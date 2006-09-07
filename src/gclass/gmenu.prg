/* $Id: gmenu.prg,v 1.1 2006-09-07 17:02:44 xthefull Exp $*/
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

CLASS GMENU FROM GMENUSHELL
      DATA oBarmenu
      DATA oMenuRoot

      METHOD New( oBarMenu )
      METHOD SetMenu( oMenuItem ) INLINE  gtk_menu_item_set_submenu( oMenuItem:pWidget, ::pWidget )
      METHOD Activate()

ENDCLASS

// oBarMenu, de que barra de menu sera este menu o si sera de un MenuItem( SubMenus )
METHOD NEW( oBarMenu, oMenuItem, cId, uGlade ) CLASS GMENU

    ::oBarMenu := oBarMenu
    
    IF cId == NIL
       ::pWidget := gtk_menu_new() // No es necesario mostrar por ser un contenedor
    ELSE
       ::pWidget := glade_xml_get_widget( uGlade, cId )
       ::CheckGlade( cId )
    ENDIF

    ::Register()

    IF oMenuItem != NIL // Asignamos a un MenuItem
       ::SetMenu( oMenuItem )
    ENDIF

Return Self

// oMenuRoot es asignado a traves de la creacion de un MenuItem.( cuando es root )
METHOD Activate( ) CLASS GMENU

       gtk_menu_shell_append( ::oBarMenu:pWidget , ::oMenuRoot:pWidget )

RETURN NIL
