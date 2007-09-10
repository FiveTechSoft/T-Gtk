#include "gtkapi.ch"
#include "hbclass.ch"
/*************************************************************
  $Id: gcomboboxentry.prg,v 1.2 2007-09-10 19:16:26 xthefull Exp $
  Protipico de Clase GComboBoxEntry
 (c)2004 Rafa Carmona
*************************************************************/
CLASS GCOMBOBOXENTRY FROM GCOMBOBOX
      DATA oEntry
      METHOD New( )
      METHOD GetText()
      METHOD Get_Widget_Entry( ) INLINE TGTK_GET_WIDGET_COMBO_ENTRY( ::pWidget )
      METHOD GetValue()       INLINE ::oEntry:GetValue()
      METHOD SetValue( uVal ) INLINE ::oEntry:SetValue( uVal )
ENDCLASS

METHOD New( bSetGet, aItems, bChange, oModel, oFont, oParent, lExpand, lFill, nPadding, lContainer, x, y,;
            cId, uGlade, uLabelTab, nWidth, nHeight, lEnd, lSecond, lResize, lShrink,;
            left_ta,right_ta,top_ta,bottom_ta, xOptions_ta, yOptions_ta ) CLASS GCOMBOBOXENTRY
       Local aIter 
       //New( bSetget,aItems, , ,,oBox,.F.,.F.,,.F.,,,"comboboxentry1",cResource,,,,.F.,.F.,.F.,.F.,,,,,,)

       ::bSetGet = bSetGet
       ::oModel := oModel

       IF cId == NIL
          if oModel == NIL
             ::pWidget = gtk_combo_entry_new_text()
          else
             ::pWidget = gtk_combo_box_entry_new_with_model( oModel:pWidget, 0 )
          endif  
       ELSE
          ::pWidget := glade_xml_get_widget( uGlade, cId )
          ::CheckGlade( cId )
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
         // TODO: De momento, solamente se admite un modelo de una columna simple, no compuesta. 
          ::oRenderer := gCellRendererText():New()
         gtk_cell_layout_pack_start( ::pWidget , ::oRenderer:pWidget, .T. )
         gtk_cell_layout_add_attribute( ::pWidget , ::oRenderer:pWidget, "text", 0 )
         // Nos posicionamos en la primera opcion del modelo de datos.
         aIter := Array( 4 )
         gtk_tree_model_get_iter_first( oModel:pWidget, aIter )
         gtk_combo_box_set_active_iter( ::pWidget, aIter )
       endif

       if nWidth != NIL
          ::Size( nWidth, nHeight )
       endif

       ::bChange := bChange
       ::Connect( "changed" )
       
       // Obtenemos el entry como un simple objeto, para manipularlo como queramos
       ::oEntry    := gEntry():Object_Empty()
       ::oEntry:pWidget := ::Get_Widget_Entry( )
       ::oEntry:Connect( "key-press-event" )

       // Asignamos a la variable pasada, el valor inicial.
       Eval( ::bSetGet, ::GetText() )
       
       ::Show()

RETURN Self

METHOD GetText() CLASS GCOMBOBOXENTRY
RETURN ::oEntry:GetValue()
