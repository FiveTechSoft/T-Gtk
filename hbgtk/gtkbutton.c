/* $Id: gtkbutton.c,v 1.1 2006-09-08 12:18:45 xthefull Exp $*/
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
#include <t-gtk.h>

#if GTK_MAJOR_VERSION < 3

HB_FUNC( GTK_BUTTON_NEW ) // -> widget
{
   GtkWidget * button = gtk_button_new( );
   hb_retptr( ( GtkWidget * ) button );

}

HB_FUNC( GTK_BUTTON_NEW_WITH_MNEMONIC ) // _cText -> widget
{
   GtkWidget * button;
   gchar *msg = str2utf8( ( gchar * ) hb_parc( 1 ) );//g_convert( hb_parc(1), -1,"UTF-8","ISO-8859-1",NULL,NULL,NULL );

   button = gtk_button_new_with_mnemonic( msg );
   
   SAFE_RELEASE( msg );

   hb_retptr( (GtkWidget *) button );
   

}

HB_FUNC( GTK_BUTTON_NEW_WITH_LABEL ) //_cText -> widget
{
   GtkWidget * button;
   gchar *msg = str2utf8( ( gchar * ) hb_parc( 1 ) ); //g_convert( hb_parc(1), -1,"UTF-8","ISO-8859-1",NULL,NULL,NULL );
   button = gtk_button_new_with_label ( msg );

   hb_retptr( ( GtkWidget * ) button );
   
   SAFE_RELEASE( msg );
   
}

HB_FUNC( GTK_BUTTON_NEW_FROM_STOCK ) // stock_id
{
  GtkWidget * button = gtk_button_new_from_stock ( (gchar *) hb_parc( 1 ) );
  hb_retptr( ( GtkWidget * ) button );
}

HB_FUNC( GTK_BUTTON_SET_LABEL ) // widget, cText
{
  gchar *msg = str2utf8( ( gchar * ) hb_parc( 2 ) ); //g_convert( hb_parc(2), -1,"UTF-8","ISO-8859-1",NULL,NULL,NULL );
  gtk_button_set_label( GTK_BUTTON( hb_parptr( 1 ) ), msg );
  SAFE_RELEASE( msg );
}

HB_FUNC( GTK_BUTTON_GET_LABEL ) // widget -> cExt
{
 gchar *cText;
 gchar *msg;
 cText = ( gchar *) gtk_button_get_label( GTK_BUTTON( hb_parptr( 1 ) ) );
 msg = utf82str( cText );//( gchar *) g_convert( cText, -1,"ISO-8859-1","UTF-8",NULL,NULL,NULL );
 hb_retc( ( gchar * ) msg );
 SAFE_RELEASE( msg );

}

HB_FUNC( GTK_BUTTON_SET_USE_UNDERLINE )
{    
   gtk_button_set_use_underline( GTK_BUTTON( hb_parptr( 1 ) ), hb_parl( 2 ) ); 
}

