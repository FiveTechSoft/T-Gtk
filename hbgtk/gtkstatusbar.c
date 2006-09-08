/* $Id: gtkstatusbar.c,v 1.1 2006-09-08 12:18:45 xthefull Exp $*/
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


HB_FUNC( GTK_STATUSBAR_NEW ) // -> widget
{
   GtkWidget * statusbar = gtk_statusbar_new( );
   hb_retnl( (ULONG) statusbar );
}

HB_FUNC( GTK_STATUSBAR_GET_CONTEXT_ID ) // pStatusbar, cContext --> ID_Context
{
   GtkWidget * statusbar = GTK_WIDGET( hb_parnl( 1 ) );
   hb_parni( (guint)  gtk_statusbar_get_context_id ( GTK_STATUSBAR( statusbar ) , (gchar *) hb_parc( 2 ) ) );
}

HB_FUNC( GTK_STATUSBAR_PUSH ) // pStatusbar, ID_Context , cText --> ID_Msg
{
   GtkWidget * statusbar = GTK_WIDGET( hb_parnl( 1 ) );
   hb_parni( (guint)  gtk_statusbar_push( GTK_STATUSBAR( statusbar ) , (guint) hb_parni( 2 ) ,(gchar*) hb_parc( 3 ) ) );
}

HB_FUNC( GTK_STATUSBAR_POP ) // pStatusbar, ID_Context 
{
   GtkWidget * statusbar = GTK_WIDGET( hb_parnl( 1 ) );
   guint id = (guint) hb_parni( 2 );	
   gtk_statusbar_pop( GTK_STATUSBAR( statusbar ), id );
}

HB_FUNC( GTK_STATUSBAR_REMOVE ) // pStatusbar, ID_Context , ID_Msg
{
   GtkWidget * statusbar = GTK_WIDGET( hb_parnl( 1 ) );
   guint id  = (guint) hb_parni( 2 );	
   guint msg = (guint) hb_parni( 3 );
   gtk_statusbar_remove( GTK_STATUSBAR( statusbar ), id , msg );
}

HB_FUNC( GTK_STATUSBAR_SET_HAS_RESIZE_GRIP ) // pStatusbar, bSetting
{
   GtkWidget * statusbar = GTK_WIDGET( hb_parnl( 1 ) );
   gtk_statusbar_set_has_resize_grip( GTK_STATUSBAR( statusbar ),hb_parl( 2 ) );
}


HB_FUNC( GTK_STATUSBAR_GET_HAS_RESIZE_GRIP ) // pStatusbar -> bResize
{
   GtkWidget * statusbar = GTK_WIDGET( hb_parnl( 1 ) );
   hb_retl( gtk_statusbar_get_has_resize_grip( GTK_STATUSBAR( statusbar ) ) );
}
