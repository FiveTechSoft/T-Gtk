/* $Id: gtkgrid.c,v 1.1 2022-07-25 15:12:53 riztan Exp $*/
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
    (c)2022 Riztan Gutierrez <riztan@gmail.com>
*/
#include <hbapi.h>
#include <gtk/gtk.h>

HB_FUNC( GTK_GRID_NEW ) // rows,columns, homogeneous -->widget
{
 GtkWidget * grid = gtk_grid_new();
 hb_retptr( ( GtkWidget * ) grid );
}


HB_FUNC( GTK_GRID_ATTACH )
{
   GtkGrid * grid    = hb_parptr( 1 );
   GtkWidget * child = hb_parptr( 2 );
   gint left   = hb_parni( 3 );
   gint top    = hb_parni( 4 );
   gint width  = hb_parni( 5 );
   gint height = hb_parni( 6 );
   gtk_grid_attach( grid, child, left, top, width, height );
}


HB_FUNC( GTK_GRID_ATTACH_NEXT_TO )
{
   GtkGrid * grid = hb_parptr( 1 );
   GtkWidget * child = hb_parptr( 2 );
   GtkWidget * sibling = hb_parptr( 3 );
   GtkPositionType side = hb_parni( 4 );
   gint width = hb_parni( 5 );
   gint height = hb_parni( 6 );
   gtk_grid_attach_next_to( grid, child, sibling, side, width, height );
}


HB_FUNC( GTK_GRID_GET_CHILD_AT )
{
   GtkGrid * grid = hb_parptr( 1 );
   gint left = hb_parni( 2 );
   gint top  = hb_parni( 3 );
   GtkWidget * widget = gtk_grid_get_child_at( grid, left, top );
   hb_retptr( widget );
}


HB_FUNC( GTK_GRID_INSERT_ROW )
{
   GtkGrid * grid = hb_parptr( 1 );
   gint position = hb_parni( 2 );
   gtk_grid_insert_row( grid, position );
}


HB_FUNC( GTK_GRID_INSERT_COLUMN )
{
   GtkGrid * grid = hb_parptr( 1 );
   gint position = hb_parni( 2 );
   gtk_grid_insert_column( grid, position );
}


HB_FUNC( GTK_GRID_REMOVE_ROW )
{
   GtkGrid * grid = hb_parptr( 1 );
   gint position = hb_parni( 2 );
   gtk_grid_remove_row( grid, position );
}


HB_FUNC( GTK_GRID_REMOVE_COLUMN )
{
   GtkGrid * grid = hb_parptr( 1 );
   gint position = hb_parni( 2 );
   gtk_grid_remove_column( grid, position );
}


HB_FUNC( GTK_GRID_INSERT_NEXT_TO )
{
   GtkGrid * grid = hb_parptr( 1 );
   GtkWidget * sibling = hb_parptr( 2 );
   GtkPositionType side = hb_parni( 3 );
   gtk_grid_insert_next_to( grid, sibling, side );
}


HB_FUNC( GTK_GRID_SET_ROW_HOMOGENEOUS )
{
   GtkGrid * grid = hb_parptr( 1 );
   gboolean homogeneous = hb_parl( 2 );
   gtk_grid_set_row_homogeneous( grid, homogeneous );
}


HB_FUNC( GTK_GRID_GET_ROW_HOMOGENEOUS )
{
   GtkGrid * grid = hb_parptr( 1 );
   hb_retl( (gboolean) gtk_grid_get_row_homogeneous( grid ) );
}


HB_FUNC( GTK_GRID_SET_ROW_SPACING )
{
   GtkGrid * grid = hb_parptr( 1 );
   guint spacing  = hb_parnd( 2 );
   gtk_grid_set_row_spacing( grid, spacing );
}


HB_FUNC( GTK_GRID_GET_ROW_SPACING )
{
   GtkGrid * grid = hb_parptr( 1 );
   hb_retnd( (guint) gtk_grid_get_row_spacing( grid ) );
}


HB_FUNC( GTK_GRID_SET_COLUMN_HOMOGENEOUS )
{
   GtkGrid * grid = hb_parptr( 1 );
   gboolean homogeneous = hb_parl( 2 );
   gtk_grid_set_column_homogeneous( grid, homogeneous );
}


HB_FUNC( GTK_GRID_GET_COLUMN_HOMOGENEOUS )
{
   GtkGrid * grid = hb_parptr( 1 );
   hb_retl( (gboolean) gtk_grid_get_column_homogeneous( grid ) );
}


HB_FUNC( GTK_GRID_SET_COLUMN_SPACING )
{
   GtkGrid * grid = hb_parptr( 1 );
   guint spacing = hb_parnd( 2 );
   gtk_grid_set_column_spacing( grid, spacing );
}


HB_FUNC( GTK_GRID_GET_COLUMN_SPACING )
{
   GtkGrid * grid = hb_parptr( 1 );
   hb_retnd( (guint) gtk_grid_get_column_spacing( grid ) );
}


HB_FUNC( GTK_GRID_GET_BASELINE_ROW )
{
   GtkGrid * grid = hb_parptr( 1 );
   hb_retni( gtk_grid_get_baseline_row( grid ) );
}


HB_FUNC( GTK_GRID_SET_BASELINE_ROW )
{
   GtkGrid * grid = hb_parptr( 1 );
   gint row = hb_parni( 2 );
   gtk_grid_set_baseline_row( grid, row );
}


HB_FUNC( GTK_GRID_GET_ROW_BASELINE_POSITION )
{
   GtkGrid * grid = hb_parptr( 1 );
   gint row = hb_parni( 2 );
   hb_retni( gtk_grid_get_row_baseline_position( grid, row ) );
}


HB_FUNC( GTK_GRID_SET_ROW_BASELINE_POSITION )
{
   GtkGrid * grid = hb_parptr( 1 );
   gint row = hb_parni( 2 );
   GtkBaselinePosition pos = hb_parni( 3 );
   gtk_grid_set_row_baseline_position( grid, row, pos );
}

//oef
