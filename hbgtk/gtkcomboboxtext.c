/* $Id: gtkcomboboxtext.c,v 1.0 2020-06-20 23:11:53 xthefull Exp $*/
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
    (c)2022 Riztan Gutierrez 
*/
#include <gtk/gtk.h>
#include "hbapi.h"


HB_FUNC( GTK_COMBO_BOX_TEXT_NEW )
{
   GtkWidget * combo = gtk_combo_box_text_new();
   hb_retptr( ( GtkWidget * ) combo );
}


HB_FUNC( GTK_COMBO_BOX_TEXT_NEW_WITH_ENTRY )
{
   GtkWidget * combo = gtk_combo_box_text_new_with_entry();
   hb_retptr( ( GtkWidget * ) combo );
}


HB_FUNC( GTK_COMBO_BOX_TEXT_APPEND )
{
  GtkComboBoxText * combo = GTK_COMBO_BOX_TEXT( hb_parptr( 1 ) );
  const gchar * id   = ( gchar * ) hb_parc( 2 );
  const gchar * text = ( gchar * ) hb_parc( 3 );
  gtk_combo_box_text_append( combo, id, text );
}


HB_FUNC( GTK_COMBO_BOX_TEXT_PREPEND )
{
  GtkComboBoxText * combo = GTK_COMBO_BOX_TEXT( hb_parptr( 1 ) );
  const gchar *id   = ( gchar * ) hb_parc( 2 );
  const gchar *text = ( gchar * ) hb_parc( 3 );
  gtk_combo_box_text_prepend( combo, id, text );
}


HB_FUNC( GTK_COMBO_BOX_TEXT_INSERT )
{
  GtkComboBoxText * combo = GTK_COMBO_BOX_TEXT( hb_parptr( 1 ) );
  gint position = hb_parni( 2 );
  const gchar *id   = ( gchar * ) hb_parc( 3 );
  const gchar *text = ( gchar * ) hb_parc( 4 );
  gtk_combo_box_text_insert( combo, position, id, text );
}


HB_FUNC( GTK_COMBO_BOX_TEXT_APPEND_TEXT )
{
  GtkComboBoxText * combo = GTK_COMBO_BOX_TEXT( hb_parptr( 1 ) );
  const gchar * text = ( gchar * ) hb_parc( 2 );
  gtk_combo_box_text_append_text ( combo, text );
}


HB_FUNC( GTK_COMBO_BOX_TEXT_PREPEND_TEXT )
{
  GtkComboBoxText * combo = GTK_COMBO_BOX_TEXT( hb_parptr( 1 ) );
  const gchar * text = ( gchar * ) hb_parc( 2 );
  gtk_combo_box_text_prepend_text ( combo, text );
}


HB_FUNC( GTK_COMBO_BOX_TEXT_INSERT_TEXT )
{
  GtkComboBoxText * combo = GTK_COMBO_BOX_TEXT( hb_parptr( 1 ) );
  gint position = hb_parni( 2 );
  const gchar * text = ( gchar * ) hb_parc( 2 );
  gtk_combo_box_text_insert_text ( combo, position, text );
}


HB_FUNC( GTK_COMBO_BOX_TEXT_REMOVE )
{
  GtkComboBoxText * combo = GTK_COMBO_BOX_TEXT( hb_parptr( 1 ) );
  gint position = hb_parni( 2 );
  gtk_combo_box_text_remove( combo, position );
}


HB_FUNC( GTK_COMBO_BOX_TEXT_REMOVE_ALL )
{
  GtkComboBoxText * combo = GTK_COMBO_BOX_TEXT( hb_parptr( 1 ) );
  gtk_combo_box_text_remove_all( combo );
}


HB_FUNC( GTK_COMBO_BOX_TEXT_GET_ACTIVE_TEXT )
{
  GtkComboBoxText * combo = GTK_COMBO_BOX_TEXT( hb_parptr( 1 ) );
  hb_retc( gtk_combo_box_text_get_active_text( combo ) );
}


//eof
