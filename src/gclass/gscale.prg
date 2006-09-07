/* $Id: gscale.prg,v 1.1 2006-09-07 17:02:45 xthefull Exp $*/
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

CLASS GScaleVH FROM GRange
      DATA bSetGet

      METHOD New( )
      METHOD SetDigits( nDigits ) INLINE gtk_scale_set_digits( ::pWidget, nDigits )
      METHOD SetDraw( lDraw )     INLINE gtk_scale_set_draw_value( ::pWidget, lDraw )
      METHOD SetPos( nTypePos )   INLINE gtk_scale_set_value_pos( ::pWidget, nTypePos )
      METHOD GetDigits( )         INLINE gtk_scale_get_digits( ::pWidget )
      METHOD GetDraw()            INLINE gtk_scale_get_draw_value( ::pWidget )
      METHOD GetPos()             INLINE gtk_scale_get_value_pos( ::pWidget )

      METHOD OnValue_Changed( oSender )

ENDCLASS

METHOD New( bSetGet, lVertical, nMin, nMax, nDecimals, nStep, oAdjust,;
            oParent, lExpand, lFill, nPadding , lContainer,;
            x, y, cId, uGlade, uLabelTab, nWidth, nHeight, lEnd,;
            lSecond, lResize, lShrink, left_ta, right_ta, top_ta, bottom_ta, xOptions_ta, yOptions_ta ) CLASS GScaleVH
       Local nValue

       DEFAULT nMin := 0 , nMax := 100, nDecimals := 0, nStep := 1

       ::bSetGet = bSetGet
       nValue :=  Eval( ::bSetGet )

       IF cId == NIL
          if !Empty( oAdjust )
              if lVertical
                 ::pWidget := gtk_vscale_new( oAdjust:pWidget )
              else
                 ::pWidget := gtk_hscale_new( oAdjust:pWidget )
              endif
          else
              if lVertical
                 ::pWidget := gtk_vscale_new_with_range( nMin, nMax, nStep )
              else
                 ::pWidget := gtk_hscale_new_with_range( nMin, nMax, nStep )
              endif
          endif
       ELSE
          ::pWidget := glade_xml_get_widget( uGlade, cId )
          ::CheckGlade( cId )
       ENDIF

       ::Register()

       ::AddChild( oParent, lExpand, lFill, nPadding, lContainer, x, y, uLabelTab, lEnd,;
                   lSecond, lResize, lShrink, left_ta, right_ta, top_ta, bottom_ta ,;
                   xOptions_ta, yOptions_ta)

       if nWidth != NIL
          ::Size( nWidth, nHeight )
       endif

       if nDecimals > 0
          ::SetDigits( nDecimals )
       endif

       ::SetRange( nMin, nMax )
       ::Set( nValue  )

       ::Connect( "value-changed" )

       ::Show()

RETURN Self

METHOD OnValue_Changed( oSender ) CLASS GSCALEVH
       Eval( oSender:bSetGet, oSender:Get() )
RETURN .F.
