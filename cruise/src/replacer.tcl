#########################################################################
# Copyright (C) 2002 Wolfgang Schrempp & Klaus Konzept                  # 
#                                                                       #
# This program is free software; you can redistribute it and/or modify  #
# it under the terms of the GNU General Public License as published by  #
# the Free Software Foundation; either version 2, or (at your option)   #
# any later version.                                                    #
#                                                                       #
# This program is distributed in the hope that it will be useful,       #
# but WITHOUT ANY WARRANTY; without even the implied warranty of        #
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the         #
# GNU General Public License for more details.                          #
#                                                                       #
# You should have received a copy of the GNU General Public License     #
# along with this program.                                              #
#########################################################################

#
# replacer.tcl 
# 

# $Id: replacer.tcl,v 1.5 2002/03/15 19:13:27 klauko70 Exp $
#
#

namespace eval cruise::replacer {


    proc replace {} {

	set backup_list "" 

	for {set id 1} {$id <= $::cruise::interp::id} {incr id} {

	    # check if replacement is needed #
	    if {[::cruise::database::read $id need_replacement]} {
		
		# check if a backup for filename has just been created 
		set filename [::cruise::database::read $id filename]
		if { [lsearch $backup_list $filename] == -1 } {
		    # make backup (if required)
		    if {$::cruise::env::create_backup_files} {
			file copy -force $filename \
			    $filename$::cruise::env::backup_files_extension
			lappend backup_list $filename
		    }
		}

		::cruise::replacer::put $id
	    }
	}
	    

    }






    proc get {id} {

	# read the appropriate environment variables from database #
	set line             [::cruise::database::read $id line]
	set current_line     [::cruise::database::read $id current_line]
	set column           [::cruise::database::read $id column]
	set column_delimiter [::cruise::database::read $id column_delimiter]
	set filename         [::cruise::database::read $id filename]

	set absolute_line [eval_line $line $current_line]

	set file_hdl [open $filename]
	set line_str ""
	set read_line 0

	while {[eof $file_hdl] == 0} {
	    gets $file_hdl line_str
	    incr read_line

	    if {$read_line == $absolute_line} {
		break
	    }
	}
	close $file_hdl

	return [lindex [eval_column $column $column_delimiter $line_str] 1]
    }







    proc put {id} {

	# read the appropriate environment variables from database #
	set line             [::cruise::database::read $id line]
	set current_line     [::cruise::database::read $id current_line]
	set column           [::cruise::database::read $id column]
	set column_delimiter [::cruise::database::read $id column_delimiter]
	set filename         [::cruise::database::read $id filename]

	set absolute_line [eval_line $line $current_line]

	### read in the source file ###
	set file_hdl [open $filename]
	set line_str ""
	set read_line 0

	while {[eof $file_hdl] == 0} {
	    gets $file_hdl line_str
	    incr read_line

	    if {$read_line == $absolute_line} {
		set replace_line $line_str
		break
	    }

	    lappend pre_lines $line_str
	}


	while {[eof $file_hdl] == 0} {
	    gets $file_hdl line_str
	    incr read_line

	    lappend post_lines $line_str
	}

	close $file_hdl



	### write the destination file ###
	set file_hdl [open $filename w]

	foreach line_str $pre_lines {
	    puts $file_hdl $line_str
	}

	set replace_line_list [eval_column $column $column_delimiter $replace_line]
	set head [lindex $replace_line_list 0]
	set tail [lindex $replace_line_list 2]
	set new_text [::cruise::database::read $id textvar]
	
	puts $file_hdl $head$new_text$tail

	foreach line_str $post_lines {
	    puts $file_hdl $line_str
	}
	
	close $file_hdl
    }





    proc eval_line {line current_line} {

	if {[string index $line 0] == "+"} {
	    ### relative (positive) line reference ###
	    set diff [string trimleft $line "+"] 
	    set absolute_line [expr $current_line + $diff]
	} elseif {[string index $line 0] == "-"} {
	    ### relative (negative) line reference ###
	    set diff [string trimleft $line "-"] 
	    set absolute_line [expr $current_line - $diff]
	} else {
	    ### absolute line reference ###
	    set absolute_line $line
	}

	return $absolute_line
    }





    proc eval_column {column delimiter line_str} {

	if {[string index $column 0] == "#"} {
	    ### field column reference ###
	    set field [string trimleft $column "#"] 

	    set splited_list [split $line_str $delimiter]
	    set head_list [lrange $splited_list 0 [expr $field - 2]]
	    set head [join $head_list $delimiter]$delimiter
	    set match [lrange $splited_list [expr $field - 1] [expr $field - 1]]
	    # ????? set match [join $match]
	    set tail_list [lrange $splited_list $field end]
	    set tail $delimiter[join $tail_list $delimiter]

	} else {
	    ### absolute column reference ###
	    set head [string range $line_str 0 [expr $column - 2]]
	    set match_and_tail [string range $line_str [expr $column - 1] end]
	    set match_end [expr [string first $delimiter $match_and_tail] - 1]
	    set match [string range $match_and_tail 0 $match_end]
	    set tail [string range $match_and_tail [expr $match_end + 1] end]
	}

	return [list $head $match $tail]
    }



}










































