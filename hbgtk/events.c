/* $Id: events.c,v 1.4 2006-09-21 22:47:04 xthefull Exp $*/
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
 *   KERNEL T-GTK [ Control conexion de seÒales de GTK+ ]
 *  (c)2003 Rafa Carmona
 */
#include <gtk/gtk.h>
#include "t-gtk.h"
#include "hbapi.h"
#include "hbvm.h"
#include "hbapiitm.h"
#include "hbstack.h"

// Atencion esto esta para mantener compatibilidad con xHarbour anteriores
// Deber· desaparecer , pero lo necesito ahora
#ifdef __OLDHARBOUR__
  HB_EXPORT PHB_SYMB hb_dynsymSymbol( PHB_DYNS pDynSym )
  {
    return pDynSym->pSymbol;
  }
#endif
/* ------------------------------------------------------------------- */

/*---------------------------------------------------
// CALLBACK generica para diferentes seÒales.
---------------------------------------------------*/
gint OnEventos( GtkWidget * widget, gpointer data )
{
  PHB_ITEM pObj   = g_object_get_data( G_OBJECT( widget ), "Self" );
  PHB_ITEM pBlock;
  PHB_DYNS pMethod;

  if( pObj ) {
     pMethod = hb_dynsymFindName( data );
     if( pMethod ){
        hb_vmPushSymbol( hb_dynsymSymbol( pMethod ) );     // Coloca simbolo en la pila
        hb_vmPush( pObj );                       // Coloca objeto en pila.
        hb_vmPush( pObj );                       // Dato a pasar
        hb_vmSend( 1 );                          // LLamada por Send
        return( hb_parl( -1 ) );
     } else {
        g_print( "Method doesn't exist OnEventos" );
     }
  }
  // Obtenemos el codeblock de la seÒal, data, que debemos evaluar...
  if( pObj == NULL ){
     pBlock = g_object_get_data( G_OBJECT( widget ), (gchar*) data );
     if( pBlock ) {
        hb_vmPushSymbol( &hb_symEval );
        hb_vmPush( pBlock );
        hb_vmPushLong( GPOINTER_TO_UINT( widget ) );  // Metemos puntero del widget
        hb_vmSend( 1 );                               // LLamada por Send al codeblocks
        // Esto es otra manera de ejecutar un codeblock
        //PHB_ITEM h_widget;
        //h_widget = hb_itemPutNL( NULL, GPOINTER_TO_UINT( widget ) ); // Dato a pasar al Codeblock
        //hb_vmEvalBlockV( hb_itemUnRef( pBlock ), 1, h_widget );
        //hb_itemRelease( h_widget );
        return( hb_parl( -1 ) );
     }
  }

  return FALSE;
}

/*---------------------------------------------------
// CALLBACK generica para diferentes seÒales.
---------------------------------------------------*/
void OnEventos_void( GtkWidget * widget, gpointer data )
{
  PHB_ITEM pObj   = g_object_get_data( G_OBJECT( widget ), "Self" );
  PHB_ITEM pBlock;
  PHB_DYNS pMethod;

  if( pObj ) {
     pMethod = hb_dynsymFindName( data );
     if( pMethod ){
        hb_vmPushSymbol( hb_dynsymSymbol( pMethod ) );     // Coloca simbolo en la pila
        hb_vmPush( pObj );                       // Coloca objeto en pila.
        hb_vmPush( pObj );                       // Dato a pasar
        hb_vmSend( 1 );                          // LLamada por Send
     } else {
        g_print( "Method doesn't exist OnEventos_void" );
     }
  }
  // Obtenemos el codeblock de la seÒal, data, que debemos evaluar...
  if( pObj == NULL ){
     pBlock = g_object_get_data( G_OBJECT( widget ), (gchar*) data );
     if( pBlock ) {
        hb_vmPushSymbol( &hb_symEval );
        hb_vmPush( pBlock );
        hb_vmPushLong( GPOINTER_TO_UINT( widget ) );  // Metemos puntero del widget
        hb_vmSend( 1 );                               // LLamada por Send al codeblocks
     }
  }
}

// **********************************************************************
// Sirve para EVENT y ONDELETE_EVENT
// **********************************************************************
gboolean OnDelete_Event( GtkWidget *widget, GdkEvent  *event, gpointer data )
{
 PHB_ITEM pObj   = g_object_get_data( G_OBJECT( widget ), "Self" );
 PHB_ITEM pBlock;
 PHB_DYNS pMethod;

 if( pObj  ) {
     pMethod = hb_dynsymFindName( data );
     if( pMethod ){
        hb_vmPushSymbol( hb_dynsymSymbol( pMethod ) );     // Coloca simbolo en la pila
        hb_vmPush( pObj );                       // Coloca objeto en pila.
        hb_vmPush( pObj );                       // Dato a pasar
        hb_vmPushLong( GPOINTER_TO_UINT( event ) );  // // Pointer de struct event
        hb_vmSend( 2 );                              // LLamada por Send
        return( hb_parl( -1 ) );
     } else {
        g_print( "Method doesn't exist OnDelete_Event" );
     }
  }

  // Obtenemos el codeblock de la seÒal, data, que debemos evaluar...
  if( pObj == NULL ){
     pBlock = g_object_get_data( G_OBJECT( widget ), (gchar*) data );
     if( pBlock ) {
        hb_vmPushSymbol( &hb_symEval );
        hb_vmPush( pBlock );
        hb_vmPushLong( GPOINTER_TO_UINT( widget ) );
        hb_vmPushLong( GPOINTER_TO_UINT( event ) );
        hb_vmSend( 2 );
        return( hb_parl( -1 ) );
     }
  }

return( FALSE );  // Salimos
}

void OnEvent_After( GtkWidget *widget, GdkEvent  *event, gpointer data )
{
 PHB_ITEM pObj   = g_object_get_data( G_OBJECT( widget ), "Self" );
 PHB_ITEM pBlock;
 PHB_DYNS pMethod;

 if( pObj  ) {
     pMethod = hb_dynsymFindName( data );
     if( pMethod ){
        hb_vmPushSymbol( hb_dynsymSymbol( pMethod ) );     // Coloca simbolo en la pila
        hb_vmPush( pObj );                       // Coloca objeto en pila.
        hb_vmPush( pObj );                       // Dato a pasar
        hb_vmPushLong( GPOINTER_TO_UINT( event ) );  // // Pointer de struct event
        hb_vmSend( 2 );                              // LLamada por Send
     } else {
        g_print( "Method doesn't exist OnEventAfter" );
     }
  }

  // Obtenemos el codeblock de la seÒal, data, que debemos evaluar...
  if( pObj == NULL ){
     pBlock = g_object_get_data( G_OBJECT( widget ), (gchar*) data );
     if( pBlock ) {
        hb_vmPushSymbol( &hb_symEval );
        hb_vmPush( pBlock );
        hb_vmPushLong( GPOINTER_TO_UINT( widget ) );
        hb_vmPushLong( GPOINTER_TO_UINT( event ) );
        hb_vmSend( 2 );
     }
  }

}

/* Evento "response" para dialogos */
gint OnResponse( GtkDialog * widget, gint arg1, gpointer data )
{
  PHB_ITEM pObj  = g_object_get_data( G_OBJECT( widget ), "Self" );
  PHB_DYNS pMethod;
  PHB_ITEM pBlock;

 if( pObj  ) {
     pMethod = hb_dynsymFindName( data );
     if( pMethod ){
        hb_vmPushSymbol( hb_dynsymSymbol( pMethod ) );     // Coloca simbolo en la pila
        hb_vmPush( pObj );                       // Coloca objeto en pila.
        hb_vmPush( pObj );                       // Dato a pasar
        hb_vmPushInteger( (gint) arg1 );         // senyal producida
        hb_vmSend( 2 );                              // LLamada por Send
        return( hb_parl( -1 ) );
     } else {
        g_print( "Method doesn't exist OnEventos" );
     }
  }

  // Obtenemos el codeblock de la seÒal, data, que debemos evaluar...
  if( pObj == NULL ){
     pBlock = g_object_get_data( G_OBJECT( widget ), (gchar*) data );
     if( pBlock ) {
        hb_vmPushSymbol( &hb_symEval );
        hb_vmPush( pBlock );
        hb_vmPushLong( GPOINTER_TO_UINT( widget ) );
        hb_vmPushInteger( arg1 );
        hb_vmSend( 2 );
        return( hb_parl( -1 ) );
     }
  }

  return( FALSE );
}

gint OnKeyPressEvent( GtkWidget * widget, GdkEventKey * event, gpointer data )
{
  PHB_ITEM pObj  = g_object_get_data( G_OBJECT( widget ), "Self" );
  PHB_DYNS pMethod;
  PHB_ITEM pBlock;
//  PHB_ITEM ReturnArray, ArrayItem, pBlock;

  if( pObj  ) {
     pMethod = hb_dynsymFindName( data );
     if( pMethod ){
// Nota: Desactivo esto, y lo dejo como recordatorio de como pasar un array, nada mas.
//         ReturnArray = hb_itemArrayNew( 10 );
//         ArrayItem = hb_itemNew( NULL );
//         // METO ELEMENTOS DE ARRAY
//         hb_itemPutNI( ArrayItem, event->type );            /* GdkEventType type */
//         hb_itemArrayPut( ReturnArray, 1, ArrayItem );

//         hb_itemPutNL( ArrayItem, (glong) event->window );  /* GdkWindow *window  */
//         hb_itemArrayPut( ReturnArray, 2, ArrayItem );

//         hb_itemPutNI( ArrayItem, event->send_event );      /* gint8 send_event */
//         hb_itemArrayPut( ReturnArray, 3, ArrayItem );

//         hb_itemPutNI( ArrayItem, event->time );            /* guint32 time */
//         hb_itemArrayPut( ReturnArray, 4, ArrayItem );

//         hb_itemPutNI( ArrayItem, event->state );           /* guint state */
//         hb_itemArrayPut( ReturnArray, 5, ArrayItem );

//         hb_itemPutNI( ArrayItem, event->keyval );          /* guint keyval */
//         hb_itemArrayPut( ReturnArray, 6, ArrayItem );

//         hb_itemPutNI( ArrayItem, event->length );          /* gint length */
//         hb_itemArrayPut( ReturnArray, 7, ArrayItem );

//         hb_itemPutC( ArrayItem, event->string );           /* gchar *string */
//         hb_itemArrayPut( ReturnArray, 8, ArrayItem );

//         hb_itemPutNI( ArrayItem, event->hardware_keycode ); /* guint16 hardware_keycode */
//         hb_itemArrayPut( ReturnArray, 9, ArrayItem );

//         hb_itemPutNI( ArrayItem, event->group );           /* guint8 group */
//         hb_itemArrayPut( ReturnArray,10, ArrayItem );

         hb_vmPushSymbol( hb_dynsymSymbol( pMethod ) );     // Coloca simbolo en la pila
         hb_vmPush( pObj );                       // Coloca objeto en pila.
         hb_vmPush( pObj );                       // oSender
         hb_vmPushLong( GPOINTER_TO_UINT( event ) );
//         hb_vmPush( ReturnArray );                // Meto array
         hb_vmSend( 2 );                          // LLamada por Send que pasa

//         hb_itemRelease( ReturnArray );           /* Libero memoria*/
//         hb_itemRelease( ArrayItem );
         return( hb_parl( -1 ) );
     } else {
       g_print( "Method doesn't %s exist en OnKeyPressEvent ", (gchar *)data );
     }
  }

  // Obtenemos el codeblock de la seÒal, data, que debemos evaluar...
  if( pObj == NULL ){
     pBlock = g_object_get_data( G_OBJECT( widget ), (gchar*) data );
     if( pBlock ) {
        hb_vmPushSymbol( &hb_symEval );
        hb_vmPush( pBlock );
        hb_vmPushLong( GPOINTER_TO_UINT( widget ) );
        hb_vmPushLong( GPOINTER_TO_UINT( event ) );
        hb_vmSend( 2 );
        return( hb_parl( -1 ) );
     }
  }

  return FALSE;

}

gint OnFocusEvent( GtkWidget *widget, GdkEventFocus * event, gpointer data )
{
  PHB_ITEM pObj  = g_object_get_data( G_OBJECT( widget ), "Self" );
  PHB_ITEM pBlock;
  PHB_DYNS pMethod;

  if( pObj ) {
     pMethod = hb_dynsymFindName( data );
     if( pMethod ){
        hb_vmPushSymbol( hb_dynsymSymbol( pMethod ) );     // Coloca simbolo en la pila
        hb_vmPush( pObj );                       // Coloca objeto en pila.
        hb_vmPush( pObj );                       // Dato a pasar
        hb_vmPushLong( GPOINTER_TO_UINT( event ) );  // Metemos puntero
        hb_vmSend( 2 );                          // LLamada por Send
        return( hb_parl( -1 ) );
     } else {
        g_print( "Method doesn't exist OnFocusEvent" );
     }
  }
  // Obtenemos el codeblock de la seÒal, data, que debemos evaluar...
  if( pObj == NULL ){
     pBlock = g_object_get_data( G_OBJECT( widget ), (gchar*) data );
     if( pBlock ) {
        hb_vmPushSymbol( &hb_symEval );
        hb_vmPush( pBlock );
        hb_vmPushLong( GPOINTER_TO_UINT( widget ) );  // Metemos puntero del widget
        hb_vmPushLong( GPOINTER_TO_UINT( event ) );  // Metemos puntero
        hb_vmSend( 2 );                               // LLamada por Send al codeblocks
        return( hb_parl( -1 ) );
     }
  }

  return FALSE;
}

void OnMove_slider( GtkWidget *widget, GtkScrollType arg1, gpointer data )
{
  PHB_ITEM pObj  = g_object_get_data( G_OBJECT( widget ), "Self" );
  PHB_ITEM pBlock;
  PHB_DYNS pMethod;

  if( pObj ) {
     pMethod = hb_dynsymFindName( data );
     if( pMethod ){
        hb_vmPushSymbol( hb_dynsymSymbol( pMethod ) );     // Coloca simbolo en la pila
        hb_vmPush( pObj );                       // Coloca objeto en pila.
        hb_vmPush( pObj );                       // Dato a pasar
        hb_vmPushInteger( arg1 );                // GtkScrollType
        hb_vmSend( 2 );                          // LLamada por Send
     } else {
        g_print( "Method doesn't %s exist en OnMove_slider ", (gchar *)data ) ;
     }
  }
  // Obtenemos el codeblock de la seÒal, data, que debemos evaluar...
  if( pObj == NULL ){
     pBlock = g_object_get_data( G_OBJECT( widget ), (gchar*) data );
     if( pBlock ) {
        hb_vmPushSymbol( &hb_symEval );
        hb_vmPush( pBlock );
        hb_vmPushLong( GPOINTER_TO_UINT( widget ) );  // Metemos puntero del widget
        hb_vmPushInteger( arg1 );                     // GtkScrollType
        hb_vmSend( 2 );                               // LLamada por Send al codeblocks
     }
  }
}

void OnSelect_child ( GtkList *list,  GtkWidget *widget, gpointer data )
{
  PHB_ITEM pObj  = g_object_get_data( G_OBJECT( list ), "Self" );
  PHB_ITEM pBlock;
  PHB_DYNS pMethod;

  if( pObj ) {
     pMethod = hb_dynsymFindName( data );
     if( pMethod ){
        hb_vmPushSymbol( hb_dynsymSymbol( pMethod ) );     // Coloca simbolo en la pila
        hb_vmPush( pObj );                            // Coloca objeto en pila.
        hb_vmPush( pObj );                            // Dato a pasar
        hb_vmPushLong( GPOINTER_TO_UINT( widget ) );  // Pointer widget child
        hb_vmSend( 2 );                               // LLamada por Send
     } else {
        g_print( "Method doesn't %s exist en OnSelect_child ", (gchar *)data);
     }
  }

  // Obtenemos el codeblock de la seÒal, data, que debemos evaluar...
  if( pObj == NULL ){
     pBlock = g_object_get_data( G_OBJECT( list ), (gchar*) data );
     if( pBlock ) {
        hb_vmPushSymbol( &hb_symEval );
        hb_vmPush( pBlock );
        hb_vmPushLong( GPOINTER_TO_UINT( list ) );
        hb_vmPushLong( GPOINTER_TO_UINT( widget ) );
        hb_vmSend( 2 );
     }
  }

}

void OnSelection_changed( GtkList *list, gpointer data )
{
  PHB_ITEM pObj  = g_object_get_data( G_OBJECT( list ), "Self" );
  PHB_ITEM pBlock;
  PHB_DYNS pMethod;

  if( pObj ) {
     pMethod = hb_dynsymFindName( data );
     if( pMethod ){
        hb_vmPushSymbol( hb_dynsymSymbol( pMethod ) );     // Coloca simbolo en la pila
        hb_vmPush( pObj );                            // Coloca objeto en pila.
        hb_vmPush( pObj );                            // Dato a pasar
        hb_vmSend( 1 );                               // LLamada por Send
     } else {
        g_print( "Method doesn't %s exist en OnSelection ", (gchar *)data );
     }
  }

  // Obtenemos el codeblock de la seÒal, data, que debemos evaluar...
  if( pObj == NULL ){
     pBlock = g_object_get_data( G_OBJECT( list ), (gchar*) data );
     if( pBlock ) {
        hb_vmPushSymbol( &hb_symEval );
        hb_vmPush( pBlock );
        hb_vmPushLong( GPOINTER_TO_UINT( list ) );
        hb_vmSend( 1 );
     }
  }

}

void OnSwitch_page( GtkNotebook *notebook, GtkNotebookPage *page, guint page_num, gpointer data )
{
  PHB_ITEM pObj  = g_object_get_data( G_OBJECT( notebook ), "Self" );
  PHB_ITEM pBlock;
  PHB_DYNS pMethod;

  if( pObj ) {
     pMethod = hb_dynsymFindName( data );
     if( pMethod ){
        hb_vmPushSymbol( hb_dynsymSymbol( pMethod ) );     // Coloca simbolo en la pila
        hb_vmPush( pObj );                            // Coloca objeto en pila.
        hb_vmPush( pObj );                            // oSender
        hb_vmPushLong( GPOINTER_TO_UINT( page ) );    // page
        hb_vmPushInteger( page_num );                 // numero de pagina actual
        hb_vmSend( 3 );                               // LLamada por Send que pasa
     } else {
        g_print( "Method doesn't %s exist en OnSwitch_page", (gchar *)data );
     }
  }

  // Obtenemos el codeblock de la seÒal, data, que debemos evaluar...
  if( pObj == NULL ){
     pBlock = g_object_get_data( G_OBJECT( notebook ), (gchar*) data );
     if( pBlock ) {
        hb_vmPushSymbol( &hb_symEval );
        hb_vmPush( pBlock );
        hb_vmPushLong( GPOINTER_TO_UINT( notebook ) ); // notebook
        hb_vmPushLong( GPOINTER_TO_UINT( page ) );     // page
        hb_vmPushInteger( page_num );                  // numero de pagina actual
        hb_vmSend( 3 );
     }
  }
}

void OnGroup_changed( GtkRadioButton *radiobutton, gpointer data )
{
  PHB_ITEM pObj  = g_object_get_data( G_OBJECT( radiobutton ), "Self" );
  PHB_ITEM pBlock;
  PHB_DYNS pMethod;

  if( pObj ) {
     pMethod = hb_dynsymFindName( data );
     if( pMethod ){
        hb_vmPushSymbol( hb_dynsymSymbol( pMethod ) );     // Coloca simbolo en la pila
        hb_vmPush( pObj );                            // Coloca objeto en pila.
        hb_vmPush( pObj );                            // oSender
        hb_vmSend( 1 );                               // LLamada por Send que pasa
     } else {
       g_print( "Method doesn't %s exist en OnGroup_changed ", (gchar *)data );
     }
  }

  // Obtenemos el codeblock de la seÒal, data, que debemos evaluar...
  if( pObj == NULL ){
     pBlock = g_object_get_data( G_OBJECT( radiobutton ), (gchar*) data );
     if( pBlock ) {
        hb_vmPushSymbol( &hb_symEval );
        hb_vmPush( pBlock );
        hb_vmPushLong( GPOINTER_TO_UINT( radiobutton ) );
        hb_vmSend( 1 );
     }
  }

}

/* SeÒal para GtkCellRendererText ó Renders text in a cell */
void OnRow_activated( GtkTreeView *treeview, GtkTreePath *path, GtkTreeViewColumn *col, gpointer data  )
{
  PHB_ITEM pObj  = g_object_get_data( G_OBJECT( treeview ), "Self" );
  PHB_ITEM pBlock;
  PHB_DYNS pMethod;

  if( pObj ) {
     pMethod = hb_dynsymFindName( data );
     if( pMethod ){
        hb_vmPushSymbol( hb_dynsymSymbol( pMethod ) );     // Coloca simbolo en la pila
        hb_vmPush( pObj );                            // Coloca objeto en pila.
        hb_vmPush( pObj );                            // oSender
        hb_vmPushLong( GPOINTER_TO_UINT( path ) );
        hb_vmPushLong( GPOINTER_TO_UINT( col  ) );
        hb_vmSend( 3 );                               // LLamada por Send que pasa
     } else {
       g_print( "Method doesn't %s exist en OnRow_Activate", (gchar *)data );
     }
  }

  // Obtenemos el codeblock de la seÒal, data, que debemos evaluar...
  if( pObj == NULL ){
     pBlock = g_object_get_data( G_OBJECT( treeview ), (gchar*) data );
     if( pBlock ) {
        hb_vmPushSymbol( &hb_symEval );
        hb_vmPush( pBlock );
        hb_vmPushLong( GPOINTER_TO_UINT( treeview ) );
        hb_vmPushLong( GPOINTER_TO_UINT( path ) );
        hb_vmPushLong( GPOINTER_TO_UINT( col  ) );
        hb_vmSend( 3 );
     }
  }

}

void OnCell_toggled( GtkCellRendererToggle *cell_renderer, gchar *path, gpointer data )
{
  PHB_ITEM pObj  = g_object_get_data( G_OBJECT( cell_renderer ), "Self" );
  PHB_ITEM pBlock;
  PHB_DYNS pMethod;

  if( pObj ) {
     pMethod = hb_dynsymFindName( data );
     if( pMethod ){
        hb_vmPushSymbol( hb_dynsymSymbol( pMethod ) );     // Coloca simbolo en la pila
        hb_vmPush( pObj );                            // Coloca objeto en pila.
        hb_vmPush( pObj );                            // oSender
        hb_vmPushString( path, strlen( path) );
        hb_vmSend( 2 );                               // LLamada por Send que pasa
     } else {
       g_print( "Method doesn't %s exist en OnCell_toggled", (gchar *)data );
     }
  }

  // Obtenemos el codeblock de la seÒal, data, que debemos evaluar...
  if( pObj == NULL ){
     pBlock = g_object_get_data( G_OBJECT( cell_renderer ), (gchar*) data );
     if( pBlock ) {
        hb_vmPushSymbol( &hb_symEval );
        hb_vmPush( pBlock );
        hb_vmPushLong( GPOINTER_TO_UINT( cell_renderer ) );
        hb_vmPushString( path, strlen( path) );
        hb_vmSend( 2 );
     }
  }

}

void OnInsert_at_cursor( GtkEntry *entry, gchar *arg1, gpointer data )
{
  PHB_ITEM pObj  = g_object_get_data( G_OBJECT( entry ), "Self" );
  PHB_ITEM pBlock;
  PHB_DYNS pMethod;

  if( pObj ) {
     pMethod = hb_dynsymFindName( data );
     if( pMethod ){
        hb_vmPushSymbol( hb_dynsymSymbol( pMethod ) );     // Coloca simbolo en la pila
        hb_vmPush( pObj );                            // Coloca objeto en pila.
        hb_vmPush( pObj );                            // oSender
        hb_vmPushString( arg1, strlen( arg1 ) );
        hb_vmSend( 2 );                               // LLamada por Send que pasa
     } else {
       g_print( "Method doesn't %s exist en OnInsert_At_Cursor", (gchar *)data );
     }
  }

  // Obtenemos el codeblock de la seÒal, data, que debemos evaluar...
  if( pObj == NULL ){
     pBlock = g_object_get_data( G_OBJECT( entry ), (gchar*) data );
     if( pBlock ) {
        hb_vmPushSymbol( &hb_symEval );
        hb_vmPush( pBlock );
        hb_vmPushLong( GPOINTER_TO_UINT( entry ) );
        hb_vmPushString( arg1, strlen( arg1 ) );
        hb_vmSend( 2 );
     }
  }
}

void OnItem_Activated( GtkIconView *iconview, GtkTreePath *arg1, gpointer data )
{
  PHB_ITEM pObj  = g_object_get_data( G_OBJECT( iconview ), "Self" );
  PHB_ITEM pBlock;
  PHB_DYNS pMethod;

  if( pObj ) {
     pMethod = hb_dynsymFindName( data );
     if( pMethod ){
        hb_vmPushSymbol( hb_dynsymSymbol( pMethod ) );     // Coloca simbolo en la pila
        hb_vmPush( pObj );                            // Coloca objeto en pila.
        hb_vmPush( pObj );                            // oSender
        hb_vmPushLong( GPOINTER_TO_UINT( arg1 ) );
        hb_vmSend( 2 );                               // LLamada por Send que pasa
     } else {
       g_print( "Method doesn't %s exist en OnItem_Activated", (gchar *)data );
     }
  }

  // Obtenemos el codeblock de la seÒal, data, que debemos evaluar...
  if( pObj == NULL ){
     pBlock = g_object_get_data( G_OBJECT( iconview ), (gchar*) data );
     if( pBlock ) {
        hb_vmPushSymbol( &hb_symEval );
        hb_vmPush( pBlock );
        hb_vmPushLong( GPOINTER_TO_UINT( iconview) );
        hb_vmPushLong( GPOINTER_TO_UINT( arg1 ) );
        hb_vmSend( 2 );
     }
  }
}

gboolean OnExpose_Event( GtkWidget *widget, GdkEventExpose *event, gpointer data )
{
  PHB_ITEM pObj  = g_object_get_data( G_OBJECT( widget ), "Self" );
  PHB_ITEM pBlock;
  PHB_DYNS pMethod;

  if( pObj ) {
     pMethod = hb_dynsymFindName( data );
     if( pMethod ){
        hb_vmPushSymbol( hb_dynsymSymbol( pMethod ) );     // Coloca simbolo en la pila
        hb_vmPush( pObj );                            // Coloca objeto en pila.
        hb_vmPush( pObj );                            // oSender
        hb_vmPushLong( GPOINTER_TO_UINT( event ) );
        hb_vmSend( 2 );                               // LLamada por Send que pasa
        return( hb_parl( -1 ) );
     } else {
       g_print( "Method doesn't %s exist en OnExpose_Event", (gchar *)data );
     }
  }

  // Obtenemos el codeblock de la seÒal, data, que debemos evaluar...
  if( pObj == NULL ){
     pBlock = g_object_get_data( G_OBJECT( widget ), (gchar*) data );
     if( pBlock ) {
        hb_vmPushSymbol( &hb_symEval );
        hb_vmPush( pBlock );
        hb_vmPushLong( GPOINTER_TO_UINT( widget) );
        hb_vmPushLong( GPOINTER_TO_UINT( event ) );
        hb_vmSend( 2 );
        return( hb_parl( -1 ) );
     }
  }
return FALSE;
}

gboolean OnConfigure_Event( GtkWidget  *widget, GdkEventConfigure *event, gpointer data )
{
  PHB_ITEM pObj  = g_object_get_data( G_OBJECT( widget ), "Self" );
  PHB_ITEM pBlock;
  PHB_DYNS pMethod;

  if( pObj ) {
     pMethod = hb_dynsymFindName( data );
     if( pMethod ){
        hb_vmPushSymbol( hb_dynsymSymbol( pMethod ) );     // Coloca simbolo en la pila
        hb_vmPush( pObj );                            // Coloca objeto en pila.
        hb_vmPush( pObj );                            // oSender
        hb_vmPushLong( GPOINTER_TO_UINT( event ) );
        hb_vmSend( 2 );                               // LLamada por Send que pasa
        return( hb_parl( -1 ) );
     } else {
       g_print( "Method doesn't %s exist en OnConfigure_Event", (gchar *)data );
     }
  }

  // Obtenemos el codeblock de la seÒal, data, que debemos evaluar...
  if( pObj == NULL ){
     pBlock = g_object_get_data( G_OBJECT( widget ), (gchar*) data );
     if( pBlock ) {
        hb_vmPushSymbol( &hb_symEval );
        hb_vmPush( pBlock );
        hb_vmPushLong( GPOINTER_TO_UINT( widget) );
        hb_vmPushLong( GPOINTER_TO_UINT( event ) );
        hb_vmSend( 2 );
        return( hb_parl( -1 ) );
     }
  }

return FALSE;
}

void OnCursor_Changed( GtkTreeView *treeview, gpointer data  )
{
  PHB_ITEM pObj  = g_object_get_data( G_OBJECT( treeview ), "Self" );
  PHB_ITEM pBlock;
  PHB_DYNS pMethod;

  if( pObj ) {
     pMethod = hb_dynsymFindName( data );
     if( pMethod ){
        hb_vmPushSymbol( hb_dynsymSymbol( pMethod ) );     // Coloca simbolo en la pila
        hb_vmPush( pObj );                            // Coloca objeto en pila.
        hb_vmPush( pObj );                            // oSender
        hb_vmSend( 1 );                               // LLamada por Send que pasa
     } else {
       g_print( "Method doesn't %s exist en OnCursor_Changed", (gchar *)data );
     }
  }

  // Obtenemos el codeblock de la seÒal, data, que debemos evaluar...
  if( pObj == NULL ){
     pBlock = g_object_get_data( G_OBJECT( treeview ), (gchar*) data );
     if( pBlock ) {
        hb_vmPushSymbol( &hb_symEval );
        hb_vmPush( pBlock );
        hb_vmPushLong( GPOINTER_TO_UINT( treeview ) );
        hb_vmSend( 1 );
     }
  }
}

/* Provaca caida de gWindow , diciendo
 * Error description:Error BASE/1004  Class: 'NIL' has no exported method: ONCOLUMNS_CHANGED
void OnColumns_changed( GtkTreeView *treeview, gpointer data  )
{
  PHB_ITEM pObj  = g_object_get_data( G_OBJECT( treeview ), "Self" );
  PHB_DYNS pMethod = hb_dynsymFindName( data );

  if( pObj && pMethod )
    {
     hb_vmPushSymbol( pMethod->pSymbol );     // Coloca simbolo en la pila
     hb_vmPush( pObj );                       // Coloca objeto en pila.
     hb_vmPush( pObj );                       // oSender
     hb_vmSend( 1 );                          // LLamada por Send que pasa
    }
  else
    {
     g_print( "Method doesn't %s exist en OnColumns_changed", (gchar *)data );
    }
}
*/

void OnEdited( GtkCellRendererText * cellrenderertext, gchar *arg1, gchar *arg2, gpointer data )
{
  PHB_ITEM pObj  = g_object_get_data( G_OBJECT( cellrenderertext ), "Self" );
  PHB_ITEM pBlock;
  PHB_DYNS pMethod;

  if( pObj ) {
     pMethod = hb_dynsymFindName( data );
     if( pMethod ){
        hb_vmPushSymbol( hb_dynsymSymbol( pMethod ) );     // Coloca simbolo en la pila
        hb_vmPush( pObj );                            // Coloca objeto en pila.
        hb_vmPush( pObj );                            // oSender
        hb_vmPushString( arg1, strlen( arg1) );
        hb_vmPushString( arg2, strlen( arg2) );
        hb_vmSend( 3 );                               // LLamada por Send que pasa
     } else {
       g_print( "Method doesn't %s exist en OnEdited", (gchar *)data );
     }
  }

  // Obtenemos el codeblock de la seÒal, data, que debemos evaluar...
  if( pObj == NULL ){
     pBlock = g_object_get_data( G_OBJECT( cellrenderertext ), (gchar*) data );
     if( pBlock ) {
        hb_vmPushSymbol( &hb_symEval );
        hb_vmPush( pBlock );
        hb_vmPushLong( GPOINTER_TO_UINT( cellrenderertext ) );
        hb_vmPushString( arg1, strlen( arg1) );
        hb_vmPushString( arg2, strlen( arg2) );
        hb_vmSend( 3 );
     }
  }

}

gboolean OnEnter_Leave_NotifyEvent( GtkWidget *widget, GdkEventCrossing *event, gpointer data )
{
  PHB_ITEM pObj  = g_object_get_data( G_OBJECT( widget ), "Self" );
  PHB_DYNS pMethod;
  PHB_ITEM pBlock;

  if( pObj  ) {
     pMethod = hb_dynsymFindName( data );
     if( pMethod ){
        hb_vmPushSymbol( hb_dynsymSymbol( pMethod ) );     // Coloca simbolo en la pila
        hb_vmPush( pObj );                       // Coloca objeto en pila.
        hb_vmPush( pObj );                       // Dato a pasar
        hb_vmPushLong( GPOINTER_TO_UINT( event ) );  // Metemos puntero del widget
        hb_vmSend( 2 );                              // LLamada por Send
        return( hb_parl( -1 ) );
     } else {
        g_print( "Method doesn't exist OnEnterLeaveNotifyEvent" );
     }
  }

  // Obtenemos el codeblock de la seÒal, data, que debemos evaluar...
  if( pObj == NULL ){
     pBlock = g_object_get_data( G_OBJECT( widget ), (gchar*) data );
     if( pBlock ) {
        hb_vmPushSymbol( &hb_symEval );
        hb_vmPush( pBlock );
        hb_vmPushLong( GPOINTER_TO_UINT( widget ) );
        hb_vmPushLong( GPOINTER_TO_UINT( event ) );
        hb_vmSend( 2 );
        return( hb_parl( -1 ) );
     }
  }

  return( FALSE );

}

gboolean OnButton_Press_Event( GtkWidget *widget, GdkEventButton *event, gpointer data )
{
  PHB_ITEM pObj  = g_object_get_data( G_OBJECT( widget ), "Self" );
  PHB_DYNS pMethod;
  PHB_ITEM pBlock;

  if( pObj  ) {
     pMethod = hb_dynsymFindName( data );
     if( pMethod ){
        hb_vmPushSymbol( hb_dynsymSymbol( pMethod ) );     // Coloca simbolo en la pila
        hb_vmPush( pObj );                       // Coloca objeto en pila.
        hb_vmPush( pObj );                       // Dato a pasar
        hb_vmPushLong( GPOINTER_TO_UINT( event ) );  // Metemos puntero del widget
        hb_vmSend( 2 );                              // LLamada por Send
        return( hb_parl( -1 ) );
     } else {
        g_print( "Method doesn't exist OnButtonPress_ReleaseEvent" );
     }
  }

  // Obtenemos el codeblock de la seÒal, data, que debemos evaluar...
  if( pObj == NULL ){
     pBlock = g_object_get_data( G_OBJECT( widget ), (gchar*) data );
     if( pBlock ) {
        hb_vmPushSymbol( &hb_symEval );
        hb_vmPush( pBlock );
        hb_vmPushLong( GPOINTER_TO_UINT( widget ) );
        hb_vmPushLong( GPOINTER_TO_UINT( event ) );
        hb_vmSend( 2 );
        return( hb_parl( -1 ) );
     }
  }
  return( FALSE );
}

gboolean OnCan_Activate_Accel( GtkWidget *widget, guint signal_id, gpointer data )
{
  PHB_ITEM pObj  = g_object_get_data( G_OBJECT( widget ), "Self" );
  PHB_DYNS pMethod;
  PHB_ITEM pBlock;

 if( pObj  ) {
     pMethod = hb_dynsymFindName( data );
     if( pMethod ){
        hb_vmPushSymbol( hb_dynsymSymbol( pMethod ) );     // Coloca simbolo en la pila
        hb_vmPush( pObj );                                 // Coloca objeto en pila.
        hb_vmPush( pObj );                                 // Dato a pasar
        hb_vmPushInteger( (guint) signal_id );
        hb_vmSend( 2 );
        return( hb_parl( -1 ) );
     } else {
        g_print( "Method doesn't exist OnCanActivateAccel" );
     }
  }

  // Obtenemos el codeblock de la seÒal, data, que debemos evaluar...
  if( pObj == NULL ){
     pBlock = g_object_get_data( G_OBJECT( widget ), (gchar*) data );
     if( pBlock ) {
        hb_vmPushSymbol( &hb_symEval );
        hb_vmPush( pBlock );
        hb_vmPushLong( GPOINTER_TO_UINT( widget ) );
        hb_vmPushInteger( (guint) signal_id );
        hb_vmSend( 2 );
        return( hb_parl( -1 ) );
     }
  }

  return( FALSE );
}

void OnChild_Notify( GtkWidget *widget, GParamSpec *pspec, gpointer data )
{
  PHB_ITEM pObj  = g_object_get_data( G_OBJECT( widget ), "Self" );
  PHB_DYNS pMethod;
  PHB_ITEM pBlock;

  if( pObj  ) {
     pMethod = hb_dynsymFindName( data );
     if( pMethod ){
        hb_vmPushSymbol( hb_dynsymSymbol( pMethod ) );     // Coloca simbolo en la pila
        hb_vmPush( pObj );                       // Coloca objeto en pila.
        hb_vmPush( pObj );                       // Dato a pasar
        hb_vmPushLong( GPOINTER_TO_UINT( pspec ) );  // Metemos puntero
        hb_vmSend( 2 );                              // LLamada por Send
     } else {
        g_print( "Method doesn't exist OnChildNotify" );
     }
  }

  // Obtenemos el codeblock de la seÒal, data, que debemos evaluar...
  if( pObj == NULL ){
     pBlock = g_object_get_data( G_OBJECT( widget ), (gchar*) data );
     if( pBlock ) {
        hb_vmPushSymbol( &hb_symEval );
        hb_vmPush( pBlock );
        hb_vmPushLong( GPOINTER_TO_UINT( widget ) );
        hb_vmPushLong( GPOINTER_TO_UINT( pspec ) );
        hb_vmSend( 2 );
     }
  }
}

gboolean OnClient_Event( GtkWidget *widget, GdkEventClient *event, gpointer data )
{
  PHB_ITEM pObj  = g_object_get_data( G_OBJECT( widget ), "Self" );
  PHB_DYNS pMethod;
  PHB_ITEM pBlock;

  if( pObj  ) {
     pMethod = hb_dynsymFindName( data );
     if( pMethod ){
        hb_vmPushSymbol( hb_dynsymSymbol( pMethod ) );     // Coloca simbolo en la pila
        hb_vmPush( pObj );                           // Coloca objeto en pila.
        hb_vmPush( pObj );                           // Dato a pasar
        hb_vmPushLong( GPOINTER_TO_UINT( event ) );  // Metemos puntero del widget
        hb_vmSend( 2 );                              // LLamada por Send
        return( hb_parl( -1 ) );
     } else {
        g_print( "Method doesn't exist OnClientEvent" );
     }
  }

  // Obtenemos el codeblock de la seÒal, data, que debemos evaluar...
  if( pObj == NULL ){
     pBlock = g_object_get_data( G_OBJECT( widget ), (gchar*) data );
     if( pBlock ) {
        hb_vmPushSymbol( &hb_symEval );
        hb_vmPush( pBlock );
        hb_vmPushLong( GPOINTER_TO_UINT( widget ) );
        hb_vmPushLong( GPOINTER_TO_UINT( event ) );
        hb_vmSend( 2 );
        return( hb_parl( -1 ) );
     }
  }
  return( FALSE );
}

void OnDirection_Changed( GtkWidget *widget, GtkTextDirection arg1, gpointer data )
{
  PHB_ITEM pObj  = g_object_get_data( G_OBJECT( widget ), "Self" );
  PHB_DYNS pMethod;
  PHB_ITEM pBlock;

  if( pObj  ) {
     pMethod = hb_dynsymFindName( data );
     if( pMethod ){
        hb_vmPushSymbol( hb_dynsymSymbol( pMethod ) );
        hb_vmPush( pObj );
        hb_vmPush( pObj );
        hb_vmPushInteger( (gint) arg1 );
        hb_vmSend( 2 );
     } else {
        g_print( "Method doesn't exist OnDirectionChanged" );
     }
  }

  // Obtenemos el codeblock de la seÒal, data, que debemos evaluar...
  if( pObj == NULL ){
     pBlock = g_object_get_data( G_OBJECT( widget ), (gchar*) data );
     if( pBlock ) {
        hb_vmPushSymbol( &hb_symEval );
        hb_vmPush( pBlock );
        hb_vmPushLong( GPOINTER_TO_UINT( widget ) );
        hb_vmPushInteger( (gint) arg1 );
        hb_vmSend( 2 );
     }
  }
}

gboolean OnFocus( GtkWidget *widget, GtkDirectionType arg1, gpointer data )
{
  PHB_ITEM pObj  = g_object_get_data( G_OBJECT( widget ), "Self" );
  PHB_DYNS pMethod;
  PHB_ITEM pBlock;

  if( pObj  ) {
     pMethod = hb_dynsymFindName( data );
     if( pMethod ){
        hb_vmPushSymbol( hb_dynsymSymbol( pMethod ) );
        hb_vmPush( pObj );
        hb_vmPush( pObj );
        hb_vmPushInteger( (gint) arg1 );
        hb_vmSend( 2 );
        return( hb_parl( -1 ) );
     } else {
        g_print( "Method doesn't exist OnFocus" );
     }
  }

  // Obtenemos el codeblock de la seÒal, data, que debemos evaluar...
  if( pObj == NULL ){
     pBlock = g_object_get_data( G_OBJECT( widget ), (gchar*) data );
     if( pBlock ) {
        hb_vmPushSymbol( &hb_symEval );
        hb_vmPush( pBlock );
        hb_vmPushLong( GPOINTER_TO_UINT( widget ) );
        hb_vmPushInteger( (gint) arg1 );
        hb_vmSend( 2 );
        return( hb_parl( -1 ) );
     }
  }
  return( FALSE );
}

// SeÒales para GtkContainer
void OnSignals_Container( GtkContainer *container, GtkWidget  *widget, gpointer data )
{
  PHB_ITEM pObj  = g_object_get_data( G_OBJECT( container ), "Self" );
  PHB_DYNS pMethod;
  PHB_ITEM pBlock;

  if( pObj  ) {
     pMethod = hb_dynsymFindName( data );
     if( pMethod ){
        hb_vmPushSymbol( hb_dynsymSymbol( pMethod ) );     // Coloca simbolo en la pila
        hb_vmPush( pObj );                       // Coloca objeto en pila.
        hb_vmPush( pObj );                       // Dato a pasar
        hb_vmPushLong( GPOINTER_TO_UINT( widget ) );  // Metemos puntero
        hb_vmSend( 2 );                              // LLamada por Send
     } else {
        g_print( "Method doesn't exist OnSignalContainer" );
     }
  }

  // Obtenemos el codeblock de la seÒal, data, que debemos evaluar...
  if( pObj == NULL ){
     pBlock = g_object_get_data( G_OBJECT( container ), (gchar*) data );
     if( pBlock ) {
        hb_vmPushSymbol( &hb_symEval );
        hb_vmPush( pBlock );
        hb_vmPushLong( GPOINTER_TO_UINT( container ) );
        hb_vmPushLong( GPOINTER_TO_UINT( widget ) );
        hb_vmSend( 2 );
     }
  }
}
// SeÒales para GtkContainer
void OnCheck_Resize( GtkContainer *container, gpointer data )
{
  PHB_ITEM pObj  = g_object_get_data( G_OBJECT( container ), "Self" );
  PHB_DYNS pMethod;
  PHB_ITEM pBlock;

  if( pObj  ) {
     pMethod = hb_dynsymFindName( data );
     if( pMethod ){
        hb_vmPushSymbol( hb_dynsymSymbol( pMethod ) );     // Coloca simbolo en la pila
        hb_vmPush( pObj );                       // Coloca objeto en pila.
        hb_vmPush( pObj );                       // Dato a pasar
        hb_vmSend( 1 );                              // LLamada por Send
     } else {
        g_print( "Method doesn't exist OnCheckResize" );
     }
  }

  // Obtenemos el codeblock de la seÒal, data, que debemos evaluar...
  if( pObj == NULL ){
     pBlock = g_object_get_data( G_OBJECT( container ), (gchar*) data );
     if( pBlock ) {
        hb_vmPushSymbol( &hb_symEval );
        hb_vmPush( pBlock );
        hb_vmPushLong( GPOINTER_TO_UINT( container ) );
        hb_vmSend( 1 );
     }
  }
}

gboolean OnGrab_Broken_Event( GtkWidget *widget, GdkEventGrabBroken *event, gpointer data )
{
 PHB_ITEM pObj   = g_object_get_data( G_OBJECT( widget ), "Self" );
 PHB_ITEM pBlock;
 PHB_DYNS pMethod;

 if( pObj  ) {
     pMethod = hb_dynsymFindName( data );
     if( pMethod ){
        hb_vmPushSymbol( hb_dynsymSymbol( pMethod ) );     // Coloca simbolo en la pila
        hb_vmPush( pObj );                       // Coloca objeto en pila.
        hb_vmPush( pObj );                       // Dato a pasar
        hb_vmPushLong( GPOINTER_TO_UINT( event ) );  // // Pointer de struct event
        hb_vmSend( 2 );                              // LLamada por Send
        return( hb_parl( -1 ) );
     } else {
        g_print( "Method doesn't exist OnGrab_Broken_Event" );
     }
  }

  // Obtenemos el codeblock de la seÒal, data, que debemos evaluar...
  if( pObj == NULL ){
     pBlock = g_object_get_data( G_OBJECT( widget ), (gchar*) data );
     if( pBlock ) {
        hb_vmPushSymbol( &hb_symEval );
        hb_vmPush( pBlock );
        hb_vmPushLong( GPOINTER_TO_UINT( widget ) );
        hb_vmPushLong( GPOINTER_TO_UINT( event ) );
        hb_vmSend( 2 );
        return( hb_parl( -1 ) );
     }
  }

return( FALSE );  // Salimos
}

void OnGrab_Notify( GtkWidget *widget, gboolean arg1, gpointer data )
{
 PHB_ITEM pObj   = g_object_get_data( G_OBJECT( widget ), "Self" );
 PHB_ITEM pBlock;
 PHB_DYNS pMethod;

 if( pObj  ) {
     pMethod = hb_dynsymFindName( data );
     if( pMethod ){
        hb_vmPushSymbol( hb_dynsymSymbol( pMethod ) );     // Coloca simbolo en la pila
        hb_vmPush( pObj );                       // Coloca objeto en pila.
        hb_vmPush( pObj );                       // Dato a pasar
        hb_vmPushLogical( arg1 );
        hb_vmSend( 2 );                              // LLamada por Send
     } else {
        g_print( "Method doesn't exist OnGrab_Notify" );
     }
  }

  // Obtenemos el codeblock de la seÒal, data, que debemos evaluar...
  if( pObj == NULL ){
     pBlock = g_object_get_data( G_OBJECT( widget ), (gchar*) data );
     if( pBlock ) {
        hb_vmPushSymbol( &hb_symEval );
        hb_vmPush( pBlock );
        hb_vmPushLong( GPOINTER_TO_UINT( widget ) );
        hb_vmPushLogical( arg1 );
        hb_vmSend( 2 );
     }
  }
}

void OnHierarchy_Changed( GtkWidget *widget, GtkWidget *widget2, gpointer data )
{
 PHB_ITEM pObj   = g_object_get_data( G_OBJECT( widget ), "Self" );
 PHB_ITEM pBlock;
 PHB_DYNS pMethod;

 if( pObj  ) {
     pMethod = hb_dynsymFindName( data );
     if( pMethod ){
        hb_vmPushSymbol( hb_dynsymSymbol( pMethod ) );     // Coloca simbolo en la pila
        hb_vmPush( pObj );                       // Coloca objeto en pila.
        hb_vmPush( pObj );                       // Dato a pasar
        hb_vmPushLong( GPOINTER_TO_UINT( widget2 ) );  // Metemos puntero
        hb_vmSend( 2 );                              // LLamada por Send
     } else {
        g_print( "Method doesn't exist OnHierarchy_Changed" );
     }
  }

  // Obtenemos el codeblock de la seÒal, data, que debemos evaluar...
  if( pObj == NULL ){
     pBlock = g_object_get_data( G_OBJECT( widget ), (gchar*) data );
     if( pBlock ) {
        hb_vmPushSymbol( &hb_symEval );
        hb_vmPush( pBlock );
        hb_vmPushLong( GPOINTER_TO_UINT( widget ) );
        hb_vmPushLong( GPOINTER_TO_UINT( widget2 ) );
        hb_vmSend( 2 );
     }
  }
}

gboolean OnMnemonic_Activate( GtkWidget *widget, gboolean arg1, gpointer data )
{
 PHB_ITEM pObj   = g_object_get_data( G_OBJECT( widget ), "Self" );
 PHB_ITEM pBlock;
 PHB_DYNS pMethod;

 if( pObj  ) {
     pMethod = hb_dynsymFindName( data );
     if( pMethod ){
        hb_vmPushSymbol( hb_dynsymSymbol( pMethod ) );     // Coloca simbolo en la pila
        hb_vmPush( pObj );                       // Coloca objeto en pila.
        hb_vmPush( pObj );                       // Dato a pasar
        hb_vmPushLogical( arg1 );
        hb_vmSend( 2 );                              // LLamada por Send
        return( hb_parl( -1 ) );
     } else {
        g_print( "Method doesn't exist OnMnemonic_Activate" );
     }
  }

  // Obtenemos el codeblock de la seÒal, data, que debemos evaluar...
  if( pObj == NULL ){
     pBlock = g_object_get_data( G_OBJECT( widget ), (gchar*) data );
     if( pBlock ) {
        hb_vmPushSymbol( &hb_symEval );
        hb_vmPush( pBlock );
        hb_vmPushLong( GPOINTER_TO_UINT( widget ) );
        hb_vmPushLogical( arg1 );
        hb_vmSend( 2 );
        return( hb_parl( -1 ) );
     }
  }
  return( FALSE );  // Salimos
}

gboolean OnMotion_Notify_Event( GtkWidget *widget, GdkEventMotion *event, gpointer data )
{
 PHB_ITEM pObj   = g_object_get_data( G_OBJECT( widget ), "Self" );
 PHB_ITEM pBlock;
 PHB_DYNS pMethod;

 if( pObj  ) {
     pMethod = hb_dynsymFindName( data );
     if( pMethod ){
        hb_vmPushSymbol( hb_dynsymSymbol( pMethod ) );     // Coloca simbolo en la pila
        hb_vmPush( pObj );                       // Coloca objeto en pila.
        hb_vmPush( pObj );                       // Dato a pasar
        hb_vmPushLong( GPOINTER_TO_UINT( event ) );
        hb_vmSend( 2 );                              // LLamada por Send
        return( hb_parl( -1 ) );
     } else {
        g_print( "Method doesn't exist OnMotion_Notify_Event" );
     }
  }

  // Obtenemos el codeblock de la seÒal, data, que debemos evaluar...
  if( pObj == NULL ){
     pBlock = g_object_get_data( G_OBJECT( widget ), (gchar*) data );
     if( pBlock ) {
        hb_vmPushSymbol( &hb_symEval );
        hb_vmPush( pBlock );
        hb_vmPushLong( GPOINTER_TO_UINT( widget ) );
        hb_vmPushLong( GPOINTER_TO_UINT( event ) );
        hb_vmSend( 2 );
        return( hb_parl( -1 ) );
     }
  }
  return( FALSE );  // Salimos
}

gboolean OnNo_Expose_Event( GtkWidget *widget, GdkEventNoExpose *event, gpointer data )
{
 PHB_ITEM pObj   = g_object_get_data( G_OBJECT( widget ), "Self" );
 PHB_ITEM pBlock;
 PHB_DYNS pMethod;

 if( pObj  ) {
     pMethod = hb_dynsymFindName( data );
     if( pMethod ){
        hb_vmPushSymbol( hb_dynsymSymbol( pMethod ) );     // Coloca simbolo en la pila
        hb_vmPush( pObj );                       // Coloca objeto en pila.
        hb_vmPush( pObj );                       // Dato a pasar
        hb_vmPushLong( GPOINTER_TO_UINT( event ) );
        hb_vmSend( 2 );                              // LLamada por Send
        return( hb_parl( -1 ) );
     } else {
        g_print( "Method doesn't exist OnNo_Expose_Event" );
     }
  }

  // Obtenemos el codeblock de la seÒal, data, que debemos evaluar...
  if( pObj == NULL ){
     pBlock = g_object_get_data( G_OBJECT( widget ), (gchar*) data );
     if( pBlock ) {
        hb_vmPushSymbol( &hb_symEval );
        hb_vmPush( pBlock );
        hb_vmPushLong( GPOINTER_TO_UINT( widget ) );
        hb_vmPushLong( GPOINTER_TO_UINT( event ) );
        hb_vmSend( 2 );
        return( hb_parl( -1 ) );
     }
  }
  return( FALSE );  // Salimos
}

void OnParent_Set( GtkWidget *widget, GtkObject *old_parent, gpointer data )
{
 PHB_ITEM pObj   = g_object_get_data( G_OBJECT( widget ), "Self" );
 PHB_ITEM pBlock;
 PHB_DYNS pMethod;

 if( pObj  ) {
     pMethod = hb_dynsymFindName( data );
     if( pMethod ){
        hb_vmPushSymbol( hb_dynsymSymbol( pMethod ) );     // Coloca simbolo en la pila
        hb_vmPush( pObj );                       // Coloca objeto en pila.
        hb_vmPush( pObj );                       // Dato a pasar
        hb_vmPushLong( GPOINTER_TO_UINT( old_parent ) );  // Metemos puntero
        hb_vmSend( 2 );                              // LLamada por Send
     } else {
        g_print( "Method doesn't exist OnParent_Set" );
     }
  }

  // Obtenemos el codeblock de la seÒal, data, que debemos evaluar...
  if( pObj == NULL ){
     pBlock = g_object_get_data( G_OBJECT( widget ), (gchar*) data );
     if( pBlock ) {
        hb_vmPushSymbol( &hb_symEval );
        hb_vmPush( pBlock );
        hb_vmPushLong( GPOINTER_TO_UINT( widget ) );
        hb_vmPushLong( GPOINTER_TO_UINT( old_parent ) );
        hb_vmSend( 2 );
     }
  }
}

gboolean OnProperty_Notify_Event( GtkWidget *widget, GdkEventProperty *event, gpointer data )
{
 PHB_ITEM pObj   = g_object_get_data( G_OBJECT( widget ), "Self" );
 PHB_ITEM pBlock;
 PHB_DYNS pMethod;

 if( pObj  ) {
     pMethod = hb_dynsymFindName( data );
     if( pMethod ){
        hb_vmPushSymbol( hb_dynsymSymbol( pMethod ) );     // Coloca simbolo en la pila
        hb_vmPush( pObj );                       // Coloca objeto en pila.
        hb_vmPush( pObj );                       // Dato a pasar
        hb_vmPushLong( GPOINTER_TO_UINT( event ) );
        hb_vmSend( 2 );                              // LLamada por Send
        return( hb_parl( -1 ) );
     } else {
        g_print( "Method doesn't exist OnProperty_Notify_Event" );
     }
  }

  // Obtenemos el codeblock de la seÒal, data, que debemos evaluar...
  if( pObj == NULL ){
     pBlock = g_object_get_data( G_OBJECT( widget ), (gchar*) data );
     if( pBlock ) {
        hb_vmPushSymbol( &hb_symEval );
        hb_vmPush( pBlock );
        hb_vmPushLong( GPOINTER_TO_UINT( widget ) );
        hb_vmPushLong( GPOINTER_TO_UINT( event ) );
        hb_vmSend( 2 );
        return( hb_parl( -1 ) );
     }
  }
  return( FALSE );  // Salimos
}

gboolean OnProximity_Event( GtkWidget *widget, GdkEventProximity *event, gpointer data )
{
 PHB_ITEM pObj   = g_object_get_data( G_OBJECT( widget ), "Self" );
 PHB_ITEM pBlock;
 PHB_DYNS pMethod;

 if( pObj  ) {
     pMethod = hb_dynsymFindName( data );
     if( pMethod ){
        hb_vmPushSymbol( hb_dynsymSymbol( pMethod ) );     // Coloca simbolo en la pila
        hb_vmPush( pObj );                       // Coloca objeto en pila.
        hb_vmPush( pObj );                       // Dato a pasar
        hb_vmPushLong( GPOINTER_TO_UINT( event ) );
        hb_vmSend( 2 );                              // LLamada por Send
        return( hb_parl( -1 ) );
     } else {
        g_print( "Method doesn't exist OnProximity_Event" );
     }
  }

  // Obtenemos el codeblock de la seÒal, data, que debemos evaluar...
  if( pObj == NULL ){
     pBlock = g_object_get_data( G_OBJECT( widget ), (gchar*) data );
     if( pBlock ) {
        hb_vmPushSymbol( &hb_symEval );
        hb_vmPush( pBlock );
        hb_vmPushLong( GPOINTER_TO_UINT( widget ) );
        hb_vmPushLong( GPOINTER_TO_UINT( event ) );
        hb_vmSend( 2 );
        return( hb_parl( -1 ) );
     }
  }
  return( FALSE );  // Salimos
}

void OnScreen_Changed( GtkWidget *widget, GdkScreen *arg1, gpointer data )
{
 PHB_ITEM pObj   = g_object_get_data( G_OBJECT( widget ), "Self" );
 PHB_ITEM pBlock;
 PHB_DYNS pMethod;

 if( pObj  ) {
     pMethod = hb_dynsymFindName( data );
     if( pMethod ){
        hb_vmPushSymbol( hb_dynsymSymbol( pMethod ) );     // Coloca simbolo en la pila
        hb_vmPush( pObj );                       // Coloca objeto en pila.
        hb_vmPush( pObj );                       // Dato a pasar
        hb_vmPushLong( GPOINTER_TO_UINT( arg1 ) );  // Metemos puntero
        hb_vmSend( 2 );                              // LLamada por Send
     } else {
        g_print( "Method doesn't exist OnScreen_Changed" );
     }
  }

  // Obtenemos el codeblock de la seÒal, data, que debemos evaluar...
  if( pObj == NULL ){
     pBlock = g_object_get_data( G_OBJECT( widget ), (gchar*) data );
     if( pBlock ) {
        hb_vmPushSymbol( &hb_symEval );
        hb_vmPush( pBlock );
        hb_vmPushLong( GPOINTER_TO_UINT( widget ) );
        hb_vmPushLong( GPOINTER_TO_UINT( arg1 ) );
        hb_vmSend( 2 );
     }
  }
}

gboolean OnScroll_Event( GtkWidget *widget, GdkEventScroll *event, gpointer data )
{
 PHB_ITEM pObj   = g_object_get_data( G_OBJECT( widget ), "Self" );
 PHB_ITEM pBlock;
 PHB_DYNS pMethod;

 if( pObj  ) {
     pMethod = hb_dynsymFindName( data );
     if( pMethod ){
        hb_vmPushSymbol( hb_dynsymSymbol( pMethod ) );     // Coloca simbolo en la pila
        hb_vmPush( pObj );                       // Coloca objeto en pila.
        hb_vmPush( pObj );                       // Dato a pasar
        hb_vmPushLong( GPOINTER_TO_UINT( event ) );
        hb_vmSend( 2 );                              // LLamada por Send
        return( hb_parl( -1 ) );
     } else {
        g_print( "Method doesn't exist OnScroll_Event" );
     }
  }

  // Obtenemos el codeblock de la seÒal, data, que debemos evaluar...
  if( pObj == NULL ){
     pBlock = g_object_get_data( G_OBJECT( widget ), (gchar*) data );
     if( pBlock ) {
        hb_vmPushSymbol( &hb_symEval );
        hb_vmPush( pBlock );
        hb_vmPushLong( GPOINTER_TO_UINT( widget ) );
        hb_vmPushLong( GPOINTER_TO_UINT( event ) );
        hb_vmSend( 2 );
        return( hb_parl( -1 ) );
     }
  }
  return( FALSE );  // Salimos
}

gboolean OnSelection_Event( GtkWidget *widget, GdkEventSelection *event, gpointer data )
{
 PHB_ITEM pObj   = g_object_get_data( G_OBJECT( widget ), "Self" );
 PHB_ITEM pBlock;
 PHB_DYNS pMethod;

 if( pObj  ) {
     pMethod = hb_dynsymFindName( data );
     if( pMethod ){
        hb_vmPushSymbol( hb_dynsymSymbol( pMethod ) );     // Coloca simbolo en la pila
        hb_vmPush( pObj );                       // Coloca objeto en pila.
        hb_vmPush( pObj );                       // Dato a pasar
        hb_vmPushLong( GPOINTER_TO_UINT( event ) );
        hb_vmSend( 2 );                              // LLamada por Send
        return( hb_parl( -1 ) );
     } else {
        g_print( "Method doesn't exist OnSelection_Event" );
     }
  }

  // Obtenemos el codeblock de la seÒal, data, que debemos evaluar...
  if( pObj == NULL ){
     pBlock = g_object_get_data( G_OBJECT( widget ), (gchar*) data );
     if( pBlock ) {
        hb_vmPushSymbol( &hb_symEval );
        hb_vmPush( pBlock );
        hb_vmPushLong( GPOINTER_TO_UINT( widget ) );
        hb_vmPushLong( GPOINTER_TO_UINT( event ) );
        hb_vmSend( 2 );
        return( hb_parl( -1 ) );
     }
  }
  return( FALSE );  // Salimos
}

gboolean OnSelection_Get( GtkWidget *widget, GtkSelectionData * selection_data, guint info, guint time, gpointer data )
{
 PHB_ITEM pObj   = g_object_get_data( G_OBJECT( widget ), "Self" );
 PHB_ITEM pBlock;
 PHB_DYNS pMethod;

 if( pObj  ) {
     pMethod = hb_dynsymFindName( data );
     if( pMethod ){
        hb_vmPushSymbol( hb_dynsymSymbol( pMethod ) );     // Coloca simbolo en la pila
        hb_vmPush( pObj );                       // Coloca objeto en pila.
        hb_vmPush( pObj );                       // Dato a pasar
        hb_vmPushLong( GPOINTER_TO_UINT( selection_data ) );
        hb_vmPushInteger( (gint) info );
        hb_vmPushInteger( (gint) time );
        hb_vmSend( 4 );                              // LLamada por Send
        return( hb_parl( -1 ) );
     } else {
        g_print( "Method doesn't exist OnSelection_Event" );
     }
  }

  // Obtenemos el codeblock de la seÒal, data, que debemos evaluar...
  if( pObj == NULL ){
     pBlock = g_object_get_data( G_OBJECT( widget ), (gchar*) data );
     if( pBlock ) {
        hb_vmPushSymbol( &hb_symEval );
        hb_vmPush( pBlock );
        hb_vmPushLong( GPOINTER_TO_UINT( widget ) );
        hb_vmPushLong( GPOINTER_TO_UINT( selection_data ) );
        hb_vmPushInteger( (gint) info );
        hb_vmPushInteger( (gint) time );
        hb_vmSend( 4 );
        return( hb_parl( -1 ) );
     }
  }
  return( FALSE );  // Salimos
}

gboolean OnSelection_Received( GtkWidget *widget, GtkSelectionData * selection_data, guint time, gpointer data )
{
 PHB_ITEM pObj   = g_object_get_data( G_OBJECT( widget ), "Self" );
 PHB_ITEM pBlock;
 PHB_DYNS pMethod;

 if( pObj  ) {
     pMethod = hb_dynsymFindName( data );
     if( pMethod ){
        hb_vmPushSymbol( hb_dynsymSymbol( pMethod ) );     // Coloca simbolo en la pila
        hb_vmPush( pObj );                       // Coloca objeto en pila.
        hb_vmPush( pObj );                       // Dato a pasar
        hb_vmPushLong( GPOINTER_TO_UINT( selection_data ) );
        hb_vmPushInteger( (gint) time );
        hb_vmSend( 3 );                              // LLamada por Send
        return( hb_parl( -1 ) );
     } else {
        g_print( "Method doesn't exist OnSelection_Received" );
     }
  }

  // Obtenemos el codeblock de la seÒal, data, que debemos evaluar...
  if( pObj == NULL ){
     pBlock = g_object_get_data( G_OBJECT( widget ), (gchar*) data );
     if( pBlock ) {
        hb_vmPushSymbol( &hb_symEval );
        hb_vmPush( pBlock );
        hb_vmPushLong( GPOINTER_TO_UINT( widget ) );
        hb_vmPushLong( GPOINTER_TO_UINT( selection_data ) );
        hb_vmPushInteger( (gint) time );
        hb_vmSend( 3 );
        return( hb_parl( -1 ) );
     }
  }
  return( FALSE );  // Salimos
}

gboolean OnShow_Help( GtkWidget *widget, GtkWidgetHelpType arg1, gpointer data )
{
 PHB_ITEM pObj   = g_object_get_data( G_OBJECT( widget ), "Self" );
 PHB_ITEM pBlock;
 PHB_DYNS pMethod;

 if( pObj  ) {
     pMethod = hb_dynsymFindName( data );
     if( pMethod ){
        hb_vmPushSymbol( hb_dynsymSymbol( pMethod ) );     // Coloca simbolo en la pila
        hb_vmPush( pObj );                       // Coloca objeto en pila.
        hb_vmPush( pObj );                       // Dato a pasar
        hb_vmPushInteger( (gint) arg1 );
        hb_vmSend( 2 );                              // LLamada por Send
        return( hb_parl( -1 ) );
     } else {
        g_print( "Method doesn't exist OnShow_Help" );
     }
  }

  // Obtenemos el codeblock de la seÒal, data, que debemos evaluar...
  if( pObj == NULL ){
     pBlock = g_object_get_data( G_OBJECT( widget ), (gchar*) data );
     if( pBlock ) {
        hb_vmPushSymbol( &hb_symEval );
        hb_vmPush( pBlock );
        hb_vmPushLong( GPOINTER_TO_UINT( widget ) );
        hb_vmPushInteger( (gint) arg1 );
        hb_vmSend( 2 );
        return( hb_parl( -1 ) );
     }
  }
  return( FALSE );  // Salimos
}

void OnSize_Allocate( GtkWidget *widget, GtkAllocation *allocation, gpointer data )
{
 PHB_ITEM pObj   = g_object_get_data( G_OBJECT( widget ), "Self" );
 PHB_ITEM pBlock;
 PHB_DYNS pMethod;

 if( pObj  ) {
     pMethod = hb_dynsymFindName( data );
     if( pMethod ){
        hb_vmPushSymbol( hb_dynsymSymbol( pMethod ) );     // Coloca simbolo en la pila
        hb_vmPush( pObj );                       // Coloca objeto en pila.
        hb_vmPush( pObj );                       // Dato a pasar
        hb_vmPushLong( GPOINTER_TO_UINT( allocation ) );
        hb_vmSend( 2 );                              // LLamada por Send
     } else {
        g_print( "Method doesn't exist OnSize_Request" );
     }
  }

  // Obtenemos el codeblock de la seÒal, data, que debemos evaluar...
  if( pObj == NULL ){
     pBlock = g_object_get_data( G_OBJECT( widget ), (gchar*) data );
     if( pBlock ) {
        hb_vmPushSymbol( &hb_symEval );
        hb_vmPush( pBlock );
        hb_vmPushLong( GPOINTER_TO_UINT( widget ) );
        hb_vmPushLong( GPOINTER_TO_UINT( allocation ) );
        hb_vmSend( 2 );
     }
  }
}

void OnSize_Request( GtkWidget *widget, GtkRequisition *requisition, gpointer data )
{
 PHB_ITEM pObj   = g_object_get_data( G_OBJECT( widget ), "Self" );
 PHB_ITEM pBlock;
 PHB_DYNS pMethod;

 if( pObj  ) {
     pMethod = hb_dynsymFindName( data );
     if( pMethod ){
        hb_vmPushSymbol( hb_dynsymSymbol( pMethod ) );     // Coloca simbolo en la pila
        hb_vmPush( pObj );                       // Coloca objeto en pila.
        hb_vmPush( pObj );                       // Dato a pasar
        hb_vmPushLong( GPOINTER_TO_UINT( requisition ) );
        hb_vmSend( 2 );                              // LLamada por Send
     } else {
        g_print( "Method doesn't exist OnSize_Request" );
     }
  }

  // Obtenemos el codeblock de la seÒal, data, que debemos evaluar...
  if( pObj == NULL ){
     pBlock = g_object_get_data( G_OBJECT( widget ), (gchar*) data );
     if( pBlock ) {
        hb_vmPushSymbol( &hb_symEval );
        hb_vmPush( pBlock );
        hb_vmPushLong( GPOINTER_TO_UINT( widget ) );
        hb_vmPushLong( GPOINTER_TO_UINT( requisition ) );
        hb_vmSend( 2 );
     }
  }
}

void OnState_Changed( GtkWidget *widget, GtkStateType state, gpointer data )
{
 PHB_ITEM pObj   = g_object_get_data( G_OBJECT( widget ), "Self" );
 PHB_ITEM pBlock;
 PHB_DYNS pMethod;

 if( pObj  ) {
     pMethod = hb_dynsymFindName( data );
     if( pMethod ){
        hb_vmPushSymbol( hb_dynsymSymbol( pMethod ) );     // Coloca simbolo en la pila
        hb_vmPush( pObj );                       // Coloca objeto en pila.
        hb_vmPush( pObj );                       // Dato a pasar
        hb_vmPushInteger( (gint) state );
        hb_vmSend( 2 );                              // LLamada por Send
     } else {
        g_print( "Method doesn't exist OnState_Changed" );
     }
  }

  // Obtenemos el codeblock de la seÒal, data, que debemos evaluar...
  if( pObj == NULL ){
     pBlock = g_object_get_data( G_OBJECT( widget ), (gchar*) data );
     if( pBlock ) {
        hb_vmPushSymbol( &hb_symEval );
        hb_vmPush( pBlock );
        hb_vmPushLong( GPOINTER_TO_UINT( widget ) );
        hb_vmPushInteger( (gint) state );
        hb_vmSend( 2 );
     }
  }
}

void OnStyle_Set( GtkWidget *widget, GtkStyle *previous_style, gpointer data )
{
 PHB_ITEM pObj   = g_object_get_data( G_OBJECT( widget ), "Self" );
 PHB_ITEM pBlock;
 PHB_DYNS pMethod;

 if( pObj  ) {
     pMethod = hb_dynsymFindName( data );
     if( pMethod ){
        hb_vmPushSymbol( hb_dynsymSymbol( pMethod ) );     // Coloca simbolo en la pila
        hb_vmPush( pObj );                       // Coloca objeto en pila.
        hb_vmPush( pObj );                       // Dato a pasar
        hb_vmPushLong( GPOINTER_TO_UINT( previous_style ) );
        hb_vmSend( 2 );                              // LLamada por Send
     } else {
        g_print( "Method doesn't exist OnStyle_Set" );
     }
  }

  // Obtenemos el codeblock de la seÒal, data, que debemos evaluar...
  if( pObj == NULL ){
     pBlock = g_object_get_data( G_OBJECT( widget ), (gchar*) data );
     if( pBlock ) {
        hb_vmPushSymbol( &hb_symEval );
        hb_vmPush( pBlock );
        hb_vmPushLong( GPOINTER_TO_UINT( widget ) );
        hb_vmPushLong( GPOINTER_TO_UINT( previous_style ) );
        hb_vmSend( 2 );
     }
  }
}

gboolean OnVisibility_Notify_Event( GtkWidget *widget, GdkEventVisibility *event, gpointer data )
{
 PHB_ITEM pObj   = g_object_get_data( G_OBJECT( widget ), "Self" );
 PHB_ITEM pBlock;
 PHB_DYNS pMethod;

 if( pObj  ) {
     pMethod = hb_dynsymFindName( data );
     if( pMethod ){
        hb_vmPushSymbol( hb_dynsymSymbol( pMethod ) );     // Coloca simbolo en la pila
        hb_vmPush( pObj );                       // Coloca objeto en pila.
        hb_vmPush( pObj );                       // Dato a pasar
        hb_vmPushLong( GPOINTER_TO_UINT( event ) );
        hb_vmSend( 2 );                              // LLamada por Send
        return( hb_parl( -1 ) );
     } else {
        g_print( "Method doesn't exist OnVisibility_Notify_Event" );
     }
  }

  // Obtenemos el codeblock de la seÒal, data, que debemos evaluar...
  if( pObj == NULL ){
     pBlock = g_object_get_data( G_OBJECT( widget ), (gchar*) data );
     if( pBlock ) {
        hb_vmPushSymbol( &hb_symEval );
        hb_vmPush( pBlock );
        hb_vmPushLong( GPOINTER_TO_UINT( widget ) );
        hb_vmPushLong( GPOINTER_TO_UINT( event ) );
        hb_vmSend( 2 );
        return( hb_parl( -1 ) );
     }
  }
  return( FALSE );  // Salimos
}

gboolean OnWindow_State_Event( GtkWidget *widget, GdkEventWindowState *event, gpointer data )
{
 PHB_ITEM pObj   = g_object_get_data( G_OBJECT( widget ), "Self" );
 PHB_ITEM pBlock;
 PHB_DYNS pMethod;

 if( pObj  ) {
     pMethod = hb_dynsymFindName( data );
     if( pMethod ){
        hb_vmPushSymbol( hb_dynsymSymbol( pMethod ) );     // Coloca simbolo en la pila
        hb_vmPush( pObj );                       // Coloca objeto en pila.
        hb_vmPush( pObj );                       // Dato a pasar
        hb_vmPushLong( GPOINTER_TO_UINT( event ) );
        hb_vmSend( 2 );                              // LLamada por Send
        return( hb_parl( -1 ) );
     } else {
        g_print( "Method doesn't exist OnWindow_State_Event" );
     }
  }

  // Obtenemos el codeblock de la seÒal, data, que debemos evaluar...
  if( pObj == NULL ){
     pBlock = g_object_get_data( G_OBJECT( widget ), (gchar*) data );
     if( pBlock ) {
        hb_vmPushSymbol( &hb_symEval );
        hb_vmPush( pBlock );
        hb_vmPushLong( GPOINTER_TO_UINT( widget ) );
        hb_vmPushLong( GPOINTER_TO_UINT( event ) );
        hb_vmSend( 2 );
        return( hb_parl( -1 ) );
     }
  }
  return( FALSE );  // Salimos
}

void OnMove_Focus( GtkWidget *widget, GtkDirectionType arg1, gpointer data )
{
  PHB_ITEM pObj  = g_object_get_data( G_OBJECT( widget ), "Self" );
  PHB_DYNS pMethod;
  PHB_ITEM pBlock;

  if( pObj  ) {
     pMethod = hb_dynsymFindName( data );
     if( pMethod ){
        hb_vmPushSymbol( hb_dynsymSymbol( pMethod ) );
        hb_vmPush( pObj );
        hb_vmPush( pObj );
        hb_vmPushInteger( (gint) arg1 );
        hb_vmSend( 2 );
     } else {
        g_print( "Method doesn't exist OnMove_Focus" );
     }
  }

  // Obtenemos el codeblock de la seÒal, data, que debemos evaluar...
  if( pObj == NULL ){
     pBlock = g_object_get_data( G_OBJECT( widget ), (gchar*) data );
     if( pBlock ) {
        hb_vmPushSymbol( &hb_symEval );
        hb_vmPush( pBlock );
        hb_vmPushLong( GPOINTER_TO_UINT( widget ) );
        hb_vmPushInteger( (gint) arg1 );
        hb_vmSend( 2 );
     }
  }
}

gboolean OnCycle_Child_Focus( GtkWidget *widget, gboolean arg1, gpointer data )
{
 PHB_ITEM pObj   = g_object_get_data( G_OBJECT( widget ), "Self" );
 PHB_ITEM pBlock;
 PHB_DYNS pMethod;

 if( pObj  ) {
     pMethod = hb_dynsymFindName( data );
     if( pMethod ){
        hb_vmPushSymbol( hb_dynsymSymbol( pMethod ) );     // Coloca simbolo en la pila
        hb_vmPush( pObj );                       // Coloca objeto en pila.
        hb_vmPush( pObj );                       // Dato a pasar
        hb_vmPushLogical( arg1 );
        hb_vmSend( 2 );                              // LLamada por Send
        return( hb_parl( -1 ) );
     } else {
        g_print( "Method doesn't exist OnCycle_Child_Focus" );
     }
  }

  // Obtenemos el codeblock de la seÒal, data, que debemos evaluar...
  if( pObj == NULL ){
     pBlock = g_object_get_data( G_OBJECT( widget ), (gchar*) data );
     if( pBlock ) {
        hb_vmPushSymbol( &hb_symEval );
        hb_vmPush( pBlock );
        hb_vmPushLong( GPOINTER_TO_UINT( widget ) );
        hb_vmPushLogical( arg1 );
        hb_vmSend( 2 );
        return( hb_parl( -1 ) );
     }
  }
  return( FALSE );  // Salimos
}

gboolean OnMove_Handle( GtkWidget *widget, GtkScrollType arg1, gpointer data )
{
  PHB_ITEM pObj  = g_object_get_data( G_OBJECT( widget ), "Self" );
  PHB_ITEM pBlock;
  PHB_DYNS pMethod;

  if( pObj ) {
     pMethod = hb_dynsymFindName( data );
     if( pMethod ){
        hb_vmPushSymbol( hb_dynsymSymbol( pMethod ) );     // Coloca simbolo en la pila
        hb_vmPush( pObj );                       // Coloca objeto en pila.
        hb_vmPush( pObj );                       // Dato a pasar
        hb_vmPushInteger( arg1 );                // GtkScrollType
        hb_vmSend( 2 );                          // LLamada por Send
        return( hb_parl( -1 ) );
     } else {
        g_print( "Method doesn't %s exist en OnMove_Handle ", (gchar *)data ) ;
     }
  }
  // Obtenemos el codeblock de la seÒal, data, que debemos evaluar...
  if( pObj == NULL ){
     pBlock = g_object_get_data( G_OBJECT( widget ), (gchar*) data );
     if( pBlock ) {
        hb_vmPushSymbol( &hb_symEval );
        hb_vmPush( pBlock );
        hb_vmPushLong( GPOINTER_TO_UINT( widget ) );  // Metemos puntero del widget
        hb_vmPushInteger( arg1 );                     // GtkScrollType
        hb_vmSend( 2 );                               // LLamada por Send al codeblocks
        return( hb_parl( -1 ) );
     }
  }
  return( FALSE );  // Salimos
}

void OnAdjust_Bounds( GtkWidget *widget, gdouble arg1, gpointer data )
{
  PHB_ITEM pObj  = g_object_get_data( G_OBJECT( widget ), "Self" );
  PHB_ITEM pBlock;
  PHB_DYNS pMethod;

  if( pObj ) {
     pMethod = hb_dynsymFindName( data );
     if( pMethod ){
        hb_vmPushSymbol( hb_dynsymSymbol( pMethod ) );     // Coloca simbolo en la pila
        hb_vmPush( pObj );                       // Coloca objeto en pila.
        hb_vmPush( pObj );                       // Dato a pasar
        hb_vmPushDouble( arg1, 10 );             // Double con 10 decimales
        hb_vmSend( 2 );                          // LLamada por Send
     } else {
        g_print( "Method doesn't %s exist en OnAdjust_Bounds", (gchar *)data ) ;
     }
  }
  // Obtenemos el codeblock de la seÒal, data, que debemos evaluar...
  if( pObj == NULL ){
     pBlock = g_object_get_data( G_OBJECT( widget ), (gchar*) data );
     if( pBlock ) {
        hb_vmPushSymbol( &hb_symEval );
        hb_vmPush( pBlock );
        hb_vmPushLong( GPOINTER_TO_UINT( widget ) );  // Metemos puntero del widget
        hb_vmPushDouble( arg1, 10 );                  // Double con 10 decimales
        hb_vmSend( 2 );                               // LLamada por Send al codeblocks
     }
  }
}
gboolean OnChange_Value( GtkWidget *widget, GtkScrollType arg1, gdouble value, gpointer data )
{
  PHB_ITEM pObj  = g_object_get_data( G_OBJECT( widget ), "Self" );
  PHB_ITEM pBlock;
  PHB_DYNS pMethod;

  if( pObj ) {
     pMethod = hb_dynsymFindName( data );
     if( pMethod ){
        hb_vmPushSymbol( hb_dynsymSymbol( pMethod ) );     // Coloca simbolo en la pila
        hb_vmPush( pObj );                       // Coloca objeto en pila.
        hb_vmPush( pObj );                       // Dato a pasar
        hb_vmPushInteger( arg1 );                // GtkScrollType
        hb_vmPushDouble( value, 10 );            // Double con 10 decimales
        hb_vmSend( 3 );                          // LLamada por Send
        return( hb_parl( -1 ) );
     } else {
        g_print( "Method doesn't %s exist en OnChange_Value", (gchar *)data ) ;
     }
  }
  // Obtenemos el codeblock de la seÒal, data, que debemos evaluar...
  if( pObj == NULL ){
     pBlock = g_object_get_data( G_OBJECT( widget ), (gchar*) data );
     if( pBlock ) {
        hb_vmPushSymbol( &hb_symEval );
        hb_vmPush( pBlock );
        hb_vmPushLong( GPOINTER_TO_UINT( widget ) );  // Metemos puntero del widget
        hb_vmPushInteger( arg1 );                     // GtkScrollType
        hb_vmPushDouble( value, 10 );                 // Double con 10 decimales
        hb_vmSend( 3 );                               // LLamada por Send al codeblocks
        return( hb_parl( -1 ) );
     }
  }
  return( FALSE );  // Salimos
}

void OnScroll_Child( GtkWidget *widget, GtkScrollType arg1, gboolean arg2, gpointer data )
{
  PHB_ITEM pObj  = g_object_get_data( G_OBJECT( widget ), "Self" );
  PHB_ITEM pBlock;
  PHB_DYNS pMethod;

  if( pObj ) {
     pMethod = hb_dynsymFindName( data );
     if( pMethod ){
        hb_vmPushSymbol( hb_dynsymSymbol( pMethod ) );     // Coloca simbolo en la pila
        hb_vmPush( pObj );                       // Coloca objeto en pila.
        hb_vmPush( pObj );                       // Dato a pasar
        hb_vmPushInteger( arg1 );                // GtkScrollType
        hb_vmPushLogical( arg2 );
        hb_vmSend( 3 );                          // LLamada por Send
     } else {
        g_print( "Method doesn't %s exist en OnScroll_Child", (gchar *)data ) ;
     }
  }
  // Obtenemos el codeblock de la seÒal, data, que debemos evaluar...
  if( pObj == NULL ){
     pBlock = g_object_get_data( G_OBJECT( widget ), (gchar*) data );
     if( pBlock ) {
        hb_vmPushSymbol( &hb_symEval );
        hb_vmPush( pBlock );
        hb_vmPushLong( GPOINTER_TO_UINT( widget ) );  // Metemos puntero del widget
        hb_vmPushInteger( arg1 );                     // GtkScrollType
        hb_vmPushLogical( arg2 );
        hb_vmSend( 3 );                               // LLamada por Send al codeblocks
     }
  }

}

// Content arrays the signals and Methods
#include "events.h"

//*****************************************************************************************************************
// Liberacion de la memoria directamente.
//*****************************************************************************************************************
gint liberate_block_memory( gpointer data )
{
  /* Debug */
  //g_print("\nLiberando widget %d classname %s \n", GPOINTER_TO_UINT( data ), hb_objGetClsName( data ) );

 /** Esto libera memoria **/
 // hb_gcGripDrop( data );
  hb_itemRelease( (PHB_ITEM) data );

  return FALSE;
}

/*
 * Gestion de Eventos general de T-Gtk a nivel de Clases.
 */                                                 //,  ->Codeblock
HB_FUNC( HARB_SIGNAL_CONNECT ) // widget, se√±al, Self, method a saltar, Connect_Flags, child
{
    GtkWidget *widget = ( GtkWidget * ) hb_parnl( 1 );
    gchar *cStr =  (gchar *) hb_parc( 2 );
    gint iPos = -1;
    gint x;
    gint iReturn;
    PHB_ITEM pSelf, pBlock;
    gint num_elements = sizeof( array )/ sizeof( TGtkActionParce );
    gint ConnectFlags = ISNIL( 5 ) ? (GConnectFlags) 0 :  (GConnectFlags) hb_parni( 5 );
    gchar *cMethod; // =  (gchar *) hb_parc( 4 );

    // Busca la se√±al que tengo que procesar.
    for ( x = 0;  x < num_elements; x++ ) {
        if( g_strcasecmp( cStr, array[x].name ) == 0 ) {
            iPos = x;
            break;
        }
    }

    /* Si es Self, es el nombre del method, de lo contrario, puede ser un codeblock */
    if( ISOBJECT( 3 ) )
      cMethod =  ISNIL( 4 ) ? array[ iPos ].method : (gchar *) hb_parc( 4 );

    // Si pasamos un bloque de codigo, entonces, cMethod es igual a la seÒal encontrada.
    // Asi, en el CALLBACK podemos seleccionar el codeblock de la seÒal que nos interesa.
    if( ISBLOCK( 4 ) )
      cMethod = array[ iPos ].name;

    if ( iPos != -1 ){
      iReturn = g_signal_connect_data( G_OBJECT( widget ),
                                       array[ iPos ].name,
                                       array[ iPos ].callback,
                                       cMethod,
                                       NULL, ConnectFlags );
      hb_retni( iReturn );
      }
   else
      g_print( "Attention, %s signal not support! Information method-%s, post-%i \n", cStr, cMethod, iPos);

    if( ISOBJECT( 3 ) ) {
       if( g_object_get_data( G_OBJECT( widget ), "Self" ) == NULL )
         {
          pSelf = hb_itemNew( hb_param( 3, HB_IT_OBJECT ) );
         // pSelf = hb_gcGripGet( hb_param( 3, HB_IT_OBJECT ) );
          g_object_set_data_full( G_OBJECT (widget), "Self", pSelf,
                                  (GDestroyNotify) liberate_block_memory );
          //Debug
          //g_print("\nEn har_e %d %s classname %s \n", GPOINTER_TO_UINT( pSelf ), array[ iPos ] , hb_objGetClsName( pSelf ) );
         }
    }


    /*Nota:
     * A diferencia de cuando disponemos de Self, necesitamos guardar cada bloque
     * por seÒal, de lo contrario, solamente la primera declarada, funcionara...
     * Para ello, aprovechamos el nombre de la seÒal, contenido en el array,
     * para guardar el codeblock segun la seÒal.
     * */
    if( ISBLOCK( 4 ) ) {
      if( g_object_get_data( G_OBJECT( widget ), array[ iPos ].name ) == NULL )
        {
         //pBlock = hb_gcGripGet( hb_param( 4, HB_IT_BLOCK | HB_IT_BYREF ) );
         //pBlock = hb_itemNew( hb_stackItemFromBase( 4 ) );
         // hb_stackItemFromBase(), significa que te devuelva un ITEM,
         // del STACK, partiendo de la BASE
         // y por BASE se entiende la funciÛn actual
         pBlock = hb_itemNew( hb_param( 4, HB_IT_BLOCK | HB_IT_BYREF ));
         /**
         * Atencion !
         * Cualquier salida via gtk_main_quit() provocara que no se llame nunca
         * a la 'callback' destroy. Hay que 'cerrar' los contenedores para que
         * emitan la seÒal 'destroy' y se pueda autollamar a la funcion de
         * liberacion de memoria liberate_block_memory
          **/
          g_object_set_data_full( G_OBJECT (widget), array[ iPos ].name, pBlock,
                                  (GDestroyNotify) liberate_block_memory );

        }
    }

}

