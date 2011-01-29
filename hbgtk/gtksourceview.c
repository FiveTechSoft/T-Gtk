/* $Id: gtksourceview.c,v 1.1 2008-09-02 21:17:21 riztan Exp $*/
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
    
    GtkSourceView for Harbour
    (c) 2008 Rafa Carmona <rafa.tgtk at gmail.com>
*/

#ifdef _HAVEGTKSOURCEVIEW_
#include <gtksourceview/gtksourceview.h>

#include "hbapi.h"
#include "hbapiitm.h"

GtkWidget * create_text_widget(const char * content_type);

HB_FUNC( GTK_SOURCE_VIEW_NEW ) // -> widget
{
   GtkWidget * view = gtk_source_view_new( );
   hb_retptr( GTK_WIDGET( view ) );
}

HB_FUNC( GTK_SOURCE_VIEW_SET_SHOW_LINE_NUMBERS ) // -> widget
{
  GtkWidget * view =  GTK_WIDGET( hb_parptr( 1 ) );
  gtk_source_view_set_show_line_numbers( GTK_SOURCE_VIEW( view ), hb_parl( 2 ));
}

HB_FUNC( HB_GTK_SOURCE_CREATE_NEW ) // -> widget
{
   GtkWidget * view; 
   const char * content_type = hb_parc( 1 );
   view = create_text_widget( content_type );
   hb_retptr( GTK_WIDGET( view ) );
}

#include <gtksourceview/gtksourcebuffer.h>
#include <gtksourceview/gtksourcelanguage.h>
#include <gtksourceview/gtksourcelanguagemanager.h>

GtkWidget * create_text_widget(const char * content_type)
  {
      static GtkSourceLanguageManager * lm = NULL;
      static const gchar * const * lm_ids = NULL;
      GtkWidget * widget = NULL;
      gint n;
  
      /* we use or own highlighting for text/plain */
      if (!g_ascii_strcasecmp(content_type, "text/plain")){
         return gtk_source_view_new();//gtk_text_view_new();
       }
      /* try to initialise the source language manager and return a "simple"
       * text view if this fails */
      if (!lm)
  	lm = gtk_source_language_manager_get_default();
      if (lm && !lm_ids)
  	lm_ids = gtk_source_language_manager_get_language_ids(lm);
      if (!lm_ids){
  	return gtk_source_view_new();//gtk_text_view_new();
      }  
      /* search for a language supporting our mime type */
      for (n = 0; !widget && lm_ids[n]; n++) {
  	GtkSourceLanguage * src_lang =
  	    gtk_source_language_manager_get_language(lm, lm_ids[n]);
  	gchar ** mime_types;
  
  	if (src_lang &&
  	    (mime_types = gtk_source_language_get_mime_types(src_lang))) {
  	    gint k;
  
  	    for (k = 0;
  		 mime_types[k] && g_ascii_strcasecmp(mime_types[k], content_type);
  		 k++);
  	    if (mime_types[k]) {
  		GtkSourceBuffer * buffer =
  		    gtk_source_buffer_new_with_language(src_lang);
  
  		gtk_source_buffer_set_highlight_syntax(buffer, TRUE);
  		widget = gtk_source_view_new_with_buffer(buffer);
  		g_object_unref(buffer);
  	    }
  	    g_strfreev(mime_types);
  	}
      }
      /* fall back to the simple text view if the mime type is not supported */
return widget ? widget : gtk_source_view_new(); //gtk_text_view_new();
}
#endif
