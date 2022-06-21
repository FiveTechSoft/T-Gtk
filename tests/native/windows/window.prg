/*
 * Ejemplo de creacion de una ventana
 * Porting Harbour to GTK+ power !
 * (C) 2010. Rafa Carmona -TheFull-
*/
#include "gtkapi.ch"

function Main()

  local hWnd

/* Ventana */
   hWnd := gtk_window_new( GTK_WINDOW_TOPLEVEL )
   gtk_window_set_icon( hWnd, "../../images/gnome-logo.png" )

   Gtk_Signal_Connect( hWnd, "key-press-event", {||  otra() } )  // Cuando se mata la aplicacion

   Gtk_Signal_Connect( hWnd, "delete-event", {||  gtk_main_quit(), .F. } )

/* Method Activate */
   gtk_window_set_title( hWnd, "Hello World! from T-Gtk for [x]Harbour" + Str( GTK_GET_MAJOR_VERSION()) )
   gtk_window_set_position( hWnd, GTK_WIN_POS_CENTER )
   gtk_window_set_default_size( hWnd, 500, 350 )
    
   gtk_widget_show( hWnd )

   gtk_Main()
   

return NIL

function otra()

  local hWnd

/* Ventana */
   hWnd := gtk_window_new( GTK_WINDOW_TOPLEVEL )
   gtk_window_set_icon( hWnd, "../../images/glade.png" )

  // Gtk_Signal_Connect( hWnd, "key-press-event", {||  gtk_main_quit(), .F. } )  // Cuando se mata la aplicacion

//    Gtk_Signal_Connect( hWnd, "", {||  gtk_main_quit(), .F. } )

/* Method Activate */
   gtk_window_set_title( hWnd, "Hello World! from T-Gtk for [x]Harbour" )
   gtk_window_set_position( hWnd, GTK_WIN_POS_CENTER )
   gtk_window_set_default_size( hWnd, 500, 350 )
    
   gtk_widget_show( hWnd )
   
   
return nil
