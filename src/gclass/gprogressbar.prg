/* $Id: gprogressbar.prg,v 1.1 2006-09-07 17:02:45 xthefull Exp $*/
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

CLASS GProgressBar FROM GWidget
      DATA nTotal
      DATA bSetGet

      METHOD New( )
      METHOD Set( nValue )
      METHOD SetTotal( nTotal ) INLINE ::nTotal := nTotal,;
                                    ::Set( Eval( ::bSetGet ) )
      METHOD SetText( cText ) INLINE gtk_progress_bar_set_text( ::pWidget, cText )
      METHOD SetOrientation( nOrientation ) INLINE ;
             gtk_progress_bar_set_orientation( ::pWidget, nOrientation )

      METHOD Inc( nValue )
      METHOD Dec( nValue )
      
      METHOD SetValue( nValue ) INLINE ::Set( nValue )

ENDCLASS

METHOD New( cText, bSetGet, nTotal, nOrientation, oParent, lExpand,;
            lFill, nPadding , lContainer, x, y, cId, uGlade, nCursor,;
            uLabelTab, nWidth, nHeight, lEnd, lSecond, lResize, lShrink,;
            left_ta, right_ta, top_ta, bottom_ta, xOptions_ta, yOptions_ta  ) CLASS GProgressBar

       DEFAULT cText := "", nTotal := 1
       ::bSetGet = bSetGet
       ::nTotal  = nTotal

       IF cId == NIL
          ::pWidget = gtk_progress_bar_new()
       ELSE
          ::pWidget := glade_xml_get_widget( uGlade, cId )
          ::CheckGlade( cId )
       ENDIF

       ::Register()

       ::AddChild( oParent, lExpand, lFill, nPadding, lContainer, x, y, uLabelTab, lEnd,;
                   lSecond, lResize, lShrink, left_ta, right_ta, top_ta, bottom_ta,;
                   xOptions_ta, yOptions_ta  )

       if nWidth != NIL
          ::Size( nWidth, nHeight )
       endif

       If nOrientation != NIL
          ::SetOrientation( nOrientation )
       endif


       ::Set( Eval( bSetGet ) )
       ::SetText( cText )
       ::Show()

RETURN Self

METHOD Set( nValue ) CLASS GPROGRESSBAR

       gtk_progress_bar_set_fraction( ::pWidget,  nValue / ::nTotal )

RETURN NIL

METHOD Inc( nValue ) CLASS GPROGRESSBAR
       Local uValue :=  Eval( ::bSetGet )
       Local nSumaTotal := 0

       DEFAULT nValue := 1

       nSumaTotal := Eval( ::bSetGet, ( nValue + uValue ) )

       if nSumaTotal <= ::nTotal
          ::Set( nSumaTotal )
       else
          Eval( ::bSetGet, ::nTotal )
          ::Set( ::nTotal )
       endif

RETURN NIL

METHOD Dec( nValue ) CLASS GPROGRESSBAR
       Local uValue :=  Eval( ::bSetGet )
       Local nRestTotal := 0

       DEFAULT nValue := 1

       nRestTotal := Eval( ::bSetGet, ( uValue - nValue ) )

       if nRestTotal >= 0
          ::Set( nRestTotal )
       else
          Eval( ::bSetGet, 0 )
          ::Set( 0 )
       endif

RETURN NIL
