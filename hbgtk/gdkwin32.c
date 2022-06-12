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

#if GTK_MAJOR_VERSION < 3

HB_FUNC( GDK_WINDOW_SET_CURSOR ) // nWindow, nCursor -> void
{
  #if GTK_MAJOR_VERSION < 3
    GtkWidget * widget = GTK_WIDGET( hb_parptr( 1 ) );
    GdkCursor * cursor = ( GdkCursor * ) hb_parptr( 2 );
    gdk_window_set_cursor( widget->window, cursor );
  #else
    GdkWindow * window = gtk_widget_get_window( GTK_WIDGET( hb_parptr( 1 ) ) );
    GdkCursor * cursor = ( GdkCursor * ) hb_parptr( 2 );
    gdk_window_set_cursor( window, cursor );
  #endif
}

HB_FUNC( GDK_WINDOW_SET_MODAL_HINT ) // nWindow, lModal -> void
{
  #if GTK_MAJOR_VERSION < 3
    GtkWidget * widget = GTK_WIDGET( hb_parptr( 1 ) );
    gboolean modal     = ( gboolean ) hb_parl( 2 );
    gdk_window_set_modal_hint( widget->window, modal );
  #else
    GdkWindow * window = gtk_widget_get_window( GTK_WIDGET( hb_parptr( 1 ) ) );
    gboolean modal     = ( gboolean ) hb_parl( 2 );
    gdk_window_set_modal_hint( window, modal );
  #endif
}

HB_FUNC( GDK_WINDOW_MAXIMIZE ) // nWindow -> void
{
  #if GTK_MAJOR_VERSION < 3
    GtkWidget * widget = GTK_WIDGET( hb_parptr( 1 ) );
    gdk_window_maximize( widget->window );
  #else
    GdkWindow * window = gtk_widget_get_window(GTK_WIDGET( hb_parptr( 1 ) ) );
    gdk_window_maximize( window );
  #endif
}

HB_FUNC( GDK_WINDOW_FULLSCREEN ) // nWindow -> void
{
  #if GTK_MAJOR_VERSION < 3
    GtkWidget * widget = GTK_WIDGET( hb_parptr( 1 ) );
    gdk_window_fullscreen( widget->window );
  #else
    GdkWindow * window = gtk_widget_get_window(GTK_WIDGET( hb_parptr( 1 ) ) );
    gdk_window_fullscreen( window );
  #endif
}

HB_FUNC( GDK_WINDOW_ICONIFY ) // nWindow -> void
{
  #if GTK_MAJOR_VERSION < 3
    GtkWidget * widget = GTK_WIDGET( hb_parptr( 1 ) );
    gdk_window_iconify( widget->window );
  #else
    GdkWindow * window = gtk_widget_get_window(GTK_WIDGET( hb_parptr( 1 ) ) );
    gdk_window_iconify( window );
  #endif
}

HB_FUNC( GDK_WINDOW_DEICONIFY ) // nWindow -> void
{
  #if GTK_MAJOR_VERSION < 3
    GtkWidget * widget = GTK_WIDGET( hb_parptr( 1 ) );
    gdk_window_deiconify( widget->window );
  #else
    GdkWindow * window = gtk_widget_get_window(GTK_WIDGET( hb_parptr( 1 ) ) );
    gdk_window_deiconify( window );
  #endif
}

HB_FUNC( GDK_WINDOW_HIDE ) // nWindow -> void
{
  #if GTK_MAJOR_VERSION < 3
    GtkWidget * widget = GTK_WIDGET( hb_parptr( 1 ) );
    gdk_window_hide( widget->window );
  #else
    GdkWindow * window = gtk_widget_get_window(GTK_WIDGET( hb_parptr( 1 ) ) );
    gdk_window_hide( window );
  #endif
}

HB_FUNC( GDK_WINDOW_SHOW ) // nWindow -> void
{
  #if GTK_MAJOR_VERSION < 3
    GtkWidget * widget = GTK_WIDGET( hb_parptr( 1 ) );
    gdk_window_show( widget->window );
  #else
    GdkWindow * window = gtk_widget_get_window(GTK_WIDGET( hb_parptr( 1 ) ) );
    gdk_window_show( window );
  #endif
}

HB_FUNC( GDK_WINDOW_MOVE ) // nWindow, x, y -> void
{
  #if GTK_MAJOR_VERSION < 3
    GtkWidget * widget = GTK_WIDGET( hb_parptr( 1 ) );
    gint x = ( gint ) hb_parni( 1 );
    gint y = ( gint ) hb_parni( 2 );
    gdk_window_move( widget->window, x, y );
  #else
    GdkWindow * window = gtk_widget_get_window(GTK_WIDGET( hb_parptr( 1 ) ) );
    gint x = ( gint ) hb_parni( 1 );
    gint y = ( gint ) hb_parni( 2 );
    gdk_window_move( window, x, y );
  #endif
}

HB_FUNC( GDK_WINDOW_RESIZE ) // nWindow, width, height -> void
{
  #if GTK_MAJOR_VERSION < 3
    GtkWidget * widget = GTK_WIDGET( hb_parptr( 1 ) );
    gint width  = ( gint ) hb_parni( 1 );
    gint height = ( gint ) hb_parni( 2 );
    gdk_window_resize( widget->window, width, height );
  #else
    GdkWindow * window = gtk_widget_get_window(GTK_WIDGET( hb_parptr( 1 ) ) );
    gint width  = ( gint ) hb_parni( 1 );
    gint height = ( gint ) hb_parni( 2 );
    gdk_window_resize( window, width, height );
  #endif
}

HB_FUNC( GDK_WINDOW_GET_TOPLEVELS )
{
  #if GTK_MAJOR_VERSION < 3
    GList * windows = gdk_window_get_toplevels();
  #else
    GList * windows = gdk_screen_get_toplevel_windows( gdk_screen_get_default() );
  #endif
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

//eof
