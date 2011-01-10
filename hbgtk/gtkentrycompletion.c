/* $Id: gtkentrycompletion.c,v 1.1 2006-09-08 12:18:45 xthefull Exp $*/
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

HB_FUNC( GTK_ENTRY_COMPLETION_NEW ) 
{
   GtkEntryCompletion * completion = gtk_entry_completion_new();
   hb_retptr( ( GtkEntryCompletion * ) completion );
}

HB_FUNC( GTK_ENTRY_SET_COMPLETION ) 
{
   GtkWidget * entry = GTK_WIDGET( hb_parptr( 1 ) );
   GtkEntryCompletion * completion = GTK_ENTRY_COMPLETION( hb_parptr( 2 ) );
   gtk_entry_set_completion (GTK_ENTRY (entry), completion );
 }
 
HB_FUNC( GTK_ENTRY_COMPLETION_SET_MODEL ) 
{
   GtkEntryCompletion * completion = GTK_ENTRY_COMPLETION( hb_parptr( 1 ) );
   GtkListStore * store = GTK_LIST_STORE( hb_parptr( 2 ) );
   gtk_entry_completion_set_model (completion, GTK_TREE_MODEL( store ));
 }
 
HB_FUNC( GTK_ENTRY_COMPLETION_SET_TEXT_COLUMN ) 
{
   GtkEntryCompletion * completion = GTK_ENTRY_COMPLETION( hb_parptr( 1 ) );
   gint column = hb_parni( 2 );
   gtk_entry_completion_set_text_column (completion, column ); 
}
