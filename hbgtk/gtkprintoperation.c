/*
 *  API Printer GTK for [x]Harbour.
 *  GtkPrintOperation — High-level Printing API
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
HB_FUNC( GTK_PRINT_OPERATION_NEW )
{
  GtkPrintOperation * op = gtk_print_operation_new ();
  hb_retnl( ( glong ) op );
}

HB_FUNC( GTK_PRINT_OPERATION_RUN ) // operation, action, parent, @cError --> GtkPrintOperationResult
{
 GtkPrintOperation *op = GTK_PRINT_OPERATION ( hb_parnl( 1 ) );
 GtkPrintOperationAction action = hb_parni( 2 );
 GtkWindow *parent = ISNIL( 3 ) ? NULL : GTK_WINDOW( hb_parnl( 3 ) );
 GError *error = NULL;
  
 hb_retni( gtk_print_operation_run( op, action, parent, &error ) );
 
 hb_storc( error ? ( gchar * ) error->message : "", 4 );
 
 if( error )
    g_error_free( error );

}

HB_FUNC( GTK_PRINT_OPERATION_SET_N_PAGES )
{
 GtkPrintOperation *op = GTK_PRINT_OPERATION ( hb_parnl( 1 ) );
 gint n_pages = hb_parni( 2 );  
  
 gtk_print_operation_set_n_pages( op, n_pages );
}

HB_FUNC( GTK_PRINT_OPERATION_SET_UNIT )
{
 GtkPrintOperation *op = GTK_PRINT_OPERATION ( hb_parnl( 1 ) );
 GtkUnit unit = hb_parni( 2 );  
 gtk_print_operation_set_unit( op, unit );
}    

HB_FUNC( GTK_PRINT_OPERATION_SET_EXPORT_FILENAME )
{
 GtkPrintOperation *op = GTK_PRINT_OPERATION ( hb_parnl( 1 ) );
 const gchar *filename = hb_parc( 2 );
 gtk_print_operation_set_export_filename( op, filename );
}

HB_FUNC( GTK_PRINT_OPERATION_SET_DEFAULT_PAGE_SETUP )
{
 GtkPrintOperation *op = GTK_PRINT_OPERATION ( hb_parnl( 1 ) );
 GtkPageSetup * default_page_setup = GTK_PAGE_SETUP( hb_parnl( 2 ) );
 gtk_print_operation_set_default_page_setup( op, default_page_setup );
}

#endif
