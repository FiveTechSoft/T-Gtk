/* $Id: hb_gda.c,v 1.1 2009-03-15 17:10:16 riztan Exp $*/
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
    (c)2008 Rafael Carmona <rafa.tgtk at gmail.com>
    (c)2008 Riztan Gutierrez <riztan at gmail.com>
*/

// Compatibilidad con HB
#include <hbgda.h>

// Functions LIBGDA
#include <hbapi.h>
#include <hbapiitm.h>

#ifdef _GNOMEDB_
#include <glib.h>
#include <glib-object.h>
#include <libgda/libgda.h>

// --- En desarrollo...  (Riztan)

/* 
 *  Equivalente a gda_data_model_get_value_at
 */

HB_FUNC( HB_GDA_VALUE_ARRAY_AT )
{
   GdaDataModel *model = GDA_DATA_MODEL( hb_parnl( 1 ) );
   gint col = GDA2HB_VECTOR( hb_parni( 2 ) );
   gint row = GDA2HB_VECTOR( hb_parni( 3 ) );
   const GValue *value = NULL;

   PHB_ITEM aValue = hb_itemArrayNew( 3 );
   PHB_ITEM pData = hb_itemNew( NULL );
   PHB_ITEM cType = hb_itemNew( NULL );
   PHB_ITEM nType = hb_itemNew( NULL );
   
   value = gda_data_model_get_value_at( model, col, row );

   if ( G_VALUE_HOLDS_CHAR(value) )
   {
      hb_itemPutC(  pData, gda_value_stringify(value) );
      hb_itemPutC(  cType, "CHAR" );
      hb_itemPutNI( nType, value->g_type );
   }
   else if ( G_VALUE_HOLDS_UCHAR(value) )
   {
      hb_itemPutC(  pData, gda_value_stringify(value) );
      hb_itemPutC(  cType, "UCHAR" );
      hb_itemPutNI( nType, value->g_type );
   }
   
   else if ( G_VALUE_HOLDS_BOOLEAN(value) )
   {
      hb_itemPutC(  pData, gda_value_stringify(value) );
      hb_itemPutC(  cType, "BOOLEAN" );
      hb_itemPutNI( nType, value->g_type );
   }
   else if ( G_VALUE_HOLDS_INT(value) || G_VALUE_HOLDS_DOUBLE(value) )
   {
      hb_itemPutNI( nType, value->g_type );
      
      PHB_ITEM pText = hb_itemNew(NULL);
      
      char * szText = gda_value_stringify(value);
      int iWidth, iDec, iLen = ( int ) pText->item.asString.length;
      BOOL fDbl;
      HB_LONG lValue;
      double dValue;

      fDbl = hb_valStrnToNum( szText, iLen, &lValue, &dValue , &iDec, &iWidth );

      if ( !fDbl )
      {
         hb_itemPutC(  cType, "INT" );
         hb_itemPutNI( pData, lValue );
      }
      else
      {
         hb_itemPutC(  cType, "DOUBLE" );
         hb_itemPutNL( pData, dValue );
      }

   }
   else if ( G_VALUE_HOLDS_LONG(value) )
   {
      hb_itemPutC(  pData, gda_value_stringify(value) );
      hb_itemPutC(  cType, "LONG" );
      hb_itemPutNI( nType, value->g_type );
   }
   else if ( G_VALUE_HOLDS_ULONG(value) )
   {
      hb_itemPutC(  pData, gda_value_stringify(value) );
      hb_itemPutC(  cType, "ULONG" );
      hb_itemPutNI( nType, value->g_type );
   }
   else if ( G_VALUE_HOLDS_INT64(value) )
   {
      hb_itemPutC(  pData, gda_value_stringify(value) );
      hb_itemPutC(  cType, "INT64" );
      hb_itemPutNI( nType, value->g_type );
   }
   else if ( G_VALUE_HOLDS_DOUBLE(value) )
   {
      hb_itemPutC(  pData, gda_value_stringify(value) );
      hb_itemPutC(  cType, "DOUBLE" );
      hb_itemPutNI( nType, value->g_type );
   }
   else if ( G_VALUE_HOLDS_STRING(value) )  //64
   {
      hb_itemPutC(  pData, gda_value_stringify(value) );
      hb_itemPutC(  cType, "STRING" );
      hb_itemPutNI( nType, value->g_type );
   }
   else if ( G_VALUE_HOLDS(value, GDA_TYPE_TIME) )  
   {
      hb_itemPutC(  pData, gda_value_stringify(value) );
      hb_itemPutC(  cType, "TIME" );
      hb_itemPutNI( nType, value->g_type );
   }
   else if ( G_VALUE_HOLDS(value, GDA_TYPE_TIMESTAMP) )  
   {
      hb_itemPutC(  pData, gda_value_stringify(value) );
      hb_itemPutC(  cType, "TIMESTAMP" );
      hb_itemPutNI( nType, value->g_type );
   }
   else
   {
      hb_itemPutC(  pData, g_strdup_value_contents(value) );
      hb_itemPutC(  cType, "UNDEFINED" );
      hb_itemPutNI( nType, 0 );
   }

   hb_arraySet( aValue, 1, pData );
   hb_arraySet( aValue, 2, cType );
   hb_arraySet( aValue, 3, nType );
      
   hb_itemReturnForward( aValue );


   hb_itemRelease( pData );
   hb_itemRelease( cType );
   hb_itemRelease( nType );

   hb_itemRelease( aValue );

}


#endif
