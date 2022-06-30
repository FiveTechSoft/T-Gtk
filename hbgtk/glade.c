/* $Id: glade.c,v 1.1 2006-09-08 12:18:45 xthefull Exp $*/
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
/*
 * Glade. Support Glade----------------------------------------------------
 */

#include <gtk/gtk.h>
#include "hbapi.h"
 

//prototypes
GtkBuilder  * _gtk_builder_new();
BOOL _gtk_builder_add_from_file( GtkBuilder * pBuilder, const gchar * filename );
GtkWidget * _gtk_builder_get_object ( GtkBuilder * pBuilder, const gchar *name );
BOOL GetGtkBuilderSts();

HB_FUNC( GLADE_XML_NEW ) //fname,root,domain
{
  g_message( "GLADE_XML_NEW is Removed! Use GTK_BUILDER_NEW." );
  GtkBuilder  * pBuilder =  _gtk_builder_new();
  const char * filename = hb_parc( 1 );
  if( _gtk_builder_add_from_file( pBuilder, ( const gchar *) filename ) ){
     hb_retptr( pBuilder );
  } else {
    g_print( "Carga de gtkbuilder no es correcta\n");
  }
}

/*
HB_FUNC( GLADE_XML_NEW_FROM_BUFFER ) //fname,root,domain
{
  GladeXML *xml;
  const char * buffer = hb_parc( 1 );
  const char * root  = ISNIL( 2 ) ? NULL : hb_parc( 2 );
  const char * domain = ISNIL( 3 ) ? NULL : hb_parc( 3 );
  xml = glade_xml_new_from_buffer( buffer, strlen(  buffer ), root, domain );
  
  hb_retptr( ( GladeXML * ) xml );
}
*/

HB_FUNC( GLADE_XML_GET_WIDGET )
{
  GtkWidget * widget;
  g_message( "GLADE_XML_GET_WIDGET is Removed! Use GTK_BUILDER_GET_OBJECT." );
  widget = GTK_WIDGET( gtk_builder_get_object ( ( GtkBuilder * ) hb_parptr( 1 ) , ( const gchar * ) hb_parc( 2 ) ) );  
  hb_retptr( widget );
}

HB_FUNC( GLADE_XML_GET_TREE_VIEW_COLUMN )
{
  GtkTreeViewColumn  * widget;
  g_message( "GLADE_XML_GET_TREE_VIEW_COLUMN is Removed! Use GTK_BUILDER_GET_OBJECT." );
  widget = GTK_TREE_VIEW_COLUMN( gtk_builder_get_object ( ( GtkBuilder * ) hb_parptr( 1 ) , ( const gchar * ) hb_parc( 2 ) ) );  
  hb_retptr( widget );
}
  

HB_FUNC( GLADE_XML_GET_CELL_RENDERER )
{
  GtkCellRenderer * widget;
  g_message( "GLADE_XML_GET_CELL_RENDERER is Removed! Use GTK_BUILDER_GET_OBJECT." );
  widget = GTK_CELL_RENDERER( ( gtk_builder_get_object ( ( GtkBuilder * ) hb_parptr( 1 ) , ( const gchar * ) hb_parc( 2 ) ) ) );  
  hb_retptr( widget );
}


HB_FUNC( GLADE_GET_WIDGET_NAME )
{
  g_message( "GLADE_GET_WIDGET_NAME is Removed!!!" );
  GtkWidget * widget = GTK_WIDGET( hb_parptr( 1 ) );
  const gchar * name = gtk_widget_get_name(widget);
  hb_retc( (gchar *) name );
}


//eof
