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
    (c)2012 Daniel Garcia-Gil <danielgarciagil at gmail.com>
    (c)2012 Riztan Gutierrez <riztan at gmail.com>
*/


#ifdef _GDA_

#include <hbapi.h>
#include <hbapiitm.h>
#include <hbapierr.h>
#include <libgda/libgda.h>


//-----------------------------------------------------//
static HB_GARBAGE_FUNC( GDAconn_release )
{
   void ** ph = ( void ** ) Cargo;

   /* Check if pointer is not NULL to avoid multiple freeing */
   if( ph && * ph )
   {
      /* Destroy the object */
      gda_connection_close( ( GdaConnection * ) * ph );

      /* set pointer to NULL to avoid multiple freeing */
      * ph = NULL;
   }
}

//-----------------------------------------------------//
#ifndef __XHARBOUR__
static const HB_GC_FUNCS s_gcGDAconnFuncs =
{
   GDAconn_release,
   hb_gcDummyMark
};
#endif
//-----------------------------------------------------//

void hb_GDAconn_ret( GdaConnection * p )
{
   if( p )
   {
#ifndef __XHARBOUR__    
      void ** ph = ( void ** ) hb_gcAllocate( sizeof( GdaConnection * ), &s_gcGDAconnFuncs );
#else
      void ** ph = ( void ** ) hb_gcAlloc( sizeof( GdaConnection * ), GDAconn_release );
#endif //__XHARBOUR__
 
      * ph = p;

      hb_retptrGC( ph );
   }
   else
      hb_retptr( NULL );
}

//-----------------------------------------------------//

GdaConnection * hb_GDAconn_par( int iParam )
{
#ifndef __XHARBOUR__      
   void ** ph = ( void ** ) hb_parptrGC( &s_gcGDAconnFuncs, iParam );
#else
   void ** ph = ( void ** ) hb_parptrGC( GDAconn_release, iParam );
#endif //__XHARBOUR__


   return ph ? ( GdaConnection * ) * ph : NULL;
}



//-----------------------------------------------------//
void hb_GDAprinterr( GError * error, PHB_ITEM pError )
{
   g_printerr ("GDA Error: (%s %d %s=\n",
               g_quark_to_string( error->domain ), error->code, error->message);
   if( pError )
      {
        hb_arrayNew( pError, 3 );
        PHB_ITEM pTemp    = hb_itemNew( NULL );

        hb_itemPutC( pTemp, g_quark_to_string(error->domain) );
        hb_arraySetForward( pError, 1, pTemp);
      
        hb_itemPutNI( pTemp, error->code );
        hb_arraySetForward( pError , 2, pTemp);
      
        hb_itemPutC( pTemp, error->message );
        hb_arraySetForward( pError, 3, pTemp);
      
        hb_itemRelease( pTemp );
      
      }
   g_error_free (error);
}

#endif
//eof 
