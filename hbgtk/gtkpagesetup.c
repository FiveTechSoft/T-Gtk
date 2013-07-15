/*
 *  API Printer GTK for [x]Harbour.
 *  GtkPageSetup — Stores page setup information
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
HB_FUNC( GTK_PAGE_SETUP_NEW )
{
 hb_retnl( (glong) gtk_page_setup_new() );
}

HB_FUNC( GTK_PAGE_SETUP_SET_ORIENTATION )
{
 GtkPageSetup * setup = GTK_PAGE_SETUP( hb_parptr( 1 ) );
 GtkPageOrientation orientation = hb_parni( 2 );
 gtk_page_setup_set_orientation( setup, orientation );
}

HB_FUNC( GTK_PAGE_SETUP_SET_PAPER_SIZE )
{
 GtkPageSetup * setup = GTK_PAGE_SETUP( hb_parptr( 1 ) );
 GtkPaperSize * size = ( GtkPaperSize * ) hb_parptr( 2 );
 gtk_page_setup_set_paper_size( setup, size);
}
#endif

#endif
