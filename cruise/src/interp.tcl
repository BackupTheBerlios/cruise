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
# interp.tcl 
# 

# $Id: interp.tcl,v 1.3 2002/03/10 18:57:51 klauko70 Exp $
#
#


namespace eval cruise::interp {


    variable id 0

    # list of preprocessor commands
    variable preproc_cmds [list MARK]



    proc preproc {cmd} {

	variable ::cruise::interp::id
	variable preproc_cmds

	# preprocessing
	if {[lsearch -exact $preproc_cmds [lindex [split $cmd] 0]] != -1} {
	    incr ::cruise::interp::id
	    namespace eval ::cruise $cmd
	}
    }



    proc execute {cmd} {

	variable ::cruise::interp::id
	variable preproc_cmds

	# execute cruise command inside the namespace ::cruise
	if {[lsearch -exact $preproc_cmds [lindex [split $cmd] 0]] == -1} {
	    incr ::cruise::interp::id
	    namespace eval ::cruise $cmd
	}
    }

}











































