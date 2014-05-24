/* $Id: gtkfileselec.c,v 1.3 2010-05-26 10:15:03 xthefull Exp $*/
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
 * GtkFileSelec. Dialogo para selecciones de ficheros
 * Api completa GTK+ 2.4
 */

#include <gtk/gtk.h>
#include "hbapi.h"
#include "hbvm.h"
#include "t-gtk.h"
#include "hbapiitm.h"
#include "hbapierr.h"

#if GTK_MAJOR_VERSION < 3

HB_FUNC( GTK_FILE_SELECTION_NEW )
{
  GtkWidget * filesel;
  const gchar * title = ( const gchar*) hb_parc( 1 );

  filesel = gtk_file_selection_new ( title );

  g_signal_connect_swapped (GTK_FILE_SELECTION (filesel)->cancel_button,
                            "clicked", G_CALLBACK (gtk_widget_destroy),
                            (gpointer) filesel);

  hb_retptr( ( GtkWidget * ) filesel );
}

HB_FUNC( GTK_FILE_SELECTION_HIDE_FILEOP_BUTTONS )
{
  GtkFileSelection * filesel = GTK_FILE_SELECTION( hb_parptr( 1 ) );
  gtk_file_selection_hide_fileop_buttons( filesel );
}

HB_FUNC( GTK_FILE_SELECTION_SHOW_FILEOP_BUTTONS )
{
  GtkFileSelection * filesel = GTK_FILE_SELECTION( hb_parptr( 1 ) );
  gtk_file_selection_show_fileop_buttons( filesel );
}

HB_FUNC( GTK_FILE_SELECTION_SET_SELECT_MULTIPLE )
{
  GtkFileSelection * filesel = GTK_FILE_SELECTION( hb_parptr( 1 ) );
  gboolean select = ( gboolean ) hb_parl( 2 );
  gtk_file_selection_set_select_multiple( filesel, select );
}

HB_FUNC( GTK_FILE_SELECTION_GET_FILENAME )
{
  GtkFileSelection * filesel = GTK_FILE_SELECTION( hb_parptr( 1 ) );
  const gchar * sel_filename = gtk_file_selection_get_filename( filesel );
  hb_retc( ( gchar * ) sel_filename );
}

// TODO: Atencion , tenemos que tener en cuenta el tema del g_filename_from_utf8
HB_FUNC( GTK_FILE_SELECTION_SET_FILENAME )
{
   GtkFileSelection * filesel = GTK_FILE_SELECTION( hb_parptr( 1 ) );
   gchar * file = ( gchar * ) hb_parc( 2 );
   gtk_file_selection_set_filename( filesel, file );
}

HB_FUNC( GTK_FILE_SELECTION_GET_SELECTIONS )
{
 /* GTK+ Reference Manual
  * filesel : a GtkFileSelection
  * Returns : a newly-allocated NULL-terminated array of strings.
  * Use g_strfreev() to free it.
  */

  GtkFileSelection * filesel = GTK_FILE_SELECTION( hb_parptr( 1 ) );
  gchar ** sel_filename = gtk_file_selection_get_selections( filesel );
  gint i = 0;

  while( sel_filename[i] )
      i++;

  hb_reta( i );
  i = 0;
  while( sel_filename[i] )
     {
      hb_storc( sel_filename[i], -1, i+1 );
      i++;
     }
  g_strfreev( sel_filename );
}
  
HB_FUNC( GTK_FILE_SELECTION_COMPLETE )
{
   GtkFileSelection * filesel = GTK_FILE_SELECTION( hb_parptr( 1 ) );
   gchar * pattern = ( gchar * ) hb_parc( 2 );
   gtk_file_selection_complete( filesel, pattern );
}

static void event_filename( GtkWidget *widget, gpointer user_data )
{
   PHB_ITEM pUser_Data = ( PHB_ITEM ) user_data;
   PHB_ITEM pBlock     = hb_arrayGetItemPtr( pUser_Data, 1 );
   PHB_ITEM pWidget    = hb_itemNew( 0 );

   if( HB_IS_BLOCK( pBlock ) )
   {
      hb_itemPutPtr( pWidget, widget );
      hb_vmEvalBlockV( pBlock, 1, pWidget );
      hb_itemRelease( pWidget );
      hb_itemRelease( pUser_Data );

   }
  
}

HB_FUNC( GTK_FILE_SELECTION_CONNECT )
{
   GtkFileSelection * filesel = GTK_FILE_SELECTION( hb_parptr( 1 ) );
   const char * szsignal = hb_parc( 2 );
   PHB_ITEM pBlock       = hb_param( 3, HB_IT_BLOCK );
   PHB_ITEM pUser_Data   = hb_itemArrayNew( 1 );
   
   
   
   if( HB_IS_BLOCK( pBlock ) ){
      hb_itemArrayPut( pUser_Data, 1, pBlock );
      if( hb_stricmp( szsignal, "ok_button" ) == 0 )
      {
         g_signal_connect (GTK_FILE_SELECTION (filesel)->ok_button,
                           "clicked",
                            G_CALLBACK(event_filename),
                            (gpointer) pUser_Data ); 
         g_signal_connect_swapped (GTK_FILE_SELECTION (filesel)->ok_button,
                           "clicked",
                            G_CALLBACK(gtk_widget_destroy ),
                            (gpointer) filesel );
      }
   }

}

#endif

