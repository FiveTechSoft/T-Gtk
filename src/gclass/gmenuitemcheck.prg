/* $Id: gmenuitemcheck.prg,v 1.1 2006-09-07 17:02:44 xthefull Exp $*/
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

CLASS GMENUITEMCHECK FROM GMENUITEM

      METHOD New( cTitle, oMenu, bAction, lRoot, lRadio, lActive, lMnemonic, cId, uGlade  )
      METHOD DrawAsRadio( lDraw ) INLINE gtk_check_menu_item_set_draw_as_radio( ::pWidget, lDraw )
      METHOD GetActive() INLINE Gtk_check_menu_item_get_Active( ::pWdiget )
      METHOD SetActive( lActive ) INLINE Gtk_check_menu_item_set_Active( ::pWidget , lActive )

ENDCLASS

METHOD New( cTitle, oMenu, bAction, lRoot, lRadio, lActive, lMnemonic, cId, uGlade ) CLASS GMENUITEMCHECK

       DEFAULT lRoot := .F.
       ::bAction := bAction

       IF cId == NIL
          IF lMnemonic
             ::pWidget := gtk_check_menu_item_new_with_mnemonic( cTitle )
          ELSE
             ::pWidget := gtk_check_menu_item_new_with_label( cTitle )  // Item del menu
          ENDIF
       ELSE
          ::pWidget := glade_xml_get_widget( uGlade, cId )
          ::CheckGlade( cId )
       ENDIF

       ::Register()                                               // Lo registramos

       if oMenu != NIL
          IF lRoot
             oMenu:oMenuRoot := Self
             ::SetMenu( oMenu )
          ELSE
             ::Append( oMenu )                                    // Aado Items al menu
          ENDIF
       endif

       IF lRadio
          ::DrawAsRadio( TRUE )
       ENDIF

       IF lActive
          ::SetActive( TRUE )
       ENDIF

       IF ::bAction != NIL
          ::Connect( "activate" )
       ENDIF

       ::Show()                                             // Y lo muestro

RETURN Self
