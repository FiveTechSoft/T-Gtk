/* $Id: scrolled.prg,v 1.1 2006-09-07 16:28:06 xthefull Exp $*/
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
/* Clase adaptada para gClass.
   Esta clase es usada por DbfGrid
   */
#include "gtkapi.ch"
#include "hbclass.ch"

#define SCROLL_HORIZONTAL 0
#define SCROLL_VERTICAL   1

CLASS TScrolledBar from gWidget

   DATA   hWnd, hVadjust, hHadjust
   DATA   nVvalue, nHvalue
   DATA   nHorLen, nVerLen  
   DATA   bGoDown, bGoUp

   METHOD New( nHorLen, nVerLen )

   METHOD GoTo()
   METHOD GoDown()
   METHOD GoUp()
   METHOD GoRight()
   METHOD GoLeft()
   
   METHOD SetAdjustment( nHorLen, nVerLen )
   METHOD Refresh()

ENDCLASS

METHOD New( nHorLen, nVerLen ) CLASS TScrolledBar

  DEFAULT nHorLen := 1.0
  DEFAULT nVerLen := 1.0

   ::nVvalue  := 1
   ::nHvalue  := 1
   ::nHorLen  := nHorLen
   ::nVerLen  := nVerLen
   ::hWnd     := gtk_scrolled_window_new( ::hHadjust, ::hVadjust )

   ::SetAdjustment( nHorLen, nVerLen )  
   
   gtk_widget_show( ::hWnd )
   
return Self

METHOD GoTo( nPos ) CLASS TScrolledBar

   if ::nVvalue > 0 
      if ::nVvalue <= ::nVerLen
         ::nVvalue := nPos
      else
      	 ::nVvalue := ::nVerLen
      endif 	
   else
      ::nVvalue := 1
   endif
   gtk_adjustment_set_value( ::hVadjust, ::nVvalue )   

return nil

METHOD GoUp() CLASS TScrolledBar

   if ::bGoUp != nil
      Eval( ::bGoUp, Self )
   endif
   if ::nVvalue > 1
      ::nVvalue -= 1
      gtk_adjustment_set_value( ::hVadjust, ::nVvalue )
   endif
     
return nil

METHOD GoDown() CLASS TScrolledBar

   if ::bGoDown != nil
      Eval( ::bGoDown, Self )
   endif
   if ::nVvalue > 0 .and. ::nVvalue < ::nVerLen
      ::nVvalue += 1
      gtk_adjustment_set_value( ::hVadjust, ::nVvalue )
   endif
   
return nil

METHOD GoRight() CLASS TScrolledBar

   if ::bGoDown != nil
      Eval( ::bGoRight, Self )
   endif
   if ::nHvalue > 0 .and. ::nHvalue < ::nHorLen
      ::nHvalue += 1
      gtk_adjustment_set_value( ::hHadjust, ::nHvalue )
   endif
   
return nil

METHOD GoLeft() CLASS TScrolledBar

   if ::bGoUp != nil
      Eval( ::bGoLeft, Self )
   endif
   if ::nHvalue > 0
      ::nHvalue -= 1
      gtk_adjustment_set_value( ::hHadjust, ::nHvalue )
   endif
   
return nil

METHOD SetAdjustment( nHorLen, nVerLen ) CLASS TScrolledBar
  
  local nLower := 1.0
  local nStep_increment := 1.0
  local nPage_increment := 20.0
  local nPage_size      := 0.0
  
   ::nHorLen  := nHorLen
   ::nVerLen  := nVerLen

   ::hHadjust := gtk_adjustment_new( ::nHvalue, nLower, ::nHorLen, nStep_increment,;
                                     nPage_increment, nPage_size )
   ::hVadjust := gtk_adjustment_new( ::nVvalue, nLower, ::nVerLen, nStep_increment,;
                                     nPage_increment, nPage_size )

   gtk_scrolled_window_set_hadjustment( ::hWnd, ::hHadjust )
   gtk_scrolled_window_set_vadjustment( ::hWnd, ::hVadjust )
 
return nil

METHOD Refresh() CLASS TScrolledBar
   
   ::nVvalue := gtk_adjustment_get_value( ::hVadjust )
   ::nHvalue := gtk_adjustment_get_value( ::hHadjust )

return nil   
