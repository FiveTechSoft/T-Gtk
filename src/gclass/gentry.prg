/* $Id: gentry.prg,v 1.10 2007-09-15 19:21:57 xthefull Exp $*/
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
#include "hbclass.ch"
#include "gclass.ch"

CLASS GENTRY FROM GWIDGET
      DATA oGet  // Get de toda la vida
      DATA bSetGet
      DATA char_iso INIT "ISO-8859-1"
      DATA lCompletion INIT .F.
      
      METHOD New( bSetGet, cPicture, oParent )
      METHOD SetPos( nPos )   INLINE gtk_editable_set_position( ::pWidget, nPos )
      METHOD SetText( cText ) INLINE gtk_entry_set_text( ::pWidget,  cText )
      METHOD GetText()        INLINE gtk_entry_get_text( ::pWidget )
      METHOD GetPos()         INLINE gtk_editable_get_position( ::pWidget )
      METHOD Justify (nType ) INLINE gtk_entry_set_alignment( ::pWidget, nType )
      METHOD SetVisible( lVisible )  INLINE gtk_entry_set_visibility( ::pWidget, lVisible )
      METHOD SetMaxLength( nMax ) INLINE gtk_entry_set_max_length( ::pWidget, nMax )

      METHOD Refresh()
      METHOD Create_Completion( aCompletion )
      
      METHOD SetValue( uValue ) INLINE ::SetText( uValue )
      METHOD GetValue( )        INLINE ::GetText()
      
      METHOD OnFocus_out_event( oSender )
      METHOD OnKeyPressEvent( oSender,   pGdkEventKey  )
      METHOD OnBackspace( oSender ) VIRTUAL
      METHOD OnCopy_Clipboard( oSender ) VIRTUAL
      METHOD OnCut_Clipboard( oSender ) VIRTUAL
      METHOD OnDelete_From_Cursor( oSender, nDeleteType, nMode ) VIRTUAL
      METHOD OnInsert_At_Cursor( oSender, cText )  VIRTUAL
      METHOD OnMove_Cursor( oSender, nMovementStep, nMode, lMode ) VIRTUAL
      METHOD OnPaste_Clipboard( oSender ) VIRTUAL
      METHOD OnPopulate_Popup( oSender, pMenu ) VIRTUAL
      METHOD OnToggle_Overwrite( oSender ) VIRTUAL
      METHOD OnChanged( oSender )                  VIRTUAL

ENDCLASS

METHOD New( bSetGet, cPicture, bValid, aCompletion, oFont, oParent, lExpand,;
            lFill, nPadding , lContainer, x, y, cId, uGlade, uLabelTab, lPassWord,;
            lEnd , lSecond, lResize, lShrink, left_ta,right_ta,top_ta,bottom_ta,;
            xOptions_ta, yOptions_ta  ) CLASS GENTRY

       IF cId == NIL
          ::pWidget := gtk_entry_new()
       ELSE
          ::pWidget := glade_xml_get_widget( uGlade, cId )
          ::CheckGlade( cId )
       ENDIF
       
       cPicture := NIL /* TODO: QUITAMOS SOPORTE DE PICTURE, no podemos controlar caracters especiales 
                         Asi que de momento, prefiero al BarÇa coñons que controlar un get de harbour */
                        
       ::Register()
       ::bSetGet := bSetGet
       ::oGet    := GetNew( -1, -1, bSetGet, "", cPicture )

       ::AddChild( oParent, lExpand, lFill, nPadding, lContainer, x, y, uLabelTab,;
                   lEnd, lSecond, lResize, lShrink, left_ta,right_ta,top_ta,bottom_ta,;
                   xOptions_ta, yOptions_ta   )

       ::bValid := bValid
       ::Connect( "key-press-event" )
//       ::Connect( "changed" )
       ::Connect_After( "focus-out-event")

       if oFont != NIL
          ::SetFont( oFont )
       endif

       if lPassWord
          ::SetVisible( .F. )
       endif
       
       if !Empty( aCompletion )
          ::lCompletion := .T.
          ::Create_Completion( aCompletion )
       endif
       
       ::oGet:SetFocus()
       ::SetText( alltrim( ::oGet:buffer ) )
       ::SetPos( ::oGet:pos - 1 )

       ::Show()

RETURN Self

METHOD Refresh() CLASS GENTRY
       ::oGet:UpdateBuffer()
       ::SetText( ::oGet:buffer )
*            if ::oGet:buffer != ::GetText()
*          ::oGet:buffer = ::GetText()
*       endif

RETURN NIL

METHOD OnFocus_Out_Event( oSender ) CLASS GENTRY

       if !( oSender:oGet:buffer == oSender:GetText() )
          // Tranformacion inversa , de utf8 a iso
          oSender:oGet:buffer := oSender:GetText()// _UTF_8( oSender:GetText(), ::char_iso )
       endif

       oSender:oGet:Assign()

       if oSender:bValid != nil
          if Len( oSender:GetText() ) == 0
             oSender:SetText( oSender:oGet:buffer )
          endif
       Endif

RETURN Super:OnFocus_Out_Event( oSender )

METHOD OnKeyPressEvent( oSender, pGdkEventKey ) CLASS GEntry

   local  nKey, nType

   nKey := HB_GET_GDKEVENTKEY_KEYVAL( pGdkEventKey )// aGdkEventKey[ 6 ]
   nType:= HB_GET_GDKEVENTKEY_TYPE( pGdkEventKey )  // aGdkEventKey[ 1 ]

   do case
      case nKey == GDK_Return
           if !::lCompletion
              gtk_widget_child_focus( gtk_widget_get_toplevel( oSender:pWidget ) ,GTK_DIR_TAB_FORWARD )
              return .T.
       endif   
   endcase

Return .F.

METHOD Create_Completion( aCompletion ) CLASS GEntry
    Local oLbx, x, n, oCompletion
    Local nLen := Len( aCompletion )
 
    /*Modelo de Datos */
    DEFINE LIST_STORE oLbx TYPES G_TYPE_STRING

    For x := 1 To nLen
        INSERT LIST_STORE oLbx ROW x VALUES aCompletion[ x ]
    Next
 
    oCompletion := gEntryCompletion():New( Self, oLbx, 1 )
 
RETURN oCompletion
