/* $Id: gtktree.c,v 1.1 2006-09-08 12:18:45 xthefull Exp $*/
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
 * Atencion, para hacer uso de los Tree, hay que meterle este define
 * ESTO ES DEPRECATED. NO DEBERIA USARSE
 */
#define GTK_ENABLE_BROKEN

#include <gtk/gtk.h>
#include "hbapi.h"

#if GTK_MAJOR_VERSION < 3
HB_FUNC( GTK_TREE_NEW )
{
  GtkWidget *tree = gtk_tree_new();
  hb_retptr( ( GtkWidget * ) tree);
}

HB_FUNC( GTK_TREE_APPEND )
{
  GtkTree * tree = GTK_TREE( hb_parptr( 1 ) );
  GtkWidget * tree_item = GTK_WIDGET( hb_parptr( 2 ) );
  gtk_tree_append( tree, tree_item );
}

HB_FUNC( GTK_TREE_PREPEND )
{
  GtkTree * tree = GTK_TREE( hb_parptr( 1 ) );
  GtkWidget * tree_item = GTK_WIDGET( hb_parptr( 2 ) );
  gtk_tree_prepend( tree, tree_item );
}

HB_FUNC( GTK_TREE_INSERT )
{
  GtkTree * tree = GTK_TREE( hb_parptr( 1 ) );
  GtkWidget * tree_item = GTK_WIDGET( hb_parptr( 2 ) );
  gtk_tree_insert( tree, tree_item, (gint) hb_parni( 3 ) );
}

HB_FUNC( GTK_TREE_REMOVE_ITEMS )
{
  GtkTree * tree = GTK_TREE( hb_parptr( 1 ) );
  GList * items =  ( GList * ) hb_parptr( 2 ) ;
  gtk_tree_remove_items( tree, items );
}

HB_FUNC( GTK_TREE_CLEAR_ITEMS )
{
  GtkTree * tree = GTK_TREE( hb_parptr( 1 ) );
  gint start = hb_parni( 2 );
  gint end = hb_parni( 3 );
  gtk_tree_clear_items( tree, start, end);
}

HB_FUNC( GTK_TREE_SELECT_ITEM )
{
  GtkTree * tree = GTK_TREE( hb_parptr( 1 ) );
  gint item = hb_parni( 2 );
  gtk_tree_select_item( tree, item);
}

HB_FUNC( GTK_TREE_UNSELECT_ITEM )
{
  GtkTree * tree = GTK_TREE( hb_parptr( 1 ) );
  gint item = hb_parni( 2 );
  gtk_tree_unselect_item( tree, item);
}

HB_FUNC( GTK_TREE_SELECT_CHILD )
{
  GtkTree * tree = GTK_TREE( hb_parptr( 1 ) );
  GtkWidget * tree_item = GTK_WIDGET( hb_parnl( 2 ) );
  gtk_tree_select_child( tree, tree_item );
}

HB_FUNC( GTK_TREE_UNSELECT_CHILD )
{
  GtkTree * tree = GTK_TREE( hb_parptr( 1 ) );
  GtkWidget * tree_item = GTK_WIDGET( hb_parptr( 2 ) );
  gtk_tree_unselect_child( tree, tree_item );
}

HB_FUNC( GTK_TREE_CHILD_POSITION )
{
  GtkTree * tree = GTK_TREE( hb_parptr( 1 ) );
  GtkWidget * child = GTK_WIDGET( hb_parptr( 2 ) );
  hb_retni( gtk_tree_child_position( tree, child ) );
}

HB_FUNC( GTK_TREE_SET_SELECTION_MODE )
{
  GtkTree * tree = GTK_TREE( hb_parptr( 1 ) );
  gtk_tree_set_selection_mode( tree, hb_parni( 2 ) );
}

HB_FUNC( GTK_TREE_SET_VIEW_MODE )
{
  GtkTree * tree = GTK_TREE( hb_parptr( 1 ) );
  gtk_tree_set_view_mode( tree, hb_parni( 2 ) );
}

HB_FUNC( GTK_TREE_SET_VIEW_LINE )
{
  GtkTree * tree = GTK_TREE( hb_parptr( 1 ) );
  gtk_tree_set_view_mode( tree, hb_parl( 2 ) );
}

HB_FUNC( GTK_TREE_REMOVE_ITEM )
{
  GtkTree * tree = GTK_TREE( hb_parptr( 1 ) );
  GtkWidget * child = GTK_WIDGET( hb_parptr( 2 ) );
  gtk_tree_remove_item( tree, child );
}

/*
 * API GtkTreeItem
 *
 */
HB_FUNC( GTK_TREE_ITEM_NEW )
{
  GtkWidget * tree_item = gtk_tree_item_new();
  hb_retptr( ( GtkWidget * ) tree_item );
}

HB_FUNC( GTK_TREE_ITEM_NEW_WITH_LABEL )
{
  GtkWidget *tree_item = gtk_tree_item_new_with_label( (gchar *)hb_parc( 1 ) );
  hb_retptr( ( GtkWidget * ) tree_item );
}

HB_FUNC( GTK_TREE_ITEM_SET_SUBTREE )
{
  GtkTreeItem * tree_item = GTK_TREE_ITEM( hb_parptr( 1 ) );
  GtkWidget * subtree = GTK_WIDGET( hb_parptr( 2 ) );
  gtk_tree_item_set_subtree( tree_item, subtree );
}
#endif
/*
void        gtk_tree_item_remove_subtree    (GtkTreeItem *tree_item);
void        gtk_tree_item_select            (GtkTreeItem *tree_item);
void        gtk_tree_item_deselect          (GtkTreeItem *tree_item);
void        gtk_tree_item_expand            (GtkTreeItem *tree_item);
void        gtk_tree_item_collapse          (GtkTreeItem *tree_item);
   */
