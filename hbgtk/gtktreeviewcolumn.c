/*
 * GtkTreeViewColumn. Column browses -----------------------------------------
 * Porting Harbour to GTK+ power !
 * (C) 2004. Rafa Carmona -TheFull-
 * (C) 2004. Joaquim Ferrer
 *
 * Funciones GTK implementadas :
 *  + gtk_tree_view_column_new()
 *  + gtk_tree_view_column_set_title()
 *  + gtk_tree_view_column_pack_start()
 *  + gtk_tree_view_column_new_with_attributes()
 *  + gtk_tree_view_column_add_attribute()
 *  + gtk_tree_view_column_set_resizable()
 *  + gtk_tree_view_column_set_clickable()
 *  + gtk_tree_view_column_set_sort_column_id()
 *  + gtk_tree_view_column_set_fixed_width()
 *  + gtk_tree_view_column_set_sizing()
 *  + gtk_tree_view_column_set_visible()
 *  + gtk_tree_view_column_get_visible()
 */

#include <gtk/gtk.h>
#include "hbapi.h"
#include "hbvm.h"

// Atencion esto esta para mantener compatibilidad con xHarbour anteriores
// Deberá desaparecer , pero lo necesito ahora
#ifdef __OLDHARBOUR__
  HB_EXPORT PHB_SYMB hb_dynsymSymbol( PHB_DYNS pDynSym );
#endif

static void
CellDataFunc( GtkTreeViewColumn *tree_column, GtkCellRenderer *cell, GtkTreeModel *tree_model,
              GtkTreeIter *iter, gpointer data);

HB_FUNC( GTK_TREE_VIEW_COLUMN_NEW ) // -> widget
{
   GtkTreeViewColumn * column = gtk_tree_view_column_new();
   hb_retptr( ( GtkTreeViewColumn * ) column );
}

//---------------------------------------------//

HB_FUNC( GTK_TREE_VIEW_COLUMN_SET_TITLE ) // -> void
{
   gtk_tree_view_column_set_title( GTK_TREE_VIEW_COLUMN( ( GtkTreeViewColumn * ) hb_parptr( 1 ) ),
                                   (gchar *) hb_parc( 2 ) );
}

//---------------------------------------------//

HB_FUNC( GTK_TREE_VIEW_COLUMN_GET_TITLE ) 
{
   GtkTreeViewColumn *column = 
                  GTK_TREE_VIEW_COLUMN( ( GtkTreeViewColumn * ) hb_parptr( 1 ) );
   hb_retc( (gchar *) gtk_tree_view_column_get_title( column ) );
}

//---------------------------------------------//

HB_FUNC( GTK_TREE_VIEW_COLUMN_PACK_START )
{
   GtkTreeViewColumn *column   =
                     GTK_TREE_VIEW_COLUMN( ( GtkWidget * ) hb_parptr( 1 ) );
   GtkCellRenderer   *renderer =
                     GTK_CELL_RENDERER( ( GtkCellRenderer * ) hb_parptr( 2 ) );
   gtk_tree_view_column_pack_start( column, renderer,
                                    ( gboolean ) hb_parl( 3 ) );
}

//---------------------------------------------//

HB_FUNC( GTK_TREE_VIEW_COLUMN_NEW_WITH_ATTRIBUTES ) // n Column, Title,
                                                    // type, renderer-> column
{
   GtkTreeViewColumn * column = gtk_tree_view_column_new();
   GtkCellRenderer   *renderer =
                     GTK_CELL_RENDERER( ( GtkCellRenderer * ) hb_parptr( 2 ) );
   PHB_ITEM pArray = hb_param( 3, HB_IT_ARRAY );        // array
   gint iLenCols = hb_arrayLen( pArray ) / 2;           // columnas
   gint iCol, n_column;
   gchar * texto ;
   // TODO : Control de len debe ser par
   /*
   Creates a new GtkTreeViewColumn with a number of default values.
   [ gtk_tree_view_column_new_with_attributes() ]
   This is equivalent to calling :
   gtk_tree_view_column_set_title(),:
   gtk_tree_view_column_pack_start(),
   and gtk_tree_view_column_set_attributes() on the newly created GtkTreeViewColumn.*/
   gtk_tree_view_column_set_title( column, hb_parc( 1 ) );
   gtk_tree_view_column_pack_start( column, renderer, TRUE);

   for( iCol = 0; iCol < iLenCols; iCol++ )
   {
      texto    = ( gchar * ) hb_arrayGetCPtr( pArray, iCol+1 );  // Retorna el puntero a la cadena,
      n_column = hb_arrayGetNI( pArray, iCol+2 );
      gtk_tree_view_column_add_attribute( column, renderer, texto, n_column );
   }

   hb_retptr( ( GtkTreeViewColumn * ) column );
}

//---------------------------------------------//

HB_FUNC( GTK_TREE_VIEW_COLUMN_ADD_ATTRIBUTE ) // Column, Renderer, string for
                                              // renderer, nColumn -> void
{
   GtkTreeViewColumn *column   = GTK_TREE_VIEW_COLUMN( ( GtkWidget * )
                                                         hb_parptr( 1 ) );
   GtkCellRenderer   *renderer = GTK_CELL_RENDERER( ( GtkCellRenderer * )
                                                         hb_parptr( 2 ) );
   gtk_tree_view_column_add_attribute( column, renderer,
                                       hb_parc( 3 ), hb_parni( 4 ) );
}

//---------------------------------------------//

HB_FUNC( GTK_TREE_VIEW_COLUMN_SET_RESIZABLE ) // nColumn, logical -> void
{
   gtk_tree_view_column_set_resizable(
                  GTK_TREE_VIEW_COLUMN (( GtkTreeViewColumn * ) hb_parptr( 1 )),
                  ( gboolean ) hb_parl( 2 ) );
}

//---------------------------------------------//

HB_FUNC( GTK_TREE_VIEW_COLUMN_SET_CLICKABLE ) // nColumn, logical -> void
{
   gtk_tree_view_column_set_clickable(
                  GTK_TREE_VIEW_COLUMN (( GtkTreeViewColumn * ) hb_parptr( 1 )),
                  ( gboolean ) hb_parl( 2 ) );
}

//---------------------------------------------//

HB_FUNC( GTK_TREE_VIEW_COLUMN_SET_SORT_COLUMN_ID ) // nColumn, logical -> void
{
   gtk_tree_view_column_set_sort_column_id( GTK_TREE_VIEW_COLUMN (( GtkTreeViewColumn * ) hb_parptr( 1 )), hb_parni( 2 ) );
}

//---------------------------------------------//

HB_FUNC( GTK_TREE_VIEW_COLUMN_SET_FIXED_WIDTH ) // nColumn, nWidth -> void
{
   gtk_tree_view_column_set_fixed_width(
                  GTK_TREE_VIEW_COLUMN (( GtkTreeViewColumn * ) hb_parptr( 1 )),
                  ( gint ) hb_parni( 2 ) );
}

//---------------------------------------------//

HB_FUNC( GTK_TREE_VIEW_COLUMN_SET_SIZING ) // nColumn, nType -> void
{
   gtk_tree_view_column_set_sizing(
                  GTK_TREE_VIEW_COLUMN (( GtkTreeViewColumn * ) hb_parptr( 1 )),
                  ( gint ) hb_parni( 2 ) );
}

//---------------------------------------------//

HB_FUNC( GTK_TREE_VIEW_COLUMN_SET_VISIBLE )
{
   gtk_tree_view_column_set_visible(
                  GTK_TREE_VIEW_COLUMN (( GtkTreeViewColumn * ) hb_parptr( 1 )),
                  ( gboolean ) hb_parl( 2 ) );  
}

//---------------------------------------------//

HB_FUNC( GTK_TREE_VIEW_COLUMN_GET_VISIBLE )
{
   GtkTreeViewColumn *column = GTK_TREE_VIEW_COLUMN(  hb_parptr( 1 ) );
   hb_retl( gtk_tree_view_column_get_visible( column ) );
}

//---------------------------------------------//

HB_FUNC( GTK_TREE_VIEW_COLUMN_GET_SORT_COLUMN_ID ) // -->Column_Sort
{
   hb_retni( gtk_tree_view_column_get_sort_column_id( GTK_TREE_VIEW_COLUMN (( GtkTreeViewColumn * ) hb_parptr( 1 )) ) );
}

//---------------------------------------------//

HB_FUNC( GTK_TREE_VIEW_COLUMN_SET_WIDGET )  // renderer, nColumn -> void
{
   GtkTreeViewColumn *column = GTK_TREE_VIEW_COLUMN(  hb_parptr( 1 ) );
   GtkWidget * widget = GTK_WIDGET( hb_parptr( 2 ) );
   gtk_tree_view_column_set_widget(  column, widget );
}

//---------------------------------------------//

// TODO: Comprobar. From Carlos Mora...
HB_FUNC( GTK_TREE_VIEW_COLUMN_SET_CELL_DATA_FUNC )
{
    PHB_DYNS pDynSym = hb_dynsymFindName( hb_parc(3) );
    if( pDynSym )
    {
        gtk_tree_view_column_set_cell_data_func( (GtkTreeViewColumn *) hb_parptr( 1 ),
                                             (GtkCellRenderer *) hb_parptr( 2 ),
                                             CellDataFunc,
                                             (gpointer) pDynSym->pSymbol,
                                             NULL);
        hb_retnl( (long) hb_dynsymSymbol( pDynSym ) ) ;
    }
    else
    {
        hb_retnl( -1 ) ;
    }

}

//---------------------------------------------//

static void RendererEditedCallBack( GtkCellRendererText *cellrenderertext,
                                            gchar *arg1,
                                            gchar *arg2,
                                            gpointer data)
{
      hb_vmPushSymbol( data );
      hb_vmPushNil();
      hb_vmPushPointer( (GtkCellRendererText *) cellrenderertext );
      hb_vmPushString( arg1, strlen( arg1 ) );
      hb_vmPushString( arg2, strlen( arg2 ) );
      hb_vmDo( 3 );

      return;

}

//---------------------------------------------//

HB_FUNC( GTK_CELL_RENDERER_CONNECT_EDITED )
{
    PHB_DYNS pDynSym = hb_dynsymFindName( hb_parc(2) );
    if( pDynSym )
    {
        g_signal_connect ( (GtkCellRenderer *) hb_parptr( 1 ), "edited",
            G_CALLBACK ( RendererEditedCallBack ), (gpointer) pDynSym->pSymbol );

        hb_retnl( (long) pDynSym->pSymbol ) ;
    }
    else
    {
        hb_retnl( -1 ) ;
    }

}

//---------------------------------------------//

void FillArrayFromIter( GtkTreeIter *iter, PHB_ITEM pArray );
PHB_ITEM Iter2Array( GtkTreeIter *iter  );
BOOL Array2Iter(PHB_ITEM aIter, GtkTreeIter *iter  );


static void
CellDataFunc( GtkTreeViewColumn *tree_column, GtkCellRenderer *cell, GtkTreeModel *tree_model,
                                             GtkTreeIter *iter, gpointer data)
{
//   PHB_ITEM pIter = hb_param( 4, HB_IT_ARRAY );
      
      hb_vmPushSymbol( data );
      hb_vmPushNil();
      hb_vmPushPointer( (GtkTreeViewColumn *) tree_column );
      hb_vmPushPointer( (GtkCellRenderer *) cell );
      hb_vmPushPointer( (GtkTreeModel *) tree_model );
      //hb_vmPushPointer( (GtkTreeIter *) iter);
      hb_vmPush( Iter2Array( (GtkTreeIter *) iter ) );
      hb_vmDo( 4 );

      return;

}

//---------------------------------------------//
