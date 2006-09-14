/* $Id: glib.c,v 1.2 2006-09-14 14:22:23 rosenwla Exp $*/
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
    (c)2003 Rafael Carmona <thefull@wanadoo.es>
    (c)2003 Joaquim Ferrer <quim_ferrer@yahoo.es>
*/
/*
 * GLib. Soporte para timers.
 */

#include <gtk/gtk.h>

#ifdef __BETA__
#include <ctype.h>
#endif

#include "hbapi.h"
#include "hbvm.h"

// Atencion esto esta para mantener compatibilidad con xHarbour anteriores
// Deberá desaparecer , pero lo necesito ahora
#ifdef __OLDHARBOUR__
  HB_EXPORT PHB_SYMB hb_dynsymSymbol( PHB_DYNS pDynSym );
#endif

int time_harbour( gpointer data )
{
 PHB_DYNS pDynSym = hb_dynsymFindName( (gchar *) data );

 if( pDynSym )
   {
    hb_vmPushSymbol( hb_dynsymSymbol( pDynSym ) );     // Coloca simbolo en la pila
    hb_vmPushNil();
    hb_vmDo( 0 );
   }
   else
   {
     g_print( "Method doesn't %s exist en g_timeout_add", (gchar *)data );
     return FALSE;
   }
  return TRUE;

}

HB_FUNC( G_TIMEOUT_ADD ) // milisegundos, funcion
{
  gint interval = hb_parni( 1 );
  gchar * cFunc = hb_parc( 2 );
  hb_retni( g_timeout_add( interval, time_harbour, cFunc ) );
}

HB_FUNC( G_SOURCE_REMOVE )
{
  guint tag = hb_parni( 1 );
  hb_retl( g_source_remove( tag ) );
}

#ifdef __BETA__
HB_FUNC( G_KEY_FILE_NEW )
{
   GKeyFile * GKeyFile* g_key_file_new();
}

HB_FUNC( G_KEY_FILE_FREE )
{
   g_key_file_free((GKeyFile *) key_file);
}

HB_FUNC( G_KEY_FILE_SET_LIST_SEPARATOR )
{
   g_key_file_set_list_separator((GKeyFile *) hb_parnl( 1 ),
                                 (gchar) hb_parc( 2 ));
}

HB_FUNC( G_KEY_FILE_LOAD_FROM_FILE )
{
   GError * error = NULL;
   gboolean ret;

   if !( ret = g_key_file_load_from_file((GKeyFile *) hb_parnl( 1 ),
                                         (const gchar *) hb_parc( 2 ),
                                         (GKeyFileFlags) hb_parni( 3 ),
                                         &error) )
      g_print( "Error de apertura : %s", error->message );

   g_error_free (error);
   hb_retl( ret );
}

HB_FUNC( G_KEY_FILE_LOAD_FROM_DATA )
{
   GError * error = NULL;
   gboolean ret;

   if !( ret = g_key_file_load_from_data((GKeyFile *) hb_parnl( 1 ),
                                         (const gchar *) hb_parc( 2 ),
                                         (gsize) hb_parclen( 2 ),
                                         (GKeyFileFlags) hb_parni( 3 ),
                                         &error) )
      g_print( "Error de apertura : %s", error->message );

   g_error_free (error);
   hb_retl( ret );
}

HB_FUNC( G_KEY_FILE_LOAD_FROM_DATA_DIRS )
{
   GError * error = NULL;
   gboolean ret;

   if !( ret = g_key_file_load_from_data_dirs((GKeyFile *) hb_parnl( 1 ),
                                              (const gchar *) hb_parc( 2 ),
                                              (gchar **) hb_parc( 3 ),
                                              (GKeyFileFlags) hb_parni( 4 ),
                                              &error) )
      g_print( "Error de apertura : %s", error->message );

   g_error_free (error);
   hb_retl( ret );
}

HB_FUNC( G_KEY_FILE_TO_DATA )
{
   GError * error = NULL;
   gsize* ilen;
   gchar* ret;

   ret = g_key_file_to_data((GKeyFile *) hb_parnl( 1 ),
                                   &ilen,
                                   &error);
   if ( !error ){
      g_print( "Error de apertura : %s", error->message );
      g_error_free (error);
      return NULL;
      }

   hb_retclen( ret, (ULONG) ilen );
}

HB_FUNC( G_KEY_FILE_GET_START_GROUP )
{
   hb_retc( g_key_file_get_start_group((GKeyFile *) hb_parnl( 1 )) );
}

HB_FUNC( G_KEY_FILE_GET_GROUPS )
{
   gchar** ret;
   gsize * length;

   ret = g_key_file_get_groups((GKeyFile *) hb_parnl( 1 ),
                               &length);
   if !( length == NULL ){
      gulong ulLen = * length;
      gulong ulIndex;
      guint uiOffset, uiMemberSize;
      PHB_ITEM pRet = hb_itemArrayNew( ulLen );;
      PHB_ITEM element = hb_itemNew(NULL);

      uiOffset = 0;
      uiMemberSize = sizeof( gchar * );

      for( ulIndex = 0; ulIndex < ulLen; ulIndex++ ){
         if !( *( (gchar **) ( ret + uiOffset ) ) == NULL ){
            hb_itemPutC( element, *( (gchar **) ( ret + uiOffset ) ) );
            hb_itemArrayPut( pRet, ulIndex, element )
            }
         else
            break;
         uiOffset += uiMemberSize;
      }
      g_strfreev((gchar**) ret);
      hb_itemRelease( element );
      hb_itemForwardValue( &(HB_VM_STACK.Return), pRet );
      }
}

HB_FUNC( G_KEY_FILE_GET_KEYS )
{
   gchar** ret;
   gsize * length;
   GError * error = NULL;

   ret = g_key_file_get_keys((GKeyFile *) hb_parnl( 1 ),
                             (const gchar *) hb_parc( 2 ),
                             &length,
                             &error)
   if !( length == NULL ){
      gulong ulLen = * length;
      gulong ulIndex;
      guint uiOffset, uiMemberSize;
      PHB_ITEM pRet = hb_itemArrayNew( ulLen );;
      PHB_ITEM element = hb_itemNew(NULL);

      uiOffset = 0;
      uiMemberSize = sizeof( gchar * );

      for( ulIndex = 0; ulIndex < ulLen; ulIndex++ ){
         if !( *( (gchar **) ( ret + uiOffset ) ) == NULL ){
            hb_itemPutC( element, *( (gchar **) ( ret + uiOffset ) ) );
            hb_itemArrayPut( pRet, ulIndex, element )
            }
         else
            break;
         uiOffset += uiMemberSize;
      }
      g_strfreev((gchar**) ret);
      hb_itemRelease( element );
      hb_itemForwardValue( &(HB_VM_STACK.Return), pRet );
      }
   elseif !( error == NULL) {
      g_print( "Error de apertura : %s", error->message );
      g_error_free (error);
      }
}

HB_FUNC( G_KEY_FILE_HAS_GROUP )
{
   hb_retl( g_key_file_has_group((GKeyFile *) hb_parnl( 1 ),
                                 (const gchar *) hb_parc( 2 )) );
}

HB_FUNC( G_KEY_FILE_HAS_KEY )
{
   GError * error = NULL;
   gboolean ret;

   ret = g_key_file_has_key((GKeyFile *) hb_parnl( 1 ),
                            (const gchar *) hb_parc( 2 ),
                            (const gchar *) hb_parc( 3 ),
                            &error)
   if !( error == NULL ){
      g_print( "Error de apertura : %s", error->message );
      g_error_free (error);
      }
   hb_retl( ret );
}

HB_FUNC( G_KEY_FILE_GET_VALUE )
{
   GError * error = NULL;
   gchar* ret;

   ret = g_key_file_get_value((GKeyFile *) hb_parnl( 1 ),
                               (const gchar *) hb_parc( 2 ),
                               (const gchar *) hb_parc( 3 ),
                               &error);
   if ( ret == NULL ){
      g_print( "Error de apertura : %s", error->message );
      g_error_free (error);
      return;
      }
   hb_retc( ret );
}

HB_FUNC( G_KEY_FILE_GET_STRING )
{
   GError * error = NULL;
   gchar* ret;

   ret = g_key_file_get_string((GKeyFile *) hb_parnl( 1 ),
                                    (const gchar *) hb_parc( 2 ),
                                    (const gchar *) hb_parc( 3 ),
                                    &error);
   if !( ret == NULL )
      hb_retc( ret );
   elseif !( error == NULL ) {
      g_print( _("Error de apertura : %s"), error->message );
      g_error_free (error);
      }
}

HB_FUNC( G_KEY_FILE_GET_LOCALE_STRING )
{
   GError * error = NULL;
   gchar* ret;

   if !( ret = g_key_file_get_locale_string((GKeyFile *) hb_parnl( 1 ),
                                            (const gchar *) hb_parc( 2 ),
                                            (const gchar *) hb_parc( 3 ),
                                            (const gchar *) hb_parc( 4 ),
                                            &error) )
   if ( ret != NULL )
      hb_retc( ret );
   else if ( error != NULL ) {
      g_print( "Error de apertura : %s", error->message );
      g_error_free (error);
      }
}

HB_FUNC( G_KEY_FILE_GET_BOOLEAN )
{
   GError * error = NULL;
   gboolean ret;

   ret = g_key_file_get_boolean((GKeyFile *) hb_parnl( 1 ),
                                (const gchar *) hb_parc( 2 ),
                                (const gchar *) hb_parc( 3 ),
                                &error);

   if ( error != NULL ){
      g_print( _("Error de apertura : %s"), error->message );
      g_error_free( error );
      }
   hb_retl( ret );
}

HB_FUNC( G_KEY_FILE_GET_INTEGER )
{
   GError * error = NULL;
   gint ret;

   ret = g_key_file_get_integer((GKeyFile *) hb_parnl( 1 ),
                                (const gchar *) hb_parc( 2 ),
                                (const gchar *) hb_parc( 3 ),
                                &error);

   if ( error != NULL ){
      g_print( _("Error de apertura : %s"), error->message );
      g_error_free( error );
      }
   hb_retni( ret );
}

HB_FUNC( G_KEY_FILE_GET_DOUBLE )
{
   GError * error = NULL;
   gdouble ret;

   ret = g_key_file_get_double((GKeyFile *) hb_parnl( 1 ),
                                (const gchar *) hb_parc( 2 ),
                                (const gchar *) hb_parc( 3 ),
                                &error);
   if ( error != NULL ){
      g_print( _("Error de apertura : %s"), error->message );
      g_error_free( error );
      }
   hb_retnl( ret );
}

HB_FUNC( G_KEY_FILE_GET_STRING_LIST )
{
   gchar** ret;
   gsize length;
   GError * error = NULL;
   ret = g_key_file_get_string_list((GKeyFile *) hb_parnl( 1 ),
                                    (const gchar *) hb_parc( 2 ),
                                    (const gchar *) hb_parc( 3 ),
                                    &length,
                                    &error);
   if ( length != NULL ){
      gulong ulLen = * length;
      gulong ulIndex;
      guint uiOffset, uiMemberSize;
      PHB_ITEM pRet = hb_itemArrayNew( ulLen );
      PHB_ITEM element = hb_itemNew(NULL);

      uiOffset = 0;
      uiMemberSize = sizeof( gchar * );

      for( ulIndex = 0; ulIndex < ulLen; ulIndex++ ){
         if !( *( (gchar **) ( ret + uiOffset ) ) == NULL ){
            hb_itemPutC( element, *( (gchar **) ( ret + uiOffset ) ) );
            hb_itemArrayPut( pRet, ulIndex, element );
            }
         else
            break;
         uiOffset += uiMemberSize;
      }
      g_strfreev((gchar**) ret);
      hb_itemRelease( element );
      hb_itemForwardValue( &(HB_VM_STACK.Return), pRet );
      }
   else if ( error != NULL) {
      g_print( "Error de apertura : %s", error->message );
      g_error_free (error);
      }
}

HB_FUNC( G_KEY_FILE_GET_LOCALE_STRING_LIST )
{
   gchar** ret;
   gsize length;
   GError * error = NULL;
   ret = g_key_file_get_locale_string_list((GKeyFile *) hb_parnl( 1 ),
                                           (const gchar *) hb_parc( 2 ),
                                           (const gchar *) hb_parc( 3 ),
                                           (const gchar *) hb_parc( 4 ),
                                           &length,
                                           &error);
   if ( length != NULL ){
      gulong ulLen = * length;
      gulong ulIndex;
      guint uiOffset, uiMemberSize;
      PHB_ITEM pRet = hb_itemArrayNew( ulLen );;
      PHB_ITEM element = hb_itemNew(NULL);

      uiOffset = 0;
      uiMemberSize = sizeof( gchar * );

      for( ulIndex = 0; ulIndex < ulLen; ulIndex++ ){
         if !( *( (gchar **) ( ret + uiOffset ) ) == NULL ){
            hb_itemPutC( element, *( (gchar **) ( ret + uiOffset ) ) );
            hb_itemArrayPut( pRet, ulIndex, element );
            }
         else
            break;
         uiOffset += uiMemberSize;
      }
      g_strfreev((gchar**) ret);
      hb_itemRelease( element );
      hb_itemForwardValue( &(HB_VM_STACK.Return), pRet );
      }
   else if ( error != NULL) {
      g_print( "Error de apertura : %s", error->message );
      g_error_free (error);
      }
}

HB_FUNC( G_KEY_FILE_GET_BOOLEAN_LIST )
{
   gboolean* ret;
   gsize length;
   GError * error = NULL;
   ret = g_key_file_get_boolean_list((GKeyFile *) hb_parnl( 1 ),
                                     (const gchar *) hb_parc( 2 ),
                                     (const gchar *) hb_parc( 3 ),
                                     &length,
                                     &error);
   if ( length != NULL ){
      gulong ulLen = * length;
      gulong ulIndex;
      guint uiOffset, uiMemberSize;
      PHB_ITEM pRet = hb_itemArrayNew( ulLen );
      PHB_ITEM element = hb_itemNew(NULL);

      uiOffset = 0;
      uiMemberSize = sizeof( gboolean );

      for( ulIndex = 0; ulIndex < ulLen; ulIndex++ ){
            hb_itemPutL( element, *( (gboolean *) ( ret + uiOffset ) ) );
            hb_itemArrayPut( pRet, ulIndex, element );

         else
            break;
         uiOffset += uiMemberSize;
      }
      g_strfreev((gchar**) ret);
      hb_itemRelease( element );
      hb_itemForwardValue( &(HB_VM_STACK.Return), pRet );
      }
   else if ( error != NULL) {
      g_print( "Error de apertura : %s", error->message );
      g_error_free (error);
      }
}

HB_FUNC( G_KEY_FILE_GET_INTEGER_LIST )
{
   gint* ret;
   gsize length;
   GError * error = NULL;
   ret = g_key_file_get_integer_list((GKeyFile *) hb_parnl( 1 ),
                                     (const gchar *) hb_parc( 2 ),
                                     (const gchar *) hb_parc( 3 ),
                                     &length,
                                     &error);
   if ( length != NULL ){
      gulong ulLen = * length;
      gulong ulIndex;
      guint uiOffset, uiMemberSize;
      PHB_ITEM pRet = hb_itemArrayNew( ulLen );
      PHB_ITEM element = hb_itemNew(NULL);

      uiOffset = 0;
      uiMemberSize = sizeof( gint );

      for( ulIndex = 0; ulIndex < ulLen; ulIndex++ ){
            hb_itemPutL( element, *( (gint *) ( ret + uiOffset ) ) );
            hb_itemArrayPut( pRet, ulIndex, element );

         else
            break;
         uiOffset += uiMemberSize;
      }
      g_strfreev((gchar**) ret);
      hb_itemRelease( element );
      hb_itemForwardValue( &(HB_VM_STACK.Return), pRet );
      }
   else if ( error != NULL ) {
      g_print( "Error de apertura : %s", error->message );
      g_error_free (error);
      }
}

HB_FUNC( G_KEY_FILE_GET_DOUBLE_LIST )
{
   gdouble* ret;
   gsize length;
   GError * error = NULL;

   ret = g_key_file_get_double_list((GKeyFile *) hb_parnl( 1 ),
                                     (const gchar *) hb_parc( 2 ),
                                     (const gchar *) hb_parc( 3 ),
                                     &length,
                                     &error);
   if ( length != NULL ){
      gulong ulLen = * length;
      gulong ulIndex;
      guint uiOffset, uiMemberSize;
      PHB_ITEM pRet = hb_itemArrayNew( ulLen );
      PHB_ITEM element = hb_itemNew(NULL);

      uiOffset = 0;
      uiMemberSize = sizeof( gdouble );

      for( ulIndex = 0; ulIndex < ulLen; ulIndex++ ){
         hb_itemPutL( element, *( (gdouble *) ( ret + uiOffset ) ) );
         hb_itemArrayPut( pRet, ulIndex, element );
         uiOffset += uiMemberSize;
      }
      hb_itemRelease( element );
      hb_itemForwardValue( &(HB_VM_STACK.Return), pRet );
      }
   else if ( error != NULL) {
      g_print( "Error de apertura : %s", error->message );
      g_error_free (error);
      }
}

HB_FUNC( G_KEY_FILE_GET_COMMENT )
{
   gchar* ret;
   GError * error = NULL;

   ret = g_key_file_get_comment((GKeyFile *) hb_parnl( 1 ),
                                     (const gchar *) hb_parc( 2 ),
                                     (const gchar *) hb_parc( 3 ),
                                     &error);
   if ( error != NULL ) {
      g_print( "Error de apertura : %s", error->message );
      g_error_free(error);
      }
   hb_retc((char*) ret );
   g_free( ret );
}

HB_FUNC( G_KEY_FILE_SET_VALUE )
{
   if ( !ISNIL( 4 ) )
   g_key_file_set_value((GKeyFile *) hb_parnl( 1 ),
                        (const gchar *) hb_parc( 2 ),
                        (const gchar *) hb_parc( 3 ),
                        (const gchar *) hb_parc( 4 ));
}

HB_FUNC( G_KEY_FILE_SET_STRING )
{
   if ( !ISNIL( 4 ) )
   g_key_file_set_string((GKeyFile *) hb_parnl( 1 ),
                        (const gchar *) hb_parc( 2 ),
                        (const gchar *) hb_parc( 3 ),
                        (const gchar *) hb_parc( 4 ));
}

HB_FUNC( G_KEY_FILE_SET_LOCALE_STRING )
{
   if ( !ISNIL( 5 ) )
   g_key_file_set_locale_string((GKeyFile *) hb_parnl( 1 ),
                                (const gchar *) hb_parc( 2 ),
                                (const gchar *) hb_parc( 3 ),
                                (const gchar *) hb_parc( 4 ),
                                (const gchar *) hb_parc( 5 ));
}

HB_FUNC( G_KEY_FILE_SET_BOOLEAN )
{
   if ( !ISNIL( 4 ) )
   g_key_file_set_boolean((GKeyFile *) hb_parnl( 1 ),
                          (const gchar *) hb_parc( 2 ),
                          (const gchar *) hb_parc( 3 ),
                          (gboolean) hb_parl( 4 ));
}

HB_FUNC( G_KEY_FILE_SET_INTEGER )
{
   if ( !ISNIL( 4 ) )
   g_key_file_set_integer((GKeyFile *) hb_parnl( 1 ),
                          (const gchar *) hb_parc( 2 ),
                          (const gchar *) hb_parc( 3 ),
                          (gint) hb_parni( 4 ));
}

HB_FUNC( G_KEY_FILE_SET_DOUBLE )
{
   if ( !ISNIL( 4 ) )
   g_key_file_set_double((GKeyFile *) hb_parnl( 1 ),
                         (const gchar *) hb_parc( 2 ),
                         (const gchar *) hb_parc( 3 ),
                         (gdouble) hb_parnl( 4 ));
}

HB_FUNC( G_KEY_FILE_SET_STRING_LIST )
{
   PHB_ITEM pList = hb_param( 4, HB_IT_ARRAY );
   PHB_BASEARRAY pBaseVar = pList->item.asArray.value;;
   guint uiMemberSize = sizeof( gchar * );
   gchar * list;
   gulong ulIndex, ulLen, uiOffset;
   gsize length = 0;

   uiOffset = 0;
   ulLen = pBaseVar->ulLen;

   for( ulIndex = 0; ulIndex < ulLen; ulIndex++ ){
   if ( ( pBaseVar->pItems + ulIndex  )->type
         && ( pBaseVar->pItems + ulIndex  )->type == HB_IT_STRING
         && ( pBaseVar->pItems + ulIndex  )->item.asInteger.value == CTYPE_CHAR ){
         if ( ulIndex == 0 )
               list = g_new0( gchar, ulIndex+1 );
            else
               list = g_renew( gchar, list, ulIndex+1 );
         g_stpcpy((gchar *) ( list + uiOffset ), (const gchar *) ( ( pBaseVar->pItems + ulIndex  )->item.asInteger.value ));
         length++;
         uiOffset += uiMemberSize;
         }
   }
   if ( length != 0 ){
//      list = g_renew( gchar *, list, uiMemberSize+uiOffset+1 );
//      list[uiMemberSize+uiOffset+1] = NULL;
      g_key_file_set_string_list((GKeyFile *) hb_parnl( 1 ),
                                 (const gchar *) hb_parc( 2 ),
                                 (const gchar *) hb_parc( 3 ),
                                 (const gchar * const) list,
                                 (gsize) length);
      g_strfreev((gchar **) list);
      }
}

HB_FUNC( G_KEY_FILE_SET_LOCALE_STRING_LIST )
{
   PHB_ITEM pList = hb_param( 5, HB_IT_ARRAY );
   PHB_BASEARRAY pBaseVar = pList->item.asArray.value;;
   guint uiMemberSize = sizeof( gchar * );
   gchar * list;
   gulong ulIndex, ulLen, uiOffset;
   gsize length = 0;

   uiOffset = 0;
   ulLen = pBaseVar->ulLen;

   for( ulIndex = 0; ulIndex < ulLen; ulIndex++ ){
   if ( ( pBaseVar->pItems + ulIndex  )->type
         && ( pBaseVar->pItems + ulIndex  )->type == HB_IT_STRING
         && ( pBaseVar->pItems + ulIndex  )->item.asInteger.value == CTYPE_CHAR ){
         if ( ulIndex == 0 )
               list = g_new0( gchar, ulIndex+1 );
            else
               list = g_renew( gchar, list, ulIndex+1 );
         g_stpcpy((gchar *) ( list + uiOffset ), (const gchar *) ( ( pBaseVar->pItems + ulIndex  )->item.asInteger.value ));
         length++;
         uiOffset += uiMemberSize;
         }
   }
   if ( length != 0 ){
//      list = g_renew( gchar *, list, uiOffset+1 );
//      *( (const gchar *) ( list + 1 ) ) = NULL;
      g_key_file_set_locale_string_list((GKeyFile *) hb_parnl( 1 ),
                                        (const gchar *) hb_parc( 2 ),
                                        (const gchar *) hb_parc( 3 ),
                                        (const gchar *) hb_parc( 4 ),
                                        (const gchar * const) list,
                                        (gsize) length);
      g_strfreev((gchar **) list);
      }
}

HB_FUNC( G_KEY_FILE_SET_BOOLEAN_LIST )
{
   PHB_ITEM pList = hb_param( 4, HB_IT_ARRAY );
   PHB_BASEARRAY pBaseVar = pList->item.asArray.value;;
   guint uiMemberSize = sizeof(gboolean);
   gboolean * list;
   gulong ulIndex, ulLen, uiOffset;
   gsize length = 0;

   uiOffset = 0;
   ulLen = pBaseVar->ulLen;

   for( ulIndex = 0; ulIndex < ulLen; ulIndex++ ){
   if ( ( pBaseVar->pItems + ulIndex  )->type
         && ( pBaseVar->pItems + ulIndex  )->type == HB_IT_LOGICAL ){
         if ( ulIndex == 0 )
               list = g_new0( gboolean, uiMemberSize );
            else
               list = g_renew( gboolean, list, uiMemberSize+uiOffset );
         *( (gboolean *) ( list + uiOffset ) ) = (gboolean) ( pBaseVar->pItems + ulIndex  )->item.asLogical.value;
         length++;
         uiOffset += uiMemberSize;
         }
   }
   if ( length != 0 )
   g_key_file_set_boolean_list((GKeyFile *) hb_parnl( 1 ),
                               (const gchar *) hb_parc( 2 ),
                               (const gchar *) hb_parc( 3 ),
                               list,
                               (gsize) length);
}

HB_FUNC( G_KEY_FILE_SET_INTEGER_LIST )
{
   PHB_ITEM pList = hb_param( 4, HB_IT_ARRAY );
   PHB_BASEARRAY pBaseVar = pList->item.asArray.value;;
   guint uiMemberSize = sizeof(gint);
   gint * list;
   gulong ulIndex, ulLen, uiOffset;
   gsize length = 0;

   uiOffset = 0;
   ulLen = pBaseVar->ulLen;

   for( ulIndex = 0; ulIndex < ulLen; ulIndex++ ){
   if ( ( pBaseVar->pItems + ulIndex  )->type
         && ( pBaseVar->pItems + ulIndex  )->type == HB_IT_INTEGER ){
         if ( ulIndex == 0 )
               list = g_new0( gint, uiMemberSize );
            else
               list = g_renew( gint, list, uiMemberSize+uiOffset );
         *( (gint *) ( list + uiOffset ) )  = (gint) ( pBaseVar->pItems + ulIndex  )->item.asInteger.value;
         length++;
         uiOffset += uiMemberSize;
         }
   }
   if ( length != 0 )
   g_key_file_set_integer_list((GKeyFile *) hb_parnl( 1 ),
                               (const gchar *) hb_parc( 2 ),
                               (const gchar *) hb_parc( 3 ),
                               list,
                               (gsize) length);
}

HB_FUNC( G_KEY_FILE_SET_DOUBLE_LIST )
{
   PHB_ITEM pList = hb_param( 5, HB_IT_ARRAY );
   PHB_BASEARRAY pBaseVar = pList->item.asArray.value;;
   guint uiMemberSize = sizeof(gint);
   gdouble * list;
   gulong ulIndex, ulLen, uiOffset;
   gsize length = 0;

   uiOffset = 0;
   ulLen = pBaseVar->ulLen;

   for( ulIndex = 0; ulIndex < ulLen; ulIndex++ ){
   if ( ( pBaseVar->pItems + ulIndex  )->type
         && ( pBaseVar->pItems + ulIndex  )->type == HB_IT_INTEGER ){
         if ( ulIndex == 0 )
               list = g_new0( gdouble, uiMemberSize );
            else
               list = g_renew( gdouble, list, uiMemberSize+uiOffset );
         *( (gdouble *) ( list + uiOffset ) )  = (gdouble) ( ( pBaseVar->pItems + ulIndex  )->item.asDouble.value );
         length++;
         uiOffset += uiMemberSize;
         }
   }
   if ( length != 0 )
      g_key_file_set_double_list((GKeyFile *) hb_parnl( 1 ),
                                 (const gchar *) hb_parc( 2 ),
                                 (const gchar *) hb_parc( 3 ),
                                 list,
                                 (gsize) length);
}

HB_FUNC( G_KEY_FILE_SET_COMMENT )
{
   GError * error = NULL;

   g_key_file_set_comment((GKeyFile *) hb_parnl( 1 ),
                          (const gchar *) hb_parc( 2 ),
                          (const gchar *) hb_parc( 3 ),
                          (const gchar *) hb_parc( 4 ),
                          &error);
   if ( !error ){
      g_print( "Error de apertura : %s", error->message );
      g_error_free (error);
      }

}

HB_FUNC( G_KEY_FILE_REMOVE_GROUP )
{
   GError * error = NULL;

   g_key_file_remove_group((GKeyFile *) hb_parnl( 1 ),
                           (const gchar *) hb_parc( 2 ),
                           &error);
   if ( !error ){
      g_print( "Error de apertura : %s", error->message );
      g_error_free (error);
      }
}

HB_FUNC( G_KEY_FILE_REMOVE_KEY )
{
   GError * error = NULL;

   g_key_file_remove_key((GKeyFile *) hb_parnl( 1 ),
                         (const gchar *) hb_parc( 2 ),
                         (const gchar *) hb_parc( 3 ),
                         &error);
   if ( !error ){
      g_print( "Error de apertura : %s", error->message );
      g_error_free (error);
      }
}

HB_FUNC( G_KEY_FILE_REMOVE_COMMENT )
{
   GError * error = NULL;

   g_key_file_remove_comment((GKeyFile *) hb_parnl( 1 ),
                         (const gchar *) hb_parc( 2 ),
                         (const gchar *) hb_parc( 3 ),
                         &error);
   if ( !error ){
      g_print( "Error de apertura : %s", error->message );
      g_error_free(error);
      }
}
#endif
