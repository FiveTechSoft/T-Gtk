/* $Id: dlgselects.c,v 1.1 2006-09-08 12:18:45 xthefull Exp $*/
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
/*
 * Distintos dialogos de Selecccion, de fonts, de archivos, de color...
*/

#if GTK_MAJOR_VERSION < 3

#include <gtk/gtk.h>
#include "hbapi.h"

HB_FUNC( __GET_POINTER_BTN_OK_FILE )
{
   GtkWidget * file_selector = GTK_WIDGET( hb_parptr( 1 ) );
   hb_retptr( (GtkWidget *) GTK_FILE_SELECTION (file_selector)->ok_button );
}

HB_FUNC( __GET_POINTER_BTN_CANCEL_FILE )
{
   GtkWidget * file_selector = GTK_WIDGET( hb_parptr( 1 ) );
   hb_retptr( (GtkWidget *) GTK_FILE_SELECTION (file_selector)->cancel_button );
}


/* Seleccion de dialogo de fonts */
HB_FUNC( __GET_POINTER_BTN_OK_FONT )
{
   GtkWidget * dlg_font = GTK_WIDGET( hb_parptr( 1 ) );
   hb_retptr( (GtkWidget *) GTK_FONT_SELECTION_DIALOG (dlg_font)->ok_button );
}

HB_FUNC( __GET_POINTER_BTN_CANCEL_FONT )
{
   GtkWidget * dlg_font = GTK_WIDGET( hb_parptr( 1 ) );
   hb_retptr( (GtkWidget *) GTK_FONT_SELECTION_DIALOG(dlg_font)->cancel_button );
}

HB_FUNC( GTK_FONT_SELECTION_DIALOG_NEW ) /* cTitle */
{
   GtkWidget *dlg_font;
   dlg_font = gtk_font_selection_dialog_new ( hb_parc( 1 ) );
   hb_retptr( (GtkWidget *) dlg_font );
}

HB_FUNC( GTK_FONT_SELECTION_DIALOG_GET_FONT_NAME )
{
   GtkWidget * dlg_font = GTK_WIDGET( hb_parptr( 1 ) );
   hb_retc( ( gchar * ) gtk_font_selection_dialog_get_font_name(
                            GTK_FONT_SELECTION_DIALOG( dlg_font ) ) );
}

HB_FUNC( GTK_FONT_SELECTION_DIALOG_SET_FONT_NAME )
{
   GtkWidget * dlg_font = GTK_WIDGET( hb_parptr( 1 ) );
   hb_retl( gtk_font_selection_dialog_set_font_name(
                            GTK_FONT_SELECTION_DIALOG( dlg_font ), hb_parc( 2 ) ) );
}

HB_FUNC( GTK_FONT_SELECTION_DIALOG_SET_PREVIEW_TEXT )
{
   GtkWidget * dlg_font = GTK_WIDGET( hb_parptr( 1 ) );
   gtk_font_selection_dialog_set_preview_text( GTK_FONT_SELECTION_DIALOG( dlg_font ),
                                                hb_parc( 2 ) );
}

HB_FUNC( GTK_FONT_SELECTION_DIALOG_GET_PREVIEW_TEXT )
{
   GtkWidget * dlg_font = GTK_WIDGET( hb_parptr( 1 ) );
   hb_retc( (gchar*) gtk_font_selection_dialog_get_preview_text( GTK_FONT_SELECTION_DIALOG( dlg_font ) ));
}
#endif

//eof
