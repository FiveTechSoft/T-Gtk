/*
 * $Id: misc.c,v 1.2 2009-03-15 19:40:01 riztan Exp $
 */
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
    (c)2009 Riztan Gutierrez <riztan at gmail.com>
    (c)2009 Alvaro Florez <aflorezd at gmail.com>
*/

#define _CLIPDEFS_H

#include <stdio.h>   /* Standard input/output definitions */
#include <unistd.h>  /* UNIX standard function definitions */
#include <fcntl.h>   /* File control definitions */

#include <stdlib.h>
#include <limits.h>

#include "hbapi.h"
#include "hbapiitm.h"


#define SIZE PIPE_BUF

HB_FUNC( RUN2ME )
{
   FILE *file;
   char *command = hb_parc( 1 );
   char buffer[SIZE];

   PHB_ITEM aRes = hb_itemNew( NULL );
   PHB_ITEM temp  = hb_itemNew( NULL );

   
   file = popen( command, "r" );
   
   while( !feof(file) )
   {
   
      if ( fgets( buffer , 1090 , file ) ) 
      {
      
         hb_itemPutC( temp, buffer );
         hb_arraySetForward( aRes, 1, temp );

         //printf( "%s", buffer ) ;
      } 
   
   }

   hb_itemReturnForward( aTemp );
    
   hb_itemRelease( temp );
   hb_itemRelease( aRes );

   pclose( file );

}


