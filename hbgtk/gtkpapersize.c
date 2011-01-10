/*
 *  API Printer GTK for [x]Harbour.
 *  GtkPaperSize — Support for named paper sizes
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

#if GTK_CHECK_VERSION(2,10,0)
HB_FUNC( GTK_PAPER_SIZE_NEW )
{
 GtkPaperSize * size;
 const gchar *name = hb_parc( 1 );
 size = gtk_paper_size_new( name); 
 hb_retptr( ( GtkPaperSize * ) size );
}

HB_FUNC( GTK_PAPER_SIZE_FREE )
{
 GtkPaperSize * size = ( GtkPaperSize * ) hb_parptr( 1 );
 gtk_paper_size_free( size );
}

#endif
