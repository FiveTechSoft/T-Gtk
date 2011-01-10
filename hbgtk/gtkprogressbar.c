/* $Id: gtkprogressbar.c,v 1.1 2006-09-08 12:18:45 xthefull Exp $*/
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

HB_FUNC( GTK_PROGRESS_BAR_NEW )
{
   GtkWidget * progressbar = gtk_progress_bar_new();
   hb_retptr( ( GtkWidget * ) progressbar );
}

HB_FUNC( GTK_PROGRESS_BAR_PULSE ) //widget
{
   GtkWidget * progressbar = GTK_WIDGET( hb_parptr( 1 ) );
   gtk_progress_bar_pulse( GTK_PROGRESS_BAR( progressbar ) );
}

HB_FUNC( GTK_PROGRESS_BAR_SET_TEXT ) //widget, ctext
{
   GtkWidget * progressbar = GTK_WIDGET( hb_parptr( 1 ) );
   gtk_progress_bar_set_text( GTK_PROGRESS_BAR( progressbar ), hb_parc( 2 ) );
}

HB_FUNC( GTK_PROGRESS_BAR_SET_FRACTION ) // widget, fraction
{
   GtkWidget * progressbar = GTK_WIDGET( hb_parptr( 1 ) );
   gtk_progress_bar_set_fraction( GTK_PROGRESS_BAR( progressbar ), ( gdouble ) hb_parnd( 2 ) );
}

HB_FUNC( GTK_PROGRESS_BAR_SET_PULSE_STEP ) // widget, fraction
{
   GtkWidget * progressbar = GTK_WIDGET( hb_parptr( 1 ) );
   gtk_progress_bar_set_pulse_step( GTK_PROGRESS_BAR( progressbar ), ( gdouble ) hb_parnd( 2 ) );
}

HB_FUNC( GTK_PROGRESS_BAR_SET_ORIENTATION )  // widget, nOrientation.
{
   GtkWidget * progressbar = GTK_WIDGET( hb_parptr( 1 ) );
   gtk_progress_bar_set_orientation( GTK_PROGRESS_BAR( progressbar ), hb_parni( 2 ) );
}                                             

HB_FUNC( GTK_PROGRESS_BAR_GET_TEXT ) // widget --> cText
{
   GtkWidget * progressbar = GTK_WIDGET( hb_parptr( 1 ) );
   hb_retc( ( gchar * )gtk_progress_bar_get_text( GTK_PROGRESS_BAR( progressbar ) ));
}

HB_FUNC( GTK_PROGRESS_BAR_GET_ORIENTATION )
{
   GtkWidget * progressbar = GTK_WIDGET( hb_parptr( 1 ) );
   hb_retni( (gint) gtk_progress_bar_get_orientation( GTK_PROGRESS_BAR( progressbar ) ) );
}
