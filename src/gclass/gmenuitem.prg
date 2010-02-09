/* $Id: gmenuitem.prg,v 1.2 2010-02-09 04:22:04 riztan Exp $*/
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

CLASS GMENUITEM FROM GBIN

      METHOD New( cTitle, oMenu, bAction, lRoot, lMnemonic, cId, uGlade)
      METHOD Append( oMenu ) INLINE gtk_menu_append( oMenu:pWidget, ::pWidget )
      METHOD SetMenu( oMenuItem ) INLINE  gtk_menu_item_set_submenu( ::pWidget, oMenuItem:pWidget )
      METHOD SetFont( oFont )  INLINE ::oFont := oFont, gtk_widget_modify_font( gtk_bin_get_child( ::pWidget ) , oFont:pFont )
      METHOD SetTitle( oMenuItem, cTitle ) INLINE gtk_menu_item_set_label( oMenuItem, cTitle )

ENDCLASS

METHOD New( cTitle, oMenu, bAction, lRoot, lMnemonic, cId, uGlade ) CLASS GMENUITEM

       DEFAULT lRoot := .F.
       ::bAction := bAction

       IF cId == NIL
           IF lMnemonic
              ::pWidget := gtk_menu_item_new_with_mnemonic( cTitle )
           ELSE
              ::pWidget := gtk_menu_item_new_with_label( cTitle )  // Item del menu
           ENDIF
       ELSE
          ::pWidget := glade_xml_get_widget( uGlade, cId )
          ::CheckGlade( cId )
       ENDIF

       ::Register()                                         // Lo registramos

       if oMenu != NIL
          IF lRoot
             oMenu:oMenuRoot := Self
             ::SetMenu( oMenu )
          ELSE
             ::Append( oMenu )                                    // Aado Items al menu
          ENDIF
       endif

       IF ::bAction != NIL
          ::Connect( "activate" ) // Salta a la opcion 2
       ENDIF

       ::Show()                                             // Y lo muestro

RETURN Self
