/* $Id: gdkwin32.c,v 1.2 2010-12-28 11:51:53 xthefull Exp $*/
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
 * GdkWin32. Api GDK a GdkWin32
 */

#include <gtk/gtk.h>
#include "hbapi.h"

#if GTK_MAJOR_VERSION < 3  // Solo funciona para < gtk3

HB_FUNC( GDK_WINDOW_SET_CURSOR ) // nWindow, nCursor -> void
{
  GtkWidget * widget = GTK_WIDGET( hb_parptr( 1 ) );
  GdkCursor * cursor = ( GdkCursor * ) hb_parptr( 2 );
  gdk_window_set_cursor( widget->window, cursor );
}

HB_FUNC( GDK_WINDOW_SET_MODAL_HINT ) // nWindow, lModal -> void
{
  GtkWidget * widget = GTK_WIDGET( hb_parptr( 1 ) );
  gboolean modal     = ( gboolean ) hb_parl( 2 );
  gdk_window_set_modal_hint( widget->window, modal );
}

HB_FUNC( GDK_WINDOW_MAXIMIZE ) // nWindow -> void
{
  GtkWidget * widget = GTK_WIDGET( hb_parptr( 1 ) );
  gdk_window_maximize( widget->window );
}

HB_FUNC( GDK_WINDOW_FULLSCREEN ) // nWindow -> void
{
  GtkWidget * widget = GTK_WIDGET( hb_parptr( 1 ) );
  gdk_window_fullscreen( widget->window );
}

HB_FUNC( GDK_WINDOW_ICONIFY ) // nWindow -> void
{
  GtkWidget * widget = GTK_WIDGET( hb_parptr( 1 ) );
  gdk_window_iconify( widget->window );
}

HB_FUNC( GDK_WINDOW_DEICONIFY ) // nWindow -> void
{
  GtkWidget * widget = GTK_WIDGET( hb_parptr( 1 ) );
  gdk_window_deiconify( widget->window );
}

HB_FUNC( GDK_WINDOW_HIDE ) // nWindow -> void
{
  GtkWidget * widget = GTK_WIDGET( hb_parptr( 1 ) );
  gdk_window_hide( widget->window );
}

HB_FUNC( GDK_WINDOW_SHOW ) // nWindow -> void
{
  GtkWidget * widget = GTK_WIDGET( hb_parptr( 1 ) );
  gdk_window_show( widget->window );
}

HB_FUNC( GDK_WINDOW_MOVE ) // nWindow, x, y -> void
{
  GtkWidget * widget = GTK_WIDGET( hb_parptr( 1 ) );
  gint x = ( gint ) hb_parni( 1 );
  gint y = ( gint ) hb_parni( 2 );
  gdk_window_move( widget->window, x, y );
}

HB_FUNC( GDK_WINDOW_RESIZE ) // nWindow, width, height -> void
{
  GtkWidget * widget = GTK_WIDGET( hb_parptr( 1 ) );
  gint width  = ( gint ) hb_parni( 1 );
  gint height = ( gint ) hb_parni( 2 );
  gdk_window_resize( widget->window, width, height );
}

HB_FUNC( GDK_WINDOW_GET_TOPLEVELS )
{
  GList * windows = gdk_window_get_toplevels();
  hb_retptr( (GList *) windows );
}
HB_FUNC( GDK_WINDOW_GET_USER_DATA )
{
   gpointer data;
   GdkWindow * window = (GdkWindow * )hb_parptr( 1 ) ;
   gdk_window_get_user_data( window, &data);
   hb_retptr( (gpointer)data );
}

HB_FUNC( GDK_GET_DEFAULT_ROOT_WINDOW )
{
   hb_retptr( (GdkWindow * ) gdk_get_default_root_window() );
}

#endif