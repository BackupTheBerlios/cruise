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
# gui.tcl 
# 

# $Id: gui.tcl,v 1.3 2002/02/23 18:37:09 klauko70 Exp $
#
#



namespace eval cruise::gui {

    # root frame for dynamically created gui
    variable root_frame  .root_frame 


    # progress status
    variable progress_status


    
    proc help_system {} {
     
	variable ::cruise::env::os
	variable ::cruise::env::machine
	
	set button [tk_messageBox -icon info -type ok -title System \
			-message "System : $::cruise::env::os  /  CPU: $::cruise::env::machine"]
    }



    proc help_version {} {

	variable ::cruise::env::version
	
	set button [tk_messageBox -icon info -type ok -title Version \
			-message "Version: $::cruise::env::version "]
    }
    


    proc help_copyright {} {

	set button [tk_messageBox -icon info -type ok -title Copyright \
			-message "Copyright by: \nWolfgang Schrempp & Klaus Konzept"]
    }



    proc cruise_exit {} {
     
	puts "Goodby ... "
	
	exit
    }



    proc file_open {} {
    
	set types {
	    {"All files"	{.*}}
	}
    
	set filename [tk_getOpenFile -filetypes $types -parent . \
			  -defaultextension .* -initialdir ./ ]
	# ????? -multiple option added in Tcl/Tk 8.4a2 ?????


	if [string compare $filename ""] {

	    progress_bar start

	    # enable 'cruise->save changes' menu
	    set save_changes_menu [.mbar.cruise index "Save changes..."]  
	    .mbar.cruise entryconfigure $save_changes_menu -state normal

	    catch [destroy .logo]

	    ### filter the cruise lines from the selected file ###
	    ::cruise::filter::extract_cruise_lines $filename

	    progress_bar stop
	}
    }




    proc save_changes {} {

	variable root_frame

	set w .save_changes
	catch {destroy $w}
	toplevel $w
	wm title $w "Save changes"
	wm resizable $w no no
	set x [expr [winfo rootx $root_frame] + 50]
	set y [expr [winfo rooty $root_frame] + 50]
	wm geometry $w "+$x+$y"
	wm transient $w .
	focus $w

	# options #
	frame $w.options -relief groove -borderwidth 3
	pack $w.options -side top -fill x -anchor s -padx 5 -pady 5
	
	checkbutton $w.options.backup -text "create backup files" 
	pack $w.options.backup -side top -anchor w

	checkbutton $w.options.diff -text "create diff files"
	pack $w.options.diff -side top -anchor w

	checkbutton $w.options.remove -text "remove cruise lines"
	pack $w.options.remove -side top -anchor w


	label $w.options.not_yet -text "not yet implemented, just hit 'OK'" -fg red
	pack $w.options.not_yet -side top -anchor w


	# buttons #
	frame $w.buttons 
	pack $w.buttons -side bottom -fill x -anchor s

	button $w.buttons.ok -text "OK" -width 10 \
	    -command "::cruise::replacer::replace; destroy $w"
	pack $w.buttons.ok -side left -padx 10 -pady 5

	button $w.buttons.cancel -text "Cancel" -width 10 \
	    -command "destroy $w"
	pack $w.buttons.cancel -side right -padx 10 -pady 5
    }



    
    proc progress_bar {start_stop} {

	variable progress_status

	set progress [.status.f10.pbar cget -width]

	if {$start_stop == "start"} {
	    set progress_status run
	    .status.f10.pbar configure -bg blue	    
	} 

	if {$start_stop == "stop"} {
	    set progress_status stop
	    .status.f10.pbar configure -width 0	    
	    .status.f10.pbar configure -bg grey	    
	} 

	if {$progress_status == "run"} {

	    incr progress 5
	    
	    if {$progress > 100} {
		set progress 0
	    }
	    
	    .status.f10.pbar configure -width $progress
	    after 200 "::cruise::gui::progress_bar -"
	} 
	
    }
    



    proc create_main_win {} {
	
	variable root_frame

	menu .mbar -tearoff 0
 
	.mbar add cascade -label "File" -underline 0 -menu .mbar.file
	.mbar add cascade -label "Cruise" -underline 0 -menu .mbar.cruise
	.mbar add cascade -label "Help" -underline 0 -menu .mbar.help
	
	menu .mbar.file -tearoff 0
	.mbar.file add command -label "Open..." -underline 0 \
	    -command [namespace current]::file_open
	.mbar.file add separator
	.mbar.file add command -label "Quit" -underline 0 \
	    -command [namespace current]::cruise_exit
	
	menu .mbar.cruise -tearoff 0
	.mbar.cruise add command -label "Save changes..." -underline 0 \
	    -state disabled -command [namespace current]::save_changes
	.mbar.cruise add separator	
	.mbar.cruise add command -label "Remove cruise lines..." -underline 0 \
	    -command "not_implemented"
	
	menu .mbar.help -tearoff 0
	.mbar.help add command -label "System..." -underline 0 \
	    -command [namespace current]::help_system
	.mbar.help add command -label "Version..." -underline 0 \
	    -command [namespace current]::help_version
	.mbar.help add command -label "Copyright..." -underline 0 \
	    -command [namespace current]::help_copyright

	. configure -menu .mbar
	
	
	# logo
	frame .logo -relief groove -borderwidth 3
	pack .logo -side top -fill x -anchor n 
	
	image create photo logo -file ../images/logo.gif
	label .logo.img -image logo
	pack .logo.img

	# root frame for dynamically created gui
	frame $root_frame -relief groove -borderwidth 3
	pack $root_frame -side top -expand 1 -fill both -anchor n

	# status bar
	frame .status -relief flat
	pack .status -side top -fill x -anchor s

	frame .status.f1 -relief sunken -borderwidth 1
	pack .status.f1 -side left

	label .status.f1.l1 -text "Status: "
	pack .status.f1.l1

	frame .status.f2 -relief sunken -borderwidth 1
	pack .status.f2 -side left

	label .status.f2.l1 -text "             "
	pack .status.f2.l1

	frame .status.f10 -relief sunken -borderwidth 1 -width 100 -height 20 
	pack .status.f10 -side right
	pack propagate .status.f10 no

	frame .status.f10.pbar -relief flat -bg grey -width 0 -height 20
	pack .status.f10.pbar -side left

    }

}











































