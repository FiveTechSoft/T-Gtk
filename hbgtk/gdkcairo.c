/*
 * 
 *  Cairo Interaction — Functions to support using Cairo
 * 
 *  This program is free software; you can redistribute it and/or
 *  modify it under the terms of the GNU Library General Public License
 *  as published by the Free Software Foundation; either version 2 of
 *  the License, or (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU Library General Public License for more details.
 *
 *  You should have received a copy of the GNU Library General Public
 *  License along with this program; if not, write to the Free Software
 *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 *
 *  Authors:
 *    Rafa Carmona( thefull@wanadoo.es )
 *
 *  Copyright 2007 Rafa Carmona
 */

#include <hbapi.h>
#include <gtk/gtk.h>


HB_FUNC( GDK_CAIRO_SET_SOURCE_PIXBUF )
{
  cairo_t *ctx = ( cairo_t * ) hb_parnl( 1 );
  GdkPixbuf * pixbuf = GDK_PIXBUF (hb_parnl( 2 ) );
  gdk_cairo_set_source_pixbuf( ctx, pixbuf,
                               hb_parnd( 3 ),
                               hb_parnd( 4 ) );
}
