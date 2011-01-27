/* $Id: gentry.prg,v 1.13 2010-12-28 18:52:20 dgarciagil Exp $*/
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
      DATA oJump
      DATA bAction
      
      METHOD New( bSetGet, cPicture, oParent )
      METHOD SetPos( nPos )   INLINE gtk_editable_set_position( ::pWidget, nPos )
      METHOD SetText( cText ) INLINE ( ;
                                      ::Connect( "focus-out-event"), ;
                                      ::Connect( "activate"),;
                                      gtk_entry_set_text( ::pWidget,  cText ) )
      METHOD GetText()        INLINE gtk_entry_get_text( ::pWidget ) 
      METHOD GetPos()         INLINE gtk_editable_get_position( ::pWidget )
      METHOD Justify (nType ) INLINE gtk_entry_set_alignment( ::pWidget, nType )
      METHOD SetVisible( lVisible )  INLINE gtk_entry_set_visibility( ::pWidget, lVisible )
      METHOD SetMaxLength( nMax ) INLINE gtk_entry_set_max_length( ::pWidget, nMax )
      METHOD SetWidthChar( nWidth ) INLINE gtk_entry_set_width_chars( ::pWidget, nWidth )

      METHOD Refresh()
      METHOD Create_Completion( aCompletion )
      
      METHOD Reset()            INLINE  Eval( ::bSetGet, "" ), ::SetText( "" )
      METHOD SetValue( uValue ) INLINE ::SetText( uValue )
      METHOD GetValue( )        INLINE ::GetText()
      
      METHOD SetButton( uImage, nPos )
      
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
      METHOD OnChanged( oSender )      INLINE Eval( ::bSetGet, ::GetText() )
      METHOD OnIcon_Release( oSelf, nPos ) SETGET

ENDCLASS

METHOD New( bSetGet, cPicture, bValid, aCompletion, oFont, oParent, lExpand,;
            lFill, nPadding , lContainer, x, y, cId, uGlade, uLabelTab, lPassWord,;
            lEnd , lSecond, lResize, lShrink, left_ta,right_ta,top_ta,bottom_ta,;
            xOptions_ta, yOptions_ta, bAction, ulButton, urButton ) CLASS GENTRY

       IF cId == NIL
          ::pWidget := gtk_entry_new()
       ELSE
          ::pWidget := glade_xml_get_widget( uGlade, cId )
          ::CheckGlade( cId )
       ENDIF
       
       cPicture := NIL /* TODO: QUITAMOS SOPORTE DE PICTURE, no podemos controlar caracters especiales 
                         Asi que de momento, prefiero al Bar�a co�ons que controlar un get de harbour */
                        
       ::Register()
       ::bSetGet := bSetGet
       ::oGet    := GetNew( -1, -1, bSetGet, "", cPicture )

       ::AddChild( oParent, lExpand, lFill, nPadding, lContainer, x, y, uLabelTab,;
                   lEnd, lSecond, lResize, lShrink, left_ta,right_ta,top_ta,bottom_ta,;
                   xOptions_ta, yOptions_ta   )

       ::bValid := bValid
       ::Connect( "key-press-event" )
       ::Connect( "changed" )
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
       If !Empty( ::oGet:buffer )
          ::SetText( alltrim( ::oGet:buffer ) )
       EndIf
       ::SetPos( ::oGet:pos - 1 )
       
       if bAction != NIL
          ::OnIcon_Release = bAction
       endif
       
       if ulButton != NIL
          ::SetButton( ulButton, GTK_ENTRY_ICON_PRIMARY )
       endif
       
       if urButton != NIL
          ::SetButton( urButton, GTK_ENTRY_ICON_SECONDARY )
       endif       

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
       oSender:SetPos( 1 )

       if oSender:bValid != nil
          if Len( oSender:GetText() ) == 0
             oSender:SetText( oSender:oGet:buffer )
          endif
       Endif

       Eval( ::bSetGet, oSender:oGet:buffer )

RETURN Super:OnFocus_Out_Event( oSender )

METHOD OnKeyPressEvent( oSender, pGdkEventKey ) CLASS GEntry

   local  nKey, nType

   nKey := HB_GET_GDKEVENTKEY_KEYVAL( pGdkEventKey )// aGdkEventKey[ 6 ]
   nType:= HB_GET_GDKEVENTKEY_TYPE( pGdkEventKey )  // aGdkEventKey[ 1 ]

   do case
      case nKey == GDK_Return .or. nKey == GDK_KP_Enter
         if !::lCompletion
            if oSender:oJump != NIL
               oSender:oJump:SetFocus()
            else 
               gtk_widget_child_focus( gtk_widget_get_toplevel( oSender:pWidget ) ,GTK_DIR_TAB_FORWARD )
            endif
            return .T.
         endif   
   endcase
   
   //actualizamos la variable contenedora del get
   Eval( ::bSetGet, oSender:oGet:buffer )

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

METHOD OnIcon_Release( uParam, nPos ) CLASS GEntry

   if hb_IsBlock( uParam )
      ::bAction = uParam
      ::Connect( "icon-release" )
   elseif hb_IsObject( uParam ) 
      if hb_IsBlock( ::bAction )
         Eval( uParam:bAction, nPos )
      endif
   endif    

RETURN NIL

METHOD SetButton( uImage, nPos ) class GEntry
   
   local pixbuf
   
   if hb_isString( uImage )
      gtk_entry_set_icon_from_stock( ::pWidget , nPos, uImage )
   elseif hb_IsObject( uImage ) .and. uImage:IsKindOf( "GIMAGE" )
      pixbuf = uImage:GetPixBuf()
      gtk_entry_set_icon_from_pixbuf( ::pWidget , nPos, pixbuf ) 
      g_object_unref( pixbuf )
   elseif hb_IsPointer( uImage )
      gtk_entry_set_icon_from_pixbuf( ::pWidget , nPos, uImage ) 
   endif

RETURN NIL
