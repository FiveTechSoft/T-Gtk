/* $Id: gtkscale.c,v 1.1 2006-09-08 12:18:45 xthefull Exp $*/
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
 * Api GtkScale completo, incluyendo Vertical y Horizontal
 */

#include <hbapi.h>
#include <gtk/gtk.h>

HB_FUNC( GTK_HSCALE_NEW ) // pAdjust -->pWidget
{
  GtkObject * adjust = GTK_OBJECT( hb_parptr( 1 ) );
  GtkWidget * widget = gtk_hscale_new( GTK_ADJUSTMENT( adjust ) );
  hb_retptr( ( GtkWidget * ) widget );
}

HB_FUNC( GTK_HSCALE_NEW_WITH_RANGE ) // dMin, dMan, dStep
{
  gdouble min  = hb_parnd( 1 );
  gdouble max  = hb_parnd( 2 );
  gdouble step = hb_parnd( 3 );
  GtkWidget * widget = gtk_hscale_new_with_range( min, max, step );
  hb_retptr( ( GtkWidget * ) widget );
}

HB_FUNC( GTK_VSCALE_NEW ) // pAdjust -->pWidget
{
  GtkObject * adjust = GTK_OBJECT( hb_parptr( 1 ) );
  GtkWidget * widget = gtk_vscale_new( GTK_ADJUSTMENT( adjust ) );
  hb_retptr( ( GtkWidget * ) widget );
}

HB_FUNC( GTK_VSCALE_NEW_WITH_RANGE ) // dMin,dMan, dStep
{
  gdouble min  = hb_parnd( 1 );
  gdouble max  = hb_parnd( 2 );
  gdouble step = hb_parnd( 3 );
  GtkWidget * widget = gtk_vscale_new_with_range( min, max, step );
  hb_retptr( ( GtkWidget * ) widget );
}

HB_FUNC( GTK_SCALE_SET_DIGITS ) // pWdiget, iDigits
{
    GtkWidget * scale = GTK_WIDGET( hb_parptr( 1 ) );
	gtk_scale_set_digits( GTK_SCALE( scale ), hb_parni( 2 ) );
}

HB_FUNC( GTK_SCALE_SET_DRAW_VALUE ) // pWdiget, bDraw_value
{
    GtkWidget * scale = GTK_WIDGET( hb_parptr( 1 ) );
	gtk_scale_set_draw_value( GTK_SCALE( scale ), hb_parl( 2 ) );
}

HB_FUNC( GTK_SCALE_SET_VALUE_POS ) // pWidget, iPositionType
{
    GtkWidget * scale = GTK_WIDGET( hb_parptr( 1 ) );
    gtk_scale_set_value_pos( GTK_SCALE( scale ) , hb_parni( 2 ) );
}

HB_FUNC( GTK_SCALE_GET_DIGITS ) // pWidget --> iDigits
{
    GtkWidget * scale = GTK_WIDGET( hb_parptr( 1 ) );
    hb_retni(  gtk_scale_get_digits( GTK_SCALE( scale ) ) );
}

HB_FUNC( GTK_SCALE_GET_DRAW_VALUE ) // pWdiget --> bDraw_value
{
    GtkWidget * scale = GTK_WIDGET( hb_parptr( 1 ) );
	hb_retl( gtk_scale_get_draw_value( GTK_SCALE( scale ) ) );
}

HB_FUNC( GTK_SCALE_GET_VALUE_POS ) // pWidget --> iPositionType
{
    GtkWidget * scale = GTK_WIDGET( hb_parptr( 1 ) );
    hb_retni( gtk_scale_get_value_pos( GTK_SCALE( scale ) ) );
}

#if GTK_CHECK_VERSION( 2,4,0 )
HB_FUNC( GTK_SCALE_GET_LAYOUT ) // pWidget --> pPango
{
    GtkWidget * scale = GTK_WIDGET( hb_parptr( 1 ) );
    PangoLayout * pango = gtk_scale_get_layout( GTK_SCALE( scale ) );
    hb_retptr( ( PangoLayout * ) pango );
}

HB_FUNC( GTK_SCALE_GET_LAYOUT_OFFSETS ) // pWidget, iX, iY
{
    GtkWidget * scale = GTK_WIDGET( hb_parptr( 1 ) );
    gint * X = (gint *) hb_parni( 2 );
    gint * Y = (gint *) hb_parni( 3 );
    gtk_scale_get_layout_offsets( GTK_SCALE( scale ), X, Y );
}
#endif
