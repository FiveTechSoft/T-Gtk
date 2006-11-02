/*
 * $Id: rc1.prg,v 1.1 2006-11-02 12:41:40 xthefull Exp $
 * Ejemplo de uso de styles
 * Porting Harbour to GTK+ power !
 * (C) 2004-05. Rafa Carmona -TheFull-
 * (C) 2004-05. Joaquim Ferrer
*/
#include "gtkapi.ch"

#define CRLF chr(9)

function Main()

  local hWnd, hScroll

/* Cambiando aspecto de la scroll bar desde una cadena
 * Ojo : Utilizar comillas simples (') ya que la cadena consta de cadenas
 * dobles (") y de corchetes ([]). Cada linea termina con un retorno de carro
 * Primero se define el nombre del style que queremos y entre { } van todos
 * los tags, luego se define que class utilizar  este style.
 */

   gtk_rc_parse_string( 'style "winscrollbar"{' + CRLF + ;
                        'bg[PRELIGHT] = "#4b6983"' + CRLF + ;
                        'fg[PRELIGHT] = "#ffffff"' + CRLF + ;
                        'bg[NORMAL]   = "#eee1b3"' + CRLF + ;
                        'GtkRange::slider_width = 18' + CRLF +;
                        'GtkRange::stepper_size = 18' + CRLF + ;
                        '}'                           + CRLF + ;
                        'class "GtkScrollbar" style : gtk "winscrollbar"' )

   hWnd := gtk_window_new( GTK_WINDOW_TOPLEVEL )
   Gtk_Signal_Connect( hWnd, "delete-event",{|| Salida()} )  // Cuando se mata la aplicacion

   hScroll = gtk_scrolled_window_new()
   gtk_widget_show ( hScroll )
   gtk_container_add( hWnd, hScroll )

   gtk_window_set_title( hWnd, "Test RC style Win32 Gtk for Harbour" )
   gtk_window_set_position( hWnd, GTK_WIN_POS_CENTER )
   gtk_window_set_default_size( hWnd, 500, 350 )

   gtk_widget_show_all( hWnd )

   gtk_Main()

return NIL
//--------------------------------------------------------------------------//
//Salida controlada del programa.
Function Salida( )
    gtk_main_quit()
Return .F.  // Salimos y matamos la aplicacion.

