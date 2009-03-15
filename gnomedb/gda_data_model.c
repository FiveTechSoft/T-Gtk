/* $Id: gda_data_model.c,v 1.4 2009-03-15 17:10:16 riztan Exp $*/
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
  gda_data_model_get_access_flags()
  gda_data_model_get_value_at_col_name ()  
  gda_data_model_send_hint ()  
  gda_data_model_import_from_model ()  
  gda_data_model_import_from_string ()
  gda_data_model_import_from_file ()
  
  
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

/*
HB_FUNC( GDA_DATA_MODEL_ROW_INSERTED )
{
   GdaDataModel *model = GDA_DATA_MODEL( hb_parnl( 1 ) );
   gint row = GDA2HB_VECTOR(hb_parni( 2 ));
   
   gda_data_model_row_inserted(model, row);
}
*/


HB_FUNC( GDA_DATA_MODEL_FREEZE )
{
   GdaDataModel *model = GDA_DATA_MODEL( hb_parnl( 1 ) );
   gda_data_model_freeze(model);
}


HB_FUNC( GDA_DATA_MODEL_THAW )
{
   GdaDataModel *model = GDA_DATA_MODEL( hb_parnl( 1 ) );
   gda_data_model_thaw(model);
}


HB_FUNC( GDA_DATA_MODEL_GET_N_ROWS )
{
   GdaDataModel *model = GDA_DATA_MODEL( hb_parnl( 1 ) );
   hb_retnl( (glong) gda_data_model_get_n_rows(model) );
}


HB_FUNC( GDA_DATA_MODEL_GET_N_COLUMNS )
{
   GdaDataModel *model = GDA_DATA_MODEL( hb_parnl( 1 ) );
   hb_retnl( (glong) gda_data_model_get_n_columns(model) );
}


HB_FUNC( GDA_DATA_MODEL_DESCRIBE_COLUMN )
{
   GdaDataModel *model = GDA_DATA_MODEL( hb_parnl( 1 ) );
   gint col = GDA2HB_VECTOR(hb_parni( 2 ));
   
   hb_retnl( (glong) gda_data_model_describe_column(model, col) );
}


HB_FUNC( GDA_DATA_MODEL_GET_COLUMN_INDEX_BY_NAME )
{
   GdaDataModel *model = GDA_DATA_MODEL( hb_parnl( 1 ) );
   const gchar *name = hb_parc( 2 );
   
   hb_retni( gda_data_model_get_column_index_by_name(model, name) );
}


HB_FUNC( GDA_DATA_MODEL_GET_COLUMN_TITLE )
{
   GdaDataModel *model = GDA_DATA_MODEL( hb_parnl( 1 ) );
   gint col = GDA2HB_VECTOR( hb_parni( 2 ) );

   hb_retc( gda_data_model_get_column_title(model, col) );
}


HB_FUNC( GDA_DATA_MODEL_SET_COLUMN_TITLE )
{
   GdaDataModel *model = GDA_DATA_MODEL( hb_parnl( 1 ) );
   gint col = GDA2HB_VECTOR( hb_parni( 2 ) );
   const gchar *title = hb_parc( 3 );

   gda_data_model_set_column_title(model, col, title);
}


HB_FUNC( GDA_DATA_MODEL_GET_ATTRIBUTES_AT )
{
   GdaDataModel *model = GDA_DATA_MODEL( hb_parnl( 1 ) );
   gint col = GDA2HB_VECTOR( hb_parni( 2 ) );
   gint row = GDA2HB_VECTOR( hb_parni( 3 ) );

   hb_retni( gda_data_model_get_attributes_at( model, col, row ) );
}


HB_FUNC( GDA_DATA_MODEL_GET_VALUE_AT )
{
   GdaDataModel *model = GDA_DATA_MODEL( hb_parnl( 1 ) );
   gint col = GDA2HB_VECTOR( hb_parni( 2 ) );
   gint row = GDA2HB_VECTOR( hb_parni( 3 ) );
   const GValue *value =  gda_data_model_get_value_at( model, col, row );
   
   hb_retptr( (GValue *) value );
}

//g_strdup_value_contents 
//HB_FUNC( G_STRDUP_VALUE_CONTENTS )
//{
//   const GValue *value = hb_param( 1, HB_IT_ANY );
//   hb_retc( g_strdup_value_contents(value) );
//}


// HB_FUNC( GDA_VALUE_HOLDS_TIMESTAMP(value) )
// HB_FUNC( GDA_VALUE_ISA() )
/*
HB_FUNC( GDA_VALUE_TO_XML )
{
   const GValue *value = hb_parptr( 1 );
   hb_retptr( gda_value_to_xml(value) );
}
*/



HB_FUNC( GDA_DATA_MODEL_SET_VALUE_AT )
{
   GdaDataModel *model = GDA_DATA_MODEL( hb_parnl( 1 ) );
   gint col = GDA2HB_VECTOR( hb_parni( 2 ) );
   gint row = GDA2HB_VECTOR( hb_parni( 3 ) );
   const GValue *value = (GValue *) hb_parptr( 4 );
   
   PHB_ITEM pError = hb_param( 5, HB_IT_ANY );
   GError *error = NULL;
   
  
   hb_retl( gda_data_model_set_value_at(model, col, row, value, &error)   );

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
   
   hb_itemRelease( pError );

}

/*
   GdaDataModel *model = GDA_DATA_MODEL( hb_parnl( 1 ) );
   gint col = GDA2HB_VECTOR( hb_parni( 2 ) );
   gint row = GDA2HB_VECTOR( hb_parni( 3 ) );
   const GValue *value =  gda_data_model_get_value_at( model, col, row );
   
   hb_retptr( (GValue *) value );
*/


HB_FUNC( GDA_DATA_MODEL_CREATE_ITER )
{
   GdaDataModel *model = GDA_DATA_MODEL( hb_parnl( 1 ) );
   hb_retnl( (glong) gda_data_model_create_iter(model) );
}


HB_FUNC( GDA_DATA_MODEL_APPEND_VALUES )
{
   GdaDataModel *model = GDA_DATA_MODEL( hb_parnl( 1 ) );
   const GList *values = hb_parptr( 2 );
   PHB_ITEM pError = hb_param( 3, HB_IT_ANY );
   GError *error = NULL;

   hb_retni( gda_data_model_append_values(model, values, &error) );

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


HB_FUNC( GDA_DATA_MODEL_APPEND_ROW )
{
   GdaDataModel *model = GDA_DATA_MODEL( hb_parnl( 1 ) );
   PHB_ITEM pError = hb_param( 2, HB_IT_ANY );
   GError *error = NULL;

   hb_retni( gda_data_model_append_row(model, &error) );

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
   
   hb_itemRelease( pError );
}


HB_FUNC( GDA_DATA_MODEL_REMOVE_ROW )
{
   GdaDataModel *model = GDA_DATA_MODEL( hb_parnl( 1 ) );
   gint row = GDA2HB_VECTOR( hb_parni( 2 ) );
   PHB_ITEM pError = hb_param( 3, HB_IT_ANY );
   GError *error = NULL;

   hb_retl( gda_data_model_remove_row(model, row, &error) );

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
   
   hb_itemRelease( pError );
}

/*
HB_FUNC( GDA_DATA_MODEL_GET_ROW_FROM_VALUES )
{
   GdaDataModel *model = GDA_DATA_MODEL( hb_parnl( 1 ) );
   GList *values = hb_parptr( 2 );
   gint cols_index = hb_parni( 3 );
   
   hb_retni( gda_data_model_get_row_from_values(model, values, cols_index) );
}
*/

/*
HB_FUNC( GDA_DATA_MODEL_EXPORT_TO_STRING )
{
   GdaDataModel *model = GDA_DATA_MODEL( hb_parnl( 1 ) );
   GdaDataModelIOFormat format = hb_parni( 2 );
   const gint *cols = hb_parni ( 3 );  // debe ser un arreglo
   gint nb_cols = hb_parni( 4 ) ;
   const gint *rows = hb_parni( 5 );   // debe ser un arreglo
   gint nb_rows = hb_parni( 6 );
   GdaParameterList *options = (GdaParameterList *)hb_parnl( 7 );
   
   hb_retc( gda_data_model_export_to_string(model, format, cols, 
            nb_cols, rows,nb_rows ,options) );
}
*/

/*
HB_FUNC( GDA_DATA_MODEL_EXPORT_TO_FILE )
{
   GdaDataModel *model = GDA_DATA_MODEL( hb_parnl( 1 ) );
   GdaDataModelIOFormat format = hb_parni( 2 );
   const gchar *file = hb_parc( 3 );
   const gint *cols = hb_param( 4 );    // Debe ser un arreglo
   gint nb_cols = hb_parni( 5 );
   const gint *rows = hb_parni( 6 );    // Debe ser un arreglo 
   gint nb_rows = hb_parni( 7 );
   GdaParameterList *options = (GdaParameterList *)hb_parnl( 8 );
   PHB_ITEM pError = hb_param( 9, HB_IT_ANY );
   GError *error = NULL;

   hb_retl( gda_data_model_export_to_file(model, format, 
                                          file, cols, nb_cols,
                                          rows, nb_rows, options, &error) );

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
   
   hb_itemRelease( pError );

}
*/

/*
HB_FUNC( GDA_DATA_MODEL_ADD_DATA_FROM_XML_NODE )
{
   GdaDataModel *model = GDA_DATA_MODEL( hb_parnl( 1 ) );
   xmlNodePtr node = hb_param( 2, HB_IT_ANY ); // Intento por recibir un arreglo.
   PHB_ITEM pError = hb_param( 9, HB_IT_ANY );
   GError *error = NULL;

   hb_retl( gda_data_model_add_data_from_xml_node(model, node, &error) );

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
   
   hb_itemRelease( pError );
}
*/


HB_FUNC( GDA_DATA_MODEL_DUMP )
{
   GdaDataModel *model = GDA_DATA_MODEL( hb_parnl( 1 ) );
   FILE *to_stream;
   
   gda_data_model_dump( model, to_stream );
}


HB_FUNC( GDA_DATA_MODEL_DUMP_AS_STRING )
{
   GdaDataModel *model = GDA_DATA_MODEL( hb_parnl( 1 ) );

   hb_retc( gda_data_model_dump_as_string(model) );
}



/* GdaDataModelIter*/

HB_FUNC( GDA_DATA_MODEL_ITER_NEW )
{
   GdaDataModel *model = GDA_DATA_MODEL( hb_parnl( 1 ) );

   hb_retnl( (glong) gda_data_model_iter_new(model) );
}


HB_FUNC( GDA_DATA_MODEL_ITER_IS_VALID )
{
   GdaDataModelIter *iter = GDA_DATA_MODEL_ITER( hb_parnl( 1 ) );
   hb_retl( gda_data_model_iter_is_valid(iter) );
}


HB_FUNC( GDA_DATA_MODEL_ITER_SET_AT_ROW )
{
   GdaDataModelIter *iter = GDA_DATA_MODEL_ITER( hb_parnl( 1 ) );
   gint row = GDA2HB_VECTOR( hb_parni( 2 ) );

   hb_retl( gda_data_model_iter_set_at_row(iter, row) );
}


HB_FUNC( GDA_DATA_MODEL_ITER_MOVE_NEXT )
{
   GdaDataModelIter *iter = GDA_DATA_MODEL_ITER( hb_parnl( 1 ) );
   hb_retl(  gda_data_model_iter_move_next(iter) );
}


HB_FUNC( GDA_DATA_MODEL_ITER_MOVE_PREV )
{
   GdaDataModelIter *iter = GDA_DATA_MODEL_ITER( hb_parnl( 1 ) );
   hb_retl(  gda_data_model_iter_move_prev(iter) );
}


HB_FUNC( GDA_DATA_MODEL_ITER_GET_ROW )
{
   GdaDataModelIter *iter = GDA_DATA_MODEL_ITER( hb_parnl( 1 ) );
   hb_retni( gda_data_model_iter_get_row(iter) );
}


HB_FUNC( GDA_DATA_MODEL_ITER_INVALIDATE_CONTENTS )
{
   GdaDataModelIter *iter = GDA_DATA_MODEL_ITER( hb_parnl( 1 ) );
   gda_data_model_iter_invalidate_contents(iter);
}


HB_FUNC( GDA_DATA_MODEL_ITER_GET_COLUMN_FOR_PARAM )
{
   GdaDataModelIter *iter = GDA_DATA_MODEL_ITER( hb_parnl( 1 ) );
   GdaParameter *param = GDA_PARAMETER( hb_parnl( 2 ) );
   hb_retni( gda_data_model_iter_get_column_for_param(iter, param) );
}


HB_FUNC( GDA_DATA_MODEL_ITER_GET_PARAM_FOR_COLUMN )
{
   GdaDataModelIter *iter = GDA_DATA_MODEL_ITER( hb_parnl( 1 ) );
   gint col = GDA2HB_VECTOR( hb_parni( 2 ) );
   hb_retnl( (glong) gda_data_model_iter_get_param_for_column(iter,col) );
}

#endif

