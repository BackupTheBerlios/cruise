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

# $Id: replacer.tcl,v 1.2 2002/02/09 10:55:32 klauko70 Exp $
#
#

namespace eval cruise::replacer {


    proc get {id} {

	# read the appropriate environment variables from database #
	set line             [::cruise::database::read $id line]
	set current_line     [::cruise::database::read $id current_line]
	set column           [::cruise::database::read $id column]
	set column_delimiter [::cruise::database::read $id column_delimiter]
	set filename         [::cruise::database::read $id filename]


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

	if {[string index $column 0] == "#"} {
	    ### field column reference ###
	    set field_num [string trimleft $column "#"] 
	    set str_list [split $line_str $column_delimiter]
	    set retval [lindex $str_list [expr $field_num - 1]]
	} else {
	    ### absolute column reference ###
	    set tail [string range $line_str [expr $column - 1] end] 
	    set str_list [split $tail $column_delimiter]
	    set retval [lindex $str_list 0]
	}
	
	return $retval
    }






    proc put {} {


    }


}










































