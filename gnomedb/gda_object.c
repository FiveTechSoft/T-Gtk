/* $Id: gda_object.c,v 1.1 2009-01-20 01:27:41 riztan Exp $*/
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

/*
Por Incluir:

  gda_data_model_row_inserted()
  gda_data_model_row_updated()
  gda_data_model_row_removed()
  gda_data_model_freeze()
  
*/

// Functions LIBGDA
#include <hbapi.h>
#include <hbapiitm.h>

#ifdef _GNOMEDB_
#include <libgda/libgda.h>


HB_FUNC( GDA_OBJECT_SET_ID )
{
   GdaObject *gdaobj  = GDA_OBJECT( hb_parnl( 1 ) );
   const gchar *strid = hb_parc( 2 );

   gda_object_set_id( gdaobj, strid );

}



#endif

