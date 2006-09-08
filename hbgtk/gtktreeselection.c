/* $Id: gtktreeselection.c,v 1.1 2006-09-08 12:18:45 xthefull Exp $*/
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
#include <hbapi.h>

PHB_ITEM Iter2Array( GtkTreeIter *iter  );
BOOL Array2Iter(PHB_ITEM aIter, GtkTreeIter *iter  );

HB_FUNC( GTK_TREE_SELECTION_GET_MODE ) // treeselection -> mode
{
  GtkTreeSelection * selection = GTK_TREE_SELECTION( hb_parnl( 1 ) );
  hb_retni( gtk_tree_selection_get_mode( selection ) );
}

HB_FUNC( GTK_TREE_SELECTION_SET_MODE ) // treeselection, nmode -> void
{
  GtkTreeSelection * selection = GTK_TREE_SELECTION( hb_parnl( 1 ) );
  gtk_tree_selection_set_mode( selection, ( gint ) hb_parni( 2 ) );
}

HB_FUNC( GTK_TREE_SELECTION_COUNT_SELECTED_ROWS ) // treeSelection -> rows selected.
{
  GtkTreeSelection * selection = GTK_TREE_SELECTION( hb_parnl( 1 ) );
  hb_retni( gtk_tree_selection_count_selected_rows( selection ) );
}    

HB_FUNC( GTK_TREE_SELECTION_GET_SELECTED ) // treeSelection , model, iter --> bool
{
  GtkTreeSelection * selection = GTK_TREE_SELECTION( hb_parnl( 1 ) );
  GtkTreeModel *model = (GtkTreeModel *) hb_parnl( 2 );
  GtkTreeIter iter;
  PHB_ITEM aIter = hb_param( 3, HB_IT_ARRAY );
  
  if ( Array2Iter( aIter, &iter ) ) {
     hb_retl( gtk_tree_selection_get_selected (selection, (ISNIL(2) ? NULL :&model ), (ISNIL( 3 ) ? NULL : &iter ) ) );
  }
  if( HB_IS_ARRAY( aIter ) && hb_arrayLen( aIter ) == 4 ) {
     hb_storni( (gint)  (iter.stamp)      ,3, 1);
     hb_stornl( (glong) (iter.user_data)  ,3, 2);
     hb_stornl( (glong) (iter.user_data2) ,3, 3);
     hb_stornl( (glong) (iter.user_data3) ,3, 4);
  }
}    
    
