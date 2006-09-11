/* $Id: events.c,v 1.2 2006-09-11 16:43:38 xthefull Exp $*/
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
#include "hbapi.h"
#include "hbvm.h"
#include "hbapiitm.h"
#include "hbstack.h"

// Content arrays the signals and Methods
#include "events.h"

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
    gint num_elements = sizeof( array )/ sizeof(gchar *);
    gint ConnectFlags = ISNIL( 5 ) ? (GConnectFlags) 0 :  (GConnectFlags) hb_parni( 5 );
    gchar *cMethod; // =  (gchar *) hb_parc( 4 );

    /* Si es Self, es el nombre del method, de lo contrario, puede ser un codeblock */
    if( ISOBJECT( 3 ) ) 
    {
      cMethod =  (gchar *) hb_parc( 4 );
     }

    // Busca la se√±al que tengo que procesar.
    for ( x = 0;  x < num_elements; x++ ) {
        if( strcmp( cStr, array[x] ) == 0 ) {
            iPos = x;
            break;
        }
    }
    
    // Buscaremos el method, si hemos pasado Self, si no, no perdemos tiempo
    if( ISOBJECT( 3 ) )
    { 
      // Si tno pasamos el method a Saltar , cogera el del array
       if ( cMethod == NULL) {
           cMethod = aMethods[ iPos ];
       }
    }
    
    // Si pasamos un bloque de codigo, entonces, cMethod es igual a la seÒal encontrada.
    // Asi, en el CALLBACK podemos seleccionar el codeblock de la seÒal que nos interesa.
    if( ISBLOCK( 4 ) )
      cMethod = array[ iPos ];
   
    switch( iPos )
     {
       case 0:  // clicked
       case 1:  // pressed
       case 2:  // released
       case 3:  // enter
       case 4:  // leave
       case 5:  // toggled
       case 7:  // day-selected
       case 8:  // day-selected-double-click
       case 9:  // month-changed
       case 10: // next-month
       case 11: // next-year
       case 12: // prev-month
       case 13: // prev-year
       case 14: // activate
       case 18: // destroy
       case 20: // changed
       case 21: // value-changed
       case 32: // show-menu
       case 67: // popup-menu
       case 95: // accept-position
       case 96: // cancel-position
       case 100: //toggle-handle-focus
         iReturn = g_signal_connect_data( G_OBJECT( widget ),
                                          array[ iPos ],
                                          G_CALLBACK( OnEventos ), 
                                          cMethod, NULL, ConnectFlags );
         hb_retni( iReturn );
		 break;

       case 6:  // delete-event
       case 39: // event
       case 48: // destroy-event
       case 62: // map-event
       case 85: // unmap-event
       case 90: // frame-event
         iReturn = g_signal_connect_data( G_OBJECT( widget ),
                                          array[ iPos ],
                                          G_CALLBACK( OnDelete_Event ), 
                                          cMethod, NULL, ConnectFlags );
         hb_retni( iReturn );
         break;
       
       case 50: // event-after
         iReturn = g_signal_connect_data( G_OBJECT( widget ),
                                          array[ iPos ],
                                          G_CALLBACK( OnEvent_After ), 
                                          cMethod, NULL, ConnectFlags );
         hb_retni( iReturn );
         break;

       case 15: // focus-out-event
       case 19: // focus-in-event
         iReturn = g_signal_connect_data( G_OBJECT( widget ),
                                          array[ iPos ],
                                          G_CALLBACK( OnFocusEvent ), 
                                          cMethod, NULL, ConnectFlags );
         hb_retni( iReturn );
         break;

       case 16: // key_press_event
       case 27: // key_release_event
         iReturn = g_signal_connect_data( G_OBJECT( widget ),
                                          array[ iPos ],
                                          G_CALLBACK( OnKeyPressEvent ), 
                                          cMethod, NULL, ConnectFlags );
         hb_retni( iReturn );
         break;

       case 17: //"response"
         iReturn = g_signal_connect_data( G_OBJECT( widget ),
                                          array[ iPos ],
                                          G_CALLBACK( OnResponse ), 
                                          cMethod, NULL, ConnectFlags );
         hb_retni( iReturn );
         break;

       case 22:  // move-slider
         iReturn = g_signal_connect_data( G_OBJECT( widget ),
                                          array[ iPos ],
                                          G_CALLBACK( OnMove_slider ), 
                                          cMethod, NULL, ConnectFlags );
         hb_retni( iReturn );
		 break;

       case 23: // "expose-event"
         iReturn = g_signal_connect_data( G_OBJECT( widget ),
                                          array[ iPos ],
                                          G_CALLBACK( OnExpose_Event ), 
                                          cMethod, NULL, ConnectFlags );
         hb_retni( iReturn );
         break;

	   case 24:  // select-child
         iReturn = g_signal_connect_data( G_OBJECT( widget ),
                                          array[ iPos ],
                                          G_CALLBACK( OnSelect_child ), 
                                          cMethod, NULL, ConnectFlags );
         hb_retni( iReturn );
		 break;

       case 25:  // Selection-changed
         iReturn = g_signal_connect_data( G_OBJECT( widget ),
                                          array[ iPos ],
                                          G_CALLBACK( OnSelection_changed ), 
                                          cMethod, NULL, ConnectFlags );
         hb_retni( iReturn );
		 break;

       case 26:  // switch-page
         iReturn = g_signal_connect_data( G_OBJECT( widget ),
                                          array[ iPos ],
                                          G_CALLBACK( OnSwitch_page ), 
                                          cMethod, NULL, ConnectFlags );
         hb_retni( iReturn );
		 break;

       case 28:  // group_changed
         iReturn = g_signal_connect_data( G_OBJECT( widget ),
                                          array[ iPos ],
                                          G_CALLBACK( OnGroup_changed ), 
                                          cMethod, NULL, ConnectFlags );
         hb_retni( iReturn );
		 break;
       
       case 29:  // row-activated
         iReturn = g_signal_connect_data( G_OBJECT( widget ),
                                          array[ iPos ],
                                          G_CALLBACK( OnRow_activated ), 
                                          cMethod, NULL, ConnectFlags );
         hb_retni( iReturn );
         break;

       case 30:  // cell_toggled
         iReturn = g_signal_connect_data( G_OBJECT( widget ),
                                          "toggled",
                                          G_CALLBACK( OnCell_toggled ), 
                                          cMethod, NULL, ConnectFlags );
         hb_retni( iReturn );
         break;
       
       case 31:  // insert-at-cursor
         iReturn = g_signal_connect_data( G_OBJECT( widget ),
                                          array[ iPos ],
                                          G_CALLBACK( OnInsert_at_cursor ), 
                                          cMethod, NULL, ConnectFlags );
         hb_retni( iReturn );
         break;
       
       case 33:  // item-activated
         iReturn = g_signal_connect_data( G_OBJECT( widget ),
                                          array[ iPos ],
                                          G_CALLBACK( OnItem_Activated ), 
                                          cMethod, NULL, ConnectFlags );
         hb_retni( iReturn );
         break;
      
       case 34: // "configure-event"
         iReturn = g_signal_connect_data( G_OBJECT( widget ),
                                          array[ iPos ],
                                          G_CALLBACK( OnConfigure_Event ), 
                                          cMethod, NULL, ConnectFlags );
         hb_retni( iReturn );
         break;
        
       case 37: // cursor
         iReturn = g_signal_connect_data( G_OBJECT( widget ),
                                          array[ iPos ],
                                          G_CALLBACK( OnCursor_Changed ), 
                                          cMethod, NULL, ConnectFlags );
         hb_retni( iReturn );
         break;
       
       case 38: // Edited
         iReturn = g_signal_connect_data( G_OBJECT( widget ),
                                          array[ iPos ],
                                          G_CALLBACK( OnEdited ), 
                                          cMethod, NULL, ConnectFlags );
         hb_retni( iReturn );
         break;

       case 40: // enter-notify-event
       case 41: // leave-notify-event
         iReturn = g_signal_connect_data( G_OBJECT( widget ),
                                          array[ iPos ],
                                          G_CALLBACK( OnEnter_Leave_NotifyEvent ), 
                                          cMethod, NULL, ConnectFlags );
         hb_retni( iReturn );
         break;
       
       case 43: // button-press-event
       case 44: // button-release-event
         iReturn = g_signal_connect_data( G_OBJECT( widget ),
                                          array[ iPos ],
                                          G_CALLBACK( OnButton_Press_Event ), 
                                          cMethod, NULL, ConnectFlags );
         hb_retni( iReturn );
         break;

       case 45: // can-activate-accel
         iReturn = g_signal_connect_data( G_OBJECT( widget ),
                                          array[ iPos ],
                                          G_CALLBACK( OnCan_Activate_Accel ), 
                                          cMethod, NULL, ConnectFlags );
         hb_retni( iReturn );
         break;
       
       case 46: // child-notify
         iReturn = g_signal_connect_data( G_OBJECT( widget ),
                                          array[ iPos ],
                                          G_CALLBACK( OnChild_Notify ), 
                                          cMethod, NULL, ConnectFlags );
         hb_retni( iReturn );
         break;
       
       case 47: // client-event
         iReturn = g_signal_connect_data( G_OBJECT( widget ),
                                          array[ iPos ],
                                          G_CALLBACK( OnClient_Event ), 
                                          cMethod, NULL, ConnectFlags );
         hb_retni( iReturn );
         break;
       
       case 49: // direction-changed
         iReturn = g_signal_connect_data( G_OBJECT( widget ),
                                          array[ iPos ],
                                          G_CALLBACK( OnDirection_Changed ), 
                                          cMethod, NULL, ConnectFlags );
         hb_retni( iReturn );
         break;

       case 51: // focus
         iReturn = g_signal_connect_data( G_OBJECT( widget ),
                                          array[ iPos ],
                                          G_CALLBACK( OnFocus ), 
                                          cMethod, NULL, ConnectFlags );
         hb_retni( iReturn );
         break;
       
       case 52: // add  --GtkContainer
       case 53: // remove
       case 54: // set-focus-child
         iReturn = g_signal_connect_data( G_OBJECT( widget ),
                                          array[ iPos ],
                                          G_CALLBACK( OnSignals_Container ), 
                                          cMethod, NULL, ConnectFlags );
         hb_retni( iReturn );
         break;
       
       case 55: // check-resize  --GtkContainer
         iReturn = g_signal_connect_data( G_OBJECT( widget ),
                                          array[ iPos ],
                                          G_CALLBACK( OnCheck_Resize ), 
                                          cMethod, NULL, ConnectFlags );
         hb_retni( iReturn );
         break;
       
       case 56: // grab-broken-event
         iReturn = g_signal_connect_data( G_OBJECT( widget ),
                                          array[ iPos ],
                                          G_CALLBACK( OnGrab_Broken_Event ), 
                                          cMethod, NULL, ConnectFlags );
         hb_retni( iReturn );
         break;
       
       case 58: // grab-notify
         iReturn = g_signal_connect_data( G_OBJECT( widget ),
                                          array[ iPos ],
                                          G_CALLBACK( OnGrab_Notify ), 
                                          cMethod, NULL, ConnectFlags );
         hb_retni( iReturn );
         break;
       
       case 35: // realize
       case 36: // unrealize
       case 42: // accel-closures-changed
       case 57: // grab-focus
       case 59: // hide
       case 61: // map
       case 78: // show
       case 84: // unmap
       case 88: // activate-default
       case 89: // activate-focus
       case 91: // keys-changed
       case 94: // close
         iReturn = g_signal_connect_data( G_OBJECT( widget ),
                                          array[ iPos ],
                                          G_CALLBACK( OnEventos_void ), 
                                          cMethod, NULL, ConnectFlags );
         hb_retni( iReturn );
         break;
       
       case 60: // hierarchy-changed
       case 93: // set-focus
         iReturn = g_signal_connect_data( G_OBJECT( widget ),
                                          array[ iPos ],
                                          G_CALLBACK( OnHierarchy_Changed ), 
                                          cMethod, NULL, ConnectFlags );
         hb_retni( iReturn );
         break;
       
       case 63: // mnemonic-activate
         iReturn = g_signal_connect_data( G_OBJECT( widget ),
                                          array[ iPos ],
                                          G_CALLBACK( OnMnemonic_Activate ), 
                                          cMethod, NULL, ConnectFlags );
         hb_retni( iReturn );
         break;
       
       case 64: // motion-notify-event
         iReturn = g_signal_connect_data( G_OBJECT( widget ),
                                          array[ iPos ],
                                          G_CALLBACK( OnMotion_Notify_Event ), 
                                          cMethod, NULL, ConnectFlags );
         hb_retni( iReturn );
         break;

       case 65: // no-expose-event
         iReturn = g_signal_connect_data( G_OBJECT( widget ),
                                          array[ iPos ],
                                          G_CALLBACK( OnNo_Expose_Event ), 
                                          cMethod, NULL, ConnectFlags );
         hb_retni( iReturn );
         break;
       
       case 66: // parent-set
         iReturn = g_signal_connect_data( G_OBJECT( widget ),
                                          array[ iPos ],
                                          G_CALLBACK( OnParent_Set ), 
                                          cMethod, NULL, ConnectFlags );
         hb_retni( iReturn );
         break;
      
       case 68: // property-notify-event
         iReturn = g_signal_connect_data( G_OBJECT( widget ),
                                          array[ iPos ],
                                          G_CALLBACK( OnProperty_Notify_Event ), 
                                          cMethod, NULL, ConnectFlags );
         hb_retni( iReturn );
         break;
       
       case 69: // proximity-in-event
       case 70: // proximity-out-event
         iReturn = g_signal_connect_data( G_OBJECT( widget ),
                                          array[ iPos ],
                                          G_CALLBACK( OnProximity_Event ), 
                                          cMethod, NULL, ConnectFlags );
         hb_retni( iReturn );
         break;
       
       case 71: // screen-changed
         iReturn = g_signal_connect_data( G_OBJECT( widget ),
                                          array[ iPos ],
                                          G_CALLBACK( OnScreen_Changed ), 
                                          cMethod, NULL, ConnectFlags );
         hb_retni( iReturn );
         break;
       
       case 72: // scroll-event
         iReturn = g_signal_connect_data( G_OBJECT( widget ),
                                          array[ iPos ],
                                          G_CALLBACK( OnScroll_Event ), 
                                          cMethod, NULL, ConnectFlags );
         hb_retni( iReturn );
         break;
       
       case 73: // selection-clear-event
       case 75: // selection-notify-event
       case 77: // selection-request-event
         iReturn = g_signal_connect_data( G_OBJECT( widget ),
                                          array[ iPos ],
                                          G_CALLBACK( OnSelection_Event ), 
                                          cMethod, NULL, ConnectFlags );
         hb_retni( iReturn );
         break;

       case 74: // selection-get
         iReturn = g_signal_connect_data( G_OBJECT( widget ),
                                          array[ iPos ],
                                          G_CALLBACK( OnSelection_Get ), 
                                          cMethod, NULL, ConnectFlags );
         hb_retni( iReturn );
         break;
       
       case 76: // selection-received
         iReturn = g_signal_connect_data( G_OBJECT( widget ),
                                          array[ iPos ],
                                          G_CALLBACK( OnSelection_Received ), 
                                          cMethod, NULL, ConnectFlags );
         hb_retni( iReturn );
         break;
       
       case 79: // show-help
         iReturn = g_signal_connect_data( G_OBJECT( widget ),
                                          array[ iPos ],
                                          G_CALLBACK( OnShow_Help ), 
                                          cMethod, NULL, ConnectFlags );
         hb_retni( iReturn );
         break;
       
       case 80: // size-allocate
         iReturn = g_signal_connect_data( G_OBJECT( widget ),
                                          array[ iPos ],
                                          G_CALLBACK( OnSize_Allocate ), 
                                          cMethod, NULL, ConnectFlags );
         hb_retni( iReturn );
         break;

       case 81: // size-request
         iReturn = g_signal_connect_data( G_OBJECT( widget ),
                                          array[ iPos ],
                                          G_CALLBACK( OnSize_Request ), 
                                          cMethod, NULL, ConnectFlags );
         hb_retni( iReturn );
         break;
       
       case 82: // state-changed
         iReturn = g_signal_connect_data( G_OBJECT( widget ),
                                          array[ iPos ],
                                          G_CALLBACK( OnState_Changed ), 
                                          cMethod, NULL, ConnectFlags );
         hb_retni( iReturn );
         break;
       
       case 83: // style-set
         iReturn = g_signal_connect_data( G_OBJECT( widget ),
                                          array[ iPos ],
                                          G_CALLBACK( OnStyle_Set ), 
                                          cMethod, NULL, ConnectFlags );
         hb_retni( iReturn );
         break;

       case 86: // visibility-notify-event
         iReturn = g_signal_connect_data( G_OBJECT( widget ),
                                          array[ iPos ],
                                          G_CALLBACK( OnVisibility_Notify_Event ), 
                                          cMethod, NULL, ConnectFlags );
         hb_retni( iReturn );
         break;
       
       case 87: // window-state-event
         iReturn = g_signal_connect_data( G_OBJECT( widget ),
                                          array[ iPos ],
                                          G_CALLBACK( OnWindow_State_Event ), 
                                          cMethod, NULL, ConnectFlags );
         hb_retni( iReturn );
         break;
       
       case 92: // move-focus
       case 103: // move-focus-out
         iReturn = g_signal_connect_data( G_OBJECT( widget ),
                                          array[ iPos ],
                                          G_CALLBACK( OnMove_Focus ), 
                                          cMethod, NULL, ConnectFlags );
         hb_retni( iReturn );
         break;

       case 97: // cycle-child-focus
       case 98: // cycle-handle-focus
         iReturn = g_signal_connect_data( G_OBJECT( widget ),
                                          array[ iPos ],
                                          G_CALLBACK( OnCycle_Child_Focus ), 
                                          cMethod, NULL, ConnectFlags );
         hb_retni( iReturn );
         break;
       
       case 99: // move-handle
         iReturn = g_signal_connect_data( G_OBJECT( widget ),
                                          array[ iPos ],
                                          G_CALLBACK( OnMove_Handle ), 
                                          cMethod, NULL, ConnectFlags );
         hb_retni( iReturn );
         break;
       
       case 101: // adjust-bounds
         iReturn = g_signal_connect_data( G_OBJECT( widget ),
                                          array[ iPos ],
                                          G_CALLBACK( OnAdjust_Bounds ), 
                                          cMethod, NULL, ConnectFlags );
         hb_retni( iReturn );
         break;
       
       case 102: // change-value
         iReturn = g_signal_connect_data( G_OBJECT( widget ),
                                          array[ iPos ],
                                          G_CALLBACK( OnChange_Value ), 
                                          cMethod, NULL, ConnectFlags );
         hb_retni( iReturn );
         break;
       
       case 104: // scroll-child
         iReturn = g_signal_connect_data( G_OBJECT( widget ),
                                          array[ iPos ],
                                          G_CALLBACK( OnScroll_Child ), 
                                          cMethod, NULL, ConnectFlags );
         hb_retni( iReturn );
         break;

       /*case :  // columns-changed ... provoca caida de gWIndow. ?ø?ø
          iReturn = g_signal_connect( G_OBJECT( widget ),
                                      array[ iPos ],
                                      G_CALLBACK( OnColumns_changed ), cMethod );
         hb_retni( iReturn );
         break;
        */
       default:
         g_print( "Attention, %s signal not support!\n", cStr );
         break;
     }

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
      if( g_object_get_data( G_OBJECT( widget ), array[ iPos ] ) == NULL )
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
          g_object_set_data_full( G_OBJECT (widget), array[ iPos ], pBlock, 
                                  (GDestroyNotify) liberate_block_memory );
         
        }
    }

}

