/* $Id: gdauirawgrid.c,v 1 2012-08-22 03:28:35 riztan Exp $*/
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
    (c)2008 Rafael Carmona <rafa.tgtk at gmail.com>
    (c)2012 Riztan Gutierrez <riztan at t-gtk.org>
*/
#include <hbapi.h>

#ifdef _GDA_
#include <gtk/gtk.h>
#include <libgda/libgda.h>
#include <libgda-ui/libgda-ui.h>


HB_FUNC( GDAUI_RAW_GRID_NEW ) 
{
   GtkWidget * form;
   GdaDataModel * model = hb_parptr( 1 );

   form = gdaui_raw_grid_new( model );
   hb_retptr( form );
}


HB_FUNC( GDAUI_RAW_GRID_SET_SAMPLE_SIZE ) 
{
   GdauiRawGrid * grid = hb_parptr( 1 );
   gint sample_size = hb_parni( 2 );

   gdaui_raw_grid_set_sample_size( grid, sample_size );
}


HB_FUNC( GDAUI_RAW_GRID_SET_SAMPLE_START ) 
{
   GdauiRawGrid * grid = hb_parptr( 1 );
   gint sample_start = hb_parni( 2 );

   gdaui_raw_grid_set_sample_start( grid, sample_start );
}


HB_FUNC( GDAUI_RAW_GRID_SET_LAYOUT_FROM_FILE ) 
{
   GdauiRawGrid * grid = hb_parptr( 1 );
   const gchar *file_name = hb_parc( 2 );
   const gchar *grid_name = hb_parc( 3 );

   gdaui_raw_grid_set_layout_from_file( grid, file_name, grid_name );
}

#endif

//eof
