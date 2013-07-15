/* $Id: gtklabel.c,v 1.1 2006-09-08 12:18:45 xthefull Exp $*/
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
#include <gtk/gtk.h>
#include <t-gtk.h>

#ifdef _GTK2_

HB_FUNC( GTK_LABEL_NEW )
{
   gchar * ctxt = str2utf8( ( gchar * ) hb_parc( 1 ) );

   GtkWidget * label = gtk_label_new( ctxt );
   
   SAFE_RELEASE( ctxt );
   
   hb_retptr( ( GtkWidget * ) label );
}

//--------------------------------------------------------//

HB_FUNC( GTK_LABEL_NEW_WITH_MNEMONIC )
{
   gchar * ctxt = str2utf8( ( gchar * ) hb_parc( 1 ) );
   GtkWidget * label = gtk_label_new_with_mnemonic( ctxt );
   SAFE_RELEASE( ctxt );   
   hb_retptr( ( GtkWidget * ) label );
}

//--------------------------------------------------------//

HB_FUNC( GTK_LABEL_SET_TEXT ) //widget, cText
{
   gchar * ctxt = str2utf8( ( gchar * ) hb_parc( 2 ) );
   GtkWidget * label = GTK_WIDGET( hb_parptr( 1 ) );
   gtk_label_set_text( GTK_LABEL( label ), ctxt );
   SAFE_RELEASE( ctxt );
   
}

//--------------------------------------------------------//

HB_FUNC( GTK_LABEL_GET_TEXT ) // widget
{
   GtkWidget * label = GTK_WIDGET( hb_parptr( 1 ) );
   hb_retc( ( gchar * ) gtk_label_get_text( GTK_LABEL( label ) ) );
}

//--------------------------------------------------------//

HB_FUNC( GTK_LABEL_SET_MNEMONIC_WIDGET ) //widget_label, widget
{
   GtkWidget * label = GTK_WIDGET( hb_parptr( 1 ) );
   GtkWidget * widget = GTK_WIDGET( hb_parptr( 2 ) );
   gtk_label_set_mnemonic_widget( GTK_LABEL( label ), widget );
}

//--------------------------------------------------------//


// http://developer.gnome.org/doc/API/2.2/pango/PangoMarkupFormat.html
// <span foreground="blue" size="100">Blue text</span> is <i>cool</i>!
HB_FUNC( GTK_LABEL_SET_MARKUP ) // widget, cText
{
   GtkWidget * label = GTK_WIDGET( hb_parptr( 1 ) );
   gtk_label_set_markup ( ( GtkLabel * ) label, (gchar *) hb_parc( 2 ) );
}

//--------------------------------------------------------//

HB_FUNC( GTK_LABEL_SET_MARKUP_WITH_MNEMONIC ) // widget, cText
{
   gchar * ctxt = str2utf8( ( gchar * ) hb_parc( 2 ) );   
   GtkWidget * label = GTK_WIDGET( hb_parptr( 1 ) );
   gtk_label_set_markup_with_mnemonic( GTK_LABEL( label ), ctxt );
   SAFE_RELEASE( ctxt );
}

//--------------------------------------------------------//

HB_FUNC( GTK_LABEL_SET_LINE_WRAP ) // widget, lWrap
{
   GtkWidget * label = GTK_WIDGET( hb_parptr( 1 ) );
   gtk_label_set_line_wrap( GTK_LABEL( label ), hb_parl( 2 ) );
}

//--------------------------------------------------------//

HB_FUNC( GTK_LABEL_GET_LINE_WRAP )
{
   GtkWidget * label = GTK_WIDGET( hb_parptr( 1 ) );
   hb_retl( gtk_label_get_line_wrap( GTK_LABEL( label ) ) );
}

//--------------------------------------------------------//

HB_FUNC( GTK_LABEL_SET_PATTERN )
{
   GtkWidget * label = GTK_WIDGET( hb_parptr( 1 ) );
   gtk_label_set_pattern( GTK_LABEL( label ), (gchar *) hb_parc( 2 ) );
}

//--------------------------------------------------------//

HB_FUNC( GTK_LABEL_SET_JUSTIFY ) //widget, iJustify
{
   GtkWidget * label = GTK_WIDGET( hb_parptr( 1 ) );
   gtk_label_set_justify(GTK_LABEL( label ), hb_parni( 2 ) );
}

//--------------------------------------------------------//

HB_FUNC( GTK_LABEL_GET_JUSTIFY )
{
   GtkWidget * label = GTK_WIDGET( hb_parptr( 1 ) );
   hb_retni( gtk_label_get_justify( GTK_LABEL( label ) ) );
}

//--------------------------------------------------------//

HB_FUNC( GTK_LABEL_GET_MNEMONIC_KEYVAL )
{
   GtkWidget * label = GTK_WIDGET( hb_parptr( 1 ) );
   hb_retni( (guint) gtk_label_get_mnemonic_keyval( GTK_LABEL( label ) ) );
}

//--------------------------------------------------------//

HB_FUNC( GTK_LABEL_GET_SELECTABLE )
{
   GtkWidget * label = GTK_WIDGET( hb_parptr( 1 ) );
   hb_retl( gtk_label_get_selectable( GTK_LABEL( label ) ) );
}

//--------------------------------------------------------//

HB_FUNC( GTK_LABEL_SET_SELECTABLE )
{
   GtkWidget * label = GTK_WIDGET( hb_parptr( 1 ) );
   gtk_label_set_selectable( GTK_LABEL( label ), hb_parl(2) );
}

//--------------------------------------------------------//

HB_FUNC( GTK_LABEL_SELECT_REGION )      // widget, istart_offset , iend_offset
{
   GtkWidget * label = GTK_WIDGET( hb_parptr( 1 ) );
   gtk_label_select_region( GTK_LABEL( label ), (gint) hb_parni( 2 ), (gint)hb_parni( 3 ) );
}

//--------------------------------------------------------//

HB_FUNC( GTK_LABEL_SET_TEXT_WITH_MNEMONIC )
{
   gchar * ctxt = str2utf8( ( gchar * ) hb_parc( 2 ) );
   GtkWidget * label = GTK_WIDGET( hb_parptr( 1 ) );
   gtk_label_set_text_with_mnemonic( GTK_LABEL( label ), ctxt );
   SAFE_RELEASE( ctxt );
}

//--------------------------------------------------------//

HB_FUNC( GTK_LABEL_GET_SELECTION_BOUNDS )
{
   GtkWidget * label = GTK_WIDGET( hb_parptr( 1 ) );
   hb_retl( gtk_label_get_selection_bounds( GTK_LABEL( label ), (gint *) hb_parni(2), (gint *) hb_parni(3) ));
}

//--------------------------------------------------------//

HB_FUNC( GTK_LABEL_GET_USE_MARKUP )
{
   GtkWidget * label = GTK_WIDGET( hb_parptr( 1 ) );
   hb_retl( gtk_label_get_use_markup( GTK_LABEL( label ) ) );
}

//--------------------------------------------------------//

HB_FUNC( GTK_LABEL_GET_USE_UNDERLINE )
{
   GtkWidget * label = GTK_WIDGET( hb_parptr( 1 ) );
   hb_retl( gtk_label_get_use_underline( GTK_LABEL( label ) ) );
}

//--------------------------------------------------------//

HB_FUNC( GTK_LABEL_SET_LABEL )
{
   gchar * ctxt = str2utf8( ( gchar * ) hb_parc( 2 ) );
   GtkWidget * label = GTK_WIDGET( hb_parptr( 1 ) );
   gtk_label_set_label( GTK_LABEL( label ), ctxt );
   SAFE_RELEASE( ctxt );
}

//--------------------------------------------------------//

HB_FUNC( GTK_LABEL_SET_USE_MARKUP )
{
   GtkWidget * label = GTK_WIDGET( hb_parptr( 1 ) );
   gtk_label_set_use_markup( GTK_LABEL( label ), hb_parl( 2 ) );
}

//--------------------------------------------------------//

HB_FUNC( GTK_LABEL_SET_USE_UNDERLINE ) 
{
   GtkWidget * label = GTK_WIDGET( hb_parptr( 1 ) );
   gtk_label_set_use_underline( GTK_LABEL( label ), hb_parl( 2 ) );
}

//--------------------------------------------------------//

#endif
