/* $Id: gtkiconview.c,v 1.1 2006-09-08 12:18:45 xthefull Exp $*/
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
 * GtkIconView. 
 * TODO://
 *  GList*  gtk_icon_view_get_selected_items( GtkIconView *icon_view );
 *  void    gtk_icon_view_selected_foreach  (GtkIconView *icon_view,
 *                                           GtkIconViewForeachFunc func,
 *                                           gpointer data);
 */

#include <gtk/gtk.h>
#include "hbapi.h"

HB_FUNC( GTK_ICON_VIEW_NEW )
{
   GtkWidget * iconlist = gtk_icon_view_new();
   hb_retptr( ( GtkWidget * ) iconlist );
}

HB_FUNC( GTK_ICON_VIEW_NEW_WITH_MODEL )
{
  GtkWidget * iconlist;
  GtkTreeModel * model = GTK_TREE_MODEL( hb_parptr( 1 ) );
  iconlist = gtk_icon_view_new_with_model( model );
  hb_retptr( ( GtkWidget * ) iconlist );
}

HB_FUNC( GTK_ICON_VIEW_SET_MODEL )
{
  GtkIconView  * iconlist = GTK_ICON_VIEW( hb_parptr( 1 ) );
  GtkTreeModel * model    = GTK_TREE_MODEL( hb_parptr( 2 ) );
  gtk_icon_view_set_model( iconlist, model );
}

HB_FUNC( GTK_ICON_VIEW_GET_MODEL )
{
  GtkIconView  * iconlist = GTK_ICON_VIEW( hb_parptr( 1 ) );
  hb_retptr( ( GtkWidget * ) gtk_icon_view_get_model( iconlist ) );
}

HB_FUNC( GTK_ICON_VIEW_SET_TOOLTIP_COLUMN )
{
  GtkIconView  * iconlist = GTK_ICON_VIEW( hb_parptr( 1 ) );
  gtk_icon_view_set_tooltip_column( iconlist, hb_parni( 2 ) );
}

HB_FUNC( GTK_ICON_VIEW_SET_TEXT_COLUMN )
{
  GtkIconView  * iconlist = GTK_ICON_VIEW( hb_parptr( 1 ) );
  gtk_icon_view_set_text_column( iconlist, hb_parni( 2 ) );
}

HB_FUNC( GTK_ICON_VIEW_GET_TEXT_COLUMN )
{
  GtkIconView  * iconlist = GTK_ICON_VIEW( hb_parptr( 1 ) );
  hb_retni( gtk_icon_view_get_text_column( iconlist ) );
}

HB_FUNC( GTK_ICON_VIEW_SET_MARKUP_COLUMN )
{
  GtkIconView  * iconlist = GTK_ICON_VIEW( hb_parptr( 1 ) );
  gtk_icon_view_set_markup_column( iconlist, hb_parni( 2 ) );
}

HB_FUNC( GTK_ICON_VIEW_GET_MARKUP_COLUMN )
{
  GtkIconView  * iconlist = GTK_ICON_VIEW( hb_parptr( 1 ) );
  hb_retni( gtk_icon_view_get_markup_column( iconlist ) );
}

HB_FUNC( GTK_ICON_VIEW_SET_PIXBUF_COLUMN )
{
  GtkIconView  * iconlist = GTK_ICON_VIEW( hb_parptr( 1 ) );
  gtk_icon_view_set_pixbuf_column( iconlist, hb_parni( 2 ) );
}

HB_FUNC( GTK_ICON_VIEW_GET_PIXBUF_COLUMN )
{
  GtkIconView  * iconlist = GTK_ICON_VIEW( hb_parptr( 1 ) );
  hb_retni( gtk_icon_view_get_pixbuf_column( iconlist ) );
}

HB_FUNC( GTK_ICON_VIEW_GET_PATH_AT_POS )
{
  GtkTreePath * path ;
  GtkIconView  * iconlist = GTK_ICON_VIEW( hb_parptr( 1 ) );
  gint x = hb_parni( 2 );
  gint y = hb_parni( 3 );

  path = gtk_icon_view_get_path_at_pos( iconlist, x, y );
  hb_retptr( ( GtkTreePath * ) path );
}

HB_FUNC( GTK_ICON_VIEW_SET_SELECTION_MODE )
{
  GtkIconView  * iconlist = GTK_ICON_VIEW( hb_parptr( 1 ) );
  GtkSelectionMode mode = hb_parni( 2 );
  gtk_icon_view_set_selection_mode( iconlist, mode  );
}

HB_FUNC( GTK_ICON_VIEW_GET_SELECTION_MODE )
{
  GtkIconView  * iconlist = GTK_ICON_VIEW( hb_parptr( 1 ) );
  hb_retni( gtk_icon_view_get_selection_mode( iconlist ) );
}

HB_FUNC( GTK_ICON_VIEW_SET_ORIENTATION )
{
  GtkIconView  * iconlist = GTK_ICON_VIEW( hb_parptr( 1 ) );
  GtkOrientation orientation = hb_parni( 2 );
  gtk_icon_view_set_item_orientation( iconlist, orientation );
}

HB_FUNC( GTK_ICON_VIEW_GET_ORIENTATION )
{
  GtkIconView  * iconlist = GTK_ICON_VIEW( hb_parptr( 1 ) );
  hb_retni( gtk_icon_view_get_item_orientation( iconlist ) );
}

HB_FUNC( GTK_ICON_VIEW_SET_COLUMNS )
{
  GtkIconView  * iconlist = GTK_ICON_VIEW( hb_parptr( 1 ) );
  gint columns = hb_parni( 2 );   
  gtk_icon_view_set_columns( iconlist, columns );
}

HB_FUNC( GTK_ICON_VIEW_GET_COLUMNS )
{
  GtkIconView  * iconlist = GTK_ICON_VIEW( hb_parptr( 1 ) );
  hb_retni( gtk_icon_view_get_columns( iconlist ) );
}

HB_FUNC( GTK_ICON_VIEW_SET_ITEM_WIDTH )
{
  GtkIconView  * iconlist = GTK_ICON_VIEW( hb_parptr( 1 ) );
  gint item_width = hb_parni( 2 );
  gtk_icon_view_set_item_width( iconlist, item_width );
}

HB_FUNC( GTK_ICON_VIEW_GET_ITEM_WIDTH )
{
  GtkIconView  * iconlist = GTK_ICON_VIEW( hb_parptr( 1 ) );
  hb_retni( gtk_icon_view_get_item_width( iconlist ) );
}

HB_FUNC( GTK_ICON_VIEW_SET_SPACING )
{
  GtkIconView  * iconlist = GTK_ICON_VIEW( hb_parptr( 1 ) );
  gint spacing = hb_parni( 2 );
  gtk_icon_view_set_spacing( iconlist, spacing );
}

HB_FUNC( GTK_ICON_VIEW_GET_SPACING )
{
  GtkIconView  * iconlist = GTK_ICON_VIEW( hb_parptr( 1 ) );
  hb_retni( gtk_icon_view_get_spacing( iconlist ) );
}

HB_FUNC( GTK_ICON_VIEW_SET_ROW_SPACING )
{
  GtkIconView  * iconlist = GTK_ICON_VIEW( hb_parptr( 1 ) );
  gint row_spacing = hb_parni( 2 );
  gtk_icon_view_set_row_spacing( iconlist, row_spacing );
}

HB_FUNC( GTK_ICON_VIEW_GET_ROW_SPACING )
{
  GtkIconView  * iconlist = GTK_ICON_VIEW( hb_parptr( 1 ) );
  hb_retni( gtk_icon_view_get_row_spacing( iconlist ) );
}

HB_FUNC( GTK_ICON_VIEW_SET_COLUMN_SPACING )
{
  GtkIconView  * iconlist = GTK_ICON_VIEW( hb_parptr( 1 ) );
  gint column_spacing = hb_parni( 2 );
  gtk_icon_view_set_column_spacing( iconlist ,column_spacing );
}

HB_FUNC( GTK_ICON_VIEW_GET_COLUMN_SPACING )
{
  GtkIconView  * iconlist = GTK_ICON_VIEW( hb_parptr( 1 ) );
  hb_retni( gtk_icon_view_get_column_spacing( iconlist ) );
}

HB_FUNC( GTK_ICON_VIEW_SET_MARGIN )
{
  GtkIconView  * iconlist = GTK_ICON_VIEW( hb_parptr( 1 ) );
  gint margin = hb_parni( 2 );
  gtk_icon_view_set_margin( iconlist, margin );
}

HB_FUNC( GTK_ICON_VIEW_GET_MARGIN )
{
  GtkIconView  * iconlist = GTK_ICON_VIEW( hb_parptr( 1 ) );
  hb_retni( gtk_icon_view_get_margin( iconlist ) );
}

HB_FUNC( GTK_ICON_VIEW_SELECT_PATH )
{
  GtkIconView  * iconlist = GTK_ICON_VIEW( hb_parptr( 1 ) );
  GtkTreePath * path = (GtkTreePath *) hb_parptr( 2 ) ;
  gtk_icon_view_select_path( iconlist, path );
}

HB_FUNC( GTK_ICON_VIEW_UNSELECT_PATH )
{
  GtkIconView  * iconlist = GTK_ICON_VIEW( hb_parptr( 1 ) );
  GtkTreePath * path = (GtkTreePath *) hb_parptr( 2 ) ;
  gtk_icon_view_unselect_path( iconlist, path );
}

HB_FUNC( GTK_ICON_VIEW_PATH_IS_SELECTED )
{
  GtkIconView  * iconlist = GTK_ICON_VIEW( hb_parptr( 1 ) );
  GtkTreePath * path = (GtkTreePath *) hb_parptr( 2 ) ;
  hb_retl( gtk_icon_view_path_is_selected( iconlist, path ) );
}

HB_FUNC( GTK_ICON_VIEW_SELECT_ALL )
{
  GtkIconView  * iconlist = GTK_ICON_VIEW( hb_parptr( 1 ) );
  gtk_icon_view_select_all( iconlist );
}

HB_FUNC( GTK_ICON_VIEW_UNSELECT_ALL )
{
  GtkIconView  * iconlist = GTK_ICON_VIEW( hb_parptr( 1 ) );
  gtk_icon_view_unselect_all( iconlist );
}

HB_FUNC( GTK_ICON_VIEW_ITEM_ACTIVATED )
{
  GtkIconView  * iconlist = GTK_ICON_VIEW( hb_parptr( 1 ) );
  GtkTreePath * path = (GtkTreePath *) hb_parptr( 2 ) ;
  gtk_icon_view_item_activated( iconlist, path );
}

HB_FUNC( GTK_ICON_VIEW_GET_CURSOR )
{
  GtkIconView  * iconlist = GTK_ICON_VIEW( hb_parptr( 1 ) );
  GtkTreePath * path; 
  GtkCellRenderer * cell; 
  gboolean bret;

  bret = gtk_icon_view_get_cursor( iconlist, &path, &cell );
  hb_storptr( (gpointer) path , 2);
  hb_storptr( (gpointer) cell , 3);
  hb_retl( bret );
}

//eof
