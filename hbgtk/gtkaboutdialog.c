/* $Id: gtkaboutdialog.c,v 1.5 2007-02-27 08:21:34 xthefull Exp $*/
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
*/
#include <gtk/gtk.h>
#include "hbapi.h"

#if GTK_MAJOR_VERSION < 3

#if GTK_CHECK_VERSION(2,6,0)

HB_FUNC( GTK_ABOUT_DIALOG_NEW )
{
  GtkWidget * dialog = gtk_about_dialog_new();
  hb_retptr( ( GtkWidget * ) dialog );
}

HB_FUNC( GTK_ABOUT_DIALOG_GET_NAME )
{
  GtkAboutDialog  * dialog = GTK_ABOUT_DIALOG( hb_parnl( 1 ) );
  #if GTK_MAJOR_VERSION < 3
    const gchar *szText = gtk_about_dialog_get_name( dialog );
  #else
    const gchar *szText = gtk_about_dialog_get_program_name( dialog );
  #endif
  hb_retc( szText );
}

HB_FUNC( GTK_ABOUT_DIALOG_SET_NAME )
{
  GtkAboutDialog  * dialog = GTK_ABOUT_DIALOG( hb_parptr( 1 ) );
  const gchar *szText = hb_parc( 2 );
  #if GTK_MAJOR_VERSION < 3
    gtk_about_dialog_set_name( dialog, szText );
  #else
    gtk_about_dialog_set_program_name( dialog, szText );
  #endif
}

HB_FUNC( GTK_ABOUT_DIALOG_GET_VERSION )
{
  GtkAboutDialog  * dialog = GTK_ABOUT_DIALOG( hb_parptr( 1 ) );
  const gchar *szText = gtk_about_dialog_get_version( dialog );
  hb_retc( szText );
}

HB_FUNC( GTK_ABOUT_DIALOG_SET_VERSION )
{
  GtkAboutDialog  * dialog = GTK_ABOUT_DIALOG( hb_parptr( 1 ) );
  const gchar *szText = hb_parc( 2 );
  gtk_about_dialog_set_version( dialog, szText );
}

HB_FUNC( GTK_ABOUT_DIALOG_GET_COPYRIGHT )
{
  GtkAboutDialog  * dialog = GTK_ABOUT_DIALOG( hb_parptr( 1 ) );
  const gchar *szText = gtk_about_dialog_get_copyright( dialog );
  hb_retc( szText );
}

HB_FUNC( GTK_ABOUT_DIALOG_SET_COPYRIGHT )
{
  GtkAboutDialog  * dialog = GTK_ABOUT_DIALOG( hb_parptr( 1 ) );
  const gchar *szText = hb_parc( 2 );
  gtk_about_dialog_set_copyright( dialog, szText );
}

HB_FUNC( GTK_ABOUT_DIALOG_GET_COMMENTS )
{
  GtkAboutDialog  * dialog = GTK_ABOUT_DIALOG( hb_parptr( 1 ) );
  const gchar *szText = gtk_about_dialog_get_comments( dialog );
  hb_retc( szText );
}

HB_FUNC( GTK_ABOUT_DIALOG_SET_COMMENTS )
{
  GtkAboutDialog  * dialog = GTK_ABOUT_DIALOG( hb_parptr( 1 ) );
  const gchar *szText = hb_parc( 2 );
  gtk_about_dialog_set_comments( dialog, szText );
}

HB_FUNC( GTK_ABOUT_DIALOG_GET_LICENSE )
{
  GtkAboutDialog  * dialog = GTK_ABOUT_DIALOG( hb_parptr( 1 ) );
  const gchar *szText = gtk_about_dialog_get_license( dialog );
  hb_retc( szText );
}

HB_FUNC( GTK_ABOUT_DIALOG_SET_LICENSE )
{
  GtkAboutDialog  * dialog = GTK_ABOUT_DIALOG( hb_parptr( 1 ) );
  const gchar *szText = hb_parc( 2 );
  gtk_about_dialog_set_license( dialog, szText );
}

HB_FUNC( GTK_ABOUT_DIALOG_GET_WEBSITE )
{
  GtkAboutDialog  * dialog = GTK_ABOUT_DIALOG( hb_parptr( 1 ) );
  const gchar *szText = gtk_about_dialog_get_website( dialog );
  hb_retc( szText );
}

HB_FUNC( GTK_ABOUT_DIALOG_SET_WEBSITE )
{
  GtkAboutDialog  * dialog = GTK_ABOUT_DIALOG( hb_parptr( 1 ) );
  const gchar *szText = hb_parc( 2 );
  gtk_about_dialog_set_website( dialog, szText );
}

HB_FUNC( GTK_ABOUT_DIALOG_GET_WEBSITE_LABEL )
{
  GtkAboutDialog  * dialog = GTK_ABOUT_DIALOG( hb_parptr( 1 ) );
  const gchar *szText = gtk_about_dialog_get_website_label( dialog );
  hb_retc( szText );
}

HB_FUNC( GTK_ABOUT_DIALOG_SET_WEBSITE_LABEL )
{
  GtkAboutDialog  * dialog = GTK_ABOUT_DIALOG( hb_parptr( 1 ) );
  const gchar *szText = hb_parc( 2 );
  gtk_about_dialog_set_website_label( dialog, szText );
}

HB_FUNC( GTK_ABOUT_DIALOG_SET_ARTISTS )
{
  GtkAboutDialog  * dialog = GTK_ABOUT_DIALOG( hb_parptr( 1 ) );
  PHB_ITEM pArray = hb_param( 2, HB_IT_ARRAY ); // array
  gint iLenCols = hb_arrayLen( pArray );        // columnas
  gint iCol;                                    // contador
  const gchar **artist = hb_xgrab( sizeof( const gchar * ) * iLenCols + 1 ); 
  
  for( iCol = 0; iCol < iLenCols ; iCol++ )
   {                                     
     artist[ iCol ] = ( const gchar * ) hb_arrayGetC( pArray, (iCol + 1) );;
   }
   artist[ iCol ] = NULL; // ultima
   gtk_about_dialog_set_artists( dialog, artist  );

   hb_xfree( artist ); 
}

HB_FUNC( GTK_ABOUT_DIALOG_SET_AUTHORS )
{
  GtkAboutDialog  * dialog = GTK_ABOUT_DIALOG( hb_parptr( 1 ) );
  PHB_ITEM pArray = hb_param( 2, HB_IT_ARRAY ); 
  gint iLenCols = hb_arrayLen( pArray );        
  gint iCol;                                    
  const gchar **authors = hb_xgrab( sizeof( const gchar * ) * iLenCols + 1 ); 
  
  for( iCol = 0; iCol < iLenCols ; iCol++ )
   {
     authors[ iCol ] = ( const gchar * ) hb_arrayGetC( pArray, (iCol + 1) );
   }
   authors[ iCol ] = NULL; // ultima
   gtk_about_dialog_set_authors( dialog, authors  );
   
   hb_xfree( authors ); 
}

HB_FUNC( GTK_ABOUT_DIALOG_SET_DOCUMENTERS )
{
  GtkAboutDialog  * dialog = GTK_ABOUT_DIALOG( hb_parptr( 1 ) );
  PHB_ITEM pArray = hb_param( 2, HB_IT_ARRAY ); 
  gint iLenCols = hb_arrayLen( pArray );        
  gint iCol;                                    
  const gchar **documenters  = hb_xgrab( sizeof( const gchar * ) * iLenCols + 1 );
  
  for( iCol = 0; iCol < iLenCols ; iCol++ )
   {
     documenters[ iCol ] = ( const gchar * ) hb_arrayGetC( pArray, iCol + 1 );
   }
   documenters[ iCol ] = NULL; 
   gtk_about_dialog_set_documenters( dialog, documenters );

   hb_xfree( documenters ); 
}

HB_FUNC( GTK_ABOUT_DIALOG_SET_LOGO )
{
  GtkAboutDialog  * dialog = GTK_ABOUT_DIALOG( hb_parptr( 1 ) );
  GdkPixbuf * logo = GDK_PIXBUF( hb_parptr( 2 ) );
  gtk_about_dialog_set_logo( dialog, logo );
}


HB_FUNC( GTK_SHOW_ABOUT_DIALOG )
{
  GtkWindow  * parent ;
  parent = ISNIL( 1 ) ? NULL : GTK_WINDOW( hb_parptr( 1 ) );
  gtk_show_about_dialog( parent, NULL, NULL );
}
#endif

//eof
