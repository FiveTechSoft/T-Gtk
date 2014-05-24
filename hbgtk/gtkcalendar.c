/* $Id: gtkcalendar.c,v 1.1 2006-09-08 12:18:45 xthefull Exp $*/
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

#if GTK_MAJOR_VERSION < 3

HB_FUNC( GTK_CALENDAR_NEW )
{
   GtkWidget * calendar = gtk_calendar_new();
   hb_retptr( ( GtkWidget * ) calendar );
}

HB_FUNC( GTK_CALENDAR_SELECT_MONTH ) // calendar, month, year
{
  GtkWidget * calendar = ( GtkWidget * ) hb_parptr( 1 );
  guint month = hb_parni( 2 );
  guint year  = hb_parni( 3 );

  gtk_calendar_select_month( GTK_CALENDAR( calendar ), month, year );
}

HB_FUNC( GTK_CALENDAR_SELECT_DAY ) // calendar, day
{
  GtkWidget * calendar = ( GtkWidget * ) hb_parptr( 1 );
  guint day = hb_parni( 2 );
  gtk_calendar_select_day ( GTK_CALENDAR( calendar ), day );
}

HB_FUNC( GTK_CALENDAR_MARK_DAY ) //calendar, day
{
  GtkWidget * calendar = ( GtkWidget * ) hb_parptr( 1 );
  guint day = hb_parni( 2 );
  gtk_calendar_mark_day ( GTK_CALENDAR( calendar ), day );
}

HB_FUNC( GTK_CALENDAR_UNMARK_DAY ) //calendar, day
{
  GtkWidget * calendar = ( GtkWidget * ) hb_parptr( 1 );
  guint day = hb_parni( 2 );
  gtk_calendar_unmark_day ( GTK_CALENDAR( calendar ), day );
}

HB_FUNC( GTK_CALENDAR_CLEAR_MARKS ) // calendar
{
  GtkWidget * calendar = ( GtkWidget * ) hb_parptr( 1 );
  gtk_calendar_clear_marks( GTK_CALENDAR( calendar ) );
}

/*
HB_FUNC( GTK_CALENDAR_DISPLAY_OPTIONS ) // calendar, flags
{
  GtkWidget * calendar = GTK_WIDGET( hb_parptr( 1 ) );
  GtkCalendarDisplayOptions flags = hb_parni( 2 );
  gtk_calendar_display_options( GTK_CALENDAR( calendar ) , flags );
}

*/

HB_FUNC( GTK_CALENDAR_DISPLAY_OPTIONS ) // calendar, flags
{
  GtkWidget * calendar = GTK_WIDGET( hb_parptr( 1 ) );
  GtkCalendarDisplayOptions flags = hb_parni( 2 );
  gtk_calendar_set_display_options( GTK_CALENDAR( calendar ) , flags );
  gtk_calendar_display_options( GTK_CALENDAR( calendar ) , flags );
 }

HB_FUNC( GTK_CALENDAR_GET_DATE )
{
  GtkWidget * calendar = ( GtkWidget * ) hb_parptr( 1 );
  guint year;
  guint month;
  guint day;
  gtk_calendar_get_date( GTK_CALENDAR( calendar ),
                         &year, &month,&day );

  hb_retd( (glong)year, (glong)month+1, (glong)day );
}

HB_FUNC( GTK_CALENDAR_FREEZE )
{
  GtkWidget * calendar = ( GtkWidget * ) hb_parptr( 1 );
  gtk_calendar_freeze( GTK_CALENDAR( calendar ) );
}

HB_FUNC( GTK_CALENDAR_THAW )
{
  GtkWidget * calendar = ( GtkWidget * ) hb_parptr( 1 );
  gtk_calendar_thaw( GTK_CALENDAR( calendar ) );
}


#endif

