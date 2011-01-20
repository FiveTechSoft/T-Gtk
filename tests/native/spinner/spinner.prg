/* Ejemlo Spinner */

#include "gtkapi.ch"
#define CRLF Hb_OsnewLine()

function exit( widget ) ;  gtk_main_quit()  ; return .f. 

function main()

 local window, vbox
 local button1, button2
 Local spinner
 
  window = gtk_window_new( GTK_WINDOW_TOPLEVEL )
  gtk_widget_set_usize( window, 200, 200 )
  gtk_signal_connect( window, "destroy", {|| gtk_main_quit() } )
  

  gtk_window_set_title ( window, "Spinners" )
  gtk_container_set_border_width( window, 10 )
  
  vbox = gtk_vbox_new (.F., 10)
  gtk_container_add ( window, vbox )
  gtk_widget_show( vbox )
  
  button1 := gtk_button_new_with_label( "Start" )
  
  gtk_signal_connect( button1, "clicked", ;
                               { |widget| gtk_spinner_start (spinner) } )

  gtk_box_pack_start( vbox, button1, .F.,.T.,0 )
  gtk_widget_show( button1 )
  
  button2 := gtk_button_new_with_label( "Stop" )
  gtk_signal_connect( button2, "clicked", ;
                               { |widget| gtk_spinner_stop (spinner) } )

  gtk_box_pack_start( vbox, button2, .F.,.T.,0 )
  gtk_widget_show( button2 )
  
  spinner := gtk_spinner_new ()
  gtk_spinner_start ( spinner )
  gtk_widget_show( spinner )
  gtk_box_pack_start( vbox, spinner, .t.,.T.,0 )
  
  gtk_widget_show_all (window)
  gtk_main()
return nil