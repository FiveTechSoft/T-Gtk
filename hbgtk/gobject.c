/* $Id: gobject.c,v 1.1 2006-09-08 12:18:45 xthefull Exp $*/
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
 * GObject. Tipos GLib, Objetos, Parámetros y Señales --------------------
 */

#include <gtk/gtk.h>
#include "hbapi.h"

// TODO:Falta el tipo DOUBLE, no consigo entener PORQUE dice tipo incompatible;
//  else if( HB_IS_DOUBLE( pValue ) )
//     value = ( gdouble *) hb_parnd( 3 );

HB_FUNC( G_OBJECT_SET )  // object, property_name, value ->void
{
  PHB_ITEM pValue = hb_param( 3, HB_IT_ANY );
  gpointer value;  //type void * for cast

  if( HB_IS_STRING( pValue ) )
      value = ( gchar *) hb_parc( 3 );
  else if( HB_IS_INTEGER( pValue ) )
      value = ( gint *) hb_parni( 3 );
  else if( HB_IS_LONG( pValue ) )
      value = ( glong *) hb_parnl( 3 );
  else if( HB_IS_DOUBLE( pValue ) ){
       g_object_set( (gpointer) hb_parnl(1), (gchar  *) hb_parc(2), hb_parnd( 3 ), NULL );
	   return ;
	   }
  else if( HB_IS_LOGICAL( pValue ) )
      value = ( gboolean *) hb_parl( 3 );

  g_object_set( (gpointer) hb_parnl(1),
                (gchar  *) hb_parc(2), value, NULL );
}

HB_FUNC( G_OBJECT_SET_VALIST )
{
  PHB_ITEM pArray = hb_param( 2, HB_IT_ARRAY );
  PHB_BASEARRAY pBase;
  gint item, iLen;

  if( ISARRAY( 2 ) )
   {
   pBase = pArray->item.asArray.value;
   iLen  = pBase->ulLen;

   for( item = 0; item < iLen; item += 2 )
     {
      if( HB_IS_STRING( pBase->pItems + item+1 ) )
          g_object_set( (gpointer) hb_parnl(1),
                        (pBase->pItems + item)->item.asString.value,
                        (pBase->pItems + item+1)->item.asString.value, NULL );

      else if( HB_IS_INTEGER( pBase->pItems + item+1 ) )
          g_object_set( (gpointer) hb_parnl(1),
                        (pBase->pItems + item)->item.asString.value,
                        (pBase->pItems + item+1)->item.asInteger.value, NULL );

      else if( HB_IS_LONG( pBase->pItems + item+1 ) )
          g_object_set( (gpointer) hb_parnl(1),
                        (pBase->pItems + item)->item.asString.value,
                        (pBase->pItems + item+1)->item.asLong.value, NULL );

      else if( HB_IS_DOUBLE( pBase->pItems + item+1 ) )
          g_object_set( (gpointer) hb_parnl(1),
                        (pBase->pItems + item)->item.asString.value,
                        (pBase->pItems + item+1)->item.asDouble.value, NULL );

      else if( HB_IS_LOGICAL( pBase->pItems + item+1 ) )
          g_object_set( (gpointer) hb_parnl(1),
                        (pBase->pItems + item)->item.asString.value,
                        TRUE, NULL );
     }
   }
   else
      g_warning ("G_OBJECT_SET_VALIST : Se esperaba un array");
}

HB_FUNC( G_OBJECT_UNREF )
{
  g_object_unref( (gpointer) hb_parnl( 1 ) );
}

HB_FUNC( G_OBJECT_SET_STRING )
{
    g_object_set ( (GObject *) hb_parnl( 1 ), hb_parc( 2 ), hb_parc( 3 ), NULL);
}

HB_FUNC( G_OBJECT_SET_INTEGER )
{
    g_object_set ( (GObject *) hb_parnl( 1 ), hb_parc( 2 ), hb_parni(3), NULL);
}

HB_FUNC( G_OBJECT_SET_LONG )
{
    g_object_set ( (GObject *) hb_parnl( 1 ), hb_parc( 2 ), hb_parnl(3), NULL);
}

HB_FUNC( G_OBJECT_SET_BOOL )
{
    g_object_set ( (GObject *) hb_parnl( 1 ), hb_parc( 2 ), hb_parl(3), NULL);
}

HB_FUNC( G_OBJECT_SET_DATA )
{
    g_object_set_data ( G_OBJECT (hb_parnl(1) ), hb_parc( 2 ), (gpointer) hb_parnl( 3 ) );
}

HB_FUNC( G_OBJECT_GET_DATA )
{
    hb_retnl( (glong) g_object_get_data ( G_OBJECT (hb_parnl(1) ), hb_parc( 2 ) ) );
}



