/* $Id: gtkspin.c,v 1.1 2006-09-08 12:18:45 xthefull Exp $*/
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

HB_FUNC( GTK_SPIN_BUTTON_NEW )  //pAdjust, value, decimals -->pWidget
{
   GtkWidget * spin_button = NULL;
   GtkObject * adjust = GTK_OBJECT(  hb_parptr( 1 )  );

   spin_button = gtk_spin_button_new( GTK_ADJUSTMENT(adjust), hb_parni( 2 ), hb_parni( 3 ) );
   hb_retptr( ( GtkWidget * ) spin_button );

}

HB_FUNC( GTK_SPIN_BUTTON_NEW_WITH_RANGE ) // min,max, step -->pWidget
{
   GtkWidget * spin_button;
   spin_button =  gtk_spin_button_new_with_range( hb_parnd( 1 ),
												  hb_parnd( 2 ),
                                                  hb_parnd( 3 ) );
  hb_retptr( ( GtkWidget * ) spin_button );
}

HB_FUNC( GTK_SPIN_BUTTON_GET_NUMERIC )
{
    GtkWidget * spin_button = GTK_WIDGET( hb_parptr( 1 ) );
    hb_retni( gtk_spin_button_get_numeric( GTK_SPIN_BUTTON( spin_button ) ) );
}

HB_FUNC( GTK_SPIN_BUTTON_SET_NUMERIC )
{
    GtkWidget * spin_button = GTK_WIDGET( hb_parptr( 1 ) );
    gtk_spin_button_set_numeric( GTK_SPIN_BUTTON( spin_button ), hb_parl( 2 ) ) ;
}

HB_FUNC( GTK_SPIN_BUTTON_GET_DIGITS )
{
    GtkWidget * spin_button = GTK_WIDGET( hb_parptr( 1 ) );
    hb_retni( gtk_spin_button_get_digits( GTK_SPIN_BUTTON( spin_button ) ) );
}

HB_FUNC( GTK_SPIN_BUTTON_GET_VALUE )
{
    GtkWidget * spin_button = GTK_WIDGET( hb_parptr( 1 ) );
    hb_retnd( gtk_spin_button_get_value( GTK_SPIN_BUTTON( spin_button ) ) );
}

HB_FUNC( GTK_SPIN_BUTTON_GET_VALUE_AS_INT )
{
    GtkWidget * spin_button = GTK_WIDGET( hb_parptr( 1 ) );
    hb_retni( gtk_spin_button_get_value_as_int( GTK_SPIN_BUTTON( spin_button ) ) );
}

HB_FUNC( GTK_SPIN_BUTTON_SET_RANGE )
{
    GtkWidget * spin_button = GTK_WIDGET( hb_parptr( 1 ) );
    gtk_spin_button_set_range( GTK_SPIN_BUTTON( spin_button ) , hb_parnd( 2 ), hb_parnd( 3 ) );
}

HB_FUNC( GTK_SPIN_BUTTON_SET_VALUE )
{
    GtkWidget * spin_button = GTK_WIDGET( hb_parptr( 1 ) );
    gtk_spin_button_set_value( GTK_SPIN_BUTTON( spin_button ) , (gdouble) hb_parnd( 2 ) );
}

HB_FUNC( GTK_SPIN_BUTTON_UPDATE )
{
    GtkWidget * spin_button = GTK_WIDGET( hb_parptr( 1 ) );
    gtk_spin_button_update( GTK_SPIN_BUTTON( spin_button ) );
}
