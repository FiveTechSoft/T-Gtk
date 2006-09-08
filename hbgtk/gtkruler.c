/* $Id: gtkruler.c,v 1.1 2006-09-08 12:18:45 xthefull Exp $*/
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
 * GtkRuler. Manejo de 'reglas' en GTK ----------------------------------------
 *
 * Notas by Quim:
 * Para la comprension de widgets 'dibujables' estos son de lo
 * mas simples de ver.
 */

#include <gtk/gtk.h>
#include "hbapi.h"

HB_FUNC( GTK_HRULER_NEW ) // -> widget
{
   GtkWidget * hruler = gtk_hruler_new();
   hb_retnl( (glong) hruler );
}

HB_FUNC( GTK_VRULER_NEW ) // -> widget
{
   GtkWidget * vruler = gtk_vruler_new();
   hb_retnl( (glong) vruler );
}

HB_FUNC( GTK_RULER_GET_METRIC ) // -> GtkMetricType enum
{
   gint GtkMetricType;
   GtkWidget * ruler = GTK_WIDGET( hb_parnl( 1 ) );	
   GtkMetricType = gtk_ruler_get_metric( GTK_RULER (ruler) );
   hb_retni( (gint) GtkMetricType );
}   

HB_FUNC( GTK_RULER_SET_METRIC ) // widget, GtkMetricType --> void
{
   GtkWidget * ruler = GTK_WIDGET( hb_parnl( 1 ) );	
   gtk_ruler_set_metric( GTK_RULER (ruler), hb_parni( 2 ) );
}   

/**
 * En Gtk+ gtk_ruler_get_range() solo rellena los punteros gdouble
 * con los valores de la estructura widget GtkRuler
 **/
HB_FUNC( GTK_RULER_GET_RANGE ) // widget, --> hbarray values
{
   GtkWidget * ruler = GTK_WIDGET( hb_parnl( 1 ) );
   gdouble lower     = GTK_RULER (ruler)->lower;
   gdouble upper     = GTK_RULER (ruler)->upper;
   gdouble position  = GTK_RULER (ruler)->position;
   gdouble max_size  = GTK_RULER (ruler)->max_size;

/* Preparando [x]Harbour para devolver un array de 4 elementos */ 
   hb_reta( 4 );
   hb_stornl( (glong) lower, -1, 1 );
   hb_stornl( (glong) upper, -1, 2 );
   hb_stornl( (glong) position, -1, 3 );
   hb_stornl( (glong) max_size, -1, 4 );
}

HB_FUNC( GTK_RULER_SET_RANGE ) // widget, lower, upper, position, max_size --> void
{
   GtkWidget * ruler = GTK_WIDGET( hb_parnl( 1 ) );
   gtk_ruler_set_range( GTK_RULER (ruler),
                        (gdouble) hb_parnl( 2 ),
                        (gdouble) hb_parnl( 3 ),
                        (gdouble) hb_parnl( 4 ),
                        (gdouble) hb_parnl( 5 ) );
} 


   
