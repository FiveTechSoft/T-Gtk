/* $Id: gtoolmenu.prg,v 1.1 2006-09-07 17:02:46 xthefull Exp $*/
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

CLASS GTOOLMENU FROM GTOOLBUTTON
      DATA bShowMenu

      METHOD New( cText, bAction, lActive, cStock, lMnemonic, cFromStock, oParent, lExpand, cId, uGlade  )
      METHOD SetMenu( oMenu ) INLINE gtk_menu_tool_button_set_menu( ::pWidget, oMenu:pWidget )
      METHOD SetShowMenu( bShowMenu )
      
      //Signals
      METHOD OnShow_Menu( oSender ) 

ENDCLASS

METHOD New( cText, oImage, oMenu, bAction, cFromStock, oParent, lExpand, cId, uGlade ) CLASS GTOOLMENU
       Local pImage

       DEFAULT lExpand := .F.
       
       if Valtype( oImage ) = "O"
          pImage := oImage:pWidget
       endif

       IF cId == NIL
          IF cFromStock != NIL
             ::pWidget := gtk_menu_tool_button_new_from_stock( cFromStock )
          ELSE
             ::pWidget := gtk_menu_tool_button_new( pImage, cText )
          ENDIF
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

       IF oMenu != NIL 
          ::SetMenu( oMenu )
       ENDIF

       IF bAction != NIL // Si hay una accion , conectamos seal
          ::bAction := bAction
          ::Connect( "clicked" )
       ENDIF

       ::Show()


RETURN Self

// Este method esta pensado para facilitar la tarea de asignar un codeblock a la señal "showmenu"
// y el conectar la señal. Dudo mucho que la gente vaya hacer uso de esto, pero nunca se sabe ;-)
METHOD SetShowMenu( bShowMenu ) CLASS GTOOLMENU
       if Valtype( bShowMenu ) = "B"
          ::bShowMenu := bShowMenu
          ::Connect( "show-menu" )
       endif
RETURN NIL

// Nota
// Se dispara antes de que se despliegue el menu del ToolMenu.
METHOD OnShow_Menu( oSender ) CLASS GTOOLMENU
   
   if oSender:bShowMenu != NIL
      Eval( oSender:bShowMenu, oSender )
   endif
    
RETURN NIL
