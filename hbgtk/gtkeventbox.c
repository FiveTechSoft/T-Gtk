/* $Id: gtkeventbox.c,v 1.1 2006-09-08 12:18:45 xthefull Exp $*/
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
#include <gtk/gtk.h>
#include "hbapi.h"

HB_FUNC( GTK_EVENT_BOX_NEW )
{
   GtkWidget * widget = gtk_event_box_new();
   hb_retptr( ( GtkWidget *  ) widget );
}

HB_FUNC( GTK_EVENT_BOX_SET_ABOVE_CHILD )
{
   GtkWidget * widget = GTK_WIDGET( hb_parptr( 1 ) );
   gboolean above_child = hb_parl( 2 );
   gtk_event_box_set_above_child( GTK_EVENT_BOX( widget ), above_child );
}

HB_FUNC( GTK_EVENT_BOX_GET_ABOVE_CHILD )
{
   GtkWidget * widget = GTK_WIDGET( hb_parptr( 1 ) );
   hb_retl( gtk_event_box_get_above_child( GTK_EVENT_BOX( widget ) ) );

}

HB_FUNC( GTK_EVENT_BOX_SET_VISIBLE_WINDOW )
{
   GtkWidget * widget = GTK_WIDGET( hb_parptr( 1 ) );
   gboolean visible= hb_parl( 2 );
   gtk_event_box_set_visible_window( GTK_EVENT_BOX( widget ), visible );
}

HB_FUNC( GTK_EVENT_BOX_GET_VISIBLE_WINDOW )
{
   GtkWidget * widget = GTK_WIDGET( hb_parptr( 1 ) );
   hb_retl( gtk_event_box_get_visible_window( GTK_EVENT_BOX( widget ) ) );
}
