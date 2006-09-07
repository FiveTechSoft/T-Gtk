/* $Id: gtoolradio.prg,v 1.1 2006-09-07 17:02:46 xthefull Exp $*/
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

CLASS GTOOLRADIO FROM GTOOLTOGGLE

      METHOD New( cText, bAction, lActive, cStock, lMnemonic, cFromStock, oParent, lExpand, cId, uGlade  )

ENDCLASS

METHOD New( cText, bAction, lActive, cStock, lMnemonic, cFromStock, oParent, lExpand, oGroup,;
            cId, uGlade ) CLASS GTOOLRADIO

       Local hGroup

       IF cId == NIL
          IF cFromStock != NIL
             ::pWidget := gtk_radio_tool_button_new_from_stock( nil,cFromStock )
          ELSE
             ::pWidget := gtk_radio_tool_button_new( )
             if lMnemonic
                ::Mnemonic( .T. )
             endif
             ::SetLabel( cText )
             if cStock != NIL
                gtk_tool_button_set_stock_id( ::pWidget, cStock )
             endif
          ENDIF

          IF !Empty( oGroup  )  // A que grupo debe de pertenecer
             hGroup := gtk_radio_tool_button_get_group( oGroup:pWidget )
             gtk_radio_tool_button_set_group( ::pWidget , hGroup )
          ENDIF
          ::SetActive( lActive )
       
       ELSE
          ::pWidget := glade_xml_get_widget( uGlade, cId )
          ::CheckGlade( cId )
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
          ::Connect( "toggled" )
       ENDIF

       ::Show()

RETURN Self
