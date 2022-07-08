/* $Id: gtktextbuffer.c,v 1.2 2010-05-26 10:15:03 xthefull Exp $*/
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
 
 /* NOTA:
  * Pasamos la responsabilidad AL PROGRAMADOR, la cadena ya tiene que venir montada:
  * gchar * text = g_convert( hb_parc( 2 ), -1,"UTF-8","ISO-8859-1",NULL,NULL,NULL );*/

#include <gtk/gtk.h>
#include "hbapi.h"
#include "hbapiitm.h"
#include "t-gtk.h"

PHB_ITEM IterText2Array( GtkTextIter *iter  );
BOOL Array2IterText(PHB_ITEM aIter, GtkTextIter *iter  );

HB_FUNC( GTK_TEXT_BUFFER_NEW )
{
   hb_retptr( ( GtkTextBuffer * ) gtk_text_buffer_new( NULL ) ); //TODO: Implementar GtkTextTagTable
}

 HB_FUNC( GTK_TEXT_BUFFER_SET_TEXT ) //  nBuffer -> void
{
  GtkTextBuffer * buffer = GTK_TEXT_BUFFER( hb_parptr( 1 ) );
  gchar * text =  str2utf8( ( gchar * ) hb_parc( 2 ) );
  gtk_text_buffer_set_text( buffer, text, -1);
  SAFE_RELEASE( text );
  hb_retptr( ( GtkTextBuffer * ) buffer );
}

HB_FUNC( GTK_TEXT_BUFFER_INSERT )
{
  GtkTextBuffer * buffer = GTK_TEXT_BUFFER( hb_parptr( 1 ) );
  GtkTextIter iter;
  PHB_ITEM pIter = hb_param( 2, HB_IT_ARRAY );
  const gchar * text = (gchar *) hb_parc( 3 );
  gint len = hb_parni( 4 ); 

  if ( Array2IterText( pIter, &iter ) )
  {
    gtk_text_buffer_insert( buffer, &iter, text, len );
  }
}

HB_FUNC( GTK_TEXT_BUFFER_INSERT_AT_CURSOR ) //  pBuffer, text , nlen-> void
{
  GtkTextBuffer * buffer = GTK_TEXT_BUFFER( hb_parptr( 1 ) );
  gchar * text =  str2utf8( ( gchar * ) hb_parc( 2 ) );
  gtk_text_buffer_insert_at_cursor( buffer, text, ( ISNIL( 3 ) ? -1 : hb_parni( 3 ) ) );
  SAFE_RELEASE( text );
}

HB_FUNC( HB_GTK_TEXT_BUFFER_GET_TEXT )
{
  GtkTextBuffer * buffer = GTK_TEXT_BUFFER( hb_parptr( 1 ) );
  GtkTextIter start, end;
  gchar * char_buffer;
   
  gtk_text_buffer_get_iter_at_offset( buffer, &start, 0 );
  gtk_text_buffer_get_iter_at_offset( buffer, &end,  -1 );
  char_buffer = gtk_text_buffer_get_text( buffer, &start, &end, 0 );
  
  hb_retc( char_buffer );
}

HB_FUNC( GTK_TEXT_BUFFER_GET_LINE_COUNT )
{
  GtkTextBuffer * buffer = GTK_TEXT_BUFFER( hb_parptr( 1 ) );
  gint iCount;
  iCount = gtk_text_buffer_get_line_count( buffer );
  hb_retni( iCount );
}

/*
 * Ojo, en C se le pueden pasar todos los parametros que se quieran,
 * pero desde aqui nos limitaremos a de momento 4 elementos
 */
HB_FUNC( GTK_TEXT_BUFFER_CREATE_TAG ) //  pBuffer,name_Tag, first property,...->pTag
{
  GtkTextTag * tag = NULL;
  GtkTextBuffer * buffer = GTK_TEXT_BUFFER( hb_parptr( 1 ) );
  gchar * tag_1 =  (gchar *) hb_parc( 2 );
  gchar * tag_2 =  (gchar *) hb_parc( 3 );
  gchar * tag_n =  (gchar *) hb_parc( 4 );
  tag = gtk_text_buffer_create_tag( buffer, tag_1, tag_2, tag_n, NULL );
  hb_retptr( ( GtkTextTag * ) tag );
}

HB_FUNC( GTK_TEXT_BUFFER_APPLY_TAG ) //  buffer, tag, aStart, aEnd
{
  GtkTextBuffer * buffer = GTK_TEXT_BUFFER( hb_parptr( 1 ) );
  GtkTextTag    * tag    = GTK_TEXT_TAG( hb_parptr( 2 ) );
  GtkTextIter start,end;
  PHB_ITEM pStart = hb_param( 3, HB_IT_ARRAY );
  PHB_ITEM pEnd = hb_param( 4, HB_IT_ARRAY );

  if ( Array2IterText( pStart, &start ) )
  {
    if ( Array2IterText( pEnd, &end ) )
    {
      gtk_text_buffer_apply_tag( buffer, tag, &start,&end );
      hb_storptr( (gpointer) (start.dummy1 ), 3,  1 );
      hb_storptr( (gpointer) (start.dummy2 ), 3,  2 );
      hb_storni(  (gint    ) (start.dummy3 ), 3,  3 );
      hb_storni(  (gint    ) (start.dummy4 ), 3,  4 );
      hb_storni(  (gint    ) (start.dummy5 ), 3,  5 );
      hb_storni(  (gint    ) (start.dummy6 ), 3,  6 );
      hb_storni(  (gint    ) (start.dummy7 ), 3,  7 );
      hb_storni(  (gint    ) (start.dummy8 ), 3,  8 );
      hb_storptr( (gpointer) (start.dummy9 ), 3,  9 );
      hb_storptr( (gpointer) (start.dummy10), 3, 10 );
      hb_storni(  (gint    ) (start.dummy11), 3, 11 );
      hb_storni(  (gint    ) (start.dummy12), 3, 12 );
      hb_storni(  (gint    ) (start.dummy13), 3, 13 );
      hb_storptr( (gpointer) (start.dummy14), 3, 14 );
      
      hb_storptr( (gpointer) (end.dummy1 ), 4,  1 );
      hb_storptr( (gpointer) (end.dummy2 ), 4,  2 );
      hb_storni(  (gint    ) (end.dummy3 ), 4,  3 );
      hb_storni(  (gint    ) (end.dummy4 ), 4,  4 );
      hb_storni(  (gint    ) (end.dummy5 ), 4,  5 );
      hb_storni(  (gint    ) (end.dummy6 ), 4,  6 );
      hb_storni(  (gint    ) (end.dummy7 ), 4,  7 );
      hb_storni(  (gint    ) (end.dummy8 ), 4,  8 );
      hb_storptr( (gpointer) (end.dummy9 ), 4,  9 );
      hb_storptr( (gpointer) (end.dummy10), 4, 10 );
      hb_storni(  (gint    ) (end.dummy11), 4, 11 );
      hb_storni(  (gint    ) (end.dummy12), 4, 12 );
      hb_storni(  (gint    ) (end.dummy13), 4, 13 );
      hb_storptr( (gpointer) (end.dummy14), 4, 14 );
    }
  }
}

HB_FUNC( GTK_TEXT_BUFFER_APPLY_TAG_BY_NAME ) //  buffer, name , &start, &end
{
  GtkTextBuffer * buffer = GTK_TEXT_BUFFER( hb_parptr( 1 ) );
  gchar * name = (gchar*) hb_parc( 2 );
  PHB_ITEM pStart = hb_param( 3, HB_IT_ARRAY );
  PHB_ITEM pEnd = hb_param( 4, HB_IT_ARRAY );
  GtkTextIter start, end;
  
  if ( Array2IterText( pStart, &start ) )
  {
    if ( Array2IterText( pEnd, &end ) )
    {
      gtk_text_buffer_apply_tag_by_name( buffer, name , &start, &end );
      hb_storptr( (gpointer) (start.dummy1 ), 3, 1  );
      hb_storptr( (gpointer) (start.dummy2 ), 3, 2  );
      hb_storni(  (gint    ) (start.dummy3 ), 3, 3  );
      hb_storni(  (gint    ) (start.dummy4 ), 3, 4  );
      hb_storni(  (gint    ) (start.dummy5 ), 3, 5  );
      hb_storni(  (gint    ) (start.dummy6 ), 3, 6  );
      hb_storni(  (gint    ) (start.dummy7 ), 3, 7  );
      hb_storni(  (gint    ) (start.dummy8 ), 3, 8  );
      hb_storptr( (gpointer) (start.dummy9 ), 3, 9  );
      hb_storptr( (gpointer) (start.dummy10), 3, 10 );
      hb_storni(  (gint    ) (start.dummy11), 3, 11 );
      hb_storni(  (gint    ) (start.dummy12), 3, 12 );
      hb_storni(  (gint    ) (start.dummy13), 3, 13 );
      hb_storptr( (gpointer) (start.dummy14), 3, 14 );
      
      hb_storptr( (gpointer) (end.dummy1 ), 4, 1  );
      hb_storptr( (gpointer) (end.dummy2 ), 4, 2  );
      hb_storni(  (gint    ) (end.dummy3 ), 4, 3  );
      hb_storni(  (gint    ) (end.dummy4 ), 4, 4  );
      hb_storni(  (gint    ) (end.dummy5 ), 4, 5  );
      hb_storni(  (gint    ) (end.dummy6 ), 4, 6  );
      hb_storni(  (gint    ) (end.dummy7 ), 4, 7  );
      hb_storni(  (gint    ) (end.dummy8 ), 4, 8  );
      hb_storptr( (gpointer) (end.dummy9 ), 4, 9  );
      hb_storptr( (gpointer) (end.dummy10), 4, 10 );
      hb_storni(  (gint    ) (end.dummy11), 4, 11 );
      hb_storni(  (gint    ) (end.dummy12), 4, 12 );
      hb_storni(  (gint    ) (end.dummy13), 4, 13 );
      hb_storptr( (gpointer) (end.dummy14), 4, 14 );

    }
  }

}

HB_FUNC( GTK_TEXT_BUFFER_GET_ITER_AT_OFFSET )  // buffer,  aIter , Pos
{
  GtkTextBuffer * buffer = GTK_TEXT_BUFFER( hb_parptr( 1 ) );
  GtkTextIter iter;
  PHB_ITEM pIter = hb_param( 2, HB_IT_ARRAY );
  
  if ( Array2IterText( pIter, &iter ) )
  {  
     gtk_text_buffer_get_iter_at_offset( buffer, &iter, (gint) hb_parni( 3 ) );
     hb_storptr( (gpointer) (iter.dummy1 ), 2, 1  );
     hb_storptr( (gpointer) (iter.dummy2 ), 2, 2  );
     hb_storni(  (gint    ) (iter.dummy3 ), 2, 3  );
     hb_storni(  (gint    ) (iter.dummy4 ), 2, 4  );
     hb_storni(  (gint    ) (iter.dummy5 ), 2, 5  );
     hb_storni(  (gint    ) (iter.dummy6 ), 2, 6  );
     hb_storni(  (gint    ) (iter.dummy7 ), 2, 7  );
     hb_storni(  (gint    ) (iter.dummy8 ), 2, 8  );
     hb_storptr( (gpointer) (iter.dummy9 ), 2, 9  );
     hb_storptr( (gpointer) (iter.dummy10), 2, 10 );
     hb_storni(  (gint    ) (iter.dummy11), 2, 11 );
     hb_storni(  (gint    ) (iter.dummy12), 2, 12 );
     hb_storni(  (gint    ) (iter.dummy13), 2, 13 );
     hb_storptr( (gpointer) (iter.dummy14), 2, 14 );
  }

}

//TODO: de momento pasamos 4 parametros.
HB_FUNC( GTK_TEXT_BUFFER_INSERT_WITH_TAGS_BY_NAME  )  // buffer,  aIter , text, nLen, tag_1, tag_2, tag_3, tag_4 
{
  GtkTextBuffer * buffer = GTK_TEXT_BUFFER( hb_parptr( 1 ) );
  PHB_ITEM pIter = hb_param( 2, HB_IT_ARRAY );
  gchar * text = (gchar*) hb_parc( 3 );
  gchar * tag1 = (gchar*) hb_parc( 5 );
  gint len = ISNIL( 4 ) ? -1 : hb_parni( 4 );
  GtkTextIter iter;
  
  if ( Array2IterText( pIter, &iter ) )
  {  
     gtk_text_buffer_insert_with_tags_by_name( buffer, &iter, text, len, tag1,
                                            hb_parc( 6 ), hb_parc( 7 ),hb_parc( 8 ), NULL );
     hb_storptr( (gpointer) (iter.dummy1 ), 2, 1 );
     hb_storptr( (gpointer) (iter.dummy2 ), 2, 2 );
     hb_storni(  (gint    ) (iter.dummy3 ), 2, 3 );
     hb_storni(  (gint    ) (iter.dummy4 ), 2, 4 );
     hb_storni(  (gint    ) (iter.dummy5 ), 2, 5 );
     hb_storni(  (gint    ) (iter.dummy6 ), 2, 6 );
     hb_storni(  (gint    ) (iter.dummy7 ), 2, 7 );
     hb_storni(  (gint    ) (iter.dummy8 ), 2, 8 );
     hb_storptr( (gpointer) (iter.dummy9 ), 2, 9 );
     hb_storptr( (gpointer) (iter.dummy10), 2, 10);
     hb_storni(  (gint    ) (iter.dummy11), 2, 11);
     hb_storni(  (gint    ) (iter.dummy12), 2, 12);
     hb_storni(  (gint    ) (iter.dummy13), 2, 13);
     hb_storptr( (gpointer) (iter.dummy14), 2, 14);
  }

}

HB_FUNC( GTK_TEXT_BUFFER_INSERT_PIXBUF  )  // buffer,  aIter , pixbuf
{
  GtkTextBuffer * buffer = GTK_TEXT_BUFFER( hb_parptr( 1 ) );
  PHB_ITEM pIter = hb_param( 2, HB_IT_ARRAY );
  GdkPixbuf * pixbuf = GDK_PIXBUF (hb_parptr( 3 ) );
  GtkTextIter iter;

  if ( Array2IterText( pIter, &iter ) )
  { 
     gtk_text_buffer_insert_pixbuf( buffer, &iter, pixbuf );
     hb_storptr( (gpointer) (iter.dummy1 ), 2, 1 );
     hb_storptr( (gpointer) (iter.dummy2 ), 2, 2 );
     hb_storni(  (gint    ) (iter.dummy3 ), 2, 3 );
     hb_storni(  (gint    ) (iter.dummy4 ), 2, 4 );
     hb_storni(  (gint    ) (iter.dummy5 ), 2, 5 );
     hb_storni(  (gint    ) (iter.dummy6 ), 2, 6 );
     hb_storni(  (gint    ) (iter.dummy7 ), 2, 7 );
     hb_storni(  (gint    ) (iter.dummy8 ), 2, 8 );
     hb_storptr( (gpointer) (iter.dummy9 ), 2, 9 );
     hb_storptr( (gpointer) (iter.dummy10), 2, 10);
     hb_storni(  (gint    ) (iter.dummy11), 2, 11);
     hb_storni(  (gint    ) (iter.dummy12), 2, 12);
     hb_storni(  (gint    ) (iter.dummy13), 2, 13);
     hb_storptr( (gpointer) (iter.dummy14), 2, 14);
  }   
}

HB_FUNC( GTK_TEXT_BUFFER_GET_TAG_TABLE )  // buffer --> Tag_table 
{
  GtkTextBuffer * buffer = GTK_TEXT_BUFFER( hb_parptr( 1 ) );
  GtkTextTagTable * table = gtk_text_buffer_get_tag_table( buffer );
  hb_retptr( ( GtkTextTagTable * ) table );
}


/* API
 * GtkTextTagTable — Collection of tags that can be used together
   TODO:
   void gtk_text_tag_table_foreach( GtkTextTagTable *table,
                                    GtkTextTagTableForeach func,
                                    gpointer data);
*/


HB_FUNC( GTK_TEXT_TAG_TABLE_NEW )
{
  GtkTextTagTable * table = gtk_text_tag_table_new();
  hb_retptr( ( GtkTextTagTable * ) table );
}

HB_FUNC( GTK_TEXT_TAG_TABLE_ADD )
{
  GtkTextTagTable * table = GTK_TEXT_TAG_TABLE( hb_parptr( 1 ) );
  GtkTextTag * tag = GTK_TEXT_TAG( hb_parptr( 2 ) );
  gtk_text_tag_table_add( table, tag );
}

HB_FUNC( GTK_TEXT_TAG_TABLE_REMOVE )
{
  GtkTextTagTable * table = GTK_TEXT_TAG_TABLE( hb_parptr( 1 ) );
  GtkTextTag * tag = GTK_TEXT_TAG( hb_parptr( 2 ) );
  gtk_text_tag_table_remove( table, tag );
}

HB_FUNC( GTK_TEXT_TAG_TABLE_LOOKUP )
{
  GtkTextTagTable * table = GTK_TEXT_TAG_TABLE( hb_parptr( 1 ) );
  gchar * name = ( gchar * ) hb_parc( 2 );
  GtkTextTag * tag;
  tag = gtk_text_tag_table_lookup( table, name );
  hb_retptr( ( GtkTextTagTable * ) tag );
}

HB_FUNC( GTK_TEXT_TAG_TABLE_GET_SIZE )
{
  GtkTextTagTable * table = GTK_TEXT_TAG_TABLE( hb_parptr( 1 ) );
  hb_retni( gtk_text_tag_table_get_size( table ) );
}


/*-----------------14/01/2005 22:06-----------------
 * Api
 * GtkTextTag — A tag that can be applied to text in a GtkTextBuffer
 * --------------------------------------------------*/
/* TODO
gboolean    gtk_text_tag_event              (GtkTextTag *tag,
                                             GObject *event_object,
                                             GdkEvent *event,
                                             const GtkTextIter *iter);
struct      GtkTextAppearance;
GtkTextAttributes* gtk_text_attributes_new  (void);
GtkTextAttributes* gtk_text_attributes_copy (GtkTextAttributes *src);
void        gtk_text_attributes_copy_values (GtkTextAttributes *src,
                                             GtkTextAttributes *dest);
void        gtk_text_attributes_unref       (GtkTextAttributes *values);
void        gtk_text_attributes_ref         (GtkTextAttributes *values);
*/
HB_FUNC( GTK_TEXT_TAG_NEW )
{
  GtkTextTag * tag = gtk_text_tag_new( (gchar *) hb_parc( 1 ) );
  hb_retptr( ( GtkTextTag * ) tag );
}

HB_FUNC( GTK_TEXT_TAG_GET_PRIORITY )
{
   GtkTextTag * tag = GTK_TEXT_TAG( hb_parptr( 1 ) );
   hb_retni(  gtk_text_tag_get_priority( tag ) );
}

HB_FUNC( GTK_TEXT_TAG_SET_PRIORITY )
{
   GtkTextTag * tag = GTK_TEXT_TAG( hb_parptr( 1 ) );
   gtk_text_tag_set_priority( tag, hb_parni( 2 ) );
}

// Creacion de una estructura TextIter
/*
struct _GtkTextIter {
   *GtkTextIter is an opaque datatype; ignore all these fields.
   * Initialize the iter with gtk_text_buffer_get_iter_*
   * functions
  //< private >
  gpointer dummy1;
  gpointer dummy2;
  gint dummy3;
  gint dummy4;
  gint dummy5;
  gint dummy6;
  gint dummy7;
  gint dummy8;
  gpointer dummy9;
  gpointer dummy10;
  gint dummy11;
  gint dummy12;
  // padding 
  gint dummy13;
  gpointer dummy14;
};
*/
/*
 * Convierte una estructura GtkIterText en un array de Harbour
 * */
PHB_ITEM IterText2Array( GtkTextIter *iter  )
{
   PHB_ITEM aIter = hb_itemArrayNew( 14 );
   PHB_ITEM element = hb_itemNew( NULL );

   hb_arraySet( aIter,  1, hb_itemPutPtr( element, iter->dummy1  ) );
   hb_arraySet( aIter,  2, hb_itemPutPtr( element, iter->dummy2  ) );
   hb_arraySet( aIter,  3, hb_itemPutNI(  element, iter->dummy3  ) );
   hb_arraySet( aIter,  4, hb_itemPutNI(  element, iter->dummy4  ) );
   hb_arraySet( aIter,  5, hb_itemPutNI(  element, iter->dummy5  ) );
   hb_arraySet( aIter,  6, hb_itemPutNI(  element, iter->dummy6  ) );
   hb_arraySet( aIter,  7, hb_itemPutNI(  element, iter->dummy7  ) );
   hb_arraySet( aIter,  8, hb_itemPutNI(  element, iter->dummy8  ) );
   hb_arraySet( aIter,  9, hb_itemPutPtr( element, iter->dummy9  ) );
   hb_arraySet( aIter, 10, hb_itemPutPtr( element, iter->dummy10 ) );
   hb_arraySet( aIter, 11, hb_itemPutNI(  element, iter->dummy11 ) );
   hb_arraySet( aIter, 12, hb_itemPutNI(  element, iter->dummy12 ) );
   hb_arraySet( aIter, 13, hb_itemPutNI(  element, iter->dummy13 ) );
   hb_arraySet( aIter, 14, hb_itemPutPtr( element, iter->dummy14 ) );

   hb_itemRelease(element);
   return aIter;
}

/*
 * Convierte un array en un GtkIterText
 * Comprueba si el dato pasado es correcto y su numero de elementos
 */
BOOL Array2IterText(PHB_ITEM aIter, GtkTextIter *iter  )
{
   if (HB_IS_ARRAY( aIter ) && hb_arrayLen( aIter ) == 14) {
       iter->dummy1  = (gpointer) hb_arrayGetPtr( aIter, 1  );
       iter->dummy2  = (gpointer) hb_arrayGetPtr( aIter, 2  );
       iter->dummy3  = (gint    ) hb_arrayGetNI(  aIter, 3  );
       iter->dummy4  = (gint    ) hb_arrayGetNI(  aIter, 4  );
       iter->dummy5  = (gint    ) hb_arrayGetNI(  aIter, 5  );
       iter->dummy6  = (gint    ) hb_arrayGetNI(  aIter, 6  );
       iter->dummy7  = (gint    ) hb_arrayGetNI(  aIter, 7  );
       iter->dummy8  = (gint    ) hb_arrayGetNI(  aIter, 8  );
       iter->dummy9  = (gpointer) hb_arrayGetPtr( aIter, 9  );
       iter->dummy10 = (gpointer) hb_arrayGetPtr( aIter, 10 );
       iter->dummy11 = (gint    ) hb_arrayGetNI(  aIter, 11 );
       iter->dummy12 = (gint    ) hb_arrayGetNI(  aIter, 12 );
       iter->dummy13 = (gint    ) hb_arrayGetNI(  aIter, 13 );
       iter->dummy14 = (gpointer) hb_arrayGetPtr( aIter, 14 );
      return TRUE ;
   }
   return FALSE;
}

//eof
