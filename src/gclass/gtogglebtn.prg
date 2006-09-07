/* $Id: gtogglebtn.prg,v 1.1 2006-09-07 17:02:45 xthefull Exp $*/
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

CLASS GTOGGLEBUTTON FROM GBUTTON

      METHOD New( )
      METHOD GetActive() INLINE gtk_toggle_button_get_active( ::pWidget )
      METHOD SetState( lState ) INLINE gtk_toggle_button_set_state( ::pWidget, lState )
     
      METHOD SetValue( uValue ) INLINE ::SetState( uValue )
      METHOD GetValue( )        INLINE ::GetActive()

      //Signals
      METHOD OnToggled( oSender )
        
ENDCLASS

METHOD New( cText, bAction, bValid, oFont, lMnemonic, oParent, lExpand,;
            lFill, nPadding , lContainer, x, y, cId, uGlade, nCursor, uLabelTab,;
            nWidth, nHeight, oBar, cMsgBar, lEnd, lSecond, lResize, lShrink,;
            left_ta,right_ta,top_ta,bottom_ta, xOptions_ta, yOptions_ta ) CLASS GTOGGLEBUTTON

       IF cId == NIL
          if lMnemonic
            ::pWidget := gtk_toggle_button_new_with_mnemonic( cText )
          else
            ::pWidget := gtk_toggle_button_new_with_label( cText )
          endif
        ELSE
          ::pWidget := glade_xml_get_widget( uGlade, cId )
          ::CheckGlade( cId )
       ENDIF

       ::Register()

       ::AddChild( oParent, lExpand, lFill, nPadding, lContainer, x, y, uLabelTab,;
                   lEnd, lSecond, lResize, lShrink, left_ta, right_ta, top_ta, bottom_ta,;
                   xOptions_ta, yOptions_ta )

       IF bAction != NIL // Si hay una accion , conectamos seal
          ::bAction := bAction
          ::Connect( "toggled" )
       ENDIF

       if bValid != NIL
          ::bValid := bValid
          ::Connect( "focus-out-event")
       endif

       if nCursor != NIL
          ::ActivateCursor( nCursor )
       endif

       if oFont != NIL
          ::SetFont( oFont )
       endif

       if nWidth != NIL
          ::Size( nWidth, nHeight )
       endif

       if oBar != NIL .AND. cMsgBar != NIL
         ::SetMsg( cMsgBar, oBar )
       endif

       ::Show()

RETURN Self

******************************************************************************
METHOD OnToggled( oSender ) CLASS GTOGGLEBUTTON
    Eval( oSender:bAction, oSender )
RETURN .F.

