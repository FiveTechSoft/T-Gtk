
/* $Id: events.c,v 1.22 2010-12-28 10:32:34 xthefull Exp $*/
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
 *   KERNEL T-GTK [ Control conexion de se�ales de GTK+ ]
 *  (c)2003 Rafa Carmona
 */
#include <gtk/gtk.h>
#include "hbapi.h"
#include "hbvm.h"
#include "hbapiitm.h"
#include "hbstack.h"
#include "t-gtk.h"
#include "hbapierr.h"
#include "gerrapi.h"

#ifdef __XHARBOUR__
#include "hashapi.h"
typedef ULONG GTKSIZE;
#define hb_strncpyLower( X, Y , Z) )   hb_strncpy( X, Y, Z ) ;
#else
typedef HB_SIZE GTKSIZE;
#endif

PHB_ITEM Iter2Array( GtkTreeIter *iter  );

// Atencion esto esta para mantener compatibilidad con xHarbour anteriores
// Debe desaparecer , pero lo necesito ahora
#ifdef __OLDHARBOUR__
  HB_EXPORT PHB_SYMB hb_dynsymSymbol( PHB_DYNS pDynSym )
  {
    return pDynSym->pSymbol;
  }
#endif
/* ------------------------------------------------------------------- */

  void OnDel_Text( GtkEntry *widget, gint ini, gint end, gpointer data )
  {
    PHB_ITEM pObj = NULL;
    PHB_ITEM pBlock;
    PHB_DYNS pMethod ;

  // comprobamos que no exista definido un codeblock a la se�al.
    pBlock = g_object_get_data( G_OBJECT( widget ), (gchar*) data );

    if( pBlock == NULL ){
      pObj  = g_object_get_data( G_OBJECT( widget ), "Self" );
      if( pObj ) {
        pMethod = hb_dynsymFindName( data );
        if( pMethod ){
          hb_vmPushSymbol( hb_dynsymSymbol( pMethod ) );     // Coloca simbolo en la pila
          hb_vmPush( pObj );                                 // Coloca objeto en pila.
          hb_vmPush( pObj );                            // oSender
          hb_vmPushInteger( ini );                      // Texto
          hb_vmPushInteger( end );                      // Largo
          hb_vmSend( 3 );
        } else {
	  HB_ERRCODE ErrCode = 5002;	  
	  hb_errRT_BASE_Ext1( EG_ARG, ErrCode, GetGErrorMsg( ErrCode, "OnDel_Text" ), HB_ERR_FUNCNAME, 0, EF_CANDEFAULT, HB_ERR_ARGS_BASEPARAMS );
//	  g_print( "Method doesn't %s exist en OnHierarchy_Changed", (gchar *)data );
        }
      }
    }

  // Obtenemos el codeblock de la se�al, data, que debemos evaluar...
    if( pObj == NULL ){
      if( pBlock ) {
        hb_vmPushSymbol( &hb_symEval );
        hb_vmPush( pBlock );
        hb_vmPushPointer( ( GtkWidget * ) widget );
        hb_vmPushInteger( ini );      // Texto
        hb_vmPushInteger( end );                   // Largo
        hb_vmSend( 3 );
      }
    }

  }

/* ------------------------------------------------------------------- */

  void On_Text( GtkEntry *widget, gchar *text, gint length, gint *position, gpointer data )
  {
    PHB_ITEM pObj = NULL;
    PHB_ITEM pBlock;
    PHB_DYNS pMethod ;

  // comprobamos que no exista definido un codeblock a la se�al.
    pBlock = g_object_get_data( G_OBJECT( widget ), (gchar*) data );

    if( pBlock == NULL ){
      pObj  = g_object_get_data( G_OBJECT( widget ), "Self" );
      if( pObj ) {
        pMethod = hb_dynsymFindName( data );
        if( pMethod ){
          hb_vmPushSymbol( hb_dynsymSymbol( pMethod ) );     // Coloca simbolo en la pila
          hb_vmPush( pObj );                                 // Coloca objeto en pila.
          hb_vmPush( pObj );                            // oSender
          hb_vmPushString( text, strlen( text ) );      // Texto
          hb_vmPushInteger( length );                   // Largo
          hb_vmPushInteger( *position );          // Posicion
          hb_vmSend( 4 );
          *position =  hb_itemGetNI( hb_stackReturnItem() );
        } else {
	  HB_ERRCODE ErrCode = 5002;	  
	  hb_errRT_BASE_Ext1( EG_ARG, ErrCode, GetGErrorMsg( ErrCode, "On_Text" ), HB_ERR_FUNCNAME, 0, EF_CANDEFAULT, HB_ERR_ARGS_BASEPARAMS );
        }
      }
    }

  // Obtenemos el codeblock de la se�al, data, que debemos evaluar...
    if( pObj == NULL ){
      if( pBlock ) {
        hb_vmPushSymbol( &hb_symEval );
        hb_vmPush( pBlock );
        hb_vmPushPointer( ( GtkWidget * ) widget );
        hb_vmPushString( text, strlen( text ) );      // Texto
        hb_vmPushInteger( length );                   // Largo
        hb_vmPushInteger( *position );          // Posicion
        hb_vmSend( 4 );
        *position =  hb_itemGetNI( hb_stackReturnItem() );
      }
    }

  }



/*---------------------------------------------------
// CALLBACK generica para diferentes se�ales.
---------------------------------------------------*/
gint OnEventos( GtkWidget * widget, gpointer data )
{
  PHB_ITEM pObj = NULL;
  PHB_ITEM pBlock;
  PHB_DYNS pMethod ;

  pBlock = g_object_get_data( G_OBJECT( widget ), (gchar*) data );

  if( pBlock == NULL ){
      pObj  = g_object_get_data( G_OBJECT( widget ), "Self" );
      if( pObj ) {
         pMethod = hb_dynsymFindName( data );
         if( pMethod ){
             hb_vmPushSymbol( hb_dynsymSymbol( pMethod ) );     // Coloca simbolo en la pila
             hb_vmPush( pObj );                                 // Coloca objeto en pila.
             hb_vmPush( pObj );                                 // Dato a pasar
             hb_vmSend( 1 );                                    // LLamada por Send
             return( hb_parl( -1 ) );
         } else {
	  HB_ERRCODE ErrCode = 5002;	  
	  hb_errRT_BASE_Ext1( EG_ARG, ErrCode, GetGErrorMsg( ErrCode, "OnEventos" ), HB_ERR_FUNCNAME, 0, EF_CANDEFAULT, HB_ERR_ARGS_BASEPARAMS );
         }
      }
  }

  // Obtenemos el codeblock de la se�al, data, que debemos evaluar...
  if( pObj == NULL ){
     if( pBlock ) {
        hb_vmPushSymbol( &hb_symEval );
        hb_vmPush( pBlock );
        hb_vmPushPointer( ( GtkWidget * ) widget );
        hb_vmSend( 1 );                               // LLamada por Send al codeblocks
        return( hb_parl( -1 ) );
     }
  }

  return FALSE;
}

/*---------------------------------------------------
// CALLBACK generica para diferentes se�ales.
---------------------------------------------------*/
void OnEventos_void( GtkWidget * widget, gpointer data )
{
  PHB_ITEM pObj = NULL;
  PHB_ITEM pBlock;
  PHB_DYNS pMethod ;

  // comprobamos que no exista definido un codeblock a la se�al.
  pBlock = g_object_get_data( G_OBJECT( widget ), (gchar*) data );

  if( pBlock == NULL ){
      pObj  = g_object_get_data( G_OBJECT( widget ), "Self" );
      if( pObj ) {
         pMethod = hb_dynsymFindName( data );
         if( pMethod ){
            hb_vmPushSymbol( hb_dynsymSymbol( pMethod ) );
            hb_vmPush( pObj );
            hb_vmPush( pObj );
            hb_vmSend( 1 );
         } else {
	  HB_ERRCODE ErrCode = 5002;	  
	  hb_errRT_BASE_Ext1( EG_ARG, ErrCode, GetGErrorMsg( ErrCode, "OnEventos_void" ), HB_ERR_FUNCNAME, 0, EF_CANDEFAULT, HB_ERR_ARGS_BASEPARAMS );	   
//           g_print( "Method doesn't %s exist en OnEventos_void", (gchar *)data );
         }
      }
  }

  // Obtenemos el codeblock de la se�al, data, que debemos evaluar...
  if( pObj == NULL ){
     if( pBlock ) {
        hb_vmPushSymbol( &hb_symEval );
        hb_vmPush( pBlock );
        hb_vmPushPointer( ( GtkWidget * ) widget );
        hb_vmSend( 1 );
     }
  }

}

// **********************************************************************
// Sirve para EVENT y ONDELETE_EVENT
// **********************************************************************
gboolean OnDelete_Event( GtkWidget *widget, GdkEvent  *event, gpointer data )
{
  PHB_ITEM pObj = NULL;
  PHB_ITEM pBlock;
  PHB_DYNS pMethod ;

  // comprobamos que no exista definido un codeblock a la se�al.
  pBlock = g_object_get_data( G_OBJECT( widget ), (gchar*) data );

  if( pBlock == NULL ){
      pObj  = g_object_get_data( G_OBJECT( widget ), "Self" );
      if( pObj ) {
         pMethod = hb_dynsymFindName( data );
         if( pMethod ){
            hb_vmPushSymbol( hb_dynsymSymbol( pMethod ) );     // Coloca simbolo en la pila
            hb_vmPush( pObj );                            // Coloca objeto en pila.
            hb_vmPush( pObj );                            // oSender
            hb_vmPushPointer( ( GdkEvent  *) event );
//            hb_vmPushLong( GPOINTER_TO_UINT( event ) );
            hb_vmSend( 2 );                               // LLamada por Send que pasa
            return( hb_parl( -1 ) );
         } else {
	  HB_ERRCODE ErrCode = 5002;	  
	  hb_errRT_BASE_Ext1( EG_ARG, ErrCode, GetGErrorMsg( ErrCode, "OnDelete_Event" ), HB_ERR_FUNCNAME, 0, EF_CANDEFAULT, HB_ERR_ARGS_BASEPARAMS );   
//           g_print( "Method doesn't %s exist en OnDelete_Event", (gchar *)data );
         }
      }
  }

  // Obtenemos el codeblock de la se�al, data, que debemos evaluar...
  if( pObj == NULL ){
     if( pBlock ) {
        hb_vmPushSymbol( &hb_symEval );
        hb_vmPush( pBlock );
        hb_vmPushPointer( ( GtkWidget * ) widget );
        hb_vmPushPointer( ( GdkEvent  *) event );
        hb_vmSend( 2 );
        return( hb_parl( -1 ) );
     }
  }

  return( FALSE );  // Salimos
}

void OnEvent_After( GtkWidget *widget, GdkEvent  *event, gpointer data )
{
  PHB_ITEM pObj = NULL;
  PHB_ITEM pBlock;
  PHB_DYNS pMethod ;

  // comprobamos que no exista definido un codeblock a la se�al.
  pBlock = g_object_get_data( G_OBJECT( widget ), (gchar*) data );

  if( pBlock == NULL ){
      pObj  = g_object_get_data( G_OBJECT( widget ), "Self" );
      if( pObj ) {
         pMethod = hb_dynsymFindName( data );
         if( pMethod ){
            hb_vmPushSymbol( hb_dynsymSymbol( pMethod ) );     // Coloca simbolo en la pila
            hb_vmPush( pObj );                            // Coloca objeto en pila.
            hb_vmPush( pObj );                            // oSender
            hb_vmPushPointer( ( GdkEvent  *) event );
//            hb_vmPushLong( GPOINTER_TO_UINT( event ) );
            hb_vmSend( 2 );                               // LLamada por Send que pasa
         } else {
	  HB_ERRCODE ErrCode = 5002;	  
	  hb_errRT_BASE_Ext1( EG_ARG, ErrCode, GetGErrorMsg( ErrCode, "OnEventAfter" ), HB_ERR_FUNCNAME, 0, EF_CANDEFAULT, HB_ERR_ARGS_BASEPARAMS );
//           g_print( "Method doesn't %s exist en OnEventAfter", (gchar *)data );
         }
      }
  }

  // Obtenemos el codeblock de la se�al, data, que debemos evaluar...
  if( pObj == NULL ){
     if( pBlock ) {
        hb_vmPushSymbol( &hb_symEval );
        hb_vmPush( pBlock );
        hb_vmPushPointer( ( GtkWidget * ) widget );
        hb_vmPushPointer( ( GdkEvent  *) event );        
        hb_vmSend( 2 );
     }
  }
}

/* Evento "response" para dialogos */
gint OnResponse( GtkDialog * widget, gint arg1, gpointer data )
{
  PHB_ITEM pObj = NULL;
  PHB_ITEM pBlock;
  PHB_DYNS pMethod ;

  // comprobamos que no exista definido un codeblock a la se�al.
  pBlock = g_object_get_data( G_OBJECT( widget ), (gchar*) data );

  if( pBlock == NULL ){
      pObj  = g_object_get_data( G_OBJECT( widget ), "Self" );
      if( pObj ) {
         pMethod = hb_dynsymFindName( data );
         if( pMethod ){
            hb_vmPushSymbol( hb_dynsymSymbol( pMethod ) );     // Coloca simbolo en la pila
            hb_vmPush( pObj );                            // Coloca objeto en pila.
            hb_vmPush( pObj );                            // oSender
            hb_vmPushInteger( (gint) arg1 );              // senyal producida
            hb_vmSend( 2 );                               // LLamada por Send que pasa
            return( hb_parl( -1 ) );
         } else {
	  HB_ERRCODE ErrCode = 5002;	  
	  hb_errRT_BASE_Ext1( EG_ARG, ErrCode, GetGErrorMsg( ErrCode, "OnResponse" ), HB_ERR_FUNCNAME, 0, EF_CANDEFAULT, HB_ERR_ARGS_BASEPARAMS );   
//	   g_print( "Method doesn't %s exist en OnResponse", (gchar *)data );
         }
      }
  }

  // Obtenemos el codeblock de la se�al, data, que debemos evaluar...
  if( pObj == NULL ){
     if( pBlock ) {
        hb_vmPushSymbol( &hb_symEval );
        hb_vmPush( pBlock );
        hb_vmPushPointer( ( GtkWidget * ) widget );
        hb_vmPushInteger( arg1 );
        hb_vmSend( 2 );
        return( hb_parl( -1 ) );
     }
  }

  return( FALSE );
}

gint OnKeyPressEvent( GtkWidget * widget, GdkEventKey * event, gpointer data )
{
  PHB_ITEM pObj = NULL;
  PHB_ITEM pBlock;
  PHB_DYNS pMethod ;
//  PHB_ITEM ReturnArray, ArrayItem, pBlock;

  // comprobamos que no exista definido un codeblock a la se�al.
  pBlock = g_object_get_data( G_OBJECT( widget ), (gchar*) data );

  if( pBlock == NULL ){
      pObj  = g_object_get_data( G_OBJECT( widget ), "Self" );
      if( pObj ) {
         pMethod = hb_dynsymFindName( data );
         if( pMethod ){
            hb_vmPushSymbol( hb_dynsymSymbol( pMethod ) );     // Coloca simbolo en la pila
            hb_vmPush( pObj );                            // Coloca objeto en pila.
            hb_vmPush( pObj );                            // oSender
            hb_vmPushPointer( ( GdkEventKey  *) event );            
            hb_vmSend( 2 );                               // LLamada por Send que pasa
            return( hb_parl( -1 ) );
         } else {
	  HB_ERRCODE ErrCode = 5002;	  
	  hb_errRT_BASE_Ext1( EG_ARG, ErrCode, GetGErrorMsg( ErrCode, "OnKeyPressEvent" ), HB_ERR_FUNCNAME, 0, EF_CANDEFAULT, HB_ERR_ARGS_BASEPARAMS );   
//	   g_print( "Method doesn't %s exist en OnKeyPressEvent", (gchar *)data );
         }
      }
  }

  // Obtenemos el codeblock de la se�al, data, que debemos evaluar...
  if( pObj == NULL ){
     if( pBlock ) {
        hb_vmPushSymbol( &hb_symEval );
        hb_vmPush( pBlock );
        hb_vmPushPointer( ( GtkWidget * ) widget );
        hb_vmPushPointer( ( GdkEventKey  *) event );
        hb_vmSend( 2 );
        return( hb_parl( -1 ) );
     }
  }

  return FALSE;

}


void OnIconRelease( GtkWidget * widget, GtkEntryIconPosition icon_pos, GdkEventKey * event, gpointer data ){
  PHB_ITEM pObj = NULL;
  PHB_ITEM pBlock;
  PHB_DYNS pMethod ;

  // comprobamos que no exista definido un codeblock a la se�al.
  pBlock = g_object_get_data( G_OBJECT( widget ), (gchar*) data );

  if( pBlock == NULL ){
      pObj  = g_object_get_data( G_OBJECT( widget ), "Self" );
      if( pObj ) {
         pMethod = hb_dynsymFindName( data );
         if( pMethod ){
            hb_vmPushSymbol( hb_dynsymSymbol( pMethod ) );     // Coloca simbolo en la pila
            hb_vmPush( pObj );                            // Coloca objeto en pila.
            hb_vmPush( pObj );                            // oSender
            hb_vmPushInteger( icon_pos );
            hb_vmSend( 2 );                               // LLamada por Send que pasa
            return;
         } else {
	  HB_ERRCODE ErrCode = 5002;	  
	  hb_errRT_BASE_Ext1( EG_ARG, ErrCode, GetGErrorMsg( ErrCode, "OnIcon_Release" ), HB_ERR_FUNCNAME, 0, EF_CANDEFAULT, HB_ERR_ARGS_BASEPARAMS );   	   
//           g_print( "Method doesn't %s exist en OnIcon_Release", (gchar *)data );
         }
      }
  }

  // Obtenemos el codeblock de la se�al, data, que debemos evaluar...
  if( pObj == NULL ){
     if( pBlock ) {
        hb_vmPushSymbol( &hb_symEval );
        hb_vmPush( pBlock );
        hb_vmPushPointer( ( GtkWidget * ) widget );
        hb_vmPushInteger( icon_pos );
        hb_vmSend( 2 );
        return;
     }
  }

  return;	
	
}



gint OnFocusEvent( GtkWidget *widget, GdkEventFocus * event, gpointer data )
{
  PHB_ITEM pObj = NULL;
  PHB_ITEM pBlock;
  PHB_DYNS pMethod ;

  // comprobamos que no exista definido un codeblock a la se�al.
  pBlock = g_object_get_data( G_OBJECT( widget ), (gchar*) data );

  if( pBlock == NULL ){
      pObj  = g_object_get_data( G_OBJECT( widget ), "Self" );
      if( pObj ) {
         pMethod = hb_dynsymFindName( data );
         if( pMethod ){
            hb_vmPushSymbol( hb_dynsymSymbol( pMethod ) );     // Coloca simbolo en la pila
            hb_vmPush( pObj );                            // Coloca objeto en pila.
            hb_vmPush( pObj );                            // oSender
            hb_vmPushPointer( ( GdkEventFocus  *) event );
            hb_vmSend( 2 );                               // LLamada por Send que pasa
            return( hb_parl( -1 ) );
         } else {
	  HB_ERRCODE ErrCode = 5002;	  
	  hb_errRT_BASE_Ext1( EG_ARG, ErrCode, GetGErrorMsg( ErrCode, "OnFocusEvent" ), HB_ERR_FUNCNAME, 0, EF_CANDEFAULT, HB_ERR_ARGS_BASEPARAMS );   
//	   g_print( "Method doesn't %s exist en OnFocusEvent", (gchar *)data );
         }
      }
  }

  // Obtenemos el codeblock de la se�al, data, que debemos evaluar...
  if( pObj == NULL ){
     if( pBlock ) {
        hb_vmPushSymbol( &hb_symEval );
        hb_vmPush( pBlock );
        hb_vmPushPointer( ( GtkWidget * ) widget );
        hb_vmPushPointer( ( GdkEventFocus  *) event );        
        hb_vmSend( 2 );
        return( hb_parl( -1 ) );
     }
  }

  return FALSE;
}

void OnMove_slider( GtkWidget *widget, GtkScrollType arg1, gpointer data )
{
  PHB_ITEM pObj = NULL;
  PHB_ITEM pBlock;
  PHB_DYNS pMethod ;

  // comprobamos que no exista definido un codeblock a la se�al.
  pBlock = g_object_get_data( G_OBJECT( widget ), (gchar*) data );

  if( pBlock == NULL ){
      pObj  = g_object_get_data( G_OBJECT( widget ), "Self" );
      if( pObj ) {
         pMethod = hb_dynsymFindName( data );
         if( pMethod ){
            hb_vmPushSymbol( hb_dynsymSymbol( pMethod ) );     // Coloca simbolo en la pila
            hb_vmPush( pObj );                            // Coloca objeto en pila.
            hb_vmPush( pObj );                            // oSender
            hb_vmPushInteger( arg1 );                     // GtkScrollType
            hb_vmSend( 2 );
         } else {
	  HB_ERRCODE ErrCode = 5002;	  
	  hb_errRT_BASE_Ext1( EG_ARG, ErrCode, GetGErrorMsg( ErrCode, "OnMove_Slider" ), HB_ERR_FUNCNAME, 0, EF_CANDEFAULT, HB_ERR_ARGS_BASEPARAMS );   	   
//           g_print( "Method doesn't %s exist en OnMove_Slider", (gchar *)data );
         }
      }
  }

  // Obtenemos el codeblock de la se�al, data, que debemos evaluar...
  if( pObj == NULL ){
     if( pBlock ) {
        hb_vmPushSymbol( &hb_symEval );
        hb_vmPush( pBlock );
        hb_vmPushPointer( ( GtkWidget * ) widget );
        hb_vmPushInteger( arg1 );                     // GtkScrollType
        hb_vmSend( 2 );
     }
  }

}

void OnSelect_child ( GtkList *list,  GtkWidget *widget, gpointer data )
{
  PHB_ITEM pObj = NULL;
  PHB_ITEM pBlock;
  PHB_DYNS pMethod ;

  // comprobamos que no exista definido un codeblock a la se�al.
  pBlock = g_object_get_data( G_OBJECT( list ), (gchar*) data );

  if( pBlock == NULL ){
      pObj  = g_object_get_data( G_OBJECT( list ), "Self" );
      if( pObj ) {
         pMethod = hb_dynsymFindName( data );
         if( pMethod ){
            hb_vmPushSymbol( hb_dynsymSymbol( pMethod ) );     // Coloca simbolo en la pila
            hb_vmPush( pObj );                            // Coloca objeto en pila.
            hb_vmPush( pObj );                            // oSender
            hb_vmPushPointer( ( GtkWidget * ) widget );
            hb_vmSend( 2 );                               // LLamada por Send que pasa
         } else {
	  HB_ERRCODE ErrCode = 5002;	  
	  hb_errRT_BASE_Ext1( EG_ARG, ErrCode, GetGErrorMsg( ErrCode, "OnSelect_child" ), HB_ERR_FUNCNAME, 0, EF_CANDEFAULT, HB_ERR_ARGS_BASEPARAMS );   
//	   g_print( "Method doesn't %s exist en OnSelect_child", (gchar *)data );
         }
      }
  }

  // Obtenemos el codeblock de la se�al, data, que debemos evaluar...
  if( pObj == NULL ){
     if( pBlock ) {
        hb_vmPushSymbol( &hb_symEval );
        hb_vmPush( pBlock );
        hb_vmPushPointer( ( GtkList * ) list );
        hb_vmPushPointer( ( GtkWidget * ) widget );
        hb_vmSend( 2 );
     }
  }

}

void OnSelection_changed( GtkList *list, gpointer data )
{
  PHB_ITEM pObj = NULL;
  PHB_ITEM pBlock;
  PHB_DYNS pMethod ;

  // comprobamos que no exista definido un codeblock a la se�al.
  pBlock = g_object_get_data( G_OBJECT( list ), (gchar*) data );

  if( pBlock == NULL ){
      pObj  = g_object_get_data( G_OBJECT( list ), "Self" );
      if( pObj ) {
         pMethod = hb_dynsymFindName( data );
         if( pMethod ){
            hb_vmPushSymbol( hb_dynsymSymbol( pMethod ) );     // Coloca simbolo en la pila
            hb_vmPush( pObj );                            // Coloca objeto en pila.
            hb_vmPush( pObj );                            // oSender
            hb_vmSend( 1 );                               // LLamada por Send que pasa
         } else {
	  HB_ERRCODE ErrCode = 5002;	  
	  hb_errRT_BASE_Ext1( EG_ARG, ErrCode, GetGErrorMsg( ErrCode, "OnSelection_changed" ), HB_ERR_FUNCNAME, 0, EF_CANDEFAULT, HB_ERR_ARGS_BASEPARAMS );   	   
//           g_print( "Method doesn't %s exist en OnSelection_changed", (gchar *)data );
         }
      }
  }

  // Obtenemos el codeblock de la se�al, data, que debemos evaluar...
  if( pObj == NULL ){
     if( pBlock ) {
        hb_vmPushSymbol( &hb_symEval );
        hb_vmPush( pBlock );
        hb_vmPushPointer( ( GtkList * ) list );
        hb_vmSend( 1 );
     }
  }

}

void OnSwitch_page( GtkNotebook *notebook, GtkNotebookPage *page, guint page_num, gpointer data )
{
  PHB_ITEM pObj = NULL;
  PHB_ITEM pBlock;
  PHB_DYNS pMethod ;

  // comprobamos que no exista definido un codeblock a la se�al.
  pBlock = g_object_get_data( G_OBJECT( notebook ), (gchar*) data );

  if( pBlock == NULL ){
      pObj  = g_object_get_data( G_OBJECT( notebook ), "Self" );
      if( pObj ) {
         pMethod = hb_dynsymFindName( data );
         if( pMethod ){
            hb_vmPushSymbol( hb_dynsymSymbol( pMethod ) ); // Coloca simbolo en la pila
            hb_vmPush( pObj );                             // Coloca objeto en pila.
            hb_vmPush( pObj );                             // oSender
            hb_vmPushPointer( ( GtkNotebookPage * ) page );
            hb_vmPushInteger( page_num );                  // actual page number 
            hb_vmSend( 3 );
         } else {
	  HB_ERRCODE ErrCode = 5002;	  
	  hb_errRT_BASE_Ext1( EG_ARG, ErrCode, GetGErrorMsg( ErrCode, "OnSwitch_page" ), HB_ERR_FUNCNAME, 0, EF_CANDEFAULT, HB_ERR_ARGS_BASEPARAMS );   	   
//           g_print( "Method doesn't %s exist en OnSwitch_page", (gchar *)data );
         }
      }
  }

  // Obtenemos el codeblock de la se�al, data, que debemos evaluar...
  if( pObj == NULL ){
     if( pBlock ) {
        hb_vmPushSymbol( &hb_symEval );
        hb_vmPush( pBlock );
        hb_vmPushPointer( ( GtkNotebook * ) notebook );
        hb_vmPushPointer( ( GtkNotebookPage * ) page );
        hb_vmPushInteger( page_num );                  // numero de pagina actual
        hb_vmSend( 3 );
     }
  }

}

void OnGroup_changed( GtkRadioButton *radiobutton, gpointer data )
{
  PHB_ITEM pObj = NULL;
  PHB_ITEM pBlock;
  PHB_DYNS pMethod ;

  // comprobamos que no exista definido un codeblock a la se�al.
  pBlock = g_object_get_data( G_OBJECT( radiobutton ), (gchar*) data );

  if( pBlock == NULL ){
      pObj  = g_object_get_data( G_OBJECT( radiobutton ), "Self" );
      if( pObj ) {
         pMethod = hb_dynsymFindName( data );
         if( pMethod ){
            hb_vmPushSymbol( hb_dynsymSymbol( pMethod ) );     // Coloca simbolo en la pila
            hb_vmPush( pObj );                            // Coloca objeto en pila.
            hb_vmPush( pObj );                            // oSender
            hb_vmSend( 1 );                               // LLamada por Send que pasa
         } else {
	  HB_ERRCODE ErrCode = 5002;	  
	  hb_errRT_BASE_Ext1( EG_ARG, ErrCode, GetGErrorMsg( ErrCode, "OnGroup_changed" ), HB_ERR_FUNCNAME, 0, EF_CANDEFAULT, HB_ERR_ARGS_BASEPARAMS );   	   
//           g_print( "Method doesn't %s exist en OnGroup_changed", (gchar *)data );
         }
      }
  }

  // Obtenemos el codeblock de la se�al, data, que debemos evaluar...
  if( pObj == NULL ){
     if( pBlock ) {
        hb_vmPushSymbol( &hb_symEval );
        hb_vmPush( pBlock );
        hb_vmPushPointer( ( GtkRadioButton * ) radiobutton );
//        hb_vmPushLong( GPOINTER_TO_UINT( radiobutton ) );
        hb_vmSend( 1 );
     }
  }
}

/* Se�al para GtkCellRendererText <97> Renders text in a cell */
void OnRow_activated( GtkTreeView *treeview, GtkTreePath *path, GtkTreeViewColumn *col, gpointer data  )
{
  PHB_ITEM pObj = NULL;
  PHB_ITEM pBlock;
  PHB_DYNS pMethod ;

  // comprobamos que no exista definido un codeblock a la se�al.
  pBlock = g_object_get_data( G_OBJECT( treeview ), (gchar*) data );

  if( pBlock == NULL ){
      pObj  = g_object_get_data( G_OBJECT( treeview ), "Self" );
      if( pObj ) {
         pMethod = hb_dynsymFindName( data );
         if( pMethod ){
            hb_vmPushSymbol( hb_dynsymSymbol( pMethod ) );     // Coloca simbolo en la pila
            hb_vmPush( pObj );                            // Coloca objeto en pila.
            hb_vmPush( pObj );                            // oSender
            hb_vmPushPointer( ( GtkTreePath * ) path );
            hb_vmPushPointer( ( GtkTreeViewColumn *) col );
            hb_vmSend( 3 );                               // LLamada por Send que pasa
         } else {
	  HB_ERRCODE ErrCode = 5002;	  
	  hb_errRT_BASE_Ext1( EG_ARG, ErrCode, GetGErrorMsg( ErrCode, "OnRow_Activate" ), HB_ERR_FUNCNAME, 0, EF_CANDEFAULT, HB_ERR_ARGS_BASEPARAMS );   	   
//           g_print( "Method doesn't %s exist en OnRow_Activate", (gchar *)data );
         }
      }
  }

  // Obtenemos el codeblock de la se�al, data, que debemos evaluar...
  if( pObj == NULL ){
     if( pBlock ) {
        hb_vmPushSymbol( &hb_symEval );
        hb_vmPush( pBlock );
        hb_vmPushPointer( ( GtkTreeView * ) treeview );
        hb_vmPushPointer( ( GtkTreePath * ) path );
        hb_vmPushPointer( ( GtkTreeViewColumn *) col );        
        hb_vmSend( 3 );
     }
  }

}

void OnCell_toggled( GtkCellRendererToggle *cell_renderer, gchar *path, gpointer data )
{
  PHB_ITEM pObj = NULL;
  PHB_ITEM pBlock;
  PHB_DYNS pMethod ;

  // comprobamos que no exista definido un codeblock a la se�al.
  pBlock = g_object_get_data( G_OBJECT( cell_renderer ), (gchar*) data );

  if( pBlock == NULL ){
      pObj  = g_object_get_data( G_OBJECT( cell_renderer ), "Self" );
      if( pObj ) {
         pMethod = hb_dynsymFindName( data );
         if( pMethod ){
            hb_vmPushSymbol( hb_dynsymSymbol( pMethod ) );     // Coloca simbolo en la pila
            hb_vmPush( pObj );                            // Coloca objeto en pila.
            hb_vmPush( pObj );                            // oSender
            hb_vmPushString( path, strlen( path) );
            hb_vmSend( 2 );                               // LLamada por Send que pasa
         } else {
	  HB_ERRCODE ErrCode = 5002;	  
	  hb_errRT_BASE_Ext1( EG_ARG, ErrCode, GetGErrorMsg( ErrCode, "OnCell_toggled" ), HB_ERR_FUNCNAME, 0, EF_CANDEFAULT, HB_ERR_ARGS_BASEPARAMS );   	   
//           g_print( "Method doesn't %s exist en OnCell_toggled", (gchar *)data );
         }
      }
  }

  // Obtenemos el codeblock de la se�al, data, que debemos evaluar...
  if( pObj == NULL ){
     if( pBlock ) {
        hb_vmPushSymbol( &hb_symEval );
        hb_vmPush( pBlock );
        hb_vmPushPointer( ( GtkCellRendererToggle * ) cell_renderer );
        hb_vmPushString( path, strlen( path) );
        hb_vmSend( 2 );
     }
  }

}

void OnInsert_at_cursor( GtkEntry *entry, gchar *arg1, gpointer data )
{
  PHB_ITEM pObj = NULL;
  PHB_ITEM pBlock;
  PHB_DYNS pMethod ;

  // comprobamos que no exista definido un codeblock a la se�al.
  pBlock = g_object_get_data( G_OBJECT( entry ), (gchar*) data );

  if( pBlock == NULL ){
      pObj  = g_object_get_data( G_OBJECT( entry ), "Self" );
      if( pObj ) {
         pMethod = hb_dynsymFindName( data );
         if( pMethod ){
            hb_vmPushSymbol( hb_dynsymSymbol( pMethod ) );     // Coloca simbolo en la pila
            hb_vmPush( pObj );                            // Coloca objeto en pila.
            hb_vmPush( pObj );                            // oSender
            hb_vmPushString( arg1, strlen( arg1 ) );
            hb_vmSend( 2 );                               // LLamada por Send que pasa
         } else {
	  HB_ERRCODE ErrCode = 5002;	  
	  hb_errRT_BASE_Ext1( EG_ARG, ErrCode, GetGErrorMsg( ErrCode, "OnInsert_At_Cursor" ), HB_ERR_FUNCNAME, 0, EF_CANDEFAULT, HB_ERR_ARGS_BASEPARAMS );   	   
//           g_print( "Method doesn't %s exist en OnInsert_At_Cursor", (gchar *)data );
         }
      }
  }

  // Obtenemos el codeblock de la se�al, data, que debemos evaluar...
  if( pObj == NULL ){
     if( pBlock ) {
        hb_vmPushSymbol( &hb_symEval );
        hb_vmPush( pBlock );
        hb_vmPushPointer( ( GtkEntry * ) entry );
        hb_vmPushString( arg1, strlen( arg1 ) );
        hb_vmSend( 2 );
     }
  }

}

void OnItem_Activated( GtkIconView *iconview, GtkTreePath *arg1, gpointer data )
{
  PHB_ITEM pObj = NULL;
  PHB_ITEM pBlock;
  PHB_DYNS pMethod ;

  // comprobamos que no exista definido un codeblock a la se�al.
  pBlock = g_object_get_data( G_OBJECT( iconview ), (gchar*) data );

  if( pBlock == NULL ){
      pObj  = g_object_get_data( G_OBJECT( iconview ), "Self" );
      if( pObj ) {
         pMethod = hb_dynsymFindName( data );
         if( pMethod ){
            hb_vmPushSymbol( hb_dynsymSymbol( pMethod ) );     // Coloca simbolo en la pila
            hb_vmPush( pObj );                            // Coloca objeto en pila.
            hb_vmPush( pObj );                            // oSender
            hb_vmPushPointer( ( GtkTreePath * ) arg1 );        
            hb_vmSend( 2 );                               // LLamada por Send que pasa
         } else {
	  HB_ERRCODE ErrCode = 5002;	  
	  hb_errRT_BASE_Ext1( EG_ARG, ErrCode, GetGErrorMsg( ErrCode, "OnItem_Activated" ), HB_ERR_FUNCNAME, 0, EF_CANDEFAULT, HB_ERR_ARGS_BASEPARAMS );   	   
//           g_print( "Method doesn't %s exist en OnItem_Activated", (gchar *)data );
         }
      }
  }

  // Obtenemos el codeblock de la se�al, data, que debemos evaluar...
  if( pObj == NULL ){
     if( pBlock ) {
        hb_vmPushSymbol( &hb_symEval );
        hb_vmPush( pBlock );
        hb_vmPushPointer( ( GtkIconView * ) iconview );      
        hb_vmPushPointer( ( GtkTreePath * ) arg1 );
        hb_vmSend( 2 );
     }
  }

}

gboolean OnExpose_Event( GtkWidget *widget, GdkEventExpose *event, gpointer data )
{
  PHB_ITEM pObj = NULL;
  PHB_ITEM pBlock;
  PHB_DYNS pMethod ;

  // comprobamos que no exista definido un codeblock a la se�al.
  pBlock = g_object_get_data( G_OBJECT( widget ), (gchar*) data );

  if( pBlock == NULL ){
      pObj  = g_object_get_data( G_OBJECT( widget ), "Self" );
      if( pObj ) {
         pMethod = hb_dynsymFindName( data );
         if( pMethod ){
            hb_vmPushSymbol( hb_dynsymSymbol( pMethod ) );     // Coloca simbolo en la pila
            hb_vmPush( pObj );                            // Coloca objeto en pila.
            hb_vmPush( pObj );                            // oSender
            hb_vmPushPointer( ( GdkEventExpose * )event  );
            hb_vmSend( 2 );                               // LLamada por Send que pasa
            return( hb_parl( -1 ) );
         } else {
	  HB_ERRCODE ErrCode = 5002;	  
	  hb_errRT_BASE_Ext1( EG_ARG, ErrCode, GetGErrorMsg( ErrCode, "OnExpose_Event" ), HB_ERR_FUNCNAME, 0, EF_CANDEFAULT, HB_ERR_ARGS_BASEPARAMS );   	   
//           g_print( "Method doesn't %s exist en OnExpose_Event", (gchar *)data );
         }
      }
  }

  // Obtenemos el codeblock de la se�al, data, que debemos evaluar...
  if( pObj == NULL ){
     if( pBlock ) {
        hb_vmPushSymbol( &hb_symEval );
        hb_vmPush( pBlock );
        hb_vmPushPointer( ( GtkWidget * ) widget  );
        hb_vmPushPointer( ( GdkEventExpose * )event  );
        hb_vmSend( 2 );
        return( hb_parl( -1 ) );
     }
  }

return FALSE;
}

gboolean OnConfigure_Event( GtkWidget  *widget, GdkEventConfigure *event, gpointer data )
{
  PHB_ITEM pObj = NULL;
  PHB_ITEM pBlock;
  PHB_DYNS pMethod ;

  // comprobamos que no exista definido un codeblock a la se�al.
  pBlock = g_object_get_data( G_OBJECT( widget ), (gchar*) data );

  if( pBlock == NULL ){
      pObj  = g_object_get_data( G_OBJECT( widget ), "Self" );
      if( pObj ) {
         pMethod = hb_dynsymFindName( data );
         if( pMethod ){
            hb_vmPushSymbol( hb_dynsymSymbol( pMethod ) );     // Coloca simbolo en la pila
            hb_vmPush( pObj );                            // Coloca objeto en pila.
            hb_vmPush( pObj );                            // oSender
            hb_vmPushPointer( ( GdkEventConfigure * )event  );
            hb_vmSend( 2 );                               // LLamada por Send que pasa
            return( hb_parl( -1 ) );
         } else {
	  HB_ERRCODE ErrCode = 5002;	  
	  hb_errRT_BASE_Ext1( EG_ARG, ErrCode, GetGErrorMsg( ErrCode, "OnConfigure_Event" ), HB_ERR_FUNCNAME, 0, EF_CANDEFAULT, HB_ERR_ARGS_BASEPARAMS );   
//	   g_print( "Method doesn't %s exist en OnConfigure_Event", (gchar *)data );
         }
      }
  }

  // Obtenemos el codeblock de la se�al, data, que debemos evaluar...
  if( pObj == NULL ){
     if( pBlock ) {
        hb_vmPushSymbol( &hb_symEval );
        hb_vmPush( pBlock );
        hb_vmPushPointer( ( GtkWidget * ) widget  );
        hb_vmPushPointer( ( GdkEventConfigure * )event  );        
        hb_vmSend( 2 );
        return( hb_parl( -1 ) );
     }
  }

return FALSE;
}

void OnCursor_Changed( GtkTreeView *treeview, gpointer data  )
{
  PHB_ITEM pObj = NULL;
  PHB_ITEM pBlock;
  PHB_DYNS pMethod ;

  // comprobamos que no exista definido un codeblock a la se�al.
  pBlock = g_object_get_data( G_OBJECT( treeview ), (gchar*) data );

  if( pBlock == NULL ){
      pObj  = g_object_get_data( G_OBJECT( treeview ), "Self" );
      if( pObj ) {
         pMethod = hb_dynsymFindName( data );
         if( pMethod ){
            hb_vmPushSymbol( hb_dynsymSymbol( pMethod ) );     // Coloca simbolo en la pila
            hb_vmPush( pObj );                            // Coloca objeto en pila.
            hb_vmPush( pObj );                            // oSender
            hb_vmSend( 1 );                               // LLamada por Send que pasa
         } else {
	  HB_ERRCODE ErrCode = 5002;	  
	  hb_errRT_BASE_Ext1( EG_ARG, ErrCode, GetGErrorMsg( ErrCode, "OnCursor_Changed" ), HB_ERR_FUNCNAME, 0, EF_CANDEFAULT, HB_ERR_ARGS_BASEPARAMS );   	   
//           g_print( "Method doesn't %s exist en OnCursor_Changed", (gchar *)data );
         }
      }
  }

  // Obtenemos el codeblock de la se�al, data, que debemos evaluar...
  if( pObj == NULL ){
     if( pBlock ) {
        hb_vmPushSymbol( &hb_symEval );
        hb_vmPush( pBlock );
        hb_vmPushPointer( ( GtkTreeView * ) treeview  );
        hb_vmSend( 1 );
     }
  }
}

void OnMove_Cursor_Tree( GtkTreeView *treeview, GtkMovementStep arg1, gint arg2, gpointer data  )
{
  PHB_ITEM pObj = NULL;
  PHB_ITEM pBlock;
  PHB_DYNS pMethod ;


  // comprobamos que no exista definido un codeblock a la se�al.
  pBlock = g_object_get_data( G_OBJECT( treeview ), (gchar*) data );

  if( pBlock == NULL ){
      pObj  = g_object_get_data( G_OBJECT( treeview ), "Self" );
      if( pObj ) {
         pMethod = hb_dynsymFindName( data );
         if( pMethod ){
            hb_vmPushSymbol( hb_dynsymSymbol( pMethod ) );     // Coloca simbolo en la pila
            hb_vmPush( pObj );                            // Coloca objeto en pila.
            hb_vmPush( pObj );                            // oSender
            hb_vmPushInteger( (gint) arg1 );
            hb_vmPushInteger( (gint) arg2 );
            hb_vmSend( 3 );                               // LLamada por Send que pasa
         } else {
	  HB_ERRCODE ErrCode = 5002;	  
	  hb_errRT_BASE_Ext1( EG_ARG, ErrCode, GetGErrorMsg( ErrCode, "OnMove_Cursor_Tree" ), HB_ERR_FUNCNAME, 0, EF_CANDEFAULT, HB_ERR_ARGS_BASEPARAMS );   	   
//           g_print( "Method doesn't %s exist en OnMove_Cursor_Tree", (gchar *)data );
         }
      }
  }

  // Obtenemos el codeblock de la se�al, data, que debemos evaluar...
  if( pObj == NULL ){
     if( pBlock ) {
        hb_vmPushSymbol( &hb_symEval );
        hb_vmPush( pBlock );
        hb_vmPushPointer( ( GtkTreeView * ) treeview  );
        hb_vmPushInteger( (gint) arg1 );
        hb_vmPushInteger( (gint) arg2 );
        hb_vmSend( 3 );
     }
  }
}

void OnEdited( GtkCellRendererText * cellrenderertext, gchar *arg1, gchar *arg2, gpointer data )
{
  PHB_ITEM pObj = NULL;
  PHB_ITEM pBlock;
  PHB_DYNS pMethod ;

  // comprobamos que no exista definido un codeblock a la se�al.
  pBlock = g_object_get_data( G_OBJECT( cellrenderertext ), (gchar*) data );

  if( pBlock == NULL ){
      pObj  = g_object_get_data( G_OBJECT( cellrenderertext ), "Self" );
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
	  HB_ERRCODE ErrCode = 5002;	  
	  hb_errRT_BASE_Ext1( EG_ARG, ErrCode, GetGErrorMsg( ErrCode, "OnEdited" ), HB_ERR_FUNCNAME, 0, EF_CANDEFAULT, HB_ERR_ARGS_BASEPARAMS );   	   
//           g_print( "Method doesn't %s exist en OnEdited", (gchar *)data );
         }
      }
  }

  // Obtenemos el codeblock de la se�al, data, que debemos evaluar...
  if( pObj == NULL ){
     if( pBlock ) {
        hb_vmPushSymbol( &hb_symEval );
        hb_vmPush( pBlock );
        hb_vmPushPointer( ( GtkCellRendererText * ) cellrenderertext  );
        hb_vmPushString( arg1, strlen( arg1) );
        hb_vmPushString( arg2, strlen( arg2) );
        hb_vmSend( 3 );
     }
  }

}
/* GtkCellRenderer, signal: editing-started */
void OnEditing_started( GtkCellRenderer *renderer, GtkCellEditable *editable,   gchar *path,  gpointer data ) 
{
  PHB_ITEM pObj = NULL;
  PHB_ITEM pBlock;
  PHB_DYNS pMethod ;
  // comprobamos que no exista definido un codeblock a la se�al.
  pBlock = g_object_get_data( G_OBJECT( renderer ), (gchar*) data );
  
  if( pBlock == NULL ){
      pObj  = g_object_get_data( G_OBJECT( renderer ), "Self" );
      if( pObj ) {
         pMethod = hb_dynsymFindName( data );
         if( pMethod ){
            hb_vmPushSymbol( hb_dynsymSymbol( pMethod ) );     // Coloca simbolo en la pila
            hb_vmPush( pObj );                            // Coloca objeto en pila.
            hb_vmPush( pObj );                            // oSender
            hb_vmPushPointer( ( GtkCellRenderer * ) renderer  );
            hb_vmPushPointer( ( GtkCellEditable * ) editable  );
            hb_vmPushString( path, strlen( path ) );
            hb_vmSend( 4 );                               // LLamada por Send que pasa
         } else {
	  HB_ERRCODE ErrCode = 5002;	  
	  hb_errRT_BASE_Ext1( EG_ARG, ErrCode, GetGErrorMsg( ErrCode, "OnEditing_started" ), HB_ERR_FUNCNAME, 0, EF_CANDEFAULT, HB_ERR_ARGS_BASEPARAMS );   
//	   g_print( "Method doesn't %s exist en OnEditing_started", (gchar *)data );
         }
      }
  } 
  // Obtenemos el codeblock de la se�al, data, que debemos evaluar...
  if( pObj == NULL ){
     if( pBlock ) {
        hb_vmPushSymbol( &hb_symEval );
        hb_vmPush( pBlock );
        hb_vmPushPointer( ( GtkCellRenderer * ) renderer  );
        hb_vmPushPointer( ( GtkCellEditable * ) editable  );
        hb_vmPushString( path, strlen( path ) );
        hb_vmSend( 4 );
     }
  }
}
/* GtkCellRenderer, signal: editing-canceled */
void OnEditing_canceled( GtkCellRenderer *renderer, gpointer data ) 
{
  PHB_ITEM pObj = NULL;
  PHB_ITEM pBlock;
  PHB_DYNS pMethod ;
  // comprobamos que no exista definido un codeblock a la se�al.
  pBlock = g_object_get_data( G_OBJECT( renderer ), (gchar*) data );
  
  if( pBlock == NULL ){
      pObj  = g_object_get_data( G_OBJECT( renderer ), "Self" );
      if( pObj ) {
         pMethod = hb_dynsymFindName( data );
         if( pMethod ){
            hb_vmPushSymbol( hb_dynsymSymbol( pMethod ) );     // Coloca simbolo en la pila
            hb_vmPush( pObj );                            // Coloca objeto en pila.
            hb_vmPush( pObj );                            // oSender
            hb_vmSend( 1 );                               // LLamada por Send que pasa
         } else {
	  HB_ERRCODE ErrCode = 5002;	  
	  hb_errRT_BASE_Ext1( EG_ARG, ErrCode, GetGErrorMsg( ErrCode, "OnEditing_canceled" ), HB_ERR_FUNCNAME, 0, EF_CANDEFAULT, HB_ERR_ARGS_BASEPARAMS );   	   
//           g_print( "Method doesn't %s exist en OnEditing_canceled", (gchar *)data );
         }
      }
  } 
  // Obtenemos el codeblock de la se�al, data, que debemos evaluar...
  if( pObj == NULL ){
     if( pBlock ) {
        hb_vmPushSymbol( &hb_symEval );
        hb_vmPush( pBlock );
        hb_vmPushPointer( ( GtkCellRenderer * ) renderer  );
        hb_vmSend( 1 );
     }
  }
}

gboolean OnEnter_Leave_NotifyEvent( GtkWidget *widget, GdkEventCrossing *event, gpointer data )
{
  PHB_ITEM pObj = NULL;
  PHB_ITEM pBlock;
  PHB_DYNS pMethod ;

  // comprobamos que no exista definido un codeblock a la se�al.
  pBlock = g_object_get_data( G_OBJECT( widget ), (gchar*) data );

  if( pBlock == NULL ){
      pObj  = g_object_get_data( G_OBJECT( widget ), "Self" );
      if( pObj ) {
         pMethod = hb_dynsymFindName( data );
         if( pMethod ){
            hb_vmPushSymbol( hb_dynsymSymbol( pMethod ) );     // Coloca simbolo en la pila
            hb_vmPush( pObj );                            // Coloca objeto en pila.
            hb_vmPush( pObj );                            // oSender
            hb_vmPushPointer( ( GdkEventCrossing * ) event );
            hb_vmSend( 2 );                               // LLamada por Send que pasa
            return( hb_parl( -1 ) );
         } else {
	  HB_ERRCODE ErrCode = 5002;	  
	  hb_errRT_BASE_Ext1( EG_ARG, ErrCode, GetGErrorMsg( ErrCode, "OnEnter_Leave_NotifyEvent" ), HB_ERR_FUNCNAME, 0, EF_CANDEFAULT, HB_ERR_ARGS_BASEPARAMS );   	   
//           g_print( "Method doesn't %s exist en OnEnterLeaveNotifyEvent", (gchar *)data );
         }
      }
  }

  // Obtenemos el codeblock de la se�al, data, que debemos evaluar...
  if( pObj == NULL ){
     if( pBlock ) {
        hb_vmPushSymbol( &hb_symEval );
        hb_vmPush( pBlock );
        hb_vmPushPointer( ( GtkWidget * ) widget );
        hb_vmPushPointer( ( GdkEventCrossing * ) event );
        hb_vmSend( 2 );
        return( hb_parl( -1 ) );
     }
  }

  return( FALSE );

}

gboolean OnButton_Press_Event( GtkWidget *widget, GdkEventButton *event, gpointer data )
{
  PHB_ITEM pObj = NULL;
  PHB_ITEM pBlock;
  PHB_DYNS pMethod ;

  // comprobamos que no exista definido un codeblock a la se�al.
  pBlock = g_object_get_data( G_OBJECT( widget ), (gchar*) data );

  if( pBlock == NULL ){
      pObj  = g_object_get_data( G_OBJECT( widget ), "Self" );
      if( pObj ) {
         pMethod = hb_dynsymFindName( data );
         if( pMethod ){
            hb_vmPushSymbol( hb_dynsymSymbol( pMethod ) );     // Coloca simbolo en la pila
            hb_vmPush( pObj );                            // Coloca objeto en pila.
            hb_vmPush( pObj );                            // oSender
            hb_vmPushPointer( ( GdkEventButton * ) event );
            hb_vmSend( 2 );                               // LLamada por Send que pasa
            return( hb_parl( -1 ) );
         } else {
	  HB_ERRCODE ErrCode = 5002;	  
	  hb_errRT_BASE_Ext1( EG_ARG, ErrCode, GetGErrorMsg( ErrCode, "OnButton_Press_Event" ), HB_ERR_FUNCNAME, 0, EF_CANDEFAULT, HB_ERR_ARGS_BASEPARAMS );   	   
//           g_print( "Method doesn't %s exist en OnButtonPress_ReleaseEvent", (gchar *)data );
         }
      }
  }

  // Obtenemos el codeblock de la se�al, data, que debemos evaluar...
  if( pObj == NULL ){
     if( pBlock ) {
        hb_vmPushSymbol( &hb_symEval );
        hb_vmPush( pBlock );
        hb_vmPushPointer( ( GtkWidget * ) widget );
        hb_vmPushPointer( ( GdkEventButton * ) event );
        hb_vmSend( 2 );
        return( hb_parl( -1 ) );
     }
  }
  return( FALSE );
}

gboolean OnCan_Activate_Accel( GtkWidget *widget, guint signal_id, gpointer data )
{
  PHB_ITEM pObj = NULL;
  PHB_ITEM pBlock;
  PHB_DYNS pMethod ;

  // comprobamos que no exista definido un codeblock a la se�al.
  pBlock = g_object_get_data( G_OBJECT( widget ), (gchar*) data );

  if( pBlock == NULL ){
      pObj  = g_object_get_data( G_OBJECT( widget ), "Self" );
      if( pObj ) {
         pMethod = hb_dynsymFindName( data );
         if( pMethod ){
            hb_vmPushSymbol( hb_dynsymSymbol( pMethod ) );     // Coloca simbolo en la pila
            hb_vmPush( pObj );                            // Coloca objeto en pila.
            hb_vmPush( pObj );                            // oSender
            hb_vmPushInteger( (guint) signal_id );
            hb_vmSend( 2 );                               // LLamada por Send que pasa
            return( hb_parl( -1 ) );
         } else {
	  HB_ERRCODE ErrCode = 5002;	  
	  hb_errRT_BASE_Ext1( EG_ARG, ErrCode, GetGErrorMsg( ErrCode, "OnCan_Activate_Accel" ), HB_ERR_FUNCNAME, 0, EF_CANDEFAULT, HB_ERR_ARGS_BASEPARAMS );   	   
//           g_print( "Method doesn't %s exist en OnCan_Activate_Accel", (gchar *)data );
         }
      }
  }

  // Obtenemos el codeblock de la se�al, data, que debemos evaluar...
  if( pObj == NULL ){
     if( pBlock ) {
        hb_vmPushSymbol( &hb_symEval );
        hb_vmPush( pBlock );
        hb_vmPushPointer( ( GtkWidget * ) widget );
        hb_vmPushInteger( (guint) signal_id );
        hb_vmSend( 2 );
        return( hb_parl( -1 ) );
     }
  }

  return( FALSE );
}

void OnChild_Notify( GtkWidget *widget, GParamSpec *pspec, gpointer data )
{
  PHB_ITEM pObj = NULL;
  PHB_ITEM pBlock;
  PHB_DYNS pMethod ;

  // comprobamos que no exista definido un codeblock a la se�al.
  pBlock = g_object_get_data( G_OBJECT( widget ), (gchar*) data );

  if( pBlock == NULL ){
      pObj  = g_object_get_data( G_OBJECT( widget ), "Self" );
      if( pObj ) {
         pMethod = hb_dynsymFindName( data );
         if( pMethod ){
            hb_vmPushSymbol( hb_dynsymSymbol( pMethod ) );     // Coloca simbolo en la pila
            hb_vmPush( pObj );                            // Coloca objeto en pila.
            hb_vmPush( pObj );                            // oSender
            hb_vmPushPointer( ( GParamSpec * ) pspec );
            hb_vmSend( 2 );                               // LLamada por Send que pasa
         } else {
	  HB_ERRCODE ErrCode = 5002;	  
	  hb_errRT_BASE_Ext1( EG_ARG, ErrCode, GetGErrorMsg( ErrCode, "OnChildNotify" ), HB_ERR_FUNCNAME, 0, EF_CANDEFAULT, HB_ERR_ARGS_BASEPARAMS );   	   
//           g_print( "Method doesn't %s exist en OnChildNotify", (gchar *)data );
         }
      }
  }

  // Obtenemos el codeblock de la se�al, data, que debemos evaluar...
  if( pObj == NULL ){
     if( pBlock ) {
        hb_vmPushSymbol( &hb_symEval );
        hb_vmPush( pBlock );
        hb_vmPushPointer( ( GtkWidget * ) widget );
        hb_vmPushPointer( ( GParamSpec * ) pspec );
        hb_vmSend( 2 );
     }
  }
}

gboolean OnClient_Event( GtkWidget *widget, GdkEventClient *event, gpointer data )
{
  PHB_ITEM pObj = NULL;
  PHB_ITEM pBlock;
  PHB_DYNS pMethod ;

  // comprobamos que no exista definido un codeblock a la se�al.
  pBlock = g_object_get_data( G_OBJECT( widget ), (gchar*) data );

  if( pBlock == NULL ){
      pObj  = g_object_get_data( G_OBJECT( widget ), "Self" );
      if( pObj ) {
         pMethod = hb_dynsymFindName( data );
         if( pMethod ){
            hb_vmPushSymbol( hb_dynsymSymbol( pMethod ) );     // Coloca simbolo en la pila
            hb_vmPush( pObj );                            // Coloca objeto en pila.
            hb_vmPush( pObj );                            // oSender
            hb_vmPushPointer( ( GdkEventClient * ) event );
            hb_vmSend( 2 );                               // LLamada por Send que pasa
            return( hb_parl( -1 ) );
         } else {
	  HB_ERRCODE ErrCode = 5002;	  
	  hb_errRT_BASE_Ext1( EG_ARG, ErrCode, GetGErrorMsg( ErrCode, "OnClient_Event" ), HB_ERR_FUNCNAME, 0, EF_CANDEFAULT, HB_ERR_ARGS_BASEPARAMS );   	   
//           g_print( "Method doesn't %s exist en OnClientEvent", (gchar *)data );
         }
      }
  }

  // Obtenemos el codeblock de la se�al, data, que debemos evaluar...
  if( pObj == NULL ){
     if( pBlock ) {
        hb_vmPushSymbol( &hb_symEval );
        hb_vmPush( pBlock );
        hb_vmPushPointer( ( GtkWidget * ) widget );
        hb_vmPushPointer( ( GdkEventClient * ) event );
        hb_vmSend( 2 );
        return( hb_parl( -1 ) );
     }
  }
  return( FALSE );
}

void OnDirection_Changed( GtkWidget *widget, GtkTextDirection arg1, gpointer data )
{
  PHB_ITEM pObj = NULL;
  PHB_ITEM pBlock;
  PHB_DYNS pMethod ;

  // comprobamos que no exista definido un codeblock a la se�al.
  pBlock = g_object_get_data( G_OBJECT( widget ), (gchar*) data );

  if( pBlock == NULL ){
      pObj  = g_object_get_data( G_OBJECT( widget ), "Self" );
      if( pObj ) {
         pMethod = hb_dynsymFindName( data );
         if( pMethod ){
            hb_vmPushSymbol( hb_dynsymSymbol( pMethod ) );     // Coloca simbolo en la pila
            hb_vmPush( pObj );                            // Coloca objeto en pila.
            hb_vmPush( pObj );                            // oSender
            hb_vmPushInteger( (gint) arg1 );
            hb_vmSend( 2 );                               // LLamada por Send que pasa
         } else {
	  HB_ERRCODE ErrCode = 5002;	  
	  hb_errRT_BASE_Ext1( EG_ARG, ErrCode, GetGErrorMsg( ErrCode, "OnDirection_Changed" ), HB_ERR_FUNCNAME, 0, EF_CANDEFAULT, HB_ERR_ARGS_BASEPARAMS );   	   
//           g_print( "Method doesn't %s exist en OnDirection_Changed", (gchar *)data );
         }
      }
  }

  // Obtenemos el codeblock de la se�al, data, que debemos evaluar...
  if( pObj == NULL ){
     if( pBlock ) {
        hb_vmPushSymbol( &hb_symEval );
        hb_vmPush( pBlock );
        hb_vmPushPointer( ( GtkWidget * ) widget );
        hb_vmPushInteger( (gint) arg1 );
        hb_vmSend( 2 );
     }
  }

}

gboolean OnFocus( GtkWidget *widget, GtkDirectionType arg1, gpointer data )
{
  PHB_ITEM pObj = NULL;
  PHB_ITEM pBlock;
  PHB_DYNS pMethod ;

  // comprobamos que no exista definido un codeblock a la se�al.
  pBlock = g_object_get_data( G_OBJECT( widget ), (gchar*) data );

  if( pBlock == NULL ){
      pObj  = g_object_get_data( G_OBJECT( widget ), "Self" );
      if( pObj ) {
         pMethod = hb_dynsymFindName( data );
         if( pMethod ){
            hb_vmPushSymbol( hb_dynsymSymbol( pMethod ) );     // Coloca simbolo en la pila
            hb_vmPush( pObj );                            // Coloca objeto en pila.
            hb_vmPush( pObj );                            // oSender
            hb_vmPushInteger( (gint) arg1 );
            hb_vmSend( 2 );                               // LLamada por Send que pasa
            return( hb_parl( -1 ) );
         } else {
	  HB_ERRCODE ErrCode = 5002;	  
	  hb_errRT_BASE_Ext1( EG_ARG, ErrCode, GetGErrorMsg( ErrCode, "OnFocus" ), HB_ERR_FUNCNAME, 0, EF_CANDEFAULT, HB_ERR_ARGS_BASEPARAMS );   	   
//           g_print( "Method doesn't %s exist en OnFocus", (gchar *)data );
         }
      }
  }

  // Obtenemos el codeblock de la se�al, data, que debemos evaluar...
  if( pObj == NULL ){
     if( pBlock ) {
        hb_vmPushSymbol( &hb_symEval );
        hb_vmPush( pBlock );
        hb_vmPushPointer( ( GtkWidget * ) widget );
        hb_vmPushInteger( (gint) arg1 );
        hb_vmSend( 2 );
        return( hb_parl( -1 ) );
     }
  }
  return( FALSE );
}

// Se�ales para GtkContainer
void OnSignals_Container( GtkContainer *container, GtkWidget  *widget, gpointer data )
{
  PHB_ITEM pObj = NULL;
  PHB_ITEM pBlock;
  PHB_DYNS pMethod ;

  // comprobamos que no exista definido un codeblock a la se�al.
  pBlock = g_object_get_data( G_OBJECT( container ), (gchar*) data );

  if( pBlock == NULL ){
      pObj  = g_object_get_data( G_OBJECT( container ), "Self" );
      if( pObj ) {
         pMethod = hb_dynsymFindName( data );
         if( pMethod ){
            hb_vmPushSymbol( hb_dynsymSymbol( pMethod ) );     // Coloca simbolo en la pila
            hb_vmPush( pObj );                            // Coloca objeto en pila.
            hb_vmPush( pObj );                            // oSender
            hb_vmPushPointer( ( GtkWidget * ) widget );
            hb_vmSend( 2 );                               // LLamada por Send que pasa
         } else {
	  HB_ERRCODE ErrCode = 5002;	  
	  hb_errRT_BASE_Ext1( EG_ARG, ErrCode, GetGErrorMsg( ErrCode, "OnSignals_Container" ), HB_ERR_FUNCNAME, 0, EF_CANDEFAULT, HB_ERR_ARGS_BASEPARAMS );   	   
//           g_print( "Method doesn't %s exist en OnSignals_Container", (gchar *)data );
         }
      }
  }

  // Obtenemos el codeblock de la se�al, data, que debemos evaluar...
  if( pObj == NULL ){
     if( pBlock ) {
        hb_vmPushSymbol( &hb_symEval );
        hb_vmPush( pBlock );
        hb_vmPushPointer( ( GtkContainer * ) container );
        hb_vmPushPointer( ( GtkWidget * ) widget );
        hb_vmSend( 2 );
     }
  }

}
// Se�ales para GtkContainer
void OnCheck_Resize( GtkContainer *container, gpointer data )
{
  PHB_ITEM pObj = NULL;
  PHB_ITEM pBlock;
  PHB_DYNS pMethod ;

  // comprobamos que no exista definido un codeblock a la se�al.
  pBlock = g_object_get_data( G_OBJECT( container ), (gchar*) data );

  if( pBlock == NULL ){
      pObj  = g_object_get_data( G_OBJECT( container ), "Self" );
      if( pObj ) {
         pMethod = hb_dynsymFindName( data );
         if( pMethod ){
            hb_vmPushSymbol( hb_dynsymSymbol( pMethod ) );     // Coloca simbolo en la pila
            hb_vmPush( pObj );                            // Coloca objeto en pila.
            hb_vmPush( pObj );                            // oSender
            hb_vmSend( 1 );                               // LLamada por Send que pasa
         } else {
	  HB_ERRCODE ErrCode = 5002;	  
	  hb_errRT_BASE_Ext1( EG_ARG, ErrCode, GetGErrorMsg( ErrCode, "OnCheck_Resize" ), HB_ERR_FUNCNAME, 0, EF_CANDEFAULT, HB_ERR_ARGS_BASEPARAMS );   	   
//            g_print( "Method doesn't %s exist en OnCheck_Resize", (gchar *)data );
         }
      }
  }

  // Obtenemos el codeblock de la se�al, data, que debemos evaluar...
  if( pObj == NULL ){
     if( pBlock ) {
        hb_vmPushSymbol( &hb_symEval );
        hb_vmPush( pBlock );
        hb_vmPushPointer( ( GtkContainer * ) container );
        hb_vmSend( 1 );
     }
  }
}

#if GTK_CHECK_VERSION(2,8,0)
gboolean OnGrab_Broken_Event( GtkWidget *widget, GdkEventGrabBroken *event, gpointer data )
{
  PHB_ITEM pObj = NULL;
  PHB_ITEM pBlock;
  PHB_DYNS pMethod ;

  // comprobamos que no exista definido un codeblock a la se�al.
  pBlock = g_object_get_data( G_OBJECT( widget ), (gchar*) data );

  if( pBlock == NULL ){
      pObj  = g_object_get_data( G_OBJECT( widget ), "Self" );
      if( pObj ) {
         pMethod = hb_dynsymFindName( data );
         if( pMethod ){
            hb_vmPushSymbol( hb_dynsymSymbol( pMethod ) );     // Coloca simbolo en la pila
            hb_vmPush( pObj );                            // Coloca objeto en pila.
            hb_vmPush( pObj );                            // oSender
            hb_vmPushPointer( ( GdkEventGrabBroken * ) event );
            hb_vmSend( 2 );                               // LLamada por Send que pasa
            return( hb_parl( -1 ) );
         } else {
	  HB_ERRCODE ErrCode = 5002;	  
	  hb_errRT_BASE_Ext1( EG_ARG, ErrCode, GetGErrorMsg( ErrCode, "OnGrab_Broken_Event" ), HB_ERR_FUNCNAME, 0, EF_CANDEFAULT, HB_ERR_ARGS_BASEPARAMS );   	   
//            g_print( "Method doesn't %s exist OnGrab_Broken_Event", (gchar *)data );
         }
      }
  }

  // Obtenemos el codeblock de la se�al, data, que debemos evaluar...
  if( pObj == NULL ){
     if( pBlock ) {
        hb_vmPushSymbol( &hb_symEval );
        hb_vmPush( pBlock );
        hb_vmPushPointer( ( GtkWidget * ) widget );
        hb_vmPushPointer( ( GdkEventGrabBroken * ) event );
        hb_vmSend( 2 );
        return( hb_parl( -1 ) );
     }
  }
  return( FALSE );  // Salimos
}
#endif


void OnGrab_Notify( GtkWidget *widget, gboolean arg1, gpointer data )
{
  PHB_ITEM pObj = NULL;
  PHB_ITEM pBlock;
  PHB_DYNS pMethod ;

  // comprobamos que no exista definido un codeblock a la se�al.
  pBlock = g_object_get_data( G_OBJECT( widget ), (gchar*) data );

  if( pBlock == NULL ){
      pObj  = g_object_get_data( G_OBJECT( widget ), "Self" );
      if( pObj ) {
         pMethod = hb_dynsymFindName( data );
         if( pMethod ){
            hb_vmPushSymbol( hb_dynsymSymbol( pMethod ) );     // Coloca simbolo en la pila
            hb_vmPush( pObj );                            // Coloca objeto en pila.
            hb_vmPush( pObj );                            // oSender
            hb_vmPushLogical( arg1 );
            hb_vmSend( 2 );                               // LLamada por Send que pasa
         } else {
	  HB_ERRCODE ErrCode = 5002;	  
	  hb_errRT_BASE_Ext1( EG_ARG, ErrCode, GetGErrorMsg( ErrCode, "OnGrab_Notify" ), HB_ERR_FUNCNAME, 0, EF_CANDEFAULT, HB_ERR_ARGS_BASEPARAMS );   	   
//            g_print( "Method doesn't %s exist en OnGrab_Notify", (gchar *)data );
         }
      }
  }

  // Obtenemos el codeblock de la se�al, data, que debemos evaluar...
  if( pObj == NULL ){
     if( pBlock ) {
        hb_vmPushSymbol( &hb_symEval );
        hb_vmPush( pBlock );
        hb_vmPushPointer( ( GtkWidget * ) widget );
        hb_vmPushLogical( arg1 );
        hb_vmSend( 2 );
     }
  }
}

void OnHierarchy_Changed( GtkWidget *widget, GtkWidget *widget2, gpointer data )
{
  PHB_ITEM pObj = NULL;
  PHB_ITEM pBlock;
  PHB_DYNS pMethod ;

  // comprobamos que no exista definido un codeblock a la se�al.
  pBlock = g_object_get_data( G_OBJECT( widget ), (gchar*) data );

  if( pBlock == NULL ){
      pObj  = g_object_get_data( G_OBJECT( widget ), "Self" );
      if( pObj ) {
         pMethod = hb_dynsymFindName( data );
         if( pMethod ){
            hb_vmPushSymbol( hb_dynsymSymbol( pMethod ) );     // Coloca simbolo en la pila
            hb_vmPush( pObj );                                 // Coloca objeto en pila.
            hb_vmPush( pObj );
            hb_vmPushPointer( ( GtkWidget * ) widget2 );
            hb_vmSend( 2 );
         } else {
	  HB_ERRCODE ErrCode = 5002;	  
	  hb_errRT_BASE_Ext1( EG_ARG, ErrCode, GetGErrorMsg( ErrCode, "OnHierarchy_Changed" ), HB_ERR_FUNCNAME, 0, EF_CANDEFAULT, HB_ERR_ARGS_BASEPARAMS );   	   
//           g_print( "Method doesn't %s exist en OnHierarchy_Changed", (gchar *)data );
         }
      }
  }

  // Obtenemos el codeblock de la se�al, data, que debemos evaluar...
  if( pObj == NULL ){
     if( pBlock ) {
        hb_vmPushSymbol( &hb_symEval );
        hb_vmPush( pBlock );
        hb_vmPushPointer( ( GtkWidget * ) widget );
        hb_vmPushPointer( ( GtkWidget * ) widget2 );
        hb_vmSend( 2 );
     }
  }

}

gboolean OnMnemonic_Activate( GtkWidget *widget, gboolean arg1, gpointer data )
{
  PHB_ITEM pObj = NULL;
  PHB_ITEM pBlock;
  PHB_DYNS pMethod ;

  // comprobamos que no exista definido un codeblock a la se�al.
  pBlock = g_object_get_data( G_OBJECT( widget ), (gchar*) data );

  if( pBlock == NULL ){
      pObj  = g_object_get_data( G_OBJECT( widget ), "Self" );
      if( pObj ) {
         pMethod = hb_dynsymFindName( data );
         if( pMethod ){
            hb_vmPushSymbol( hb_dynsymSymbol( pMethod ) );     // Coloca simbolo en la pila
            hb_vmPush( pObj );                            // Coloca objeto en pila.
            hb_vmPush( pObj );                            // oSender
            hb_vmPushLogical( arg1 );
            hb_vmSend( 2 );                               // LLamada por Send que pasa
            return( hb_parl( -1 ) );
         } else {
	  HB_ERRCODE ErrCode = 5002;	  
	  hb_errRT_BASE_Ext1( EG_ARG, ErrCode, GetGErrorMsg( ErrCode, "OnMnemonic_Activate" ), HB_ERR_FUNCNAME, 0, EF_CANDEFAULT, HB_ERR_ARGS_BASEPARAMS );   	   
//           g_print( "Method doesn't %s exist en OnMnemonic_Activate", (gchar *)data );
         }
      }
  }

  // Obtenemos el codeblock de la se�al, data, que debemos evaluar...
  if( pObj == NULL ){
     if( pBlock ) {
        hb_vmPushSymbol( &hb_symEval );
        hb_vmPush( pBlock );
        hb_vmPushPointer( ( GtkWidget * ) widget );
        hb_vmPushLogical( arg1 );
        hb_vmSend( 2 );
        return( hb_parl( -1 ) );
     }
  }
  return( FALSE );
}

gboolean OnMotion_Notify_Event( GtkWidget *widget, GdkEventMotion *event, gpointer data )
{
  PHB_ITEM pObj = NULL;
  PHB_ITEM pBlock;
  PHB_DYNS pMethod ;

  // comprobamos que no exista definido un codeblock a la se�al.
  pBlock = g_object_get_data( G_OBJECT( widget ), (gchar*) data );

  if( pBlock == NULL ){
      pObj  = g_object_get_data( G_OBJECT( widget ), "Self" );
      if( pObj ) {
         pMethod = hb_dynsymFindName( data );
         if( pMethod ){
            hb_vmPushSymbol( hb_dynsymSymbol( pMethod ) );     // Coloca simbolo en la pila
            hb_vmPush( pObj );                            // Coloca objeto en pila.
            hb_vmPush( pObj );                            // oSender
            hb_vmPushPointer( ( GdkEventMotion * ) event );
            hb_vmSend( 2 );                               // LLamada por Send que pasa
            return( hb_parl( -1 ) );
         } else {
	  HB_ERRCODE ErrCode = 5002;	  
	  hb_errRT_BASE_Ext1( EG_ARG, ErrCode, GetGErrorMsg( ErrCode, "OnMotion_Notify_Event" ), HB_ERR_FUNCNAME, 0, EF_CANDEFAULT, HB_ERR_ARGS_BASEPARAMS );   	   
//           g_print( "Method doesn't %s exist en OnMotion_Notify_Event", (gchar *)data );
         }
      }
  }

  // Obtenemos el codeblock de la se�al, data, que debemos evaluar...
  if( pObj == NULL ){
     if( pBlock ) {
        hb_vmPushSymbol( &hb_symEval );
        hb_vmPush( pBlock );
        hb_vmPushPointer( ( GtkWidget * ) widget );  
        hb_vmPushPointer( ( GdkEventMotion * ) event );
        hb_vmSend( 2 );
        return( hb_parl( -1 ) );
     }
  }

  return( FALSE );  // Salimos
}

gboolean OnNo_Expose_Event( GtkWidget *widget, GdkEventNoExpose *event, gpointer data )
{
  PHB_ITEM pObj = NULL;
  PHB_ITEM pBlock;
  PHB_DYNS pMethod ;

  // comprobamos que no exista definido un codeblock a la se�al.
  pBlock = g_object_get_data( G_OBJECT( widget ), (gchar*) data );

  if( pBlock == NULL ){
      pObj  = g_object_get_data( G_OBJECT( widget ), "Self" );
      if( pObj ) {
         pMethod = hb_dynsymFindName( data );
         if( pMethod ){
            hb_vmPushSymbol( hb_dynsymSymbol( pMethod ) );     // Coloca simbolo en la pila
            hb_vmPush( pObj );                            // Coloca objeto en pila.
            hb_vmPush( pObj );                            // oSender
            hb_vmPushPointer( ( GdkEventNoExpose * ) event );
            hb_vmSend( 2 );                               // LLamada por Send que pasa
            return( hb_parl( -1 ) );
         } else {
	  HB_ERRCODE ErrCode = 5002;	  
	  hb_errRT_BASE_Ext1( EG_ARG, ErrCode, GetGErrorMsg( ErrCode, "OnNo_Expose_Event" ), HB_ERR_FUNCNAME, 0, EF_CANDEFAULT, HB_ERR_ARGS_BASEPARAMS );   	   
//           g_print( "Method doesn't %s exist en OnNo_Expose_Event", (gchar *)data );
         }
      }
  }

  // Obtenemos el codeblock de la se�al, data, que debemos evaluar...
  if( pObj == NULL ){
     if( pBlock ) {
        hb_vmPushSymbol( &hb_symEval );
        hb_vmPush( pBlock );
        hb_vmPushPointer( ( GtkWidget * ) widget );
        hb_vmPushPointer( ( GdkEventMotion * ) event );
        hb_vmSend( 2 );
        return( hb_parl( -1 ) );
     }
  }

  return( FALSE );  // Salimos
}

void OnParent_Set( GtkWidget *widget, GtkObject *old_parent, gpointer data )
{
  PHB_ITEM pObj = NULL;
  PHB_ITEM pBlock;
  PHB_DYNS pMethod ;

  // comprobamos que no exista definido un codeblock a la se�al.
  pBlock = g_object_get_data( G_OBJECT( widget ), (gchar*) data );

  if( pBlock == NULL ){
      pObj  = g_object_get_data( G_OBJECT( widget ), "Self" );
      if( pObj ) {
         pMethod = hb_dynsymFindName( data );
         if( pMethod ){
            hb_vmPushSymbol( hb_dynsymSymbol( pMethod ) );     // Coloca simbolo en la pila
            hb_vmPush( pObj );                            // Coloca objeto en pila.
            hb_vmPush( pObj );                            // oSender
            hb_vmPushPointer( ( GtkObject * ) old_parent );
            hb_vmSend( 2 );                               // LLamada por Send que pasa
         } else {
	  HB_ERRCODE ErrCode = 5002;	  
	  hb_errRT_BASE_Ext1( EG_ARG, ErrCode, GetGErrorMsg( ErrCode, "OnParent_Set" ), HB_ERR_FUNCNAME, 0, EF_CANDEFAULT, HB_ERR_ARGS_BASEPARAMS );   	   
//            g_print( "Method doesn't %s exist en OnParent_Set", (gchar *)data );
         }
      }
  }

  // Obtenemos el codeblock de la se�al, data, que debemos evaluar...
  if( pObj == NULL ){
     if( pBlock ) {
        hb_vmPushSymbol( &hb_symEval );
        hb_vmPush( pBlock );
        hb_vmPushPointer( ( GtkWidget * ) widget );
        hb_vmPushPointer( ( GtkObject * ) old_parent );
        hb_vmSend( 2 );
     }
  }
}

gboolean OnProperty_Notify_Event( GtkWidget *widget, GdkEventProperty *event, gpointer data )
{
  PHB_ITEM pObj = NULL;
  PHB_ITEM pBlock;
  PHB_DYNS pMethod ;

  // comprobamos que no exista definido un codeblock a la se�al.
  pBlock = g_object_get_data( G_OBJECT( widget ), (gchar*) data );

  if( pBlock == NULL ){
      pObj  = g_object_get_data( G_OBJECT( widget ), "Self" );
      if( pObj ) {
         pMethod = hb_dynsymFindName( data );
         if( pMethod ){
            hb_vmPushSymbol( hb_dynsymSymbol( pMethod ) );     // Coloca simbolo en la pila
            hb_vmPush( pObj );                            // Coloca objeto en pila.
            hb_vmPush( pObj );                            // oSender
            hb_vmPushPointer( ( GdkEventProperty * ) event );
            hb_vmSend( 2 );                               // LLamada por Send que pasa
            return( hb_parl( -1 ) );
         } else {
	  HB_ERRCODE ErrCode = 5002;	  
	  hb_errRT_BASE_Ext1( EG_ARG, ErrCode, GetGErrorMsg( ErrCode, "OnProperty_Notify_Event" ), HB_ERR_FUNCNAME, 0, EF_CANDEFAULT, HB_ERR_ARGS_BASEPARAMS );   	   
//            g_print( "Method doesn't %s exist en OnProperty_Notify_Event", (gchar *)data );
         }
      }
  }

  // Obtenemos el codeblock de la se�al, data, que debemos evaluar...
  if( pObj == NULL ){
     if( pBlock ) {
        hb_vmPushSymbol( &hb_symEval );
        hb_vmPush( pBlock );
        hb_vmPushPointer( ( GtkWidget * ) widget );
        hb_vmPushPointer( ( GdkEventProperty * ) event );
        hb_vmSend( 2 );
        return( hb_parl( -1 ) );
     }
  }
  return( FALSE );  // Salimos
}

gboolean OnProximity_Event( GtkWidget *widget, GdkEventProximity *event, gpointer data )
{
  PHB_ITEM pObj = NULL;
  PHB_ITEM pBlock;
  PHB_DYNS pMethod ;

  // comprobamos que no exista definido un codeblock a la se�al.
  pBlock = g_object_get_data( G_OBJECT( widget ), (gchar*) data );

  if( pBlock == NULL ){
      pObj  = g_object_get_data( G_OBJECT( widget ), "Self" );
      if( pObj ) {
         pMethod = hb_dynsymFindName( data );
         if( pMethod ){
            hb_vmPushSymbol( hb_dynsymSymbol( pMethod ) );     // Coloca simbolo en la pila
            hb_vmPush( pObj );                            // Coloca objeto en pila.
            hb_vmPush( pObj );                            // oSender
            hb_vmPushPointer( ( GdkEventProximity * ) event );
            hb_vmSend( 2 );                               // LLamada por Send que pasa
            return( hb_parl( -1 ) );
         } else {
	  HB_ERRCODE ErrCode = 5002;	  
	  hb_errRT_BASE_Ext1( EG_ARG, ErrCode, GetGErrorMsg( ErrCode, "OnProximity_Event" ), HB_ERR_FUNCNAME, 0, EF_CANDEFAULT, HB_ERR_ARGS_BASEPARAMS );   	   
//            g_print( "Method doesn't %s exist en OnProximity_Event", (gchar *)data );
         }
      }
  }

  // Obtenemos el codeblock de la se�al, data, que debemos evaluar...
  if( pObj == NULL ){
     if( pBlock ) {
        hb_vmPushSymbol( &hb_symEval );
        hb_vmPush( pBlock );
        hb_vmPushPointer( ( GtkWidget * ) widget );
        hb_vmPushPointer( ( GdkEventProximity * ) event );
        hb_vmSend( 2 );
        return( hb_parl( -1 ) );
     }
  }
  return( FALSE );  // Salimos
}

void OnScreen_Changed( GtkWidget *widget, GdkScreen *arg1, gpointer data )
{
  PHB_ITEM pObj = NULL;
  PHB_ITEM pBlock;
  PHB_DYNS pMethod ;

  // comprobamos que no exista definido un codeblock a la se�al.
  pBlock = g_object_get_data( G_OBJECT( widget ), (gchar*) data );

  if( pBlock == NULL ){
      pObj  = g_object_get_data( G_OBJECT( widget ), "Self" );
      if( pObj ) {
         pMethod = hb_dynsymFindName( data );
         if( pMethod ){
            hb_vmPushSymbol( hb_dynsymSymbol( pMethod ) );     // Coloca simbolo en la pila
            hb_vmPush( pObj );                                 // Coloca objeto en pila.
            hb_vmPush( pObj );                                 // oSender
            hb_vmPushPointer( ( GdkScreen * ) arg1 );
            hb_vmSend( 2 );
         } else {
	  HB_ERRCODE ErrCode = 5002;	  
	  hb_errRT_BASE_Ext1( EG_ARG, ErrCode, GetGErrorMsg( ErrCode, "OnScreen_Changed" ), HB_ERR_FUNCNAME, 0, EF_CANDEFAULT, HB_ERR_ARGS_BASEPARAMS );   	   
//           g_print( "Method doesn't %s exist en OnScreen_Changed", (gchar *)data );
         }
      }
  }

  // Obtenemos el codeblock de la se�al, data, que debemos evaluar...
  if( pObj == NULL ){
     if( pBlock ) {
        hb_vmPushSymbol( &hb_symEval );
        hb_vmPush( pBlock );
        hb_vmPushPointer( ( GtkWidget * ) widget );
        hb_vmPushPointer( ( GdkScreen * ) arg1 );
        hb_vmSend( 2 );
     }
  }
}

gboolean OnScroll_Event( GtkWidget *widget, GdkEventScroll *event, gpointer data )
{
  PHB_ITEM pObj = NULL;
  PHB_ITEM pBlock;
  PHB_DYNS pMethod ;

  // comprobamos que no exista definido un codeblock a la se�al.
  pBlock = g_object_get_data( G_OBJECT( widget ), (gchar*) data );

  if( pBlock == NULL ){
      pObj  = g_object_get_data( G_OBJECT( widget ), "Self" );
      if( pObj ) {
         pMethod = hb_dynsymFindName( data );
         if( pMethod ){
            hb_vmPushSymbol( hb_dynsymSymbol( pMethod ) );     // Coloca simbolo en la pila
            hb_vmPush( pObj );                            // Coloca objeto en pila.
            hb_vmPush( pObj );                            // oSender
            hb_vmPushPointer( ( GdkEventScroll * ) event );
//            hb_vmPushLong( GPOINTER_TO_UINT( event ) );
            hb_vmSend( 2 );                               // LLamada por Send que pasa
            return( hb_parl( -1 ) );
         } else {
	  HB_ERRCODE ErrCode = 5002;	  
	  hb_errRT_BASE_Ext1( EG_ARG, ErrCode, GetGErrorMsg( ErrCode, "OnScroll_Event" ), HB_ERR_FUNCNAME, 0, EF_CANDEFAULT, HB_ERR_ARGS_BASEPARAMS );   	   
//           g_print( "Method doesn't %s exist en OnScroll_Event", (gchar *)data );
         }
      }
  }

  // Obtenemos el codeblock de la se�al, data, que debemos evaluar...
  if( pObj == NULL ){
     if( pBlock ) {
        hb_vmPushSymbol( &hb_symEval );
        hb_vmPush( pBlock );
        hb_vmPushPointer( ( GtkWidget * ) widget );
        hb_vmPushPointer( ( GdkEventScroll * ) event );
        hb_vmSend( 2 );
        return( hb_parl( -1 ) );
     }
  }
  return( FALSE );  // Salimos
}

gboolean OnSelection_Event( GtkWidget *widget, GdkEventSelection *event, gpointer data )
{
  PHB_ITEM pObj = NULL;
  PHB_ITEM pBlock;
  PHB_DYNS pMethod ;

  // comprobamos que no exista definido un codeblock a la se�al.
  pBlock = g_object_get_data( G_OBJECT( widget ), (gchar*) data );

  if( pBlock == NULL ){
      pObj  = g_object_get_data( G_OBJECT( widget ), "Self" );
      if( pObj ) {
         pMethod = hb_dynsymFindName( data );
         if( pMethod ){
            hb_vmPushSymbol( hb_dynsymSymbol( pMethod ) );     // Coloca simbolo en la pila
            hb_vmPush( pObj );                            // Coloca objeto en pila.
            hb_vmPush( pObj );                            // oSender
            hb_vmPushPointer( ( GdkEventSelection * ) event );
            hb_vmSend( 2 );                               // LLamada por Send que pasa
            return( hb_parl( -1 ) );
         } else {
	  HB_ERRCODE ErrCode = 5002;	  
	  hb_errRT_BASE_Ext1( EG_ARG, ErrCode, GetGErrorMsg( ErrCode, "OnSelection_Event" ), HB_ERR_FUNCNAME, 0, EF_CANDEFAULT, HB_ERR_ARGS_BASEPARAMS );   	   
//            g_print( "Method doesn't %s exist en OnSelection_Event", (gchar *)data );
         }
      }
  }

  // Obtenemos el codeblock de la se�al, data, que debemos evaluar...
  if( pObj == NULL ){
     if( pBlock ) {
        hb_vmPushSymbol( &hb_symEval );
        hb_vmPush( pBlock );
        hb_vmPushPointer( ( GtkWidget * ) widget );
        hb_vmPushPointer( ( GdkEventSelection * ) event );
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
        hb_vmPushPointer( ( GtkSelectionData * ) selection_data );
        hb_vmPushInteger( (gint) info );
        hb_vmPushInteger( (gint) time );
        hb_vmSend( 4 );                              // LLamada por Send
        return( hb_parl( -1 ) );
     } else {
	  HB_ERRCODE ErrCode = 5002;	  
	  hb_errRT_BASE_Ext1( EG_ARG, ErrCode, GetGErrorMsg( ErrCode, "OnSelection_Get" ), HB_ERR_FUNCNAME, 0, EF_CANDEFAULT, HB_ERR_ARGS_BASEPARAMS );          
//        g_print( "Method doesn't exist OnSelection_Event" );
     }
  }

  // Obtenemos el codeblock de la se�al, data, que debemos evaluar...
  if( pObj == NULL ){
     pBlock = g_object_get_data( G_OBJECT( widget ), (gchar*) data );
     if( pBlock ) {
        hb_vmPushSymbol( &hb_symEval );
        hb_vmPush( pBlock );
        hb_vmPushPointer( ( GtkWidget * ) widget );
        hb_vmPushPointer( ( GtkSelectionData * ) selection_data );
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
        hb_vmPushPointer( ( GtkSelectionData * ) selection_data );
        hb_vmPushInteger( (gint) time );
        hb_vmSend( 3 );                              // LLamada por Send
        return( hb_parl( -1 ) );
     } else {
	  HB_ERRCODE ErrCode = 5002;	  
	  hb_errRT_BASE_Ext1( EG_ARG, ErrCode, GetGErrorMsg( ErrCode, "OnSelection_Received" ), HB_ERR_FUNCNAME, 0, EF_CANDEFAULT, HB_ERR_ARGS_BASEPARAMS );   
//       g_print( "Method doesn't exist OnSelection_Received" );
     }
  }

  // Obtenemos el codeblock de la se�al, data, que debemos evaluar...
  if( pObj == NULL ){
     pBlock = g_object_get_data( G_OBJECT( widget ), (gchar*) data );
     if( pBlock ) {
        hb_vmPushSymbol( &hb_symEval );
        hb_vmPush( pBlock );
        hb_vmPushPointer( ( GtkWidget * ) widget );
        hb_vmPushPointer( ( GtkSelectionData * ) selection_data );
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
	  HB_ERRCODE ErrCode = 5002;	  
	  hb_errRT_BASE_Ext1( EG_ARG, ErrCode, GetGErrorMsg( ErrCode, "OnShow_Help" ), HB_ERR_FUNCNAME, 0, EF_CANDEFAULT, HB_ERR_ARGS_BASEPARAMS );          
//        g_print( "Method doesn't exist OnShow_Help" );
     }
  }

  // Obtenemos el codeblock de la se�al, data, que debemos evaluar...
  if( pObj == NULL ){
     pBlock = g_object_get_data( G_OBJECT( widget ), (gchar*) data );
     if( pBlock ) {
        hb_vmPushSymbol( &hb_symEval );
        hb_vmPush( pBlock );
        hb_vmPushPointer( ( GtkWidget * ) widget );
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
        hb_vmPushPointer( ( GtkAllocation * ) allocation );
        hb_vmSend( 2 );                              // LLamada por Send
     } else {
	  HB_ERRCODE ErrCode = 5002;	  
	  hb_errRT_BASE_Ext1( EG_ARG, ErrCode, GetGErrorMsg( ErrCode, "OnSize_Allocate" ), HB_ERR_FUNCNAME, 0, EF_CANDEFAULT, HB_ERR_ARGS_BASEPARAMS );          
//        g_print( "Method doesn't exist OnSize_Request" );
     }
  }

  // Obtenemos el codeblock de la se�al, data, que debemos evaluar...
  if( pObj == NULL ){
     pBlock = g_object_get_data( G_OBJECT( widget ), (gchar*) data );
     if( pBlock ) {
        hb_vmPushSymbol( &hb_symEval );
        hb_vmPush( pBlock );
        hb_vmPushPointer( ( GtkWidget * ) widget );
        hb_vmPushPointer( ( GtkAllocation * ) allocation );
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
        hb_vmPushPointer( ( GtkRequisition * ) requisition );
        hb_vmSend( 2 );                              // LLamada por Send
     } else {
	  HB_ERRCODE ErrCode = 5002;	  
	  hb_errRT_BASE_Ext1( EG_ARG, ErrCode, GetGErrorMsg( ErrCode, "OnSize_Request" ), HB_ERR_FUNCNAME, 0, EF_CANDEFAULT, HB_ERR_ARGS_BASEPARAMS );          
//        g_print( "Method doesn't exist OnSize_Request" );
     }
  }

  // Obtenemos el codeblock de la se�al, data, que debemos evaluar...
  if( pObj == NULL ){
     pBlock = g_object_get_data( G_OBJECT( widget ), (gchar*) data );
     if( pBlock ) {
        hb_vmPushSymbol( &hb_symEval );
        hb_vmPush( pBlock );
        hb_vmPushPointer( ( GtkWidget * ) widget );
        hb_vmPushPointer( ( GtkRequisition * ) requisition );
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
	  HB_ERRCODE ErrCode = 5002;	  
	  hb_errRT_BASE_Ext1( EG_ARG, ErrCode, GetGErrorMsg( ErrCode, "OnState_Changed" ), HB_ERR_FUNCNAME, 0, EF_CANDEFAULT, HB_ERR_ARGS_BASEPARAMS );          
//        g_print( "Method doesn't exist OnState_Changed" );
     }
  }

  // Obtenemos el codeblock de la se�al, data, que debemos evaluar...
  if( pObj == NULL ){
     pBlock = g_object_get_data( G_OBJECT( widget ), (gchar*) data );
     if( pBlock ) {
        hb_vmPushSymbol( &hb_symEval );
        hb_vmPush( pBlock );
        hb_vmPushPointer( ( GtkWidget * ) widget );
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
        hb_vmPushPointer( ( GtkStyle * ) previous_style );
        hb_vmSend( 2 );                              // LLamada por Send
     } else {
	  HB_ERRCODE ErrCode = 5002;	  
	  hb_errRT_BASE_Ext1( EG_ARG, ErrCode, GetGErrorMsg( ErrCode, "OnStyle_Set" ), HB_ERR_FUNCNAME, 0, EF_CANDEFAULT, HB_ERR_ARGS_BASEPARAMS );          
//        g_print( "Method doesn't exist OnStyle_Set" );
     }
  }

  // Obtenemos el codeblock de la se�al, data, que debemos evaluar...
  if( pObj == NULL ){
     pBlock = g_object_get_data( G_OBJECT( widget ), (gchar*) data );
     if( pBlock ) {
        hb_vmPushSymbol( &hb_symEval );
        hb_vmPush( pBlock );
        hb_vmPushPointer( ( GtkWidget * ) widget );
        hb_vmPushPointer( ( GtkStyle * ) previous_style );
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
        hb_vmPushPointer( ( GdkEventVisibility * ) event );
        hb_vmSend( 2 );                              // LLamada por Send
        return( hb_parl( -1 ) );
     } else {
	  HB_ERRCODE ErrCode = 5002;	  
	  hb_errRT_BASE_Ext1( EG_ARG, ErrCode, GetGErrorMsg( ErrCode, "OnVisibility_Notify_Event" ), HB_ERR_FUNCNAME, 0, EF_CANDEFAULT, HB_ERR_ARGS_BASEPARAMS );          
//        g_print( "Method doesn't exist OnVisibility_Notify_Event" );
     }
  }

  // Obtenemos el codeblock de la se�al, data, que debemos evaluar...
  if( pObj == NULL ){
     pBlock = g_object_get_data( G_OBJECT( widget ), (gchar*) data );
     if( pBlock ) {
        hb_vmPushSymbol( &hb_symEval );
        hb_vmPush( pBlock );
        hb_vmPushPointer( ( GtkWidget * ) widget );
        hb_vmPushPointer( ( GdkEventVisibility * ) event );
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
        hb_vmPushPointer( ( GdkEventWindowState * ) event );
        hb_vmSend( 2 );                              // LLamada por Send
        return( hb_parl( -1 ) );
     } else {
	  HB_ERRCODE ErrCode = 5002;	  
	  hb_errRT_BASE_Ext1( EG_ARG, ErrCode, GetGErrorMsg( ErrCode, "OnWindow_State_Event" ), HB_ERR_FUNCNAME, 0, EF_CANDEFAULT, HB_ERR_ARGS_BASEPARAMS );          
//         g_print( "Method doesn't exist OnWindow_State_Event" );
     }
  }

  // Obtenemos el codeblock de la se�al, data, que debemos evaluar...
  if( pObj == NULL ){
     pBlock = g_object_get_data( G_OBJECT( widget ), (gchar*) data );
     if( pBlock ) {
        hb_vmPushSymbol( &hb_symEval );
        hb_vmPush( pBlock );
        hb_vmPushPointer( ( GtkWidget * ) widget );
        hb_vmPushPointer( ( GdkEventWindowState * ) event );
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
	  HB_ERRCODE ErrCode = 5002;	  
	  hb_errRT_BASE_Ext1( EG_ARG, ErrCode, GetGErrorMsg( ErrCode, "OnMove_Focus" ), HB_ERR_FUNCNAME, 0, EF_CANDEFAULT, HB_ERR_ARGS_BASEPARAMS );          
//        g_print( "Method doesn't exist OnMove_Focus" );
     }
  }

  // Obtenemos el codeblock de la se�al, data, que debemos evaluar...
  if( pObj == NULL ){
     pBlock = g_object_get_data( G_OBJECT( widget ), (gchar*) data );
     if( pBlock ) {
        hb_vmPushSymbol( &hb_symEval );
        hb_vmPush( pBlock );
        hb_vmPushPointer( ( GtkWidget * ) widget );
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
	  HB_ERRCODE ErrCode = 5002;	  
	  hb_errRT_BASE_Ext1( EG_ARG, ErrCode, GetGErrorMsg( ErrCode, "OnCycle_Child_Focus" ), HB_ERR_FUNCNAME, 0, EF_CANDEFAULT, HB_ERR_ARGS_BASEPARAMS );          
//        g_print( "Method doesn't exist OnCycle_Child_Focus" );
     }
  }

  // Obtenemos el codeblock de la se�al, data, que debemos evaluar...
  if( pObj == NULL ){
     pBlock = g_object_get_data( G_OBJECT( widget ), (gchar*) data );
     if( pBlock ) {
        hb_vmPushSymbol( &hb_symEval );
        hb_vmPush( pBlock );
        hb_vmPushPointer( ( GtkWidget * ) widget );
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
	  HB_ERRCODE ErrCode = 5002;	  
	  hb_errRT_BASE_Ext1( EG_ARG, ErrCode, GetGErrorMsg( ErrCode, "OnMove_Handle" ), HB_ERR_FUNCNAME, 0, EF_CANDEFAULT, HB_ERR_ARGS_BASEPARAMS );          
//        g_print( "Method doesn't %s exist en OnMove_Handle ", (gchar *)data ) ;
     }
  }
  // Obtenemos el codeblock de la se�al, data, que debemos evaluar...
  if( pObj == NULL ){
     pBlock = g_object_get_data( G_OBJECT( widget ), (gchar*) data );
     if( pBlock ) {
        hb_vmPushSymbol( &hb_symEval );
        hb_vmPush( pBlock );
        hb_vmPushPointer( ( GtkWidget * ) widget );
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
	  HB_ERRCODE ErrCode = 5002;	  
	  hb_errRT_BASE_Ext1( EG_ARG, ErrCode, GetGErrorMsg( ErrCode, "OnAdjust_Bounds" ), HB_ERR_FUNCNAME, 0, EF_CANDEFAULT, HB_ERR_ARGS_BASEPARAMS );          
//        g_print( "Method doesn't %s exist en OnAdjust_Bounds", (gchar *)data ) ;
     }
  }
  // Obtenemos el codeblock de la se�al, data, que debemos evaluar...
  if( pObj == NULL ){
     pBlock = g_object_get_data( G_OBJECT( widget ), (gchar*) data );
     if( pBlock ) {
        hb_vmPushSymbol( &hb_symEval );
        hb_vmPush( pBlock );
        hb_vmPushPointer( ( GtkWidget * ) widget );
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
	  HB_ERRCODE ErrCode = 5002;	  
	  hb_errRT_BASE_Ext1( EG_ARG, ErrCode, GetGErrorMsg( ErrCode, "OnChange_Value" ), HB_ERR_FUNCNAME, 0, EF_CANDEFAULT, HB_ERR_ARGS_BASEPARAMS );          
//        g_print( "Method doesn't %s exist en OnChange_Value", (gchar *)data ) ;
     }
  }
  // Obtenemos el codeblock de la se�al, data, que debemos evaluar...
  if( pObj == NULL ){
     pBlock = g_object_get_data( G_OBJECT( widget ), (gchar*) data );
     if( pBlock ) {
        hb_vmPushSymbol( &hb_symEval );
        hb_vmPush( pBlock );
        hb_vmPushPointer( ( GtkWidget * ) widget );
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
	  HB_ERRCODE ErrCode = 5002;	  
	  hb_errRT_BASE_Ext1( EG_ARG, ErrCode, GetGErrorMsg( ErrCode, "OnScroll_Child" ), HB_ERR_FUNCNAME, 0, EF_CANDEFAULT, HB_ERR_ARGS_BASEPARAMS );          
//        g_print( "Method doesn't %s exist en OnScroll_Child", (gchar *)data ) ;
     }
  }
  // Obtenemos el codeblock de la se�al, data, que debemos evaluar...
  if( pObj == NULL ){
     pBlock = g_object_get_data( G_OBJECT( widget ), (gchar*) data );
     if( pBlock ) {
        hb_vmPushSymbol( &hb_symEval );
        hb_vmPush( pBlock );
        hb_vmPushPointer( ( GtkWidget * ) widget );
        hb_vmPushInteger( arg1 );                     // GtkScrollType
        hb_vmPushLogical( arg2 );
        hb_vmSend( 3 );                               // LLamada por Send al codeblocks
     }
  }

}

void OnBackspace( GtkEntry *entry, gpointer data )
{
  PHB_ITEM pObj  = g_object_get_data( G_OBJECT( entry ), "Self" );
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
	  HB_ERRCODE ErrCode = 5002;	  
	  hb_errRT_BASE_Ext1( EG_ARG, ErrCode, GetGErrorMsg( ErrCode, "OnBackspace" ), HB_ERR_FUNCNAME, 0, EF_CANDEFAULT, HB_ERR_ARGS_BASEPARAMS );          
//        g_print( "Method doesn't %s exist en OnBackspace ", (gchar *)data );
     }
  }

  // Obtenemos el codeblock de la se�al, data, que debemos evaluar...
  if( pObj == NULL ){
     pBlock = g_object_get_data( G_OBJECT( entry ), (gchar*) data );
     if( pBlock ) {
        hb_vmPushSymbol( &hb_symEval );
        hb_vmPush( pBlock );
        hb_vmPushPointer( ( GtkEntry * ) entry );
        hb_vmSend( 1 );
     }
  }
}

void OnCopy_Clipboard( GtkEntry *entry, gpointer data )
{
  PHB_ITEM pObj  = g_object_get_data( G_OBJECT( entry ), "Self" );
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
	  HB_ERRCODE ErrCode = 5002;	  
	  hb_errRT_BASE_Ext1( EG_ARG, ErrCode, GetGErrorMsg( ErrCode, "OnCopy_Clipboard" ), HB_ERR_FUNCNAME, 0, EF_CANDEFAULT, HB_ERR_ARGS_BASEPARAMS );          
//        g_print( "Method doesn't %s exist en OnCopy_Clipboard ", (gchar *)data );
     }
  }

  // Obtenemos el codeblock de la se�al, data, que debemos evaluar...
  if( pObj == NULL ){
     pBlock = g_object_get_data( G_OBJECT( entry ), (gchar*) data );
     if( pBlock ) {
        hb_vmPushSymbol( &hb_symEval );
        hb_vmPush( pBlock );
        hb_vmPushPointer( ( GtkEntry * ) entry );
        hb_vmSend( 1 );
     }
  }
}

void OnCut_Clipboard( GtkEntry *entry, gpointer data )
{
  PHB_ITEM pObj  = g_object_get_data( G_OBJECT( entry ), "Self" );
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
	  HB_ERRCODE ErrCode = 5002;	  
	  hb_errRT_BASE_Ext1( EG_ARG, ErrCode, GetGErrorMsg( ErrCode, "OnCut_Clipboard" ), HB_ERR_FUNCNAME, 0, EF_CANDEFAULT, HB_ERR_ARGS_BASEPARAMS );          
//        g_print( "Method doesn't %s exist en OnCut_Clipboard ", (gchar *)data );
     }
  }

  // Obtenemos el codeblock de la se�al, data, que debemos evaluar...
  if( pObj == NULL ){
     pBlock = g_object_get_data( G_OBJECT( entry ), (gchar*) data );
     if( pBlock ) {
        hb_vmPushSymbol( &hb_symEval );
        hb_vmPush( pBlock );
        hb_vmPushPointer( ( GtkEntry * ) entry );
        hb_vmSend( 1 );
     }
  }
}

void OnDelete_From_Cursor( GtkEntry *entry, GtkDeleteType arg1, gint arg2, gpointer data )
{
  PHB_ITEM pObj  = g_object_get_data( G_OBJECT( entry ), "Self" );
  PHB_ITEM pBlock;
  PHB_DYNS pMethod;

  if( pObj ) {
     pMethod = hb_dynsymFindName( data );
     if( pMethod ){
        hb_vmPushSymbol( hb_dynsymSymbol( pMethod ) );     // Coloca simbolo en la pila
        hb_vmPush( pObj );                            	   // Coloca objeto en pila.
        hb_vmPush( pObj );                            	   // Dato a pasar
        hb_vmPushInteger( (GtkDeleteType) arg1 );                   // GtkDeleteType
        hb_vmPushInteger( (gint) arg2 );                   	   // none
        hb_vmSend( 3 );                               	   // LLamada por Send
     } else {
	  HB_ERRCODE ErrCode = 5002;	  
	  hb_errRT_BASE_Ext1( EG_ARG, ErrCode, GetGErrorMsg( ErrCode, "OnDelete_From_Cursor" ), HB_ERR_FUNCNAME, 0, EF_CANDEFAULT, HB_ERR_ARGS_BASEPARAMS );          
//        g_print( "Method doesn't %s exist en OnDelete_From_Cursor ", (gchar *)data );
     }
  }

  // Obtenemos el codeblock de la se�al, data, que debemos evaluar...
  if( pObj == NULL ){
     pBlock = g_object_get_data( G_OBJECT( entry ), (gchar*) data );
     if( pBlock ) {
        hb_vmPushSymbol( &hb_symEval );
        hb_vmPush( pBlock );
        hb_vmPushPointer( ( GtkEntry * ) entry );
        hb_vmPushInteger( (gint) arg1 );                   // GtkDeleteType
        hb_vmPushInteger( arg2 );                   	   // none
        hb_vmSend( 3 );                               	   // LLamada por Send
     }
  }
}

void OnMove_Cursor( GtkEntry *entry, GtkDeleteType arg1, gint arg2, gboolean arg3, gpointer data )
{
  PHB_ITEM pObj  = g_object_get_data( G_OBJECT( entry ), "Self" );
  PHB_ITEM pBlock;
  PHB_DYNS pMethod;

  if( pObj ) {
     pMethod = hb_dynsymFindName( data );
     if( pMethod ){
        hb_vmPushSymbol( hb_dynsymSymbol( pMethod ) );     // Coloca simbolo en la pila
        hb_vmPush( pObj );                            	   // Coloca objeto en pila.
        hb_vmPush( pObj );                            	   // Dato a pasar
        hb_vmPushInteger( (GtkDeleteType) arg1 );                   // GtkDeleteType
        hb_vmPushInteger( arg2 );                   	   // none
	hb_vmPushLogical( arg3 );
        hb_vmSend( 4 );                               	   // LLamada por Send
     } else {
	  HB_ERRCODE ErrCode = 5002;	  
	  hb_errRT_BASE_Ext1( EG_ARG, ErrCode, GetGErrorMsg( ErrCode, "OnMove_Cursor" ), HB_ERR_FUNCNAME, 0, EF_CANDEFAULT, HB_ERR_ARGS_BASEPARAMS );          
//        g_print( "Method doesn't %s exist en OnDelete_From_Cursor ", (gchar *)data );
     }
  }

  // Obtenemos el codeblock de la se�al, data, que debemos evaluar...
  if( pObj == NULL ){
     pBlock = g_object_get_data( G_OBJECT( entry ), (gchar*) data );
     if( pBlock ) {
        hb_vmPushSymbol( &hb_symEval );
        hb_vmPush( pBlock );
        hb_vmPushPointer( ( GtkEntry * ) entry );
        hb_vmPushInteger( (gint) arg1 );                   // GtkDeleteType
        hb_vmPushInteger( arg2 );
		hb_vmPushLogical( arg3 );
        hb_vmSend( 4 );                               	   // LLamada por Send
     }
  }
}

void OnPaste_Clipboard( GtkEntry *entry, gpointer data )
{
  PHB_ITEM pObj  = g_object_get_data( G_OBJECT( entry ), "Self" );
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
	  HB_ERRCODE ErrCode = 5002;	  
	  hb_errRT_BASE_Ext1( EG_ARG, ErrCode, GetGErrorMsg( ErrCode, "OnPaste_Clipboard" ), HB_ERR_FUNCNAME, 0, EF_CANDEFAULT, HB_ERR_ARGS_BASEPARAMS );          
//        g_print( "Method doesn't %s exist en OnPaste_Clipboard ", (gchar *)data );
     }
  }

  // Obtenemos el codeblock de la se�al, data, que debemos evaluar...
  if( pObj == NULL ){
     pBlock = g_object_get_data( G_OBJECT( entry ), (gchar*) data );
     if( pBlock ) {
        hb_vmPushSymbol( &hb_symEval );
        hb_vmPush( pBlock );
        hb_vmPushPointer( ( GtkEntry * ) entry );
        hb_vmSend( 1 );
     }
  }
}

void OnPopulate_Popup( GtkEntry *entry, GtkMenu *arg1, gpointer data )
{
  PHB_ITEM pObj  = g_object_get_data( G_OBJECT( entry ), "Self" );
  PHB_ITEM pBlock;
  PHB_DYNS pMethod;

  if( pObj ) {
     pMethod = hb_dynsymFindName( data );
     if( pMethod ){
        hb_vmPushSymbol( hb_dynsymSymbol( pMethod ) );     // Coloca simbolo en la pila
        hb_vmPush( pObj );                            	   // Coloca objeto en pila.
        hb_vmPush( pObj );                            	   // Dato a pasar
        hb_vmPushPointer( ( GtkMenu * ) arg1 );
        hb_vmSend( 2 );                               	   // LLamada por Send
     } else {
	  HB_ERRCODE ErrCode = 5002;	  
	  hb_errRT_BASE_Ext1( EG_ARG, ErrCode, GetGErrorMsg( ErrCode, "OnPopulate_Popup" ), HB_ERR_FUNCNAME, 0, EF_CANDEFAULT, HB_ERR_ARGS_BASEPARAMS );          
//        g_print( "Method doesn't %s exist en OnPopulate_Popup ", (gchar *)data );
     }
  }

  // Obtenemos el codeblock de la se�al, data, que debemos evaluar...
  if( pObj == NULL ){
     pBlock = g_object_get_data( G_OBJECT( entry ), (gchar*) data );
     if( pBlock ) {
        hb_vmPushSymbol( &hb_symEval );
        hb_vmPush( pBlock );
        hb_vmPushPointer( ( GtkEntry * ) entry );
        hb_vmPushPointer( ( GtkMenu * ) arg1 );
        hb_vmSend( 2 );                               	   // LLamada por Send
     }
  }
}

void OnToggle_Overwrite( GtkEntry *entry, gpointer data )
{
  PHB_ITEM pObj  = g_object_get_data( G_OBJECT( entry ), "Self" );
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
	  HB_ERRCODE ErrCode = 5002;	  
	  hb_errRT_BASE_Ext1( EG_ARG, ErrCode, GetGErrorMsg( ErrCode, "OnToggle_Overwrite" ), HB_ERR_FUNCNAME, 0, EF_CANDEFAULT, HB_ERR_ARGS_BASEPARAMS );          
//        g_print( "Method doesn't %s exist en OnToggle_Overwrite ", (gchar *)data );
     }
  }

  // Obtenemos el codeblock de la se�al, data, que debemos evaluar...
  if( pObj == NULL ){
     pBlock = g_object_get_data( G_OBJECT( entry ), (gchar*) data );
     if( pBlock ) {
        hb_vmPushSymbol( &hb_symEval );
        hb_vmPush( pBlock );
        hb_vmPushPointer( ( GtkEntry * ) entry );
        hb_vmSend( 1 );
     }
  }
}

#if GTK_CHECK_VERSION(2,10,0)
// gestiona tanto begin-print como end-print
void OnBegin_Print( GtkPrintOperation *operation, GtkPrintContext *context, gpointer data )
{
  PHB_ITEM pObj = NULL;
  PHB_ITEM pBlock;
  PHB_DYNS pMethod ;

  // comprobamos que no exista definido un codeblock a la se�al.
  pBlock = g_object_get_data( G_OBJECT( operation ), (gchar*) data );

  if( pBlock == NULL ){
      pObj  = g_object_get_data( G_OBJECT( operation ), "Self" );
      if( pObj ) {
         pMethod = hb_dynsymFindName( data );
         if( pMethod ){
            hb_vmPushSymbol( hb_dynsymSymbol( pMethod ) );     // Coloca simbolo en la pila
            hb_vmPush( pObj );                            // Coloca objeto en pila.
            hb_vmPush( pObj );                            // oSender
            hb_vmPushPointer( ( GtkPrintContext * ) context );
            hb_vmSend( 2 );                               // LLamada por Send que pasa
         } else {
	  HB_ERRCODE ErrCode = 5002;	  
	  hb_errRT_BASE_Ext1( EG_ARG, ErrCode, GetGErrorMsg( ErrCode, "OnBegin_Print" ), HB_ERR_FUNCNAME, 0, EF_CANDEFAULT, HB_ERR_ARGS_BASEPARAMS );   	   
//           g_print( "Method doesn't %s exist en OnBegin_Print", (gchar *)data );
         }
      }
  }

  // Obtenemos el codeblock de la se�al, data, que debemos evaluar...
  if( pObj == NULL ){
     if( pBlock ) {
        hb_vmPushSymbol( &hb_symEval );
        hb_vmPush( pBlock );
        hb_vmPushPointer( ( GtkPrintOperation * ) operation );
        hb_vmPushPointer( ( GtkPrintContext * ) context );
        hb_vmSend( 2 );
     }
  }
}

void OnDraw_Page( GtkPrintOperation *operation, GtkPrintContext *context, gint page_nr, gpointer data )
{
  PHB_ITEM pObj = NULL;
  PHB_ITEM pBlock;
  PHB_DYNS pMethod ;

  // comprobamos que no exista definido un codeblock a la se�al.
  pBlock = g_object_get_data( G_OBJECT( operation ), (gchar*) data );

  if( pBlock == NULL ){
      pObj  = g_object_get_data( G_OBJECT( operation ), "Self" );
      if( pObj ) {
         pMethod = hb_dynsymFindName( data );
         if( pMethod ){
            hb_vmPushSymbol( hb_dynsymSymbol( pMethod ) );     // Coloca simbolo en la pila
            hb_vmPush( pObj );                            // Coloca objeto en pila.
            hb_vmPush( pObj );                            // oSender
            hb_vmPushPointer( ( GtkPrintContext * ) context );
            hb_vmPushInteger( (gint) page_nr );
            hb_vmSend( 3 );                               // LLamada por Send que pasa
         } else {
	  HB_ERRCODE ErrCode = 5002;	  
	  hb_errRT_BASE_Ext1( EG_ARG, ErrCode, GetGErrorMsg( ErrCode, "OnDraw_Page" ), HB_ERR_FUNCNAME, 0, EF_CANDEFAULT, HB_ERR_ARGS_BASEPARAMS );   	   
//           g_print( "Method doesn't %s exist en OnDraw_Page", (gchar *)data );
         }
      }
  }

  // Obtenemos el codeblock de la se�al, data, que debemos evaluar...
  if( pObj == NULL ){
     if( pBlock ) {
        hb_vmPushSymbol( &hb_symEval );
        hb_vmPush( pBlock );
        hb_vmPushPointer( ( GtkPrintOperation * ) operation );
        hb_vmPushPointer( ( GtkPrintContext * ) context );
        hb_vmPushInteger( (gint) page_nr );
        hb_vmSend( 3 );
     }
  }
}

void OnRequest_Page_Setup(GtkPrintOperation *operation, GtkPrintContext *context, gint page_nr, GtkPageSetup *setup, gpointer data)
{
  PHB_ITEM pObj = NULL;
  PHB_ITEM pBlock;
  PHB_DYNS pMethod ;

  // comprobamos que no exista definido un codeblock a la se�al.
  pBlock = g_object_get_data( G_OBJECT( operation ), (gchar*) data );

  if( pBlock == NULL ){
      pObj  = g_object_get_data( G_OBJECT( operation ), "Self" );
      if( pObj ) {
         pMethod = hb_dynsymFindName( data );
         if( pMethod ){
            hb_vmPushSymbol( hb_dynsymSymbol( pMethod ) );     // Coloca simbolo en la pila
            hb_vmPush( pObj );                            // Coloca objeto en pila.
            hb_vmPush( pObj );                            // oSender
            hb_vmPushPointer( ( GtkPrintContext * ) context );     
            hb_vmPushInteger( (gint) page_nr );
            hb_vmPushPointer( ( GtkPageSetup * ) setup );
            hb_vmSend( 4 );                               // LLamada por Send que pasa
         } else {
	  HB_ERRCODE ErrCode = 5002;	  
	  hb_errRT_BASE_Ext1( EG_ARG, ErrCode, GetGErrorMsg( ErrCode, "OnRequest_Page_Setup" ), HB_ERR_FUNCNAME, 0, EF_CANDEFAULT, HB_ERR_ARGS_BASEPARAMS );   	   
//           g_print( "Method doesn't %s exist en OnRequest_Page_Setup", (gchar *)data );
         }
      }
  }

  // Obtenemos el codeblock de la se�al, data, que debemos evaluar...
  if( pObj == NULL ){
     if( pBlock ) {
        hb_vmPushSymbol( &hb_symEval );
        hb_vmPush( pBlock );
        hb_vmPushPointer( ( GtkPrintOperation * ) operation );
        hb_vmPushPointer( ( GtkPrintContext * ) context );
        hb_vmPushInteger( (gint) page_nr );
        hb_vmPushPointer( ( GtkPageSetup * ) setup );
        hb_vmSend( 4 );
     }
  }
}

gboolean OnPaginate( GtkPrintOperation *operation, GtkPrintContext *context, gpointer data )
{
  PHB_ITEM pObj = NULL;
  PHB_ITEM pBlock;
  PHB_DYNS pMethod ;

  // comprobamos que no exista definido un codeblock a la se�al.
  pBlock = g_object_get_data( G_OBJECT( operation ), (gchar*) data );

  if( pBlock == NULL ){
      pObj  = g_object_get_data( G_OBJECT( operation ), "Self" );
      if( pObj ) {
         pMethod = hb_dynsymFindName( data );
         if( pMethod ){
            hb_vmPushSymbol( hb_dynsymSymbol( pMethod ) );     // Coloca simbolo en la pila
            hb_vmPush( pObj );                            // Coloca objeto en pila.
            hb_vmPush( pObj );                            // oSender
            hb_vmPushPointer( ( GtkPrintContext * ) context );            
            hb_vmSend( 2 );                               // LLamada por Send que pasa
            return( hb_parl( -1 ) );
         } else {
	  HB_ERRCODE ErrCode = 5002;	  
	  hb_errRT_BASE_Ext1( EG_ARG, ErrCode, GetGErrorMsg( ErrCode, "OnPaginate" ), HB_ERR_FUNCNAME, 0, EF_CANDEFAULT, HB_ERR_ARGS_BASEPARAMS );   	   
//           g_print( "Method doesn't %s exist en OnPaginate", (gchar *)data );
         }
      }
  }

  // Obtenemos el codeblock de la se�al, data, que debemos evaluar...
  if( pObj == NULL ){
     if( pBlock ) {
        hb_vmPushSymbol( &hb_symEval );
        hb_vmPush( pBlock );
        hb_vmPushPointer( ( GtkPrintOperation * ) operation );
        hb_vmPushPointer( ( GtkPrintContext * ) context );            
        hb_vmSend( 2 );
        return( hb_parl( -1 ) );
     }
  }

  return( FALSE );  // Salimos
}

void OnPrepare( GtkAssistant *assistant, GtkWidget * widget, gpointer data)
{
  PHB_ITEM pObj = NULL;
  PHB_ITEM pBlock;
  PHB_DYNS pMethod ;

  // comprobamos que no exista definido un codeblock a la se�al.
  pBlock = g_object_get_data( G_OBJECT( assistant ), (gchar*) data );

  if( pBlock == NULL ){
      pObj  = g_object_get_data( G_OBJECT( assistant ), "Self" );
      if( pObj ) {
         pMethod = hb_dynsymFindName( data );
         if( pMethod ){
            hb_vmPushSymbol( hb_dynsymSymbol( pMethod ) );     // Coloca simbolo en la pila
            hb_vmPush( pObj );                            // Coloca objeto en pila.
            hb_vmPush( pObj );                            // oSender
            hb_vmPushPointer( ( GtkWidget * ) widget );            
            hb_vmSend( 2 );                               // LLamada por Send que pasa
         } else {
	  HB_ERRCODE ErrCode = 5002;	  
	  hb_errRT_BASE_Ext1( EG_ARG, ErrCode, GetGErrorMsg( ErrCode, "OnPrepare" ), HB_ERR_FUNCNAME, 0, EF_CANDEFAULT, HB_ERR_ARGS_BASEPARAMS );   	   
//           g_print( "Method doesn't %s exist en OnPrepare", (gchar *)data );
         }
      }
  }

  // Obtenemos el codeblock de la se�al, data, que debemos evaluar...
  if( pObj == NULL ){
     if( pBlock ) {
        hb_vmPushSymbol( &hb_symEval );
        hb_vmPush( pBlock );
        hb_vmPushPointer( ( GtkAssistant * ) assistant );
        hb_vmPushPointer( ( GtkWidget * ) widget );
        hb_vmSend( 2 );
     }
  }
}


void OnPopupMenu( GtkStatusIcon *status_icon,
                  guint          button,
                  guint          activate_time,
                  gpointer data)
{
  PHB_ITEM pObj = NULL;
  PHB_ITEM pBlock;
  PHB_DYNS pMethod ;

  // comprobamos que no exista definido un codeblock a la se�al.
  pBlock = g_object_get_data( G_OBJECT( status_icon ), (gchar*) data );

  if( pBlock == NULL ){
      pObj  = g_object_get_data( G_OBJECT( status_icon ), "Self" );
      if( pObj ) {
         pMethod = hb_dynsymFindName( data );
         if( pMethod ){
            hb_vmPushSymbol( hb_dynsymSymbol( pMethod ) );     // Coloca simbolo en la pila
            hb_vmPush( pObj );                            // Coloca objeto en pila.
            hb_vmPush( pObj );                            // oSender
            hb_vmPushInteger( (guint) button );
            hb_vmPushInteger( (guint) activate_time );
            hb_vmSend( 3 );                               // LLamada por Send que pasa
         } else {
	  HB_ERRCODE ErrCode = 5002;	  
	  hb_errRT_BASE_Ext1( EG_ARG, ErrCode, GetGErrorMsg( ErrCode, "OnPopupMenu" ), HB_ERR_FUNCNAME, 0, EF_CANDEFAULT, HB_ERR_ARGS_BASEPARAMS );   	   
//           g_print( "Method doesn't %s exist en OnPopupMenu", (gchar *)data );
         }
      }
  }

  // Obtenemos el codeblock de la se�al, data, que debemos evaluar...
  if( pObj == NULL ){
     if( pBlock ) {
        hb_vmPushSymbol( &hb_symEval );
        hb_vmPush( pBlock );
        hb_vmPushPointer( ( GtkStatusIcon * ) status_icon );
        hb_vmPushInteger( (guint) button );
        hb_vmPushInteger( (guint) activate_time );
        hb_vmSend( 3 );
     }
  }
}
                           
#endif

gboolean OnMatch_Selected ( GtkEntryCompletion *widget, GtkTreeModel *model, GtkTreeIter *iter, gpointer data )
{
  PHB_ITEM pObj = NULL;
  PHB_ITEM pBlock;
  PHB_DYNS pMethod ;

  // comprobamos que no exista definido un codeblock a la se�al.
  pBlock = g_object_get_data( G_OBJECT( widget ), (gchar*) data );

  if( pBlock == NULL ){
      pObj  = g_object_get_data( G_OBJECT( widget ), "Self" );
      if( pObj ) {
         pMethod = hb_dynsymFindName( data );
         if( pMethod ){
            hb_vmPushSymbol( hb_dynsymSymbol( pMethod ) );     // Coloca simbolo en la pila
            hb_vmPush( pObj );                            // Coloca objeto en pila.
            hb_vmPush( pObj );                            // oSender
            hb_vmPushPointer( ( GtkTreeModel * ) model );
            //hb_vmPushPointer( ( GtkTreeIter *) iter );
            hb_vmPush( Iter2Array( (GtkTreeIter *) iter ) ); // Enviamos el array, no el puntero
            hb_vmSend( 3 );                               // LLamada por Send que pasa
            return hb_parl( -1 ) ;
         } else {
         HB_ERRCODE ErrCode = 5002;	  
	     hb_errRT_BASE_Ext1( EG_ARG, ErrCode, GetGErrorMsg( ErrCode, "OnMatch_Seleted" ), HB_ERR_FUNCNAME, 0, EF_CANDEFAULT, HB_ERR_ARGS_BASEPARAMS );   	   
//           g_print( "Method doesn't %s exist en OnRow_Activate", (gchar *)data );
         }
      }
  }

  // Obtenemos el codeblock de la se�al, data, que debemos evaluar...
  if( pObj == NULL ){
     if( pBlock ) {
        hb_vmPushSymbol( &hb_symEval );
        hb_vmPush( pBlock );
        hb_vmPushPointer( ( GtkEntryCompletion * ) widget );
        hb_vmPushPointer( ( GtkTreeModel * ) model );
        //hb_vmPushPointer( ( GtkTreeIter *) iter );
        hb_vmPush( Iter2Array( (GtkTreeIter *) iter ) );  // Enviamos el array, no el puntero
        hb_vmSend( 3 );
        return hb_parl( -1 ) ;
     }
  }
  return( FALSE );  // Salimos
}

// Content arrays the signals and Methods
#include "events.h"

//*****************************************************************************************************************
// Liberacion de la memoria directamente.
//*****************************************************************************************************************
gint liberate_block_memory( gpointer data )
{
  /* Debug */
  #ifdef _XHARBOUR_
     g_print("\nLiberando widget %d classname %s \n", GPOINTER_TO_UINT( data ), hb_objGetClsName( data ) );
  #endif

 /** Esto libera memoria **/
 // hb_gcGripDrop( data );
  hb_itemRelease( (PHB_ITEM) data );

  return FALSE;
}


/*
 *  Esto mientras se hace una funcion mas compatible entre Harbour y xHarbour
 */
#ifdef __XHARBOUR__
   #include "events_xhb_signal_connect.h" 
#else
   #include "events_hb_signal_connect.h"
#endif

//eof
