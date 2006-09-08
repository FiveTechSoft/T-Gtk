/* $Id: gtkcellrenderer.c,v 1.1 2006-09-08 12:18:45 xthefull Exp $*/
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

HB_FUNC( GTK_CELL_RENDERER_TEXT_NEW ) // -> renderer
{
   GtkCellRenderer *renderer = gtk_cell_renderer_text_new();
   hb_retnl( (ULONG) renderer );
}

HB_FUNC( GTK_CELL_RENDERER_TOGGLE_NEW ) // -> renderer
{
   GtkCellRenderer *renderer = gtk_cell_renderer_toggle_new();
   hb_retnl( (ULONG) renderer );
}

HB_FUNC( GTK_CELL_RENDERER_PIXBUF_NEW ) // -> renderer
{
   GtkCellRenderer *renderer = gtk_cell_renderer_pixbuf_new();
   hb_retnl( (ULONG) renderer );
}

HB_FUNC( GTK_CELL_LAYOUT_PACK_START )
{
   GtkCellLayout * cell_layout =  GTK_CELL_LAYOUT( ( GtkCellLayout * )hb_parnl( 1 ) );
   GtkCellRenderer *cell = GTK_CELL_RENDERER( ( GtkCellRenderer * ) hb_parnl( 2 ) );
   gboolean expand = hb_parl( 3 );

   gtk_cell_layout_pack_start( cell_layout , cell, expand );

}

HB_FUNC( GTK_CELL_LAYOUT_ADD_ATTRIBUTE )
{
   GtkCellLayout *cell_layout =  GTK_CELL_LAYOUT( ( GtkCellLayout * )hb_parnl( 1 ) );
   GtkCellRenderer *cell = GTK_CELL_RENDERER( ( GtkCellRenderer * ) hb_parnl( 2 ) );
   const gchar *attribute = hb_parc( 3 );
   gint column = hb_parni( 4 );  
   
   gtk_cell_layout_add_attribute( cell_layout, cell, attribute, column );
}


#if GTK_CHECK_VERSION(2,6,0) 

HB_FUNC( GTK_CELL_RENDERER_PROGRESS_NEW ) // -> renderer
{
   GtkCellRenderer *renderer = gtk_cell_renderer_progress_new();
   hb_retnl( (ULONG) renderer );
}

HB_FUNC( GTK_CELL_RENDERER_COMBO_NEW ) // -> renderer
{
   GtkCellRenderer *renderer = gtk_cell_renderer_combo_new();
   hb_retnl( (ULONG) renderer );
}

#endif
