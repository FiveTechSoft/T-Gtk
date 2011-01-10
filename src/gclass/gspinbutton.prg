/* $Id: gspinbutton.prg,v 1.2 2007-08-12 10:24:44 xthefull Exp $*/
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


CLASS GSpinbutton FROM GWidget
      DATA bSetGet
      DATA bWhen

      METHOD New( )
      METHOD SetRange( nMin, nMax )
      METHOD Get()
      METHOD Set( ndValue ) INLINE ( Eval( ::bSetGet, ndValue ), gtk_spin_button_set_value( ::pWidget, ndValue ) )
      METHOD SetNumeric( lNumeric ) INLINE gtk_spin_button_set_numeric( ::pWidget, lNumeric )
      
      METHOD SetValue( uValue ) INLINE ::Set( uValue )
      METHOD GetValue( )        INLINE ::Get()

      METHOD OnChanged( oSender )
      METHOD OnFocus_out_event( oSender )
      METHOD OnKeyPressEvent( oSender, pGdkEventKey  )

ENDCLASS

METHOD New( bSetGet, nMin, nMax, nDecimals, nStep, oAdjust, bValid,;
            oParent, lExpand, lFill, nPadding , lContainer,;
            x, y, cId, uGlade, uLabelTab, nWidth, nHeight, lEnd,;
            lSecond, lResize, lShrink, left_ta, right_ta, top_ta, bottom_ta ,;
            xOptions_ta, yOptions_ta) CLASS GSpinButton
       Local pAdjust, nValue
       
       DEFAULT nMin := 0 , nMax := 100, nDecimals := 0, nStep := 1

       ::bSetGet = bSetGet
       nValue :=  Eval( ::bSetGet )
       ::bValid := bValid

       IF cId == NIL
          if Empty( oAdjust )
             pAdjust := gtk_adjustment_new( nMin, nMax, nValue, nStep, 10, 0 )
          else
             pAdjust := oAdjust:pWidget  // De momento no esta la clase Adjust
          endif
          ::pWidget = gtk_spin_button_new( pAdjust, nMin, nDecimals )
          ::SetRange( nMin, nMax )
          ::SetNumeric( .T. ) // Only accept numbers
       ELSE
          ::pWidget := glade_xml_get_widget( uGlade, cId )
          ::CheckGlade( cId )
       ENDIF

       ::Register()

       ::AddChild( oParent, lExpand, lFill, nPadding, lContainer, x, y, uLabelTab,;
                   lEnd, lSecond, lResize, lShrink, left_ta, right_ta, top_ta, bottom_ta ,;
                   xOptions_ta, yOptions_ta)

       if nWidth != NIL
          ::Size( nWidth, nHeight )
       endif
       
       ::Set( nValue  )

       ::Connect( "changed" )
       ::Connect( "focus-in-event")
       ::Connect( "key-press-event" )
       ::Connect_After( "focus-out-event")
       
       ::Show()

RETURN Self

METHOD SetRange( nMin, nMax )   CLASS GSpinButton

       gtk_spin_button_set_range( ::pWidget, nMin, nMax)

RETURN Nil

METHOD Get() CLASS GSPINBUTTON
       Local uResult

       IF gtk_spin_button_get_digits( ::pWidget ) > 0
          uResult := gtk_spin_button_get_value( ::pWidget )
       ELSE
          uResult := gtk_spin_button_get_value_as_int( ::pWidget )
       ENDIF

RETURN uResult

METHOD OnChanged( oSender ) CLASS GSPINBUTTON
       Eval( oSender:bSetGet, oSender:Get() )
RETURN .F.

METHOD OnFocus_Out_Event( oSender ) CLASS GSPINBUTTON

   // actualiza contenido, por si la politica de actualizacion no es always.
   gtk_spin_button_update( oSender:pWidget )
   Eval( oSender:bSetGet, oSender:Get() )

RETURN Super:OnFocus_Out_Event( oSender )

METHOD OnKeyPressEvent( oSender, pGdkEventKey ) CLASS GSPINBUTTON
   local  nKey, nType

   nKey := HB_GET_GDKEVENTKEY_KEYVAL( pGdkEventKey )// aGdkEventKey[ 6 ]
   nType:= HB_GET_GDKEVENTKEY_TYPE( pGdkEventKey )  // aGdkEventKey[ 1 ]

   do case
      case nKey == GDK_Return
           gtk_widget_child_focus( gtk_widget_get_toplevel( oSender:pWidget ) ,GTK_DIR_TAB_FORWARD )
           return .T.
   endcase

Return .F.

