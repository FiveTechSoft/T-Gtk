/* $Id: gcombobox.prg,v 1.1 2006-09-07 17:07:55 xthefull Exp $*/
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

CLASS GCOMBOBOX FROM GBIN
      DATA aItems
      DATA bSetGet
      DATA oRenderer, oModel

      METHOD New( )
      METHOD SetItems( aItems )
      METHOD GetText()
      METHOD Insert( nPos,cText ) INLINE gtk_combo_box_insert_text ( ::pWidget, nPos-1, cText )
      METHOD RemoveItem( nItem )
      METHOD RemoveAll( )
      METHOD SetActive( nItem ) INLINE gtk_combo_box_set_active(::pWidget, nItem -1 )
      METHOD SetFont( oFont )  INLINE ::oFont := oFont, gtk_widget_modify_font( gtk_bin_get_child( ::pWidget ) , oFont:pFont )
      METHOD SelectItem( cItem )

      METHOD GetActive() INLINE  ( gtk_combo_box_get_active( ::pWidget ) + 1 )
      METHOD GetPos()    INLINE  ( gtk_combo_box_get_active( ::pWidget ) + 1 )

      METHOD OnChanged( oSender )
      
      METHOD SetValue( cItem ) INLINE ::SelectItem( cItem )
      METHOD GetValue( )       INLINE cValtoChar( ::GetText() )

ENDCLASS

METHOD New( bSetGet, aItems, bChange, oModel, oFont, oParent, lExpand, lFill, nPadding, lContainer, x, y,;
            cId, uGlade, uLabelTab, nWidth, nHeight, lEnd, lSecond, lResize, lShrink,;
            left_ta,right_ta,top_ta,bottom_ta, xOptions_ta, yOptions_ta ) CLASS GCOMBOBOX
       Local aIter 

       ::bSetGet := bSetGet
       ::oModel  := oModel

       IF cId == NIL
          if oModel == NIL
             ::pWidget = gtk_combo_box_new_text( )
          else
             // TODO: De momento, solamente se admite un modelo de una columna simple, no compuesta. 
             ::pWidget = gtk_combo_box_new_with_model( oModel:pWidget )
          endif  
       ELSE
          // Atentos, para que podamos usar correctamente, de momento,
          // los combobox simples, hay que meterse dentro de items y
          // no dar ningun valor, pero si buscais dentro del .glade
          // debeis de tener esto definido...si no no introducira
          // los elementos
          // Quizas se debe a un bug de glade....
          // <property name="items" translatable="yes"></property>
          ::pWidget := glade_xml_get_widget( uGlade, cId )
          ::CheckGlade( cId )
          //TODO: Seria interesante recuperar los valores metidos desde Glade
          // y asociarlos al array aItems , si estuviese vacio.
          // o Borrar los definidos en Glade si le hemos pasado elementos.
       ENDIF

       ::Register()
       ::AddChild( oParent, lExpand, lFill, nPadding, lContainer, x, y, uLabelTab,;
                   lEnd, lSecond, lResize, lShrink, left_ta, right_ta, top_ta, bottom_ta,;
                   xOptions_ta, yOptions_ta  )

       if oFont != NIL
          ::SetFont( oFont )
       endif

       if oModel == NIL 
          ::SetItems( aItems )
       else
         ::oRenderer := gCellRendererText():New()
         gtk_cell_layout_pack_start( ::pWidget , ::oRenderer:pWidget, .T. )
         gtk_cell_layout_add_attribute( ::pWidget , ::oRenderer:pWidget, "text", 0 )
         // Nos posicionamos en la primera opcion del modelo de datos.
         aIter := Array( 4 )
         gtk_tree_model_get_iter_first( oModel:pWidget, aIter )
         gtk_combo_box_set_active_iter( ::pWidget, aIter )
         // Asignamos a la variable pasada, el valor inicial.
         Eval( ::bSetGet, ::GetText() )
       endif

       if nWidth != NIL
          ::Size( nWidth, nHeight )
       endif

       ::bChange := bChange

       ::Connect( "changed" )
       ::Show()

RETURN Self

METHOD SetItems( aItems ) CLASS GCOMBOBOX
       Local X
       Local uActive := 1
       Local uText

       if Eval( ::bSetGet ) == nil  .AND. !Empty( aItems )
          Eval( ::bSetGet, aItems[ 1 ] )
       else
          uText :=  Eval( ::bSetGet )
       endif

       if !Empty( aItems )
          ::aItems := aItems
          for x := 1 to Len( aItems )
             gtk_combo_box_append_text ( ::pWidget, cValtoChar( aItems[x] ) )
          next
       endif

       if uText != NIL
          uActive := Ascan( aItems, uText )
          if uActive = 0
             uActive := 1
          endif
       endif

       ::SetActive( uActive )

RETURN NIL

METHOD GetText() CLASS GCOMBOBOX
       Local nPos, aIter
       Local uResult := ""

       if ::oRenderer = NIL // Si no se base en un modelo de datos
          nPos := gtk_combo_box_get_active( ::pWidget )
          if nPos >= 0
             uResult := ::aItems[ nPos + 1]
          endif
       else
          aIter := Array( 4 )
          if ( gtk_combo_box_get_active_iter( ::pWidget, aIter ) )
             HB_GTK_TREE_MODEL_GET_STRING(  ::oModel:pWidget, aIter, 0, @uResult )
          endif
       endif
       

RETURN uResult

METHOD RemoveItem( nItem ) CLASS GCOMBOBOX

       Adel( ::aItems, nItem )
       ASIZE( ::aItems, ( Len( ::aItems ) - 1) )
       gtk_combo_box_remove_text( ::pWidget, nItem - 1 )

RETURN Nil

/*
 Selecionamos un Item en concreto teniendo en cuanta
 si existe en nuestro ::aItems
*/
METHOD SelectItem( cItem ) CLASS GCOMBOBOX
       Local uActive := 0, x
       Local nLen := Len( ::aItems )

       for x := 1 to nLen
           if cItem == ::aItems[ x ]
              uActive := x
              exit
           endif
       next

       if uActive > 0 // Se encontro
         ::SetActive( uActive )
       endif

RETURN NIL

METHOD RemoveAll( ) CLASS GCOMBOBOX
    Local x
    Local nLen := Len( ::aItems ) 
    
    if ::oModel = NIL
       ::aItems := NIL
       FOR x := 1 To nLen 
           gtk_combo_box_remove_text( ::pWidget, 0 )
       NEXT
    else
        ::oModel:Clear()
    endif

RETURN Nil


METHOD OnChanged( oSender ) CLASS GCOMBOBOX

    Eval( oSender:bSetGet, oSender:GetText() )

    if oSender:bChange != NIL
       Eval( oSender:bChange, oSender )
    endif

RETURN .F.
