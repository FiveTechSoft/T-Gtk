/* $Id: gda_connection.c,v 1.4 2009-03-26 22:40:16 riztan Exp $*/
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

gda_connection_close_no_warning ()
gda_connection_get_client ()
gda_connection_get_options()
gda_connection_get_provider_obj()
gda_connection_get_infos()

gda_connection_add_event()
gda_connection_add_event_string()
gda_connection_add_events_list()
gda_connection_get_events()
gda_connection_clear_events_list()
gda_connection_get_last_insert_id()
gda_connection_get_transaction_status()

*/

#ifdef _GDA_

#include <hbapi.h>
#include <hbapiitm.h>
#include <hbapierr.h>

#include <hbvm.h>
#include <hbvmint.h>
#include <hbstack.h>

// Functions LIBGDA
#include <glib.h>
#include <glib-object.h>
#include <libgda/libgda.h>
#include <sql-parser/gda-sql-parser.h>

#include "hbgda.h"

HB_FUNC( GDA_CONNECTION_OPEN )
{
   GdaConnection *cnc = GDA_CONNECTION( hb_parptr( 1 ) );
   GError *error = NULL;
   PHB_ITEM pError = hb_param( 3, HB_IT_ANY );

   hb_retl( gda_connection_open( cnc, &error ) );

   if (error != NULL) {
      hb_GDAprinterr( error, pError );
      hb_errRT_BASE_SubstR( EG_ARG, 1124, NULL, HB_ERR_FUNCNAME, HB_ERR_ARGS_BASEPARAMS );
   }
}

HB_FUNC( GDA_CONNECTION_OPEN_FROM_DSN )
{
   const gchar *dsn = hb_parc( 1 );
   const gchar *auth_string = hb_parc( 2 );
   int   options = hb_parni( 3 );
   GError *error = NULL;
   PHB_ITEM pError = hb_param( 3, HB_IT_ANY );
   
   hb_retptr( gda_connection_open_from_dsn( dsn, auth_string, options, &error ) );

   if (error != NULL) {
      hb_GDAprinterr( error, pError );
      hb_errRT_BASE_SubstR( EG_ARG, 1124, NULL, HB_ERR_FUNCNAME, HB_ERR_ARGS_BASEPARAMS );
   }

}


HB_FUNC( GDA_CONNECTION_OPEN_FROM_STRING )
{
   const gchar *dsn = hb_parc( 1 );
   const gchar *cnc_string  = hb_parc( 2 );
   const gchar *auth_string = hb_parc( 3 );
   int   options = hb_parni( 4 );
   GError *error = NULL;
   PHB_ITEM pError = hb_param( 3, HB_IT_ANY );
   
   hb_retptr( gda_connection_open_from_string( dsn, cnc_string, auth_string, options, &error ) );

   if (error != NULL) {
      hb_GDAprinterr( error, pError );
      hb_errRT_BASE_SubstR( EG_ARG, 1124, NULL, HB_ERR_FUNCNAME, HB_ERR_ARGS_BASEPARAMS );
   }
}


HB_FUNC( GDA_CONNECTION_CLOSE )
{
   GdaConnection *cnc = GDA_CONNECTION( hb_parptr( 1 ) );
   gda_connection_close (cnc);
}


HB_FUNC( GDA_CONNECTION_CLOSE_NO_WARNING )
{
   GdaConnection *cnc = GDA_CONNECTION( hb_parptr( 1 ) );
   gda_connection_close_no_warning (cnc);
}


HB_FUNC( GDA_CONNECTION_IS_OPENED )
{
   GdaConnection *cnc = GDA_CONNECTION( hb_parptr( 1 ) );
   hb_retl( gda_connection_is_opened( cnc ) );
}


HB_FUNC( GDA_CONNECTION_CREATE_PARSER )
{
   GdaConnection *cnc = GDA_CONNECTION( hb_parptr( 1 ) );
   GdaSqlParser *parser;

   parser = gda_connection_create_parser( cnc );

   if (!parser)
      hb_retptr( NULL );
   
   hb_retptr( (GdaSqlParser *) parser );
}


HB_FUNC( GDA_CONNECTION_VALUE_TO_SQL_STRING )
{
   GdaConnection *cnc = GDA_CONNECTION( hb_parptr( 1 ) );
   GValue *from = hb_parptr( 2 );
   gchar * result;
 
   result = gda_connection_value_to_sql_string( cnc, from);
   
   if (!result)
      hb_retptr(NULL);
   hb_retptr( (GValue *) result );
}

/*
TODO.
HB_FUNC( GDA_CONNECTION_STATEMENT_TO_SQL )
*/

HB_FUNC( GDA_CONNECTION_STATEMENT_PREPARE )
{
   GdaConnection *cnc = GDA_CONNECTION( hb_parptr( 1 ) );
   GdaStatement *stmt =  hb_parptr( 2 );

   GError * error = NULL;
   PHB_ITEM pError = hb_param( 3, HB_IT_ANY );
   
   hb_retl( gda_connection_statement_prepare( cnc, stmt, &error) );

   if (error != NULL) {
      hb_GDAprinterr( error, pError );
      hb_errRT_BASE_SubstR( EG_ARG, 1124, NULL, HB_ERR_FUNCNAME, HB_ERR_ARGS_BASEPARAMS );
   }
}

/*
TODO
HB_FUNC( GDA_CONNECTION_STATEMENT_EXECUTE )
*/

HB_FUNC( GDA_CONNECTION_STATEMENT_EXECUTE_NON_SELECT )
{
   GdaConnection *cnc = GDA_CONNECTION( hb_parptr( 1 ) );
   GdaStatement *stmt =  hb_parptr( 2 );
   GdaSet *params = hb_parptr( 3 );
//   GdaSet *last_insert_row;
   GError * error = NULL;
   PHB_ITEM pError = hb_param( 3, HB_IT_ANY );
   
   hb_retni(  gda_connection_statement_execute_non_select( cnc, stmt, params, NULL, &error) );

   if (error != NULL) {
      hb_GDAprinterr( error, pError );
      hb_errRT_BASE_SubstR( EG_ARG, 1124, NULL, HB_ERR_FUNCNAME, HB_ERR_ARGS_BASEPARAMS );
   }
}


HB_FUNC( GDA_CONNECTION_STATEMENT_EXECUTE_SELECT )
{
   GdaConnection *cnc = GDA_CONNECTION( hb_parptr( 1 ) );
   GdaStatement *stmt =  hb_parptr( 2 );
   GdaSet *params = hb_parptr( 3 );
   GError * error = NULL;
   PHB_ITEM pError = hb_param( 3, HB_IT_ANY );
   
   hb_retptr( gda_connection_statement_execute_select( cnc, stmt, params, &error) );

   if (error != NULL) {
      hb_GDAprinterr( error, pError );
      hb_errRT_BASE_SubstR( EG_ARG, 1124, NULL, HB_ERR_FUNCNAME, HB_ERR_ARGS_BASEPARAMS );
   }
}


HB_FUNC( GDA_EXECUTE_NON_SELECT_COMMAND )
{
   GdaConnection *cnc = GDA_CONNECTION( hb_parptr( 1 ) );
   const gchar *sql =  (const gchar *) hb_parc( 2 );
   GError *error = NULL;
   glong result = gda_execute_non_select_command( cnc, sql, &error);
   PHB_ITEM pError = hb_param( 3, HB_IT_ANY );

   hb_retnl( (glong) result );

   if (error != NULL) {
      hb_GDAprinterr( error, pError );
      hb_errRT_BASE_SubstR( EG_ARG, 1124, NULL, HB_ERR_FUNCNAME, HB_ERR_ARGS_BASEPARAMS );
   }
}


HB_FUNC( GDA_EXECUTE_SELECT_COMMAND )
{
   GdaConnection *cnc = GDA_CONNECTION( hb_parptr( 1 ) );
   const gchar *sql =  (const gchar *) hb_parc( 2 );
   GError *error = NULL;
   GdaDataModel *model = gda_execute_select_command( cnc, sql, &error);
   //hb_retptr( (GdaDataModel *) gda_connection_execute_select_command( cnc, sql, &error) );

   PHB_ITEM pError = hb_param( 4, HB_IT_ANY );

   hb_retptr( (GdaDataModel *) model );

   if (error != NULL) {
      hb_GDAprinterr( error, pError );
      hb_errRT_BASE_SubstR( EG_ARG, 1124, NULL, HB_ERR_FUNCNAME, HB_ERR_ARGS_BASEPARAMS );
   }
}


/* Asks the underlying provider for if a specific feature is supported. */

HB_FUNC( GDA_CONNECTION_SUPPORTS_FEATURE )
{
   GdaConnection *cnc = GDA_CONNECTION( hb_parptr( 1 ) );
   int feature = hb_parni( 2 );

   hb_retl( gda_connection_supports_feature(cnc, feature) );
}

/*
DEPRECATED

HB_FUNC( GDA_CONNECTION_GET_SCHEMA )
{
   GdaConnection *cnc = GDA_CONNECTION( hb_parptr( 1 ) );
   int schema = hb_parni( 2 );
   GdaParameterList *params = (GdaParameterList *)hb_parptr( 3 );

   GError *error = NULL;
   PHB_ITEM pError = hb_param( 4, HB_IT_ANY );

   hb_retnl( (glong) gda_connection_get_schema( cnc, schema, params, &error ) );

   if (error != NULL) {
      hb_GDAprinterr( error, pError );
      hb_errRT_BASE_SubstR( EG_ARG, 1124, NULL, HB_ERR_FUNCNAME, HB_ERR_ARGS_BASEPARAMS );
   }
}
*/

/*
HB_FUNC( GDA_CONNECTION_GET_SERVER_VERSION )
{
   GdaConnection *cnc = GDA_CONNECTION( hb_parptr( 1 ) );
   hb_retc( gda_connection_get_server_version( cnc ) );
}


HB_FUNC( GDA_CONNECTION_GET_DATABASE )
{
   GdaConnection *cnc = GDA_CONNECTION( hb_parptr( 1 ) );
   hb_retc( gda_connection_get_database(cnc) );
}


HB_FUNC( GDA_CONNECTION_SET_DSN )
{
   GdaConnection *cnc = GDA_CONNECTION( hb_parptr( 1 ) );
   const gchar *datasource = hb_parc( 2 );
   
   hb_retl( gda_connection_set_dsn(cnc, datasource) );
}
*/

HB_FUNC( GDA_CONNECTION_GET_DSN )
{
   GdaConnection *cnc = GDA_CONNECTION( hb_parptr( 1 ) );
   hb_retc( gda_connection_get_dsn(cnc) );
}


HB_FUNC( GDA_CONNECTION_GET_CNC_STRING )
{
   GdaConnection *cnc = GDA_CONNECTION( hb_parptr( 1 ) );
   hb_retc( gda_connection_get_cnc_string(cnc) );
}


HB_FUNC( GDA_CONNECTION_GET_AUTENTHICATION )
{
   GdaConnection *cnc = GDA_CONNECTION( hb_parptr( 1 ) );
   hb_retc( gda_connection_get_authentication(cnc) );
}


HB_FUNC( GDA_CONNECTION_GET_PROVIDER )
{
   GdaConnection *cnc = GDA_CONNECTION( hb_parptr( 1 ) );
   hb_retptr( gda_connection_get_provider(cnc) );
}


HB_FUNC( GDA_CONNECTION_GET_PROVIDER_NAME )
{
   GdaConnection *cnc = GDA_CONNECTION( hb_parptr( 1 ) );
   hb_retc( gda_connection_get_provider_name(cnc) );
}

/*
HB_FUNC( GDA_CONNECTION_SET_USERNAME )
{
   GdaConnection *cnc = GDA_CONNECTION( hb_parptr( 1 ) );
   const gchar *username = hb_parc( 2 );

   hb_retl( gda_connection_set_username(cnc, username) );
}


HB_FUNC( GDA_CONNECTION_GET_USERNAME )
{
   GdaConnection *cnc = GDA_CONNECTION( hb_parptr( 1 ) );
   hb_retc( gda_connection_get_username(cnc) );
   
}


HB_FUNC( GDA_CONNECTION_SET_PASSWORD )
{
   GdaConnection *cnc = GDA_CONNECTION( hb_parptr( 1 ) );
   const gchar *password = hb_parc( 2 );
   hb_retl( gda_connection_set_password(cnc, password) );

}


HB_FUNC( GDA_CONNECTION_GET_PASSWORD )
{
   GdaConnection *cnc = GDA_CONNECTION( hb_parptr( 1 ) );
   hb_retc( gda_connection_get_password(cnc) );
   
}


HB_FUNC( GDA_CONNECTION_CHANGE_DATABASE )
{
   GdaConnection *cnc = GDA_CONNECTION( hb_parptr( 1 ) );
   const gchar *name = hb_parc( 2 );

   hb_retl( gda_connection_change_database(cnc, name) );
}
*/
/*
HB_FUNC( GDA_CONNECTION_EXECUTE_COMMAND )
{
   GdaConnection *cnc = GDA_CONNECTION( hb_parptr( 1 ) );
   GdaCommand *cmd =  (GdaCommand *)hb_parptr( 2 );
   GdaParameterList *params = (GdaParameterList *)hb_parptr( 3 );
   GError *error = NULL;
   GdaDataModel * model = gda_connection_execute_command( cnc, cmd, params, &error);
   PHB_ITEM pError = hb_param( 4, HB_IT_ANY );

   hb_retnl( (glong) model );

   if (error != NULL) {
      hb_GDAprinterr( error, pError );
      hb_errRT_BASE_SubstR( EG_ARG, 1124, NULL, HB_ERR_FUNCNAME, HB_ERR_ARGS_BASEPARAMS );
   }
}
*/

/*
HB_FUNC( GDA_CONNECTION_BEGIN_TRANSACTION )
{
   GdaConnection *cnc = GDA_CONNECTION( hb_parptr( 1 ) );
   const gchar *name = hb_parc( 2 );
   int level = hb_parni( 3 );
   PHB_ITEM pError = hb_param( 4, HB_IT_ANY );
   GError *error = NULL;
   int result = 0;
   
   result = gda_connection_begin_transaction( cnc, name, level, &error );

   hb_retl( result );
   
   if (error != NULL) {
      hb_GDAprinterr( error, pError );
      hb_errRT_BASE_SubstR( EG_ARG, 1124, NULL, HB_ERR_FUNCNAME, HB_ERR_ARGS_BASEPARAMS );
   }
}


HB_FUNC( GDA_CONNECTION_COMMIT_TRANSACTION )
{
   GdaConnection *cnc = GDA_CONNECTION( hb_parptr( 1 ) );
   const gchar *name = hb_parc( 2 );
   PHB_ITEM pError = hb_param( 3, HB_IT_ANY );
   GError *error = NULL;
   int result = 0;
   
   result = gda_connection_commit_transaction( cnc, name, &error );
   
   hb_retl( result );
   
   if (error != NULL) {
      hb_GDAprinterr( error, pError );
      hb_errRT_BASE_SubstR( EG_ARG, 1124, NULL, HB_ERR_FUNCNAME, HB_ERR_ARGS_BASEPARAMS );
   }
}


HB_FUNC( GDA_CONNECTION_ROLLBACK_TRANSACTION )
{
   GdaConnection *cnc = GDA_CONNECTION( hb_parptr( 1 ) );
   const gchar *name = hb_parc( 2 );
   PHB_ITEM pError = hb_param( 3, HB_IT_ANY );
   GError *error = NULL;
   int result = 0;
   
   result = gda_connection_rollback_transaction( cnc, name, &error );
   
   hb_retl( result );
   
   if (error != NULL) {
      hb_GDAprinterr( error, pError );
      hb_errRT_BASE_SubstR( EG_ARG, 1124, NULL, HB_ERR_FUNCNAME, HB_ERR_ARGS_BASEPARAMS );
   }
}


HB_FUNC( GDA_CONNECTION_ADD_SAVEPOINT )
{
   GdaConnection *cnc = GDA_CONNECTION( hb_parptr( 1 ) );
   const gchar *name = hb_parc( 2 );
   PHB_ITEM pError = hb_param( 3, HB_IT_ANY );
   GError *error = NULL;
   int result = 0;
   
   result = gda_connection_add_savepoint( cnc, name, &error );
   
   hb_retl( result );
   
   if (error != NULL) {
      hb_GDAprinterr( error, pError );
      hb_errRT_BASE_SubstR( EG_ARG, 1124, NULL, HB_ERR_FUNCNAME, HB_ERR_ARGS_BASEPARAMS );
   }
}


HB_FUNC( GDA_CONNECTION_ROLLBACK_SAVEPOINT )
{
   GdaConnection *cnc = GDA_CONNECTION( hb_parptr( 1 ) );
   const gchar *name = hb_parc( 2 );
   PHB_ITEM pError = hb_param( 3, HB_IT_ANY );
   GError *error = NULL;
   int result = 0;
   
   result = gda_connection_rollback_savepoint( cnc, name, &error );
   
   hb_retl( result );
   
   if (error != NULL) {
      hb_GDAprinterr( error, pError );
      hb_errRT_BASE_SubstR( EG_ARG, 1124, NULL, HB_ERR_FUNCNAME, HB_ERR_ARGS_BASEPARAMS );
   }

}


HB_FUNC( GDA_CONNECTION_DELETE_SAVEPOINT )
{
   GdaConnection *cnc = GDA_CONNECTION( hb_parptr( 1 ) );
   const gchar *name = hb_parc( 2 );
   PHB_ITEM pError = hb_param( 3, HB_IT_ANY );
   GError *error = NULL;
   int result = 0;
   
   result = gda_connection_delete_savepoint( cnc, name, &error );
   
   hb_retl( result );
   
   if (error != NULL) {
      hb_GDAprinterr( error, pError );
      hb_errRT_BASE_SubstR( EG_ARG, 1124, NULL, HB_ERR_FUNCNAME, HB_ERR_ARGS_BASEPARAMS );
   }

}

*/

HB_FUNC( GDA_CONNECTION_INSERT_ROW_INTO_TABLE ) {
   GdaConnection *cnc = GDA_CONNECTION( hb_parptr( 1 ) );
   const gchar *table = hb_parc( 2 );
   GError *error = NULL;
   GSList *clist = NULL;
   GSList *vlist = NULL;
   gboolean retval;

   //g_return_val_if_fail (GDA_IS_CONNECTION (cnc), FALSE);
   //g_return_val_if_fail (table && *table, FALSE);

   PHB_ITEM pParam;
   HB_ULONG ulPCount = hb_pcount();

   if( ulPCount && ulPCount > 3)
   {
      HB_ULONG ulParam;
      HB_TYPE iParamType;
      GValue *value;

   
      for( ulParam=4; ulParam <= ulPCount; ulParam=ulParam+2 )
      {

          pParam = hb_param( ulParam, HB_IT_ANY );

          clist = g_slist_prepend (clist, hb_itemGetC( pParam ) );

          pParam = hb_param( ulParam+1, HB_IT_ANY );
          iParamType = HB_ITEM_TYPE( pParam );
          switch( iParamType ){
          case HB_IT_STRING:
               g_print("CADENA\n");
               value = gda_value_new_from_string( hb_itemGetC( pParam ), G_TYPE_STRING );
               break;
          case HB_IT_INTEGER:
               g_print("Numero ENTERO\n");
               value = gda_value_new( G_TYPE_INT );
               g_value_set_int( value, hb_itemGetNI( pParam ) );
               break;
          case HB_IT_NUMERIC:
               g_print("Numero Simple\n");
               value = gda_value_new( G_TYPE_FLOAT );
               g_value_set_float( value, hb_itemGetNI( pParam ) );
               break;
          case HB_IT_DOUBLE:
               g_print("Numero DOBLE\n");
               value = gda_value_new( G_TYPE_FLOAT );
               g_value_set_float( value, hb_itemGetND( pParam ) );
               break;
          case HB_IT_LOGICAL:
               g_print("Numero DOBLE\n");
               value = gda_value_new( G_TYPE_BOOLEAN );
               g_value_set_boolean( value, hb_itemGetL( pParam ) );
               break;
          case HB_IT_DATE:
               g_print("TimeStamp \n");
               value = gda_value_new( GDA_TYPE_TIMESTAMP );
               gda_value_set_timestamp( value, (GdaTimestamp *) hb_itemGetDL( pParam ) ); 
               break;
          }

          vlist = g_slist_prepend (vlist, value );
      }

      if (!clist) {
         g_warning ("No specified column or value");
         hb_retl( FALSE );
      }

      clist = g_slist_reverse (clist);
      vlist = g_slist_reverse (vlist);

      retval = gda_insert_row_into_table_v (cnc, table, clist, vlist, &error);

      PHB_ITEM pError = hb_param( 4, HB_IT_ANY );
      if (error != NULL) {
         hb_GDAprinterr( error, pError );
         hb_errRT_BASE_SubstR( EG_ARG, 1124, NULL, HB_ERR_FUNCNAME, HB_ERR_ARGS_BASEPARAMS );
      }

      gda_value_free(value);
      g_slist_free (clist);
      g_slist_free (vlist);

      hb_retl(retval);
   }
}



HB_FUNC( GDA_CONNECTION_INSERT_ROW_INTO_TABLE_V )
{
   GdaConnection *cnc = GDA_CONNECTION( hb_parptr( 1 ) );
   const gchar *table = hb_parc( 2 );
   GSList *fields = NULL;
   GSList *values = NULL;
   GError *error = NULL;

   PHB_ITEM pError = hb_param( 4, HB_IT_ANY );

   hb_retl( gda_insert_row_into_table_v( cnc, table, fields, values, &error ) );

   if (error != NULL) {
      hb_GDAprinterr( error, pError );
      hb_errRT_BASE_SubstR( EG_ARG, 1124, NULL, HB_ERR_FUNCNAME, HB_ERR_ARGS_BASEPARAMS );
   }   
}




#endif
