/* $Id: gdaui.c,v 1 2012-07-31 04:50:05 riztan Exp $*/
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
#include <libgda/libgda.h>
#include <libgda-ui/libgda-ui.h>


// -------------------------------------------------------------------------------
// Initialization of the library
// -------------------------------------------------------------------------------
HB_FUNC( GDAUI_INIT ) 
{
  gdaui_init( );
}


HB_FUNC( GDAUI_GET_DEFAULT_PATH )
{
   hb_retc( gdaui_get_default_path() );
} 


HB_FUNC( GDAUI_SET_DEFAULT_PATH )
{
   gdaui_set_default_path( (const gchar *) hb_parc( 1 ) );
} 


#endif
//eof
