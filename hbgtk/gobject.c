/* $Id: gobject.c,v 1.4 2010-10-27 21:39:33 xthefull Exp $*/
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
 * GObject. Tipos GLib, Objetos, Par�metros y Se�ales --------------------
 */

#include <gtk/gtk.h>
#include "hbapi.h"
#include "hbapiitm.h"
#include <t-gtk.h>


HB_FUNC( G_OBJECT_SET )  // object, property_name, value ->void
{
  PHB_ITEM pValue = hb_param( 3, HB_IT_ANY );

  if( HB_IS_STRING( pValue ) )
       g_object_set( (gpointer) hb_parptr( 1 ), (gchar  *) hb_parc( 2 ), hb_parc( 3 ), NULL );
  else if( HB_IS_INTEGER( pValue ) )
       g_object_set( (gpointer) hb_parptr( 1 ), (gchar  *) hb_parc( 2 ), hb_parni( 3 ), NULL );
  else if( HB_IS_LONG( pValue ) )
       g_object_set( (gpointer) hb_parptr( 1 ), (gchar  *) hb_parc( 2 ), hb_parnl( 3 ), NULL );
  else if( HB_IS_DOUBLE( pValue ) )
       g_object_set( (gpointer) hb_parptr( 1 ), (gchar  *) hb_parc( 2 ), hb_parnd( 3 ), NULL );
  else if( HB_IS_LOGICAL( pValue ) )
       g_object_set( (gpointer) hb_parptr( 1 ), (gchar  *) hb_parc( 2 ), hb_parl( 3 ), NULL );
  
}

HB_FUNC( G_OBJECT_SET_VALIST )
{
  PHB_ITEM pArray = hb_param( 2, HB_IT_ARRAY );
  PHB_BASEARRAY pBase;
  gint item, iLen;

  if( ISARRAY( 2 ) )
   {
   pBase = pArray->item.asArray.value;
   
   iLen = hb_arrayLen( pArray );

   for( item = 0; item < iLen; item += 2 )
     {
      if( HB_IS_STRING( pBase->pItems + item+1 ) )
          g_object_set( (gpointer) hb_parptr( 1 ),
                        (pBase->pItems + item)->item.asString.value,
                        (pBase->pItems + item+1)->item.asString.value, NULL );

      else if( HB_IS_INTEGER( pBase->pItems + item+1 ) )
          g_object_set( (gpointer) hb_parptr( 1 ),
                        (pBase->pItems + item)->item.asString.value,
                        (pBase->pItems + item+1)->item.asInteger.value, NULL );

      else if( HB_IS_LONG( pBase->pItems + item+1 ) )
          g_object_set( (gpointer) hb_parptr( 1 ),
                        (pBase->pItems + item)->item.asString.value,
                        (pBase->pItems + item+1)->item.asLong.value, NULL );

      else if( HB_IS_DOUBLE( pBase->pItems + item+1 ) )
          g_object_set( (gpointer) hb_parptr( 1 ),
                        (pBase->pItems + item)->item.asString.value,
                        (pBase->pItems + item+1)->item.asDouble.value, NULL );

      else if( HB_IS_LOGICAL( pBase->pItems + item+1 ) )
          g_object_set( (gpointer) hb_parptr( 1 ),
                        (pBase->pItems + item)->item.asString.value,
                        TRUE, NULL );
     }
   }
   else
      g_warning ("G_OBJECT_SET_VALIST : Se esperaba un array");
}

HB_FUNC( G_OBJECT_UNREF )
{
	GObject * p = ( GObject * ) hb_parptr( 1 );
  if( G_IS_OBJECT( p ) )
     g_object_unref( (gpointer) hb_parptr( 1 ) );
}

HB_FUNC( G_OBJECT_SET_STRING )
{
   gchar * src    = utf82str( ( gchar * ) hb_parc( 3 ) );
   gchar * szDest = str2utf8( src );
   g_object_set ( G_OBJECT( hb_parptr( 1 ) ), hb_parc( 2 ), ( gchar * ) szDest, NULL);
   SAFE_RELEASE( szDest );
   SAFE_RELEASE( src );
}

HB_FUNC( G_OBJECT_SET_INTEGER )
{
    g_object_set ( G_OBJECT( hb_parptr( 1 ) ), hb_parc( 2 ), hb_parni(3), NULL);
}

HB_FUNC( G_OBJECT_SET_LONG )
{
    g_object_set ( G_OBJECT( hb_parptr( 1 ) ), hb_parc( 2 ), hb_parnl(3), NULL);
}

HB_FUNC( G_OBJECT_SET_BOOL )
{
    g_object_set ( G_OBJECT( hb_parptr( 1 ) ), hb_parc( 2 ), hb_parl(3), NULL);
}

HB_FUNC( G_OBJECT_SET_DATA )
{
    g_object_set_data ( G_OBJECT( hb_parptr( 1 ) ), hb_parc( 2 ), (gpointer) hb_parnl( 3 ) );
}


HB_FUNC( G_OBJECT_SET_DATA_FULL )
{
    g_object_set_data_full ( G_OBJECT( hb_parptr( 1 ) ), hb_parc( 2 ), hb_parptr( 3 ), g_object_unref );
}

HB_FUNC( G_OBJECT_GET_POINTER )
{
    hb_retptr( (gpointer) g_object_get_data ( G_OBJECT( hb_parptr( 1 ) ), hb_parc( 2 ) ) );
}


HB_FUNC( G_OBJECT_GET_DATA )
{
    hb_retnl( (glong) g_object_get_data ( G_OBJECT( hb_parptr( 1 ) ), hb_parc( 2 ) ) );
}

HB_FUNC( G_OBJECT_SET_PROPERTY )
{
  gpointer object = G_OBJECT( hb_parptr( 1 ) );
  const gchar *property_name = hb_parc( 2 );
  PHB_ITEM pItem = hb_param(3, HB_IT_ANY );

  
  switch( hb_itemType(pItem) )
  {
    case HB_IT_STRING:
    case HB_IT_MEMO:
      g_object_set(object, property_name, hb_parc(3), NULL);
      break;

    case HB_IT_INTEGER:
      g_object_set(object, property_name, hb_parni(3), NULL);
      break;

    case HB_IT_LONG:
      g_object_set(object, property_name, hb_parnl(3), NULL);
      break;

    case HB_IT_DOUBLE:
      g_object_set(object, property_name, hb_parnd(3), NULL);
      break;

    case HB_IT_POINTER:
      g_object_set(object, property_name, hb_parptr(3), NULL);
      break;

    case HB_IT_LOGICAL:
      g_object_set(object, property_name, hb_parl(3), NULL);
      break;
  }
}

HB_FUNC( GTK_LIST_STORE )
{
 GObject * object = hb_parptr( 1 );
 hb_retptr(  GTK_LIST_STORE( object ) );
}


