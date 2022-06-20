/*
 *  
 *  GtkAssistant — A widget used to guide users through multi-step operations
 * 
 *  This program is free software; you can redistribute it and/or
 *  modify it under the terms of the GNU Library General Public License
 *  as published by the Free Software Foundation; either version 2 of
 *  the License, or (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU Library General Public License for more details.
 *
 *  You should have received a copy of the GNU Library General Public
 *  License along with this program; if not, write to the Free Software
 *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 *
 *  Authors:
 *    Rafa Carmona( thefull@wanadoo.es )
 *
 *  Copyright 2007 Rafa Carmona
 */

/*
 * TODO:
   Estas 2 funciones simplemente sirven para modificar el comportamiento de Forward.
   De momento, dejamos su implementacion.
   gint        (*GtkAssistantPageFunc) 
   void        gtk_assistant_set_forward_page_func 
*/

#include <hbapi.h>
#include <gtk/gtk.h>


#if GTK_CHECK_VERSION(2,10,0)
HB_FUNC( GTK_ASSISTANT_NEW )
{
  GtkWidget * assistant = gtk_assistant_new();
  hb_retptr( ( GtkWidget * ) assistant );
}

//--------------------------------------------------------//

HB_FUNC( GTK_ASSISTANT_GET_CURRENT_PAGE )
{
  GtkAssistant * assistant = GTK_ASSISTANT( hb_parptr( 1 ) );
  gint page = gtk_assistant_get_current_page( assistant );
  hb_retni( page );
}

//--------------------------------------------------------//

HB_FUNC( GTK_ASSISTANT_SET_CURRENT_PAGE )
{
  GtkAssistant * assistant = GTK_ASSISTANT( hb_parptr( 1 ) );
  gint page = hb_parni( 2 );
  gtk_assistant_set_current_page( assistant, page );
}

//--------------------------------------------------------//

HB_FUNC( GTK_ASSISTANT_GET_N_PAGES )
{
  GtkAssistant * assistant = GTK_ASSISTANT( hb_parptr( 1 ) );
  gint pages = gtk_assistant_get_n_pages( assistant );
  hb_retni( pages );
}

//--------------------------------------------------------//

HB_FUNC( GTK_ASSISTANT_GET_NTH_PAGE )
{
  GtkWidget * child;
  GtkAssistant * assistant = GTK_ASSISTANT( hb_parptr( 1 ) );
  gint page_num = hb_parni( 2 );
  child = gtk_assistant_get_nth_page ( assistant, page_num );
  hb_retptr( ( GtkWidget * ) child ) ;
}

//--------------------------------------------------------//

HB_FUNC( GTK_ASSISTANT_PREPEND_PAGE )
{
  GtkAssistant * assistant = GTK_ASSISTANT( hb_parptr( 1 ) );
  GtkWidget * page = GTK_WIDGET( hb_parptr( 2 ) );
  gint index = gtk_assistant_prepend_page ( assistant, page );
  hb_retni( index );
}

//--------------------------------------------------------//

HB_FUNC( GTK_ASSISTANT_APPEND_PAGE )
{
  GtkAssistant * assistant = GTK_ASSISTANT( hb_parptr( 1 ) );
  GtkWidget * page = GTK_WIDGET( hb_parptr( 2 ) );
  gint index = gtk_assistant_append_page ( assistant, page );
  hb_retni( index );
}

//--------------------------------------------------------//

HB_FUNC( GTK_ASSISTANT_INSERT_PAGE )
{
  GtkAssistant * assistant = GTK_ASSISTANT( hb_parptr( 1 ) );
  GtkWidget * page = GTK_WIDGET( hb_parptr( 2 ) );
  gint position = hb_parni( 3 );
  gint index = gtk_assistant_insert_page( assistant, page, position );
  hb_retni( index );
}

//--------------------------------------------------------//

HB_FUNC( GTK_ASSISTANT_SET_PAGE_TYPE )
{
  GtkAssistant * assistant = GTK_ASSISTANT( hb_parptr( 1 ) );
  GtkWidget * page = GTK_WIDGET( hb_parptr( 2 ) );
  GtkAssistantPageType type = hb_parni( 3 );
  gtk_assistant_set_page_type( assistant, page, type );
}

//--------------------------------------------------------//

HB_FUNC( GTK_ASSISTANT_GET_PAGE_TYPE )
{
  GtkAssistant * assistant = GTK_ASSISTANT( hb_parptr( 1 ) );
  GtkWidget * page = GTK_WIDGET( hb_parptr( 2 ) );
  GtkAssistantPageType type = gtk_assistant_get_page_type( assistant, page );
  hb_retni( type );
}

//--------------------------------------------------------//

HB_FUNC( GTK_ASSISTANT_SET_PAGE_TITLE )
{
  GtkAssistant * assistant = GTK_ASSISTANT( hb_parptr( 1 ) );
  GtkWidget * page = GTK_WIDGET( hb_parptr( 2 ) );
  const gchar *title = hb_parc( 3 );
  gtk_assistant_set_page_title( assistant, page, title );
}

//--------------------------------------------------------//

HB_FUNC( GTK_ASSISTANT_GET_PAGE_TITLE )
{
  GtkAssistant * assistant = GTK_ASSISTANT( hb_parptr( 1 ) );
  GtkWidget * page = GTK_WIDGET( hb_parptr( 2 ) );
  const gchar * title = gtk_assistant_get_page_title( assistant, page );
  hb_retc( ( const gchar * ) title );
}

//--------------------------------------------------------//


#if GTK_MAJOR_VERSION < 4 
  #if GTK_MINOR_VERSION < 20 //GTK_CHECK_VERSION(3,20,0)
  HB_FUNC( GTK_ASSISTANT_SET_PAGE_HEADER_IMAGE )
  {
    GtkAssistant * assistant = GTK_ASSISTANT( hb_parptr( 1 ) );
    GtkWidget * page = GTK_WIDGET( hb_parptr( 2 ) );
    GdkPixbuf * pixbuf = GDK_PIXBUF (hb_parptr( 3 ) );
    
    gtk_assistant_set_page_header_image( assistant, page, pixbuf );
  }
//--------------------------------------------------------//

HB_FUNC( GTK_ASSISTANT_GET_PAGE_HEADER_IMAGE )
{
  GtkAssistant * assistant = GTK_ASSISTANT( hb_parptr( 1 ) );
  GtkWidget * page = GTK_WIDGET( hb_parptr( 2 ) );
  GdkPixbuf * pixbuf = gtk_assistant_get_page_header_image( assistant, page );
  hb_retptr( ( GdkPixbuf * ) pixbuf );
}

//--------------------------------------------------------//

HB_FUNC( GTK_ASSISTANT_SET_PAGE_SIDE_IMAGE )
{
  GtkAssistant * assistant = GTK_ASSISTANT( hb_parptr( 1 ) );
  GtkWidget * page = GTK_WIDGET( hb_parptr( 2 ) );
  GdkPixbuf * pixbuf = GDK_PIXBUF (hb_parptr( 3 ) );
  gtk_assistant_set_page_side_image( assistant, page, pixbuf );
}

//--------------------------------------------------------//

HB_FUNC( GTK_ASSISTANT_GET_PAGE_SIDE_IMAGE )
{
  GtkAssistant * assistant = GTK_ASSISTANT( hb_parptr( 1 ) );
  GtkWidget * page = GTK_WIDGET( hb_parptr( 2 ) );
  GdkPixbuf * pixbuf = gtk_assistant_get_page_side_image( assistant, page );
  hb_retptr( ( GdkPixbuf * ) pixbuf );
}

  #endif
#endif
//--------------------------------------------------------//

HB_FUNC( GTK_ASSISTANT_SET_PAGE_COMPLETE )
{
  GtkAssistant * assistant = GTK_ASSISTANT( hb_parptr( 1 ) );
  GtkWidget * page = GTK_WIDGET( hb_parptr( 2 ) );
  gboolean complete = hb_parl( 3 );  
  gtk_assistant_set_page_complete( assistant, page, complete );
}

//--------------------------------------------------------//

HB_FUNC( GTK_ASSISTANT_GET_PAGE_COMPLETE )
{
  GtkAssistant * assistant = GTK_ASSISTANT( hb_parptr( 1 ) );
  GtkWidget * page = GTK_WIDGET( hb_parptr( 2 ) );
  gboolean complete = gtk_assistant_get_page_complete( assistant, page ); 
  hb_retl( complete );
}

//--------------------------------------------------------//

HB_FUNC( GTK_ASSISTANT_ADD_ACTION_WIDGET )
{
  GtkAssistant * assistant = GTK_ASSISTANT( hb_parptr( 1 ) );
  GtkWidget * child = GTK_WIDGET( hb_parptr( 2 ) );
  gtk_assistant_add_action_widget( assistant, child );
}

//--------------------------------------------------------//

HB_FUNC( GTK_ASSISTANT_REMOVE_ACTION_WIDGET )
{
  GtkAssistant * assistant = GTK_ASSISTANT( hb_parptr( 1 ) );
  GtkWidget * child = GTK_WIDGET( hb_parptr( 2 ) );
  gtk_assistant_remove_action_widget( assistant, child );
}

//--------------------------------------------------------//

HB_FUNC( GTK_ASSISTANT_UPDATE_BUTTONS_STATE )
{
  GtkAssistant * assistant = GTK_ASSISTANT( hb_parptr( 1 ) );
  gtk_assistant_update_buttons_state( assistant );
}

//--------------------------------------------------------//
#endif
 
//eof
