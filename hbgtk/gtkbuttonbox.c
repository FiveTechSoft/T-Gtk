/* $Id: gtkbuttonbox.c,v 1.1 2006-09-08 12:18:45 xthefull Exp $*/
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

HB_FUNC( GTK_BUTTON_BOX_SET_LAYOUT ) // widget, enum GtkButtonBoxStyle -> void   
{
  GtkWidget * widget = GTK_WIDGET( hb_parnl( 1 ) );   
  gtk_button_box_set_layout( GTK_BUTTON_BOX( widget ),
                             hb_parni( 2 ) );
}

HB_FUNC( GTK_BUTTON_BOX_GET_LAYOUT ) // widget --> GtkButtonBoxStyle 
{
  GtkWidget * widget = GTK_WIDGET( hb_parnl( 1 ) );   
  GtkButtonBoxStyle style = gtk_button_box_get_layout( GTK_BUTTON_BOX( widget ) );
  hb_retni( (gint) style );
}
                             
HB_FUNC( GTK_HBUTTON_BOX_NEW ) // void --> widget
{
  GtkWidget * widget = gtk_hbutton_box_new();
  hb_retnl( (glong) widget );
}

HB_FUNC( GTK_VBUTTON_BOX_NEW ) // void --> widget
{
  GtkWidget * widget = gtk_vbutton_box_new();
  hb_retnl( (glong) widget );
}




