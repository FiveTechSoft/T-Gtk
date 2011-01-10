/*
  Pixbufs en T-Gtk
  Ejemplo basado en el ejemplo de Pixbufs.c de GTKDEMO
  (c)2005 Rafa Carmona
 */

#include "gclass.ch"

#define FRAME_DELAY 50
#define BACKGROUND_NAME "background.jpg"
#define GDK_COLORSPACE_RGB 0
#define GDK_INTERP_NEAREST 0

#define GDK_RGB_DITHER_NORMAL 1
#define CYCLE_LEN 60

static frame_num := 1

static window
static image_names, N_IMAGES

/* Current frame */
static frame

/* Background image */
static  background
static  back_width, back_height

static images

/* Widgets */
static da

Function Main()
     Local oTimer  
   
     image_names := { "apple-red.png",;
                      "gnome-applets.png",;
                      "gnome-calendar.png",;
                      "gnome-foot.png",;
                      "gnome-gmush.png",;
                      "gnome-gimp.png",;
                      "gnome-gsame.png",;
                      "gnu-keys.png" }
    
      Images := ARRAY( Len( image_names ) )
      N_IMAGES := Len( images )

      window = gtk_window_new( GTK_WINDOW_TOPLEVEL )
      gtk_window_set_title ( window, "T-Gtk Pixbufs ;-)")
      Gtk_window_set_position( Window, GTK_WIN_POS_CENTER )
      gtk_window_set_resizable (GTK_WINDOW (window), FALSE)
      
      gtk_Signal_Connect( window, "delete-event", {|| Salida() } )  // Cuando se mata la aplicacion

      Load_pixbufs()

      gtk_widget_set_size_request(window, back_width, back_height)
      
      frame = gdk_pixbuf_new (GDK_COLORSPACE_RGB, FALSE, 8, back_width, back_height)

      da = gtk_drawing_area_new ()
      Gtk_Signal_Connect( da, "expose-event", {|widget, event|expose_cb(widget, event) } )  // Procesa mensajes de dibujo

      gtk_container_add (GTK_CONTAINER (window), da)
     
      /*    timeout_id = g_timeout_add (FRAME_DELAY, timeout, NULL); */
      DEFINE TIMER oTimer ACTION Timeout() INTERVAL FRAME_DELAY
      ACTIVATE TIMER oTimer
      
      gtk_widget_show_all( window )
      gtk_main()

RETURN NIL

/* Loads the images for the demo and returns whether the operation succeeded */
STATIC FUNCTION load_pixbufs( )
  Local i , filename 
  Local path := "../../images/"
  background = gdk_pixbuf_new_from_file ( path + BACKGROUND_NAME )
  
  back_width  = gdk_pixbuf_get_width ( background )
  back_height = gdk_pixbuf_get_height( background )

  FOR i := 1 TO N_IMAGES
      images[i] = gdk_pixbuf_new_from_file( path + image_names[i] )
  NEXT

RETURN NIL

//Salida controlada del programa.
Function Salida( widget )
      gtk_main_quit()
Return .F.  // Salimos y matamos la aplicacion.

/* Expose callback for the drawing area */
FUNCTION EXPOSE_CB(  widget, event )
   Local pixels,  rowstride
   Local style_black   := HB_GET_WIDGET_STYLE_BLACK_GC ( widget ) // widget->style->black_gc
   Local area_y        := HB_GET_EVENTEXPOSE_AREA_Y( event )
   Local area_x        := HB_GET_EVENTEXPOSE_AREA_X( event )
   Local area_width    := HB_GET_EVENTEXPOSE_AREA_WIDTH( event )
   Local area_height   := HB_GET_EVENTEXPOSE_AREA_HEIGHT( event )
   Local widget_window := HB_GET_WIDGET_WINDOW( widget )

   rowstride := gdk_pixbuf_get_rowstride( frame )
   pixels   := gdk_pixbuf_get_pixels( frame ) + rowstride * area_y + area_x * 3
   gdk_draw_rgb_image_dithalign( widget_window,;
                                 style_black,;
                                 area_x, area_y,;
                                 area_width, area_height,;
                                 GDK_RGB_DITHER_NORMAL,;
                                 pixels, rowstride,;
                                 area_x, area_y)

return TRUE


/* Timeout handler to regenerate the frame */
FUNCTION timeout(  )
    Local f,i,xmid,ymid,radius
    Local N_IMAGES := Len( images )
    Local ang, xpos, ypos, iw, ih, r ,k
    Local r1   := ARRAY( 4 )
    Local r2   := ARRAY( 4 )
    Local dest := ARRAY( 4 )

    gdk_pixbuf_copy_area (background, 0, 0, back_width, back_height, frame, 0, 0)
  
    f = ( (frame_num % CYCLE_LEN) / CYCLE_LEN ) * 1.0
    xmid = back_width  / 2.0
    ymid = back_height / 2.0
    radius = MIN( xmid, ymid) / 2.0
    
    FOR i := 1 TO N_IMAGES

      ang := 2.0 * PI() *  (i-1) / N_IMAGES - f * 2.0 * PI()
      iw  := gdk_pixbuf_get_width( images[i] )
      ih  := gdk_pixbuf_get_height( images[i] )

      r = radius + (radius / 3.0) * sin (f * 2.0 * PI() )

      xpos = floor( xmid + r * cos (ang) - iw / 2.0 + 0.5)
      ypos = floor( ymid + r * sin (ang) - ih / 2.0 + 0.5)

      k = iif( ( i = 1 .OR. i = 3 .OR. i = 5 .OR. i = 7 ),  sin (f * 2.0 * PI()) , cos ( f * 2.0 * PI() ) )
      k = 2.0 * k * k
      k = MAX (0.25, k)
      
      r1[1] := xpos
      r1[2] := ypos
      r1[3] := iw * k
      r1[4] := ih * k

      r2[1] := 0
      r2[2] := 0
      r2[3] := back_width
      r2[4] := back_height

      IF gdk_rectangle_intersect( r1, r2, dest ) 
         gdk_pixbuf_composite( images[i],;
                                frame,;
                                dest[1], dest[2],;
                                dest[3], dest[4],;
                                xpos, ypos,;
                                k, k,;
                                GDK_INTERP_NEAREST,;
                                if( ( i = 1 .OR. i = 3 .OR. i = 5 .OR. i = 7),;
                                    MAX (127, fabs (255 * sin (f * 2.0 * PI() ) ) ),;
                                    MAX (127, fabs (255 * cos (f * 2.0 * PI())))) )
      ENDIF
    NEXT
    
    
    gtk_widget_queue_draw (da)
    frame_num++

RETURN NIL

#pragma BEGINDUMP
#include <gtk/gtk.h>
#include "hbapi.h"
#include <math.h>

HB_FUNC( COS )
{
  if( ISNUM(1) )
  {
    double dInput = hb_parnd(1);
    double dResult;
    dResult = cos (dInput);

    hb_retnd( dResult );
  }
  else
  {
   hb_retnd (0.0);
  }
 }

HB_FUNC( SIN )
{
  if( ISNUM(1) )
  {
    double dInput = hb_parnd(1);
    double dResult;
    dResult = sin (dInput);

    hb_retnd( dResult );
  }
  else
  {
   hb_retnd (0.0);
  }
 }

HB_FUNC( FLOOR )
{
  if( ISNUM(1) )
  {
    double dInput = hb_parnd(1);
    double dResult;
    dResult = floor (dInput);

    hb_retnd( dResult );
  }
  else
  {
   hb_retnd (0.0);
  }
 }
HB_FUNC( FABS )
{
  if( ISNUM(1) )
  {
    double dInput = hb_parnd(1);
    double dResult;
    dResult = fabs (dInput);

    hb_retnd( dResult );
  }
  else
  {
   hb_retnd (0.0);
  }
 }

HB_FUNC( PI )
{
    hb_retnd( 3.14159265358979323846);
}

#pragma ENDDUMP

