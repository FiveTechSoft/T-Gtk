/* $Id: gtkmisc.c,v 1.1 2006-09-08 12:18:45 xthefull Exp $*/
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

/*
#DEFINE LEFT 0.0
#DEFINE CENTER 0.5
#DEFINE RIGTH  1.0
*/

HB_FUNC( GTK_MISC_SET_ALIGNMENT ) // widget, nPosH, nPosV
{
  GtkWidget * widget = ( GtkWidget * ) hb_parptr( 1 );
  gtk_misc_set_alignment( GTK_MISC( widget ), hb_parnd(2), hb_parnd( 3 ) );
}

HB_FUNC( GTK_MISC_SET_PADDING ) // widget, nxpad, nypad
{
  GtkWidget * widget = ( GtkWidget * ) hb_parptr( 1 );
  gtk_misc_set_padding( GTK_MISC( widget ), hb_parni(2), hb_parni( 3 ) );
}

HB_FUNC( GTK_MISC_GET_ALIGNMENT ) // widget, @nPosH, @nPosV
{
  GtkWidget * widget = ( GtkWidget * ) hb_parptr( 1 );
  gfloat  x;
  gfloat  y;
  gtk_misc_get_alignment( GTK_MISC( widget ), &x, &y );
  hb_stornd( ( gfloat ) x, 2 );
  hb_stornd( ( gfloat ) y, 3 );
}

HB_FUNC( GTK_MISC_GET_PADDING ) // widget, @nxpad, @nypad
{
  GtkWidget * widget = ( GtkWidget * ) hb_parptr( 1 );
  gint  xpad;
  gint  ypad;
  gtk_misc_get_padding( GTK_MISC( widget ), &xpad, &ypad );
  hb_storni( xpad, 2 );
  hb_storni( ypad, 3 );
}
