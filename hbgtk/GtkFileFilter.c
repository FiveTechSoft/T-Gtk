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
    (c)2011 Daniel Garcia-Gil<danielgarciagil@gmail.com>

*/
#include <gtk/gtk.h>
#include "hbapi.h"

#ifdef _GTK2_

HB_FUNC( GTK_FILE_FILTER_NEW )
{
	GtkFileFilter * pFilter = gtk_file_filter_new();
	hb_retptr( ( GtkFileFilter * ) pFilter );
}

//-------------------------------------------------------//

HB_FUNC( GTK_FILE_FILTER_ADD_PATTERN )
{
	GtkFileFilter * pFilter = ( GtkFileFilter * ) hb_parptr( 1 ) ;
	const char * szFilter = hb_parc( 2 );
	gtk_file_filter_add_pattern( pFilter, szFilter );
}

//-------------------------------------------------------//

HB_FUNC( GTK_FILE_FILTER_SET_NAME )
{
	GtkFileFilter * pFilter = ( GtkFileFilter * ) hb_parptr( 1 ) ;
	const char * szName = hb_parc( 2 );
	gtk_file_filter_set_name( pFilter, szName );
}

//-------------------------------------------------------//

HB_FUNC( GTK_FILE_FILTER_GET_NAME )
{
	GtkFileFilter * pFilter = ( GtkFileFilter * ) hb_parptr( 1 ) ;
	hb_retc( gtk_file_filter_get_name( pFilter ) );
}

//-------------------------------------------------------//

#endif
