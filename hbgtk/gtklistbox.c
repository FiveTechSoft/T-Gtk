/* $Id: gtklistbox.c,v 1.1 2022-06-18 14:11:07 riztan Exp $*/
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
*/
#include <gtk/gtk.h>
#include "hbapi.h"
#include "hbvm.h"

//static void
//CreateWidgetFunc( GObject *item, gpointer data ) ;


static void
CreateWidgetFunc( GObject *item, gpointer data )
{
   hb_vmPushSymbol( data );
   hb_vmPushNil();
   hb_vmPushPointer( (GObject *) item );
   hb_vmDo( 1 );

   return;
}

    
HB_FUNC( GTK_LIST_BOX_NEW ) //->widget
{
   GtkWidget * hWnd = gtk_list_box_new();
   hb_retptr( ( GtkWidget *  ) hWnd );
}


//----------------------

HB_FUNC( GTK_LIST_BOX_BIND_MODEL ) 
{
   PHB_DYNS pDynSym = hb_dynsymFindName( hb_parc( 3 ) );

   if( pDynSym )
   {
      GtkListBox   *box   = hb_parptr( 1 );
      GListModel   *model = hb_parptr( 2 );
      //GtkListBoxCreateWidgetFunc create_widget_func,
      //gpointer user_data,
      //GDestroyNotify user_data_free_func
      gtk_list_box_bind_model( box, 
                               model, 
                               CreateWidgetFunc, 
                               (gpointer) pDynSym->pSymbol,
                               NULL);
   }
}


/*
void
gtk_list_box_drag_highlight_row (
  GtkListBox* box,
  GtkListBoxRow* row
)*/
HB_FUNC( GTK_LIST_BOX_DRAG_HIGHLIGHT_ROW )
{
   GtkListBox    *box = GTK_LIST_BOX( ( GtkListBox *) hb_parptr( 1 ) );
   GtkListBoxRow *row = GTK_LIST_BOX_ROW( ( GtkListBoxRow *) hb_parptr( 2 ) );

   gtk_list_box_drag_highlight_row( box, row );
}

/*
void
gtk_list_box_drag_unhighlight_row (
  GtkListBox* box
)*/
HB_FUNC( GTK_LIST_BOX_DRAG_UNHIGHLIGHT_ROW )
{
   GtkListBox *box = GTK_LIST_BOX( ( GtkListBox *) hb_parptr( 1 ) );
   gtk_list_box_drag_unhighlight_row( box );
}

/*
gboolean
gtk_list_box_get_activate_on_single_click (
  GtkListBox* box
)*/
HB_FUNC( GTK_LIST_BOX_GET_ACTIVATE_ON_SINGLE_CLICK )
{
   GtkListBox *box = GTK_LIST_BOX( ( GtkListBox *) hb_parptr( 1 ) );
   hb_retl( gtk_list_box_get_activate_on_single_click( box ) );
}


/*
GtkAdjustment*
gtk_list_box_get_adjustment (
  GtkListBox* box
)*/
HB_FUNC( GTK_LIST_BOX_GET_ADJUSTMENT  )
{
   GtkListBox *box = GTK_LIST_BOX( ( GtkListBox *) hb_parptr( 1 ) );
   hb_retptr( ( GtkAdjustment * ) gtk_list_box_get_adjustment( box ) );
}


/*
GtkListBoxRow*
gtk_list_box_get_row_at_index (
  GtkListBox* box,
  gint index_
)*/
HB_FUNC( GTK_LIST_BOX_GET_ROW_AT_INDEX )
{
   GtkListBox *box = GTK_LIST_BOX( ( GtkListBox *) hb_parptr( 1 ) );
   gint index_ = hb_parni( 2 );
   hb_retptr( ( GtkListBoxRow *) gtk_list_box_get_row_at_index( box, index_ ) );
}


/*
GtkListBoxRow*
gtk_list_box_get_row_at_y (
  GtkListBox* box,
  gint y
)*/
HB_FUNC( GTK_LIST_BOX_GET_ROW_AT_Y )
{
   GtkListBox *box = GTK_LIST_BOX( ( GtkListBox *) hb_parptr( 1 ) );
   gint y = hb_parni( 2 );
   hb_retptr( (GtkListBoxRow *) gtk_list_box_get_row_at_y( box, y ) );
}


/*
GtkListBoxRow*
gtk_list_box_get_selected_row (
  GtkListBox* box
)*/
HB_FUNC( GTK_LIST_BOX_GET_SELECTED_ROW )
{
   GtkListBox *box = GTK_LIST_BOX( ( GtkListBox *) hb_parptr( 1 ) );
   hb_retptr( ( GtkListBoxRow *) gtk_list_box_get_selected_row( box ) );
}


/*
GList*
gtk_list_box_get_selected_rows (
  GtkListBox* box
)*/
HB_FUNC( GTK_LIST_BOX_GET_SELECTED_ROWS )
{
   GtkListBox * box = GTK_LIST_BOX( ( GtkListBox *) hb_parptr( 1 ) );
   hb_retptr( (GList *) gtk_list_box_get_selected_rows( box ) );
}


/*
GtkSelectionMode
gtk_list_box_get_selection_mode (
  GtkListBox* box
)*/
HB_FUNC( GTK_LIST_BOX_GET_SELECTION_MODE )
{
   GtkListBox *box = GTK_LIST_BOX( ( GtkListBox *) hb_parptr( 1 ) );
   hb_retni( gtk_list_box_get_selection_mode( box ) );
}

/*
void
gtk_list_box_insert (
  GtkListBox* box,
  GtkWidget* child,
  gint position
)*/
HB_FUNC( GTK_LIST_BOX_INSERT )
{
   GtkListBox *box   = GTK_LIST_BOX( ( GtkListBox *) hb_parptr( 1 ) );
   GtkWidget  *child = GTK_WIDGET( ( GtkWidget *) hb_parptr( 2 ) );
   gint       position = hb_parni( 3 );
   gtk_list_box_insert( box, child, position  );
}


/*
void
gtk_list_box_invalidate_filter (
  GtkListBox* box
)
*/
HB_FUNC( GTK_LIST_BOX_INVALIDATE_FILTER  )
{
   GtkListBox *box = GTK_LIST_BOX( ( GtkListBox *) hb_parptr( 1 ) );
   gtk_list_box_invalidate_filter( box );
}


/*
void
gtk_list_box_invalidate_headers (
  GtkListBox* box
)*/
HB_FUNC( GTK_LIST_BOX_INVALIDATE_HEADERS )
{
   GtkListBox *box = GTK_LIST_BOX( ( GtkListBox *) hb_parptr( 1 ) );
   gtk_list_box_invalidate_headers( box );
}


/*
void
gtk_list_box_invalidate_sort (
  GtkListBox* box
)*/
HB_FUNC( GTK_LIST_BOX_INVALIDATE_SORT )
{
   GtkListBox *box = GTK_LIST_BOX( ( GtkListBox *) hb_parptr( 1 ) );
   gtk_list_box_invalidate_sort( box );
}


/*
void
gtk_list_box_prepend (
  GtkListBox* box,
  GtkWidget* child
)*/
HB_FUNC( GTK_LIST_BOX_PREPEND )
{
   GtkListBox *box = GTK_LIST_BOX( ( GtkListBox *) hb_parptr( 1 ) );
   GtkWidget *child = GTK_WIDGET( ( GtkWidget * ) hb_parptr( 2 ) );
   gtk_list_box_prepend( box, child );
}


/*
void
gtk_list_box_select_all (
  GtkListBox* box
)*/
HB_FUNC( GTK_LIST_BOX_SELECT_ALL )
{
   GtkListBox *box = GTK_LIST_BOX( ( GtkListBox *) hb_parptr( 1 ) );
   gtk_list_box_select_all( box );
}


/*
void
gtk_list_box_select_row (
  GtkListBox* box,
  GtkListBoxRow* row
)*/
HB_FUNC( GTK_LIST_BOX_SELECT_ROW )
{
   GtkListBox    *box = GTK_LIST_BOX( ( GtkListBox *) hb_parptr( 1 ) );
   GtkListBoxRow *row = GTK_LIST_BOX_ROW( ( GtkListBoxRow *) hb_parptr( 2 ) );
   gtk_list_box_select_row( box, row );
}


/*
void
gtk_list_box_selected_foreach (
  GtkListBox* box,
  GtkListBoxForeachFunc func,
  gpointer data
)*/
HB_FUNC( GTK_LIST_BOX_SELECTED_FOREACH )  //TODO
{
   GtkListBox *box = GTK_LIST_BOX( ( GtkListBox *) hb_parptr( 1 ) );
   GtkListBoxForeachFunc func = hb_parptr( 2 );
   gpointer data = hb_parptr( 3 );
   gtk_list_box_selected_foreach( box, func, data );
}


/*
void
gtk_list_box_set_activate_on_single_click (
  GtkListBox* box,
  gboolean single
)*/
HB_FUNC( GTK_LIST_BOX_SET_ACTIVATE_ON_SINGLE_CLICK )
{
   GtkListBox *box = GTK_LIST_BOX( ( GtkListBox *) hb_parptr( 1 ) );
   gboolean single = hb_parl( 2 );
   gtk_list_box_set_activate_on_single_click( box, single );
}


/*
void
gtk_list_box_set_adjustment (
  GtkListBox* box,
  GtkAdjustment* adjustment
)*/
HB_FUNC( GTK_LIST_BOX_SET_ADJUSTMENT )
{
   GtkListBox *box = GTK_LIST_BOX( ( GtkListBox *) hb_parptr( 1 ) );
   GtkAdjustment *adjustment = hb_parptr( 2 );
   gtk_list_box_set_adjustment( box, adjustment );
}


/*
void
gtk_list_box_set_filter_func (
  GtkListBox* box,
  GtkListBoxFilterFunc filter_func,
  gpointer user_data,
  GDestroyNotify destroy
)*/
HB_FUNC( GTK_LIST_BOX_SET_FILTER_FUNC )  //TODO
{
  GtkListBox *box = GTK_LIST_BOX( ( GtkListBox *) hb_parptr( 1 ) );
  GtkListBoxFilterFunc filter_func = hb_parptr( 2 );
  gpointer user_data = hb_parptr( 3 );
  GDestroyNotify destroy = hb_parptr( 4 );
  gtk_list_box_set_filter_func( box, filter_func, user_data, destroy );
}


/*
void
gtk_list_box_set_header_func (
  GtkListBox* box,
  GtkListBoxUpdateHeaderFunc update_header,
  gpointer user_data,
  GDestroyNotify destroy
)*/
HB_FUNC( GTK_LIST_BOX_SET_HEADER_FUNC )
{
   GtkListBox *box = GTK_LIST_BOX( ( GtkListBox *) hb_parptr( 1 ) );
   GtkListBoxUpdateHeaderFunc update_header = hb_parptr( 2 );
   gpointer user_data = hb_parptr( 3 );
   GDestroyNotify destroy = hb_parptr( 4 );
   gtk_list_box_set_header_func( box, update_header, user_data, destroy );
}


/*
void
gtk_list_box_set_placeholder (
  GtkListBox* box,
  GtkWidget* placeholder
)*/
HB_FUNC( GTK_LIST_BOX_SET_PLACEHOLDER )
{
   GtkListBox *box = GTK_LIST_BOX( ( GtkListBox *) hb_parptr( 1 ) );
   GtkWidget *placeholder = hb_parptr( 2 );
   gtk_list_box_set_placeholder( box, placeholder );
}


/*
void
gtk_list_box_set_selection_mode (
  GtkListBox* box,
  GtkSelectionMode mode
)*/
HB_FUNC( GTK_LIST_BOX_SET_SELECTION_MODE )
{
   GtkListBox *box = GTK_LIST_BOX( ( GtkListBox *) hb_parptr( 1 ) );
   GtkSelectionMode mode = hb_parni( 2 );
   gtk_list_box_set_selection_mode( box, mode );
}


/*
void
gtk_list_box_set_sort_func (
  GtkListBox* box,
  GtkListBoxSortFunc sort_func,
  gpointer user_data,
  GDestroyNotify destroy
)*/
HB_FUNC( GTK_LIST_BOX_SET_SORT_FUNC ) //TODO
{
   GtkListBox *box = GTK_LIST_BOX( ( GtkListBox *) hb_parptr( 1 ) );
   GtkListBoxSortFunc sort_func = hb_parptr( 2 );
   gpointer user_data = hb_parptr( 3 );
   GDestroyNotify destroy = hb_parptr( 4 );
   gtk_list_box_set_sort_func( box, sort_func, user_data, destroy );
}


/*
void
gtk_list_box_unselect_all (
  GtkListBox* box
)*/
HB_FUNC( GTK_LIST_BOX_UNSELECT_ALL )
{
   GtkListBox *box = GTK_LIST_BOX( ( GtkListBox *) hb_parptr( 1 ) );
   gtk_list_box_unselect_all( box );
}


/*
void
gtk_list_box_unselect_row (
  GtkListBox* box,
  GtkListBoxRow* row
)*/
HB_FUNC( GTK_LIST_BOX_UNSELECT_ROW )
{
   GtkListBox    *box = GTK_LIST_BOX( ( GtkListBox *) hb_parptr( 1 ) );
   GtkListBoxRow *row = GTK_LIST_BOX_ROW( ( GtkListBoxRow *) hb_parptr( 2 ) );
   gtk_list_box_unselect_row( box, row );
}

//eof
