/* $Id: gtkfilechooser.c,v 1.2 2008-12-18 01:32:59 riztan Exp $*/
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
#include <gtk/gtk.h>
#include "hbapi.h"

#if GTK_MAJOR_VERSION < 3

#if GTK_CHECK_VERSION(2,4,0)


HB_FUNC( GTK_FILE_CHOOSER_WIDGET_NEW )
{
  GtkFileChooserAction action = hb_parni( 1 );
  hb_retptr( ( GtkWidget * ) gtk_file_chooser_widget_new( action ) );
}

/*
Funciona, pero de momento no tiene utilidad en t-gtk (RIGC-2015-10-05)
HB_FUNC( GTK_FILE_CHOOSER_DIALOG_NEW )
{ const gchar * title = hb_parc( 1 );
  GtkWindow * parent = GTK_WINDOW( hb_parptr( 2 ) );
  GtkFileChooserAction nAction = hb_parni( 3 );
//  const gchar * first_button_text = hb_parc( 4 );
  hb_retptr( ( GtkWidget * ) gtk_file_chooser_dialog_new( title, parent, nAction, 
                             GTK_STOCK_CANCEL, GTK_RESPONSE_CANCEL,
                             GTK_STOCK_OPEN, GTK_RESPONSE_ACCEPT,
                             NULL ) );
}
*/

HB_FUNC( GTK_FILE_CHOOSER_SET_CURRENT_NAME )
{
  GtkFileChooser * chooser= GTK_FILE_CHOOSER( hb_parptr( 1 ) );
  gtk_file_chooser_set_current_name( chooser, hb_parc( 2 ) ) ;
}

HB_FUNC( GTK_FILE_CHOOSER_GET_CURRENT_FOLDER ) // pWidget--> folder
{
  GtkFileChooser * chooser= GTK_FILE_CHOOSER( hb_parptr( 1 ) );
  gchar * file = gtk_file_chooser_get_current_folder( chooser );
  hb_retc( file );
  g_free( file );
}

HB_FUNC( GTK_FILE_CHOOSER_SET_CURRENT_FOLDER ) // pWidget, folder --> bOk
{
  GtkFileChooser * chooser= GTK_FILE_CHOOSER( hb_parptr( 1 ) );
  hb_retl( gtk_file_chooser_set_current_folder( chooser, hb_parc( 2 ) ) );
}

HB_FUNC( GTK_FILE_CHOOSER_GET_FILENAME ) // pWidget--> folder
{
  GtkFileChooser * chooser= GTK_FILE_CHOOSER( hb_parptr( 1 ) );
  gchar * file = gtk_file_chooser_get_filename( chooser );
  hb_retc( file );
  g_free( file );
}

HB_FUNC( GTK_FILE_CHOOSER_SET_FILENAME ) // pWidget,filename-->bOk
{
  GtkFileChooser * chooser = GTK_FILE_CHOOSER( hb_parptr( 1 ) );
  hb_retl( gtk_file_chooser_set_filename( chooser , hb_parc( 2 ) ) );
}

HB_FUNC( GTK_FILE_CHOOSER_SET_ACTION ) // pWidget, folder --> bOk
{
  GtkFileChooser * chooser = GTK_FILE_CHOOSER( hb_parptr( 1 ) );
  gtk_file_chooser_set_action( chooser , hb_parni( 2 ) );
}

HB_FUNC( GTK_FILE_CHOOSER_GET_ACTION ) // pWidget, folder --> bOk
{
  GtkFileChooser * chooser= GTK_FILE_CHOOSER( hb_parptr( 1 ) );
  hb_retni( gtk_file_chooser_get_action( chooser ) );
}

HB_FUNC( GTK_FILE_CHOOSER_ADD_FILTER ) // pWidget, folder --> bOk
{
  GtkFileChooser * chooser= GTK_FILE_CHOOSER( hb_parptr( 1 ) );
  gtk_file_chooser_add_filter( chooser, ( GtkFileFilter * ) hb_parptr( 2 ) );
}


HB_FUNC( GTK_FILE_CHOOSER_SELECT_FILENAME ) // pWidget,filename-->bOk
{
  GtkFileChooser * chooser = GTK_FILE_CHOOSER( hb_parptr( 1 ) );
  hb_retl( gtk_file_chooser_select_filename( chooser , hb_parc( 2 ) ) );
}

#include "hbapiitm.h"
HB_FUNC( GTK_FILE_CHOOSER_GET_URIS )
{
  GtkFileChooser * chooser = GTK_FILE_CHOOSER( hb_parptr( 1 ) );
  GSList * uris = gtk_file_chooser_get_uris( chooser );
  GSList * l;
  PHB_ITEM aItems = hb_itemArrayNew( 0 );
  PHB_ITEM temp   = hb_itemNew( NULL );

  for (l= uris; l != NULL; l = l->next) {
     gchar * uri = uris->data;
     //printf( "%s\n", uri );
     hb_itemPutC( temp, uri );
     hb_arrayAdd( aItems, temp );
  }
  hb_itemReturnForward( aItems );
  hb_itemRelease( temp   );
  hb_itemRelease( aItems );
  g_slist_free( uris );
  g_slist_free( l );
}


HB_FUNC( GTK_FILE_CHOOSER_GET_SELECT_MULTIPLE ) //pWidget
{
  GtkFileChooser * chooser = GTK_FILE_CHOOSER( hb_parptr( 1 ) );
  hb_retl( gtk_file_chooser_get_select_multiple( chooser ) );
}


HB_FUNC( GTK_FILE_CHOOSER_SET_SELECT_MULTIPLE ) //pWidget, boolean
{
  GtkFileChooser * chooser = GTK_FILE_CHOOSER( hb_parptr( 1 ) );
  gtk_file_chooser_set_select_multiple( chooser, hb_parl( 2 ) );
}


HB_FUNC( CHOOSEDIR ) // cTitle, cDir_Default, pParent_Window
{
    GtkWidget * dialog;
    gchar *filename;

    dialog = gtk_file_chooser_dialog_new ( hb_parc( 1 ),
                      ISNIL( 3 ) ? NULL : GTK_WINDOW( hb_parptr( 3 ) ),
                      GTK_FILE_CHOOSER_ACTION_SELECT_FOLDER,
                      GTK_STOCK_CANCEL, GTK_RESPONSE_CANCEL,
                      GTK_STOCK_OPEN, GTK_RESPONSE_ACCEPT,
                      NULL);

   gtk_file_chooser_set_filename( GTK_FILE_CHOOSER ( dialog ) , hb_parc( 2 ) );
   
   if (gtk_dialog_run (GTK_DIALOG (dialog)) == GTK_RESPONSE_ACCEPT)
    {
       filename = gtk_file_chooser_get_filename( GTK_FILE_CHOOSER ( dialog ) );        
       hb_retc( filename );
       g_free( filename );
    } else {
       hb_retc( "" );
    }
    gtk_widget_destroy (dialog);
}
#endif

#endif
