/* $Id: gtkscrollbar.c,v 1.1 2006-09-08 12:18:45 xthefull Exp $*/
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
 * GtkScrollbar. Barras de scroll --------------------------------------------
 *
 * NOTA: nAdjustment de obtiene al llamar a gtk_adjustment_new() que es
 *       una 'clase' gen‚rica para ajustes en widgets, p.e., spinbutton, etc.
 */

#include <gtk/gtk.h>
#include "hbapi.h"

#ifdef _GTK2_

HB_FUNC( GTK_HSCROLLBAR_NEW ) //  nAdjustment -> Widget
{
  GtkWidget * hscroll;
  GtkAdjustment * adjust = ( GtkAdjustment *) hb_parptr( 1 );
  #if GTK_MAJOR_VERSION < 3
      hscroll = gtk_hscrollbar_new( adjust );
  #else
      hscroll = gtk_scrollbar_new(  GTK_ORIENTATION_HORIZONTAL ,adjust );
  #endif    

  hb_retptr( ( GtkWidget * ) hscroll );
}

HB_FUNC( GTK_VSCROLLBAR_NEW ) //  nAdjustment -> Widget
{
  GtkWidget * vscroll;
  GtkAdjustment * adjust = ( GtkAdjustment *) hb_parptr( 1 );
  #if GTK_MAJOR_VERSION < 3
      vscroll = gtk_vscrollbar_new( adjust );
  #else
      vscroll = gtk_scrollbar_new(  GTK_ORIENTATION_VERTICAL ,adjust );
  #endif    
  hb_retptr( ( GtkWidget * ) vscroll );
}


#endif
