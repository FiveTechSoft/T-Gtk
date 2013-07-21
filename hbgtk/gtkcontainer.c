/* $Id: gtkcontainer.c,v 1.2 2010-12-23 13:21:00 dgarciagil Exp $*/
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
#include "hbapiitm.h"

#ifdef _GTK2_

/*
 * Preparado para sopartar un dialogo
 */
HB_FUNC( GTK_CONTAINER_ADD )
{
    GtkWidget *window = GTK_WIDGET( hb_parptr( 1 ) );
    GtkWidget *widget = GTK_WIDGET( hb_parptr( 2 ) );

    if GTK_IS_DIALOG(window)
    {
        // TODO: Mirar de como obtener el vbox
        // gtk_container_add(GTK_CONTAINER( GTK_DIALOG(window)->vbox ), widget );
    }
    else
    {
        gtk_container_add(GTK_CONTAINER(window), widget  );
    }
}

HB_FUNC( GTK_CONTAINER_REMOVE )
{
    GtkWidget *window = GTK_WIDGET( hb_parptr( 1 ) );
    GtkWidget *widget = GTK_WIDGET( hb_parptr( 2 ) );

    gtk_container_remove(GTK_CONTAINER(window), widget  );
}


HB_FUNC( GTK_CONTAINER_SET_BORDER_WIDTH ) // widget, guint border_width
{
    GtkWidget *widget = GTK_WIDGET( hb_parptr( 1 ) );
    gtk_container_set_border_width( GTK_CONTAINER( widget ) , hb_parni( 2 ) );
}

HB_FUNC( GTK_CONTAINER_SET_FOCUS_CHAIN )
{
    GtkContainer *container = GTK_CONTAINER( hb_parptr( 1 ) );
    PHB_ITEM param = hb_param( 2, HB_IT_ANY );
    GList *list = NULL;

    if ( HB_IS_ARRAY( param ) ) {
       ULONG nPos = 0;
        for ( nPos = 1; nPos <= hb_arrayLen( param ); nPos++ ) {
             list = g_list_append ( list,  GTK_WIDGET( hb_arrayGetPtr( param, nPos ) ) );
        }
        gtk_container_set_focus_chain ( container, list );
     }

}

#endif
