/* $Id: gbutton.prg,v 1.1 2006-09-07 17:07:55 xthefull Exp $*/
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

#define STYLE_COLOR     1
#define STYLE_COMPONENT 2
#define STYLE_STATE     3

CLASS GBUTTON FROM GBIN

      METHOD New( )
      METHOD SetLabel( cText ) INLINE gtk_button_set_label( ::pWidget, cText )
      METHOD SetText( cText )  INLINE gtk_button_set_label( ::pWidget, cText )
      METHOD GetLabel( )       INLINE gtk_button_get_label( ::pWidget )
      METHOD SetFont( oFont )  INLINE ::oFont := oFont, gtk_widget_modify_font( gtk_bin_get_child( ::pWidget ) , oFont:pFont )
      METHOD StyleChild( cColor, iComponent, iState ) INLINE  __GSTYLE( cColor, gtk_bin_get_child( ::pWidget ), iComponent , iState )
      
      //Signals
      METHOD OnClicked( oSender )

ENDCLASS

METHOD New( cText, bAction, bValid, oFont, lMnemonic, cFromStock, oParent, lExpand,;
            lFill, nPadding , lContainer, x, y, cId, uGlade, nCursor,;
            uLabelTab, nWidth, nHeight, oBar, cMsgBar, lEnd, lSecond, lResize, lShrink,;
            left_ta,right_ta,top_ta,bottom_ta, xOptions_ta, yOptions_ta, aStyles, aStylesChild ) CLASS GBUTTON

       IF cId == NIL
          IF cFromStock != NIL
             ::pWidget := gtk_button_new_from_stock( cFromStock )
          ELSE
             if lMnemonic
                ::pWidget := Gtk_button_new_with_mnemonic( cText )
             else
                if cText != NIL
                   ::pWidget := Gtk_button_new_with_label( cText )
                else
                   ::pWidget := Gtk_button_new()
                endif
             endif
          ENDIF
       ELSE
          ::pWidget := glade_xml_get_widget( uGlade, cId )
          ::CheckGlade( cId )
       ENDIF

       // La aplicacion del style es ANTES de aadir al padre
       // Lo dejamos como recordatorio
       if Valtype( aStyles  ) = "A"
          FOR X := 1 TO Len( aStyles )
             ::Style( aStyles[X,STYLE_COLOR], aStyles[ X,STYLE_COMPONENT ], aStyles[ X,STYLE_STATE ] )
          NEXT
       endif
       
       ::Register()

       ::AddChild( oParent, lExpand, lFill, nPadding, lContainer, x, y,;
                   uLabelTab, lEnd, lSecond, lResize, lShrink,;
                   left_ta,right_ta,top_ta,bottom_ta, xOptions_ta, yOptions_ta  )

       IF bAction != NIL // Si hay una accion , conectamos seal
          ::bAction := bAction
          ::Connect( "clicked" )
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
 /*Nota:
  La aplicacion de StyleChild debe ser posterior a la puesta en su contenedor
  por el tema de la font
 */
       if Valtype( aStylesChild  ) = "A"
          FOR X := 1 TO Len( aStylesChild )
             ::StyleChild( aStylesChild[X,STYLE_COLOR], aStylesChild[ X,STYLE_COMPONENT ], aStylesChild[ X,STYLE_STATE ] )
          NEXT
       endif

       ::Show()

RETURN Self

******************************************************************************
METHOD OnClicked( oSender ) CLASS GBUTTON
    Eval( oSender:bAction, oSender )
RETURN .F.
