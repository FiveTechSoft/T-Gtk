/* $Id: gtktogglebutton.c,v 1.1 2006-09-08 12:18:45 xthefull Exp $*/
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
#include <t-gtk.h>


HB_FUNC( GTK_TOGGLE_BUTTON_NEW ) // -> widget
{
   GtkWidget * button = gtk_toggle_button_new( );
   hb_retptr( (GtkWidget *) button );
}

HB_FUNC( GTK_TOGGLE_BUTTON_NEW_WITH_LABEL ) //cText -> widget
{
   GtkWidget * button;
   gchar *msg = str2utf8( ( gchar * ) hb_parc( 1 ) ); //g_convert( hb_parc(1), -1,"UTF-8","ISO-8859-1",NULL,NULL,NULL );
   button = gtk_toggle_button_new_with_label ( msg );
   SAFE_RELEASE( msg );
   hb_retptr( (GtkWidget *) button );
}

HB_FUNC( GTK_TOGGLE_BUTTON_NEW_WITH_MNEMONIC ) //cText -> widget
{
   GtkWidget * button;
   gchar *msg = str2utf8( ( gchar * ) hb_parc( 1 ) );//g_convert( hb_parc(1), -1,"UTF-8","ISO-8859-1",NULL,NULL,NULL );

   button = gtk_toggle_button_new_with_mnemonic( msg );
   
   SAFE_RELEASE( msg );

   hb_retptr( (GtkWidget *) button );

}

/* Afecta solamente a Checks y radios.*/
HB_FUNC( GTK_TOGGLE_BUTTON_SET_MODE )
{
  GtkWidget * button = GTK_WIDGET( hb_parptr( 1 ) );
  gtk_toggle_button_set_mode( GTK_TOGGLE_BUTTON( button ), hb_parl( 2 ) );
}

HB_FUNC( GTK_TOGGLE_BUTTON_GET_MODE )
{
  GtkWidget * button = GTK_WIDGET( hb_parptr( 1 ) );
  hb_retl( gtk_toggle_button_get_mode( GTK_TOGGLE_BUTTON( button ) ) );
}

HB_FUNC( GTK_TOGGLE_BUTTON_TOGGLED ) // widget
{
  GtkWidget * button = GTK_WIDGET( hb_parptr( 1 ) );
  gtk_toggle_button_toggled( GTK_TOGGLE_BUTTON( button ) );
}

HB_FUNC( GTK_TOGGLE_BUTTON_GET_ACTIVE ) //widget --> lActivo
{
  GtkWidget * button = GTK_WIDGET( hb_parptr( 1 ) );
  hb_retl( gtk_toggle_button_get_active( GTK_TOGGLE_BUTTON( button ) ) );
}

HB_FUNC( GTK_TOGGLE_BUTTON_SET_STATE ) // widget, lstate
{
   GtkWidget * button = GTK_WIDGET( hb_parptr( 1 ) );
   #if GTK_MAJOR_VERSION < 3
     gtk_toggle_button_set_state( GTK_TOGGLE_BUTTON( button ), hb_parl( 2 ) );
   #else
     gtk_toggle_button_set_active( GTK_TOGGLE_BUTTON( button ), hb_parl( 2 ) );
   #endif
   g_message( "gtk_toggle_button_set_state is deprecated! /n Use gtk_toggle_button_set_active" );
}

HB_FUNC( GTK_TOGGLE_BUTTON_SET_ACTIVE ) // widget, lstate
{
   GtkWidget * button = GTK_WIDGET( hb_parptr( 1 ) );
   gtk_toggle_button_set_active( GTK_TOGGLE_BUTTON( button ), hb_parl( 2 ) );
}

HB_FUNC( GTK_TOGGLE_BUTTON_GET_INCONSISTENT ) // widget --> linconsistent
{
   GtkWidget * button = GTK_WIDGET( hb_parptr( 1 ) );
   hb_retl( gtk_toggle_button_get_inconsistent( GTK_TOGGLE_BUTTON( button ) ) );
}

HB_FUNC( GTK_TOGGLE_BUTTON_SET_INCONSISTENT ) // widget ,linconsistent
{
   GtkWidget * button = GTK_WIDGET( hb_parptr( 1 ) );
   gtk_toggle_button_set_inconsistent( GTK_TOGGLE_BUTTON( button ), hb_parl( 2 ) );
}

//eof
