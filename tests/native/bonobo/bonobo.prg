/*
 * $Id: bonobo.prg,v 1.1 2008-11-08 17:45:56 xthefull Exp $
 * Ejemplo de uso de componentes BONOBO
 * Porting Harbour to GTK+ power !
 * (C) 2008. Rafa Carmona -TheFull-

   Para saber que servidores tenemos disponibles, preguntamos el prefijo de instalacion
   pkg-config --variable=prefix bonobo-activation-2.0
   Si nos devuelve por ejemplo /usr, tenemos en la ruta;
   /usr/lib/bonobo/servers los ficheros acabados en .server
   
   http://www.calcifer.org/documentos/librognome/bonobo-activation-server-files.html

   Ejemplos: ./test GNOME_CPUFreqApplet   
   GNOME_AccessxStatusApplet
   GNOME_BrightnessApplet   
   GNOME_MixerApplet

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
   gtk_window_set_default_size( hWnd, 150, 150 )

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

