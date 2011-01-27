/* $Id: gtktreestore.c,v 1.3 2010-10-27 21:39:33 xthefull Exp $*/
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
#include "t-gtk.h"

PHB_ITEM Iter2Array( GtkTreeIter *iter  );
BOOL Array2Iter(PHB_ITEM aIter, GtkTreeIter *iter  );
void FillArrayFromIter( GtkTreeIter *iter, PHB_ITEM pArray );

HB_FUNC( GTK_TREE_STORE_NEWV ) // iCantidad, { a_G_Types }-> TreeStore
{
  GtkTreeStore * store;
  PHB_ITEM pArray = hb_param( 2, HB_IT_ARRAY ); // array
  gint iCol;					// contador
  gint iLenCols = hb_arrayLen( pArray );        // columnas
  GType colTypes[ iLenCols  ];                  // array de tipos

  if( iLenCols != hb_parni( 1 ) )
    g_print("OJO, datos no concuerdan: %d pasado\n%d longitud de array\nEn la llamada a gtk_tree_store_newv",hb_parni(1),iLenCols);

  for( iCol = 0; iCol < iLenCols; iCol++ )
   {
     colTypes[ iCol ] = hb_arrayGetNI( pArray, iCol+1 );
   }
  store = gtk_tree_store_newv( iLenCols, colTypes );
  hb_retptr( store );
}

/*
 * Hb_gtk_tree_store_new( aItems ) , recibe un array bi-dimensional para montar
 * el modelo de datos
 * */
HB_FUNC( HB_GTK_TREE_STORE_NEW ) // aItems -> pTreeStore
{
  GtkTreeStore * store;

  PHB_ITEM pArray2    = hb_param( 1, HB_IT_ARRAY );        // array
  PHB_ITEM pArray     = hb_arrayGetItemPtr( pArray2, 1 );   // 1 Array
  PHB_BASEARRAY pBase = pArray->item.asArray.value;        // base
  gint iCol;
  gint iLenCols       = hb_arrayLen( pArray );
/*
  #ifdef __HARBOUR20__
     gint iLenCols = pBase->nLen;  // columnas
  #else
     gint iLenCols = pBase->ulLen;  // columnas
  #endif
*/
  GType colTypes[ iLenCols ];    // array de tipos

   /* Determinando el tipo de datos para cada columna */
  for( iCol = 0; iCol < iLenCols; iCol++ )
   {
     if( HB_IS_STRING( pBase->pItems + iCol ) )
       colTypes[ iCol ] = G_TYPE_STRING;
     else if( HB_IS_INTEGER( pBase->pItems + iCol ) )
       colTypes[ iCol ] = G_TYPE_INT;
     else if( HB_IS_DOUBLE(  pBase->pItems + iCol ) )
       colTypes[ iCol ] = G_TYPE_DOUBLE;
     else if( HB_IS_DATE( pBase->pItems + iCol ) )
       colTypes[ iCol ] = G_TYPE_STRING;
     else if( HB_IS_LOGICAL( pBase->pItems + iCol ) )
       colTypes[ iCol ] = G_TYPE_BOOLEAN;
   }

  store = gtk_tree_store_newv( iLenCols, colTypes );
  hb_retptr( ( GtkTreeStore * ) store );
}


HB_FUNC( GTK_TREE_STORE_APPEND ) // treestore , Iter, parent -> void
{
  GtkTreeStore * store = GTK_TREE_STORE( hb_parptr( 1 ) );
  PHB_ITEM aIter = hb_param( 2, HB_IT_ARRAY ); // array
  GtkTreeIter iter;

  if( ISNIL( 3 ) ){
      gtk_tree_store_append( store, &iter, NULL );
  }
  else
    {
      GtkTreeIter parent;
      PHB_ITEM pIter = hb_param( 3, HB_IT_ARRAY );
      if ( Array2Iter( pIter, &parent ) )
         {
           gtk_tree_store_append( store, &iter, &parent );
           FillArrayFromIter( &parent, pIter );      
         }
    }

  if( HB_IS_ARRAY( aIter ) && hb_arrayLen( aIter ) == 4 )
     FillArrayFromIter( &iter, aIter );
  else
    g_print("Error: Se necesita un array de 4 elementos");

}

HB_FUNC( GTK_TREE_STORE_SET ) // Treestore, column, item, data -> void
{
  GtkTreeStore * store = GTK_TREE_STORE( hb_parptr( 1 ) );
  GtkTreeIter iter;
  PHB_ITEM pIter = hb_param( 3, HB_IT_ARRAY );
  PHB_ITEM pValue = hb_param( 4, HB_IT_ANY );

  if ( Array2Iter( pIter, &iter ) )
  {
     if( HB_IS_STRING( pValue ) )
       gtk_tree_store_set( store, &iter, (gint) hb_parni( 2 ),
                       hb_parc( 4 ), -1 );
     else if( HB_IS_INTEGER( pValue ) )
       gtk_tree_store_set( store, &iter, (gint) hb_parni( 2 ),
                       hb_parni( 4 ), -1 );
     else if( HB_IS_DOUBLE( pValue ) )
       gtk_tree_store_set( store, &iter, (gint) hb_parni( 2 ),
                       hb_parnd( 4 ), -1 );
     else if( HB_IS_LONG( pValue ) )
       gtk_tree_store_set( store, &iter, (gint) hb_parni( 2 ),
                       hb_parnl( 4 ), -1 );
     else if( HB_IS_DATE( pValue ) )
       gtk_tree_store_set( store, &iter, (gint) hb_parni( 2 ),
                       hb_pards( 4 ), -1 );
     else if( HB_IS_LOGICAL( pValue ) )
       gtk_tree_store_set( store, &iter, (gint) hb_parni( 2 ),
                       hb_parl( 4 ), -1 );
     
    if( HB_IS_ARRAY( pIter ) && hb_arrayLen( pIter ) == 4 )
       FillArrayFromIter( &iter, pIter );
    else
       g_print("Error: Se necesita un array de 4 elementos");     

  }
}

/*--------------------------------------------------------------------------*/
/*--------------------------------------------------------------------------*/
HB_FUNC( GTK_TREE_STORE_INSERT ) // ::pList, aIter, aParent, nRow 
{
  GtkTreeStore * store = GTK_TREE_STORE( hb_parptr( 1 ) );
  PHB_ITEM pIter   = hb_param( 2, HB_IT_ARRAY );
  PHB_ITEM pParent = hb_param( 3, HB_IT_ARRAY );
  gint position = hb_parni( 4 );
  GtkTreeIter  iter, parent ;

  if ( Array2Iter( pIter, &iter ) )
  {
      if( ISNIL( 3 ) ){
         gtk_tree_store_insert( store, &iter, NULL, position );
         FillArrayFromIter( &iter, pIter );
         } 
      else
         {
          if ( Array2Iter( pParent, &parent ) )
             {
              gtk_tree_store_insert( store, &iter, &parent, position );
              FillArrayFromIter( &iter, pIter );
              FillArrayFromIter( &parent, pParent );
             }
         }
  }
}

/*--------------------------------------------------------------------------*/
/*--------------------------------------------------------------------------*/
HB_FUNC( GTK_TREE_STORE_CLEAR ) // treestore
{
  GtkTreeStore * store = GTK_TREE_STORE( hb_parptr( 1 ) );
  gtk_tree_store_clear( store );
}


/*--------------------------------------------------------------------------*/
/*--------------------------------------------------------------------------*/

HB_FUNC( GTK_TREE_STORE_REMOVE )
{
  GtkTreeStore * store = GTK_TREE_STORE( hb_parptr( 1 ) );
  GtkTreeIter  iter;
  PHB_ITEM pIter = hb_param( 2, HB_IT_ARRAY );
  BOOL bresult = FALSE;

  if ( Array2Iter( pIter, &iter ) )
  {
     bresult = gtk_tree_store_remove( store, &iter );
     FillArrayFromIter( &iter, pIter );
     
  }
  hb_retl( bresult );
}