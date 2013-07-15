/* $Id: gtkliststore.c,v 1.3 2010-10-27 21:39:33 xthefull Exp $*/
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
 * GtkListStore. Modelo de datos para Browses y Trees ------------------------
 *  + gtk_list_store_set_value() PARCIAL!!
 */

/*
TODO:
void        gtk_list_store_set_valist       (GtkListStore *list_store,
                                             GtkTreeIter *iter,
                                             va_list var_args);
void        gtk_list_store_reorder          (GtkListStore *store,
                                             gint *new_order);
void        gtk_list_store_swap             (GtkListStore *store,
                                             GtkTreeIter *a,
                                             GtkTreeIter *b);
void        gtk_list_store_move_before      (GtkListStore *store,
                                             GtkTreeIter *iter,
                                             GtkTreeIter *position);
void        gtk_list_store_move_after       (GtkListStore *store,
                                             GtkTreeIter *iter,
                                             GtkTreeIter *position);
 */

#include <gtk/gtk.h>
#include "hbapi.h"
#include "hbapiitm.h"
#include "t-gtk.h"
#include "hbapierr.h"

#ifdef _GTK2_

void FillArrayFromIter( GtkTreeIter *iter, PHB_ITEM pArray );
PHB_ITEM Iter2Array( GtkTreeIter *iter  );
BOOL Array2Iter(PHB_ITEM aIter, GtkTreeIter *iter  );
BOOL BuildIterArrayFromParam( int iParam );


/*
 * Hb_gtk_list_store_new( aItems ) , recibe un array bi-dimensional para montar
 * el modelo de datos
 * */
HB_FUNC( HB_GTK_LIST_STORE_NEW ) // aItems -> pListStore
{
  GtkListStore * store;

  PHB_ITEM pArray2    = hb_param( 1, HB_IT_ARRAY );        // array
  PHB_ITEM pArray     = hb_arrayGetItemPtr( pArray2, 1 );   // 1 Array
  PHB_BASEARRAY pBase = pArray->item.asArray.value;        // base
  gint iCol;
  gint iLenCols       = hb_arrayLen( pArray );

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

  store = gtk_list_store_newv( iLenCols, colTypes );
  hb_retptr( ( GtkListStore * ) store );
}
/*--------------------------------------------------------------------------*/
/*--------------------------------------------------------------------------*/
HB_FUNC( HB_GTK_LIST_STORE_SET_LONG ) // liststore, column, item, data -> void
{
  GtkListStore * store = GTK_LIST_STORE( hb_parptr( 1 ) );
  PHB_ITEM pIter = hb_param( 3, HB_IT_ARRAY );        // array
  GtkTreeIter iter;

  if ( Array2Iter( pIter, &iter ) )
  {
     gtk_list_store_set( store, &iter, (gint) hb_parni( 2 ),
                    ( glong ) hb_parnl( 4 ), -1 );
     FillArrayFromIter( &iter, pIter );
  }
}

/*--------------------------------------------------------------------------*/
/*--------------------------------------------------------------------------*/
HB_FUNC( GTK_LIST_STORE_NEWV ) // iCantidad, { a_G_Types }-> pListStore
{
  GtkListStore * store;
  PHB_ITEM pArray = hb_param( 2, HB_IT_ARRAY );        // array
  gint iCol;
  gint iLenCols = hb_arrayLen( pArray );  // columnas
  GType colTypes[ iLenCols  ];    // array de tipos

  if( iLenCols != hb_parni( 1 ) )
    g_print("OJO, datos no concuerdan: %d pasado\n%d longitud de array\nEn la llamada a gtk_list_store_new",hb_parni(1),iLenCols);

  for( iCol = 0; iCol < iLenCols; iCol++ )
   {
     colTypes[ iCol ] = hb_arrayGetNI( pArray, iCol+1 );
   }
  store = gtk_list_store_newv( iLenCols, colTypes );
  hb_retptr( ( GtkListStore * ) store );
}

/*--------------------------------------------------------------------------*/
/*--------------------------------------------------------------------------*/
HB_FUNC( GTK_LIST_STORE_SET_COLUMN_TYPES ) // ListStore, n_columns, { a_G_Types }
{
  GtkListStore * store = GTK_LIST_STORE( hb_parptr( 1 ) );
  PHB_ITEM pArray = hb_param( 3, HB_IT_ARRAY );        // array
  gint iCol;
  gint iLenCols = hb_arrayLen( pArray );  // columnas
  GType colTypes[ iLenCols  ];    // array de tipos

  if( iLenCols != hb_parni( 2 ) )
    g_print("OJO, datos no concuerdan: %d pasado\n%d longitud de array\nEn la llamada a gtk_list_store_Set_colun_type",hb_parni(2),iLenCols);

  for( iCol = 0; iCol < iLenCols; iCol++ )
   {
     colTypes[ iCol ] = hb_arrayGetNI( pArray, iCol+1 );
   }

   gtk_list_store_set_column_types ( store, iLenCols, colTypes );

}

/*--------------------------------------------------------------------------*/
/*--------------------------------------------------------------------------*/
HB_FUNC( GTK_LIST_STORE_APPEND ) // liststore , aIter-> new Item
{
  GtkListStore * store = GTK_LIST_STORE( hb_parptr( 1 ) );
  PHB_ITEM aIter;// = hb_param( 2, HB_IT_ARRAY ); // array
  GtkTreeIter iter;

  gtk_list_store_append( store, &iter );

/*
 * Rafa : Esto no te podia funcionar, solo se cumple si
 * la longitud del array no es 4 y NUNCA se cumple si no
 * es un array, si no prueba de NO pasarle un array.
 * if (HB_IS_ARRAY( aIter ) && hb_arrayLen( aIter ) == 4 )
 *
 */
  
  if( BuildIterArrayFromParam( 2 ) )  { 
     aIter = hb_param( 2, HB_IT_ARRAY );
     FillArrayFromIter( &iter, aIter );
  }
  else
    hb_errRT_BASE( EG_ARG, 5000, GetGErrorMsg( 5000 ), HB_ERR_FUNCNAME, HB_ERR_ARGS_BASEPARAMS );

}

/*--------------------------------------------------------------------------*/
/*--------------------------------------------------------------------------*/
HB_FUNC( GTK_LIST_STORE_PREPEND ) // liststore, aIter -> new Item
{
  GtkListStore * store = GTK_LIST_STORE( hb_parptr( 1 ) );
  PHB_ITEM aIter = hb_param( 2, HB_IT_ARRAY ); // array
  GtkTreeIter iter;

  gtk_list_store_prepend( store, &iter );

  if( BuildIterArrayFromParam( 2 ) )  { 
     aIter = hb_param( 2, HB_IT_ARRAY );
     FillArrayFromIter( &iter, aIter );
  }
  else
    hb_errRT_BASE( EG_ARG, 5000, GetGErrorMsg( 5000 ), HB_ERR_FUNCNAME, HB_ERR_ARGS_BASEPARAMS );
   
}

/*--------------------------------------------------------------------------*/
/*--------------------------------------------------------------------------*/
HB_FUNC( GTK_LIST_STORE_CLEAR ) // liststore
{
  GtkListStore * store = GTK_LIST_STORE( hb_parptr( 1 ) );
  gtk_list_store_clear( store );
}

/*--------------------------------------------------------------------------*/
/*--------------------------------------------------------------------------*/
HB_FUNC( GTK_LIST_STORE_SET ) // liststore, column, item, data -> void
{

  GtkListStore * store = GTK_LIST_STORE( hb_parptr( 1 ) );
  GtkTreeIter iter;
  PHB_ITEM pIter = hb_param( 3, HB_IT_ARRAY );
  PHB_ITEM pValue = hb_param( 4, HB_IT_ANY );

  if ( Array2Iter( pIter, &iter ) )
  {
     if( HB_IS_STRING( pValue ) )
       gtk_list_store_set( store, &iter, (gint) hb_parni( 2 ),
                       hb_parc( 4 ), -1 );
     else if( HB_IS_INTEGER( pValue ) )
       gtk_list_store_set( store, &iter, (gint) hb_parni( 2 ),
                       hb_parni( 4 ), -1 );
     else if( HB_IS_DOUBLE( pValue ) )
       gtk_list_store_set( store, &iter, (gint) hb_parni( 2 ),
                       hb_parnd( 4 ), -1 );
     else if( HB_IS_LONG( pValue ) )
       gtk_list_store_set( store, &iter, (gint) hb_parni( 2 ),
                       hb_parnl( 4 ), -1 );
     else if( HB_IS_DATE( pValue ) )
       gtk_list_store_set( store, &iter, (gint) hb_parni( 2 ),
                       hb_pards( 4 ), -1 );
     else if( HB_IS_LOGICAL( pValue ) )
       gtk_list_store_set( store, &iter, (gint) hb_parni( 2 ),
                       hb_parl( 4 ), -1 );
     else if( HB_IS_POINTER( pValue ) )
       gtk_list_store_set( store, &iter, (gint) hb_parni( 2 ),
                       hb_parptr( 4 ), -1 );                       

     FillArrayFromIter( &iter, pIter );
  }

}

/*--------------------------------------------------------------------------*/
/* TODO: Falta la implementacion de GValue.*/
/*--------------------------------------------------------------------------*/
HB_FUNC( GTK_LIST_STORE_SET_VALUE ) // liststore, iter , column, GValue -> void
{
  GtkListStore * store = GTK_LIST_STORE( hb_parptr( 1 ) );
  GtkTreeIter iter;
  PHB_ITEM pIter = hb_param( 2, HB_IT_ARRAY );
  gint column   = hb_parni( 3 );
  GValue * value =  ( GValue * )hb_parni( 4 ) ;

  if ( Array2Iter( pIter, &iter ) )
  {
    gtk_list_store_set_value( store, &iter, column,  value );
  }

}


/*--------------------------------------------------------------------------*/
/*--------------------------------------------------------------------------*/
HB_FUNC( GTK_LIST_STORE_REMOVE )
{
  GtkListStore * store = GTK_LIST_STORE( hb_parptr( 1 ) );
  GtkTreeIter  iter;
  PHB_ITEM pIter = hb_param( 2, HB_IT_ARRAY );
  BOOL bresult = FALSE;

  if ( Array2Iter( pIter, &iter ) )
  {
     bresult = gtk_list_store_remove( store, &iter );
     FillArrayFromIter( &iter, pIter );
     
  }
  hb_retl( bresult );
}

/*--------------------------------------------------------------------------*/
/*--------------------------------------------------------------------------*/
HB_FUNC( GTK_LIST_STORE_INSERT )
{
  GtkListStore * store = GTK_LIST_STORE( hb_parptr( 1 ) );
  PHB_ITEM pIter;
  gint position = hb_parni( 3 );
  GtkTreeIter  iter;

  if( BuildIterArrayFromParam( 2 ) )  { 
     pIter = hb_param( 2, HB_IT_ARRAY );
     if ( Array2Iter( pIter, &iter ) )
     {
        gtk_list_store_insert( store, &iter, position );
        FillArrayFromIter( &iter, pIter );
     }
  }
  else
    hb_errRT_BASE( EG_ARG, 5000, GetGErrorMsg( 5000 ), HB_ERR_FUNCNAME, HB_ERR_ARGS_BASEPARAMS );  
  

}

/*--------------------------------------------------------------------------*/
/*--------------------------------------------------------------------------*/
HB_FUNC( GTK_LIST_STORE_INSERT_BEFORE )
{
  GtkListStore * store = GTK_LIST_STORE( hb_parptr( 1 ) );
  PHB_ITEM pIter = hb_param( 2, HB_IT_ARRAY );
  PHB_ITEM pSibling = hb_param( 3, HB_IT_ARRAY );
  PHB_ITEM pSibling2 = hb_param( 4, HB_IT_ARRAY );
  GtkTreeIter  iter, sibling;

  if ( Array2Iter( pIter, &iter ) )
     {
      if( ISNIL( 3 ) )
         {
          gtk_list_store_insert_before( store, &iter, NULL );
          FillArrayFromIter( &iter, pIter );
         }
      else
         {
          if ( Array2Iter( pSibling, &sibling ) )
             {
              gtk_list_store_insert_before( store, &iter, &sibling );
              FillArrayFromIter( &iter, pSibling );
              FillArrayFromIter( &sibling, pSibling2 );
              }
          }
     }

}

/*--------------------------------------------------------------------------*/
/*--------------------------------------------------------------------------*/
HB_FUNC( GTK_LIST_STORE_INSERT_AFTER )
{
  GtkListStore * store = GTK_LIST_STORE( hb_parptr( 1 ) );
  PHB_ITEM pIter;
  PHB_ITEM pSibling;
  PHB_ITEM pSibling2 = hb_param( 4, HB_IT_ARRAY );
  GtkTreeIter  iter, sibling;

  
  if( BuildIterArrayFromParam( 2 ) )
  {
     pIter = hb_param( 2, HB_IT_ANY );
     if ( Array2Iter( pIter, &iter ) )
     {
         if( ISNIL( 3 ) )
         {
             gtk_list_store_insert_after( store, &iter, NULL );
             FillArrayFromIter( &iter, pIter );
         }
         else
         {
	    if( BuildIterArrayFromParam( 3 ) )
	    {
	       pSibling = hb_param( 3, HB_IT_ANY );
               if ( Array2Iter( pSibling, &sibling ) )
               {
                  gtk_list_store_insert_after( store, &iter, &sibling );
                  FillArrayFromIter( &iter, pSibling );
                  FillArrayFromIter( &sibling, pSibling2 );
               }
	    }else
	      hb_errRT_BASE( EG_ARG, 5000, GetGErrorMsg( 5000 ), HB_ERR_FUNCNAME, HB_ERR_ARGS_BASEPARAMS );
         }
      }
   }
   else
      hb_errRT_BASE( EG_ARG, 5000, GetGErrorMsg( 5000 ), HB_ERR_FUNCNAME, HB_ERR_ARGS_BASEPARAMS );

}

/*--------------------------------------------------------------------------*/
// WARNING: This function is slow. Only use it for debugging and/or testing purposes.
/*--------------------------------------------------------------------------*/
HB_FUNC( GTK_LIST_STORE_ITER_IS_VALID )
{
  GtkListStore * store = GTK_LIST_STORE( hb_parptr( 1 ) );
  PHB_ITEM pIter = hb_param( 2, HB_IT_ARRAY );
  GtkTreeIter  iter;
  gboolean result = FALSE;
  if ( Array2Iter( pIter, &iter ) )
  {
    result = gtk_list_store_iter_is_valid( store, &iter );
  }
  hb_retl( result );
}


/*
 * struct GtkTreeIter {

  gint stamp;
  gpointer user_data;
  gpointer user_data2;
  gpointer user_data3;
};
*/

/* A nivel de harbour, convertimos un puntero Iter a un array*/
HB_FUNC( ITER2ARRAY )
{
  GtkTreeIter * iter = hb_parptr( 1 ) ;
  PHB_ITEM pIter = hb_param( 2, HB_IT_ARRAY );
  FillArrayFromIter( iter, pIter );
}

/*
 * Convierte una estructura item en un array de Harbour
 * */
PHB_ITEM Iter2Array( GtkTreeIter *iter  )
{
   PHB_ITEM aIter = hb_itemArrayNew( 4 );
   PHB_ITEM element = hb_itemNew( NULL );

   hb_arraySet( aIter, 1, hb_itemPutNI( element, (gint) iter->stamp ) );
   hb_arraySet( aIter, 2, hb_itemPutPtr( element, (gpointer) iter->user_data ) );
   hb_arraySet( aIter, 3, hb_itemPutPtr( element, (gpointer) iter->user_data2 ) );
   hb_arraySet( aIter, 4, hb_itemPutPtr( element, (gpointer) iter->user_data3 ) );
   hb_itemRelease(element);
   return aIter;
}

/*
 * Convierte un array en un Iter
 * Comprueba si el dato pasado es correcto y su numero de elementos
 */
BOOL Array2Iter(PHB_ITEM aIter, GtkTreeIter *iter  )
{
   if (HB_IS_ARRAY( aIter ) && hb_arrayLen( aIter ) == 4) {
       iter->stamp      = (gint) hb_arrayGetNI( aIter, 1 );
       iter->user_data  = (gpointer) hb_arrayGetPtr( aIter, 2 );
       iter->user_data2 = (gpointer) hb_arrayGetPtr( aIter, 3 );
       iter->user_data3 = (gpointer) hb_arrayGetPtr( aIter, 4 );
      return TRUE ;
   }
   return FALSE;
}

/*
 * Fill harbour array with iter structure
 *
 */

void  FillArrayFromIter( GtkTreeIter *iter, PHB_ITEM pArray  )
{
   PHB_ITEM element = hb_itemNew( NULL );

   hb_arraySet( pArray, 1, hb_itemPutNI( element, (gint) iter->stamp ) );
   hb_arraySet( pArray, 2, hb_itemPutPtr( element, (gpointer) iter->user_data ) );
   hb_arraySet( pArray, 3, hb_itemPutPtr( element, (gpointer) iter->user_data2 ) );
   hb_arraySet( pArray, 4, hb_itemPutPtr( element, (gpointer) iter->user_data3 ) );
   hb_itemRelease(element);
}


BOOL BuildIterArrayFromParam( int iParam )
{
   
   BOOL bRet = TRUE;
   PHB_ITEM pItem = hb_param( iParam, HB_IT_ANY );

   if( ISARRAY( iParam) ){
      if( hb_arrayLen( pItem )  != 4 ){
         int i;
         int iLen = hb_arrayLen( pItem );
         for( i = 0; i < 4 - iLen; i++)
         {
            PHB_ITEM pPos = hb_itemNew( NULL );
            hb_arrayAddForward( pItem, pPos );
            hb_itemRelease( pPos );
         }
      }
   }
   else if( ISBYREF( iParam ) ){
      int i;
      PHB_ITEM pArray = hb_itemArrayNew( 0 );
         for( i = 0; i < 4; i++)
         {
            PHB_ITEM pPos = hb_itemNew( NULL );
            hb_arrayAddForward( pArray, pPos );
            hb_itemRelease( pPos );
         }               
#ifdef __XHARBOUR__
      // TODO: buscar sustituto para esta funcion  (RIGC) 
      //hb_itemParamStoreForward( iParam, pArray );
#else
      hb_itemParamStoreForward( iParam, pArray );
#endif
   }
   else
     bRet = FALSE;
  
   return bRet;
}

/*-----------------21/01/2005 18:53-----------------
 * Otra opcion
 * --------------------------------------------------*/
/*
 *
FUNCTION Test()

  // Cargamos la estructura desde C
  LOCAL color := GetColor()

  // Cambiamos un miembro
  color.r = 100

  // La volvemos a pasar a C
  ParseColor( color )

RETURN Nil


HB_FUNC( GETCOLOR )
{
   COLOR color;

   color.r = 255;
   color.g = 150;
   color.b = 50;

   hb_retclen( (char*) &color, sizeof( COLOR ) );
}

HB_FUNC( PARSECOLOR )
{
   COLOR color = (COLOR) hb_param( 1, HB_IT_STRING )->item.asString.value;

   if( color.r == 100 )
      OutputDebugString( "Funciona !!" );
}
*/

/*
Funciones descatalogadas
HB_FUNC( _GTK_LIST_STORE_APPEND ) // liststore -> new Item
{
  GtkListStore * store = GTK_LIST_STORE( hb_parnl( 1 ) );
  GtkTreeIter iter;
  gtk_list_store_append( store, &iter );
  hb_retnl( (glong) iter.user_data );
}
HB_FUNC( _GTK_LIST_STORE_SET ) // liststore, column, item, data -> void
{
  GtkListStore * store = GTK_LIST_STORE( hb_parnl( 1 ) );
  GtkTreeIter iter;
  iter.stamp = store->stamp;
  iter.user_data = ( glong * ) hb_parnl( 3 );
  gtk_list_store_set( store, &iter, (gint) hb_parni( 2 ),
                      ( gchar * ) hb_parc( 4 ), -1 );
}
 Averiguamos el tipo de dato pasado, y eso lo meteremos correctamente
 HB_FUNC( _GTK_LIST_STORE_SET_B ) // liststore, column, item, data -> void
{
  GtkListStore * store = GTK_LIST_STORE( hb_parnl( 1 ) );
  GtkTreeIter iter;
  iter.stamp = store->stamp;
  iter.user_data = ( glong * ) hb_parnl( 3 );
  PHB_ITEM pValue = hb_param( 4, HB_IT_ANY ); // cualquier cosa
  if( HB_IS_STRING( pValue ) )
       gtk_list_store_set( store, &iter, (gint) hb_parni( 2 ),
                       hb_parc( 4 ), -1 );
  else if( HB_IS_INTEGER( pValue ) )
       gtk_list_store_set( store, &iter, (gint) hb_parni( 2 ),
                       hb_parni( 4 ), -1 );
  else if( HB_IS_DOUBLE( pValue ) )
       gtk_list_store_set( store, &iter, (gint) hb_parni( 2 ),
                       hb_parnd( 4 ), -1 );
  else if( HB_IS_LONG( pValue ) )
       gtk_list_store_set( store, &iter, (gint) hb_parni( 2 ),
                       hb_parnl( 4 ), -1 );
  else if( HB_IS_DATE( pValue ) )
       gtk_list_store_set( store, &iter, (gint) hb_parni( 2 ),
                       hb_parnl( 4 ), -1 );
  else if( HB_IS_LOGICAL( pValue ) )
       gtk_list_store_set( store, &iter, (gint) hb_parni( 2 ),
                       hb_parl( 4 ), -1 );
}

*/

#endif
