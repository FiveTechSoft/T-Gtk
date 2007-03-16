/*
 *  GtkStatusIcon for [x]Harbour
 *  GtkStatusIcon — Display an icon in the system tray
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
#include <hbapi.h>
#include <gtk/gtk.h>

#if GTK_CHECK_VERSION( 2,10,0 )
HB_FUNC( GTK_STATUS_ICON_NEW ) 
{
  GtkStatusIcon * status = gtk_status_icon_new();
  hb_retnl( (glong) status );
}

HB_FUNC( GTK_STATUS_ICON_NEW_FROM_STOCK ) 
{
  GtkStatusIcon * status = gtk_status_icon_new_from_stock( hb_parc( 1 ) );
  hb_retnl( (glong) status );
}

HB_FUNC( GTK_STATUS_ICON_NEW_FROM_FILE ) 
{
  GtkStatusIcon * status;
  const gchar * filename = hb_parc( 1 );
  status = gtk_status_icon_new_from_file( filename );
  hb_retnl( (glong) status );
}

HB_FUNC( GTK_STATUS_ICON_SET_FROM_ICON_NAME ) 
{
  GtkStatusIcon * status = GTK_STATUS_ICON( hb_parnl( 1 ) );
  const gchar * icon_name = hb_parc( 2 );
  gtk_status_icon_set_from_icon_name( status, icon_name );
}

HB_FUNC( GTK_STATUS_ICON_SET_TOOLTIP ) 
{
  GtkStatusIcon * status = GTK_STATUS_ICON( hb_parnl( 1 ) );
  const gchar * tooltip = hb_parc( 2 );
  gtk_status_icon_set_tooltip( status, tooltip );
}

HB_FUNC( GTK_STATUS_ICON_SET_VISIBLE ) 
{
  GtkStatusIcon * status = GTK_STATUS_ICON( hb_parnl( 1 ) );
  gboolean visible = hb_parl( 2 );
  gtk_status_icon_set_visible( status, visible );
}

HB_FUNC( GTK_STATUS_ICON_GET_BLINKING ) 
{
  GtkStatusIcon * status = GTK_STATUS_ICON( hb_parnl( 1 ) );
  hb_retl( gtk_status_icon_get_blinking( status ) );
}

HB_FUNC( GTK_STATUS_ICON_SET_BLINKING ) 
{
  GtkStatusIcon * status = GTK_STATUS_ICON( hb_parnl( 1 ) );
  gboolean blinking = hb_parl( 2 );
  gtk_status_icon_set_blinking( status, blinking );
}

HB_FUNC( GTK_STATUS_ICON_POSITION_MENU ) 
{
  GtkMenu * menu = GTK_MENU( hb_parnl( 1 ) );
  gint x,y;
  gboolean push_in;
  
  gtk_status_icon_position_menu( menu,
                                 &x,
                                 &y,
                                 &push_in, NULL );

}
#endif
