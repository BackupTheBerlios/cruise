#
# gui.tcl 
# 

# $Id: gui.tcl,v 1.1 2002/02/09 10:20:32 klauko70 Exp $
#
#



namespace eval cruise::gui {

    # root frame for dynamically created gui
    variable root_frame  .root_frame 


    
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

	    catch [destroy .logo]

	    ### filter the cruise lines from the selected file ###
	    ::cruise::filter::extract_cruise_lines $filename
	}
    }



    proc file_save_as {} {
    
	set types {
	    {"All files"	{.*}}
	}
    

	set button [tk_messageBox -icon info -type ok -title "not yet..." \
			-message "not yet implemented :-("]


	# set filename [tk_getSaveFile -filetypes $types -parent . \
# 			  -defaultextension .* -initialdir ./ ]

# 	if [string compare $filename ""] {
	    
# 	    # ????? generate output file and save it ?????
	    
# 	}
    }

    

    proc create_main_win {} {
	
	variable root_frame

	menu .mbar -tearoff 0
 
	.mbar add cascade -label "File" -underline 0 -menu .mbar.file
	.mbar add cascade -label "Help" -underline 0 -menu .mbar.help
	
	menu .mbar.file -tearoff 0
	.mbar.file add command -label "Open..." -underline 0 \
	    -command [namespace current]::file_open
	.mbar.file add separator
	.mbar.file add command -label "Save as..." -underline 0 \
	    -command [namespace current]::file_save_as
	.mbar.file add separator
	.mbar.file add command -label "Quit" -underline 0 \
	    -command [namespace current]::cruise_exit
	
	menu .mbar.options -tearoff 0
	
	menu .mbar.help -tearoff 0
	.mbar.help add command -label "System..." -underline 0 \
	    -command [namespace current]::help_system
	.mbar.help add command -label "Version..." -underline 0 \
	    -command [namespace current]::help_version
	.mbar.help add command -label "Copyright..." -underline 0 \
	    -command [namespace current]::help_copyright

	. configure -menu .mbar
	
	
	frame .logo -relief groove -borderwidth 3
	pack .logo -side top -fill x -anchor n 
	
	image create photo logo -file ../images/logo.gif
	label .logo.img -image logo
	pack .logo.img

	frame $root_frame -relief groove -borderwidth 3
	pack $root_frame -side top -expand 1 -fill both -anchor n

    }

}











































