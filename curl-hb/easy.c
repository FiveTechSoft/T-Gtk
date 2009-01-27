/* $Id: easy.c,v 1.1 2009-01-27 19:34:45 riztan Exp $*/
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

#include <hbapi.h>
#include <hbapiitm.h>

#ifdef _CURL_
#include <curl/curl.h>

HB_FUNC( CURL_EASY_INIT )
{
   CURL *res = NULL;
  
   res = curl_easy_init();
  
   hb_retptr( res );
}


HB_FUNC( CURL_EASY_CLEANUP )
{
   CURL *curl = hb_parptr( 1 );
   curl_easy_cleanup( curl );
}


HB_FUNC( CURL_EASY_DUPHANDLE )
{
   CURL *incurl  = hb_parptr( 1 );
   CURL *outcurl = NULL;
   
   outcurl = curl_easy_duphandle( incurl );
   hb_retptr( outcurl );
}

/*
HB_FUNC( CURL_EASY_GETINFO )
{
   CURL *curl = hb_parptr( 1 );
   CURLINFO info = hb_parni( 2 );

//   CURLcode code = curl_easy_getinfo( curl, info );
   
//   hbret
}
*/


HB_FUNC( CURL_EASY_SETOPT )
{
   CURL *curl = hb_parptr( 1 );
   int option = hb_parni( 2 );

   PHB_ITEM param = hb_param( 3, HB_IT_ANY );

   if (HB_IS_STRING( param ))
   {
      hb_retni( curl_easy_setopt( curl, option , hb_itemGetC( param ) ) );
   }

   else if (HB_IS_INTEGER( param ))
   {

//      if ( option==CURLOPT_WRITEDATA )
//      {
//      FHANDLE hfile = hb_parnl( 3 );
//         FHANDLE hfile = hb_parni( 3 );
//         hb_retni( curl_easy_setopt( curl, option , hfile ) );
//      FILE *fila;
//      fila = fopen("riztancurl.html","w");
      
//      hb_retni( (ULONG) hfile ); 
//      hb_retni( hb_fsFile( hfile ) ) ;
//        hb_retni( curl_easy_setopt( curl, option , fila ) );
//        hb_retnl( hb_fsFile( (BYTE *) param ) );


//      }      
//      else
//      {
         hb_retni( curl_easy_setopt( curl, option , hb_itemGetNI( param ) ) );
//      }

   }

   else if (HB_IS_LOGICAL( param ))
   {
      hb_retni( curl_easy_setopt( curl, option , hb_itemGetL( param ) ) );
   }


   else if (HB_IS_ARRAY( param ))
   {
      ULONG nPos = 0;
      struct curl_slist *list = NULL;
      
         for ( nPos = 1; nPos <= hb_arrayLen( param ); nPos++ )
         {
            curl_slist_append( list, hb_arrayGetC( param, nPos ) );
         }
  
      hb_retni( curl_easy_setopt( curl, option , list ) );
   }


   else if (HB_IS_POINTER( param ))
   {
      hb_retni( curl_easy_setopt( curl, option , hb_itemGetPtr( param ) ) );
   }
   

//   hb_itemRelease( param );
}


HB_FUNC( CURL_EASY_PERFORM )
{
   CURL *curl = hb_parptr( 1 );
   hb_retni( curl_easy_perform(curl) );
}


HB_FUNC( CURL_VERSION )
{
   hb_retc( curl_version() );
}


HB_FUNC( CURL_EASY_STRERROR )
{
   CURLcode errornum = hb_parni( 1 );
   const char *msg = curl_easy_strerror( errornum );

   hb_retc( msg );
}


HB_FUNC( FILE_OPEN )
{
   FILE *arch ;
   arch = fopen( hb_parc( 1 ), "w" );
   
   hb_retptr( arch );
}


HB_FUNC( FILE_CLOSE )
{
   hb_retnl( fclose( hb_parptr( 1 ) ) ); 
}


#endif







