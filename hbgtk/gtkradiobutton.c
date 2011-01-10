/* $Id: gtkradiobutton.c,v 1.1 2006-09-08 12:18:45 xthefull Exp $*/
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

HB_FUNC( GTK_RADIO_BUTTON_NEW ) // NULL o Group -->radio
{
   GtkWidget * radio = gtk_radio_button_new( ( GSList * ) hb_parptr( 1 )  );
   hb_retptr( ( GtkWidget * ) radio );
}

HB_FUNC( GTK_RADIO_BUTTON_NEW_FROM_WIDGET ) //group-->radio
{
   GtkWidget * radio = gtk_radio_button_new_from_widget( GTK_RADIO_BUTTON( hb_parptr( 1 ) )) ;
   hb_retptr( ( GtkWidget * ) radio );
}
  
HB_FUNC( GTK_RADIO_BUTTON_NEW_WITH_LABEL ) // group, label-->radio
{
   GtkWidget * radio ;
   GSList * group = ( GSList * ) hb_parptr( 1 );
   radio = gtk_radio_button_new_with_label(  group, (gchar *) hb_parc( 2 ) ) ;
   hb_retptr( ( GtkWidget * ) radio );
}

HB_FUNC( GTK_RADIO_BUTTON_NEW_WITH_LABEL_FROM_WIDGET ) // radio, label
{
   GtkWidget * radio ;
   GtkWidget * radio_widget = GTK_WIDGET( hb_parptr( 1 ) );
   radio = gtk_radio_button_new_with_label_from_widget( GTK_RADIO_BUTTON( radio_widget ), (gchar *) hb_parc( 2 ) ) ;
   hb_retptr( ( GtkWidget * ) radio );
}

HB_FUNC( GTK_RADIO_BUTTON_NEW_WITH_MNEMONIC ) // group, label
{
   GtkWidget * radio ;
   GSList * group = ( GSList * ) hb_parptr( 1 );
   radio = gtk_radio_button_new_with_mnemonic (  group, (gchar *) hb_parc( 2 ) ) ;
   hb_retptr( ( GtkWidget * ) radio );
}

HB_FUNC( GTK_RADIO_BUTTON_NEW_WITH_MNEMONIC_FROM_WIDGET ) // radio, label
{
   GtkWidget * radio ;
   GtkWidget * radio_widget = GTK_WIDGET( hb_parptr( 1 ) );
   radio = gtk_radio_button_new_with_mnemonic_from_widget( GTK_RADIO_BUTTON( radio_widget ), (gchar *) hb_parc( 2 ) ) ;
   hb_retptr( ( GtkWidget * ) radio );
}

HB_FUNC( GTK_RADIO_BUTTON_SET_GROUP )
{
  GtkWidget * radio = GTK_WIDGET( hb_parptr( 1 ) );
  GSList    * group = ( GSList * ) hb_parptr( 2 );
  gtk_radio_button_set_group( GTK_RADIO_BUTTON( radio ), group );
}

HB_FUNC( GTK_RADIO_BUTTON_GET_GROUP )
{
  GtkWidget * radio = GTK_WIDGET( hb_parptr( 1 ) );
  GSList*     group = gtk_radio_button_get_group( GTK_RADIO_BUTTON( radio ) );
  hb_retptr( ( GtkWidget * ) group );
}
