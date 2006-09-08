/* $Id: gtkcombobox.c,v 1.1 2006-09-08 12:18:45 xthefull Exp $*/
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
/*
 Combobox
 */
#if GTK_CHECK_VERSION( 2,4,0)
HB_FUNC( GTK_COMBO_BOX_NEW )
{
   GtkWidget * combo = gtk_combo_box_new();
   hb_retnl( ( glong ) combo );
}

HB_FUNC( GTK_COMBO_BOX_NEW_WITH_MODEL )
{
   GtkWidget * combo = gtk_combo_box_new_with_model( GTK_TREE_MODEL( hb_parnl( 1 ) ) );
   hb_retnl( ( glong ) combo );
}

HB_FUNC( GTK_COMBO_BOX_SET_WRAP_WIDTH )
{
   GtkWidget * combo = GTK_WIDGET( hb_parnl( 1 ) );
   gint iWidth = hb_parni( 2 );
   gtk_combo_box_set_wrap_width( GTK_COMBO_BOX( combo ), iWidth );
}

HB_FUNC( GTK_COMBO_BOX_SET_ROW_SPAN_COLUMN )
{
   GtkWidget * combo = GTK_WIDGET( hb_parnl( 1 ) );
   gint iRow_Span = hb_parni( 2 );
   gtk_combo_box_set_row_span_column( GTK_COMBO_BOX( combo ), iRow_Span );
}

HB_FUNC( GTK_COMBO_BOX_SET_COLUMN_SPAN_COLUMN )
{
   GtkWidget * combo = GTK_WIDGET( hb_parnl( 1 ) );
   gint iCol_Span = hb_parni( 2 );
   gtk_combo_box_set_column_span_column( GTK_COMBO_BOX( combo ), iCol_Span );
}

HB_FUNC( GTK_COMBO_BOX_NEW_TEXT )
{
   GtkWidget * combo = gtk_combo_box_new_text();
   hb_retnl( ( glong ) combo );
}

HB_FUNC( GTK_COMBO_BOX_APPEND_TEXT )
{
  GtkWidget * combo = GTK_WIDGET( hb_parnl( 1 ) );
  gtk_combo_box_append_text ( GTK_COMBO_BOX (combo), (gchar *) hb_parc( 2 ) );
}

HB_FUNC( GTK_COMBO_BOX_INSERT_TEXT )
{
  GtkWidget * combo = GTK_WIDGET( hb_parnl( 1 ) );
  gint position = hb_parni( 2 );
  gchar *text = hb_parc( 3 );
  gtk_combo_box_insert_text( GTK_COMBO_BOX (combo), position ,text );
}

HB_FUNC( GTK_COMBO_BOX_PREPEND_TEXT )
{
  GtkWidget * combo = GTK_WIDGET( hb_parnl( 1 ) );
  gchar *text = hb_parc( 2 );
  gtk_combo_box_prepend_text ( GTK_COMBO_BOX (combo), text );
}

HB_FUNC( GTK_COMBO_BOX_REMOVE_TEXT )
{
  GtkWidget * combo = GTK_WIDGET( hb_parnl( 1 ) );
  gint position = hb_parni( 2 );
  gtk_combo_box_remove_text( GTK_COMBO_BOX (combo), position );
}

HB_FUNC( GTK_COMBO_BOX_GET_ACTIVE )// iActive or -1 not Active
{
  GtkWidget * combo = GTK_WIDGET( hb_parnl( 1 ) );
  gint iActive = gtk_combo_box_get_active( GTK_COMBO_BOX (combo) );
  hb_retni( iActive );
}

HB_FUNC( GTK_COMBO_BOX_SET_ACTIVE )// combo,index
{
  GtkWidget * combo = GTK_WIDGET( hb_parnl( 1 ) );
  gint position = (gint)hb_parni( 2 );
  gtk_combo_box_set_active( GTK_COMBO_BOX (combo), position );
}

// Todo:
/* gtk_combo_box_get_active_iter ()
   gtk_combo_box_set_active_iter ()
 * gtk_combo_box_get_model ()
 * gtk_combo_box_set_model ()
 */

HB_FUNC( GTK_COMBO_BOX_POPUP )
{
  GtkWidget * combo = GTK_WIDGET( hb_parnl( 1 ) );
  gtk_combo_box_popup( GTK_COMBO_BOX( combo ) );
}

HB_FUNC( GTK_COMBO_BOX_POPDOWN )
{
  GtkWidget * combo = GTK_WIDGET( hb_parnl( 1 ) );
  gtk_combo_box_popdown( GTK_COMBO_BOX( combo ) );
}

/* GtkComboEntry . Child is widget Entry */
HB_FUNC( GTK_COMBO_BOX_ENTRY_NEW )
{
   GtkWidget * combo = gtk_combo_box_entry_new();
   hb_retnl( ( glong ) combo );
}

HB_FUNC( GTK_COMBO_BOX_ENTRY_NEW_WITH_MODEL ) // TreeModel, iText_Column
{
   GtkWidget * combo = gtk_combo_box_entry_new_with_model( GTK_TREE_MODEL( hb_parnl( 1 ) ), (gint) hb_parni( 2 ) );
   hb_retnl( ( glong ) combo );
}

HB_FUNC( GTK_COMBO_ENTRY_NEW_TEXT )
{
   GtkWidget * combo = gtk_combo_box_entry_new_text ();
   hb_retnl( ( glong ) combo );
}

HB_FUNC( GTK_COMBO_BOX_ENTRY_SET_TEXT_COLUMN )
{
   GtkWidget * entry_box = GTK_WIDGET( hb_parnl( 1 ) );
   gtk_combo_box_entry_set_text_column( GTK_COMBO_BOX_ENTRY(entry_box), (gint)hb_parni( 2 ) );
}

HB_FUNC( TGTK_GET_TEXT_COMBO_ENTRY )
{
 GtkWidget * combo_box = GTK_WIDGET( hb_parnl( 1 ) );
 GtkEntry * entry = GTK_ENTRY(GTK_BIN (combo_box)->child );
 hb_retc( gtk_entry_get_text( entry ) );
}

HB_FUNC( TGTK_GET_WIDGET_COMBO_ENTRY )
{
 GtkWidget * combo_box = GTK_WIDGET( hb_parnl( 1 ) );
 GtkEntry * entry = GTK_ENTRY(GTK_BIN (combo_box)->child );
 hb_retnl( (glong) entry  );
}

#endif

/* OBSOLETO ------->
HB_FUNC( GTK_COMBO_NEW )
{
   GtkWidget * combo = gtk_combo_new();
   hb_retnl( ( glong ) combo );
}

HB_FUNC( GTK_COMBO_SET_POPDOWN_STRINGS )
 {
  GtkWidget * combo = GTK_WIDGET( hb_parnl( 1 ) );
  gtk_combo_set_popdown_strings( GTK_COMBO(combo), (GList*)hb_parnl( 2 ) );
 }
 OBSOLETO ------->  */
