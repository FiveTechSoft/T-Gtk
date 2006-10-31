/*
 * $Id: image.prg,v 1.1 2006-10-31 11:43:59 xthefull Exp $
 * Ejemplo de uso de pixbuf y colocacion de un icono a la ventana.
 * Porting Harbour to GTK+ power !
 * (C) 2004-05. Rafa Carmona -TheFull-
 * (C) 2004-05. Joaquim Ferrer
*/
#include "gtkapi.ch"

function main()

  local hWnd, hBox, hIcon, hImage

/* Ventana */
   hWnd  := gtk_window_new( GTK_WINDOW_TOPLEVEL )

/* Aquí conectamos el evento "destroy" al manejador de la señal */
   Gtk_Signal_Connect( hWnd, "destroy", {||gtk_main_quit() } )  // Cuando se mata la aplicacion

/* Icono para barra de titulo de la ventana */
   hIcon := gdk_pixbuf_new_from_file( "../../images/glade.png" )

   if hIcon != 0
      gtk_window_set_icon( hWnd, hIcon )
      gdk_pixbuf_unref( hIcon )
   endif

/* Caja de 'empaquetamiento'*/
   hBox := gtk_hbox_new( .f., 0 )
   gtk_container_add( hWnd, hBox )
   gtk_widget_show( hBox )

/* Imagen 'via' icono */
   hIcon := gdk_pixbuf_new_from_file( "../../images/rafa.jpg" )

   if hIcon != 0
      hImage = gtk_image_new_from_pixbuf( hIcon )
      gtk_container_add( hBox, hImage )
      gdk_pixbuf_unref( hIcon )
   endif

/* Imagen de disco */
   hImage := gtk_image_new_from_file( "../../images/glogo.png" )
   gtk_container_add( hBox, hImage )

/* Imagen del almacen 'stock' */
   hImage := gtk_image_new_from_stock( GTK_STOCK_DIALOG_AUTHENTICATION,;
                                       GTK_ICON_SIZE_DIALOG )
   gtk_container_add( hBox, hImage )

/* Method Activate */
   gtk_window_set_title( hWnd, "Test Icon & Images png,jpg T-Gtk for [x]Harbour" )
   gtk_window_set_position( hWnd, GTK_WIN_POS_CENTER )
   gtk_window_set_default_size( hWnd, 300, 200 )

   gtk_widget_show_all( hWnd )

   gtk_Main()

return NIL
