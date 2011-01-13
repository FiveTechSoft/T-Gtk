/* $Id: gtktextview.c,v 1.1 2006-09-08 12:18:45 xthefull Exp $*/
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

PHB_ITEM IterText2Array( GtkTextIter *iter  );
BOOL Array2IterText(PHB_ITEM aIter, GtkTextIter *iter  );

HB_FUNC( GTK_TEXT_VIEW_NEW ) //  void -> nWidget
{
  GtkWidget * text = gtk_text_view_new();
  hb_retptr( ( GtkWidget * ) text );
}

HB_FUNC( GTK_TEXT_VIEW_NEW_WITH_BUFFER ) //  void -> nWidget
{
  GtkWidget * text;
  GtkTextBuffer * buffer = GTK_TEXT_BUFFER( hb_parptr( 1 ) );
  text = gtk_text_view_new_with_buffer( buffer );
  hb_retptr( ( GtkWidget * ) text );
}

HB_FUNC( GTK_TEXT_VIEW_GET_BUFFER ) //  nWidget -> nBuffer
{
  GtkWidget * view = GTK_WIDGET( hb_parptr( 1 ) );
  GtkTextBuffer * buffer = gtk_text_view_get_buffer( GTK_TEXT_VIEW(view) );
  hb_retptr( ( GtkWidget * ) buffer );
}

HB_FUNC( GTK_TEXT_VIEW_SET_BUFFER ) //  pWidget , pBuffer
{
  GtkTextView * view = GTK_TEXT_VIEW( hb_parptr( 1 ) );
  GtkTextBuffer * buffer = GTK_TEXT_BUFFER( hb_parptr( 2 ) );
  gtk_text_view_set_buffer( view, buffer );
}

HB_FUNC( GTK_TEXT_VIEW_SET_LEFT_MARGIN ) //  nWidget, nMargin -> void
{
  GtkWidget * view = GTK_WIDGET( hb_parptr( 1 ) );
  gint margin = (gint) hb_parni( 2 );
  gtk_text_view_set_left_margin( GTK_TEXT_VIEW(view), margin );
}

HB_FUNC( GTK_TEXT_VIEW_SET_RIGHT_MARGIN ) //  nWidget, nMargin -> void
{
  GtkWidget * view = GTK_WIDGET( hb_parptr( 1 ) );
  gint margin = (gint) hb_parni( 2 );
  gtk_text_view_set_right_margin( GTK_TEXT_VIEW(view), margin );
}

HB_FUNC( GTK_TEXT_VIEW_ADD_CHILD_IN_WINDOW )
{
  GtkTextView * view  = GTK_TEXT_VIEW( hb_parptr( 1 ) );
  GtkWidget   * child = GTK_WIDGET( hb_parptr( 2 ) );
  GtkTextWindowType window = hb_parni( 3 );
  gint xpos = hb_parni( 4 );
  gint ypos = hb_parni( 5 );
  gtk_text_view_add_child_in_window( view, child, window, xpos, ypos );
}

HB_FUNC( GTK_TEXT_VIEW_SET_EDITABLE ) //nWidget, bVisible -> void
{
  GtkTextView * view = GTK_TEXT_VIEW( hb_parptr( 1 ) );
  gboolean bedited = hb_parl( 2 );
  gtk_text_view_set_editable( view, bedited ) ;
}

HB_FUNC( GTK_TEXT_VIEW_PLACE_CURSOR_ONSCREEN ) //nWidget-->bMove
{
  GtkTextView * view = GTK_TEXT_VIEW( hb_parptr( 1 ) );
  hb_retl( gtk_text_view_place_cursor_onscreen( view ) ) ;
}
 
HB_FUNC( GTK_TEXT_VIEW_SCROLL_TO_ITER ) //nWidget-->bMove
{
  GtkTextView * view = GTK_TEXT_VIEW( hb_parptr( 1 ) );
  GtkTextIter iter;
  PHB_ITEM pIter = hb_param( 2, HB_IT_ARRAY );
  
  if ( Array2IterText( pIter, &iter ) )
    {   
     gtk_text_view_scroll_to_iter( view, &iter , 0.0, TRUE, 1.0, 1.0 );
/*                                             GtkTextIter *iter,
                                             gdouble within_margin,
                                             gboolean use_align,
                                             gdouble xalign,
                                             gdouble yalign);
 */
    }
} 


HB_FUNC( GTK_TEXT_VIEW_SET_JUSTIFICATION )
{
  GtkWidget * text = GTK_WIDGET( hb_parptr( 1 ) );
  gint iJust = hb_parni( 2 );
  gtk_text_view_set_justification( GTK_TEXT_VIEW( text ), iJust );
}

