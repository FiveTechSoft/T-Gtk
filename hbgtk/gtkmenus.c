/* $Id: gtkmenus.c,v 1.1 2006-09-08 12:18:45 xthefull Exp $*/
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
#include <hbapi.h>
#include <hbvm.h>
#include <gtk/gtk.h>

HB_FUNC( GTK_MENU_BAR_NEW )
{
    hb_retnl( ( ULONG ) gtk_menu_bar_new() );
}

HB_FUNC( GTK_MENU_NEW )
{
  hb_retnl( ( glong ) gtk_menu_new() );
}

HB_FUNC( GTK_MENU_ITEM_NEW_WITH_LABEL )
{
   GtkWidget * menuitem = gtk_menu_item_new_with_label( (gchar *)hb_parc( 1 ) );
   hb_retnl( ( glong ) menuitem );
}

HB_FUNC( GTK_MENU_ITEM_NEW_WITH_MNEMONIC )
{
   GtkWidget * menuitem = gtk_menu_item_new_with_mnemonic( (gchar *)hb_parc( 1 ) );
   hb_retnl( ( glong ) menuitem );
}

HB_FUNC( GTK_TEAROFF_MENU_ITEM_NEW )      /*  GtkTearOff   */
{
   GtkWidget * menuitem = gtk_tearoff_menu_item_new();
   hb_retnl( ( glong ) menuitem );
}


HB_FUNC( GTK_MENU_APPEND )
{
   GtkWidget * menu =     GTK_WIDGET( hb_parnl( 1 ) );
   GtkWidget * menuitem = GTK_WIDGET( hb_parnl( 2 ) );
   gtk_menu_append( GTK_MENU (menu), menuitem );
}

HB_FUNC( GTK_MENU_ITEM_SET_SUBMENU )
{
   GtkWidget * menu_item = GTK_WIDGET( hb_parnl( 1 ) );
   GtkWidget * submenu   = GTK_WIDGET( hb_parnl( 2 ) );
   gtk_menu_item_set_submenu ( GTK_MENU_ITEM( menu_item ), submenu );
}

// OBSOLETO!! gtk_menu_bar_append(GTK_MENU_BAR (menu_bar), root_menu);

HB_FUNC( GTK_MENU_SHELL_APPEND )
{
   GtkMenuShell * menu_shell = GTK_MENU_SHELL( hb_parnl( 1 ) );
   GtkWidget * child         = GTK_WIDGET( hb_parnl( 2 ) );
   gtk_menu_shell_append ( menu_shell, child );
}

/*-----------------20/08/2004 21:55-----------------
 * GtkCheckMenuItem
 * (c)2004 Rafa Carmona
 * --------------------------------------------------*/
HB_FUNC( GTK_CHECK_MENU_ITEM_NEW )
{
   GtkWidget * menuitem = gtk_check_menu_item_new( );
   hb_retnl( ( glong ) menuitem );
}

HB_FUNC( GTK_CHECK_MENU_ITEM_NEW_WITH_LABEL )
{
   GtkWidget * menuitem = gtk_check_menu_item_new_with_label( (gchar *)hb_parc( 1 ) );
   hb_retnl( ( glong ) menuitem );
}

HB_FUNC( GTK_CHECK_MENU_ITEM_NEW_WITH_MNEMONIC )
{
   GtkWidget * menuitem = gtk_check_menu_item_new_with_mnemonic( (gchar *)hb_parc( 1 ) );
   hb_retnl( ( glong ) menuitem );
}

HB_FUNC( GTK_CHECK_MENU_ITEM_GET_ACTIVE )
{
   GtkWidget * menuitem = GTK_WIDGET( hb_parnl( 1 ) );
   hb_retl( gtk_check_menu_item_get_active( GTK_CHECK_MENU_ITEM( menuitem ) ) );
}

HB_FUNC( GTK_CHECK_MENU_ITEM_SET_ACTIVE )
{
   GtkWidget * menuitem = GTK_WIDGET( hb_parnl( 1 ) );
   gtk_check_menu_item_set_active( GTK_CHECK_MENU_ITEM( menuitem ), hb_parl( 2 ) );
}

HB_FUNC( GTK_CHECK_MENU_ITEM_TOGGLED )
{
   GtkWidget * menuitem = GTK_WIDGET( hb_parnl( 1 ) );
   gtk_check_menu_item_toggled( GTK_CHECK_MENU_ITEM( menuitem ) );
}

HB_FUNC( GTK_CHECK_MENU_ITEM_GET_INCONSISTENT )
{
   GtkWidget * menuitem = GTK_WIDGET( hb_parnl( 1 ) );
   hb_retl( gtk_check_menu_item_get_inconsistent( GTK_CHECK_MENU_ITEM( menuitem ) ) );
}

HB_FUNC( GTK_CHECK_MENU_ITEM_SET_INCONSISTENT )
{
   GtkWidget * menuitem = GTK_WIDGET( hb_parnl( 1 ) );
   gtk_check_menu_item_set_inconsistent( GTK_CHECK_MENU_ITEM( menuitem ), hb_parl( 2 ) );
}

#if GTK_CHECK_VERSION( 2,4,0)
HB_FUNC( GTK_CHECK_MENU_ITEM_SET_DRAW_AS_RADIO )
{
   GtkWidget * menuitem = GTK_WIDGET( hb_parnl( 1 ) );
   gtk_check_menu_item_set_draw_as_radio( GTK_CHECK_MENU_ITEM( menuitem ), hb_parl( 2 ) );
}

HB_FUNC( GTK_CHECK_MENU_ITEM_GET_DRAW_AS_RADIO )
{
   GtkWidget * menuitem = GTK_WIDGET( hb_parnl( 1 ) );
   hb_retl( gtk_check_menu_item_get_draw_as_radio( GTK_CHECK_MENU_ITEM( menuitem ) ));
}
#endif
/*-----------------20/08/2004 00:40-----------------
 * GtkSeparatorMenu
 * (c)2004 Rafa Carmona
 * --------------------------------------------------*/

HB_FUNC( GTK_SEPARATOR_MENU_ITEM_NEW )
{
   GtkWidget * menuitem = gtk_separator_menu_item_new( );
   hb_retnl( ( glong ) menuitem );
}

/*-----------------20/08/2004 23:44-----------------
 * GtkImageMenuItem
 * (c)2004 Rafa Carmona
 * --------------------------------------------------*/
HB_FUNC( GTK_IMAGE_MENU_ITEM_SET_IMAGE )
{
   GtkWidget * menuitem = GTK_WIDGET( hb_parnl( 1 ) );
   GtkWidget * image    = GTK_WIDGET( hb_parnl( 2 ) );
   gtk_image_menu_item_set_image( GTK_IMAGE_MENU_ITEM( menuitem ), image );
}

HB_FUNC( GTK_IMAGE_MENU_ITEM_GET_IMAGE )
{
   GtkWidget * menuitem = GTK_WIDGET( hb_parnl( 1 ) );
   GtkWidget * image  = gtk_image_menu_item_get_image( GTK_IMAGE_MENU_ITEM( menuitem ) );
   hb_retnl( ( glong ) image );
}

HB_FUNC( GTK_IMAGE_MENU_ITEM_NEW )
{
   GtkWidget * menuitem = gtk_image_menu_item_new( );
   hb_retnl( ( glong ) menuitem );
}

HB_FUNC( GTK_IMAGE_MENU_ITEM_NEW_FROM_STOCK )
{
   GtkWidget * menuitem = gtk_image_menu_item_new_from_stock( (gchar *) hb_parc( 1 ), NULL );
                                            // TODO: GtkAccelGroup *accel_group);
   hb_retnl( ( glong ) menuitem );
}

HB_FUNC( GTK_IMAGE_MENU_ITEM_NEW_WITH_LABEL )
{
   GtkWidget * menuitem = gtk_image_menu_item_new_with_label( (gchar *) hb_parc( 1 ) );
   hb_retnl( ( glong ) menuitem );
}

HB_FUNC( GTK_IMAGE_MENU_ITEM_NEW_WITH_MNEMONIC )
{
   GtkWidget * menuitem = gtk_image_menu_item_new_with_mnemonic( (gchar *) hb_parc( 1 ) );
   hb_retnl( ( glong ) menuitem );
}

/*-----------------30/08/2004 22:54-----------------
 * GtkRadioMenuItem
 * (c)2004 Rafa Carmona
 * --------------------------------------------------*/

//struct      GtkRadioMenuItem;
HB_FUNC( GTK_RADIO_MENU_ITEM_NEW )
{
   GtkWidget * radio = gtk_radio_menu_item_new ( ( GSList * ) hb_parnl( 1 )  );
   hb_retnl( (glong) radio );
}

HB_FUNC( GTK_RADIO_MENU_ITEM_NEW_WITH_LABEL  )
{
   GtkWidget * radio ;
   GSList    * group = ( GSList * ) hb_parnl( 1 );
   radio = gtk_radio_menu_item_new_with_label(  group, (gchar *) hb_parc( 2 ) ) ;
   hb_retnl( (glong) radio );
}

HB_FUNC( GTK_RADIO_MENU_ITEM_NEW_WITH_MNEMONIC  )
{
   GtkWidget * radio ;
   GSList    * group = ( GSList * ) hb_parnl( 1 );
   radio = gtk_radio_menu_item_new_with_mnemonic(  group, (gchar *) hb_parc( 2 ) ) ;
   hb_retnl( (glong) radio );
}

#if GTK_CHECK_VERSION( 2,4,0)
HB_FUNC( GTK_RADIO_MENU_ITEM_NEW_FROM_WIDGET  ) // radio, label
{
   GtkWidget * radio ;
   GtkWidget * radio_widget = GTK_WIDGET( hb_parnl( 1 ) );
   radio = gtk_radio_menu_item_new_from_widget( GTK_RADIO_MENU_ITEM( radio_widget ) ) ;
   hb_retnl( (glong) radio );
}

HB_FUNC( GTK_RADIO_MENU_ITEM_NEW_WITH_LABEL_FROM_WIDGET  )
{
   GtkWidget * radio ;
   GtkWidget * radio_widget = GTK_WIDGET( hb_parnl( 1 ) );
   radio =  gtk_radio_menu_item_new_with_label_from_widget( GTK_RADIO_MENU_ITEM( radio_widget ), (gchar *) hb_parc( 2 ) ) ;
   hb_retnl( (glong) radio );
}

HB_FUNC( GTK_RADIO_MENU_ITEM_NEW_WITH_MNEMONIC_FROM_WIDGET  )
{
   GtkWidget * radio ;
   GtkWidget * radio_widget = GTK_WIDGET( hb_parnl( 1 ) );
   radio =  gtk_radio_menu_item_new_with_mnemonic_from_widget( GTK_RADIO_MENU_ITEM( radio_widget ), (gchar *) hb_parc( 2 ) ) ;
   hb_retnl( (glong) radio );
}
#endif

HB_FUNC( GTK_RADIO_MENU_ITEM_SET_GROUP )
{
  GtkWidget * radio = GTK_WIDGET( hb_parnl( 1 ) );
  GSList    * group = ( GSList * ) hb_parnl( 2 );
  gtk_radio_menu_item_set_group( GTK_RADIO_MENU_ITEM( radio ), group );
}

HB_FUNC( GTK_RADIO_MENU_ITEM_GET_GROUP )
{
  GtkWidget * radio = GTK_WIDGET( hb_parnl( 1 ) );
  GSList    * group = gtk_radio_menu_item_get_group( GTK_RADIO_MENU_ITEM( radio ) );
  hb_retnl( (glong) group );
}

HB_FUNC( HB_GTK_MENU_POPUP )
{
  GtkMenu * menu = GTK_MENU( hb_parnl( 1 ) );
  gtk_menu_popup( menu, NULL,NULL,NULL,NULL,0, gtk_get_current_event_time() );
}

HB_FUNC( GTK_MENU_POPUP )
{
  GtkMenu * menu = GTK_MENU( hb_parnl( 1 ) );
  gtk_menu_popup( menu, NULL,NULL,NULL,NULL, hb_parni( 6 ), hb_parni( 7 ) );
}
