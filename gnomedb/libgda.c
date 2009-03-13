/* $Id: libgda.c,v 1.3 2009-03-13 04:34:13 riztan Exp $*/
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


HB_FUNC( GDA_CONFIG_REMOVE_DATA_SOURCE )
{

   gda_config_remove_data_source ( ( const gchar * )hb_parc( 1 )  );

}


// GdaClient*          gda_client_new                      (void);
HB_FUNC( GDA_CLIENT_NEW )
{
  GdaClient * client = gda_client_new();
  hb_retnl( (glong) client );
}

/*
gda_client_get_connections ()

const GList*        gda_client_get_connections          (GdaClient *client);
Gets the list of all open connections in the given GdaClient object. The GList returned is an internal pointer, so DON'T TRY TO FREE IT.
client :
	a GdaClient object.
Returns :
	a GList of GdaConnection objects; dont't modify that list 
*/
HB_FUNC( GDA_CLIENT_GET_CONNECTIONS )
{
   GdaClient *client = GDA_CLIENT( hb_parnl( 1 ) );
   hb_retptr( (GList *) gda_client_get_connections(client) );  
}


HB_FUNC( GDA_CLIENT_CLOSE_ALL_CONNECTION )
{
  
  GdaClient *client = GDA_CLIENT( hb_parnl( 1 ) );
  gda_client_close_all_connections(client) ;

}


/*
gda_client_begin_transaction        (GdaClient *client,
                                     const gchar *name,
                                     GdaTransactionIsolation level,
                                     GError **error);
*/
HB_FUNC( GDA_CLIENT_BEGIN_TRANSACTION )
{
   GdaClient *client = GDA_CLIENT( hb_parnl( 1 ) );
   const gchar *name = hb_parc( 2 );
   int level = hb_parni( 3 );
   PHB_ITEM pError = hb_param( 4, HB_IT_ANY );
   GError *error = NULL;
   int result = 0;
   
   result = gda_client_begin_transaction( client, name, level, &error );

   hb_retl( result );
   
   // Si hay algún tipo de error
   if (error != NULL) {
      if( pError )
         {
         hb_arrayNew( pError, 2 );
         PHB_ITEM pCode = hb_itemNew( NULL ), pMessage = hb_itemNew( NULL );

         pCode = hb_itemPutNI( hb_arrayGetItemPtr( pError,1), error->code );
         pMessage = hb_itemPutC( hb_arrayGetItemPtr( pError,2), error->message );
      
         hb_arraySet( pError, 1, pCode );
         hb_arraySet( pError, 2, pMessage);
      
         hb_itemRelease( pCode );
         hb_itemRelease( pMessage );
      }
      g_error_free (error);

   }

}


/*
gda_client_commit_transaction       (GdaClient *client,
                                     const gchar *name,
                                     GError **error);
*/
HB_FUNC( GDA_CLIENT_COMMIT_TRANSACTION )
{

   GdaClient *client = GDA_CLIENT( hb_parnl( 1 ) );
   const gchar *name = hb_parc( 2 );
   PHB_ITEM pError = hb_param( 3, HB_IT_ANY );
   GError *error = NULL;
   int result = 0;
   
   result = gda_client_commit_transaction( client, name, &error );
   
   hb_retl( result );
   
   // Si hay algún tipo de error
   if (error != NULL) {
      if( pError )
         {
         hb_arrayNew( pError, 2 );
         PHB_ITEM pCode = hb_itemNew( NULL ), pMessage = hb_itemNew( NULL );

         pCode = hb_itemPutNI( hb_arrayGetItemPtr( pError,1), error->code );
         pMessage = hb_itemPutC( hb_arrayGetItemPtr( pError,2), error->message );
      
         hb_arraySet( pError, 1, pCode );
         hb_arraySet( pError, 2, pMessage);
      
         hb_itemRelease( pCode );
         hb_itemRelease( pMessage );
      }
      g_error_free (error);

   }

}


/*
gda_client_rollback_transaction     (GdaClient *client,
                                     const gchar *name,
                                     GError **error);
*/
HB_FUNC( GDA_CLIENT_ROLLBACK_TRANSACTION )
{
   GdaClient *client = GDA_CLIENT( hb_parnl( 1 ) );
   const gchar *name = hb_parc( 2 );
   PHB_ITEM pError = hb_param( 3, HB_IT_ANY );
   GError *error = NULL;
   int result = 0;
   
   result = gda_client_rollback_transaction( client, name, &error );
   
   hb_retl( result );
   
   // Si hay algún tipo de error
   if (error != NULL) {
      if( pError )
         {
         hb_arrayNew( pError, 2 );
         PHB_ITEM pCode = hb_itemNew( NULL ), pMessage = hb_itemNew( NULL );

         pCode = hb_itemPutNI( hb_arrayGetItemPtr( pError,1), error->code );
         pMessage = hb_itemPutC( hb_arrayGetItemPtr( pError,2), error->message );
      
         hb_arraySet( pError, 1, pCode );
         hb_arraySet( pError, 2, pMessage);
      
         hb_itemRelease( pCode );
         hb_itemRelease( pMessage );
      }
      g_error_free (error);

   }

}


HB_FUNC( GDA_CLIENT_GET_DSN_SPECS )
{
   GdaClient *client = GDA_CLIENT( hb_parnl( 1 ) );
   const gchar *provider = hb_parc( 2 );
   
   hb_retc( gda_client_get_dsn_specs( client, provider ) );

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
      // PHB_ITEM pCode = hb_itemNew( NULL ), pMessage = hb_itemNew( NULL );
      PHB_ITEM pTemp    = hb_itemNew( NULL );

      char szNum[32];
      sprintf( szNum, "%d", error->code );
      g_printerr( szNum );
      g_printerr( error->message );

//      pCode = hb_itemPutNI( hb_arrayGetItemPtr( pError,1), error->code );
//      pMessage = hb_itemPutC( hb_arrayGetItemPtr( pError,2), error->message );

      hb_itemPutNI( pTemp, error->code );
      hb_arraySetForward( pError , 1, pTemp);
      
      hb_itemPutC( pTemp, error->message );
      hb_arraySetForward( pError, 2, pTemp);
      
      hb_itemRelease( pTemp );
      
    }
    g_error_free (error);

 }
}

/*
   hb_itemReturnForward( aNew );
    
   hb_itemRelease( temp );
   hb_itemRelease( aTemp );
   hb_itemRelease( aNew );
*/

HB_FUNC( GDA_COMMAND_NEW )
{
   const gchar *text =  hb_parc( 1 );
   GdaCommandType type = hb_parni( 2 );
   GdaCommandOptions options = hb_parni( 3 );
   GdaCommand * command;
   command = gda_command_new( text, type, options );
   hb_retnl( (glong) command );
}


HB_FUNC( GDA_CONFIG_GET_PROVIDER_LIST )
{
   GList *providers;
   GList *l;

/*
 -- Gracias a Walter Negro por la explicacion del correcto 
    manejo de los arreglos a nivel de C.
*/
//   HB_ITEM aTemp;
//   HB_ITEM aNew;
//   HB_ITEM temp;

//   aTemp.type = HB_IT_NIL;
//   aNew.type = HB_IT_NIL;
//   temp.type = HB_IT_NIL;

   PHB_ITEM aTemp = hb_itemNew( NULL );
   PHB_ITEM aNew  = hb_itemArrayNew( 0 );
   PHB_ITEM temp  = hb_itemNew( NULL );
   
   providers = gda_config_get_provider_list();
   
   for (l = providers; l != NULL; l = l->next) {
       GdaProviderInfo *info = (GdaProviderInfo *) l->data;
//       GList *ll;
       
//       PHB_ITEM aParamInfo = hb_itemArrayNew( 0 );

       if (!info) {
             g_printerr ("** ERROR: gda_config_get_provider_list returned a NULL item\n");
             gda_main_quit ();
       }
 
       hb_arrayNew( aTemp, 5 );
       
       hb_itemPutC( temp, info->id );
       hb_arraySetForward( aTemp, 1, temp );
       
       hb_itemPutC( temp, info->location );
       hb_arraySetForward( aTemp, 2, temp );
       
       hb_itemPutC( temp, info->description );
       hb_arraySetForward( aTemp, 3, temp );
       
       /* Falta incluir el 4to elemento ( info->param_info ) */
       
       hb_itemPutC( temp, info->dsn_spec );
       hb_arraySetForward( aTemp, 5, temp );

       hb_arrayAddForward(aNew, aTemp);
 
   }

   hb_itemReturnForward( aNew );
    
   hb_itemRelease( temp );
   hb_itemRelease( aTemp );
   hb_itemRelease( aNew );
}


HB_FUNC( GDA_CONFIG_GET_DATA_SOURCE_LIST )
{
   GList *DataSources;
   GList *l;
   
   PHB_ITEM aTemp = hb_itemNew( NULL );
   PHB_ITEM aNew  = hb_itemArrayNew( 0 );
   PHB_ITEM temp  = hb_itemNew( NULL );
   
   DataSources = gda_config_get_data_source_list();
   
   for (l = DataSources; l != NULL; l = l->next) {

       GdaDataSourceInfo *info = (GdaDataSourceInfo *) l->data;

       hb_arrayNew( aTemp, 7 );
       
       hb_itemPutC( temp, info->name );
       hb_arraySetForward( aTemp, 1, temp );

       hb_itemPutC( temp, info->provider );
       hb_arraySetForward( aTemp, 2, temp );

       hb_itemPutC( temp, info->cnc_string );
       hb_arraySetForward( aTemp, 3, temp );

       hb_itemPutC( temp, info->description );
       hb_arraySetForward( aTemp, 4, temp );

       hb_itemPutC( temp, info->username );
       hb_arraySetForward( aTemp, 5, temp );

       hb_itemPutC( temp, info->password );
       hb_arraySetForward( aTemp, 6, temp );

       hb_itemPutL( temp, info->is_global );
       hb_arraySetForward( aTemp, 7, temp );

       hb_arrayAddForward(aNew, aTemp);
 
   }

   hb_itemReturnForward( aNew );
    
   hb_itemRelease( temp );
   hb_itemRelease( aTemp );
   hb_itemRelease( aNew );
}

#endif

