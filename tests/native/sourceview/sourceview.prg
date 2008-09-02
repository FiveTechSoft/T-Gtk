/*
 * $Id: sourceview.prg,v 1.1 2008-09-02 21:15:03 riztan Exp $
 * Ejemplo de uso de GtkSourceView2
 * Porting Harbour to GTK+ power !
 * (C)2008 Rafa Carmona
*/
#include "gtkapi.ch"

function Main( cMime )

  local hWnd, hView, scrolled

  DEFAULT cMime := "text/x-c"  // Por defecto, sintaxis de C

/* Ventana */
   hWnd := gtk_window_new( GTK_WINDOW_TOPLEVEL )
   Gtk_Signal_Connect( hWnd, "delete-event", {|| Salida() } )  // Cuando se mata la aplicacion

/* Method Activate */
   gtk_window_set_title( hWnd, "Test GtkSourceView [x]Harbour" )
   gtk_window_set_position( hWnd, GTK_WIN_POS_CENTER )
   gtk_window_set_default_size( hWnd, 500, 350 )
   
   
   scrolled = gtk_scrolled_window_new(NIL, NIL )
   gtk_container_set_border_width( scrolled, 10 )
   gtk_scrolled_window_set_policy( scrolled,;
                                    GTK_POLICY_AUTOMATIC, GTK_POLICY_ALWAYS )

   gtk_container_add ( hWnd, scrolled )
   gtk_widget_show( scrolled )

   hView := HB_GTK_SOURCE_CREATE_NEW( cMime ) // gtk_source_view_new( )
   gtk_source_view_set_show_line_numbers( hView, .T. )
   gtk_container_add ( scrolled, hView)
   gtk_widget_show( hView )
   
   gtk_widget_show( hWnd )

   gtk_Main()

return NIL

//--------------------------------------------------------------------------//
//Salida controlada del programa.
Function Salida( widget )
   gtk_main_quit()
Return .F.  // Salimos y matamos la aplicacion.

