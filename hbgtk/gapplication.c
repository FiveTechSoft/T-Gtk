/* $Id: gapplication.c,v 1.8 2022-07-26 01:49:30 riztan Exp $*/
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
    (c)2022 Riztan Gutierrez <riztan@gmail.com>
*/
#include <gtk/gtk.h>
#include "hbapi.h"


HB_FUNC( G_APPLICATION_NEW )
{
   const gchar * application_id = hb_parptr( 1 );
   GApplicationFlags flags      = hb_parni( 2 );
   GApplication * application   = g_application_new( application_id, flags );
   hb_retptr( application );
}


HB_FUNC( G_APPLICATION_ACTIVATE )
{
   GApplication * application = hb_parptr( 1 );
   g_application_activate( application );
}


HB_FUNC( G_APPLICATION_GET_APPLICATION_ID )
{
   GApplication * application = hb_parptr( 1 );
   hb_retc( g_application_get_application_id( application ) );
}


HB_FUNC( G_APPLICATION_RUN )
{
   GApplication * app = hb_parptr( 1 );
   int argc = hb_parni( 2 );
   char ** argv = ( char ** ) hb_parptr( 3 ); //hb_parc( 3 ); 
   hb_retni( g_application_run( app, argc, argv ) );
}


//eof
