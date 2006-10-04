/* $Id: gtkentry.c,v 1.2 2006-10-04 08:35:28 rosenwla Exp $*/
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

HB_FUNC( GTK_ENTRY_NEW ) // -->widget
{
   GtkWidget * hWnd = gtk_entry_new();
   hb_retnl( ( glong ) hWnd );
}

HB_FUNC( GTK_EDITABLE_GET_POSITION ) // widget
{
   GtkWidget * Entry = GTK_WIDGET( hb_parnl( 1 ) );

   hb_retni( gtk_editable_get_position( GTK_EDITABLE( Entry ) ) );
}

HB_FUNC( GTK_EDITABLE_SET_POSITION ) // widget, nPosition
{
   GtkWidget * Entry = GTK_WIDGET( hb_parnl( 1 ) );

   gtk_editable_set_position( GTK_EDITABLE( Entry ), hb_parni( 2 ) );
}

HB_FUNC( GTK_EDITABLE_SET_EDITABLE ) // widget, is_editable
{
   GtkWidget * Entry = GTK_WIDGET( hb_parnl( 1 ) );

   gtk_editable_set_editable( GTK_EDITABLE( Entry ), hb_parl( 2 ) );
}

HB_FUNC( GTK_ENTRY_SET_TEXT ) // widget, ctext
{
   GtkWidget * Entry = GTK_WIDGET( hb_parnl( 1 ) );

   gtk_entry_set_text( GTK_ENTRY( Entry ), hb_parc( 2 ) );
}

HB_FUNC( GTK_ENTRY_GET_TEXT ) // widgert --> cText
{
   GtkWidget * Entry = GTK_WIDGET( hb_parnl( 1 ) );

   hb_retc(  (gchar *) gtk_entry_get_text( GTK_ENTRY( Entry ) ) );
}

HB_FUNC( GTK_ENTRY_SET_VISIBILITY ) // pWidget, bVisible
{
   GtkWidget * Entry = GTK_WIDGET( hb_parnl( 1 ) );
   gtk_entry_set_visibility( GTK_ENTRY( Entry ), hb_parl( 2 ) );
}

#if GTK_CHECK_VERSION( 2,4,0)
HB_FUNC( GTK_ENTRY_SET_ALIGNMENT )
{
   GtkWidget * Entry = GTK_WIDGET( hb_parnl( 1 ) );
   gtk_entry_set_alignment( GTK_ENTRY( Entry ), hb_parnl( 2 ) );
}
#endif

HB_FUNC( GTK_ENTRY_SET_MAX_LENGTH ) // pWidget, max
{
	GtkWidget * Entry = GTK_WIDGET( hb_parnl( 1 ) );
	gtk_entry_set_max_length( GTK_ENTRY( Entry ), (gint) hb_parni( 2) );
}

HB_FUNC( GTK_ENTRY_GET_MAX_LENGTH )
{
	GtkWidget * Entry = GTK_WIDGET( hb_parnl( 1 ) );
	hb_retni( gtk_entry_get_max_length( GTK_ENTRY( Entry ) ) );
}

HB_FUNC( GTK_ENTRY_SET_ACTIVATES_DEFAULT )
{
   GtkWidget * Entry = GTK_WIDGET( hb_parnl( 1 ) );
   gtk_entry_set_activates_default( GTK_ENTRY( Entry ), hb_parnl( 2 ) );
}     

HB_FUNC( GTK_ENTRY_GET_COMPLETION )
{
   GtkWidget * Entry = GTK_WIDGET( hb_parnl( 1 ) );
   GtkEntryCompletion * completion = gtk_entry_get_completion(GTK_ENTRY( Entry ) );
   hb_retnl( ( glong ) completion );
}   
        
