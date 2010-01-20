/* $Id: gdkpixbuf.c,v 1.2 2010-01-20 06:26:11 riztan Exp $*/
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
 * GdkPixbuf. Iconos / bitmaps / imagenes GDK 
*/
#include <gtk/gtk.h>
#include "hbapi.h"

HB_FUNC( GDK_PIXBUF_NEW_FROM_FILE ) // cFilename -> pixbuf
{
  GdkPixbuf * pixbuf;
  GError    * error = NULL;
  gboolean has_alpha = TRUE ;  // transparent
  int bits_per_sample = 8;
  int width = 1;
  int height = 1;

  pixbuf = gdk_pixbuf_new_from_file( (gchar *) hb_parc( 1 ), &error );
  if (!pixbuf)
  {
     g_print( "Error de apertura : %s", error->message );
     g_error_free (error);
     pixbuf = gdk_pixbuf_new( GDK_COLORSPACE_RGB, has_alpha, 
                              bits_per_sample, width, height);
  }
  hb_retnl( (ULONG) pixbuf );
}

HB_FUNC( GDK_PIXBUF_UNREF ) // nIcon -> void
{
  GdkPixbuf * pixbuf = GDK_PIXBUF( hb_parnl( 1 ) );
  gdk_pixbuf_unref( pixbuf );
}

HB_FUNC( GDK_PIXBUF_GET_TYPE ) //
{
  hb_retni( gdk_pixbuf_get_type() );
}

HB_FUNC( GDK_PIXBUF_GET_WIDTH ) 
{
  GdkPixbuf * pixbuf = GDK_PIXBUF (hb_parnl( 1 ) );
  hb_retni( gdk_pixbuf_get_width( pixbuf ) );
}

HB_FUNC( GDK_PIXBUF_GET_HEIGHT ) 
{
  GdkPixbuf * pixbuf = GDK_PIXBUF (hb_parnl( 1 ) );
  hb_retni( gdk_pixbuf_get_height( pixbuf ) );
}

HB_FUNC( GDK_PIXBUF_GET_ROWSTRIDE ) 
{
  GdkPixbuf * pixbuf = GDK_PIXBUF (hb_parnl( 1 ) );
  hb_retni( gdk_pixbuf_get_rowstride( pixbuf ) );
}

HB_FUNC( GDK_PIXBUF_GET_PIXELS ) 
{
  GdkPixbuf * pixbuf = GDK_PIXBUF (hb_parnl( 1 ) );
  hb_retnl( (glong) gdk_pixbuf_get_pixels( pixbuf ) );
}

HB_FUNC( GDK_PIXBUF_NEW ) // color_space, balpha, ibits,iwidth,iheigth -> pixbuf
{
  GdkPixbuf * pixbuf;
  GdkColorspace colorspace = hb_parni( 1 );
  gboolean has_alpha = hb_parl( 2 );  // transparent
  int bits_per_sample = hb_parni( 3 );
  int width = hb_parni( 4 );
  int height = hb_parni( 5 );

  pixbuf = gdk_pixbuf_new( colorspace,
                           has_alpha,
                           bits_per_sample,
                           width,
                           height);
  hb_retnl( (glong) pixbuf );
}

HB_FUNC( GDK_DRAW_RGB_IMAGE_DITHALIGN )
{
     GdkDrawable *drawable = GDK_DRAWABLE( hb_parnl( 1 ) );
     GdkGC * gc = ( GdkGC * ) hb_parnl( 2 );              
     gint x = hb_parni( 3 );                  
     gint y = hb_parni( 4 );                  
     gint width = hb_parni( 5 );              
     gint height = hb_parni( 6 );             
     GdkRgbDither dith = hb_parni( 7 );       
     guchar * rgb_buf = ( guchar *) hb_parnl( 8 );         
     gint rowstride= hb_parni( 9 );          
     gint xdith = hb_parni( 10);              
     gint ydith = hb_parni( 11 );             
     
     gdk_draw_rgb_image_dithalign( drawable,
                                   gc,
                                    x,
                                    y,
                                    width,
                                    height,
                                    dith,
                                    rgb_buf,
                                    rowstride,
                                    xdith,
                                    ydith);
}

HB_FUNC( GDK_PIXBUF_COPY_AREA ) 
{
   GdkPixbuf * pixbuf = GDK_PIXBUF( hb_parnl( 1 ) );
   int src_x = hb_parni( 2 );
   int src_y = hb_parni( 3 );                                                           
   int width = hb_parni( 4 );                                                           
   int height = hb_parni( 5 );
   GdkPixbuf * dest_pixbuf = GDK_PIXBUF( hb_parnl( 6 ) );
   int dest_x = hb_parni( 7 );                                                          
   int dest_y = hb_parni( 8 );                                                         

   gdk_pixbuf_copy_area( pixbuf,
                         src_x,
                         src_y,
                         width,
                         height,
                         dest_pixbuf,
                         dest_x,
                         dest_y);
}

HB_FUNC( GDK_PIXBUF_COMPOSITE ) 
{
   GdkPixbuf * src = GDK_PIXBUF( hb_parnl( 1 ) );
   GdkPixbuf * dest = GDK_PIXBUF( hb_parnl( 2 ) );
   gint dest_x = hb_parni( 3 );                                                          
   gint dest_y = hb_parni( 4 );                                                         
   gint dest_width = hb_parni( 5 );                                                           
   gint dest_height = hb_parni( 6 );
   gdouble offset_x = hb_parnd( 7 );
   gdouble offset_y = hb_parnd( 8 );
   gdouble scale_x = hb_parnd( 9 );
   gdouble scale_y = hb_parnd( 10 );
   GdkInterpType interp_type = hb_parni( 11 );
   gint overall_alpha = hb_parni( 12 );

   gdk_pixbuf_composite( src,
                         dest,
                         dest_x,
                         dest_y,
                         dest_width,
                         dest_height,
                         offset_x,
                         offset_y,
                         scale_x,
                         scale_y,
                         interp_type,
                         overall_alpha );

}

HB_FUNC( GDK_PIXBUF_ADD_ALPHA ) // pixbuf, bsubstitute_color, r,g,b
{
   GdkPixbuf * pixbuf = ( GdkPixbuf * ) hb_parnl( 1 );
   GdkPixbuf * pixbuf2;
   gboolean substitute_color = hb_parl( 2 );
   guchar r = ( guchar ) hb_parnl( 3 );         
   guchar g = ( guchar ) hb_parnl( 4 );         
   guchar b = ( guchar ) hb_parnl( 5 );         

   pixbuf2 = gdk_pixbuf_add_alpha( pixbuf, substitute_color, r,g,b );
   hb_retnl( (glong) pixbuf2 );
}

HB_FUNC( GDK_PIXBUF_ROTATE_SIMPLE ) // pixbuf, angle( 0,90,180,270 )
{
   GdkPixbuf * pixbuf = ( GdkPixbuf * ) hb_parnl( 1 );
   GdkPixbuf * pixbuf2;

   pixbuf2 = gdk_pixbuf_rotate_simple( pixbuf, hb_parni( 2 ) );
   hb_retnl( (glong) pixbuf2 );
}

HB_FUNC( GDK_PIXBUF_FLIP ) // pixbuf, bHorizontal
{
   GdkPixbuf * pixbuf = ( GdkPixbuf * ) hb_parnl( 1 );
   GdkPixbuf * pixbuf2;

   pixbuf2 = gdk_pixbuf_flip( pixbuf, hb_parl( 2 ) );
   hb_retnl( (glong) pixbuf2 );
}

HB_FUNC( GDK_PIXBUF_SCALE_SIMPLE ) // pPixbuf src, wifth,height, interp_type
{
   GdkPixbuf * pixbuf = GDK_PIXBUF( hb_parnl( 1 ) );
   GdkPixbuf * pixbuf2;
   gint dest_width  = hb_parni( 2 );
   gint dest_height = hb_parni( 3 );
   GdkInterpType interp_type = ISNIL( 4 ) ? GDK_INTERP_BILINEAR : hb_parni( 4 );
   
   pixbuf2 = gdk_pixbuf_scale_simple( pixbuf, dest_width, dest_height, interp_type );
   hb_retnl( (glong) pixbuf2 );
}
