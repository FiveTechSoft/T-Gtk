/* $Id: gtkimage.c,v 1.2 2007-08-01 20:56:44 xthefull Exp $*/
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
#include <hbapi.h>
#include <gtk/gtk.h>


HB_FUNC( GTK_IMAGE_NEW ) // -->widget
{
   GtkWidget * image = gtk_image_new();
   hb_retptr( ( GtkWidget * ) image );
}

HB_FUNC( GTK_IMAGE_NEW_FROM_FILE ) // cFileName -> image
{
  GtkWidget * image  = gtk_image_new_from_file( (gchar *) hb_parc( 1 ) );
  hb_retptr( (GtkWidget *) image );
}

#if GTK_MAJOR_VERSION < 3
//  warning: ‘gtk_image_new_from_stock’ is deprecated: Use 'gtk_image_new_from_icon_name' instead 
HB_FUNC( GTK_IMAGE_NEW_FROM_STOCK ) // nIcon, nSize -> image
{
  GtkWidget * image  = gtk_image_new_from_stock( (gchar *) hb_parc( 1 ),
                                                 (gint   ) hb_parni( 2 ) );
  hb_retptr( (GtkWidget *) image );
}
#endif

HB_FUNC( GTK_IMAGE_NEW_FROM_ICON_NAME ) // nIcon, nSize -> image
{
  const gchar * icon_name = (gchar *) hb_parc( 1 );
  GtkIconSize   size      = (gint   ) hb_parni( 2 ); 
  GtkWidget   * image     = gtk_image_new_from_icon_name( icon_name, size );
                                                 
  hb_retptr( (GtkWidget *) image );
}

HB_FUNC( GTK_IMAGE_SET_FROM_FILE ) // widget , cFileName
{
   GtkWidget * image = GTK_WIDGET( hb_parptr( 1 ) );
   gtk_image_set_from_file( GTK_IMAGE( image ), hb_parc( 2 ) );
}



HB_FUNC( GTK_IMAGE_GET_PIXBUF )
{
   GtkWidget * image = GTK_WIDGET( hb_parptr( 1 ) );
   GdkPixbuf * pixbuf = gtk_image_get_pixbuf ( GTK_IMAGE( image ) );
   hb_retptr( (GdkPixbuf *) pixbuf );
}

HB_FUNC( GTK_IMAGE_NEW_FROM_PIXBUF ) // nIcon -> image
{
  GdkPixbuf * pixbuf = ( GdkPixbuf * ) hb_parptr( 1 );
  GtkWidget * image  = gtk_image_new_from_pixbuf( pixbuf );
  hb_retptr( (GtkWidget *) image );
}

HB_FUNC( GTK_IMAGE_SET_FROM_PIXBUF )  // pImage, pPixbuf
{
   GtkWidget * image = GTK_WIDGET( hb_parptr( 1 ) );
   GdkPixbuf * pixbuf = ( GdkPixbuf * ) hb_parptr( 2 );
   gtk_image_set_from_pixbuf( GTK_IMAGE( image ), pixbuf );
}

// #if GTK_CHECK_VERSION(2,8,0)
HB_FUNC( GTK_IMAGE_CLEAR )
{
   GtkWidget * image = GTK_WIDGET( hb_parptr( 1 ) );
   gtk_image_clear( GTK_IMAGE( image ) );
}
//#endif


HB_FUNC( GTK_DRAWING_AREA_NEW )
{
  GtkWidget * draw =  gtk_drawing_area_new ();
  hb_retptr( (GtkWidget *) draw );

}

#if GTK_MAJOR_VERSION < 3
HB_FUNC( GTK_IMAGE_GET_PIXMAP )
{
   GtkWidget * image = GTK_WIDGET( hb_parptr( 1 ) );
   GdkPixmap * pixmap;
   gtk_image_get_pixmap( GTK_IMAGE( image ), &pixmap, NULL );
   hb_retptr( (GdkPixmap *) pixmap );
}
#endif

//eof
