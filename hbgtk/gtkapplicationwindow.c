/* $Id: gtkapplicationwindow.c,v 1.8 2022-07-26 01:00:44 riztan Exp $*/
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
    (c)2022 Riztan Gutierrez <riztan@gmail.com>
*/
#include <gtk/gtk.h>
#include "hbapi.h"


HB_FUNC( GTK_APPLICATION_WINDOW_NEW )
{
   GtkApplication * application = hb_parptr( 1 );
   GtkWidget * widget = gtk_application_window_new( application );
   hb_retptr( widget );
}


HB_FUNC( GTK_APPLICATION_WINDOW_GET_HELP_OVERLAY )
{
   GtkApplicationWindow * window = hb_parptr( 1 );
   GtkShortcutsWindow * shortcut = gtk_application_window_get_help_overlay( window );
   hb_retptr( shortcut );
}


HB_FUNC( GTK_APPLICATION_WINDOW_GET_ID )
{
   GtkApplicationWindow * window = hb_parptr( 1 );
   hb_retnd( gtk_application_window_get_id( window ) );
}


HB_FUNC( GTK_APPLICATION_WINDOW_GET_SHOW_MENUBAR )
{
   GtkApplicationWindow * window = hb_parptr( 1 );
   hb_retl( gtk_application_window_get_show_menubar( window ) );
}


HB_FUNC( GTK_APPLICATION_WINDOW_SET_HELP_OVERLAY )
{
   GtkApplicationWindow * window = hb_parptr( 1 );
   GtkShortcutsWindow* help_overlay = hb_parptr( 2 );
   gtk_application_window_set_help_overlay( window, help_overlay );
}


HB_FUNC( GTK_APPLICATION_WINDOW_SET_SHOW_MENUBAR )
{
   GtkApplicationWindow * window = hb_parptr( 1 );
   gboolean show_menubar = hb_parl( 2 );
   gtk_application_window_set_show_menubar( window, show_menubar );
}


//eof
