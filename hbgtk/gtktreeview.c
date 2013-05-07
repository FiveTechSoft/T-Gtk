/* $Id: gtktreeview.c,v 1.3 2010-02-09 04:22:04 riztan Exp $*/
/*
 * GtkTreeView. List browses y Trees -----------------------------------------
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


HB_FUNC( GTK_TREE_VIEW_NEW )
{
   GtkWidget * tree = gtk_tree_view_new();
   hb_retptr( ( GtkWidget * ) tree );
}

//------------------------------------------------------//

HB_FUNC( GTK_TREE_VIEW_NEW_WITH_MODEL ) // model --> widget
{
   GtkWidget * tree =  gtk_tree_view_new_with_model ( GTK_TREE_MODEL( hb_parptr( 1 ) ) );
   hb_retptr( ( GtkWidget * ) tree );
}

//------------------------------------------------------//

HB_FUNC( GTK_TREE_VIEW_SET_MODEL ) // treeview, model -> void
{
   GtkTreeView * tree   = GTK_TREE_VIEW( hb_parptr( 1 ) );
   GtkTreeModel * model = ISNIL( 2 ) ? NULL : GTK_TREE_MODEL( hb_parptr( 2 )  );
   gtk_tree_view_set_model( tree , model );
}

//------------------------------------------------------//

HB_FUNC( GTK_TREE_VIEW_SET_RULES_HINT ) // treeview -> void
{
  gtk_tree_view_set_rules_hint(GTK_TREE_VIEW ( GTK_WIDGET( hb_parptr( 1 ) ) ), 
                               (gboolean) hb_parl( 2 ) );
}

//------------------------------------------------------//

HB_FUNC( GTK_TREE_VIEW_APPEND_COLUMN ) // treeview, column -> void
{
   gtk_tree_view_append_column( GTK_TREE_VIEW ( GTK_WIDGET( hb_parptr( 1 ) )),
                                GTK_TREE_VIEW_COLUMN( ( GtkTreeViewColumn * ) hb_parptr( 2 )) );
}

//------------------------------------------------------//

HB_FUNC( GTK_TREE_VIEW_INSERT_COLUMN ) // treeview, column, pos -> void
{
   gtk_tree_view_insert_column( GTK_TREE_VIEW ( GTK_WIDGET( hb_parptr( 1 ) )),
                                GTK_TREE_VIEW_COLUMN( ( GtkTreeViewColumn * ) hb_parptr( 2 )),
                                (gint) hb_parni( 3 ) );
}

//------------------------------------------------------//

HB_FUNC( GTK_TREE_VIEW_GET_COLUMN ) // treeview, nColumn -> column
{
  GtkTreeViewColumn * column =
      gtk_tree_view_get_column( GTK_TREE_VIEW( GTK_WIDGET( hb_parptr( 1 ) ) ),
                                ( gint ) hb_parni( 2 ) );

  if GTK_IS_TREE_VIEW_COLUMN( column )
     hb_retptr( ( GtkTreeViewColumn * ) column );
  else
     hb_retptr( ( GtkTreeViewColumn * ) 0 );
}

//------------------------------------------------------//

HB_FUNC( GTK_TREE_VIEW_REMOVE_COLUMN )
{
   GtkTreeView * tree   = GTK_TREE_VIEW( hb_parptr( 1 ) );
   hb_retni( gtk_tree_view_remove_column( tree, GTK_TREE_VIEW_COLUMN( ( GtkTreeViewColumn * ) hb_parptr( 2 )) ) );
}
    
//------------------------------------------------------//

HB_FUNC( GTK_TREE_VIEW_GET_SELECTION ) // treeview -> treeselection
{
  GtkTreeSelection * selection = gtk_tree_view_get_selection(
                                 GTK_TREE_VIEW( hb_parptr( 1 ) ) );
  hb_retptr( ( GtkTreeSelection *) selection );
}

//------------------------------------------------------//

HB_FUNC( GTK_TREE_VIEW_GET_MODEL ) // treeview -> treemodel
{
  GtkTreeView * tree   = GTK_TREE_VIEW( hb_parptr( 1 ) );
  GtkTreeModel * model = gtk_tree_view_get_model( tree );
  hb_retptr( ( GtkTreeModel * ) model );
}

//------------------------------------------------------//

// Por Carlos Mora, comprobarlo
HB_FUNC( GTK_TREE_VIEW_SET_CURSOR_ON_CELL )
{
  GtkTreeView * tree = GTK_TREE_VIEW( hb_parptr( 1 ) );
  GtkTreePath * path = (GtkTreePath *) hb_parptr( 2 ) ;
  GtkTreeViewColumn * focus_column = GTK_TREE_VIEW_COLUMN( hb_parptr( 3 ) );
  GtkCellRenderer * focus_cell = GTK_CELL_RENDERER( hb_parptr( 4 ) );
  gboolean start_editing = hb_parl( 5 );

  gtk_tree_view_set_cursor_on_cell( tree,
                                    path,
                                    focus_column, 
                                    focus_cell,
                                    start_editing );
}

//------------------------------------------------------//

HB_FUNC( GTK_TREE_COLUMN_GET_EDITABLE_WIDGET )
{
    GtkTreeViewColumn * column = (GtkTreeViewColumn *) hb_parnl( 1 );
    #if GTK_MAJOR_VERSION < 3
        hb_retptr( ( GtkTreeViewColumn * ) column->editable_widget );
    #else
        // TODO: Any Idea ?
    #endif    
}

//------------------------------------------------------//

HB_FUNC( GTK_TREE_VIEW_GET_CURSOR )
{
    GtkTreePath * path;
    GtkTreeViewColumn * focus_column;

    gtk_tree_view_get_cursor( (GtkTreeView *) hb_parptr( 1 ) , &path, &focus_column);

    hb_storptr( ( GtkTreePath * ) path, 2 );
    hb_storptr( ( GtkTreeViewColumn * ) focus_column, 3 );
}

HB_FUNC( GTK_TREE_VIEW_SCROLL_TO_POINT )
{
   GtkTreeView * tree = GTK_TREE_VIEW( hb_parptr( 1 ) );
   gint tree_x = hb_parni( 2 );
   gint tree_y = hb_parni( 3 );
   gtk_tree_view_scroll_to_point( tree, tree_x, tree_y );
}

HB_FUNC( GTK_TREE_VIEW_SCROLL_TO_CELL )
{
   GtkTreeView * tree = GTK_TREE_VIEW( hb_parptr( 1 ) );
   GtkTreePath * path = (GtkTreePath *) hb_parptr( 2 ) ;
   GtkTreeViewColumn * focus_column = GTK_TREE_VIEW_COLUMN( hb_parptr( 3 ) ) ;
   gboolean use_align = hb_parl( 4 );
   gfloat row_align = hb_parnl( 5 ) ;
   gfloat col_align = hb_parnl( 6 ) ;

   gtk_tree_view_scroll_to_cell( tree, path, focus_column, use_align, row_align, col_align );
}


//------------------------------------------------------//

HB_FUNC( GTK_TREE_VIEW_SET_ENABLE_SEARCH )
{
   GtkTreeView * tree = GTK_TREE_VIEW( hb_parptr( 1 ) );
   gtk_tree_view_set_enable_search ( tree , (gboolean) hb_parl( 2 ) );
}

//------------------------------------------------------//

HB_FUNC( GTK_TREE_VIEW_GET_SEARCH_COLUMN )
{
   GtkTreeView * tree = GTK_TREE_VIEW( hb_parptr( 1 ) );
   hb_retni( gtk_tree_view_get_search_column( tree ) );
}

//------------------------------------------------------//

HB_FUNC( GTK_TREE_VIEW_SET_SEARCH_COLUMN )
{
  GtkTreeView * tree = GTK_TREE_VIEW( hb_parptr( 1 ) );
  gint column = hb_parni( 2 );
  gtk_tree_view_set_search_column( tree, column );
}

//------------------------------------------------------//

HB_FUNC( GTK_TREE_VIEW_INSERT_COLUMN_WITH_ATTRIBUTES )
{
   gint column;
   GtkTreeView * tree = GTK_TREE_VIEW( hb_parptr( 1 ) );
   GtkCellRenderer * renderer = GTK_CELL_RENDERER( hb_parptr( 4 ) );

   column = gtk_tree_view_insert_column_with_attributes( tree,
                                             (gint) hb_parni( 2 ),   // Position
                                             (gchar *) hb_parc( 3 ), // Title
                                             renderer,
                                             (gchar *) hb_parc( 5 ), // Type
                                             (gint) hb_parni( 6 ),
                                             NULL);
   hb_retni( column );
}

//------------------------------------------------------//

HB_FUNC( GTK_TREE_VIEW_EXPAND_ALL )
{
   GtkTreeView * tree = GTK_TREE_VIEW( hb_parptr( 1 ) );
   gtk_tree_view_expand_all( tree );
}

//------------------------------------------------------//

HB_FUNC( GTK_TREE_VIEW_EXPAND_ROW )
{
   GtkTreeView * tree = GTK_TREE_VIEW( hb_parptr( 1 ) );
   GtkTreePath * path = (GtkTreePath *) hb_parptr( 2 ) ;
   gboolean open_all = hb_parl( 3 ); 
   hb_retl( gtk_tree_view_expand_row( tree, path, open_all ) );
}

//------------------------------------------------------//

HB_FUNC( GTK_TREE_VIEW_COLLAPSE_ROW )
{
   GtkTreeView * tree = GTK_TREE_VIEW( hb_parptr( 1 ) );
   GtkTreePath * path = (GtkTreePath *) hb_parptr( 2 ) ;
   hb_retl( gtk_tree_view_collapse_row( tree, path ) );
}

//------------------------------------------------------//

HB_FUNC( GTK_TREE_VIEW_SET_HEADERS_VISIBLE )
{
  GtkTreeView * tree = GTK_TREE_VIEW( hb_parptr( 1 ) );
  gboolean bvisible = hb_parl( 2 );
  gtk_tree_view_set_headers_visible ( tree , bvisible );
}

//------------------------------------------------------//

HB_FUNC( GTK_TREE_VIEW_COLUMNS_AUTOSIZE )
{
  GtkTreeView * tree = GTK_TREE_VIEW( hb_parptr( 1 ) );
  gtk_tree_view_columns_autosize( tree );
}

//------------------------------------------------------//

HB_FUNC( HB_GTK_TREE_VIEW_GET_TOTAL_COLUMNS ) // Treeview -->Total_Columns
{
  GtkTreeView * tree = GTK_TREE_VIEW( hb_parptr( 1 ) );
  GList * list ;
  guint elements = 0;
  
  list = gtk_tree_view_get_columns( tree );

  elements = g_list_length( list );
  hb_retni  ( (guint) elements );
  g_list_free( list );

}   

//------------------------------------------------------//

HB_FUNC( HB_GTK_TREE_VIEW_NEXT_ROW )
{
  GtkTreeView * tree = GTK_TREE_VIEW( hb_parptr( 1 ) );
  GtkTreePath * path ;
  GtkTreeViewColumn *focus_column;

  gtk_tree_view_get_cursor( tree , &path, &focus_column);
  if ( path )
  {                                     
    gtk_tree_path_next( path ) ;
    gtk_tree_view_set_cursor( tree , path, focus_column, TRUE );
    gtk_tree_path_free( path );
    hb_retl( TRUE );
  } else{
    hb_retl( FALSE );
  }
}  

//------------------------------------------------------//

HB_FUNC( HB_GTK_TREE_VIEW_PREV_ROW )
{
  GtkTreeView * tree = GTK_TREE_VIEW( hb_parptr( 1 ) );
  GtkTreePath * path;
  GtkTreeViewColumn *focus_column;

  gtk_tree_view_get_cursor( tree , &path, &focus_column);
  if ( path )
  {
    if ( gtk_tree_path_prev( path ) ) {
        gtk_tree_view_set_cursor( tree , path, focus_column, TRUE );
        hb_retl( TRUE );
    } else {
        hb_retl( FALSE );
    }    
    gtk_tree_path_free( path );
  }
}  

//------------------------------------------------------//

HB_FUNC( HB_GTK_TREE_VIEW_UP_ROW )
{
  GtkTreeView * tree = GTK_TREE_VIEW( hb_parptr( 1 ) );
  GtkTreePath * path;
  GtkTreeViewColumn *focus_column;

  gtk_tree_view_get_cursor( tree , &path, &focus_column);
  if ( path  )
  {
    if ( gtk_tree_path_up( path ) ) {
      if( gtk_tree_path_get_depth( path ) > 0 )
        gtk_tree_view_set_cursor( tree , path, focus_column, TRUE );
      hb_retl( TRUE );     
    } else {
        hb_retl( FALSE );
    }    
    gtk_tree_path_free( path );

  }
}  

//------------------------------------------------------//

HB_FUNC( HB_GTK_TREE_VIEW_DOWN_ROW )
{
  GtkTreeView * tree = GTK_TREE_VIEW( hb_parptr( 1 ) );
  GtkTreePath * path;
  GtkTreeViewColumn *focus_column;

  gtk_tree_view_get_cursor( tree , &path, &focus_column);
  if ( path )
  {
    gtk_tree_path_down( path );
    gtk_tree_view_set_cursor( tree , path, focus_column, TRUE );
    gtk_tree_path_free( path );
    hb_retl( TRUE );
   }  else {
      hb_retl( FALSE );
   }  
}  

//------------------------------------------------------//


HB_FUNC( GTK_TREE_VIEW_SET_CURSOR )
{

   GtkTreeView * tree_view = GTK_TREE_VIEW( hb_parptr( 1 ) );
   GtkTreePath * path = ( GtkTreePath * ) hb_parptr( 2 );
   GtkTreeViewColumn *focus_column = ( GtkTreeViewColumn * ) hb_parptr( 3 );
	
   gtk_tree_view_set_cursor( tree_view,
                             path,
                             focus_column,
                             hb_parl( 4 ) );	
	
}

HB_FUNC( GTK_TREE_VIEW_GET_PATH_AT_POS )
{
   GtkTreeView * tree_view = GTK_TREE_VIEW( hb_parptr( 1 ) );
   gint x = hb_parni( 2 );
   gint y = hb_parni( 3 );
   GtkTreePath * path = ( GtkTreePath * ) hb_parptr( 4 );
   GtkTreeViewColumn *focus_column = ISNIL( 5 ) ? NULL : ( GtkTreeViewColumn * ) hb_parptr( 5 );
//   gint cell_x = ISNIL( 6 ) ? NULL : hb_parni( 6 );
 //  gint cell_y = ISNIL( 7 ) ? NULL : hb_parni( 7 );
  
   hb_retl( gtk_tree_view_get_path_at_pos(GTK_TREE_VIEW( tree_view ),
                                           (gint) x, 
                                           (gint) y,
                                            &path, &focus_column, NULL, NULL ) );
//                                            ( ISNIL( 6 ) ? NULL : (gint) hb_parni( 6 ) ),
//                                            ( ISNIL( 7 ) ? NULL : (gint)hb_parni( 7 ) ) ) );
   hb_storptr( (GtkTreePath * ) path, 4 );
   hb_storptr( (GtkTreeViewColumn * ) focus_column, 5 );

}


HB_FUNC( GTK_TREE_VIEW_ROW_ACTIVATED )
{
   GtkTreeView * tree_view = GTK_TREE_VIEW( hb_parptr( 1 ) );
   GtkTreePath * path = ( GtkTreePath * ) hb_parptr( 2 );
   GtkTreeViewColumn *column = ( GtkTreeViewColumn * ) hb_parptr( 3 );

   gtk_tree_view_row_activated( tree_view, path, column );
}


HB_FUNC( GTK_TREE_VIEW_SET_ENABLE_TREE_LINES )
{
   GtkTreeView * tree_view = GTK_TREE_VIEW( hb_parptr( 1 ) );
   gtk_tree_view_set_enable_tree_lines( tree_view, (gboolean) hb_parl( 2 ) );
}


HB_FUNC( GTK_TREE_VIEW_GET_ENABLE_TREE_LINES )
{
   GtkTreeView * tree_view = GTK_TREE_VIEW( hb_parptr( 1 ) );
   hb_retl( gtk_tree_view_get_enable_tree_lines( tree_view ) );
}


HB_FUNC( GTK_TREE_VIEW_SET_GRID_LINES )
{
   GtkTreeView * tree_view = GTK_TREE_VIEW( hb_parptr( 1 ) );
   gtk_tree_view_set_grid_lines( tree_view, hb_parni( 2 ) );
}

HB_FUNC( GTK_TREE_VIEW_GET_GRID_LINES )
{
   GtkTreeView * tree_view = GTK_TREE_VIEW( hb_parptr( 1 ) );
   hb_retni( gtk_tree_view_get_grid_lines( tree_view ) );
}


/*
 * TODO: Seria interesante realizar WRAPPER

void        gtk_tree_view_get_cursor        (GtkTreeView *tree_view,
                                             GtkTreePath **path,
                                             GtkTreeViewColumn **focus_column);
*/
