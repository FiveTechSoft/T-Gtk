/* $Id: gentry.prg,v 1.4 2006-10-04 15:22:36 rosenwla Exp $*/
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
#include "getexit.ch"

CLASS GENTRY FROM GWIDGET
      DATA oGet AS OBJECT // Get de toda la vida 
      // DATA bSetGet // Remove from Rosen
      DATA char_iso INIT "ISO-8859-1"
      DATA lCompletion INIT .F.
      
      METHOD New( bSetGet, cPicture, oParent )
      METHOD SetPos( nRow, nPos )   INLINE gtk_editable_set_position( ::pWidget, nPos )
      METHOD SetText( cText ) INLINE gtk_entry_set_text( ::pWidget,  cText )
      METHOD GetText()        INLINE gtk_entry_get_text( ::pWidget )
      METHOD GetPos()         INLINE gtk_editable_get_position( ::pWidget )
      METHOD Justify (nType ) INLINE gtk_entry_set_alignment( ::pWidget, nType )
      METHOD SetVisible( lVisible )  INLINE gtk_entry_set_visibility( ::pWidget, lVisible )
	  METHOD DispOutAt()
	  
      METHOD Refresh()
      METHOD Create_Completion( aCompletion )
      
      METHOD SetValue( uValue ) INLINE ::SetText( uValue )
      METHOD GetValue( )        INLINE ::GetText()
      METHOD DispOutAt( nRow, nCol, xBuffer, cClr, lType, nMode )
	  
	  METHOD OnFocus_in_event( oSender )
      METHOD OnFocus_out_event( oSender )
      METHOD OnKey_Press_event( oSender, pGdkEventKey  )
	  METHOD OnBackspace( oSender ) INLINE oSender:oGet:BackSpace(.t.)
	  METHOD OnCopy_Clipboard( oSender ) INLINE TraceLog("OnCopy_Clipboard"), oSender:oGet:Assign()
	  METHOD OnCut_Clipboard( oSender ) VIRTUAL
	  METHOD OnDelete_From_Cursor( oSender, nDeleteType, nMode ) INLINE TraceLog("OnDelete_From_Cursor", nDeleteType, nMode)
	  METHOD OnInsert_At_Cursor( oSender, cKey ) INLINE TraceLog("OnInsert_At_Cursor"), oSender:oGet:Insert( cKey )
	  METHOD OnMove_Cursor( oSender, nMovementStep, nMode, lMode ) INLINE TraceLog("OnMove_Cursor", nMovementStep, nMode, lMode)
	  METHOD OnPaste_Clipboard( oSender ) VIRTUAL
	  METHOD OnPopulate_Popup( oSender, pMenu ) VIRTUAL
	  METHOD OnToggle_Overwrite( oSender ) INLINE TraceLog("OnToggle_Overwrite")
      METHOD OnChanged( oSender )                  VIRTUAL

ENDCLASS

METHOD New( bSetGet, cPicture, bValid, aCompletion, oFont, oParent, lExpand,;
            lFill, nPadding , lContainer, x, y, cId, uGlade, uLabelTab, lPassWord,;
            lEnd , lSecond, lResize, lShrink, left_ta,right_ta,top_ta,bottom_ta,;
            xOptions_ta, yOptions_ta  ) CLASS GENTRY
	   Local cColorSpec
	   
       IF cId == NIL
          ::pWidget := gtk_entry_new()
       ELSE
          ::pWidget := glade_xml_get_widget( uGlade, cId )
          ::CheckGlade( cId )
       ENDIF
       
       cPicture := NIL /* TODO: QUITAMOS SOPORTE DE PICTURE, no podemos controlar caracters especiales 
                         Asi que de momento, prefiero al BarÇa coñons que controlar un get de harbour */
                        
       ::Register()
       // ::bSetGet := bSetGet //Remowe from Rosen
       // ::oGet    := GetNew( -1, -1, bSetGet, "", cPicture ) // Remove from Rosen
	   ::oGet := Get():New( -1, 0, bSetGet, NIL, cPicture, cColorSpec )
	   
	   ::AddChild( oParent, lExpand, lFill, nPadding, lContainer, x, y, uLabelTab,;
                   lEnd, lSecond, lResize, lShrink, left_ta,right_ta,top_ta,bottom_ta,;
                   xOptions_ta, yOptions_ta   )

       ::bValid := bValid
	   //TraceLog("key-press-event")
	   ::Connect( "backspace" )
       ::Connect( "key-press-event" )
	   ::Connect( "delete-from-cursor" )
	   ::Connect( "insert-at-cursor" )
	   ::Connect( "copy-clipboard" )
	   ::Connect( "cut-clipboard" )
	   ::Connect( "paste-clipboard" )
	   ::Connect( "move-cursor" )
	   ::Connect( "populate-popup" )
	   ::Connect( "toggle-overwrite" )
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

	   ::oGet:oGUI := Self
	   ::oGet:SetFocus()
	   ::SetText( ::oGet:Buffer )
	   ::SetPos( NIL, ::oGet:pos - 1 )
	   ::Show()
		
RETURN Self

METHOD Refresh() CLASS GENTRY
       ::oGet:UpdateBuffer()
       ::SetText( ::oGet:Buffer )
*		if ::oGet:buffer != ::GetText()
*          ::oGet:buffer = ::GetText()
*       endif

RETURN NIL

METHOD DispOutAt( nRow, nCol, xBuffer, cClr, lType, nMode ) CLASS GENTRY
	IF nMode == NIL .OR. nMode == HB_GET
		::SetText( xBuffer )
		//TraceLog( xBuffer )
	ENDIf
Return NIL

METHOD OnFocus_in_event( oSender ) CLASS GENTRY
	Local nReturn
	if ( nReturn := Super:OnFocus_in_event( oSender ) )
		oSender:SetText( oSender:oGet:SetFocus():Buffer )
	endif
Return nReturn

METHOD OnFocus_Out_Event( oSender ) CLASS GENTRY
	Local nReturn
       if !( oSender:oGet:buffer == oSender:GetText() )
          // Tranformacion inversa , de utf8 a iso
          oSender:oGet:buffer( oSender:GetText() ) // _UTF_8( oSender:GetText(), ::char_iso )
       endif
       
       if oSender:bValid != nil
          if Len( oSender:GetText() ) == 0
             oSender:SetText( oSender:oGet:buffer )
          endif
       Endif
	   if ( nReturn := Super:OnFocus_Out_Event( oSender ) )
		oSender:oGet:KillFocus()
	   else
		oSender:oGet:ExitState := GE_NOEXIT	   
	   endif
RETURN nReturn

METHOD OnKey_Press_Event( oSender, pGdkEventKey ) CLASS GEntry

   local  nKey, nType, cKey

   nKey := HB_GET_GDKEVENTKEY_KEYVAL( pGdkEventKey )// aGdkEventKey[ 6 ]
   nType:= HB_GET_GDKEVENTKEY_TYPE( pGdkEventKey )  // aGdkEventKey[ 1 ]
   
   //TraceLog(nKey, nType)
   Switch nKey
      case GDK_Return
		if !::lCompletion
              gtk_widget_child_focus( gtk_widget_get_toplevel( oSender:pWidget ) ,GTK_DIR_TAB_FORWARD )
              return .T.
		endif   
		exit
		
	  Default
         if ( nKey >= 32 .and. nKey <= 255 )
            // clear buffer and get window when postblock returns .F.
            cKey := Chr( nKey )
            if oSender:oGet:type == "N" .and. ( cKey == "." .or. cKey == "," )
               oSender:oGet:ToDecPos()
			   Return .T.
            else
			oSender:oGet:xBuffer := oSender:GetText()
			
            if oSender:oGet:TypeOut
				if ! Set( _SET_CONFIRM )
					oSender:oGet:ExitState := GE_ENTER
                endif
            endif
            endif
         endif
		 //Return .T.
   end
   TraceLog( nKey, cKey, oSender:oGet:buffer, oSender:GetText(), oSender:oGet:hasfocus )
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
