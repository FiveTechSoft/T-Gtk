/* $Id: gtktoolbar.c,v 1.2 2007-05-03 10:10:19 xthefull Exp $*/
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

#if GTK_CHECK_VERSION(2,4,0) 

HB_FUNC( GTK_TOOLBAR_NEW ) 
{
   GtkWidget * toolbar = gtk_toolbar_new( );
   hb_retptr( ( GtkWidget * ) toolbar );
}
HB_FUNC( GTK_TOOLBAR_INSERT ) // tool, item, nPos = 0 Preend, -1 AddEnd
{
   GtkWidget * toolbar = GTK_WIDGET( hb_parptr( 1 ) );
   GtkToolItem * item = GTK_TOOL_ITEM( hb_parptr( 2 ) );
   gtk_toolbar_insert (GTK_TOOLBAR (toolbar), item , hb_parni( 3 ) );
}

HB_FUNC( GTK_TOOLBAR_SET_STYLE )
{
   GtkWidget * toolbar = GTK_WIDGET( hb_parptr( 1 ) );
   gtk_toolbar_set_style( GTK_TOOLBAR( toolbar ), hb_parni( 2 ) );
}

HB_FUNC( GTK_TOOLBAR_SET_SHOW_ARROW ) // toolbar, bShow
{
  GtkWidget * toolbar = GTK_WIDGET( hb_parptr( 1 ) );
  gtk_toolbar_set_show_arrow( GTK_TOOLBAR( toolbar ), hb_parl( 2 ) );
}
    
HB_FUNC( GTK_TOOLBAR_SET_ORIENTATION ) // toolbar, bOrientation, ( 0 horizontally , 1 vertically )
{    
  GtkWidget * toolbar = GTK_WIDGET( hb_parptr( 1 ) );
  gtk_toolbar_set_orientation( GTK_TOOLBAR( toolbar ), hb_parni( 2 ) );
}
/* --------------------------------------------------------------------------
// GtkToolItems____
--------------------------------------------------------------------------  */
HB_FUNC( GTK_TOOL_ITEM_NEW )
{
   GtkToolItem * tool = gtk_tool_item_new();
   hb_retptr( ( GtkToolItem * ) tool );
}

HB_FUNC( GTK_TOOL_ITEM_SET_HOMOGENEOUS ) // ITEM, bhomogeneous
{
  GtkToolItem * item = GTK_TOOL_ITEM( hb_parptr( 1 ) );
  gtk_tool_item_set_homogeneous( item, hb_parl( 2 ) );
}

HB_FUNC( GTK_TOOL_ITEM_GET_HOMOGENEOUS ) // ITEM--> bHomogeneous
{
  GtkToolItem * item = GTK_TOOL_ITEM( hb_parptr( 1 ) );
  hb_retl(  gtk_tool_item_get_homogeneous( item ) );
}

HB_FUNC( GTK_TOOL_ITEM_SET_EXPAND ) // ITEM, bExpand
{
   GtkToolItem * item = GTK_TOOL_ITEM( hb_parptr( 1 ) );
   gtk_tool_item_set_expand ( item , hb_parl( 2 ) );
}

HB_FUNC( GTK_TOOL_ITEM_GET_EXPAND ) // ITEM -->bExpand
{
   GtkToolItem * item = GTK_TOOL_ITEM( hb_parptr( 1 ) );
   hb_retl( gtk_tool_item_get_expand( item ) );
}


// gtk_tool_item_set_tooltip has been deprecated since version 2.12 and should not be used in newly-written code. 
// Use gtk_tool_item_set_tooltip_text() instead.
HB_FUNC( GTK_TOOL_ITEM_SET_TOOLTIP ) // GtkToolItem, Gtktooltip, tip_Text, tip_private
{
   GtkToolItem * item = GTK_TOOL_ITEM( hb_parptr( 1 ) );
   GtkTooltips * tooltips = GTK_TOOLTIPS( hb_parptr( 2 ) );
   gtk_tool_item_set_tooltip ( item, tooltips, (gchar *) hb_parc( 3 ), (gchar *) hb_parc( 4 ) ) ;
}

HB_FUNC( GTK_TOOL_ITEM_SET_TOOLTIP_TEXT ) // GtkToolItem, tip_Text
{
   GtkToolItem * item = GTK_TOOL_ITEM( hb_parptr( 1 ) );
   gtk_tool_item_set_tooltip_text( item, (gchar *) hb_parc( 2 ) );
}



/* --------------------------------------------------------------------------
 * GtkToolButton Implementation. 
 * --------------------------------------------------------------------------*/
HB_FUNC( GTK_TOOL_BUTTON_NEW ) // Widget Icon(NULL), label( or NULL )
{
   GtkToolItem * tool = NULL;
   GtkWidget * icon_widget = NULL;
   gchar * text = NULL;
   
   hb_parptr( 1 ) ? icon_widget = GTK_WIDGET( hb_parptr( 1 ) ) : NULL ;
   hb_parc( 2 )  ? text = ( gchar * ) hb_parc( 2 ) : NULL;

   tool = gtk_tool_button_new( icon_widget, text );
   hb_retptr( ( GtkToolItem * ) tool );
}

HB_FUNC( GTK_TOOL_BUTTON_NEW_FROM_STOCK )
{
   GtkToolItem * tool = gtk_tool_button_new_from_stock( hb_parc( 1 ) );
   hb_retptr( ( GtkToolItem * ) tool );
}

HB_FUNC( GTK_TOOL_BUTTON_SET_LABEL ) // toolbutton, label
{
   GtkToolButton * button = GTK_TOOL_BUTTON( hb_parptr( 1 ) );
   gtk_tool_button_set_label( button, (gchar *) hb_parc( 2 ) );
}

HB_FUNC( GTK_TOOL_BUTTON_GET_LABEL ) // toolbutton --> clabel
{
   GtkToolButton * button = GTK_TOOL_BUTTON( hb_parptr( 1 ) );
   hb_retc( (gchar*) gtk_tool_button_get_label( button ) );
}

HB_FUNC( GTK_TOOL_BUTTON_SET_USE_UNDERLINE ) //toolbutton, bUse_underline
{
   GtkToolButton * button = GTK_TOOL_BUTTON( hb_parptr( 1 ) );
   gtk_tool_button_set_use_underline(  button , hb_parl( 2 ) );
}

HB_FUNC( GTK_TOOL_BUTTON_GET_USE_UNDERLINE ) //toolbutton --> bUse_underline
{
   GtkToolButton * button = GTK_TOOL_BUTTON( hb_parptr( 1 ) );
   hb_retl( gtk_tool_button_get_use_underline( button ) );
}

HB_FUNC( GTK_TOOL_BUTTON_SET_STOCK_ID ) // toolbutton, stock_id
{
   GtkToolButton * button = GTK_TOOL_BUTTON( hb_parptr( 1 ) );
   gtk_tool_button_set_stock_id( button, (gchar*)hb_parc( 2 ) );
}

HB_FUNC( GTK_TOOL_BUTTON_GET_STOCK_ID ) // toolbutton
{
   GtkToolButton * button = GTK_TOOL_BUTTON( hb_parptr( 1 ) );
   hb_retc( (gchar *) gtk_tool_button_get_stock_id( button ) );
}

HB_FUNC( GTK_TOOL_BUTTON_SET_ICON_WIDGET ) // toolbutton, icon_widget
{
   GtkToolButton * button  = GTK_TOOL_BUTTON( hb_parptr( 1 ) );
   GtkWidget * icon_widget = GTK_WIDGET( hb_parptr( 2 )  );
   gtk_tool_button_set_icon_widget( button, icon_widget );
}

HB_FUNC( GTK_TOOL_BUTTON_GET_ICON_WIDGET ) // toolbutton --> icon_widget
{
  GtkToolButton * button  = GTK_TOOL_BUTTON( hb_parptr( 1 ) );	
  hb_retptr( ( GtkToolButton * ) gtk_tool_button_get_icon_widget( button ) );
}

HB_FUNC( GTK_TOOL_BUTTON_SET_LABEL_WIDGET ) // button, label_widget
{
  GtkToolButton * button  = GTK_TOOL_BUTTON( hb_parptr( 1 ) );	
  GtkWidget * label = GTK_WIDGET( hb_parptr( 2 )  );
  gtk_tool_button_set_label_widget( button, label );
}

HB_FUNC( GTK_TOOL_BUTTON_GET_LABEL_WIDGET ) // button -> label_widget
{
  GtkToolButton * button  = GTK_TOOL_BUTTON( hb_parptr( 1 ) );	
  hb_retptr( ( GtkToolButton * ) gtk_tool_button_get_label_widget( button ) );
}

/* --------------------------------------------------------------------------*/
/* GtkToggleToolButton Implementation */
/* --------------------------------------------------------------------------*/
HB_FUNC( GTK_TOGGLE_TOOL_BUTTON_NEW )
{
   GtkToolItem * tool = gtk_toggle_tool_button_new( );
   hb_retptr( ( GtkToolItem * ) tool );
}

HB_FUNC( GTK_TOGGLE_TOOL_BUTTON_NEW_FROM_STOCK )
{
   GtkToolItem * tool = gtk_toggle_tool_button_new_from_stock( hb_parc( 1 ) );
   hb_retptr( ( GtkToolItem * ) tool );
}

HB_FUNC( GTK_TOGGLE_TOOL_BUTTON_SET_ACTIVE ) // Item, bActive
{
   GtkToolItem * item = GTK_TOOL_ITEM( hb_parptr( 1 ) ) ;
   gtk_toggle_tool_button_set_active( GTK_TOGGLE_TOOL_BUTTON( item ), hb_parl( 2 ) );
}

HB_FUNC( GTK_TOGGLE_TOOL_BUTTON_GET_ACTIVE ) // Item
{
   GtkToolItem * item =  GTK_TOOL_ITEM( hb_parptr( 1 ) );
   hb_retl( gtk_toggle_tool_button_get_active( GTK_TOGGLE_TOOL_BUTTON( item ) ) );
}

/* --------------------------------------------------------------------------*/
/* GtkRadioToolButton */
/* --------------------------------------------------------------------------*/

HB_FUNC( GTK_RADIO_TOOL_BUTTON_NEW )
{
   GtkToolItem * radio = gtk_radio_tool_button_new( ( GSList * ) hb_parptr( 1 )  );
   hb_retptr( ( GtkToolItem * ) radio );
}

HB_FUNC( GTK_RADIO_TOOL_BUTTON_NEW_FROM_STOCK )
{
   GtkToolItem * radio = gtk_radio_tool_button_new_from_stock( ( GSList * ) hb_parptr( 1 ), 
                                                      ( gchar * ) hb_parc( 2 ) );	  
   hb_retptr( ( GtkToolItem * ) radio );
}

HB_FUNC( GTK_RADIO_TOOL_BUTTON_NEW_FROM_WIDGET )
{
   GtkRadioToolButton * group	= GTK_RADIO_TOOL_BUTTON( hb_parptr( 1 ) );
   GtkToolItem * radio = gtk_radio_tool_button_new_from_widget( group );
   hb_retptr( ( GtkToolItem * ) radio );
}

HB_FUNC( GTK_RADIO_TOOL_BUTTON_GET_GROUP )
{
  GtkRadioToolButton * radio = GTK_RADIO_TOOL_BUTTON( hb_parptr( 1 ) );
  GSList*    group = gtk_radio_tool_button_get_group( radio ) ;
  hb_retptr( ( GtkRadioToolButton * ) group );
}

HB_FUNC( GTK_RADIO_TOOL_BUTTON_SET_GROUP )
{
  GtkRadioToolButton * radio = GTK_RADIO_TOOL_BUTTON( hb_parptr( 1 ) );
  GSList * group = ( GSList * ) hb_parptr( 2 );
  gtk_radio_tool_button_set_group( radio , group );
}

HB_FUNC( GTK_RADIO_TOOL_BUTTON_NEW_WITH_STOCK_FROM_WIDGET ) // radio , stock_id
{
  GtkRadioToolButton * group = GTK_RADIO_TOOL_BUTTON( hb_parptr( 1 ) );
  GtkToolItem * radio = gtk_radio_tool_button_new_with_stock_from_widget( group, (gchar *) hb_parc( 2 ) );
  hb_retptr( ( GtkRadioToolButton * ) radio );
}

/* --------------------------------------------------------------------------*/
/* GtkSeparatorToolItem */
/* --------------------------------------------------------------------------*/
HB_FUNC( GTK_SEPARATOR_TOOL_ITEM_NEW )
{
  GtkToolItem * separator = gtk_separator_tool_item_new();
  hb_retptr( ( GtkToolItem * ) separator );
}

HB_FUNC( GTK_SEPARATOR_TOOL_ITEM_SET_DRAW )
{
  GtkSeparatorToolItem * separator = GTK_SEPARATOR_TOOL_ITEM( hb_parptr( 1 ) );
  gtk_separator_tool_item_set_draw( separator, hb_parl( 2 ) );
}

HB_FUNC( GTK_SEPARATOR_TOOL_ITEM_GET_DRAW )
{
  GtkSeparatorToolItem * separator = GTK_SEPARATOR_TOOL_ITEM( hb_parptr( 1 ) );
  hb_retl(  gtk_separator_tool_item_get_draw( separator ) );
}

/* --------------------------------------------------------------------------*/
/* GtkMenuToolButton*/
/* --------------------------------------------------------------------------*/
HB_FUNC( GTK_MENU_TOOL_BUTTON_NEW )
{
  GtkToolItem * menutool;
  GtkWidget *icon = ISNIL( 1 ) ? NULL : GTK_WIDGET( hb_parptr( 1 ) );
  gchar * label = ISNIL( 2 ) ? NULL : ( gchar * ) hb_parc( 2 );
  menutool = gtk_menu_tool_button_new( icon, label );
  hb_retptr( ( GtkToolItem * ) menutool );
}

HB_FUNC( GTK_MENU_TOOL_BUTTON_NEW_FROM_STOCK )
{
  GtkToolItem * menutool;
  gchar * stock_id = ( gchar * ) hb_parc( 1 );
  menutool = gtk_menu_tool_button_new_from_stock( stock_id );
  hb_retptr( ( GtkToolItem * ) menutool );
}

HB_FUNC( GTK_MENU_TOOL_BUTTON_SET_MENU )
{
  GtkMenuToolButton * button = GTK_MENU_TOOL_BUTTON( hb_parptr( 1 ) );;
  GtkWidget * menu = GTK_WIDGET( hb_parptr( 2 ) );
  gtk_menu_tool_button_set_menu( button, menu );
}

HB_FUNC( GTK_MENU_TOOL_BUTTON_GET_MENU )
{
  GtkMenuToolButton * button = GTK_MENU_TOOL_BUTTON( hb_parptr( 1 ) );;
  GtkWidget * menu = gtk_menu_tool_button_get_menu( button );
  hb_retptr( ( GtkMenuToolButton * ) menu );
}

#else
#endif
