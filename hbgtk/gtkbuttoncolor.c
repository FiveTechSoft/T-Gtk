/* $Id: gtkbuttoncolor.c,v 1.1 2006-09-08 12:18:45 xthefull Exp $*/
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
#include <hbapi.h>
#include <gtk/gtk.h>

#ifdef _GTK2_

#if GTK_CHECK_VERSION(2,4,0) 

HB_FUNC( GTK_COLOR_BUTTON_NEW )
{
   GtkWidget * button = gtk_color_button_new();

/*   gtk_signal_connect( GTK_OBJECT( hWnd ), "color_set", ( GtkSignalFunc )
                       ClickEvent, NULL );
*/

   hb_retptr( ( GtkWidget * ) button );
}

/* TODO:
 *  Esta funcion esta 'parseada' , para usar de forma simple el uso 
 * de seleccion de color.
 */
HB_FUNC( GTK_COLOR_BUTTON_SET_COLOR )
{
   GtkWidget * button = GTK_WIDGET( hb_parptr( 1 ) );
   GdkColor color;
   // TODO:
   // Se deberia hacer un alloc_map, para mapear el color buscado en el sistema
   gdk_color_parse( hb_parc( 2 ) , &color);
   gtk_color_button_set_color( GTK_COLOR_BUTTON( button ), &color );
}

HB_FUNC( GTK_COLOR_BUTTON_GET_ALPHA ) // widget
{
   GtkWidget * button = GTK_WIDGET( hb_parptr( 1 ) );
   hb_retni( gtk_color_button_get_alpha( GTK_COLOR_BUTTON( button ) ));
}

HB_FUNC( GTK_COLOR_BUTTON_SET_ALPHA ) // widget, nAlphaColor
{
   GtkWidget * button = GTK_WIDGET( hb_parptr( 1 ) );
   gtk_color_button_set_alpha( GTK_COLOR_BUTTON( button ), (guint16) hb_parni(2) ) ;
}

HB_FUNC( GTK_COLOR_BUTTON_SET_TITLE ) // widget, cTitle
{
   GtkWidget * button = GTK_WIDGET( hb_parptr( 1 ) );
   gtk_color_button_set_title( GTK_COLOR_BUTTON( button ) , (gchar *) hb_parc(2) );
}

HB_FUNC( GTK_COLOR_BUTTON_GET_TITLE ) // widget
{
   hb_retc( ( gchar * ) gtk_color_button_get_title( GTK_COLOR_BUTTON( hb_parnl( 1 ) ) ) );
}

HB_FUNC( GTK_COLOR_BUTTON_SET_USE_ALPHA ) // widget, bUsed
{
   gtk_color_button_set_use_alpha( GTK_COLOR_BUTTON( hb_parptr(1)) , hb_parl( 2 ) );
}
#endif

#endif
