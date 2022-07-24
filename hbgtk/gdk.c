/* $Id: gdk.c,v 1.2 2010-05-26 10:17:35 xthefull Exp $*/
/*
    LGPL Licence.
    
    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this software; see the file COPYING.  If not, write to
    the Free Software Foundation, Inc., 59 Temple Place, Suite 330,
    Boston, MA 02111-1307 USA (or visit the web site http://www.gnu.org/).

    LGPL Licence.
    (c)2003 Rafael Carmona <thefull@wanadoo.es>
    (c)2003 Joaquim Ferrer <quim_ferrer@yahoo.es>
*/
/*
 * Api GDK
 */

#include <gtk/gtk.h>
#include "hbapi.h"


PHB_ITEM Color2Array( GdkColor *color );
BOOL Array2Color(PHB_ITEM aColor, GdkColor *color );

PHB_ITEM Rect2Array( GdkRectangle *rect );
BOOL Array2Rect(PHB_ITEM aRect, GdkRectangle *rect );

/*
 * Display
 */
HB_FUNC( GDK_GET_DISPLAY ) //deprecated
{
   GdkDisplay * display = gdk_display_get_default();
   hb_retc( ( gchar*) gdk_display_get_name( display ) );
}


HB_FUNC( GDK_FLUSH ) //deprecated
{
  gdk_display_flush( gdk_display_get_default() );
}

HB_FUNC( GDK_DISPLAY_FLUSH )
{
  GdkDisplay * display = (GdkDisplay *) hb_parptr( 1 );
  gdk_display_flush( display );
}

/* depecrated
HB_FUNC( GDK_SCREEN_WIDTH )
{
  hb_retni( gdk_screen_width() );
}


HB_FUNC( GDK_SCREEN_HEIGHT )
{
  hb_retni( gdk_screen_height() );
}


HB_FUNC( GDK_SCREEN_WIDTH_MM )
{
  hb_retni( gdk_screen_width_mm() );
}

HB_FUNC( GDK_SCREEN_HEIGHT_MM )
{
  hb_retni( gdk_screen_height_mm() );
}
*/

HB_FUNC( GDK_SET_DOUBLE_CLICK_TIME ) //deprecated
{
  //gdk_set_double_click_time( (guint) hb_parni( 1 ) );
  GdkDisplay *display = gdk_display_get_default();
  gdk_display_set_double_click_time( display, (guint) hb_parni( 1 ) );
}

HB_FUNC( GDK_DISPLAY_SET_DOUBLE_CLICK_TIME ) //msec
{
  GdkDisplay *display = hb_parptr( 1 );
  gdk_display_set_double_click_time( display, (guint) hb_parni( 2 ) );
}



HB_FUNC( GDK_BEEP ) //deprecated
{
  gdk_display_beep( gdk_display_get_default() );
}

HB_FUNC( GDK_DISPLAY_BEEP )
{
  GdkDisplay *display = hb_parptr( 1 );
  gdk_display_beep( display );
}

HB_FUNC( GDK_DISPLAY_OPEN )
{
  GdkDisplay * display = gdk_display_open( hb_parc( 1 ) );
  hb_retptr( (GdkDisplay *) display);
}

HB_FUNC( GDK_DISPLAY_GET_DEFAULT )
{
  hb_retptr( (GdkDisplay *) gdk_display_get_default() );
}

HB_FUNC( GDK_DISPLAY_GET_NAME )
{
  GdkDisplay * display = (GdkDisplay *) hb_parptr( 1 );
  hb_retc( (gchar*) gdk_display_get_name( display ) );
}

HB_FUNC( GDK_DISPLAY_GET_N_SCREENS ) //deprecated
{
  //GdkDisplay * display = (GdkDisplay *) hb_parptr( 1 );
  hb_retni( 0 ); //gdk_display_get_n_screens( display ) );
}

// GtkSettings* gtk_settings_get_for_screen    (GdkScreen *screen);
HB_FUNC( GTK_SETTINGS_GET_DEFAULT )
{
   GtkSettings * set = gtk_settings_get_default ();
   hb_retptr( (GtkSettings *) set );
}

#if GTK_MAJOR_VERSION < 3
HB_FUNC( CAMBIO_STYLE )
{
    
 GtkSettings * settings = gtk_settings_get_default();
 gtk_rc_reparse_all_for_settings (settings, TRUE );

    while (gtk_events_pending())
        gtk_main_iteration();

}

/*
 * API Graphics Contexts
 * */

// Create a new graphics context with default values.
HB_FUNC( GDK_GC_NEW )
{
  GtkWidget * widget = GTK_WIDGET( hb_parptr( 1 ) );
  GdkGC * gc = gdk_gc_new( GDK_DRAWABLE( widget->window ) );
  hb_retptr( (GdkGC *)  gc );
}

HB_FUNC( GDK_GC_SET_LINE_ATTRIBUTES ) // gc, line_width, line_style, cap_style, join_style
{
  GdkGC * gc = GDK_GC( hb_parptr( 1 ) );
  gdk_gc_set_line_attributes( gc, hb_parni( 2 ), hb_parni( 3 ), hb_parni( 4 ),hb_parni( 5 ) );
}

HB_FUNC( GDK_DRAW_LINE )
{
  GtkWidget * widget = GTK_WIDGET( hb_parptr( 1 ) );
  GdkGC * gc = GDK_GC( hb_parptr( 2 ) );
  gdk_draw_line( GDK_DRAWABLE( widget->window ), /* �ea en donde dibujar */
                 gc,                             /* contexto gr�ico a utilizar */
                 hb_parni( 3 ), hb_parni( 4 ),   /* (x, y) inicial */
                 hb_parni( 5 ), hb_parni( 6 ) ); /* (x, y) final */
}

HB_FUNC( GDK_DRAW_RECTANGLE )
{
    GtkWidget * widget = GTK_WIDGET( hb_parptr( 1 ) );
    GdkGC * gc = GDK_GC( hb_parptr( 2 ) );
    gboolean filled = hb_parl( 3 );
    gint x      = hb_parni(4);
    gint y      = hb_parni(5);
    gint width  = hb_parni(6);
    gint height = hb_parni(7);

    gdk_draw_rectangle( GDK_DRAWABLE( widget->window),
                        gc, filled, x, y, width,  height );
}

HB_FUNC( GDK_DRAW_PIXBUF )
{
    GtkWidget * widget = GTK_WIDGET( hb_parptr( 1 ) );
    GdkGC * gc = ISNIL(2) ? NULL : GDK_GC( hb_parptr( 2 ) );
    GdkPixbuf * pixbuf = ( GdkPixbuf * ) hb_parptr( 3 );
    gint src_x  = ISNIL(4) ? 0 :hb_parni(4);
    gint src_y  = ISNIL(5) ? 0 :hb_parni(5);
    gint dest_x = hb_parni(6);
    gint dest_y = hb_parni(7);
    gint width  = ISNIL(8) ? -1 : hb_parni(8);
    gint height = ISNIL(9) ? -1 : hb_parni(9);
    GdkRgbDither dither = ISNIL(10) ? 0 :hb_parni(10);
    gint x_dither = hb_parni(11);
    gint y_dither = hb_parni(12);

    gdk_draw_pixbuf( GDK_DRAWABLE( widget->window) , /* area en donde dibujar */
                     gc,
                     pixbuf,
                     src_x, src_y, dest_x, dest_y,
                     width, height, dither, x_dither, y_dither);

}

HB_FUNC( GDK_DRAW_LAYOUT )
{
    GtkWidget * widget = GTK_WIDGET( hb_parptr( 1 ) );
    GdkGC * gc = GDK_GC( hb_parptr( 2 ) );
    PangoLayout * pango = ( PangoLayout * ) hb_parptr( 5 );
    gint x      = hb_parni(3);
    gint y      = hb_parni(4);

    gdk_draw_layout( GDK_DRAWABLE( widget->window),
                                   gc, x ,y, pango );
}

HB_FUNC( GDK_DRAW_LAYOUT_WITH_COLORS )
{
    GtkWidget * widget = GTK_WIDGET( hb_parptr( 1 ) );
    GdkGC * gc = GDK_GC( hb_parptr( 2 ) );
    PangoLayout * pango = ( PangoLayout * ) hb_parptr( 5 );
    gint x      = hb_parni(3);
    gint y      = hb_parni(4);
    GdkColor foreground, background;
    PHB_ITEM pColor = hb_param( 6, HB_IT_ARRAY );        // array
    PHB_ITEM pColor2 = hb_param( 7, HB_IT_ARRAY );        // array

   if ( Array2Color( pColor, &foreground ) )
    {
     if ( Array2Color( pColor2, &background ) )
        {
        gdk_draw_layout_with_colors( GDK_DRAWABLE( widget->window),
                         gc, x ,y, pango,
                         &foreground, &background );
        }
     }
}

HB_FUNC( GDK_DRAW_ARC )
{
    GtkWidget * widget = GTK_WIDGET( hb_parptr( 1 ) );
    GdkGC * gc = GDK_GC( hb_parptr( 2 ) );
    gboolean filled = hb_parl( 3 );
    gint x      = hb_parni(4);
    gint y      = hb_parni(5);
    gint width  = hb_parni(6);
    gint height = hb_parni(7);
    gint angle1 = hb_parni(8);
    gint angle2 = hb_parni(9);

    gdk_draw_arc( GDK_DRAWABLE( widget->window),
                  gc, filled, x, y, width, height, angle1, angle2 );
}


HB_FUNC( GDK_COLORMAP_ALLOC_COLOR ) // colormap, { colors }, writeable, best_match
{
  GdkColor color;
  GdkColormap *colormap = GDK_COLORMAP( hb_parptr( 1 ) );
  PHB_ITEM pColor = hb_param( 2, HB_IT_ARRAY );        // array
  gboolean bresult = FALSE;

  if ( Array2Color( pColor, &color ) )
    {
     bresult = gdk_colormap_alloc_color(  colormap, &color, hb_parl( 3 ), hb_parl( 4 ) );
     hb_storni( (guint32) (color.pixel), 1);
     hb_stornl( (guint16) (color.red)  , 2);
     hb_stornl( (guint16) (color.green), 3);
     hb_stornl( (guint16) (color.blue) , 4);
    }
    hb_retl( bresult );

}

//Sets the foreground color for a graphics context.
HB_FUNC( GDK_GC_SET_FOREGROUND ) // gc, { colors }
{
    GdkGC * gc = GDK_GC( hb_parptr( 1 ) );
    GdkColor color;
    PHB_ITEM pColor = hb_param( 2, HB_IT_ARRAY );        // array
    if ( Array2Color( pColor, &color ) )
    {
     gdk_gc_set_foreground( gc, &color );
     hb_storni( (guint32) (color.pixel), 1);
     hb_stornl( (guint16) (color.red)  , 2);
     hb_stornl( (guint16) (color.green), 3);
     hb_stornl( (guint16) (color.blue) , 4);
    }
 hb_ret();
}

HB_FUNC( GDK_GC_SET_BACKGROUND ) // gc, { colors }
{
    GdkGC * gc = GDK_GC( hb_parptr( 1 ) );
    GdkColor color;
    PHB_ITEM pColor = hb_param( 2, HB_IT_ARRAY );        // array
    if ( Array2Color( pColor, &color ) )
    {
     gdk_gc_set_background( gc, &color );
     hb_storni( (guint32) (color.pixel), 1);
     hb_stornl( (guint16) (color.red)  , 2);
     hb_stornl( (guint16) (color.green), 3);
     hb_stornl( (guint16) (color.blue) , 4);
    }
 hb_ret();
}
#endif

HB_FUNC( GDK_RECTANGLE_INTERSECT )
{
    GdkRectangle rect1,rect2,dest ;
    PHB_ITEM pSrc1 = hb_param( 1, HB_IT_ARRAY );        // array
    PHB_ITEM pSrc2 = hb_param( 2, HB_IT_ARRAY );        // array
    PHB_ITEM pDest = hb_param( 3, HB_IT_ARRAY );        // array
    gboolean bResult = FALSE ;
    if ( Array2Rect( pSrc1, &rect1 ) &&  Array2Rect( pSrc2, &rect2 ) &&  Array2Rect( pDest, &dest ) )
       {
         bResult = gdk_rectangle_intersect( &rect1, &rect2, &dest );
         hb_stornl( (dest.x),  1);
         hb_stornl( (dest.y),  2);
         hb_stornl( (dest.width) , 3);
         hb_stornl( (dest.height) , 4);
       }
     hb_retl( bResult );
}


HB_FUNC( GDK_PIXBUF_NEW_FROM_RESOURCE_AT_SCALE )
{
   const char* resource_path = hb_parc( 1 );
   int width  = hb_parni( 2 );
   int height = hb_parni( 3 );
   gboolean preserve_aspect_ratio = hb_parl( 4 );
   
   GdkPixbuf * pixbuf = gdk_pixbuf_new_from_resource_at_scale( resource_path,
		                                               width,
		                                               height,
		                                               preserve_aspect_ratio, NULL );
   hb_retptr( (GdkPixbuf *) pixbuf );
}


HB_FUNC( GDK_PIXBUF_NEW_FROM_FILE_AT_SIZE )
{
   const char * filename = hb_parc( 1 );
   int width = hb_parni( 2 );
   int height = hb_parni( 3 );

   GdkPixbuf * pixbuf = gdk_pixbuf_new_from_file_at_size( filename,
                                                          width, height, 
                                                          NULL );
   hb_retptr( (GdkPixbuf *) pixbuf );
}


HB_FUNC( GDK_PIXBUF_NEW_FROM_FILE_AT_SCALE )
{
   const char * filename = hb_parc( 1 );
   int width = hb_parni( 2 );
   int height = hb_parni( 3 );
   gboolean preserve_aspect_ratio = hb_parl( 4 );

   GdkPixbuf * pixbuf = gdk_pixbuf_new_from_file_at_scale( filename,
                                                           width, height, 
                                                           preserve_aspect_ratio,
                                                           NULL );
   hb_retptr( (GdkPixbuf *) pixbuf );
}
//eof
