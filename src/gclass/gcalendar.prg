/* $Id: gcalendar.prg,v 1.1 2006-09-07 17:07:55 xthefull Exp $*/
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
*/
#include "gtkapi.ch"
#include "hbclass.ch"

CLASS gCalendar FROM GWIDGET

    DATA dDate INIT date()
    DATA nStyle
    DATA bDaySelected, bDayD
    DATA bPrevMonth, bNextMonth, bMonthChanged
    DATA bPrevYear, bNextYear

    METHOD New()
    METHOD GetDate() INLINE gtk_calendar_get_date( ::pWidget )
    METHOD SetDate( dDate )
    METHOD MarkDay( nDay ) INLINE gtk_calendar_mark_day( ::pWidget, nDay )
    METHOD SetStyle( nStyle )

    METHOD OnDay_Selected( oSender )
    METHOD OnDay_Selected_double_click( oSender )
    METHOD OnMonth_changed( oSender )
    METHOD OnNext_Month( oSender )
    METHOD OnNext_Year( oSender )
    METHOD OnPrev_Month( oSender )
    METHOD OnPrev_Year( oSender )

ENDCLASS

METHOD New( dDate, nStyle, lMarkDay, bDaySelected, bDayD, bPrevMonth, bNextMonth, bMonthChanged,;
            bPrevYear, bNextYear, oParent, lExpand, lFill, nPadding, lContainer, x, y,;
            cId, uGlade, uLabelTab, nWidth, nHeight, lSecond, lResize, lShrink,;
            left_ta, right_ta, top_ta, bottom_ta,xOptions_ta, yOptions_ta ) CLASS GCALENDAR

       IF cId == NIL
          ::pWidget = gtk_calendar_new( )
       ELSE
          ::pWidget := glade_xml_get_widget( uGlade, cId )
          ::CheckGlade( cId )
       ENDIF

       ::Register()

       ::AddChild( oParent, lExpand, lFill, nPadding, lContainer, x, y,;
                   uLabelTab, ,lSecond, lResize, lShrink, left_ta, right_ta, top_ta, bottom_ta,;
                   xOptions_ta, yOptions_ta )

       ::SetStyle( nStyle )

       if dDate  != NIL
          ::SetDate( dDate )
       else
          ::SetDate( ::dDate )
       endif

       if lMarkDay
          ::MarkDay( day( dDate ) )
       endif

       // Conectamos señales a medida.
       if !Empty( bDaySelected )
          ::bDaySelected := bDaySelected
          ::Connect( "day-selected" )
       endif

       if !Empty( bDayD )
          ::bDayD := bDayD
          ::Connect( "day-selected-double-click" )
       endif

       if !Empty( bPrevMonth )
          ::bPrevMonth := bPrevMonth
          ::Connect( "prev-month" )
       endif

       if !Empty( bNextMonth )
          ::bNextMonth := bNextMonth
          ::Connect( "next-month" )
       endif

       if !Empty( bMonthChanged  )
          ::bMonthChanged := bMonthChanged
          ::Connect( "month-changed" )
       endif

       if !Empty( bNextYear  )
          ::bNextYear := bNextYear
          ::Connect( "next-year" )
       endif

       if !Empty( bPrevYear)
          ::bPrevYear := bPrevYear
          ::Connect( "prev-year" )
       endif

       ::Show()

RETURN Self

METHOD SetStyle( nStyle ) CLASS GCALENDAR

       if nStyle != NIL
          ::nStyle := nStyle
           gtk_calendar_display_options( ::pWidget, ::nStyle )
       endif

Return NIL

METHOD SetDate( dDate ) CLASS GCALENDAR

       if Valtype( dDate ) == "D"
          ::dDate := dDate
          gtk_calendar_select_month( ::pWidget, month( dDate )-1, year( dDate ) )
          gtk_calendar_select_day( ::pWidget,day( dDate ) )
       endif

RETURN NIL

METHOD OnDay_Selected( oSender )  CLASS GCALENDAR
       EVAL( oSender:bDaySelected, oSender )
RETURN .F.

METHOD OnDay_Selected_double_click( oSender ) CLASS GCALENDAR
       EVAL( oSender:bDayD, oSender )
RETURN .F.

METHOD OnMonth_changed( oSender )     CLASS GCALENDAR
       EVAL( oSender:bMonthChanged, oSender )
RETURN .F.

METHOD OnNext_Month( oSender )        CLASS GCALENDAR
       EVAL( oSender:bNextMonth, oSender )
RETURN .F.

METHOD OnNext_Year( oSender )         CLASS GCALENDAR
       EVAL( oSender:bNextYear, oSender )
RETURN .F.

METHOD OnPrev_Month( oSender )        CLASS GCALENDAR
       EVAL( oSender:bPrevMonth, oSender )
RETURN .F.

METHOD OnPrev_Year( oSender )         CLASS GCALENDAR
       EVAL( oSender:bPrevYear,oSender )
RETURN .F.



