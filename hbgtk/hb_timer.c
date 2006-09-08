/*
 *  Control de Timers a traves de gLib
 *  Licenciado bajo LGPL
 *
 *  This program is free software; you can redistribute it and/or
 *  modify it under the terms of the GNU Library General Public License
 *  as published by the Free Software Foundation; either version 2 of
 *  the License, or (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU Library General Public License for more details.
 *
 *  You should have received a copy of the GNU Library General Public
 *  License along with this program; if not, write to the Free Software
 *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 *
 *  Authors:
 *    Rafa Carmona( thefull@wanadoo.es )
 *
 *  Copyright 2005 Rafa Carmona
 */

#include <gtk/gtk.h>
#include "hbapi.h"
#include "hbvm.h"

// Atencion esto esta para mantener compatibilidad con xHarbour anteriores
// Deberá desaparecer , pero lo necesito ahora
#ifdef __OLDHARBOUR__
  HB_EXPORT PHB_SYMB hb_dynsymSymbol( PHB_DYNS pDynSym );
#endif

gint __OnTimer( gpointer data )
{
  PHB_DYNS pDynSym = hb_dynsymFindName( "TIMEREVENT" );
  if( pDynSym )
   {
    hb_vmPushSymbol( hb_dynsymSymbol( pDynSym ) );     // Coloca simbolo en la pila
    hb_vmPushNil();
    hb_vmPushString( data, strlen( data ) );
    hb_vmDo( 1 );
    //return( hb_itemGetL( (PHB_ITEM) &hb_stack.Return ) ); Esto ya no es compatible...
    return( hb_parl( -1 ) );  // Esto es lo mismo que lo de arriba, pero compatible de Clipper.
    //return( hb_itemGetL( hb_stackReturnItem() ) );  // Esto es lo mismo que usar hb_parl( -1 )
   }
   else
   {
    return( FALSE );
   }

}

HB_FUNC( TGTK_HB_SETTIMER ) // milisegundos, nId
{
  gint interval = hb_parni( 1 );
  gchar *cStr =  (gchar *) hb_parc( 2 );
  guint nTag;

  nTag = g_timeout_add( interval, __OnTimer, cStr );
  hb_retni( nTag );
}

HB_FUNC( TGTK_HB_DELTIMER ) // nId
{
  guint tag = hb_parni( 1 );
  gboolean lResult ;

  lResult = g_source_remove( tag );
  hb_retl( lResult );
}
