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
    DATA bDaySelected, bDayD, bDelete
    DATA bPrevMonth, bNextMonth, bMonthChanged
    DATA bPrevYear, bNextYear
    DATA bOnMarkDay,bOnUnMarkDay

    METHOD New()
    METHOD GetDate() INLINE gtk_calendar_get_date( ::pWidget )
    METHOD SetDate( dDate )
    METHOD MarkDay( nDay ) 
    METHOD UnMarkDay( nDay ) 
    METHOD ClearMarks( nDay ) INLINE gtk_calendar_clear_marks( ::pWidget )
    METHOD SetStyle( nStyle )
    
    
    METHOD OnKeyPressEvent( oSender,   pGdkEventKey  )
    METHOD OnDay_Selected( oSender )  SETGET
    METHOD OnDay_Selected_double_click( oSender ) SETGET
    METHOD OnMonth_changed( oSender ) SETGET
    METHOD OnNext_Month( oSender )    SETGET
    METHOD OnNext_Year( oSender )     SETGET
    METHOD OnPrev_Month( oSender )    SETGET
    METHOD OnPrev_Year( oSender )     SETGET

ENDCLASS

METHOD New( dDate, nStyle, lMarkDay, bDaySelected, bDayD, bPrevMonth, bNextMonth, bMonthChanged,;
            bPrevYear, bNextYear, oParent, lExpand, lFill, nPadding, lContainer, x, y,;
            cId, uGlade, uLabelTab, nWidth, nHeight, lSecond, lResize, lShrink,;
            left_ta, right_ta, top_ta, bottom_ta,xOptions_ta, yOptions_ta,;
            bOnMarkDay,bOnUnMarkDay,bDelete ) CLASS GCALENDAR

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

       if hb_IsBlock(bOnMarkDay)   ; ::bOnMarkDay   := bOnMarkDay   ; endif
       if hb_IsBlock(bOnUnMarkDay) ; ::bOnUnMarkDay := bOnUnMarkDay ; endif

       if hb_IsBlock(bDelete) ; ::bDelete := bDelete ; endif
       
       ::Connect( "key-press-event" )

       // Conectamos señales a medida.

       ::OnDay_Selected  = bDaySelected
       ::OnDay_Selected_double_click = bDayD
       ::OnMonth_changed = bMonthChanged
       ::OnNext_Month    = bNextMonth
       ::OnNext_Year     = bNextYear
       ::OnPrev_Month    = bPrevMonth
       ::OnPrev_Year     = bPrevYear

       ::Show()

RETURN Self

METHOD SetStyle( nStyle ) CLASS GCALENDAR

       if nStyle != NIL
          ::nStyle := nStyle
           gtk_calendar_set_display_options( ::pWidget, ::nStyle )
       endif

Return NIL

METHOD SetDate( dDate ) CLASS GCALENDAR

       if Valtype( dDate ) == "D"
          ::dDate := dDate
          gtk_calendar_select_month( ::pWidget, month( dDate )-1, year( dDate ) )
          gtk_calendar_select_day( ::pWidget,day( dDate ) )
       endif

RETURN NIL

METHOD MarkDay( nDay ) CLASS GCALENDAR
   
   if hb_IsNil(nDay) ; nDay:= DAY( ::GetDate() ) ; endif

   gtk_calendar_mark_day( ::pWidget, nDay )
   if hb_IsBlock( ::bOnMarkDay )
      Eval( ::bOnMarkDay, Self )
   endif
RETURN NIL


METHOD UnMarkDay( nDay ) CLASS GCALENDAR

   if hb_IsNil(nDay) ; nDay:= DAY( ::GetDate() ) ; endif

   gtk_calendar_unmark_day( ::pWidget, nDay )
   if hb_IsBlock( ::bOnUnMarkDay )
      Eval( ::bOnUnMarkDay, Self )
   endif
RETURN NIL


METHOD OnKeyPressEvent( oSender,   pGdkEventKey  ) CLASS GCALENDAR

   local nKey, nState
   local dFirstDayWeek
   local dLastDayWeek
   local dLastDayMonth, dDate
   local nDay, nMonth, nYear

   nKey   = HB_GET_GDKEVENTKEY_KEYVAL( pGdkEventKey )// aGdkEventKey[ 6 ]
   nState = HB_GET_GDKEVENTKEY_STATE( pGdkEventKey )  // aGdkEventKey[ 1 ]

   dDate = ::GetDate()
 
   switch nKey
      case GDK_Delete
         if hb_IsBlock( ::bDelete )
            Eval( ::bDelete, Self )
         endif
         //::UnMarkDay( DAY( dDate ) )
         exit         
      case GDK_LEFT
         dDate--
         exit         
      case GDK_RIGHT
         dDate++
         exit
      case GDK_UP
         dDate -= 7
         exit
      case GDK_DOWN
         dDate += 7
         exit
      case GDK_HOME 
         dFirstDayWeek = ::dDate - DoW( dDate ) + 1 
         dDate = dFirstDayWeek
         exit
      case GDK_END 
         dLastDayWeek = dDate - DoW( dDate ) + 7
         dDate = dLastDayWeek
         exit
      case GDK_Page_Down
         nMonth = Month( dDate )
         nDay   = Day( dDate )
         nYear  = Year( dDate )
         if hb_nAnd( nState, GDK_CONTROL_MASK ) == GDK_CONTROL_MASK
             nYear++
         else      
            if nMonth == 12
               nMonth = 1 
               nYear++
            else 
               nMonth++
            endif 
         endif
         dDate = SToD( StrZero( nYear, 4 ) + StrZero( nMonth, 2 ) + StrZero( nDay, 2 ) ) 
         
         exit
      case GDK_Page_Up
         nMonth = Month( dDate )
         nDay   = Day( dDate )
         nYear  = Year( dDate )
         if hb_nAnd( nState, GDK_CONTROL_MASK ) == GDK_CONTROL_MASK
             nYear-- 
         else
            if nMonth == 1
               nMonth = 12 
               nYear--
            else 
               nMonth--
            endif 
         endif
         dDate = SToD( StrZero( nYear, 4 ) + StrZero( nMonth, 2 ) + StrZero( nDay, 2 ) )
         exit
      case GDK_Return 
      case GDK_KP_Enter
      case GDK_space 
         if hb_IsBlock( ::bDayD )
            Eval( ::bDayD, Self )
         endif         
   end switch
   
   ::SetDate( dDate )

RETURN NIL

METHOD OnDay_Selected( uParam )  CLASS GCALENDAR

   if hb_IsBlock( uParam )
      ::bDaySelected = uParam
      ::Connect( "day-selected" )
   elseif hb_IsObject( uParam )
      if hb_IsBlock( ::bDaySelected )
         Eval( uParam:bDaySelected, uParam )
      endif
   endif    

RETURN .F.

METHOD OnDay_Selected_double_click( uParam ) CLASS GCALENDAR

   if hb_IsBlock( uParam )
      ::bDayD = uParam
      ::Connect( "day-selected-double-click" )
   elseif hb_IsObject( uParam ) 
      if hb_IsBlock( ::bDayD )
         Eval( uParam:bDayD, uParam )
      endif
   endif    

RETURN .F.

METHOD OnMonth_changed( uParam )     CLASS GCALENDAR

   if hb_IsBlock( uParam )
      ::bMonthChanged = uParam
      ::Connect( "month-changed" )
   elseif hb_IsObject( uParam ) 
      if hb_IsBlock( ::bMonthChanged )
         Eval( uParam:bMonthChanged, uParam )
      endif
   endif    

RETURN .F.

METHOD OnNext_Month( uParam )        CLASS GCALENDAR

   if hb_IsBlock( uParam )
      ::bNextMonth = uParam
      ::Connect( "next-month" )
   elseif hb_IsObject( uParam ) 
      if hb_IsBlock( ::bNextMonth )
         Eval( uParam:bNextMonth, uParam )
      endif
   endif    

RETURN .F.

METHOD OnNext_Year( uParam )         CLASS GCALENDAR

   if hb_IsBlock( uParam )
      ::bNextYear = uParam
      ::Connect( "next-year" )
   elseif hb_IsObject( uParam ) 
      if hb_IsBlock( ::bNextYear )
         Eval( uParam:bNextYear, uParam )
      endif
   endif    
   
RETURN .F.

METHOD OnPrev_Month( uParam )        CLASS GCALENDAR

   if hb_IsBlock( uParam )
      ::bPrevMonth = uParam
      ::Connect( "prev-month" )
   elseif hb_IsObject( uParam ) 
      if hb_IsBlock( ::bPrevMonth )
         Eval( uParam:bPrevMonth, uParam )
      endif
   endif    

RETURN .F.

METHOD OnPrev_Year( uParam )         CLASS GCALENDAR

   if hb_IsBlock( uParam )
      ::bPrevYear = uParam
      ::Connect( "prev-year" )
   elseif hb_IsObject( uParam ) 
      if hb_IsBlock( ::bPrevYear )
         Eval( uParam:bPrevYear, uParam )
      endif
   endif    

RETURN .F.



