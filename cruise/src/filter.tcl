#
# filter.tcl 
# 

# $Id: filter.tcl,v 1.1 2002/02/09 10:20:32 klauko70 Exp $
#
#

namespace eval cruise::filter {

    # default definition for cruise token
    variable cruise_regexp {((.)*(\$(c)\$)(( )+)((.)+))}
    variable cruise_regexp_field 7


    proc extract_cruise_lines {file} {
	
	variable cruise_regexp
	variable cruise_regexp_field

	variable regexp_vars 
	variable file_hdl [open $file]
	variable line_str

	variable ::cruise::env::current_line 0
	variable ::cruise::env::line 0
	set filter_line 0
	variable ::cruise::env::filename $file
	
	set regexp_vars complete
	for {set x 1} {$x <= $cruise_regexp_field} {incr x} {
	    lappend regexp_vars part($x)
	}

	while {[eof $file_hdl] == 0} {
	    gets $file_hdl line_str
	    incr filter_line
	    
	    # reset environment variables #
	    set ::cruise::env::current_line $filter_line
	    set ::cruise::env::line [expr $filter_line + 1]
	    set ::cruise::env::column 1
	    set ::cruise::env::column_delimiter " "
	    set ::cruise::env::filename $file
	    
	    # send extracted line to the cruise interpreter #
	    if {[eval [list regexp $cruise_regexp $line_str] $regexp_vars ] == 1} {
		::cruise::interp::execute $part($cruise_regexp_field)
	    }
	}
	close $file_hdl
    }




    proc define_cruise_regexp {regexp regexp_field} {

	# not yet implemented
    }

}










































