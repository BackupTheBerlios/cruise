#
# database.tcl 
# 

# $Id: database.tcl,v 1.1 2002/02/09 10:20:32 klauko70 Exp $
#
#


namespace eval cruise::database {


    proc write {id var value} {
	
	variable ::cruise::database::$id.$var $value
	
	return "::cruise::database::$id.$var"
    }


    proc read {id var} {
	
	variable ::cruise::database::$id.$var
	
	return [set ::cruise::database::$id.$var]
    }


}











































