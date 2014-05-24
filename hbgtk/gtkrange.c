/* $Id: gtkrange.c,v 1.1 2006-09-08 12:18:45 xthefull Exp $*/
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

#if GTK_MAJOR_VERSION < 3

HB_FUNC( GTK_RANGE_SET_UPDATE_POLICY ) // pWidget, nTypeUpdate
{
    GtkWidget * range = GTK_WIDGET( hb_parptr( 1 ) );
    gtk_range_set_update_policy( GTK_RANGE( range ), hb_parni( 2 ));
}

HB_FUNC( GTK_RANGE_GET_ADJUSTMENT ) // pWidget--> pAdjustment
{
    GtkWidget * range = GTK_WIDGET( hb_parptr( 1 ) );
    GtkAdjustment * adjust;
    adjust =  gtk_range_get_adjustment( GTK_RANGE( range ) );
    hb_retptr( ( GtkWidget * ) adjust );
}

HB_FUNC( GTK_RANGE_SET_ADJUSTMENT ) // pWidget, pAdjustment
{
   GtkWidget * range = GTK_WIDGET( hb_parptr( 1 ) );
   GObject * adjust  = G_OBJECT( hb_parptr( 2 ) );
   gtk_range_set_adjustment( GTK_RANGE( range ), GTK_ADJUSTMENT( adjust ) );
}

HB_FUNC( GTK_RANGE_GET_INVERTED ) // pWidget --> bResult
{
   GtkWidget * range = GTK_WIDGET( hb_parptr( 1 ) );
   hb_retl( gtk_range_get_inverted( GTK_RANGE( range ) ) );
}

HB_FUNC( GTK_RANGE_SET_INVERTED ) // pWidget, bSetting
{
   GtkWidget * range = GTK_WIDGET( hb_parnl( 1 ) );
   gtk_range_set_inverted( GTK_RANGE( range ) , hb_parl( 2 ) );
}

HB_FUNC( GTK_RANGE_GET_UPDATE_POLICY ) // pWidget--> iTypeUpdate
{
   GtkWidget * range = GTK_WIDGET( hb_parptr( 1 ) );
   hb_retni( gtk_range_get_update_policy( GTK_RANGE( range ) ) );
}

HB_FUNC( GTK_RANGE_GET_VALUE ) // pWidget--> dValue
{
   GtkWidget * range = GTK_WIDGET( hb_parptr( 1 ) );
   hb_retnd( gtk_range_get_value( GTK_RANGE( range ) ) );
}

HB_FUNC( GTK_RANGE_SET_INCREMENTS ) // pWidget, dStep, dPage
{
   GtkWidget * range = GTK_WIDGET( hb_parptr( 1 ) );
   gdouble step = hb_parnd( 2 );
   gdouble page = hb_parnd( 3 );
   gtk_range_set_increments( GTK_RANGE( range ),
                             step, page );
}

HB_FUNC( GTK_RANGE_SET_RANGE ) // pWidget, dMin, dMax
{
   GtkWidget * range = GTK_WIDGET( hb_parptr( 1 ) );
   gdouble min = hb_parnd( 2 );
   gdouble max = hb_parnd( 3 );
   gtk_range_set_range( GTK_RANGE( range ),
                                min, max );
}

HB_FUNC( GTK_RANGE_SET_VALUE ) // pWidget, dValue
{
   GtkWidget * range = GTK_WIDGET( hb_parptr( 1 ) );
   gdouble value = hb_parnd( 2 );
   gtk_range_set_value( GTK_RANGE( range ),value );
}
#if GTK_MAJOR_VERSION < 3
HB_FUNC( GTK_RANGE_GET_ORIENTATION ) // pWidget, int orientation
{
   GtkWidget * range = GTK_WIDGET( hb_parptr( 1 ) );
   gint orientation  = GTK_RANGE (range)->orientation;
   hb_retni( orientation );
}
#else
HB_FUNC( GTK_RANGE_GET_ORIENTATION ) // pWidget, int orientation
{
   hb_retni( 0 );
}
#endif

#endif
