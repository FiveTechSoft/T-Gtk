/* $Id: gget.prg,v 1.4 2007-08-12 10:24:44 xthefull Exp $*/
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
    (c)2007 Federico de Maussion <fj_demaussion@yahoo.com.ar>
*/
#include "hbclass.ch"
#include "gclass.ch"
#include "getexit.ch"

//#define nAcentoAgudo  65105
//#define nAcentoGrave  65104
//#define nDieresis     65111
//#define nTilde        126
//#define nCircunflejo  65106

// Shift Ctrl Alt
// Shift Izquierdo  65505
// Shift Derecho    65506
// Ctrl  Izquierdo  65507
// Ctrl  Derecho    65508
// Alt   Izquierdo  65513
// Alt   Derecho    65027

Static oGetAct

CLASS GGET FROM  GWIDGET
      DATA oGet  // Get de toda la vida
      DATA bSetGet
      DATA char_iso     INIT "ISO-8859-1"
      DATA lCompletion  INIT .F.
      DATA lSal         INIT .F.

      DATA nTilde       INIT 0
      DATA bValid
      DATA cPicture, cPicMask, Type

      METHOD New( bSetGet, cPicture, oParent )
      METHOD SetPos( nPos )          INLINE gtk_editable_set_position( ::pWidget, nPos )
      METHOD SetText( cText )        INLINE gtk_entry_set_text( ::pWidget,  cText )
      METHOD GetText()               INLINE gtk_entry_get_text( ::pWidget )
      METHOD GetPos()                INLINE gtk_editable_get_position( ::pWidget )
      METHOD Justify (nType )        INLINE gtk_entry_set_alignment( ::pWidget, nType )
      METHOD SetVisible( lVisible )  INLINE gtk_entry_set_visibility( ::pWidget, lVisible )
     METHOD OnPaste_Clipboard( oSender )

      METHOD Refresh()
      METHOD Create_Completion( aCompletion )

      METHOD SetValue( uValue )      INLINE ::SetText( uValue )
      METHOD GetValue( )             INLINE ::GetText()
      METHOD UpdateBuffer(  )

      METHOD OnFocus_out_event( oSender )
      METHOD OnKeyPressEvent( oSender,   pGdkEventKey  )
      METHOD OnInsert_At_Cursor( oSender, cText )  VIRTUAL
      METHOD OnChanged( oSender )                  VIRTUAL

      METHOD OnFocus_in_event( oSender )
      METHOD DispOutAt( oSender )
      METHOD UpdateBuffer( )

ENDCLASS

METHOD New( bSetGet, cPicture, bValid, aCompletion, oFont, oParent, lExpand,;
            lFill, nPadding , lContainer, x, y, cId, uGlade, uLabelTab, lPassWord,;
            lEnd , lSecond, lResize, lShrink, left_ta,right_ta,top_ta,bottom_ta,;
            xOptions_ta, yOptions_ta  ) CLASS GGET

       DEFAULT cPicture := ""

       IF cId == NIL
          ::pWidget := gtk_entry_new()
       ELSE
          ::pWidget := glade_xml_get_widget( uGlade, cId )
          ::CheckGlade( cId )
       ENDIF

       ::Register()
       ::bSetGet := bSetGet
       ::Type    := ValType(Eval(bSetGet))
       if cPicture == Nil .and. Valtype(eval(bSetGet)) == "D"
         cPicture := Upper(Set( _SET_DATEFORMAT ))
         cPicture := StrTran( cPicture, "Y", "9" )
         cPicture := StrTran( cPicture, "M", "9" )
         cPicture := StrTran( cPicture, "D", "9" )
       end
       cPicture := Upper( Alltrim( cPicture ) )
       ::cPicture := cPicture
       if cPicture != nil .and. !Empty(cPicture)
         ::cPicMask := SubStr(cPicture, Rat(" ", cPicture)+1)
       end
       ::oGet     := GetNew( -1, -1, bSetGet, "", cPicture )

       ::AddChild( oParent, lExpand, lFill, nPadding, lContainer, x, y, uLabelTab,;
                   lEnd, lSecond, lResize, lShrink, left_ta,right_ta,top_ta,bottom_ta,;
                   xOptions_ta, yOptions_ta   )

       ::bValid := bValid
       ::Connect( "key-press-event" )       // Con esto se controla reglas del picture
       ::Connect_After( "focus-out-event")
       ::Connect_After( "focus-in-event")

       ::Connect_After( "paste-clipboard" )

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
       ::SetText( UTF_8( ::oGet:buffer ) )
       ::SetPos( ::oGet:pos - 1 )
       ::oGet:KillFocus()
       ::Show()

       oGetAct := Self

RETURN Self

METHOD Refresh() CLASS GGET
   Local lFocus

   lFocus := ::oGet:HasFocus
   if !lFocus
      ::oGet:SetFocus()
   end
   ::oGet:UpdateBuffer()
   if !lFocus
      ::oGet:KillFocus()
   end
   ::DispOutAt( Self )

RETURN NIL

METHOD DispOutAt( oSender, lSal ) CLASS GGET

  DEFAUlT lSal := .t.

      oSender:SetText( UTF_8( oSender:oGet:buffer ) )
      if lSal .and. oSender:oGet:pos != Nil
         oSender:SetPos( oSender:oGet:pos - 1 )
      end

Return NIL


METHOD OnFocus_In_Event( oSender ) CLASS GGET

  if !( oGetAct == oSender )
    oGetAct = oSender
    if ! Empty( oSender:cPicture ) .and. oSender:oGet:type == "N"
      oSender:oGet:SetFocus()
      oSender:oGet:Picture := StrTran(  Upper(StrTran( oSender:cPicture, ",", "" )), "@E ", "" )
      oSender:oGet:KillFocus()
    endif

    oSender:oGet:SetFocus()
    oSender:oGet:Clear := .t.
    oSender:DispOutAt( oSender )

    oSender:oGet:Pos = 1
    oSender:SetPos(0)
  end

Return Super:OnFocus_in_event( oSender )

METHOD OnFocus_Out_Event( oSender ) CLASS GGET
   local ldev := .f.

     if !( oSender:oGet:buffer == _UTF_8( oSender:GetText() ) )
       oSender:oGet:buffer := _UTF_8( oSender:GetText() )
     endif

     oSender:oGet:Assign()
     if ! Empty( oSender:cPicture ) .and. oSender:oGet:type == "N"
       oSender:oGet:Picture := oSender:cPicture
     endif
     oSender:oGet:UpdateBuffer()
     oSender:DispOutAt( oSender, .f. )

     if oSender:oGet:BadDate
       oSender:SetFocus()
       ldev := .t.
     end

     if oSender:oGet:hasfocus
       oSender:oGet:KillFocus()
     end

//RETURN ldev
RETURN Super:OnFocus_Out_Event( oSender )

METHOD OnKeyPressEvent( oSender, pGdkEventKey ) CLASS GGET

   local  nKey, nType, cKey, cKey2, cText, cText2

   cKey2 := HB_GET_GDKEVENTKEY_STRING( pGdkEventKey )
   nKey := HB_GET_GDKEVENTKEY_KEYVAL( pGdkEventKey )// aGdkEventKey[ 6 ]
   nType:= HB_GET_GDKEVENTKEY_TYPE( pGdkEventKey )  // aGdkEventKey[ 1 ]

   if !oSender:oGet:hasfocus
      oSender:oGet:SetFocus()
   End

   if oSender:oGet:Clear .and. (Len(oSender:oGet:buffer) == oSender:GetPos()+1)
      oSender:SetPos(oSender:oGet:Pos-1)
   elseif oSender:oGet:Clear .and. (Len(oSender:oGet:buffer) > oSender:GetPos()+1)
      oSender:oGet:Pos := oSender:GetPos()+1
      oSender:oGet:Clear := .f.
   elseif !oSender:oGet:Clear .and. !( oSender:oGet:Pos == oSender:GetPos()+1 )
      oSender:oGet:Pos := oSender:GetPos()+1
   endif

   if !( oSender:oGet:buffer == _UTF_8(oSender:GetText() ) )
      oSender:oGet:buffer := _UTF_8( oSender:GetText() )
      oSender:oGet:Pos := oSender:GetPos()+1
   endif

   do case
      case nKey == GDK_Tab .or. nKey == GTK_KEY_TAB .Or. ;
           nKey == GDK_Return .or. nKey == GTK_KEY_ENTER  .or. ;
           nKey == 13 .or. nKey == 65421// VK_RETURN
           if !oSender:lCompletion
              gtk_widget_child_focus( gtk_widget_get_toplevel( oSender:pWidget ) ,GTK_DIR_TAB_FORWARD )
              ::lSal := .t.
              return .T.
           endif

      case nKey == GDK_INSERT
           Set( _SET_INSERT, ! Set( _SET_INSERT ) )
           return .T.

      case nKey == GDK_RIGHT .Or. nKey == GTK_KEY_RIGHT
           return .f.
      case nKey == GDK_LEFT .Or. nKey == GTK_KEY_LEFT
           return .f.
      case nKey == GDK_DOWN .Or. nKey == GTK_KEY_DOWN
           return .f.
      case nKey == GDK_UP .Or. nKey == GTK_KEY_UP
           return .f.
      case nKey == GDK_Delete .Or. nKey == GTK_KEY_DEL
            return .f.
      case nKey == GDK_BackSpace .Or. nKey == GTK_KEY_BS
           return .f.
      case nKey == GDK_HOME .Or. nKey == GTK_KEY_HOME
           return .f.
      case nKey == GDK_END .Or. nKey == GTK_KEY_END
           return .f.

//                        Shift Shift Ctrl  Ctrl  Alt   Alt
      case Str(nKey,5) $ "65505*65506*65507*65508*65513*65027*"
           return .f.
//                          ~    `      '     ^     "
      case Str(nKey,5) $ "  126*65104*65105*65106*65111*"
           oSender:nTilde = nKey
           return .f.

   endcase

   if oSender:nTilde != 0 //.and. Chr(nKey) $ "aeiounAEIOUN"
           cKey := Chr(nKey)
           cText2 := "aeiouAEIOU"
           do case
              case cKey $ "aeiouAEIOU" .and. oSender:nTilde == 65105
                   cText := "·ÈÌÛ˙¡…Õ”⁄"
              case cKey $ "aeiouAEIOU" .and. oSender:nTilde == 65104
                   cText := "‡ËÏÚ˘¿»Ã“Ÿ"
              case cKey $ "aeiouAEIOU" .and. oSender:nTilde == 65111
                   cText := "‰ÎÔˆ¸ƒÀœ÷‹"
              case cKey $ "aeiouAEIOU" .and. oSender:nTilde == 65106
                   cText := "‚ÍÓÙ˚¬ Œ‘€"
              case cKey $ "aeiouAEIOU" .and. oSender:nTilde == 94
                   cText := "‚ÍÓÙ˚¬ Œ‘€"
              case cKey $ "aonAON" .and. oSender:nTilde == 126
                   cText := "„ıÒ√’—"
                   cText2 := "aonAON"
           endcase

           if cText != Nil
             cKey := SubStr(cText,at(Chr(nKey), cText2),1)
           end
           oSender:nTilde = 0
   else

     Switch ::type
     case "D"
        if nKey >= 65456 .and. nKey < 65466
          cKey := Str(nKey -65456,1)
        elseif nKey >= 48 .and. nKey < 58
          cKey := Chr(nKey)
        elseif nKey >= 32 .and. nKey < 256
          return .t.
        end
        exit

     case "N"
        if Str(nKey,5) $ "65453*   45"
          ::lMenus := !::lMenus
          oSender:DispOutAt( oSender )
          return .t.
        end

        if nKey >= 65456 .and. nKey < 65466
          cKey := Str(nKey -65456,1)
        elseif nKey >= 48 .and. nKey < 58
          cKey := Chr(nKey)
        elseif nKey >= 32 .and. nKey < 256
          return .t.
        end
        exit

     case "M"
     case "C"
     // Caracteres AlfabÈticos
        if nKey >= 65456 .and. nKey < 65466
          cKey := Str(nKey -65456,1)
        elseif nKey >= 32 .and. nKey < 256
          cKey :=  Chr(nKey)
        end
        exit

     case "L"
     // Caracteres AlfabÈticos
        if Chr(nKey)$ "fnFNtyTY" 
          cKey := Chr(nKey)
        elseif Chr(nKey) $ "sS" 
          cKey := "T"
        end
        exit
   end
   end


   if cKey != Nil .And. !Empty( cKey )
     if ::cPicMask != nil
       if substr(::cPicMask,oSender:oGet:Pos,1) == "!"
         cKey := MyUpper(cKey)
       end
     end
     if Set( _SET_INSERT )
       oSender:oGet:Insert( cKey )
     else
       oSender:oGet:OverStrike( cKey )
     endif

     oSender:DispOutAt( oSender )
     if oSender:oGet:TypeOut
       if ! Set( _SET_CONFIRM )
         oSender:oGet:ExitState := GE_ENTER
       endif
     endif
     return .t.
   end

   TraceLog( Chr(nKey), nKey, cKey2, _utf_8(cKey2), oSender:oGet:buffer , _UTF_8( oSender:GetText()))

Return .F.


METHOD Create_Completion( aCompletion ) CLASS GGET
    Local oLbx, x, n, oCompletion
    Local nLen := Len( aCompletion )

    /*Modelo de Datos */
    DEFINE LIST_STORE oLbx TYPES G_TYPE_STRING

    For x := 1 To nLen
        INSERT LIST_STORE oLbx ROW x VALUES aCompletion[ x ]
    Next

    oCompletion := gEntryCompletion():New( Self, oLbx, 1 )

RETURN oCompletion

METHOD UpdateBuffer( ) CLASS GGET

   ::oGet:SetFocus( )
   ::oGet:UpdateBuffer( )
   ::SetText( utf_8( ::oGet:Buffer ) )
   ::oGet:KillFocus( )

RETURN nil

METHOD OnPaste_Clipboard( oSender ) CLASS GGET

  oSender:SetText( cValidaTex( oSender ) )

RETURN nil

static Function cValidaTex( oSender )
  Local original := oSender:oGet:buffer
  Local cText := _Utf_8( oSender:GetText( ) )
  Local cDev := ""
  Local cLetra, cLetra2
  Local x, nLen

  if oSender:Type = "L"
    cDev := original
  elseif oSender:Type == "D"
    nLen := Len( cText )
    For x := 1 to nLen
      cLetra := SubStr(cText,x,1)
      cLetra2 := SubStr(original,x,1)
      if cLetra $ "0123456789/"
        cDev += cLetra
      elseif cLetra2 $ "0123456789/"
        cDev += cLetra2
      end
    next
  elseif oSender:Type == "N"
    if "," $ cText
      cText := StrTran( cText, ".", "" )
      cText := StrTran( cText, ",", "." )
    end
    nLen := Len( cText )
    For x :=1 to nLen
      cLetra := SubStr(cText,x,1)
      cLetra2 := SubStr(original,x,1)
      if cLetra $ "0123456789."
        cDev += cLetra
      elseif cLetra2 $ "0123456789."
        cDev += cLetra2
      end
    next
  elseif oSender:Type $ "CM"
    cDev := cText
  end

  cDev := Trans( cText, oSender:cPicture )

  if oSender:Type $ "CM"
    cDev := utf_8( cText )
  end

RETURN cDev

//-------------------------------------------------------------------

FUNCTION MyUpper( cChar )
   Local cDev := ""
   Local x, nAt, cLetra

   for x = 1 to Len( cChar )
      cLetra := Substr(cChar,x,1)
      nAt := AT( cLetra, "abcdefghijklmnopqrstuvwxyz·ÈÌÛ˙‡ËÏÚ˘‰ÎÔˆ¸‚ÍÓÙ˚„ıÒÁ" )
      if nAt > 0
        cDev += SubStr("ABCDEFGHIJKLMNOPQRSTUVWXYZ¡…Õ”⁄¿»Ã“ŸƒÀœ÷‹¬ Œ‘€√’—«",nAt,1)
      else
        cDev += cLetra
      endif
   next

Return cDev


