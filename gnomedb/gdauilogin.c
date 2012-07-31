/* $Id: gdauilogin.c,v 1 2012-07-31 05:17:46 riztan Exp $*/
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
    (c)2012 Riztan Gutierrez <riztan at t-gtk.org>
*/
#include <hbapi.h>

#ifdef _GDA_
#include <gtk/gtk.h>
#include <libgda/libgda.h>
#include <libgda-ui/libgda-ui.h>


HB_FUNC( GDAUI_LOGIN_NEW ) 
{
   GtkWidget * login;
   const gchar *dsn =  hb_parc( 1 );
   login = gdaui_login_new( dsn );

   hb_retptr( login );
}


HB_FUNC( GDAUI_LOGIN_SET_MODE )
{
   GdauiLogin * login = hb_parptr( 1 );
   gint mode = hb_parni( 2 );

   gdaui_login_set_mode( login, mode ); 
}


HB_FUNC( GDAUI_LOGIN_GET_CONNECTION_INFORMATION ) 
{
   const GdaDsnInfo * dsninfo;
   GdauiLogin * login = hb_parptr( 1 );

   dsninfo = gdaui_login_get_connection_information( login ) ;
   hb_retptr( dsninfo );
}


HB_FUNC( GDAUI_LOGIN_SET_DSN ) 
{
   GdauiLogin * login = hb_parptr( 1 );
   const gchar * dsn = hb_parc( 2 );

   gdaui_login_set_dsn( login, dsn );
}



HB_FUNC( GDAUI_LOGIN_SET_DSN_CONNECTION_INFORMATION ) 
{
   GdauiLogin * login = hb_parptr( 1 );
   const GdaDsnInfo * dsninfo = hb_parptr( 2 );

   gdaui_login_set_dsn_connection_informatio( login, dsninfo );
}


#endif

//eof
