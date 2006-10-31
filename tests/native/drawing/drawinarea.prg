 /*
 * $Id: drawinarea.prg,v 1.1 2006-10-31 11:43:58 xthefull Exp $
 * Ejemplo de uso Drawing_area_new() y dibujando a traves del evento expose_event
 * Porting Harbour to GTK+ power !
 * (C) 2004-05. Rafa Carmona -TheFull-
 * (C) 2004-05. Joaquim Ferrer
*/
#include "gclass.ch"

Static pixbuf, pixbuf2

Function Main()
         Local button, table, vPaned, image,  entry_file, draw
         Local Window

         Window := Gtk_Window_New( GTK_WINDOW_TOPLEVEL )

         Gtk_window_set_title( Window, "GUI T-Gtk Power!! Draw primitives" )
         Gtk_window_set_position( Window, GTK_WIN_POS_CENTER )

         Gtk_Signal_Connect( Window, "delete-event", {|| Salida() } )  // Cuando se mata la aplicacion

         pixbuf := gdk_pixbuf_new_from_file( "../../images/glade.png" )
         pixbuf2 := gdk_pixbuf_new_from_file( "../../images/rafa.jpg" )

         draw = gtk_drawing_area_new()
         gtk_widget_set_size_request( draw, 300, 300 )
         gtk_widget_show (draw)
         Gtk_Signal_Connect( draw, "expose-event", {|widget,event| dibuja( widget,event ) } )  // Procesa mensajes de dibujo
         Gtk_Signal_Connect( draw, "configure-event", {|widget,event| Configure_event( window, widget, event ) } )  
         gtk_container_add (Window, draw)


         gtk_widget_show ( window )

         gtk_main ()

         // Debemos de referenciar pixbufs de la memoria
         gdk_pixbuf_unref( pixbuf )
         gdk_pixbuf_unref( pixbuf2 )

return NIL

//Salida controlada del programa.
Function Salida( widget )
    gtk_main_quit()
Return .F.  // Salimos y matamos la aplicacion.

// Informamos del cambio de la ventana
STATIC FUNCTION Configure_event( window, widget, event )
  STATIC nVeces := 0
  
  Gtk_window_set_title( Window, "Change window "+ cValToChar( ++nVeces ) )

RETURN .F.

FUNCTION DIBUJA( widget, event )
 Local gc
 Local colormap, pango
 Local color := { 0, 0XF, 25500, 34534 }

 Local cTextMark := '<span foreground="blue" size="large"><b>Esto es <span foreground="yellow"'+;
                ' size="xx-large" background="black" ><i>fabuloso</i></span></b>!!!!</span>'+;
                HB_OSNEWLINE()+;
                '<span foreground="red" size="23000"><b><i>T-Gtk power!!</i></b> </span>' +;
                HB_OSNEWLINE()+;
                'Usando un lenguaje de <b>marcas</b> para mostrar textos'

  gc = gdk_gc_new( widget  )   // cambio propiedades del contexto gr�ico gc

  gdk_gc_set_line_attributes(gc,;
                            5,; /* grosor */
                            GDK_LINE_DOUBLE_DASH,; /* tipo de l�ea (slida en este caso) */
                            GDK_CAP_BUTT ,; /* terminacin (redondeada en este caso) */
                            GDK_JOIN_BEVEL) /* unin de trazos (redondeado en este caso) */

   color := { 0, 0XFFFF, 0XFFFF, 0XFFFF }
   gdk_colormap_alloc_color( gtk_widget_get_colormap( widget ), color,;
                             FALSE,; /* slo lectura, para poder compartirlo */
                             TRUE )  /* si no lo puede reservar, pide uno parecido */
   gdk_gc_set_foreground( gc, color )
   gdk_draw_arc( widget,;
               gc, .F., 0, 0, 200,  200, 0, 18400 )


   color := { 0, 0, 0, 0XFFFF }
   gdk_gc_set_line_attributes(gc,;
                            25,; /* grosor */
                            GDK_LINE_DOUBLE_DASH,; /* tipo de l�ea (slida en este caso) */
                            GDK_CAP_BUTT ,; /* terminacin (redondeada en este caso) */
                            GDK_JOIN_BEVEL) /* unin de trazos (redondeado en este caso) */

   colormap := gtk_widget_get_colormap( widget )
   /* reservo el color (o pido uno cercano) */
   gdk_colormap_alloc_color( colormap, color,;
                             FALSE,; /* slo lectura, para poder compartirlo */
                             TRUE )  /* si no lo puede reservar, pide uno parecido */
   gdk_gc_set_foreground( gc, color )

   gdk_draw_line( widget,; /* area en donde dibujar */
                  gc,; /* contexto grafico a utilizar */
                  1, 1,; /* (x, y) inicial */
                  200, 200) /* (x, y) final */


   gdk_gc_set_line_attributes(gc,;
                             15,; /* grosor */
                            GDK_LINE_ON_OFF_DASH,; /* tipo de l�ea (slida en este caso) */
                            GDK_CAP_ROUND,; /* terminacin (redondeada en este caso) */
                            GDK_JOIN_BEVEL) /* unin de trazos (redondeado en este caso) */

  color := { 0, 0, 0XFFFF, 0XFFFF }
  colormap := gtk_widget_get_colormap( widget )
  gdk_colormap_alloc_color( colormap, color,;
                             FALSE,; /* slo lectura, para poder compartirlo */
                             TRUE )  /* si no lo puede reservar, pide uno parecido */
  gdk_gc_set_foreground( gc, color )
  gdk_draw_line( widget,; /* area en donde dibujar */
                gc,; /* contexto grafico a utilizar */
                200, 1,;  /* (x, y) inicial */
                1, 200)   /* (x, y) final */

  // Rectangulo relleno de color amarillo
  color := { 0, 0XFFFF, 0XFFFF, 0 }
  colormap := gtk_widget_get_colormap( widget )
  gdk_colormap_alloc_color( colormap, color,;
                             FALSE,; /* slo lectura, para poder compartirlo */
                             TRUE )  /* si no lo puede reservar, pide uno parecido */
  gdk_gc_set_foreground( gc, color )
  gdk_draw_rectangle( widget,;
                      gc, .T., 40, 40, 30,  30 )

// Un bitmap por aqui en la posicion 70,70
  gdk_draw_pixbuf( widget, gc, pixbuf, 0, 0, 70, 70 )

  // Rectangulo sin rellenar, pero como tenemos un pincel muy gordo
  // debemos de cambiarlo.
   gdk_gc_set_line_attributes(gc,;
                             2,; /* grosor */
                             GDK_LINE_DOUBLE_DASH,; /* tipo de l�ea (slida en este caso) */
                             GDK_CAP_ROUND,; /* terminacin (redondeada en este caso) */
                             GDK_JOIN_BEVEL) /* unin de trazos (redondeado en este caso) */

  gdk_draw_rectangle( widget,;
                      gc, .FALSE, 90, 90, 140, 140 )


// Color AZUL
  color := { 0, 0, 0, 0XFFFF }
  gdk_colormap_alloc_color( gtk_widget_get_colormap( widget ), color,;
                             FALSE,; /* slo lectura, para poder compartirlo */
                             TRUE )  /* si no lo puede reservar, pide uno parecido */
  gdk_gc_set_foreground( gc, color )


/* Haciendo un poco de trastadas ;-) , fijate como es la imagen original,
   y comparalo con lo que estas viendo */
  gdk_draw_pixbuf( widget, gc, pixbuf2, 100, 100, 170, 170, 100,100 )


/* Podemos imprimir texto a traves de pango sin problemas!!!*/
  pango :=  gtk_widget_create_pango_layout( widget, "Hola, Esta pintado"+;
                                     HB_OSNEWLINE()+"TEXTO desde Harbour!!" )


  gdk_draw_layout( widget, gc, 100, 50, pango )

  pango :=  gtk_widget_create_pango_layout( widget, "Hola, Esta pintado"+;
                                     HB_OSNEWLINE()+"TEXTO desde Harbour!!"+;
                                     HB_OSNEWLINE()+"PERO CON foreground, background!!" )

  gdk_draw_layout_with_colors( widget, gc, 60, 150, pango,;
                               { 0, 0xFFFF, 0XFFFF, 0XFFFF },;
                               { 0, 0xFFFF, 0, 0XFFFF } )

  pango_layout_set_markup( pango, cTextMark )
  gdk_draw_layout( widget, gc, 10, 200, pango )

  g_object_unref( gc )


Return .T.

**********************************************************************

#pragma BEGINDUMP
#include <gtk/gtk.h>
#include "hbapi.h"

PHB_ITEM Color2Array( GdkColor *color );
BOOL Array2Color(PHB_ITEM aColor, GdkColor *color );

#pragma ENDDUMP

