/* $Id: gdauidataselector.c,v 1 2012-07-31 05:46:31 riztan Exp $*/
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
#include <libgda/libgda.h>
#include <libgda-ui/libgda-ui.h>


HB_FUNC( GDAUI_DATA_SELECTOR_GET_MODEL ) 
{
   GdaDataModel * datamodel;
   GdauiDataSelector * iface = hb_parptr( 1 );
   
   datamodel = gdaui_data_selector_get_model( iface );
   hb_retptr( datamodel );
}


HB_FUNC( GDAUI_DATA_SELECTOR_SET_MODEL ) 
{
   GdauiDataSelector * iface = hb_parptr( 1 );
   GdaDataModel * datamodel = hb_parptr( 2 );
   
   gdaui_data_selector_set_model( iface, datamodel );
}


HB_FUNC( GDAUI_DATA_SELECTOR_GET_SELECTED_ROWS ) 
{
   GdauiDataSelector * iface = hb_parptr( 1 );

   hb_retptr( gdaui_data_selector_get_selected_rows( iface ) );
   //TODO: retornar arreglo...
}


HB_FUNC( GDAUI_DATA_SELECTOR_GET_DATA_SET ) 
{
   GdauiDataSelector * iface = hb_parptr( 1 );

   hb_retptr( gdaui_data_selector_get_data_set( iface ) );
}


HB_FUNC( GDAUI_DATA_SELECTOR_SELECT_ROW ) 
{
   GdauiDataSelector * iface = hb_parptr( 1 );
   gint row = hb_parni( 2 );

   hb_parl( gdaui_data_selector_select_row( iface, row ) );
}


HB_FUNC( GDAUI_DATA_SELECTOR_UNSELECT_ROW ) 
{
   GdauiDataSelector * iface = hb_parptr( 1 );
   gint row = hb_parni( 2 );

   gdaui_data_selector_unselect_row( iface, row );
}


HB_FUNC( GDAUI_DATA_SELECTOR_SET_COLUMN_VISIBLE ) 
{
   GdauiDataSelector * iface = hb_parptr( 1 );
   gint column = hb_parni( 2 );
   gboolean visible = hb_parl( 3 );

   gdaui_data_selector_set_column_visible( iface, column, visible );
}
#endif

//eof
