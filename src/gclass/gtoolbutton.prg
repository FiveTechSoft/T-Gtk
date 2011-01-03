/* $Id: gtoolbutton.prg,v 1.2 2010-12-28 18:52:20 dgarciagil Exp $*/
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

CLASS GTOOLBUTTON FROM GTOOLITEM

      METHOD New( cText, bAction, cStock, lMnemonic, cFromStock, oParent, lExpand, cId, uGlade  )
      METHOD SetLabel( cText ) INLINE gtk_tool_button_set_label( ::pWidget, cText )
      METHOD GetLabel()        INLINE gtk_tool_button_get_label( ::pWidget )
      METHOD Mnemonic( lUsed ) INLINE gtk_tool_button_set_use_underline( ::pWidget, lUsed )
      METHOD IsMnemonic()      INLINE gtk_tool_button_get_use_underline( ::pWidget )
      METHOD SetStock( uID )   INLINE gtk_tool_button_set_stock_id( ::pWidget, uID )
      METHOD GetStock()        INLINE gtk_tool_button_get_stock_id( ::pWidget )
      METHOD SetIcon( oIcon )  INLINE gtk_tool_button_set_icon_widget( oIcon:pWidget )
      METHOD GetIcon( )        INLINE gtk_tool_button_get_icon_widget( ::pWidget )
      METHOD SetExpand( lExpand ) INLINE gtk_tool_item_set_expand ( ::pWidget , lExpand )
      METHOD SetSytle() VIRTUAL
      
      //Signals
      METHOD OnClicked( oSender )

ENDCLASS

METHOD New( cText, bAction, cStock, lMnemonic, cFromStock, oParent, lExpand,;
            cId, uGlade ) CLASS GTOOLBUTTON

       DEFAULT lExpand := .F.,;
               lMnemonic := .F.


       IF cId == NIL
          IF cFromStock != NIL
             ::pWidget := gtk_tool_button_new_from_stock( cFromStock )
          ELSE
             ::pWidget := gtk_tool_button_new()
             if lMnemonic
                ::Mnemonic( .T. )
             endif
             ::SetLabel( cText )
             if cStock != NIL
                gtk_tool_button_set_stock_id( ::pWidget, cStock )
             endif
          ENDIF
        ELSE
          ::pWidget := glade_xml_get_widget( uGlade, cId )
          ::CheckGlade( cId )
          ::Mnemonic( lMnemonic )
          if cText != NIL
             ::SetLabel( cText )
          endif
        ENDIF

       ::Register()

       IF oParent != NIL
           gtk_toolbar_insert( oParent:pWidget, ::pWidget, -1 )    // Si ponemos 0 es PRE
           if lExpand
              ::SetExpand( .T. )
           endif
       ENDIF

       IF bAction != NIL // Si hay una accion , conectamos seal
          ::bAction := bAction
          ::Connect( "clicked" )
       ENDIF

       ::Show()

RETURN Self

******************************************************************************
METHOD OnClicked( oSender ) CLASS GTOOLBUTTON
    Eval( oSender:bAction, oSender )
RETURN .F.
