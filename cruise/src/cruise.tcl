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
# cruise.tcl 
# 

# $Id: cruise.tcl,v 1.7 2002/03/28 23:08:50 wolli Exp $
#
#



namespace eval cruise {

    image create photo reload -file ../images/reload.gif
    image create photo help -file ../images/help.gif


    namespace eval env {
	### definition of environment variables 
	### (accessible from the cruise script via env::varname)

	# version and machine 
	variable version           "0.01-alpha"	
	variable os                $tcl_platform(os)
	variable machine           $tcl_platform(machine)
	variable platform          $tcl_platform(platform)
	
	# gui style (global)
	variable status_line       yes ;# ????? not yet implemented ?????
	variable menu_bar          yes ;# ????? not yet implemented ?????
	
	# gui style (widget specific)
	variable reload_button     yes
	variable help_button       yes

	# save options
	variable create_backup_files     yes
	variable backup_files_extension  .bak
	variable create_diff_files       no   ;# ????? not yet implemented ?????
	variable diff_files_extension    .dif ;# ????? not yet implemented ?????
	variable remove_cruise_lines     no   ;# ????? not yet implemented ?????

	# reference parameter
	variable line              0
	variable current_line      0
	variable column            0
	variable column_delimiter  " "
	variable filename          "not specified"

	# additional parameter 
	variable text              "not specified"
	variable option_list       ""
	variable help              ""
	variable command           ""
    }




    namespace eval param {
	### cruise command parameter parser

	proc -id {value} {
	    variable ::cruise::interp::id
	    variable ::cruise::env::$value
	    set ::cruise::env::$value $::cruise::interp::id
	}

	proc -m {value} {
	    set ::cruise::env::line \
		[::cruise::database::read [set ::cruise::env::$value] line]
	    set ::cruise::env::current_line \
		[::cruise::database::read [set ::cruise::env::$value] current_line]
	    set ::cruise::env::column \
		[::cruise::database::read [set ::cruise::env::$value] column]
	    set ::cruise::env::column_delimiter \
		[::cruise::database::read [set ::cruise::env::$value] column_delimiter]
	    set ::cruise::env::filename \
		[::cruise::database::read [set ::cruise::env::$value] filename]
	}

	proc -t {value} {
	    variable ::cruise::env::text
	    set ::cruise::env::text $value
	}

	proc -h {value} {
	    variable ::cruise::env::help
	    set ::cruise::env::help $value
	}

	proc -cmd {value} {
	    variable ::cruise::env::command
	    set ::cruise::env::command $value
	}

	proc -c {value} {
	    variable ::cruise::env::column
	    set ::cruise::env::column $value
	}

	proc -cd {value} {
	    variable ::cruise::env::column_delimiter
	    set ::cruise::env::column_delimiter $value
	}

	proc -l {value} {
	    variable ::cruise::env::line
	    set ::cruise::env::line $value
	}

	proc -ol {value} {
	    variable ::cruise::env::option_list
	    set ::cruise::env::option_list $value
	}


	proc parse {param_list} {
	    
	    set num_args [llength $param_list]
	    
	    for {set i 0} {$i < $num_args} {incr i 2} {
		set param [lindex $param_list $i]
		set value [lindex $param_list [expr $i + 1]]

		# ????? own error handling needed ?????
		eval ::cruise::param::$param [list $value] ;# 'list' joins parameter 
	    }
	}


    } ;# end: namespace 'eval'





    #####################################
    ### definition of cruise commands ###
    #####################################

    variable prolog {
	variable ::cruise::gui::root_frame
	set w $::cruise::gui::root_frame
	
	variable ::cruise::interp::id
	set f $::cruise::interp::id

	param::parse $args

	# store appropriate environment variables in database # 
	database::write  $interp::id  window_path       $w.$f
	database::write  $interp::id  line              $env::line
	database::write  $interp::id  current_line      $env::current_line
	database::write  $interp::id  column            $env::column
	database::write  $interp::id  column_delimiter  $env::column_delimiter
	database::write  $interp::id  filename          $env::filename
    }




    variable epilog {
	# install help button
	if {$env::help_button} {
	    if {$env::help == ""} {
		::button $w.$f.hb -image help -state disabled -command \
		    "::cruise::gui::create_help_win {$::cruise::env::help}"
	    } else {
		::button $w.$f.hb -image help -state normal -command \
		    "::cruise::gui::create_help_win {$::cruise::env::help}"
	    }
	    pack $w.$f.hb -side right 
	} 

	# install reload button 
	if {$env::reload_button} {
	    ::button $w.$f.rb -image reload -command \
		"::cruise::database::write $interp::id textvar [::cruise::replacer::get $interp::id]" 
	    pack $w.$f.rb -side right
	} 
    }





    proc MARK {args} {
	
	variable prolog
	eval $prolog

	database::write $interp::id need_replacement no
    }




    proc label {args} {
	
	variable env::text
	
	variable prolog
	eval $prolog

	database::write $interp::id need_replacement no


	frame $w.$f -relief groove -borderwidth 1
	pack $w.$f -expand 1 -fill both

	::label $w.$f.l -text $env::text
	pack $w.$f.l -side left
    }




    proc entry {args} {
	
	variable env::text

	variable prolog
	variable epilog
	eval $prolog

	database::write $interp::id need_replacement yes


	frame $w.$f -relief groove -borderwidth 1
	pack $w.$f -expand 1 -fill both

	::label $w.$f.l -text $env::text
	pack $w.$f.l -side left

	# create textvar in database
	set textvar [database::write $interp::id textvar ""] 

	::entry $w.$f.e -textvariable $textvar
	pack $w.$f.e -side left -expand yes -anchor e -padx 10
	
	# fill the textvar (the entry)
	database::write $interp::id textvar [::cruise::replacer::get $interp::id]

	eval $epilog
    }




    proc menubutton {args} {
	
	variable env::text
	variable env::option_list

	variable prolog
	variable epilog
	eval $prolog

	database::write $interp::id need_replacement yes


	frame $w.$f -relief groove -borderwidth 1
	pack $w.$f -expand 1 -fill both

	::label $w.$f.l -text $env::text
	pack $w.$f.l -side left

	# create textvar in database
	set textvar [database::write $interp::id textvar ""] 

	eval ::tk_optionMenu $w.$f.mb $textvar $option_list 
	   # 'eval' is necessary to turn the option_list into it's component parts
	pack $w.$f.mb -side left -expand yes -anchor e -padx 10
	
	# fill the textvar (the menubutton value)
	database::write $interp::id textvar [::cruise::replacer::get $interp::id]

	eval $epilog
    }




    proc button {args} {
	
	variable env::text
	variable env::command
	
	variable prolog
	eval $prolog

	database::write $interp::id need_replacement no


	frame $w.$f -relief groove -borderwidth 1
	pack $w.$f -expand 1 -fill both

	::button $w.$f.l -text $env::text -command "exec $env::command"
	pack $w.$f.l -side left
    }



}



source filter.tcl
source replacer.tcl
source interp.tcl
source gui.tcl
source database.tcl


cruise::gui::create_main_win

if {$argc != 0} {
    cruise::gui::file_open $argv
}










































