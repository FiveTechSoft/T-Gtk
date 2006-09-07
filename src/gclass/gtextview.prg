/* $Id: gtextview.prg,v 1.1 2006-09-07 17:02:45 xthefull Exp $*/
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

/*
 Prototipo de clase TextView, similar a los MEMOS, pero MUCHOS mas potentes,
 asi como en la clase gEntry , uso un get de toda la vida, aqui prescindo
 totalmente de el.

 Hay varias clases que se entremezclan para realizar determinadas cosas.
 De momento , esto es una version ALPHA! suficiente para mostrar texto,
 mas adelante ya empezaremos con las pijotadas.

 (c)2005 Rafa Carmona
*/


CLASS GTEXTVIEW FROM GCONTAINER
      DATA bSetGet
      DATA oBuffer

      METHOD New( bSetGet, oParent )
      METHOD SetLeft( nMargin )  INLINE gtk_text_view_set_left_margin( ::pWidget, nMargin )
      METHOD SetRight( nMargin ) INLINE gtk_text_view_set_right_margin( ::pWidget, nMargin )
      METHOD SetEditable( lEdited ) INLINE gtk_text_view_set_editable( ::pWidget, lEdited )
      
      METHOD SetText( cText )    INLINE ( ::oBuffer:SetText( cText ), Eval( ::bSetGet, ::GetText() ) )
      METHOD GetText(  )         INLINE ::oBuffer:GetText( )
      METHOD Insert( cText )     INLINE ( ::oBuffer:Insert( cText ), Eval( ::bSetGet, ::GetText() ) )
      METHOD Insert_PixBuf( aIter, uPixbuf ) INLINE ::oBuffer:Insert_Pixbuf( aIter, uPixBuf )
      METHOD Insert_Tag( cText, cTag_Name, aIter ) INLINE ( ::oBuffer:Insert_Tag_Name( cText, cTag_Name, aIter ), , Eval( ::bSetGet, ::GetText() ) )
      METHOD CreateTag( cName, aValues, xParam2, xParam3, xParam4 ) INLINE ::oBuffer:CreateTag( cName, aValues, xParam2, xParam3, xParam4  )
                                                                        
      METHOD GetTagTable()      INLINE gtk_text_buffer_get_tag_table( ::oBuffer:pWidget )
      METHOD RemoveTag( name )  INLINE gtk_text_tag_table_remove( ::GetTagTable(), gtk_text_tag_table_lookup( ::GetTagTable(), name ) )
      
      METHOD SetValue( cText )    INLINE ( ::oBuffer:SetText( cText ), Eval( ::bSetGet, ::GetText() ) )
      METHOD GetValue(  )         INLINE ::oBuffer:GetText( )

      METHOD OnFocus_out_event( oSender )

ENDCLASS

METHOD New( bSetGet, lReadOnly, oParent, lExpand, lFill, nPadding , lContainer, x, y, cId, uGlade,;
            uLabelTab, nWidth, nHeight, lEnd, lSecond, lResize, lShrink,;
            left_ta, right_ta, top_ta, bottom_ta, xOptions_ta, yOptions_ta ) CLASS GTEXTVIEW

       Local cText := ""

       ::bSetGet := bSetGet
       cText :=  Eval( ::bSetGet )

       IF cId == NIL
          ::pWidget := gtk_text_view_new()
       ELSE
          ::pWidget := glade_xml_get_widget( uGlade, cId )
          ::CheckGlade( cId )
       ENDIF
       ::Register()
       ::oBuffer := gTextBuffer():New( ::pWidget )

       if ::bSetGet != NIL
          ::SetText( cText )
       endif
       
       if lReadOnly// READONLY
          ::SetEditable( .F. )
       endif   

       ::AddChild( oParent, lExpand, lFill, nPadding, lContainer, x, y, uLabelTab,;
                   lEnd, lSecond, lResize, lShrink , left_ta, right_ta, top_ta, bottom_ta,;
                   xOptions_ta, yOptions_ta )

       ::Connect( "focus-out-event")
       
       ::Show()

RETURN Self

METHOD OnFocus_Out_Event( oSender ) CLASS GTEXTVIEW

       //TODO:Fix bug. Cuando se pierde el foco por una tecla acelerado.
       // no se actualiza la variable!!
       Eval( oSender:bSetGet, oSender:GetText() )

RETURN Super:OnFocus_Out_Event( oSender )

/*
  Definicion provisional aqui.
*/
CLASS GTEXTBUFFER FROM GOBJECT
      DATA pWidget

      METHOD New( pTextView )
      METHOD SetText( cText ) INLINE gtk_text_buffer_set_text( ::pWidget, cText )
      METHOD GetText(  )      INLINE hb_gtk_text_buffer_get_text( ::pWidget )
      METHOD Insert( cText )  INLINE gtk_text_buffer_insert_at_cursor( ::pWidget, cText )
      METHOD Insert_Tag_Name( cText, cTag1, aIter, nLen )
      METHOD Insert_Pixbuf( aIter, uPixbuf )

      METHOD CreateTag( cName, aValues, xParam2, xParam3, xParam4  )
      METHOD GetIterAtOffSet( aIter, nPos ) INLINE gtk_text_buffer_get_iter_at_offset( ::pWidget, aIter, nPos )
      
      METHOD WriteToFile( cFile ) INLINE ::SaveToFile( cFile )
      METHOD SaveToFile( cFile ) 
      METHOD LoadToFile( cFile )

ENDCLASS

METHOD New( pTextView ) CLASS GTEXTBUFFER
       ::pWidget := gtk_text_view_get_buffer( pTextView )
RETURN Self

METHOD CreateTag( cName, aValues, xParam2, xParam3, xParam4 ) CLASS GTEXTBUFFER
   Local pTag
   // De momento, la llamada admite 4 parametros, mas que suficientes..
   pTag := gtk_text_buffer_create_tag( ::pWidget, cName, xParam2, xParam3, xParam4 )
   // Pero , podemos aplicar directamente un array de propiedades.
   if !Empty( aValues )
      ::Set_Valist( aValues, pTag )
   endif

RETURN pTag

METHOD Insert_Tag_Name( cText, cTag1, aIter, nLen ) CLASS GTEXTBUFFER
    DEFAULT aIter := Array( 14 ) , nLen := -1

    gtk_text_buffer_insert_with_tags_by_name( ::pWidget, aIter, cText, nLen,  cTag1 )

RETURN NIL

METHOD Insert_Pixbuf( aIter, uPixbuf ) CLASS GTEXTBUFFER
   Local xPixbuf
   
   if uPixBuf:ClassName = "GIMAGE" // Si en un objeto GIMAGE, cogemos el pixbuf
      xPixBuf := uPixBuf:GetPixbuf()
   else
      xPixbuf := uPixBuf // Si no, es que le hemos pasado el puntero directamente.
   endif

   if !Empty( xPixBuf )
      gtk_text_buffer_insert_pixbuf( ::pWidget, aIter, xPixbuf )
   endif

RETURN NIL

METHOD SaveToFile( cFile ) CLASS GTEXTBUFFER
     Local  oFile
     
     DEFAULT cFile := "file_tgtk.txt"
     
     oFile := gTextFile():New( cFile, "W" )
     oFile:WriteLn( ::GetText() )
     oFile:Close()

RETURN NIL

METHOD LoadToFile( cFile ) CLASS GTEXTBUFFER
    Local oFile                        
    
    if !Empty( cFile )
       oFile :=  gTextFile():New( cFile, "R" )
       ::SetText( oFile:GetText() )
       oFile:Close()
    endif

RETURN NIL


/*
  Definicion provisional aqui. TEXT_TAG
*/
CLASS GTEXTTAG
      DATA pWidget

ENDCLASS      


