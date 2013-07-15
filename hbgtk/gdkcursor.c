/* $Id: gdkcursor.c,v 1.2 2010-12-28 11:04:17 xthefull Exp $*/
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
 * Cursores GDK
 */

#include <gtk/gtk.h>
#include "hbapi.h"

#ifdef _GTK2_

HB_FUNC( GDK_CURSOR_NEW ) // nGdkTypeCursor -> cursor
{
  GdkCursor * cursor = gdk_cursor_new( ( gint ) hb_parni( 1 ) );
  hb_retptr( (GdkCursor*) cursor );
}

HB_FUNC( GDK_CURSOR_UNREF ) // pCursor -> void
{
  GdkCursor * cursor = ( GdkCursor * )  hb_parptr( 1 );
  gdk_cursor_unref( cursor );
}

HB_FUNC( GDK_CURSOR_GET_DISPLAY ) // pCursor -> display
{
  GdkCursor * cursor = ( GdkCursor *) hb_parptr( 1 );
  GdkDisplay * display = gdk_cursor_get_display( cursor );
  hb_retptr( (GdkDisplay*) display );
}

#endif
