/* $Id: gtklist.c,v 1.1 2006-09-08 12:18:45 xthefull Exp $*/
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

#ifdef _GTK2_

HB_FUNC( GTK_LIST_NEW ) //->widget
{
   GtkWidget * hWnd = gtk_list_new( );
   hb_retptr( ( GtkWidget *  ) hWnd );
}

HB_FUNC( GTK_LIST_SET_SELECTION_MODE )
{
  GtkWidget * list = GTK_WIDGET( hb_parptr( 1 ) );
  gtk_list_set_selection_mode( GTK_LIST( list) , hb_parni( 2 ) );

}

HB_FUNC( GTK_LIST_SELECT_ITEM )
{
  GtkWidget * list = GTK_WIDGET( hb_parptr( 1 ) );
  gtk_list_select_item( GTK_LIST( list) , hb_parni( 2 ) );
}

HB_FUNC( GTK_LIST_ITEM_NEW_WITH_LABEL ) //->widget
{
   GtkWidget * hWnd = gtk_list_item_new_with_label( hb_parc( 1 ) );
   hb_retptr( ( GtkWidget *  ) hWnd );
}

HB_FUNC( GTK_LIST_CHILD_POSITION )
{
  GtkWidget * list = GTK_WIDGET( hb_parptr( 1 ) );
  GtkWidget * child = GTK_WIDGET( hb_parptr( 2 ) );
  hb_retni(  gtk_list_child_position ( GTK_LIST(list), child ) );
}

HB_FUNC( GTK_LIST_CLEAR_ITEMS )
{
  GtkWidget * list = GTK_WIDGET( hb_parptr( 1 ) );
  gint start = hb_parni( 2 );
  gint end =   hb_parni( 3 );
  gtk_list_clear_items( GTK_LIST(list), start, end ) ;
}

#endif
