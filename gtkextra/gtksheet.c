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
    (c)2012 Rafael Carmona <rafa.tgtk at gmail.com>
    (c)2012 Daniel Garcia-Gil <danielgarciagil at gmail.com>
    (c)2012 Riztan Gutierrez <riztan at gmail.com>
*/


#ifdef _GTKEXTRA_

#include <hbapi.h>
#include <hbapiitm.h>
#include <hbapierr.h>

#include <gtkextra/gtkextra.h>

HB_FUNC( GTK_SHEET_NEW )
{
  guint rows = hb_parnl( 1 );
  guint columns = hb_parnl( 2 );
  const gchar *title = hb_parc( 3 );
  
  GtkWidget *widget = gtk_sheet_new( rows, columns, title );
  hb_retptr( widget );
}


HB_FUNC( GTK_SHEET_CONSTRUCT )
{
  GtkSheet *sheet = GTK_SHEET( hb_parptr( 1 ) );
  guint rows = hb_parnl( 2 );
  guint columns = hb_parnl( 3 );
  const gchar *title = hb_parc( 4 );
  
  gtk_sheet_construct( sheet, rows, columns, title );
}


HB_FUNC( GTK_SHEET_NEW_BROWSER )
{
  guint rows = hb_parnl( 1 );
  guint columns = hb_parnl( 2 );
  const gchar *title = hb_parc( 3 );
  
  GtkWidget *widget = gtk_sheet_new_browser( rows, columns, title );
  hb_retptr( widget );
}


#endif
//eof 
