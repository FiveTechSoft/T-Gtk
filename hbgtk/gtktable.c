/* $Id: gtktable.c,v 1.1 2006-09-08 12:18:45 xthefull Exp $*/
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

#if GTK_MAJOR_VERSION < 3
    
HB_FUNC( GTK_TABLE_NEW ) // rows,columns, homogeneous -->widget
{
 GtkWidget * Table = gtk_table_new( hb_parni( 1 ),  hb_parni( 2 ),  hb_parl( 3 ) );
 hb_retptr( ( GtkWidget * ) Table );
}

HB_FUNC( GTK_TABLE_RESIZE ) // table, rows, columns
{
  GtkWidget * Table = GTK_WIDGET( hb_parptr( 1 ) );
  gtk_table_resize( GTK_TABLE( Table ),
                    hb_parni(3),
                    hb_parni(4) );
}


HB_FUNC( GTK_TABLE_ATTACH ) // table, child, iLeft, iRight,top, bottom, xoptions, yOptions, xpadding, ypadding
{
  GtkWidget * Table = GTK_WIDGET( hb_parptr( 1 ) );
  GtkWidget * Child = GTK_WIDGET( hb_parptr( 2 ) );

  gtk_table_attach( GTK_TABLE( Table ), Child ,
                    hb_parni(3),
                    hb_parni(4),
                    hb_parni(5),
                    hb_parni(6),
                    hb_parni(7),
                    hb_parni(8),
                    hb_parni(9),
                    hb_parni(10) );
}

HB_FUNC( GTK_TABLE_ATTACH_DEFAULTS ) // table, child, left,right,top,bottom
{
  GtkWidget * Table = ( GtkWidget * ) hb_parptr( 1 );
  GtkWidget * Child = ( GtkWidget * ) hb_parptr( 2 );

  gtk_table_attach_defaults( GTK_TABLE( Table ),
                             Child,
                             hb_parni(3),
                             hb_parni(4),
                             hb_parni(5),
                             hb_parni(6) );

}

HB_FUNC( GTK_TABLE_SET_ROW_SPACING ) // table, row, spacing
{

   GtkWidget * Table = ( GtkWidget * ) hb_parptr( 1 );
   gtk_table_set_row_spacing( GTK_TABLE( Table ),
                              hb_parni(2),
                              hb_parni(3) );
}

HB_FUNC( GTK_TABLE_SET_COL_SPACING ) // table, column, spacing
{

   GtkWidget * Table = ( GtkWidget * ) hb_parptr( 1 );
   gtk_table_set_col_spacing( GTK_TABLE( Table ),
                              hb_parni(2),
                              hb_parni(3) );
}

HB_FUNC( GTK_TABLE_SET_ROW_SPACINGS ) // table, spacing
{
   GtkWidget * Table = ( GtkWidget * ) hb_parptr( 1 );
   gtk_table_set_row_spacings( GTK_TABLE( Table ),
                               hb_parni( 2 ) );
}

HB_FUNC( GTK_TABLE_SET_COL_SPACINGS ) // table, spacing
{

   GtkWidget * Table = ( GtkWidget * ) hb_parptr( 1 );
   gtk_table_set_col_spacings( GTK_TABLE( Table ),
                               hb_parni( 2 ) );
}

HB_FUNC( GTK_TABLE_SET_HOMOGENEOUS ) // table, homogeneous
{
   GtkWidget * Table = ( GtkWidget * ) hb_parptr( 1 );
   gtk_table_set_homogeneous( GTK_TABLE( Table ),
                               hb_parl( 2 ) );
}

HB_FUNC( GTK_TABLE_GET_DEFAULT_ROW_SPACING ) // table -> row default
{
   GtkWidget * Table = ( GtkWidget * ) hb_parptr( 1 );
   hb_retni( gtk_table_get_default_row_spacing( GTK_TABLE( Table ) ) );
}

HB_FUNC( GTK_TABLE_GET_HOMOGENEOUS ) // table -> bHomogeneous
{
   GtkWidget * Table = ( GtkWidget * ) hb_parptr( 1 );
   hb_retl( gtk_table_get_homogeneous( GTK_TABLE( Table ) ) );
}

HB_FUNC( GTK_TABLE_GET_ROW_SPACING ) // table , nRow -> spacing
{
   GtkWidget * Table = ( GtkWidget * ) hb_parptr( 1 );
   hb_retni( gtk_table_get_row_spacing( GTK_TABLE( Table ), hb_parni( 2 ) ) );
}

HB_FUNC( GTK_TABLE_GET_COL_SPACING ) // table, nCol ->  spacing
{
   GtkWidget * Table = ( GtkWidget * ) hb_parptr( 1 );
   hb_retni( gtk_table_get_col_spacing( GTK_TABLE( Table ), hb_parni( 2 ) ) );
}

HB_FUNC( GTK_TABLE_GET_DEFAULT_COL_SPACING ) // table -> col default
{
   GtkWidget * Table = ( GtkWidget * ) hb_parptr( 1 );
   hb_retni( gtk_table_get_default_col_spacing( GTK_TABLE( Table ) ) );
}

#endif
