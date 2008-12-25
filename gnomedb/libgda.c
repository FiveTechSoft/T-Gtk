// Functions LIBGDA
#include <hbapi.h>
#include <hbapiitm.h>

#ifdef _GNOMEDB_
#include <libgda/libgda.h>

/*
gboolean            gda_config_save_data_source         (const gchar *name,
                                                         const gchar *provider,
                                                         const gchar *cnc_string,
                                                         const gchar *description,
                                                         const gchar *username,
                                                         const gchar *password,
                                                         gboolean is_global);

Adds a new data source (or update an existing one) to the GDA configuration, based on the parameters given.

name : 	name for the data source to be saved.
provider : 	provider ID for the new data source.
cnc_string : 	connection string for the new data source.
description : 	description for the new data source.
username : 	user name for the new data source.
password : 	password to use when authenticating username.
is_global : 	TRUE if the data source is system-wide
Returns : 	TRUE if no error occurred
*/
HB_FUNC( GDA_CONFIG_SAVE_DATA_SOURCE )
{

 hb_retl( gda_config_save_data_source ( ( const gchar * )hb_parc( 1 ),
					( const gchar * )hb_parc( 2 ),
					( const gchar * )hb_parc( 3 ),
					( const gchar * )hb_parc( 4 ),
					( const gchar * )hb_parc( 5 ),
					( const gchar * )hb_parc( 6 ),
					hb_parl( 7 ) ) );
}

// GdaClient*          gda_client_new                      (void);
HB_FUNC( GDA_CLIENT_NEW )
{
  GdaClient * client = gda_client_new();
  hb_retnl( (glong) client );
}


/*
GdaConnection*      gda_client_open_connection          (GdaClient *client,
                                                         const gchar *dsn,
                                                         const gchar *username,
                                                         const gchar *password,
                                                         GdaConnectionOptions options,
                                                         GError **error);
*/
HB_FUNC( GDA_CLIENT_OPEN_CONNECTION )
{
 GdaConnection *connection;
 GdaClient *client     = GDA_CLIENT( hb_parnl( 1 ) );
 const gchar *dsn      = (const gchar *)hb_parc( 2 );
 const gchar *username = (const gchar *)hb_parc( 3 );
 const gchar *password = (const gchar *)hb_parc( 4 );
 GdaConnectionOptions options = hb_parni( 5 );
 PHB_ITEM pError = hb_param( 6, HB_IT_ANY );
 GError *error = NULL;

 connection = gda_client_open_connection(client, dsn, username, password, options, &error );

 hb_retnl( (glong) connection );

 // Si hay algún tipo de error
 if (error != NULL) {
     // g_printerr ("Error: %d %s\n", error->code, error->message );
    if( pError )
      {
      hb_arrayNew( pError, 2 );
      hb_arraySetNI( pError, 1, error->code );
      hb_arraySetC( pError,  2, error->message );
      }
     g_error_free (error);

     g_error_free (error);
 }
}

HB_FUNC( GDA_CONNECTION_CLOSE )
{
 GdaConnection *cnc = GDA_CONNECTION( hb_parnl( 1 ) );
 gda_connection_close (cnc);
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
      hb_arraySetNI( pError, 1, error->code );
      hb_arraySetC( pError,  2, error->message );
      }
     g_error_free (error);
 }

}

HB_FUNC( GDA_COMMAND_NEW )
{
  const gchar *text =  hb_parc( 1 );
  GdaCommandType type = hb_parni( 2 );
  GdaCommandOptions options = hb_parni( 3 );
  GdaCommand * command;
  command = gda_command_new( text, type, options );
  hb_retnl( (glong) command );
}


#endif

