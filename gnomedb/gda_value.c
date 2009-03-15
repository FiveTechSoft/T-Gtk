/* $Id: gda_value.c,v 1.1 2009-03-15 17:10:16 riztan Exp $*/
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

#ifdef _GNOMEDB_
#include <glib.h>
#include <glib-object.h>
#include <libgda/libgda.h>

HB_FUNC( GDA_VALUE_NEW_FROM_STRING )
{
   const gchar *cValue = hb_parc( 1 );
   GType type = hb_parnl( 2 );

//   GValue value = gda_value_new_from_string( cValue, type );
   
   hb_retptr( (GValue *) gda_value_new_from_string( cValue, type ) );
   
}


HB_FUNC( GDA_VALUE_STRINGIFY )
{
   const GValue *value = (GValue *) hb_parptr( 1 ) ;
   hb_retc( gda_value_stringify( value ) );
}






#endif
