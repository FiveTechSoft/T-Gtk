/* $Id: gdauidataproxy.c,v 1 2012-07-31 06:00:15 riztan Exp $*/
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
    (c)2008 Rafael Carmona <rafa.tgtk at gmail.com>
    (c)2012 Riztan Gutierrez <riztan at t-gtk.org>
*/
#include <hbapi.h>

#ifdef _GDA_
#include <gtk/gtk.h>
#include <libgda/libgda.h>
#include <libgda-ui/libgda-ui.h>


HB_FUNC( GDAUI_DATA_PROXY_GET_PROXY ) 
{
   GdaDataProxy * dataproxy;
   GdauiDataProxy * iface = hb_parptr( 1 );
   
   dataproxy = gdaui_data_proxy_get_proxy( iface );
   hb_retptr( dataproxy );
}


HB_FUNC( GDAUI_DATA_PROXY_GET_ACTIONS_GROUP ) 
{
   GtkActionGroup * actiongroup;
   GdauiDataProxy * iface = hb_parptr( 1 );
   
   actiongroup = gdaui_data_proxy_get_actions_group( iface );
   hb_retptr( actiongroup );
}


HB_FUNC( GDAUI_DATA_PROXY_PERFORM_ACTION ) 
{
   GdauiDataProxy * iface = hb_parptr( 1 );
   gint action = hb_parni( 2 );

   gdaui_data_proxy_perform_action( iface, action );
}


HB_FUNC( GDAUI_DATA_PROXY_COLUMN_SET_EDITABLE ) 
{
   GdauiDataProxy * iface = hb_parptr( 1 );
   gint column = hb_parni( 2 );
   gboolean editable = hb_parl( 3 );

   gdaui_data_proxy_column_set_editable( iface, column, editable );
}


HB_FUNC( GDAUI_DATA_PROXY_COLUMN_SHOW_ACTIONS ) 
{
   GdauiDataProxy * iface = hb_parptr( 1 );
   gint column = hb_parni( 2 );
   gboolean show_actions = hb_parl( 3 );

   gdaui_data_proxy_column_show_actions( iface, column, show_actions );
}


HB_FUNC( GDAUI_DATA_PROXY_SET_WRITE_MODE ) 
{
   GdauiDataProxy * iface = hb_parptr( 1 );
   gint mode = hb_parni( 2 );

   hb_retl( gdaui_data_proxy_set_write_mode( iface, mode ) );
}


HB_FUNC( GDAUI_DATA_PROXY_GET_WRITE_MODE ) 
{
   GdauiDataProxy * iface = hb_parptr( 1 );

   hb_retni( gdaui_data_proxy_get_write_mode( iface ) );
}


#endif

//eof
