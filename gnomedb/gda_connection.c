/* $Id: gda_connection.c,v 1.3 2009-03-15 17:10:16 riztan Exp $*/
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

gda_connection_open()
gda_connection_close_no_warning ()
gda_connection_get_client ()
gda_connection_get_options()
gda_connection_get_provider_obj()
gda_connection_get_infos()
gda_connection_get_schema()

gda_connection_add_event()
gda_connection_add_event_string()
gda_connection_add_events_list()
gda_connection_get_events()
gda_connection_clear_events_list()
gda_connection_get_last_insert_id()
gda_connection_get_transaction_status()

*/

// Functions LIBGDA
#include <hbapi.h>
#include <hbapiitm.h>

#ifdef _GNOMEDB_
#include <libgda/libgda.h>

HB_FUNC( GDA_CONNECTION_CLOSE )
{
 GdaConnection *cnc = GDA_CONNECTION( hb_parnl( 1 ) );
 gda_connection_close (cnc);
}

HB_FUNC( GDA_CONNECTION_EXECUTE_NON_SELECT_COMMAND )
{
   GdaConnection *cnc = GDA_CONNECTION( hb_parnl( 1 ) );
   GdaCommand *cmd =  (GdaCommand *)hb_parnl( 2 );
   GdaParameterList *params = (GdaParameterList *)hb_parnl( 3 );
   GError *error = NULL;
   long result = gda_connection_execute_non_select_command( cnc, cmd, params, &error);
   PHB_ITEM pError = hb_param( 4, HB_IT_ANY );

   hb_retnl( (glong) result );

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


HB_FUNC( GDA_CONNECTION_EXECUTE_SELECT_COMMAND )
{
   GdaConnection *cnc = GDA_CONNECTION( hb_parnl( 1 ) );
   GdaCommand *cmd =  (GdaCommand *)hb_parnl( 2 );
   GdaParameterList *params = (GdaParameterList *)hb_parnl( 3 );
   GError *error = NULL;
   GdaDataModel * model = gda_connection_execute_select_command( cnc, cmd, params, &error);
   PHB_ITEM pError = hb_param( 4, HB_IT_ANY );

   hb_retnl( (glong) model );

   // Si hay algún tipo de error
   if (error != NULL) {
       g_printerr ("Error: %d %s\n", error->code, error->message );
       // pError = hb_itemArrayNew(2);
       // hb_itemPutNI( hb_arrayGetItemPtr( pError,1), error->code );
       // hb_itemPutC( hb_arrayGetItemPtr( pError,2),  error->message);
       // hb_itemRelease( pError );
       // hb_storni( (gint) (error->code), 4, 1);
       // hb_storc( (gchar *) (error->message), 4, 2);
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


/* Asks the underlying provider for if a specific feature is supported. */
HB_FUNC( GDA_CONNECTION_SUPPORTS_FEATURE )
{
   GdaConnection *cnc = GDA_CONNECTION( hb_parnl( 1 ) );
   int feature = hb_parni( 2 );

   hb_retl( gda_connection_supports_feature(cnc, feature) );
}


HB_FUNC( GDA_CONNECTION_IS_OPENED )
{
   GdaConnection *cnc = GDA_CONNECTION( hb_parnl( 1 ) );
   hb_retl( gda_connection_is_opened( cnc ) );
}


HB_FUNC( GDA_CONNECTION_GET_SERVER_VERSION )
{
   GdaConnection *cnc = GDA_CONNECTION( hb_parnl( 1 ) );
   hb_retc( gda_connection_get_server_version( cnc ) );
}


HB_FUNC( GDA_CONNECTION_GET_DATABASE )
{
   GdaConnection *cnc = GDA_CONNECTION( hb_parnl( 1 ) );
   hb_retc( gda_connection_get_database(cnc) );
}


HB_FUNC( GDA_CONNECTION_SET_DSN )
{
   GdaConnection *cnc = GDA_CONNECTION( hb_parnl( 1 ) );
   const gchar *datasource = hb_parc( 2 );
   
   hb_retl( gda_connection_set_dsn(cnc, datasource) );
}


HB_FUNC( GDA_CONNECTION_GET_DSN )
{
   GdaConnection *cnc = GDA_CONNECTION( hb_parnl( 1 ) );
   hb_retc( gda_connection_get_dsn(cnc) );
}


HB_FUNC( GDA_CONNECTION_GET_CNC_STRING )
{
   GdaConnection *cnc = GDA_CONNECTION( hb_parnl( 1 ) );
   hb_retc( gda_connection_get_cnc_string(cnc) );
}


HB_FUNC( GDA_CONNECTION_GET_PROVIDER )
{
   GdaConnection *cnc = GDA_CONNECTION( hb_parnl( 1 ) );
   hb_retc( gda_connection_get_provider(cnc) );
}


HB_FUNC( GDA_CONNECTION_SET_USERNAME )
{
   GdaConnection *cnc = GDA_CONNECTION( hb_parnl( 1 ) );
   const gchar *username = hb_parc( 2 );

   hb_retl( gda_connection_set_username(cnc, username) );
}


HB_FUNC( GDA_CONNECTION_GET_USERNAME )
{
   GdaConnection *cnc = GDA_CONNECTION( hb_parnl( 1 ) );
   hb_retc( gda_connection_get_username(cnc) );
   
}


HB_FUNC( GDA_CONNECTION_SET_PASSWORD )
{
   GdaConnection *cnc = GDA_CONNECTION( hb_parnl( 1 ) );
   const gchar *password = hb_parc( 2 );
   hb_retl( gda_connection_set_password(cnc, password) );

}


HB_FUNC( GDA_CONNECTION_GET_PASSWORD )
{
   GdaConnection *cnc = GDA_CONNECTION( hb_parnl( 1 ) );
   hb_retc( gda_connection_get_password(cnc) );
   
}


HB_FUNC( GDA_CONNECTION_CHANGE_DATABASE )
{
   GdaConnection *cnc = GDA_CONNECTION( hb_parnl( 1 ) );
   const gchar *name = hb_parc( 2 );

   hb_retl( gda_connection_change_database(cnc, name) );
}

/*
HB_FUNC( GDA_CONNECTION_EXECUTE_COMMAND )
{
   GdaConnection *cnc = GDA_CONNECTION( hb_parnl( 1 ) );
   GdaCommand *cmd =  (GdaCommand *)hb_parnl( 2 );
   GdaParameterList *params = (GdaParameterList *)hb_parnl( 3 );
   GError *error = NULL;
   GdaDataModel * model = gda_connection_execute_command( cnc, cmd, params, &error);
   PHB_ITEM pError = hb_param( 4, HB_IT_ANY );

   hb_retnl( (glong) model );

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
*/


HB_FUNC( GDA_CONNECTION_BEGIN_TRANSACTION )
{
   GdaConnection *cnc = GDA_CONNECTION( hb_parnl( 1 ) );
   const gchar *name = hb_parc( 2 );
   int level = hb_parni( 3 );
   PHB_ITEM pError = hb_param( 4, HB_IT_ANY );
   GError *error = NULL;
   int result = 0;
   
   result = gda_connection_begin_transaction( cnc, name, level, &error );

   hb_retl( result );
   
   // Si hay algún tipo de error
   if (error != NULL) {
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


HB_FUNC( GDA_CONNECTION_COMMIT_TRANSACTION )
{
   GdaConnection *cnc = GDA_CONNECTION( hb_parnl( 1 ) );
   const gchar *name = hb_parc( 2 );
   PHB_ITEM pError = hb_param( 3, HB_IT_ANY );
   GError *error = NULL;
   int result = 0;
   
   result = gda_connection_commit_transaction( cnc, name, &error );
   
   hb_retl( result );
   
   // Si hay algún tipo de error
   if (error != NULL) {
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


HB_FUNC( GDA_CONNECTION_ROLLBACK_TRANSACTION )
{
   GdaConnection *cnc = GDA_CONNECTION( hb_parnl( 1 ) );
   const gchar *name = hb_parc( 2 );
   PHB_ITEM pError = hb_param( 3, HB_IT_ANY );
   GError *error = NULL;
   int result = 0;
   
   result = gda_connection_rollback_transaction( cnc, name, &error );
   
   hb_retl( result );
   
   // Si hay algún tipo de error
   if (error != NULL) {
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


HB_FUNC( GDA_CONNECTION_ADD_SAVEPOINT )
{
   GdaConnection *cnc = GDA_CONNECTION( hb_parnl( 1 ) );
   const gchar *name = hb_parc( 2 );
   PHB_ITEM pError = hb_param( 3, HB_IT_ANY );
   GError *error = NULL;
   int result = 0;
   
   result = gda_connection_add_savepoint( cnc, name, &error );
   
   hb_retl( result );
   
   // Si hay algún tipo de error
   if (error != NULL) {
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


HB_FUNC( GDA_CONNECTION_ROLLBACK_SAVEPOINT )
{
   GdaConnection *cnc = GDA_CONNECTION( hb_parnl( 1 ) );
   const gchar *name = hb_parc( 2 );
   PHB_ITEM pError = hb_param( 3, HB_IT_ANY );
   GError *error = NULL;
   int result = 0;
   
   result = gda_connection_rollback_savepoint( cnc, name, &error );
   
   hb_retl( result );
   
   // Si hay algún tipo de error
   if (error != NULL) {
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


HB_FUNC( GDA_CONNECTION_DELETE_SAVEPOINT )
{
   GdaConnection *cnc = GDA_CONNECTION( hb_parnl( 1 ) );
   const gchar *name = hb_parc( 2 );
   PHB_ITEM pError = hb_param( 3, HB_IT_ANY );
   GError *error = NULL;
   int result = 0;
   
   result = gda_connection_delete_savepoint( cnc, name, &error );
   
   hb_retl( result );
   
   // Si hay algún tipo de error
   if (error != NULL) {
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


#endif

