/* $Id: gda_object.c,v 1.2 2009-03-26 22:40:16 riztan Exp $*/
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

 
*/

// Functions LIBGDA
#include <hbapi.h>
#include <hbapiitm.h>

#ifdef _GNOMEDB_
#include <libgda/libgda.h>


HB_FUNC( GDA_OBJECT_GET_DICT )
{
   GdaObject *gdaobj  = GDA_OBJECT( hb_parnl( 1 ) );
   hb_retnl( (glong) gda_object_get_dict( gdaobj ) );
}


HB_FUNC( GDA_OBJECT_SET_ID )
{
   GdaObject *gdaobj  = GDA_OBJECT( hb_parnl( 1 ) );
   const gchar *strid = hb_parc( 2 );

   gda_object_set_id( gdaobj, strid );

}


HB_FUNC( GDA_OBJECT_SET_NAME )
{
   GdaObject *gdaobj  = GDA_OBJECT( hb_parnl( 1 ) );
   const gchar *descr = hb_parc( 2 );

   gda_object_set_name( gdaobj, descr );
}


HB_FUNC( GDA_OBJECT_SET_OWNER )
{
   GdaObject *gdaobj  = GDA_OBJECT( hb_parnl( 1 ) );
   const gchar *owner = hb_parc( 2 );

   gda_object_set_owner( gdaobj, owner );
}


HB_FUNC( GDA_OBJECT_GET_ID )
{
   GdaObject *gdaobj  = GDA_OBJECT( hb_parnl( 1 ) );

   hb_retc( gda_object_get_id( gdaobj ) );
}


HB_FUNC( GDA_OBJECT_GET_NAME )
{
   GdaObject *gdaobj  = GDA_OBJECT( hb_parnl( 1 ) );

   hb_retc( gda_object_get_name( gdaobj ) );
}


HB_FUNC( GDA_OBJECT_GET_DESCRIPTION )
{
   GdaObject *gdaobj  = GDA_OBJECT( hb_parnl( 1 ) );

   hb_retc( gda_object_get_description( gdaobj ) );
}


HB_FUNC( GDA_OBJECT_GET_OWNER )
{
   GdaObject *gdaobj  = GDA_OBJECT( hb_parnl( 1 ) );

   hb_retc( gda_object_get_owner( gdaobj ) );
}


HB_FUNC( GDA_OBJECT_DESTROY )
{
   GdaObject *gdaobj  = GDA_OBJECT( hb_parnl( 1 ) );
   gda_object_destroy( gdaobj );
}


HB_FUNC( GDA_OBJECT_DESTROY_CHECK )
{
   GdaObject *gdaobj  = GDA_OBJECT( hb_parnl( 1 ) );
   gda_object_destroy_check( gdaobj );
}

/*  imcompleta...
HB_FUNC( GDA_OBJECT_CONNECT_DESTROY )
{
   GdaObject *gdaobj  = GDA_OBJECT( hb_parnl( 1 ) );
   hb_retnl( (gulong) gda_object_connect_destroy( gdaobj ) );
}
*/


HB_FUNC( GDA_OBJECT_BLOCK_CHANGED )
{
   GdaObject *gdaobj  = GDA_OBJECT( hb_parnl( 1 ) );
   gda_object_block_changed( gdaobj );
}


HB_FUNC( GDA_OBJECT_UNBLOCK_CHANGED )
{
   GdaObject *gdaobj  = GDA_OBJECT( hb_parnl( 1 ) );
   gda_object_unblock_changed( gdaobj );
}


#endif

