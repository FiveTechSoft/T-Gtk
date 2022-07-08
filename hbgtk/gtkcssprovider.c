/* $Id: gtkcssprovider.c,v 1.0 2022-07-07 19:28:10 riztan Exp $*/
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
#include "t-gtk.h"
#include "hbapierr.h"
#include "gerrapi.h"


HB_FUNC( GTK_CSS_PROVIDER_NEW )
{
   GtkCssProvider * css_provider = gtk_css_provider_new();
   hb_retptr( (GtkCssProvider *) css_provider );
}


HB_FUNC( GTK_CSS_PROVIDER_GET_NAMED )
{
   const gchar * name    = hb_parc( 1 );
   const gchar * variant = hb_parc( 2 );
   hb_retptr( (GtkCssProvider *) gtk_css_provider_get_named( name, variant ) );
}


HB_FUNC( GTK_CSS_PROVIDER_LOAD_FROM_DATA )
{
   GtkCssProvider * css_provider = (GtkCssProvider *) hb_parptr( 1 );
   const gchar * data = hb_parc( 2 );
   gssize length = hb_parni( 3 );
   GError ** error = NULL;
   hb_retl( gtk_css_provider_load_from_data( css_provider, data, length, error ) );
}

/*
HB_FUNC( GTK_CSS_PROVIDER_LOAD_FROM_FILE )
{
   GtkCssProvider * css_provider = (GtkCssProvider *) hb_parptr( 1 );
   const gchar * data = hb_parc( 2 );
   GFile file = hb_parc( 3 );
   GError ** error = NULL;
   hb_retl( gtk_css_provider_load_from_file( css_provider, data, length, error ) );
}
*/


HB_FUNC( GTK_CSS_PROVIDER_LOAD_FROM_PATH )
{
   GtkCssProvider * css_provider = (GtkCssProvider *) hb_parptr( 1 );
   const gchar * path = hb_parc( 2 );
   GError ** error = NULL;
   hb_retl( gtk_css_provider_load_from_path( css_provider, path, error ) );
}


HB_FUNC( GTK_CSS_PROVIDER_LOAD_FROM_RESOURCE )
{
   GtkCssProvider * css_provider = hb_parptr( 1 ) ;
   const gchar * resource_path = hb_parc( 2 );
   gtk_css_provider_load_from_resource( css_provider, resource_path );
}


HB_FUNC( GTK_CSS_PROVIDER_TO_STRING )
{
   GtkCssProvider * css_provider = hb_parptr( 1 );
   hb_retc( gtk_css_provider_to_string( css_provider ) );
}

//eof
