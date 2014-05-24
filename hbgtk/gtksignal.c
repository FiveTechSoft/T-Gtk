/* $Id: gtksignal.c,v 1.2 2006-11-16 10:07:21 xthefull Exp $*/
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


#if GTK_MAJOR_VERSION < 3

HB_FUNC( G_SIGNAL_EMIT_BY_NAME ) //pWidget, cSignal
{
   GtkWidget * widget = ( GtkWidget * ) hb_parptr( 1 );
   g_signal_emit_by_name( G_OBJECT( widget ), (gchar *) hb_parc( 2 ) );
}

HB_FUNC( G_SIGNAL_STOP_EMISSION_BY_NAME ) //pWidget, cSignal
{
   GtkWidget * widget = ( GtkWidget * ) hb_parptr( 1 );
   g_signal_stop_emission_by_name( G_OBJECT( widget ), (gchar *) hb_parc( 2 ) );
}

HB_FUNC( G_SIGNAL_HANDLER_DISCONNECT )
{
   GtkWidget * widget = GTK_WIDGET( hb_parptr( 1 ) );
   gulong handler_id = hb_parnl( 2 );
   g_signal_handler_disconnect( G_OBJECT( widget ), handler_id );
}

HB_FUNC( HB_G_SIGNAL_HANDLER_DISCONNECT ) // widget, handler_id_signal, cName_Signal
{
   GtkWidget * widget = GTK_WIDGET( hb_parptr( 1 ) );
   gulong handler_id = hb_parnl( 2 );
   gchar *cSignal = (gchar *) hb_parc( 3 );
   
   g_signal_handler_disconnect( G_OBJECT( widget ), handler_id );
   
   if( g_object_get_data( G_OBJECT( widget ), cSignal ) ) 
     {   
       g_object_set_data( G_OBJECT( widget ), cSignal, NULL );
     }
}

#endif
