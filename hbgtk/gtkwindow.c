/* $Id: gtkwindow.c,v 1.8 2010-12-23 15:55:47 xthefull Exp $*/
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
#include "t-gtk.h"

gint window_exit( GtkWidget *widget, gpointer data )
{
  gtk_main_quit();
  return TRUE;
}


// funcion traida de Jan Bodnar http://zetcode.com/tutorials/gtktutorial/firstprograms/
//
GdkPixbuf *create_pixbuf( const gchar * filename )
{
   GdkPixbuf *pixbuf;
   GError *error = NULL;
   pixbuf = gdk_pixbuf_new_from_file(filename, &error);

   if(!pixbuf) {
      fprintf(stderr, "%s\n", error->message);
      g_error_free(error);
   }

   return pixbuf;

}

// Para tomar el valor de la ventana superior
GtkWidget * get_win_parent()
{
    GtkWidget *wParent = NULL;
    guint uiElement;

    GList *tops = gtk_window_list_toplevels();
    
//buscamos la ventana con el foco
    if ( tops ) {
       uiElement = g_list_length( tops );
       while( uiElement > 0 ){
          uiElement--;
          if( gtk_window_get_window_type( g_list_nth_data( tops, uiElement ) ) == GTK_WINDOW_TOPLEVEL )          	
         	  if( gtk_window_has_toplevel_focus( g_list_nth_data( tops, uiElement ) ) ){
         	  	wParent = ( g_list_nth( tops, uiElement ) )->data ;
              uiElement = 0;
             }
       }
    }
    g_list_free( tops );
    return wParent;
}

HB_FUNC( GTK_WINDOW_NEW )
{
  GtkWidget * window = window = gtk_window_new ( hb_parni( 1 ) ) ;
  hb_retptr( (GtkWidget * ) window );
}

HB_FUNC( GTK_WINDOW_SET_TITLE ) // widget, cTitle
{
  GtkWidget * window = GTK_WIDGET(  hb_parptr( 1 ) );
  gtk_window_set_title( GTK_WINDOW( window ), (gchar *) hb_parc( 2 ) );
}

HB_FUNC( GTK_WINDOW_GET_TITLE ) // widget-->cTitle
{
  GtkWidget * window = GTK_WIDGET( hb_parptr( 1 ) );
  hb_retc( gtk_window_get_title( GTK_WINDOW( window ) ) );
}


HB_FUNC( GTK_WINDOW_SET_DELETABLE ) // window, logical -> void
{
  GtkWidget * window = GTK_WIDGET(  hb_parptr( 1 ) );
  gtk_window_set_deletable( GTK_WINDOW( window ), (gboolean) hb_parl( 2 ) );
}

HB_FUNC( GTK_WINDOW_SET_RESIZABLE ) // window, logical -> void
{
  GtkWidget * window = GTK_WIDGET(  hb_parptr( 1 ) );
  gtk_window_set_resizable( GTK_WINDOW( window ), (gboolean) hb_parl( 2 ) );
}

HB_FUNC( GTK_WINDOW_GET_RESIZABLE ) // window -> logical
{
  GtkWidget * window = GTK_WIDGET(  hb_parptr( 1 ) );
  gboolean resizable = gtk_window_get_resizable( GTK_WINDOW(window) );
  hb_retl( resizable );
}

HB_FUNC( GTK_WINDOW_SET_POSITION ) // widget, nPosicion -> void
{
  gtk_window_set_position( GTK_WINDOW(  hb_parptr( 1 ) ), hb_parni( 2 ) );
}

HB_FUNC( GTK_WINDOW_GET_POSITION ) // widget -> aPos XY
{
  GtkWidget * window = GTK_WIDGET( hb_parptr( 1 ) );
  gint root_x;
  gint root_y;
  gtk_window_get_position( GTK_WINDOW(window), &root_x, &root_y );
  hb_reta( 2 );
  hb_storni( root_x, -1, 1 );
  hb_storni( root_y, -1, 2 );
}

HB_FUNC( GTK_WINDOW_SET_DEFAULT_SIZE ) // widget, width, height ->void
{
  gtk_window_set_default_size( GTK_WINDOW( hb_parptr( 1 ) ), hb_parni( 2 ),
                                           hb_parni( 3 ) );
}

HB_FUNC( GTK_WINDOW_SET_ICON ) //  window, Icon -> void
{
  GtkWidget * window = ( GtkWidget * ) hb_parptr( 1 );
  GdkPixbuf * pixbuf = ( GdkPixbuf * ) create_pixbuf( hb_parc( 2 ) );

  gtk_window_set_icon( GTK_WINDOW(window), pixbuf );
}

HB_FUNC( GTK_WINDOW_SET_ICON_NAME ) //  window, cIcon -> void
{
  GtkWidget * window = ( GtkWidget * )  hb_parptr( 1 ) ;
  const gchar * cIcon = hb_parcx( 2 );
  gtk_window_set_icon_name( GTK_WINDOW(window), cIcon );
}

HB_FUNC( GTK_WINDOW_SET_ICON_FROM_FILE ) //  window, cIcon -> void
{
  GtkWidget * window = ( GtkWidget * ) hb_parptr( 1 );
  const gchar * cIcon = hb_parc( 2 );
  gtk_window_set_icon_from_file( GTK_WINDOW(window), cIcon, NULL );
}

HB_FUNC( GTK_WINDOW_GET_MODAL ) // window, bState -> void
{
  GtkWidget * window = GTK_WIDGET(  hb_parptr( 1 ) );
  gboolean modal = gtk_window_get_modal( GTK_WINDOW(window) );
  hb_retl( modal );
}

HB_FUNC( GTK_WINDOW_SET_MODAL ) // window, bState -> void
{
  GtkWidget * window = GTK_WIDGET(  hb_parptr( 1 ) );
  gboolean bState = hb_parl( 2 );

  gtk_window_set_modal( GTK_WINDOW(window), bState );
}

HB_FUNC( GTK_WINDOW_SET_TRANSIENT_FOR ) // window, parent
{
  GtkWidget * window = GTK_WIDGET( hb_parptr( 1 ) );
  GtkWidget * parent = GTK_WIDGET( hb_parptr( 2 ) );

  gtk_window_set_transient_for( GTK_WINDOW(window), GTK_WINDOW( parent) );
}

HB_FUNC( GTK_WINDOW_MAXIMIZE ) // widget -> void
{
  gtk_window_maximize( GTK_WINDOW(  hb_parptr( 1 ) ) );
}

HB_FUNC( GTK_WINDOW_UNMAXIMIZE ) // widget -> void
{
  gtk_window_unmaximize( GTK_WINDOW(  hb_parptr( 1 ) ) );
}

HB_FUNC( GTK_WINDOW_FULLSCREEN ) // widget -> void
{
  gtk_window_fullscreen( GTK_WINDOW(  hb_parptr( 1 ) ) );
}

HB_FUNC( GTK_WINDOW_UNFULLSCREEN ) // widget -> void
{
  gtk_window_unfullscreen( GTK_WINDOW(  hb_parptr( 1 ) ) );
}

HB_FUNC( GTK_WINDOW_ICONIFY ) // widget -> void
{
  gtk_window_iconify( GTK_WINDOW(  hb_parptr( 1 ) ) );
}

HB_FUNC( GTK_WINDOW_DEICONIFY ) // widget -> void
{
  gtk_window_deiconify( GTK_WINDOW(  hb_parptr( 1 ) ) );
}

/*
HB_FUNC( GTK_WINDOW_SET_FRAME_DIMENSIONS ) // widget, left, top, right,
                                           // bottom -> void
{
  GtkWidget * window = GTK_WIDGET(  hb_parptr( 1 ) );
  gtk_window_set_frame_dimensions( GTK_WINDOW( window ),
                                   (gint) hb_parni( 2 ),
                                   (gint) hb_parni( 3 ),
                                   (gint) hb_parni( 4 ),
                                   (gint) hb_parni( 5 ) );
}

HB_FUNC( GTK_WINDOW_SET_HAS_FRAME ) // window, logical -> void
{
  GtkWidget * window = GTK_WIDGET(  hb_parptr( 1 ) );
  gtk_window_set_has_frame( GTK_WINDOW( window ), (gboolean) hb_parl( 2 ) );
}
*/
HB_FUNC( GTK_WINDOW_SET_SKIP_TASKBAR_HINT ) // window, logical -> void
{
  GtkWidget * window = GTK_WIDGET(  hb_parptr( 1 ) );
  gtk_window_set_skip_taskbar_hint( GTK_WINDOW( window ), (gboolean) hb_parl( 2 ) );
}

HB_FUNC( GTK_WINDOW_MOVE ) // widget, left, top -> void
{
  GtkWidget * window = GTK_WIDGET(  hb_parptr( 1 ) );
  gtk_window_move( GTK_WINDOW( window ), (gint) hb_parni( 2 ),
                                         (gint) hb_parni( 3 ) );
}

HB_FUNC( GTK_WINDOW_SET_KEEP_ABOVE )
{
  GtkWidget * window = GTK_WIDGET(  hb_parptr( 1 ) );
  gtk_window_set_keep_above( GTK_WINDOW( window ), hb_parl( 2 ));
}

HB_FUNC( GTK_WINDOW_SET_KEEP_BELOW ) 
{
  GtkWidget * window = GTK_WIDGET(  hb_parptr( 1 ) );
  gtk_window_set_keep_below( GTK_WINDOW( window ), hb_parl( 2 ) );
}

HB_FUNC( GTK_WINDOW_SET_DESTROY_WITH_PARENT )
{
  GtkWidget * window = GTK_WIDGET(  hb_parptr( 1 ) );
  gtk_window_set_destroy_with_parent( GTK_WINDOW( window ), hb_parl( 2 ) );
}

HB_FUNC( GTK_WINDOW_SET_DECORATED )
{
  GtkWidget * window = GTK_WIDGET(  hb_parptr( 1 ) );
  gtk_window_set_decorated( GTK_WINDOW( window ), hb_parl( 2 ) );
}

HB_FUNC( GTK_WINDOW_SET_DEFAULT )
{
  GtkWidget * window = GTK_WIDGET(  hb_parptr( 1 ) );
  GtkWidget * default_widget = NULL;

  if(  hb_parptr( 2 ) );
     default_widget = GTK_WIDGET(  hb_parptr( 2 ) );

  gtk_window_set_default( GTK_WINDOW( window ), default_widget );
}

HB_FUNC( GTK_WINDOW_SET_DEFAULT_ICON )
{
  GdkPixbuf * pixbuf = ( GdkPixbuf * ) create_pixbuf( hb_parc( 1 ) );
  gtk_window_set_default_icon( pixbuf );
  g_object_unref(  pixbuf );
}

HB_FUNC( GTK_WINDOW_SET_DEFAULT_ICON_FROM_FILE )
{
  hb_retl( gtk_window_set_default_icon_from_file( hb_parc( 1 ), NULL ) );
}

HB_FUNC( GTK_WINDOW_SET_DEFAULT_ICON_NAME )
{
  gtk_window_set_default_icon_name( hb_parc( 1 ) );
}

HB_FUNC( GTK_WINDOW_SET_FOCUS )
{
  GtkWidget * window = GTK_WIDGET(  hb_parptr( 1 ) );
  GtkWidget * default_widget = NULL;

  if(  hb_parptr( 2 ) );
     default_widget = GTK_WIDGET(  hb_parptr( 2 ) );

  gtk_window_set_focus( GTK_WINDOW( window ), default_widget );
}

HB_FUNC( GTK_WINDOW_PRESENT )
{
  GtkWidget * window = GTK_WIDGET(  hb_parptr( 1 ) );
  gtk_window_present( GTK_WINDOW( window ) );
}

HB_FUNC( GETACTIVEWINDOW )
{
   hb_retptr( (GtkWidget *) get_win_parent() );
}

HB_FUNC( GTK_WINDOW_LIST_TOPLEVELS )
{
    GList * toplevel = gtk_window_list_toplevels();
    hb_retptr( (GList *) toplevel );
}

HB_FUNC( GET_GTKWINDOW )
{
    GtkWidget * widget = GTK_WIDGET( hb_parptr( 1 ) );
    #if GTK_MAJOR_VERSION < 3
        hb_retptr( widget->window );
    #else
        // TODO  : Any idea
        hb_retptr( gtk_widget_get_parent_window( widget ) );
    #endif    
}

HB_FUNC( GTK_WINDOW_SET_TYPE_HINT ) // window, nWindowTypeHint -> void
{
  GtkWidget * window = GTK_WIDGET( hb_parptr( 1 ) );
  gtk_window_set_type_hint( GTK_WINDOW( window ),  hb_parni( 2 ) );
}

HB_FUNC( GTK_WINDOW_ADD_ACCEL_GROUP ) // pWindow, pAccel_Group --> void
{
  GtkAccelGroup *accel_group = GTK_ACCEL_GROUP( hb_parptr( 2 ) );
  GtkWindow * window = GTK_WINDOW( hb_parptr( 1 ) );
  gtk_window_add_accel_group( window, accel_group );
}


#if GTK_MAJOR_VERSION < 4
#if GTK_MINOR_VERSION < 8
  HB_FUNC( GTK_WINDOW_SET_OPACITY ) 
  {
    GtkWidget * window = GTK_WIDGET( hb_parptr( 1 ) );
    gtk_window_set_opacity( GTK_WINDOW( window ),  hb_parnd( 2 ) );
  }


  HB_FUNC( GTK_WINDOW_GET_OPACITY ) 
  {
    GtkWidget * window = GTK_WIDGET( hb_parptr( 1 ) );
    hb_retnd( gtk_window_get_opacity( GTK_WINDOW( window ) ) );
  }
#endif
#endif

/*
HB_FUNC( CREATE_PIXBUF ) // cFilename
{
   GdkPixbuf *create_pixbuf(const gchar * filename)
   {
      GdkPixbuf *pixbuf;
      GError *error = NULL;
      pixbuf = gdk_pixbuf_new_from_file(filename, &error);
      if(!pixbuf) {
         fprintf(stderr, "%s\n", error->message);
         g_error_free(error);
      }

      return pixbuf;
   }
}
*/


