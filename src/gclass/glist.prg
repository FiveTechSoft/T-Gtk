/* $Id: glist.prg,v 1.1 2006-09-07 17:02:44 xthefull Exp $*/
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
    
    * Protipico de Clase GList
    Esta clase no aconseja no usarse, porque a sido dejada
    de usarse a partir de la version 2.4 de GTK+
    He creido conveniente portarla, porque todavia hay milllones
    de sistemas corriendo bajo GTK 2.0.

    Atentos, el array pasado puede contener lo que sea, y sera
    devuelto tal y como se pasa, cogiendo la variable el tipo que sea.
    Internamente, la clase glist manera datos tipo cadena, pero nosotros
    solamente cogeremos en que posicion estamos, y eso es lo que devolveremos,
     la posicion dentro de nuestro array de Harbour, no el valor contenido
     dentro de gtk_list_new()
*/
#include "gtkapi.ch"
#include "hbclass.ch"

CLASS GLIST FROM GWIDGET
      DATA bSetGet
      DATA aItems

      METHOD New( )
      METHOD SetItems( aItems )
      METHOD AddItem( cItem )
      METHOD SetMode( nMode )  INLINE  gtk_list_set_selection_mode( ::pWidget, nMode )
      METHOD Remove()

      METHOD OnSelect_Child( oSender, pChild )
      METHOD OnSelection_changed( oSender )
ENDCLASS

METHOD New( bSetGet, aItems, bChange, oFont, oParent, lExpand, lFill, nPadding, lContainer, x, y,;
            cId, uGlade, uLabelTab, nWidth, nHeight, lEnd, lSecond, lResize, lShrink,;
            left_ta, right_ta, top_ta, bottom_ta, xOptions_ta, yOptions_ta ) CLASS GLIST
        Local nPos := 0

       ::bSetGet := bSetGet
       ::bChange := bChange

       IF cId == NIL
          ::pWidget = gtk_list_new( )
       ELSE
          ::pWidget := glade_xml_get_widget( uGlade, cId )
          ::CheckGlade( cId )
       ENDIF

       ::Register()

       ::AddChild( oParent, lExpand, lFill, nPadding, lContainer, x, y, uLabelTab, lEnd,;
                   lSecond, lResize, lShrink, left_ta, right_ta, top_ta, bottom_ta,;
                   xOptions_ta, yOptions_ta  )

       if oFont != NIL
          ::SetFont( oFont )
       endif

       ::SetMode( GTK_SELECTION_BROWSE )
       ::SetItems( aItems )

       nPos :=  AScan( aItems, Eval( bSetGet ) )
       if nPos > 0
          gtk_list_select_item( ::pWidget, nPos - 1 )
       endif

       if nWidth != NIL
          ::Size( nWidth, nHeight )
       endif

//       ::Connect( "selection-changed" )
       ::Connect( "select-child" )
       ::Show()

RETURN Self

METHOD SetItems( aItems ) CLASS GLIST
       Local X

       IF !Empty( aItems )
          ::aItems := aItems
          FOR x := 1 to Len( aItems )
              ::AddItem( cValToChar( aItems[ x ] ) )
          NEXT
       ENDIF

RETURN NIL

METHOD AddItem( cItem ) CLASS GLIST
       Local pItem

       pItem := gtk_list_item_new_with_label( cItem )
       gtk_container_add( ::pWidget, pItem )
       gtk_widget_show( pItem )

RETURN NIL

METHOD OnSelect_Child( oSender, pChild ) CLASS GLIST
       local nPos :=  GTK_LIST_CHILD_POSITION ( oSender:pWidget, pChild )

       if nPos >= 0
          nPos++
          Eval( oSender:bSetGet, oSender:aItems[ nPos ] )
          ::OnSelection_changed( Self )
       endif

RETURN .F.

METHOD OnSelection_changed( oSender ) CLASS GLIST
       // Evaluamos Codeblock bChange cuando cambiamos de elemento
       if oSender:bChange != NIL
          Eval( oSender:bChange, oSender )
       endif
RETURN .F.

METHOD Remove( ) CLASS GLIST
       gtk_list_clear_items( ::pWidget, 0, -1 )
       ::aItems := NIL
RETURN NIL
