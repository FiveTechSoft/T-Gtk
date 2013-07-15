/*
 *  API Printer GTK for [x]Harbour.
 *  GtkPrintContext — Encapsulates context for drawing pages
 * 
 *  This program is free software; you can redistribute it and/or
 *  modify it under the terms of the GNU Library General Public License
 *  as published by the Free Software Foundation; either version 2 of
 *  the License, or (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU Library General Public License for more details.
 *
 *  You should have received a copy of the GNU Library General Public
 *  License along with this program; if not, write to the Free Software
 *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 *
 *  Authors:
 *    Rafa Carmona( thefull@wanadoo.es )
 *
 *  Copyright 2007 Rafa Carmona
 */

#include <hbapi.h>
#include <gtk/gtk.h>

#ifdef _GTK2_

#if GTK_CHECK_VERSION(2,10,0)
HB_FUNC( GTK_PRINT_CONTEXT_GET_CAIRO_CONTEXT )
{
 cairo_t *cr;   
 GtkPrintContext *context = GTK_PRINT_CONTEXT( hb_parnl( 1 ) );

  cr = gtk_print_context_get_cairo_context( context );
  hb_retnl( (glong) cr );
}

HB_FUNC( GTK_PRINT_CONTEXT_GET_WIDTH )
{
 GtkPrintContext *context = GTK_PRINT_CONTEXT( hb_parnl( 1 ) );
 hb_retnd( ( gdouble )gtk_print_context_get_width( context ) );
}

HB_FUNC( GTK_PRINT_CONTEXT_CREATE_PANGO_LAYOUT )
{
 GtkPrintContext *context = GTK_PRINT_CONTEXT( hb_parnl( 1 ) );
 PangoLayout * layout = gtk_print_context_create_pango_layout( context );
 hb_retnl( (glong) layout );
}

HB_FUNC( GTK_PRINT_CONTEXT_GET_PAGE_SETUP )
{
 GtkPrintContext *context = GTK_PRINT_CONTEXT( hb_parnl( 1 ) );
 GtkPageSetup * setup;
 setup = gtk_print_context_get_page_setup( context );
 hb_retnl( (glong) setup );
}
#endif

#endif
