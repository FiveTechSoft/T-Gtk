/* $Id: gda_dict.c,v 1.1 2009-03-26 23:03:41 riztan Exp $*/
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


HB_FUNC( GDA_DICT_NEW )
{
   GdaDict *dict = gda_dict_new();
   hb_retnl( (glong) dict );

}


HB_FUNC( GDA_DICT_SET_CONNECTION )
{
   GdaDict *dict = GDA_DICT( hb_parptr( 1 ) );
   GdaConnection *cnc = GDA_CONNECTION( hb_parptr( 2 ) );
   gda_dict_set_connection( dict, cnc );
}


HB_FUNC( GDA_DICT_GET_CONNECTION )
{
   GdaDict *dict = GDA_DICT( hb_parptr( 1 ) );
   hb_retptr( gda_dict_get_connection( dict ) );
}


HB_FUNC(  GDA_DICT_GET_DATABASE )
{
   GdaDict *dict = GDA_DICT( hb_parptr( 1 ) );
   hb_retptr( gda_dict_get_database( dict ) );
}


HB_FUNC( GDA_DICT_UPDATE_DBMS_META_DATA )
{
   GdaDict *dict = GDA_DICT( hb_parptr( 1 ) );
   GType limit_to_type = hb_parptr( 2 );
   const gchar *limit_obj_name = hb_parc( 3 );

   GError *error = NULL;
   PHB_ITEM pError = hb_param( 4, HB_IT_ANY );

   hb_retl( gda_dict_update_dbms_meta_data( dict, limit_to_type, limit_obj_name, &error ) );

   if (error != NULL) {
      g_printerr ("Error: %d %s\n", error->code, error->message );
      if( pError )
        {
        hb_arrayNew( pError, 2 );
        PHB_ITEM pTemp    = hb_itemNew( NULL );

        char szNum[32];
        sprintf( szNum, "%d", error->code );
        g_printerr( szNum );
        g_printerr( error->message );

        hb_itemPutNI( pTemp, error->code );
        hb_arraySetForward( pError , 1, pTemp);
      
        hb_itemPutC( pTemp, error->message );
        hb_arraySetForward( pError, 2, pTemp);
      
        hb_itemRelease( pTemp );
      
      }
      g_error_free (error);
   }
   
}


HB_FUNC( GDA_DICT_STOP_UPDATE_DBMS_META_DATA )
{
   GdaDict *dict = GDA_DICT( hb_parptr( 1 ) );
   gda_dict_stop_update_dbms_meta_data( dict );
}


#endif

