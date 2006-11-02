/*
 * $Id: utils.prg,v 1.1 2006-11-02 12:41:41 xthefull Exp $
 * Acceso a utilidades GLib
 * Porting Harbour to GLib power !
 * (C) 2005. Rafa Carmona -TheFull-
 * (C) 2005. Joaquim Ferrer
 *
 * Notas by Quim:
 * Aparte de servir de ejemplo y 'port' de algunas funciones
 * gutils de GLib, nos sirve para 'testear' la funcion [x]Harbour
 * HB_CLICK_CONNECT_BY_PARAM, que conecta la señal 'click' a un
 * widget, pasándole un parámetro de cualquier tipo [x]Harbour
 */

#include "gtkapi.ch"

static window

function exit() 
  gtk_main_quit()
return( .f. )

function main()
 local vbox, button
 
  window = gtk_window_new( GTK_WINDOW_TOPLEVEL )
  gtk_signal_connect( window, "delete-event", {||exit()} )
  gtk_window_set_title ( window, "Test GLib utils" )
  gtk_container_set_border_width( window, 10 )

  vbox = gtk_vbox_new (FALSE, 0)
  gtk_container_add ( window, vbox )
  gtk_widget_show( vbox )
  
  button := gtk_button_new_with_label( 'hb_g_find_program_in_path( "notepad.exe" )' )
  HB_CLICK_CONNECT_BY_PARAM( button, "view", 1 )
  gtk_box_pack_start( vbox, button, .F.,.T.,0 )
  
  button := gtk_button_new_with_label( "hb_g_get_current_dir()" )
  HB_CLICK_CONNECT_BY_PARAM( button, "view", 2 )
  gtk_box_pack_start( vbox, button, .F.,.T.,0 )
  
  button := gtk_button_new_with_label( 'hb_g_getenv( "PATH" )' )
  HB_CLICK_CONNECT_BY_PARAM( button, "view", 3 )
  gtk_box_pack_start( vbox, button, .F.,.T.,0 )
  
  button := gtk_button_new_with_label( "hb_g_get_home_dir()" )
  HB_CLICK_CONNECT_BY_PARAM( button, "view", 4 )
  gtk_box_pack_start( vbox, button, .F.,.T.,0 )
  
  button := gtk_button_new_with_label( "hb_g_get_tmp_dir()" )
  HB_CLICK_CONNECT_BY_PARAM( button, "view", 5 )
  gtk_box_pack_start( vbox, button, .F.,.T.,0 )
  
  button := gtk_button_new_with_label( "hb_g_get_user_name()" )
  HB_CLICK_CONNECT_BY_PARAM( button, "view", 6 )
  gtk_box_pack_start( vbox, button, .F.,.T.,0 )
  
  button := gtk_button_new_with_label( "hb_g_get_real_name()" )
  HB_CLICK_CONNECT_BY_PARAM( button, "view", 7 )
  gtk_box_pack_start( vbox, button, .F.,.T.,0 )
  
  button := gtk_button_new_with_label( "hb_g_get_prgname()" )
  HB_CLICK_CONNECT_BY_PARAM( button, "view", 8 )
  gtk_box_pack_start( vbox, button, .F.,.T.,0 )
  
  button := gtk_button_new_with_label( "hb_g_get_application_name()" )
  HB_CLICK_CONNECT_BY_PARAM( button, "view", 9 )
  gtk_box_pack_start( vbox, button, .F.,.T.,0 )
  
  button := gtk_button_new_with_label( "Salir" )
  gtk_signal_connect( button, "clicked", {|| g_signal_emit_by_name( window, "destroy" )} )
  gtk_box_pack_start( vbox, button, .F.,.T.,0 )

  gtk_widget_show_all (window)
  gtk_main()

return nil

function view( widget, param )
  do case
     case param == 1
          msgalert( hb_g_find_program_in_path( "notepad.exe" ) )
     case param == 2
          msgalert( hb_g_get_current_dir() )
     case param == 3
          msgalert( hb_g_getenv( "PATH" ) ) 
     case param == 4
          msgalert( hb_g_get_home_dir() ) 
     case param == 5
          msgalert( hb_g_get_tmp_dir() ) 
     case param == 6
          msgalert( hb_g_get_user_name() )
     case param == 7
          msgalert( hb_g_get_real_name() ) 
     case param == 8
          msgalert( hb_g_get_prgname() )          // programa en ejecucion       
     case param == 9
          msgalert( hb_g_get_application_name() ) // human-readable application name
  endcase
return( 0 )
