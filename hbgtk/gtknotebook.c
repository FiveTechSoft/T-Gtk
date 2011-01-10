/* $Id: gtknotebook.c,v 1.1 2006-09-08 12:18:45 xthefull Exp $*/
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

HB_FUNC( GTK_NOTEBOOK_NEW )
{
   GtkWidget * notebook = gtk_notebook_new ();
   hb_retptr( ( GtkWidget * ) notebook );
}

HB_FUNC( GTK_NOTEBOOK_APPEND_PAGE )
{
   GtkWidget * notebook = GTK_WIDGET( hb_parptr( 1 ) );
   GtkWidget * child = GTK_WIDGET( hb_parptr( 2 ) );
   GtkWidget * label = GTK_WIDGET( hb_parptr( 3 ) );

   gtk_notebook_append_page( GTK_NOTEBOOK( notebook ),
                               child,
                               label );
}

HB_FUNC( GTK_NOTEBOOK_PREPEND_PAGE )
{
   GtkWidget * notebook = GTK_WIDGET( hb_parptr( 1 ) );
   GtkWidget * child = GTK_WIDGET( hb_parptr( 2 ) );
   GtkWidget * label = GTK_WIDGET( hb_parptr( 3 ) );

   gtk_notebook_prepend_page( GTK_NOTEBOOK( notebook ),
                               child,
                               label );
}


HB_FUNC( GTK_NOTEBOOK_SET_TAB_POS ) // widget, nPos
{
   GtkWidget * notebook = GTK_WIDGET( hb_parptr( 1 ) );
   gint iPos = hb_parni( 2 );

   gtk_notebook_set_tab_pos( GTK_NOTEBOOK( notebook ), iPos );
}

// Esta fun es propia, no existe en GTK
HB_FUNC( GTK_NOTEBOOK_GET_TAB_POS ) // widget-->tab
{
   GtkNotebook *notebook  = GTK_NOTEBOOK(  hb_parptr( 1 )  );
   hb_retni( notebook->tab_pos + 1 );
}

HB_FUNC( GTK_NOTEBOOK_SET_SHOW_TABS ) // widget, lShow
{
   GtkWidget * notebook = GTK_WIDGET( hb_parptr( 1 ) );
   gint iShow = (gint) hb_parl( 2 );
   gtk_notebook_set_show_tabs( GTK_NOTEBOOK( notebook ), iShow );
}

HB_FUNC( GTK_NOTEBOOK_SET_SHOW_BORDER ) // widget, lShow
{
   GtkWidget * notebook = GTK_WIDGET( hb_parptr( 1 ) );
   gint iShow = (gint) hb_parl( 2 );
   gtk_notebook_set_show_border( GTK_NOTEBOOK( notebook ), iShow );
}

HB_FUNC( GTK_NOTEBOOK_GET_CURRENT_PAGE ) // widget --> current page
{
   GtkWidget * notebook = GTK_WIDGET( hb_parptr( 1 ) );
   hb_retni( ( gint ) gtk_notebook_get_current_page( GTK_NOTEBOOK( notebook ) ) );
}

HB_FUNC( GTK_NOTEBOOK_SET_CURRENT_PAGE ) // widget, Page -->
{
   GtkWidget * notebook = GTK_WIDGET( hb_parptr( 1 ) );
   gint page_num = hb_parni( 2 ) ;
   gtk_notebook_set_current_page( GTK_NOTEBOOK( notebook ) , page_num );
}

HB_FUNC( GTK_NOTEBOOK_NEXT_PAGE ) // widget
{
   gtk_notebook_next_page( GTK_NOTEBOOK( GTK_WIDGET( hb_parptr( 1 ) ) ) );
}

HB_FUNC( GTK_NOTEBOOK_PREV_PAGE ) // widget
{
   gtk_notebook_prev_page( GTK_NOTEBOOK( GTK_WIDGET( hb_parptr( 1 ) ) ) );
}

HB_FUNC( GTK_NOTEBOOK_SET_SCROLLABLE ) // hWnd, lScroll
{
   GtkWidget * notebook = GTK_WIDGET( hb_parptr( 1 ) );
   gint iScroll = (gint) hb_parl( 2 );

   gtk_notebook_set_scrollable( GTK_NOTEBOOK( notebook ), iScroll );
}

HB_FUNC( GTK_NOTEBOOK_POPUP_ENABLE ) // widget
{
   GtkWidget * notebook = GTK_WIDGET( hb_parptr( 1 ) );
   gtk_notebook_popup_enable( GTK_NOTEBOOK( notebook ) );
}

HB_FUNC( GTK_NOTEBOOK_POPUP_DISABLE ) // widget
{
      GtkWidget * notebook = GTK_WIDGET( hb_parptr( 1 ) );
      gtk_notebook_popup_disable( GTK_NOTEBOOK( notebook ) );
}

HB_FUNC( GTK_NOTEBOOK_REMOVE_PAGE )
{
   GtkWidget * notebook = GTK_WIDGET( hb_parptr( 1 ) );
   gint page_num =  hb_parni( 2 ) ;

   gtk_notebook_remove_page(  GTK_NOTEBOOK( notebook ),  page_num );
}
