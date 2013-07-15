/* $Id: gtkadjustment.c,v 1.2 2010-12-24 01:06:17 dgarciagil Exp $*/
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
 * GtkAdjustment. 'Ajustes' para widgets -------------------------------------
 *
 * Funciones GTK implementadas :
 *  + gtk_adjustment_new()
 *  + gtk_adjustment_get_value
 *  + gtk_adjustment_set_value
 *  + gtk_adjustment_clamp_page
 *  + gtk_adjustment_changed
 *  + gtk_adjustment_value_changed
 *
 * Explicación de parámetros:
 * lower = the minimum value.
 * upper = the maximum value.
 * value = the current value.
 * step_increment = the increment to use to make minor changes to
 *                  the value. In a GtkScrollbar this increment is
 *                  used when the mouse is clicked on the arrows at
 *                  the top and bottom of the scrollbar, to scroll
 *                  by a small amount.
 * page_increment = the increment to use to make major changes to the value.
 *                  In a GtkScrollbar this increment is used when the mouse
 *                  is clicked in the trough, to scroll by a large amount.
 * page_size      = the page size. In a GtkScrollbar this is the size of
 *                  the area which is currently visible.
 */

#include <gtk/gtk.h>
#include "hbapi.h"

#ifdef _GTK2_

HB_FUNC( GTK_ADJUSTMENT_NEW ) // -> nAdjustment
{
  gdouble lower = (gdouble) hb_parnd( 1 );
  gdouble upper = (gdouble) hb_parnd( 2 );
  gdouble value = (gdouble) hb_parnd( 3 );   
  gdouble step_increment = (gdouble) hb_parnd( 4 );
  gdouble page_increment = (gdouble) hb_parnd( 5 );
  gdouble page_size      = (gdouble) hb_parnd( 6 );

  GtkObject * adjust = gtk_adjustment_new( lower, upper, value,
                                               step_increment,
                                               page_increment,
                                               page_size );
  
  hb_retptr( ( GtkObject * ) adjust );
}

HB_FUNC( GTK_ADJUSTMENT_GET_VALUE ) // pAdjust-->nValue
{
   GtkObject * adjust = GTK_OBJECT(  hb_parptr( 1 )  );
   hb_retnd( gtk_adjustment_get_value( GTK_ADJUSTMENT( adjust ) ) );
}

HB_FUNC( GTK_ADJUSTMENT_SET_VALUE ) // pAdjust, nValue
{
   GtkObject * adjust = GTK_OBJECT(  hb_parptr( 1 )  );
   gtk_adjustment_set_value( GTK_ADJUSTMENT( adjust ), hb_parnd( 2 ) );
}

HB_FUNC( GTK_ADJUSTMENT_GET_STEP_INCREMENT ) // pAdjust-->step_increment
{
   GtkObject * adjust = GTK_OBJECT(  hb_parptr( 1 )  );
   hb_retnd( GTK_ADJUSTMENT( adjust )->step_increment );
}

HB_FUNC( GTK_ADJUSTMENT_GET_PAGE_INCREMENT ) // pAdjust-->page_increment
{
   GtkObject * adjust = GTK_OBJECT(  hb_parptr( 1 )  );
   hb_retnd( GTK_ADJUSTMENT( adjust )->page_increment );
}

HB_FUNC( GTK_ADJUSTMENT_GET_UPPER ) // pAdjust-->upper
{
   GtkObject * adjust = GTK_OBJECT(  hb_parptr( 1 )  );
   hb_retnd( GTK_ADJUSTMENT( adjust )->upper );
}

HB_FUNC( GTK_ADJUSTMENT_GET_LOWER ) // pAdjust-->lower
{
   GtkObject * adjust = GTK_OBJECT(  hb_parptr( 1 )  );
   hb_retnd( GTK_ADJUSTMENT( adjust )->lower );
}

HB_FUNC( GTK_ADJUSTMENT_GET_PAGE_SIZE ) // pAdjust-->page_size
{
   GtkObject * adjust = GTK_OBJECT(  hb_parptr( 1 )  );
   hb_retnd( GTK_ADJUSTMENT( adjust )->page_size );
}

HB_FUNC( GTK_ADJUSTMENT_CLAMP_PAGE ) // pAdjust, nlower, nUpper
{
   GtkObject * adjust = GTK_OBJECT(  hb_parptr( 1 )  );
   gtk_adjustment_clamp_page( GTK_ADJUSTMENT( adjust ), hb_parnd( 2 ), hb_parnd( 3 ) );
}

HB_FUNC( GTK_ADJUSTMENT_CHANGED ) // pAdjust
{
   GtkObject * adjust = GTK_OBJECT(  hb_parptr( 1 )  );
   gtk_adjustment_changed( GTK_ADJUSTMENT( adjust ) );
}

HB_FUNC( GTK_ADJUSTMENT_VALUE_CHANGED ) // pAdjust
{
   GtkObject * adjust = GTK_OBJECT(  hb_parptr( 1 )  );
   gtk_adjustment_value_changed( GTK_ADJUSTMENT( adjust ) );
}

#endif
