/* $Id: gtkfilechooserbutton.c,v 1.1 2006-09-08 12:18:45 xthefull Exp $*/
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

#if GTK_CHECK_VERSION(2,6,0)

HB_FUNC( GTK_FILE_CHOOSER_BUTTON_NEW )
{
  GtkWidget * button;
  GtkFileChooserAction action = hb_parni( 2 );
  button = gtk_file_chooser_button_new ( hb_parc( 1 ), action );
  hb_retnl( (glong) button );
}

HB_FUNC( GTK_FILE_CHOOSER_BUTTON_NEW_WITH_BACKEND )
{
  GtkWidget * button;
  GtkFileChooserAction action = hb_parni( 2 );
  button = gtk_file_chooser_button_new_with_backend( hb_parc( 1 ), action , hb_parc( 3 ) );
  hb_retnl( (glong) button );
}

HB_FUNC( GTK_FILE_CHOOSER_BUTTON_NEW_WITH_DIALOG )
{
  GtkWidget * button;
  GtkWidget * dialog = GTK_WIDGET( hb_parnl( 1 ) );
  button = gtk_file_chooser_button_new_with_dialog( dialog );
  hb_retnl( (glong) button );
}

HB_FUNC( GTK_FILE_CHOOSER_BUTTON_GET_TITLE )
{
  GtkFileChooserButton * button = GTK_FILE_CHOOSER_BUTTON( hb_parnl( 1 ) );
  hb_retc( (gchar * ) gtk_file_chooser_button_get_title( button ) );
}

HB_FUNC( GTK_FILE_CHOOSER_BUTTON_SET_TITLE )
{
  GtkFileChooserButton * button = GTK_FILE_CHOOSER_BUTTON( hb_parnl( 1 ) );
  gtk_file_chooser_button_set_title( button , hb_parc( 2 ) );
}

HB_FUNC( GTK_FILE_CHOOSER_BUTTON_GET_WIDTH_CHARS )
{
  GtkFileChooserButton * button = GTK_FILE_CHOOSER_BUTTON( hb_parnl( 1 ) );
  hb_retni( (gint) gtk_file_chooser_button_get_width_chars( button ) );
}

HB_FUNC( GTK_FILE_CHOOSER_BUTTON_SET_WIDTH_CHARS )
{
  GtkFileChooserButton * button = GTK_FILE_CHOOSER_BUTTON( hb_parnl( 1 ) );
  gtk_file_chooser_button_set_width_chars( button, hb_parni( 2 ) );
}

#endif
