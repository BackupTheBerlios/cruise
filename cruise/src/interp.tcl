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

# $Id: interp.tcl,v 1.2 2002/02/09 10:55:10 klauko70 Exp $
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











































