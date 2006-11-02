/*
 * $Id: winmodal.prg,v 1.1 2006-11-02 12:41:41 xthefull Exp $
 * Ejemplo de uso tener la ventana 'arriba'
 * Porting Harbour to GTK+ power !
 * (C) 2004-05. Rafa Carmona -TheFull-
 * (C) 2004-05. Joaquim Ferrer
*/
#include "gtkapi.ch"

function Main()

  local hWnd

/* Ventana */
   hWnd := gtk_window_new( GTK_WINDOW_TOPLEVEL )
   Gtk_Signal_Connect( hWnd, "delete-event", {|| Salida() } )  // Cuando se mata la aplicacion

/* Method Activate */
   gtk_window_set_title( hWnd, "Test Gdk Window for [x]Harbour" )
   gtk_window_set_position( hWnd, GTK_WIN_POS_CENTER )
   gtk_window_set_default_size( hWnd, 500, 350 )

   gtk_widget_show( hWnd )

/* Importante !. Solo se puede llamar si el widget est  totalmente
 * creado, despues de show(). Si no el "handle de ventana" GdkWindow
 * aun no existe y dara  error !!!
 * La ventana siempre estara encima...
 */
   gdk_window_set_modal_hint( hWnd, .t. )

   gtk_Main()

return NIL
//--------------------------------------------------------------------------//
//Salida controlada del programa.
Function Salida( widget )
         gtk_main_quit()
Return .F.  // Salimos y matamos la aplicacion.

