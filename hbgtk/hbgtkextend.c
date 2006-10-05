/* $Id: hbgtkextend.c,v 1.3 2006-10-05 15:32:39 xthefull Exp $*/
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
 * hbGtkExtend. Extensiones de Harbour para acceso a GTK+ --------------------
 * Cuando sea necesario el acceso a estructuras de C que Harbour no soporta
 * recurriremos a estas funciones que 'simularan' esta carencia, ademas de
 * muchas otras 'maravillas' que descubriremos.
 *
 * Funciones implementadas :
 *  + hb_gtk_get_dlg_box()          Devuelve el contenedor vbox de un dialogo
 *  + hb_gtk_get_dlg_action_area()  Devuelve el contenedor action_area de un dialogo
 *  + hb_gtk_get_statusbar_label()  Devuelve widget label de un statusbar
 *  + hb_gtk_call_block()--interna- 'Ejecutor' de un codeblock en C
 *  + hb_gtk_signal_connect_block() Conexion de señales a codeblocks
 * Otra via  para conexion de señales :
 *  + hb_call_block() Callback de GTK_SIGNAL_CONNECT_HB_BLOCK
 *  + GTK_SIGNAL_CONNECT_HB_BLOCK()
 *  + HB_CLICK_CONNECT_BY_PARAM() Conectando con paso de parametro
 */

#include <gtk/gtk.h>
#include "hbapi.h"
#include "hbvm.h"
#include "hbapiitm.h"

// Atencion esto esta para mantener compatibilidad con xHarbour anteriores
// Deberá desaparecer , pero lo necesito ahora
#ifdef __OLDHARBOUR__
  HB_EXPORT PHB_SYMB hb_dynsymSymbol( PHB_DYNS pDynSym );
#endif

/**
 * Internals ...............................................................
 **/

void 
hb_gtk_call_block( GtkWidget * widget, gpointer data )
{
   PHB_ITEM pItem  = g_object_get_data( G_OBJECT( widget ), "Codeblock" );

  if( HB_IS_BLOCK(pItem) )
    {
	  // hb_vmEvalBlockV( pItem, nLong, PHB_ITEM );
	  hb_vmEvalBlock( pItem );
    }
  else
      g_warning( "Error hb_gtk_call_block: Se esperaba un codeblock \n" );
}

gint 
hb_gtk_call_block_destroy( GtkWidget * widget, gpointer data )
{
  PHB_ITEM pObj  = g_object_get_data( G_OBJECT( widget ), "Codeblock" );
  if( pObj )
    {
     /* Debug
      printf("\nC destroy %d classname %s \n", GPOINTER_TO_UINT( pObj ),
              hb_objGetClsName( pObj ) );
     */
      hb_gcGripDrop( pObj );
    }
  return FALSE;
}

gint 
click_connect_by_param( GtkWidget * widget, gpointer data )
{
  PHB_DYNS pDynSym = hb_dynsymFindName( data );
  PHB_ITEM pSelf   = g_object_get_data( G_OBJECT (widget), "click_user_data" );
  gpointer value;  /** type void pointer for cast **/
  
  if( pDynSym )
   {
    hb_vmPushSymbol( hb_dynsymSymbol( pDynSym ) );     // Coloca simbolo en la pila
    hb_vmPushNil();
    hb_vmPushLong( GPOINTER_TO_UINT( widget ) );
    
    if( HB_IS_STRING( pSelf ) ){
         value = ( gchar *) pSelf->item.asString.value;
         hb_vmPushString( value, strlen( value ) );
        }
    else if( HB_IS_INTEGER( pSelf ) ){
         hb_vmPushInteger( pSelf->item.asInteger.value );
        }
    else if( HB_IS_LOGICAL( pSelf ) ){
         hb_vmPushLogical( pSelf->item.asLogical.value );
        }
    else if( HB_IS_DATE( pSelf ) ){
         hb_vmPushDate( pSelf->item.asDate.value );
        } 
    else if( HB_IS_DOUBLE( pSelf ) ){
         hb_vmPushDouble( pSelf->item.asDouble.value, 10 );
        }

/* Estos hay que montarlos 'a mano'
else if( HB_IS_ARRAY( pSelf ) )
 pSelf->item.asArray.value;
else if( HB_IS_BLOCK( pSelf ) ) 
 pSelf->item.asBlock.value;     
*/      
    
    hb_vmDo( 2 );
//    return( hb_itemGetL( (PHB_ITEM) &hb_stack.Return ) );
    return( hb_parl( -1 ) );
   }
   else
   {
    g_print("No se encontro la funcion %s\n", (gchar*) data );
    return 0;;
   }
}

gint 
click_connect_destroy( gpointer data )
{
  /* Debug */
  g_warning( "ei, se libera correctamente :-)" );
  
 /** Esto libera memoria **/
  hb_gcGripDrop( data );
  return FALSE;
}

/**
 * NOTAS: NO USAR ESTAS FUNCIONES!!! ES EXPERIMENTAL....
 * Distintos metodos de conexion a señales .................................
 **/

HB_FUNC( HB_GTK_SIGNAL_CONNECT_BLOCK ) // widget, se¤al, codeblock -> NIL
{
  GtkWidget * widget = ( GtkWidget * ) hb_parnl( 1 );
  gchar *     signal = ( gchar * ) hb_parc( 2 );
  PHB_ITEM     pSelf = hb_param( 3, HB_IT_BLOCK );

  g_signal_connect( G_OBJECT( widget ), signal,
                    G_CALLBACK( hb_gtk_call_block ), pSelf );

/* Al conectar la señal al codeblock, se fuerza la conexion a la callback que
 * será llamada al destruirse el widget, liberando el codeblock de memoria,
 * Rafa una solucion muy 'eficiente' y 'transparente' al usuario.
 */

  if( g_object_get_data( G_OBJECT( widget ), "Codeblock" ) == NULL )
    {
      pSelf = hb_gcGripGet( hb_param( 3, HB_IT_BLOCK ) );
      g_object_set_data( G_OBJECT( widget ), "Codeblock", pSelf );

      g_signal_connect( G_OBJECT( widget ), "destroy",
                        G_CALLBACK( hb_gtk_call_block_destroy ), pSelf );
    }
}

/**
 * NOTAS: NO USAR ESTAS FUNCIONES!!! ES EXPERIMENTAL....
 * Distintos metodos de conexion a señales .................................
 **/
HB_FUNC( HB_CLICK_CONNECT_BY_PARAM ) // widget, salto a funcion, param
{
  GtkWidget * widget = ( GtkWidget * ) hb_parnl( 1 );
  gchar * cFunc      = hb_parc( 2 );
  gint iReturn       = 0;
  PHB_ITEM pSelf     = NULL;
  
 /**
  * Notas by Quim:
  * g_object_set_data_full variante de g_object_set_data, pero con posibilidad
  * de llamada a funcion cuando se destruye el widget.
  * Specifies the type of function which is called when a data element is destroyed. 
  * It is passed the pointer to the data element and should free any memory and 
  * resources allocated for it. 
  **/

  if( g_object_get_data( G_OBJECT (widget), "click_user_data" ) == NULL )
    {
     /** Esto reserva memoria **/
      pSelf = hb_gcGripGet( hb_param( 3, HB_IT_ANY ) );
  
     /**
      * Atencion !
      * Cualquier salida via gtk_main_quit() provocara que no se llame nunca
      * a la 'callback' destroy. Hay que 'cerrar' los contenedores para que
      * emitan la señal 'destroy' y se pueda autollamar a la funcion de
      * liberacion de memoria click_connect_destroy
      **/
      g_object_set_data_full( G_OBJECT (widget), "click_user_data", pSelf, 
                             (GDestroyNotify) click_connect_destroy );
      
      iReturn = g_signal_connect( G_OBJECT( widget ), "clicked",
                                  G_CALLBACK( click_connect_by_param ), cFunc );
    }                                   
  hb_retni( iReturn );
}


/**
 * Miscelaneas ............................................................
 **/

HB_FUNC( HB_GTK_GET_DLG_BOX ) //  nWidget dialog -> child vBox
{
  GtkWidget * box = GTK_DIALOG( hb_parnl( 1 ) )->vbox;
  hb_retnl( (glong) box );
}

HB_FUNC( HB_GTK_GET_DLG_ACTION_AREA ) //  nWidget dialog -> child action_area
{
  GtkWidget * area = GTK_DIALOG( hb_parnl( 1 ) )->action_area;
  hb_retnl( (glong) area );
}

HB_FUNC( HB_GTK_GET_STATUSBAR_LABEL ) //  nWidget statusbar -> child label
{
  GtkWidget * label = GTK_STATUSBAR( hb_parnl( 1 ) )->label;
  hb_retnl( (glong) label );
}

HB_FUNC( UTF_8 )
{
  gchar * iso = ISNIL( 2 ) ? "ISO-8859-1" : hb_parc( 2 );
  gchar *msg = g_convert( hb_parc(1), -1,"UTF-8", iso ,NULL,NULL,NULL );
  hb_retc( msg );
}

HB_FUNC( _UTF_8 )
{
  gchar * iso = ISNIL( 2 ) ? "ISO-8859-1" : hb_parc( 2 );
  gchar *msg = g_convert( hb_parc(1), -1, iso, "UTF-8" ,NULL,NULL,NULL );
  hb_retc( msg );
}

HB_FUNC( G_LOCALE_TO_UTF8 )
{
  
  gchar *msg = g_locale_to_utf8( hb_parc(1), -1, NULL, NULL, NULL);
  hb_retc( msg );
}

PHB_ITEM Rect2Array( GdkRectangle *rect );
BOOL Array2Rect(PHB_ITEM aRect, GdkRectangle *rect );

/*
 * Convierte una estructura item en un array de Harbour
 typedef struct {
  gint x;
  gint y;
  gint width;
  gint height;
} GdkRectangle;*/

PHB_ITEM Rect2Array( GdkRectangle *rect )
{
   PHB_ITEM aRect = hb_itemArrayNew(4);
   PHB_ITEM element = hb_itemNew( NULL );

   hb_arraySet( aRect, 1, hb_itemPutNI( element, rect->x ) );
   hb_arraySet( aRect, 2, hb_itemPutNI( element, rect->y ) );
   hb_arraySet( aRect, 3, hb_itemPutNI( element, rect->width ) );
   hb_arraySet( aRect, 4, hb_itemPutNI( element, rect->height ) );
   hb_itemRelease(element);
   return aRect;
}

/*
 * Convierte un array en un GdkRectangle
 * Comprueba si el dato pasado es correcto y su numero de elementos
 */
BOOL Array2Rect(PHB_ITEM aRect, GdkRectangle *rect )
{
   if (HB_IS_ARRAY( aRect ) && hb_arrayLen( aRect ) == 4)
   {
       rect->x      =  hb_arrayGetNI( aRect, 1 );
       rect->y      =  hb_arrayGetNI( aRect, 2 );
       rect->width  =  hb_arrayGetNI( aRect, 3 );
       rect->height =  hb_arrayGetNI( aRect, 4 );
      return TRUE ;
   }
   return FALSE;
}
