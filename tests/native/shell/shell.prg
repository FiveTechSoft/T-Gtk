/*
 * $Id: shell.prg,v 1.1 2006-11-02 12:41:40 xthefull Exp $
 * Ejemplo de uso de llamadas externas.
 * Porting Harbour to GTK+ power !
 * (C) 2004-05. Rafa Carmona -TheFull-
 * (C) 2004-05. Joaquim Ferrer
 *
 */

#include "gtkapi.ch"

func exit( ) ;  gtk_main_quit() ; return( .f. )

function main()

 local window, vbox, button
 
  
  window = gtk_window_new( GTK_WINDOW_TOPLEVEL )
  gtk_signal_connect( window, "destroy", {|| exit() })
  
  gtk_window_set_title ( window, "Test winexec & shellexec" )
  gtk_container_set_border_width( window, 10 )

  vbox = gtk_vbox_new (FALSE, 0)
  gtk_container_add ( window, vbox )
  gtk_widget_show( vbox )

  button := gtk_button_new_with_label( "Ejecuta [ notepad.exe ]" )
  gtk_signal_connect( button, "clicked", {|| run_winexec()} )
  gtk_box_pack_start( vbox, button, .F.,.T.,0 )
  gtk_widget_show( button )
  
  button := gtk_button_new_with_label( "Ejecuta [ iexplore.exe ]" )
  gtk_signal_connect( button, "clicked", {|| run_shellexec() } )
  gtk_box_pack_start( vbox, button, .F.,.T.,0 )
  gtk_widget_show( button )
 
  button := gtk_button_new_with_label( "WINRUN Ejecuta [ notepad.exe ]" )
  gtk_signal_connect( button, "clicked", {||run_winrun() } )
  gtk_box_pack_start( vbox, button, .F.,.T.,0 )
  gtk_widget_show( button )

  button := gtk_button_new_with_label( "Salir" )
  gtk_signal_connect( button, "clicked", {|| g_signal_emit_by_name( window, "destroy" )} )
  gtk_box_pack_start( vbox, button, .F.,.T.,0 )
  gtk_widget_show( button )
  gtk_widget_show_all (window)
  gtk_main()

return nil

func run_winexec()
 /* Actua sobre el path actual c:\winxx\... */
  if "WINDOWS" $  Upper( Os()  )
     winexec( "notepad.exe" )
  else
     winexec( "gedit" )
  endif

return( 0 )

func run_winrun()
  if "WINDOWS" $  Upper( Os()  )
      winrun("notepad.exe")
  else
     winrun( "gedit" )
  endif

return( 0 )

func run_shellexec()
 /* Actua pasando directorio de la aplicacion */
  if "WINDOWS" $  Upper( Os()  )
  shellexec( 'C:/Archivos de programa/Internet Explorer/', ;
             "iexplore.exe", "www.google.es" )
  else
  shellexec( '/usr/bin/', ;
             "mozilla", "www.google.es" )
  endif
return( 0 )
