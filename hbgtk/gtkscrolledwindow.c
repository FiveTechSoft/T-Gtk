/* $Id: gtkscrolledwindow.c,v 1.1 2006-09-08 12:18:45 xthefull Exp $*/
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
 * GtkScrolledWindow. Barras de scroll para widgets --------------------------
 */

#include <gtk/gtk.h>
#include "hbapi.h"

#ifdef _GTK2_

HB_FUNC( GTK_SCROLLED_WINDOW_NEW )
{
   GtkWidget *scroll;
   GtkAdjustment *hadjustment, *vadjustment;

   if ISNIL( 1 )
      hadjustment = GTK_ADJUSTMENT( hb_parptr( 1 ) );
   else
      hadjustment = NULL;
   if ISNIL( 2 )
      vadjustment = GTK_ADJUSTMENT( hb_parptr( 2 ) );
   else
      vadjustment = NULL;
           
   scroll = gtk_scrolled_window_new( hadjustment, vadjustment );
   hb_retptr( ( GtkWidget * ) scroll );
}

//---------------------------------------------------//

HB_FUNC( GTK_SCROLLED_WINDOW_SET_POLICY )
{
   GtkWidget * scroll = GTK_WIDGET( hb_parptr( 1 ) );
   gtk_scrolled_window_set_policy( GTK_SCROLLED_WINDOW( scroll ),
                                   (gint) hb_parni(2), (gint) hb_parni(3) );
}

//---------------------------------------------------//

HB_FUNC( GTK_SCROLLED_WINDOW_ADD_WITH_VIEWPORT )
{
   GtkWidget * scroll = GTK_WIDGET( hb_parptr( 1 ) );
   GtkWidget * child  = GTK_WIDGET( hb_parptr( 2 ) );
   gtk_scrolled_window_add_with_viewport( GTK_SCROLLED_WINDOW (scroll),
   				          child );
}   

//---------------------------------------------------//

HB_FUNC( GTK_SCROLLED_WINDOW_SET_SHADOW_TYPE )
{
   GtkWidget * scroll = GTK_WIDGET( hb_parptr( 1 ) );
   gtk_scrolled_window_set_shadow_type( GTK_SCROLLED_WINDOW (scroll),
                                        (gint) hb_parni(2) );
}

//---------------------------------------------------//
#if GTK_MAJOR_VERSION < 3
HB_FUNC( GTK_SCROLLED_WINDOW_GET_SCROLL )
{
   GtkWidget *scroll     = GTK_WIDGET( hb_parptr( 1 ) );
   GtkWidget *hscrollbar = GTK_SCROLLED_WINDOW (scroll)->hscrollbar;
   GtkWidget *vscrollbar = GTK_SCROLLED_WINDOW (scroll)->vscrollbar;
   if (hb_parni(2) == 0)
      hb_retptr( ( GtkWidget * ) hscrollbar );
   else
      hb_retptr( ( GtkWidget * ) vscrollbar );
}
#endif
//---------------------------------------------------//

HB_FUNC( GTK_SCROLLED_WINDOW_SET_HADJUSTMENT )
{
   GtkScrolledWindow *scroll  = GTK_SCROLLED_WINDOW (hb_parptr( 1 ));
   GtkAdjustment *hadjustment = GTK_ADJUSTMENT (hb_parptr( 2 ));
   
   gtk_scrolled_window_set_hadjustment( scroll, hadjustment);
}

//---------------------------------------------------//

HB_FUNC( GTK_SCROLLED_WINDOW_SET_VADJUSTMENT )
{
   GtkScrolledWindow *scroll  = GTK_SCROLLED_WINDOW (hb_parptr( 1 ));
   GtkAdjustment *vadjustment = GTK_ADJUSTMENT (hb_parptr( 2 ));
   
   gtk_scrolled_window_set_vadjustment( scroll, vadjustment);
}

//---------------------------------------------------//

HB_FUNC( GTK_SCROLLED_WINDOW_GET_VADJUSTMENT )
{
   GtkScrolledWindow *scroll  = GTK_SCROLLED_WINDOW (hb_parptr( 1 ));
   GtkAdjustment * vadjustment = gtk_scrolled_window_get_vadjustment( scroll );
   hb_retptr( ( GtkAdjustment * ) vadjustment );
}

//---------------------------------------------------//

#endif
