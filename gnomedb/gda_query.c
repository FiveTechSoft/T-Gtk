/* $Id: gda_query.c,v 1.1 2009-03-26 23:03:41 riztan Exp $*/
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

HB_FUNC( GDA_QUERY_NEW )
{
   GdaDict *dict = GDA_DICT( hb_parnl( 1 ) );
   GdaQuery *query = gda_query_new( dict );
   hb_retnl( (glong) query );

}


HB_FUNC( GDA_QUERY_NEW_FROM_SQL )
{
   GdaDict *dict = GDA_DICT( hb_parnl( 1 ) );
   const gchar *sql = hb_parc( 2 );

   GError *error = NULL;
   PHB_ITEM pError = hb_param( 3, HB_IT_ANY );

   GdaQuery *query = gda_query_new_from_sql( dict, sql, &error );

   hb_retnl( (glong) query );
   
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


HB_FUNC( GDA_QUERY_CONDITION_NEW )
{
   GdaQuery *query = GDA_QUERY( hb_parnl( 1 ) );
   hb_retnl( (glong) gda_query_condition_new( query, hb_parni( 2 ) ) );
}


/*  En construccion...        
HB_FUNC( GDA_QUERY_CONDITION_NEW_FROM_SQL )
{
   GdaQuery *query = GDA_QUERY( hb_parnl( 1 ) );
   const gchar *sql_cond = hb_parc( 2 );

   GSList *target;
   PHB_ITEM pTargets = hb_param( 3, HB_IT_ANY );

   GError *error = NULL;
   PHB_ITEM pError = hb_param( 4, HB_IT_ANY );

   GdaQuery *query = gda_query_new_from_sql( dict, sql, &error );

   hb_retnl( (glong) query );
   
   if (targets != NULL) {
      if( pTargets )
        {
   for (target = providers; l != NULL; l = l->next) {
       GdaProviderInfo *info = (GdaProviderInfo *) l->data;
 
   }        
        
        hb_arrayNew( pTargets, 2 );
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


HB_FUNC( GDA_QUERY_CONDITION_SET_COND_TYPE )
{
  GdaQueryCondition *condition = GDA_QUERY_CONDITION( hb_parnl( 1 ) );
  
  gda_query_condition_set_cond_type( condition, hb_parni( 2 ) );
}


HB_FUNC( GDA_QUERY_DECLARE_CONDITION )
{
   GdaQuery *query = GDA_QUERY( hb_parnl( 1 ) );
   GdaQueryCondition *cond = GDA_QUERY_CONDITION( hb_parnl( 2 ) );
   
   gda_query_declare_condition( query, cond );

}


HB_FUNC( GDA_QUERY_UNDECLARE_CONDITION )
{
   GdaQuery *query = GDA_QUERY( hb_parnl( 1 ) );
   GdaQueryCondition *cond = GDA_QUERY_CONDITION( hb_parnl( 2 ) );
   
   gda_query_undeclare_condition( query, cond );

}


HB_FUNC( GDA_QUERY_SET_QUERY_TYPE )
{
   GdaQuery *query = GDA_QUERY( hb_parnl( 1 ) );
   gda_query_set_query_type( query, hb_parni( 2 ) );
}


HB_FUNC( GDA_QUERY_GET_QUERY_TYPE )
{
   GdaQuery *query = GDA_QUERY( hb_parnl( 1 ) );
   hb_retni( gda_query_get_query_type( query ) );
}


HB_FUNC( GDA_QUERY_GET_QUERY_TYPE_STRING )
{
   GdaQuery *query = GDA_QUERY( hb_parnl( 1 ) );
   hb_retc( gda_query_get_query_type_string( query ) );
}


HB_FUNC( GDA_QUERY_IS_SELECT_QUERY )
{
   GdaQuery *query = GDA_QUERY( hb_parnl( 1 ) );
   hb_retl( gda_query_is_select_query( query ) );
}


HB_FUNC( GDA_QUERY_IS_INSERT_QUERY )
{
   GdaQuery *query = GDA_QUERY( hb_parnl( 1 ) );
   hb_retl( gda_query_is_insert_query( query ) );
}


HB_FUNC( GDA_QUERY_IS_UPDATE_QUERY )
{
   GdaQuery *query = GDA_QUERY( hb_parnl( 1 ) );
   hb_retl( gda_query_is_update_query( query ) );
}


HB_FUNC( GDA_QUERY_IS_DELETE_QUERY )
{
   GdaQuery *query = GDA_QUERY( hb_parnl( 1 ) );
   hb_retl( gda_query_is_delete_query( query ) );
}


HB_FUNC( GDA_QUERY_IS_WELL_FORMED )
{
   GdaQuery *query = GDA_QUERY( hb_parnl( 1 ) );
   GdaParameterList *context = (GdaParameterList *)hb_parnl( 2 );
   GError *error = NULL;
   PHB_ITEM pError = hb_param( 3, HB_IT_ANY );

   hb_retl( gda_query_is_well_formed( query, context, &error ) );

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


HB_FUNC( GDA_QUERY_SET_SQL_TEXT )
{
   GdaQuery *query = GDA_QUERY( hb_parnl( 1 ) );
   const gchar *sql = hb_parc( 2 );
   GError *error = NULL;
   PHB_ITEM pError = hb_param( 3, HB_IT_ANY );
   
   gda_query_set_sql_text( query, sql, &error );

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


HB_FUNC( GDA_QUERY_GET_SQL_TEXT )
{
   GdaQuery *query = GDA_QUERY( hb_parnl( 1 ) );
   hb_retc( gda_query_get_sql_text( query ) );
}



/*  GDA_QUERY_TARGET */

HB_FUNC( GDA_QUERY_TARGET_NEW )
{
   GdaQuery *query = GDA_QUERY( hb_parnl( 1 ) );
   const gchar *table = hb_parc( 2 );
   hb_retnl( (glong) gda_query_target_new( query, table) );
}


HB_FUNC( GDA_QUERY_TARGET_NEW_COPY )
{
   GdaQueryTarget *target_orig = GDA_QUERY_TARGET( hb_parnl( 1 ) );
   hb_retnl( (glong) gda_query_target_new_copy( target_orig ) );
}


HB_FUNC( GDA_QUERY_TARGET_GET_QUERY )
{
   GdaQueryTarget *target = GDA_QUERY_TARGET( hb_parnl( 1 ) );
   hb_retnl( (glong) gda_query_target_get_query( target ) );
}


HB_FUNC( GDA_QUERY_TARGET_GET_REPRESENTED_TABLE_NAME )
{
   GdaQueryTarget *target = GDA_QUERY_TARGET( hb_parnl( 1 ) );
   hb_retc( gda_query_target_get_represented_table_name( target ) );
}


HB_FUNC( GDA_QUERY_TARGET_GET_REPRESENTED_ENTITY )
{
   GdaQueryTarget *target = GDA_QUERY_TARGET( hb_parnl( 1 ) );
   hb_retnl( (glong) gda_query_target_get_represented_entity( target ) );
}


HB_FUNC( GDA_QUERY_TARGET_SET_ALIAS )
{
   GdaQueryTarget *target = GDA_QUERY_TARGET( hb_parnl( 1 ) );
   const gchar *alias = hb_parc( 2 );
   
   gda_query_target_set_alias( target, alias );
}


HB_FUNC( GDA_QUERY_TARGET_GET_ALIAS )
{
   GdaQueryTarget *target = GDA_QUERY_TARGET( hb_parnl( 1 ) );

   hb_retc( gda_query_target_get_alias( target ) );
}


HB_FUNC( GDA_QUERY_TARGET_GET_COMPLETE_NAME )
{
   GdaQueryTarget *target = GDA_QUERY_TARGET( hb_parnl( 1 ) );

   hb_retc( gda_query_target_get_complete_name( target ) );
}

#endif

