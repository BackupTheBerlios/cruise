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
# database.tcl 
# 

# $Id: database.tcl,v 1.2 2002/02/09 10:53:40 klauko70 Exp $
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











































