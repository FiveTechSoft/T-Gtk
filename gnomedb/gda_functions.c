/* $Id: gda_sql_parser.c,v 1.0 2012-07-06 22:40:16 riztan Exp $*/
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
    (c)2012 Rafael Carmona <rafa.tgtk at gmail.com>
    (c)2012 Riztan Gutierrez <riztan at gmail.com>
*/

#ifdef _GDA_

#include <hbapi.h>
#include <hbapiitm.h>
#include <hbapierr.h>

#include <hbvm.h>
#include <hbvmint.h>
#include <hbstack.h>

// Functions LIBGDA
#include <libgda/libgda.h>
#include <hbgda.h>


/* Funcion de prueba... (para eliminar) */
HB_FUNC( EJEMPLO ) 
{
   PHB_ITEM pParam;
   const char *szFunc = hb_parc( 1 );
   HB_ULONG ulPCount = hb_pcount();

   if( szFunc )
   {
      PHB_DYNS pDynSym = hb_dynsymFindName( szFunc );

      if( pDynSym )
      {
         hb_vmPushSymbol( pDynSym->pSymbol );
         hb_vmPushNil();
         if( ulPCount && ulPCount > 1)
         {
            HB_ULONG ulParam;
            HB_TYPE iParamType;
            const char *cValue;

            for( ulParam=2; ulParam <= ulPCount; ulParam++ ){
               pParam = hb_param( ulParam, HB_IT_ANY );
               iParamType = HB_ITEM_TYPE( pParam );

               switch( iParamType ){
               case HB_IT_INTEGER:
                    hb_vmPushInteger( hb_itemGetNI( pParam ) );
                    break;
               case HB_IT_NUMERIC:
                    hb_vmPushInteger( hb_itemGetNI( pParam ) );
                    break;
               case HB_IT_DOUBLE:
                    hb_vmPushDouble( hb_itemGetNI( pParam ), 
                                     hb_stackSetStruct()->HB_SET_DECIMALS );
                    break;
               case HB_IT_STRING:
                    cValue = hb_itemGetC( pParam );
                    hb_vmPushString( cValue, strlen( cValue ) );
                    break;
               case HB_IT_LOGICAL:
                    hb_vmPushLogical( hb_itemGetL( pParam ) );
                    break;
               case HB_IT_DATE:
                    hb_vmPushDate( (long) hb_itemGetDL( pParam ) );
                    //hb_vmPushDate( (long) hb_itemGetNL( pParam ) );
                    break;
//               case HB_IT_DATETIME:
//                    hb_vmPushInteger( hb_itemGetNI( pParam ) );
//                    break;
//               case HB_IT_TIMESTAMP:
//                    hb_vmPushInteger( hb_itemGetNI( pParam ) );
//                    break;
               case HB_IT_NIL:
                    hb_vmPushNil();
                    break;
               }

            }
         }
         hb_vmProc( ( HB_USHORT ) ulPCount-1 );
         //pResult = hb_stackReturnItem();
         hb_stackReturnItem(); 
         //hb_stackPushReturn();
      }
   }

   //hb_retptr( pResult ); 
}


#endif
//oef
