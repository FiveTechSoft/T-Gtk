/*
 * $Id: demotable.prg,v 1.1 2006-10-31 11:43:58 xthefull Exp $
 * Ejemplo de uso paneles y tablas nativamente
 * Porting Harbour to GTK+ power !
 * (C) 2004-05. Rafa Carmona -TheFull-
 * (C) 2004-05. Joaquim Ferrer
*/
#include "gclass.ch"

Function Main()
         Local button, table, vPaned, image,  entry_file, draw
         Local cValue := "Esto es un texto por defecto"
         Local hButton1, hButton2, hButton3, Window, vBox
         Local oFont

         Window := Gtk_Window_New( GTK_WINDOW_TOPLEVEL )

         Gtk_window_set_title( Window, "GUI T-Gtk Ejemplo de Paneles y Tablas" )
         Gtk_window_set_position( Window, GTK_WIN_POS_CENTER )
         gtk_signal_connect( window, "destroy", {|| gtk_main_quit(), .F. } )

         vPaned := gtk_hpaned_new()
         gtk_container_add (Window, vPaned)

         table = gtk_table_new (2, 2, TRUE )
         gtk_paned_add1( vpaned, table )

         oFont := GFont():New( "Tahoma 18" )

         hButton1 := Gtk_button_new_with_label( "Boton 1" )

         gtk_widget_modify_font( gtk_bin_get_child( hButton1 ) , oFont:pFont )
         gtk_table_attach_defaults( table, hButton1, 0, 1, 0, 1)
         gtk_widget_show( hButton1 )

         hButton2 := Gtk_button_new_with_label( "Boton 2" )
         gtk_table_attach_defaults( table, hButton2, 1, 2, 0, 1)
         gtk_widget_show( hButton2 )

         hButton3 := Gtk_button_new_with_label( "Boton 3" )
         __GSTYLE( "orange"  ,  hButton3 , BGCOLOR , STATE_NORMAL)   // Cuando esta normal, fondo azul
         __GSTYLE( "yellow"  ,  hButton3 , BGCOLOR , STATE_PRELIGHT)   // Cuando esta normal, fondo azul
         __GSTYLE( "red"     ,  hButton3 , FGCOLOR , STATE_NORMAL)   // Cuando esta normal, fondo azul

         // Color del Hijo contenido
         __GSTYLE( "blue"  , gtk_bin_get_child( hButton3 ), FGCOLOR , STATE_NORMAL)   // Cuando esta normal, fondo azul
         __GSTYLE( "red"   , gtk_bin_get_child( hButton3 ), BGCOLOR , STATE_PRELIGHT)   // Cuando esta seleccionado
          gtk_widget_modify_font( gtk_bin_get_child( hButton3 ) , oFont:pFont )
         SysRefresh()

         gtk_table_attach_defaults (table, hButton3, 0, 2, 1, 2)
         gtk_widget_show( hButton3 )

         // Y este en el otro lado
         vBox := gtk_vbox_new()
         gtk_widget_show (vbox)
         gtk_paned_pack2( vpaned, vBox , .F.,.F.)

         entry_file = gtk_entry_new ()
         gtk_widget_show (entry_file)
         gtk_entry_set_text( entry_file, cValue )
         Gtk_box_pack_start( vbox, entry_file, .F.,.T.,0 )

         button = gtk_button_new_from_stock ( "gtk-dialog-error" )
         gtk_widget_show (button)
         Gtk_box_pack_start( vbox, button, .F.,.T.,0 )

         // Botton de seleccion de color
         button = gtk_color_button_new( )
         gtk_color_button_set_title( button, "Titulo de ColorButton" )
         gtk_color_button_set_color( button, "yellow")
         gtk_color_button_set_use_alpha( button, .T. )

         gtk_widget_show (button)
         Gtk_box_pack_start( vbox, button, .F.,.T.,0 )

         draw = gtk_drawing_area_new()
         gtk_widget_set_size_request( draw, 200, 200 )
         gtk_widget_show (draw)
         Gtk_Signal_Connect( draw, "expose_event", {|w,e| dibuja( w,e )} )  // Procesa mensajes de dibujo
         Gtk_box_pack_start( vbox, draw, .T., .F.,10 )

         image = gtk_image_new()
         gtk_image_set_from_file( image,"../../images/Anieyes.gif" )
         Gtk_box_pack_start( vbox, image ,.t.,.t.,0 )
         gtk_widget_show (image)

         image = gtk_image_new()
         gtk_image_set_from_file( image,"../../images/raptor.jpg" )
         Gtk_box_pack_start( vbox, image ,.t.,.t.,0 )
         gtk_widget_show (image)

         gtk_widget_show (table)
         gtk_widget_show (vpaned)


         gtk_widget_show ( WIndow )

         gtk_main ()

				 oFont:End() // Liberamos la fuente

return NIL


FUNCTION DIBUJA( Widget )
	 Local gc
	 Local colormap
	 Local color := { 0, 0XFFFF, 0, 0 }

	gc = gdk_gc_new( widget  )   // cambio propiedades del contexto gr�ico gc
    gdk_gc_set_line_attributes(gc,;
                               5,; /* grosor */
                               GDK_LINE_DOUBLE_DASH,; /* tipo de l�ea (slida en este caso) */
                               GDK_CAP_PROJECTING,; /* terminacin (redondeada en este caso) */
                               GDK_JOIN_ROUND) /* unin de trazos (redondeado en este caso) */

    colormap := gtk_widget_get_colormap( widget )
    * Algo hace harbour que no pone bien los colores
    gdk_colormap_alloc_color( colormap, color,;
                              FALSE,; /* slo lectura, para poder compartirlo */
                              TRUE )  /* si no lo puede reservar, pide uno parecido */
    gdk_gc_set_foreground( gc, color )

	gdk_draw_line( widget,; /* �ea en donde dibujar */
                   gc,; /* contexto gr�ico a utilizar */
                   1, 1,; /* (x, y) inicial */
                   200, 200) /* (x, y) final */

    gdk_gc_set_line_attributes(gc,;
                               15,; /* grosor */
                               GDK_LINE_ON_OFF_DASH,; /* tipo de l�ea (slida en este caso) */
                               GDK_CAP_ROUND,; /* terminacin (redondeada en este caso) */
                               GDK_JOIN_BEVEL) /* unin de trazos (redondeado en este caso) */

    color := { 0,0,0,0XFFFF }
    colormap := gtk_widget_get_colormap( widget )
    gdk_colormap_alloc_color( colormap, color,;
                              FALSE,; /* slo lectura, para poder compartirlo */
                              TRUE )  /* si no lo puede reservar, pide uno parecido */
    gdk_gc_set_foreground( gc, color )

    gdk_draw_line( widget,; /* �ea en donde dibujar */
                   gc,; /* contexto gr�ico a utilizar */
                   200, 1,; /* (x, y) inicial */
                   1, 200) /* (x, y) final */

    g_object_unref( gc )


Return .T.

