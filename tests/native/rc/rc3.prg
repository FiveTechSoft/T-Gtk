/*
 * $Id: rc3.prg,v 1.1 2006-11-02 12:41:40 xthefull Exp $
 * Ejemplo de uso de styles
 * Porting Harbour to GTK+ power !
 * (C) 2004-05. Rafa Carmona -TheFull-
 * (C) 2004-05. Joaquim Ferrer
*/
#include "gtkapi.ch"

#define CRLF chr(9)

function Main()

  local hWnd, hScroll, cPathThemes

/*
 * Devolviendo el path donde estan instalados los temas en la instalacion GTK
 */
   cPathThemes := gtk_rc_get_theme_dir()

/*
 * Cambiando aspecto de la aplicacion desde un archivo definido en themes
 */
   cPathThemes += "/Crux/gtk-2.0/gtkrc"

   gtk_rc_parse( cPathThemes )

   hWnd := gtk_window_new( GTK_WINDOW_TOPLEVEL )
   Gtk_Signal_Connect( hWnd, "delete-event",{|| Salida()} )  // Cuando se mata la aplicacion

   hScroll = gtk_scrolled_window_new()
   gtk_widget_show ( hScroll )
   gtk_container_add( hWnd, hScroll )

   gtk_window_set_title( hWnd, "Test RC Gtk for Harbour" )
   gtk_window_set_position( hWnd, GTK_WIN_POS_CENTER )
   gtk_window_set_default_size( hWnd, 500, 350 )

   gtk_widget_show_all( hWnd )

   gtk_Main()

return NIL
//--------------------------------------------------------------------------//
//Salida controlada del programa.
Function Salida( widget )
         gtk_main_quit()
Return .F.  // Salimos y matamos la aplicacion.

