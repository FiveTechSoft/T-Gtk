/* $Id: glib.c,v 1.1 2006-09-08 12:18:45 xthefull Exp $*/
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
 * GLib. Soporte para timers.
 */

#include <gtk/gtk.h>
#include "hbapi.h"
#include "hbvm.h"

// Atencion esto esta para mantener compatibilidad con xHarbour anteriores
// Deberá desaparecer , pero lo necesito ahora
#ifdef __OLDHARBOUR__
  HB_EXPORT PHB_SYMB hb_dynsymSymbol( PHB_DYNS pDynSym );
#endif

int time_harbour( gpointer data )
{
 PHB_DYNS pDynSym = hb_dynsymFindName( (gchar *) data );

 if( pDynSym )
   {
    hb_vmPushSymbol( hb_dynsymSymbol( pDynSym ) );     // Coloca simbolo en la pila
    hb_vmPushNil();
    hb_vmDo( 0 );
   }
   else
   {
     g_print( "Method doesn't %s exist en g_timeout_add", (gchar *)data );
     return FALSE;
   }
  return TRUE;

}

HB_FUNC( G_TIMEOUT_ADD ) // milisegundos, funcion
{
  gint interval = hb_parni( 1 );
  gchar * cFunc = hb_parc( 2 );
  hb_retni( g_timeout_add( interval, time_harbour, cFunc ) );
}

HB_FUNC( G_SOURCE_REMOVE )
{
  guint tag = hb_parni( 1 );
  hb_retl( g_source_remove( tag ) );
}
