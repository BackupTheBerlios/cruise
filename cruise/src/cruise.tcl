#
# cruise.tcl 
# 

# $Id: cruise.tcl,v 1.1 2002/02/09 10:20:32 klauko70 Exp $
#
#



namespace eval cruise {

    image create photo reload -file ../images/reload.gif


    namespace eval env {
	### definition of environment variables 
	### (accessible from the cruise script via env::varname)

	# version and machine 
	variable version           "0.01-alpha"	
	variable os                $tcl_platform(os)
	variable machine           $tcl_platform(machine)
	variable platform          $tcl_platform(platform)
	
	# gui style
	variable reload_button     yes

	# reference parameter
	variable line              0
	variable current_line      0
	variable column            0
	variable column_delimiter  " "
	variable filename          "not specified"

	# additional parameter 
	variable text              "not specified"
	variable option_list       ""
    }




    namespace eval param {
	### cruise command parameter parser

	proc -t {value} {
	    variable ::cruise::env::text
	    set ::cruise::env::text $value
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



    proc label {args} {
	
	variable env::text
	
	variable prolog
	eval $prolog

	frame $w.$f -relief groove -borderwidth 1
	pack $w.$f -expand 1 -fill both

	::label $w.$f.l -text $env::text
	pack $w.$f.l -side left
    }




    proc entry {args} {
	
	variable env::text

	variable prolog
	eval $prolog

	frame $w.$f -relief groove -borderwidth 1
	pack $w.$f -expand 1 -fill both

	::label $w.$f.l -text $env::text
	pack $w.$f.l -side left

	# create textvar in database
	set textvar [database::write $interp::id textvar ""] 

	::entry $w.$f.e -textvariable $textvar
	pack $w.$f.e -side left
	
	# fill the textvar (the entry)
	database::write $interp::id textvar [::cruise::replacer::get $interp::id]

	# install reload button # ????? maybe we can do this in an 'epilog' ?????
	if {$env::reload_button} {
	    ::button $w.$f.rb -image reload -command \
		"::cruise::database::write $interp::id textvar [::cruise::replacer::get $interp::id]" 
	    pack $w.$f.rb -side right
	}
    }




    proc menubutton {args} {
	
	variable env::text
	variable env::option_list

	variable prolog
	eval $prolog

	frame $w.$f -relief groove -borderwidth 1
	pack $w.$f -expand 1 -fill both

	::label $w.$f.l -text $env::text
	pack $w.$f.l -side left

	# create textvar in database
	set textvar [database::write $interp::id textvar ""] 

	eval ::tk_optionMenu $w.$f.mb $textvar $option_list 
	   # 'eval' is necessary to turn the option_list into it's component parts
	pack $w.$f.mb -side left
	
	# fill the textvar (the menubutton value)
	database::write $interp::id textvar [::cruise::replacer::get $interp::id]

	# install reload button # ????? maybe we can do this in an 'epilog' ?????
	if {$env::reload_button} {
	    ::button $w.$f.rb -image reload -command \
		"::cruise::database::write $interp::id textvar [::cruise::replacer::get $interp::id]" 
	    pack $w.$f.rb -side right
	}
    }




}



source filter.tcl
source replacer.tcl
source interp.tcl
source gui.tcl
source database.tcl


cruise::gui::create_main_win











































