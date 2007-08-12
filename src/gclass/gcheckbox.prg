/* $Id: gcheckbox.prg,v 1.2 2007-08-12 10:24:44 xthefull Exp $*/
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

CLASS GCHECKBOX FROM GTOGGLEBUTTON
      DATA bSetGet

      METHOD New( )
      METHOD OnClicked( oSender )
      METHOD OnKeyPressEvent( oSender, pGdkEventKey ) 

ENDCLASS

METHOD New( cText, bSetGet, bValid, oFont, lMnemonic, oParent, lExpand,;
            lFill, nPadding , lContainer, x, y, cId, uGlade, nCursor, uLabelTab,;
            lEnd, lSecond, lResize, lShrink, left_ta,right_ta,top_ta,bottom_ta , xOptions_ta, yOptions_ta ) CLASS GCHECKBOX

       ::bSetGet   = bSetGet

       IF cId == NIL
          if lMnemonic
             ::pWidget := gtk_check_button_new_with_mnemonic( cText )
          else
             ::pWidget := gtk_check_button_new_with_label( cText )
          endif
        ELSE
           ::pWidget := glade_xml_get_widget( uGlade, cId )
           ::CheckGlade( cId )
        ENDIF

       ::Register()

       ::AddChild( oParent, lExpand, lFill, nPadding, lContainer, x, y, uLabelTab,;
                   lEnd , lSecond, lResize, lShrink, left_ta,right_ta,top_ta,bottom_ta,;
                   xOptions_ta, yOptions_ta )

       ::Connect( "clicked" )

       if ::bSetGet != nil
          ::SetState( Eval( bSetGet ) )
       endif

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

       ::Connect( "key-press-event" )
       ::Show()

RETURN Self

METHOD OnClicked( oSender ) CLASS GCHECKBOX
       if oSender:bSetGet != nil
          Eval( oSender:bSetGet, oSender:GetActive() )
       endif
RETURN .F.

METHOD OnKeyPressEvent( oSender, pGdkEventKey ) CLASS GCHECKBOX

   local  nKey, nType

   nKey := HB_GET_GDKEVENTKEY_KEYVAL( pGdkEventKey )// aGdkEventKey[ 6 ]
   nType:= HB_GET_GDKEVENTKEY_TYPE( pGdkEventKey )  // aGdkEventKey[ 1 ]

   do case
      case nKey == GDK_Return
           gtk_widget_child_focus( gtk_widget_get_toplevel( oSender:pWidget ) ,GTK_DIR_TAB_FORWARD )
           return .T.
   endcase

Return .F.
