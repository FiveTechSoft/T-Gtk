/* $Id: window.c,v 1.2 2007-03-02 08:21:32 xthefull Exp $*/
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

gint destroy( GtkWidget *widget, gpointer data )
{
  gtk_main_quit();
  return FALSE;
}
/* Conexion a destroy directamente */
HB_FUNC( CONNECT_DESTROY_WIDGET )
{
  GtkWidget * window = GTK_WIDGET( hb_parnl( 1 ) );
  g_signal_connect( G_OBJECT( window ),
                      "destroy",
                      G_CALLBACK( destroy ), NULL );
}

/*
 * Wrappers de dummpy
 * */

HB_FUNC( GTK_WINDOW )
{
  hb_retnl( (glong) hb_parnl( 1 ) );
}

HB_FUNC( GTK_CONTAINER )
{
  hb_retnl( (glong) hb_parnl( 1 ) );
}
HB_FUNC( GTK_BOX)
{
  hb_retnl( (glong) hb_parnl( 1 ) );
}

HB_FUNC( GTK_COMBO_BOX )
{
  hb_retnl( (glong) hb_parnl( 1 ) );
}

HB_FUNC( GTK_TOOLBAR )
{
  hb_retnl( (glong) hb_parnl( 1 ) );
}

HB_FUNC( GTK_TREE )
{
  hb_retnl( (glong) hb_parnl( 1 ) );
}

HB_FUNC( GTK_SCROLLED_WINDOW )
{
  hb_retnl( (glong) hb_parnl( 1 ) );
}

HB_FUNC( GTK_TREE_ITEM )
{
  hb_retnl( (glong) hb_parnl( 1 ) );
}

HB_FUNC( GTK_ASSISTANT )
{
  hb_retnl( (glong) hb_parnl( 1 ) );
}

HB_FUNC( GTK_ENTRY )
{
  hb_retnl( (glong) hb_parnl( 1 ) );
}
