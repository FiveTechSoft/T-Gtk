*
 * $Id: bonobo.prg,v 1.1 2008-11-08 17:45:56 xthefull Exp $
 * Ejemplo de uso de componentes BONOBO
 * Porting Harbour to GTK+ power !
 * (C) 2008. Rafa Carmona -TheFull-
*/
#include "gtkapi.ch"

function Main( cType )

  local hWnd

   DEFAULT cType := "GNOME_CPUFreqApplet"

/* Ventana */
   hWnd := gtk_window_new( GTK_WINDOW_TOPLEVEL )
   Gtk_Signal_Connect( hWnd, "delete-event", {|| Salida() } )  // Cuando se mata la aplicacion

/* Method Activate */
   gtk_window_set_title( hWnd, "Bonobo [x]Harbour" )
   gtk_window_set_position( hWnd, GTK_WIN_POS_CENTER )
   gtk_window_set_default_size( hWnd, 50, 50 )

   bonobo_init() /*Inicializamos Bonobo*/
   bonobo_Widget( hWnd, "OAFIID:"+ cType )

   gtk_widget_show( hWnd )

   gtk_Main()

return NIL
//--------------------------------------------------------------------------//
//Salida controlada del programa.
Function Salida( widget )
gtk_main_quit()
Return .F.  // Salimos y matamos la aplicacion.

