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

# $Id: gui.tcl,v 1.5 2002/03/15 19:12:24 klauko70 Exp $
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

	    # enable 'file->save' menu
	    set save_menu [.mbar.file index "Save"]  
	    .mbar.file entryconfigure $save_menu -state normal

	    # enable 'file->save as...' menu
	    set save_as_menu [.mbar.file index "Save as..."]  
	    .mbar.file entryconfigure $save_as_menu -state normal

	    catch [destroy .logo]

	    ### filter the cruise lines from the selected file ###
	    ::cruise::filter::extract_cruise_lines $filename

	    progress_bar stop
	}
    }




    proc file_save {} {

	::cruise::replacer::replace
    }




    proc file_preferences_save {} {

	variable root_frame
	variable ::cruise::env::backup_files_extension
	variable ::cruise::env::diff_files_extension
	variable ::cruise::env::create_backup_files
	variable ::cruise::env::create_diff_files
	variable ::cruise::env::remove_cruise_lines
	global backup_files_extension
	global diff_files_extension
	global create_backup_files
	global create_diff_files
	global remove_cruise_lines

	set w .file_preferences_save
	catch {destroy $w}
	toplevel $w
	wm title $w "Preferences - Save"
	wm resizable $w no no
	set x [expr [winfo rootx $root_frame] + 50]
	set y [expr [winfo rooty $root_frame] + 50]
	wm geometry $w "+$x+$y"
	wm transient $w .
	focus $w
	
	set backup_files_extension $::cruise::env::backup_files_extension
	set diff_files_extension $::cruise::env::diff_files_extension
	set create_backup_files $::cruise::env::create_backup_files
	set create_diff_files $::cruise::env::create_diff_files
	set remove_cruise_lines $::cruise::env::remove_cruise_lines

	# options #
	frame $w.options -relief groove -borderwidth 3
	pack $w.options -side top -fill x -anchor s -padx 5 -pady 5


	frame $w.options.backup -relief groove -borderwidth 1
	pack $w.options.backup -side top -fill x -anchor s -padx 5 -pady 5

	checkbutton $w.options.backup.cb1 -text "create backup files" \
	    -variable create_backup_files -onvalue yes -offvalue no \
	    -command {
		set w .file_preferences_save
		if {$create_backup_files} {
		    $w.options.backup.e1 configure -state normal
		} else {
		    $w.options.backup.e1 configure -state disabled
		}
	    }
	pack $w.options.backup.cb1 -side top -anchor w

	label $w.options.backup.l1 -text "backup files extension:"
	pack $w.options.backup.l1 -side left -anchor w

	entry $w.options.backup.e1 -width 5 -textvariable backup_files_extension 
	pack $w.options.backup.e1 -side right -pady 5 -padx 5


	frame $w.options.diff -relief groove -borderwidth 1
	pack $w.options.diff -side top -fill x -anchor s -padx 5 -pady 5

	checkbutton $w.options.diff.cb1 -text "create diff files" \
	    -variable create_diff_files -onvalue yes -offvalue no \
	    -command {
		set w .file_preferences_save
		if {$create_diff_files} {
		    $w.options.diff.e1 configure -state normal
		} else {
		    $w.options.diff.e1 configure -state disabled
		}
	    }	
	pack $w.options.diff.cb1 -side top -anchor w

	label $w.options.diff.l1 -text "diff files extension:"
	pack $w.options.diff.l1 -side left -anchor w

	entry $w.options.diff.e1 -width 5 -textvariable diff_files_extension
	pack $w.options.diff.e1 -side right -pady 5 -padx 5


	frame $w.options.remove -relief groove -borderwidth 1
	pack $w.options.remove -side top -fill x -anchor s -padx 5 -pady 5

	checkbutton $w.options.remove.cb1 -text "remove cruise lines" \
	    -variable remove_cruise_lines -onvalue yes -offvalue no
	pack $w.options.remove.cb1 -side top -anchor w


	# buttons #
	frame $w.buttons 
	pack $w.buttons -side bottom -fill x -anchor s

	button $w.buttons.ok -text "OK" -width 10 -command {
	    set w .file_preferences_save
	    set ::cruise::env::backup_files_extension $backup_files_extension
	    set ::cruise::env::diff_files_extension $diff_files_extension
	    set ::cruise::env::create_backup_files $create_backup_files
	    set ::cruise::env::create_diff_files $create_diff_files
	    set ::cruise::env::remove_cruise_lines $remove_cruise_lines

	    destroy $w
	}

	pack $w.buttons.ok -side left -padx 10 -pady 5

	button $w.buttons.cancel -text "Cancel" -width 10 \
	    -command "destroy $w"
	pack $w.buttons.cancel -side right -padx 10 -pady 5

	
	if {$create_backup_files} {
	    $w.options.backup.e1 configure -state normal
	} else {
	    $w.options.backup.e1 configure -state disabled
	}
	if {$create_diff_files} {
	    $w.options.diff.e1 configure -state normal
	} else {
	    $w.options.diff.e1 configure -state disabled
	}

    }





    proc file_preferences_userinterface {} {

	variable root_frame
	variable ::cruise::env::reload_button
	variable ::cruise::env::help_button
	global reload_button
	global help_button

	set w .file_preferences_userinterface
	catch {destroy $w}
	toplevel $w
	wm title $w "Preferences - User Interface"
	wm resizable $w no no
	set x [expr [winfo rootx $root_frame] + 50]
	set y [expr [winfo rooty $root_frame] + 50]
	wm geometry $w "+$x+$y"
	wm transient $w .
	focus $w
	
	set reload_button $::cruise::env::reload_button
	set help_button $::cruise::env::help_button

	# options #
	frame $w.options -relief groove -borderwidth 3
	pack $w.options -side top -fill x -anchor s -padx 5 -pady 5


	frame $w.options.reload -relief groove -borderwidth 1
	pack $w.options.reload -side top -fill x -anchor s -padx 5 -pady 5

	checkbutton $w.options.reload.cb1 -text "enable reload button" \
	    -variable reload_button -onvalue yes -offvalue no 
	pack $w.options.reload.cb1 -side top -anchor w


	frame $w.options.help -relief groove -borderwidth 1
	pack $w.options.help -side top -fill x -anchor s -padx 5 -pady 5

	checkbutton $w.options.help.cb1 -text "enable help button" \
	    -variable help_button -onvalue yes -offvalue no 
	pack $w.options.help.cb1 -side top -anchor w


	# buttons #
	frame $w.buttons 
	pack $w.buttons -side bottom -fill x -anchor s

	button $w.buttons.ok -text "OK" -width 10 -command {
	    set w .file_preferences_userinterface
	    set ::cruise::env::reload_button $reload_button
	    set ::cruise::env::help_button $help_button

	    destroy $w
	}

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
	.mbar.file add command -label "Save" -underline 0 -state disabled \
	    -command [namespace current]::file_save
	.mbar.file add command -label "Save as..." -underline 1 -state disabled \
	    -command [namespace current]::file_save_as
	.mbar.file add separator
	.mbar.file add cascade -label "Preferences" -underline 0 \
	    -menu .mbar.file.preferences 

	menu .mbar.file.preferences -tearoff 0
	.mbar.file.preferences add command -label "Save..." -underline 0 \
	    -command [namespace current]::file_preferences_save
	.mbar.file.preferences add command -label "User Interface..." -underline 0 \
	    -command [namespace current]::file_preferences_userinterface

	.mbar.file add separator
	.mbar.file add command -label "Quit" -underline 0 \
	    -command [namespace current]::cruise_exit
	
	menu .mbar.cruise -tearoff 0
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





    proc create_help_win {hlp_txt} {

	# help window for the widget-specific help button

	variable root_frame

	set w .widget_specific_help
	catch {destroy $w}
	toplevel $w
	wm title $w "Help"
	wm resizable $w no no
	set x [expr [winfo rootx $root_frame] + 50]
	set y [expr [winfo rooty $root_frame] + 50]
	wm geometry $w "+$x+$y"
	wm transient $w .
	focus $w
	
	# help text #
	frame $w.hlp_txt -relief groove -borderwidth 3
	pack $w.hlp_txt -side top -fill x -anchor s -padx 5 -pady 5
	text $w.hlp_txt.txt -yscrollcommand "$w.hlp_txt.scroll set" \
	    -setgrid true -wrap word -width 40 -height 10
	pack $w.hlp_txt.txt -expand yes -fill both -side left
	$w.hlp_txt.txt insert end $hlp_txt
	scrollbar $w.hlp_txt.scroll -command "$w.hlp_txt.txt yview"
	pack $w.hlp_txt.scroll -side right -fill both -side left
	

	# buttons #
	frame $w.buttons 
	pack $w.buttons -side bottom -fill x -anchor s

	button $w.buttons.ok -text "OK" -width 10 \
	    -command "destroy $w"
	pack $w.buttons.ok -side top -padx 10 -pady 5

    }

    
}











































