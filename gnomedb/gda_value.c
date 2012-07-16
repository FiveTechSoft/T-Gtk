/* $Id: gda_value.c,v 1.2 2009-03-26 23:34:40 riztan Exp $*/
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

#ifdef _GDA_
#include <glib.h>
#include <glib-object.h>
#include <libgda/libgda.h>


HB_FUNC( GDA_VALUE_NEW_FROM_STRING )
{
   const gchar *cValue = hb_parc( 1 );
   GType type = hb_parnl( 2 );
   GValue *value = gda_value_new_from_string( cValue, type );

   hb_retptr( value );
}


HB_FUNC( GDA_VALUE_FREE )
{
   gda_value_free( (GValue *) hb_parptr( 1 ) );
}


HB_FUNC( GDA_VALUE_STRINGIFY )
{
   const GValue *value = (GValue *) hb_parptr( 1 ) ;
   hb_retc( gda_value_stringify( value ) );
}


HB_FUNC( G_VALUE_HOLDS ) 
{
   const GValue *value = (GValue *) hb_parptr( 1 );
   hb_retl( G_VALUE_HOLDS( value, hb_parni( 2 ) ) );

}


HB_FUNC( G_VALUE_HOLDS_STRING ) 
{
   const GValue *value = (GValue *) hb_parptr( 1 );
   gchar * cType = "";

//   PHB_ITEM cType = hb_itemNew( NULL );
   
   if ( G_VALUE_HOLDS_CHAR(value) )
   {
//      hb_itemPutC(  cType, "CHAR" );
        cType = "CHAR";
   }
   else if ( G_VALUE_HOLDS_UCHAR(value) )
   {
//      hb_itemPutC(  cType, "UCHAR" );
        cType = "UCHAR";
   }
   
   else if ( G_VALUE_HOLDS_BOOLEAN(value) )
   {
//      hb_itemPutC(  cType, "BOOLEAN" );
        cType = "BOOLEAN";
   }
   else if ( G_VALUE_HOLDS_INT(value) || G_VALUE_HOLDS_DOUBLE(value) )
   {
      PHB_ITEM pText = hb_itemNew(NULL);
      
      char * szText = gda_value_stringify(value);
      int iWidth, iDec, iLen = ( int ) pText->item.asString.length;
      BOOL fDbl;
      HB_LONG lValue;
      double dValue;

      fDbl = hb_valStrnToNum( szText, iLen, &lValue, &dValue , &iDec, &iWidth );

      if ( !fDbl )
      {
//         hb_itemPutC(  cType, "INT" );
           cType = "INT";
      }
      else
      {
//         hb_itemPutC(  cType, "DOUBLE" );
           cType = "DOUBLE";
      }

   }
   else if ( G_VALUE_HOLDS_LONG(value) )
   {
//      hb_itemPutC(  cType, "LONG" );
        cType = "LONG";
   }
   else if ( G_VALUE_HOLDS_ULONG(value) )
   {
//      hb_itemPutC(  cType, "ULONG" );
        cType = "ULONG";
   }
   else if ( G_VALUE_HOLDS_INT64(value) )
   {
//      hb_itemPutC(  cType, "INT64" );
        cType = "INT64";
   }
   else if ( G_VALUE_HOLDS_DOUBLE(value) )
   {
//      hb_itemPutC(  cType, "DOUBLE" );
        cType = "DOUBLE";
   }
   else if ( G_VALUE_HOLDS_STRING(value) )  //64
   {
//      hb_itemPutC(  cType, "STRING" );
        cType = "STRING";
   }
   else if ( G_VALUE_HOLDS(value, GDA_TYPE_TIME) )  
   {
//      hb_itemPutC(  cType, "TIME" );
        cType = "TIME";
   }
   else if ( G_VALUE_HOLDS(value, GDA_TYPE_TIMESTAMP) )  
   {
//      hb_itemPutC(  cType, "TIMESTAMP" );
        cType = "TIMESTAMP";
   }
   else
   {
//      hb_itemPutC(  cType, "UNDEFINED" );
        cType = "UNDEFINED";
   }

   hb_retc( cType );

//   hb_itemRelease( cType );

}

#endif
