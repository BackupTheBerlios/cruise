#
# interp.tcl 
# 

# $Id: interp.tcl,v 1.1 2002/02/09 10:20:32 klauko70 Exp $
#
#


namespace eval cruise::interp {


    variable id 0
    

    proc execute {cmd} {

	variable ::cruise::interp::id

	# preprocessing
	# not yet implemented


	# execute cruise command inside the namespace ::cruise
	incr ::cruise::interp::id
	namespace eval ::cruise $cmd
    }

}











































