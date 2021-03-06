/* $Id: gradiobutton.prg,v 1.4 2010-12-24 01:06:17 dgarciagil Exp $*/
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

CLASS GRadioButton FROM GCheckBox
      DATA pGroup

      METHOD New()
      //Signals
      METHOD OnToggled( oSender )

ENDCLASS

METHOD New( cText, lActived, oRadio, bAction, oFont, lMnemonic, oParent,;
            lExpand, lFill, nPadding, lContainer, x, y, cId, uGlade,;
            nCursor, uLabelTab, nWidth, nHeight, oBar, cMsgBar, lEnd, lSecond, lResize, lShrink,;
            left_ta, right_ta, top_ta, bottom_ta, xOptions_ta, yOptions_ta ) CLASS GRadioButton

       IF cId == NIL
          if oRadio:Classname() == "GRADIOBUTTON"
             if !Empty( oRadio:pGroup )
                ::pGroup := gtk_radio_button_get_group( oRadio:pWidget )
             endif
          endif
          if lMnemonic
             ::pWidget := gtk_radio_button_new_with_mnemonic(::pGroup, cText)
          else
             ::pWidget = gtk_radio_button_new_with_label( ::pGroup, cText)
          endif
          ::pGroup := gtk_radio_button_get_group( ::pWidget )
       ELSE
          ::pWidget := glade_xml_get_widget( uGlade, cId )
          ::CheckGlade( cId )
       ENDIF

       ::Register()

       ::AddChild( oParent, lExpand, lFill, nPadding, lContainer, x, y, uLabelTab,;
                   lEnd, lSecond, lResize, lShrink, left_ta, right_ta, top_ta, bottom_ta,;
                   xOptions_ta, yOptions_ta )

       if nWidth != NIL
          ::Size( nWidth, nHeight )
       endif

       if lActived
          ::SetState( .T. )
       endif

       if nCursor != NIL
          ::ActivateCursor( nCursor )
       endif

       if oFont != NIL
          ::SetFont( oFont )
       endif

       if oBar != NIL .AND. cMsgBar != NIL
         ::SetMsg( cMsgBar, oBar )
       endif

       /* Note : source-> /share/gtk-doc/html/gtk/GtkRadioButton.html
          When an unselected button in the group is clicked the clicked button receives the "toggled" signal, 
          as does the previously selected button. Inside the "toggled" handler, gtk_toggle_button_get_active() 
          can be used to determine if the button has been selected or deselected.
       */
       if bAction != NIL
         ::bAction := bAction
         ::Connect( "toggled" )
       endif

       ::Show()

RETURN Self

******************************************************************************
METHOD OnToggled( oSender ) CLASS GRadioButton

    if oSender:bAction != NIL
       if oSender:GetActive()  // Se dispara SOLO el que se activa. 
          Eval( oSender:bAction, oSender )
       endif
    endif

RETURN .F.

