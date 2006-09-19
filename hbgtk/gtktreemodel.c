/* $Id: gtktreemodel.c,v 1.1 2006-09-08 12:18:45 xthefull Exp $*/
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

PHB_ITEM Iter2Array( GtkTreeIter *iter  );
BOOL Array2Iter(PHB_ITEM aIter, GtkTreeIter *iter  );

HB_FUNC( GTK_TREE_MODEL_GET_ITER_FROM_PATH ) // hModel, cPath
{
    GtkTreeModel *model = (GtkTreeModel *) hb_parnl( 1 );
    GtkTreeIter iter;

    gtk_tree_model_get_iter_from_string(model, &iter, hb_parc(2) );

    hb_retnl( (glong) iter.user_data );

}

HB_FUNC( GTK_TREE_MODEL_GET_LONG )
{
    long l;
    GtkListStore * model = (GtkListStore *) hb_parnl( 1 ) ;
    GtkTreeIter iter;

    iter.user_data = (gpointer) hb_parnl( 2 );
    iter.stamp = model->stamp;
    gtk_tree_model_get ( (GtkTreeModel *) model, &iter, 0, &l, -1);

    hb_retnl( l );
}

HB_FUNC( GTK_LIST_STORE_GET_COL_TYPE )
{
  hb_retnl( gtk_tree_model_get_column_type( GTK_TREE_MODEL( hb_parnl( 1 ) ), hb_parni( 2 ) ) );
}

HB_FUNC( GTK_TREE_MODEL_GET_COLUMN_TYPE ) // pModel, nColumn --> Gtype
{
  GType column_type;
  GtkTreeModel *model = GTK_TREE_MODEL( hb_parnl( 1 ) );
  gint index = hb_parni( 2 );
  column_type = gtk_tree_model_get_column_type( model, index );
  hb_retnl( column_type );
}
 
HB_FUNC( GTK_TREE_MODEL_GET ) //  pModel, aIter, nColumn, TODO:Determinar typo llenado...
{
   GtkTreeModel *model = (GtkTreeModel *) hb_parnl( 1 );
   GtkTreeIter iter;
   PHB_ITEM pIter = hb_param( 2, HB_IT_ARRAY );
   gchar *name;

  if ( Array2Iter( pIter, &iter ) ) {
      gtk_tree_model_get( model, &iter , hb_parni( 3 ), &name, -1 );
      hb_retc( name );
      g_free( name );
  }
}

HB_FUNC( GTK_TREE_MODEL_GET_PATH ) //  pModel, aIter
{
   GtkTreeModel *model = (GtkTreeModel *) hb_parnl( 1 );
   GtkTreePath * path = NULL;
   GtkTreeIter iter;
   PHB_ITEM aIter = hb_param( 2, HB_IT_ARRAY );
   
   if ( Array2Iter( aIter, &iter ) ) 
       path =  gtk_tree_model_get_path( model, &iter );
   
   if( HB_IS_ARRAY( aIter ) && hb_arrayLen( aIter ) == 4 ) {
     hb_storni( (gint)  (iter.stamp)      ,2, 1);
     hb_stornl( (glong) (iter.user_data)  ,2, 2);
     hb_stornl( (glong) (iter.user_data2) ,2, 3);
     hb_stornl( (glong) (iter.user_data3) ,2, 4);
    }
    
  // 08/Dic/2005 Rafa 
  // OJO a esto, no se puede liberar AQUI, si no se pierde referencia al path
  // gtk_tree_path_free( path );
    hb_retnl( (glong) path );
}

HB_FUNC( GTK_TREE_PATH_NEW_FROM_STRING )
{
  GtkTreePath * path =  gtk_tree_path_new_from_string( (gchar*) hb_parc( 1 ) );
  hb_retnl( (glong) path );
}

HB_FUNC( GTK_TREE_PATH_FREE )
{
  GtkTreePath * path  = (GtkTreePath *)  hb_parnl( 1 );

  gtk_tree_path_free( path );
}

HB_FUNC( GTK_TREE_MODEL_GET_ITER ) //  pModel, aIter, path
{
   GtkTreeModel *model = (GtkTreeModel *) hb_parnl( 1 );
   GtkTreePath  *path  = (GtkTreePath *)  hb_parnl( 3 );
   GtkTreeIter iter;
   PHB_ITEM aIter = hb_param( 2, HB_IT_ARRAY );
   gboolean bresult = FALSE;

   if ( Array2Iter( aIter, &iter ) ) 
       bresult =  gtk_tree_model_get_iter( model, &iter, path );
  
   if( HB_IS_ARRAY( aIter ) && hb_arrayLen( aIter ) == 4 ) {
     hb_storni( (gint)  (iter.stamp)      ,2, 1);
     hb_stornl( (glong) (iter.user_data)  ,2, 2);
     hb_stornl( (glong) (iter.user_data2) ,2, 3);
     hb_stornl( (glong) (iter.user_data3) ,2, 4);
    }
    hb_retl( bresult );
}
    
HB_FUNC( HB_GTK_TREE_MODEL_GET_STRING ) //  pModel, aIter, nColumn, Type CHAR
{
   GtkTreeModel *model = (GtkTreeModel *) hb_parnl( 1 );
   GtkTreeIter iter;
   PHB_ITEM aIter = hb_param( 2, HB_IT_ARRAY );
   gchar * name;

  if ( Array2Iter( aIter, &iter ) ) {
      gtk_tree_model_get( model, &iter , hb_parni( 3 ), &name, -1 );
      hb_storc( name, 4 );
      g_free( name );
  }
  
  if( HB_IS_ARRAY( aIter ) && hb_arrayLen( aIter ) == 4 ) {
     hb_storni( (gint)  (iter.stamp)      ,2, 1);
     hb_stornl( (glong) (iter.user_data)  ,2, 2);
     hb_stornl( (glong) (iter.user_data2) ,2, 3);
     hb_stornl( (glong) (iter.user_data3) ,2, 4);
    }

}

HB_FUNC( HB_GTK_TREE_MODEL_GET_INT ) //  pModel, aIter, nColumn, Type INT
{
   GtkTreeModel *model = (GtkTreeModel *) hb_parnl( 1 );
   GtkTreeIter iter;
   PHB_ITEM aIter = hb_param( 2, HB_IT_ARRAY );
   gint value;

  if ( Array2Iter( aIter, &iter ) ) {
      gtk_tree_model_get( model, &iter , hb_parni( 3 ), &value, -1 );
      hb_storni( value, 4 );
  }

  if( HB_IS_ARRAY( aIter ) && hb_arrayLen( aIter ) == 4 ) {
     hb_storni( (gint)  (iter.stamp)      ,2, 1);
     hb_stornl( (glong) (iter.user_data)  ,2, 2);
     hb_stornl( (glong) (iter.user_data2) ,2, 3);
     hb_stornl( (glong) (iter.user_data3) ,2, 4);
    }

}

HB_FUNC( HB_GTK_TREE_MODEL_GET_BOOLEAN ) //  pModel, aIter, nColumn, Type BOOLEAN
{
   GtkTreeModel *model = (GtkTreeModel *) hb_parnl( 1 );
   GtkTreeIter iter;
   PHB_ITEM aIter = hb_param( 2, HB_IT_ARRAY );
   gboolean value;

  if ( Array2Iter( aIter, &iter ) ) {
      gtk_tree_model_get( model, &iter , hb_parni( 3 ), &value, -1 );
      hb_storl( value, 4 );
  }

  if( HB_IS_ARRAY( aIter ) && hb_arrayLen( aIter ) == 4 ) {
     hb_storni( (gint)  (iter.stamp)      ,2, 1);
     hb_stornl( (glong) (iter.user_data)  ,2, 2);
     hb_stornl( (glong) (iter.user_data2) ,2, 3);
     hb_stornl( (glong) (iter.user_data3) ,2, 4);
    }

}


HB_FUNC( HB_GTK_TREE_MODEL_GET_LONG ) //  pModel, aIter, nColumn, Type LONG
{
   GtkTreeModel *model = (GtkTreeModel *) hb_parnl( 1 );
   GtkTreeIter iter;
   PHB_ITEM aIter = hb_param( 2, HB_IT_ARRAY );
   glong value;

  if ( Array2Iter( aIter, &iter ) ) {
      gtk_tree_model_get( model, &iter , hb_parni( 3 ), &value, -1 );
      hb_stornl( value, 4 );
  }

  
  if( HB_IS_ARRAY( aIter ) && hb_arrayLen( aIter ) == 4 ) {
     hb_storni( (gint)  (iter.stamp)      ,2, 1);
     hb_stornl( (glong) (iter.user_data)  ,2, 2);
     hb_stornl( (glong) (iter.user_data2) ,2, 3);
     hb_stornl( (glong) (iter.user_data3) ,2, 4);
    }
}

HB_FUNC( HB_GTK_TREE_MODEL_GET_DOUBLE ) //  pModel, aIter, nColumn, Type DOUBLE
{
   GtkTreeModel *model = (GtkTreeModel *) hb_parnl( 1 );
   GtkTreeIter iter;
   PHB_ITEM aIter = hb_param( 2, HB_IT_ARRAY );
   gdouble value;

  if ( Array2Iter( aIter, &iter ) ) {
      gtk_tree_model_get( model, &iter , hb_parni( 3 ), &value, -1 );
      hb_stornd( value, 4 );
  }

  if( HB_IS_ARRAY( aIter ) && hb_arrayLen( aIter ) == 4 ) {
     hb_storni( (gint)  (iter.stamp)      ,2, 1);
     hb_stornl( (glong) (iter.user_data)  ,2, 2);
     hb_stornl( (glong) (iter.user_data2) ,2, 3);
     hb_stornl( (glong) (iter.user_data3) ,2, 4);
    }

}

HB_FUNC( HB_GTK_TREE_PATH_GET_INDICES )
{
  GtkTreePath  *path  = (GtkTreePath *)  hb_parnl( 1 );
  hb_retni( gtk_tree_path_get_indices( path )[0] );
}

HB_FUNC( GTK_TREE_MODEL_GET_ITER_FIRST ) //  model, iter --> bool
{
  GtkTreeModel *model = (GtkTreeModel *) hb_parnl( 1 );
  GtkTreeIter iter;
  PHB_ITEM aIter = hb_param( 2, HB_IT_ARRAY );
  
  if ( Array2Iter( aIter, &iter ) ) {
     hb_retl( gtk_tree_model_get_iter_first( model, &iter ) );
  }
  if( HB_IS_ARRAY( aIter ) && hb_arrayLen( aIter ) == 4 ) {
     hb_storni( (gint)  (iter.stamp)      ,2, 1);
     hb_stornl( (glong) (iter.user_data)  ,2, 2);
     hb_stornl( (glong) (iter.user_data2) ,2, 3);
     hb_stornl( (glong) (iter.user_data3) ,2, 4);
  }
}    

HB_FUNC( GTK_TREE_MODEL_ITER_NEXT ) //  model, iter --> bool
{
  GtkTreeModel *model = (GtkTreeModel *) hb_parnl( 1 );
  GtkTreeIter iter;
  PHB_ITEM aIter = hb_param( 2, HB_IT_ARRAY );
  
  if ( Array2Iter( aIter, &iter ) ) {
     hb_retl( gtk_tree_model_iter_next( model, &iter ) );
  }
  if( HB_IS_ARRAY( aIter ) && hb_arrayLen( aIter ) == 4 ) {
     hb_storni( (gint)  (iter.stamp)      ,2, 1);
     hb_stornl( (glong) (iter.user_data)  ,2, 2);
     hb_stornl( (glong) (iter.user_data2) ,2, 3);
     hb_stornl( (glong) (iter.user_data3) ,2, 4);
  }
}    

HB_FUNC( GTK_TREE_MODEL_GET_ITER_FROM_STRING ) //  model, iter, cPath --> bool
{
  GtkTreeModel *model = (GtkTreeModel *) hb_parnl( 1 );
  GtkTreeIter iter;
  PHB_ITEM aIter = hb_param( 2, HB_IT_ARRAY );
  gchar * path_string = hb_parc( 3 );

  if ( Array2Iter( aIter, &iter ) ) {
     hb_retl( gtk_tree_model_get_iter_from_string( model, &iter, path_string ) );
  }
  if( HB_IS_ARRAY( aIter ) && hb_arrayLen( aIter ) == 4 ) {
     hb_storni( (gint)  (iter.stamp)      ,2, 1);
     hb_stornl( (glong) (iter.user_data)  ,2, 2);
     hb_stornl( (glong) (iter.user_data2) ,2, 3);
     hb_stornl( (glong) (iter.user_data3) ,2, 4);
  }
}    

// Combo_box de ITER

HB_FUNC( GTK_COMBO_BOX_SET_ACTIVE_ITER )
{
  GtkWidget * combo = GTK_WIDGET( hb_parnl( 1 ) );
  GtkTreeIter iter;
  PHB_ITEM aIter = hb_param( 2, HB_IT_ARRAY );
  
  if ( Array2Iter( aIter, &iter ) ) {
      gtk_combo_box_set_active_iter( GTK_COMBO_BOX( combo ), &iter );
  }

  if( HB_IS_ARRAY( aIter ) && hb_arrayLen( aIter ) == 4 ) {
     hb_storni( (gint)  (iter.stamp)      ,2, 1);
     hb_stornl( (glong) (iter.user_data)  ,2, 2);
     hb_stornl( (glong) (iter.user_data2) ,2, 3);
     hb_stornl( (glong) (iter.user_data3) ,2, 4);
  }
}    

HB_FUNC( GTK_COMBO_BOX_GET_ACTIVE_ITER )
{
  GtkWidget * combo = GTK_WIDGET( hb_parnl( 1 ) );
  GtkTreeIter iter;
  PHB_ITEM aIter = hb_param( 2, HB_IT_ARRAY );
  
  if ( Array2Iter( aIter, &iter ) ) {
      hb_retl( gtk_combo_box_get_active_iter( GTK_COMBO_BOX( combo ), &iter ) );
  }

  if( HB_IS_ARRAY( aIter ) && hb_arrayLen( aIter ) == 4 ) {
     hb_storni( (gint)  (iter.stamp)      ,2, 1);
     hb_stornl( (glong) (iter.user_data)  ,2, 2);
     hb_stornl( (glong) (iter.user_data2) ,2, 3);
     hb_stornl( (glong) (iter.user_data3) ,2, 4);
  }
}    