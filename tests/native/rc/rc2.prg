/*
 * $Id: rc2.prg,v 1.1 2006-11-02 12:41:40 xthefull Exp $
 * Ejemplo de uso de styles
 * Porting Harbour to GTK+ power !
 * (C) 2004-05. Rafa Carmona -TheFull-
 * (C) 2004-05. Joaquim Ferrer
*/
#include "gtkapi.ch"

#define CRLF chr(9)

function Main()

  local hWnd, hScroll

/* Cambiando aspecto de la scroll bar desde un archivo definido por el
 * usuario, en este caso winrc (sin extension)
 * winrc es un archivo de texto que utilizamos sin extensi¢n para evitar
 * incompatibilidad entre win32 y otros S.O.
 */

   gtk_rc_parse( "winrc" )

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
