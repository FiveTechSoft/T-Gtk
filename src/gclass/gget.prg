/* $Id: gget.prg,v 1.1 2007-05-07 09:18:08 xthefull Exp $*/
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
   (c)2007 Federico de Maussion
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

CLASS GGET FROM GENTRY
     DATA nTilde INIT 0
     DATA cPicture

     METHOD New( bSetGet, cPicture, oParent )

     METHOD Refresh()
     METHOD GetValue( )        INLINE ::GetText()
     METHOD SetValue( uValue )

     METHOD OnFocus_out_event( oSender )
     METHOD OnKey_Press_event( oSender,   pGdkEventKey  )
     METHOD OnInsert_At_Cursor( oSender, cText )  VIRTUAL
     METHOD OnChanged( oSender )                  VIRTUAL

     METHOD OnFocus_in_event( oSender )
     METHOD DispOutAt( oSender )

ENDCLASS

METHOD New( bSetGet, cPicture, bValid, aCompletion, oFont, oParent, lExpand,;
           lFill, nPadding , lContainer, x, y, cId, uGlade, uLabelTab, lPassWord,;
           lEnd , lSecond, lResize, lShrink, left_ta,right_ta,top_ta,bottom_ta,;
           xOptions_ta, yOptions_ta  ) CLASS GGET

      IF cId == NIL
         ::pWidget := gtk_entry_new()
      ELSE
         ::pWidget := glade_xml_get_widget( uGlade, cId )
         ::CheckGlade( cId )
      ENDIF

      ::Register()
      ::bSetGet := bSetGet
      if cPicture == Nil .and. Valtype(eval(bSetGet)) == "D"
        cPicture := Upper(Set( _SET_DATEFORMAT ))
        cPicture := StrTran( cPicture, "Y", "9" )
        cPicture := StrTran( cPicture, "M", "9" )
        cPicture := StrTran( cPicture, "D", "9" )
      end
      ::cPicture := cPicture
      ::oGet    := GetNew( -1, -1, bSetGet, "", cPicture )

      ::AddChild( oParent, lExpand, lFill, nPadding, lContainer, x, y, uLabelTab,;
                  lEnd, lSecond, lResize, lShrink, left_ta,right_ta,top_ta,bottom_ta,;
                  xOptions_ta, yOptions_ta   )

      ::bValid := bValid
      ::Connect( "key-press-event" )       // Con esto se controla reglas del picture
      ::Connect_After( "focus-out-event")
      ::Connect_After( "focus-in-event")

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

METHOD DispOutAt( oSender ) CLASS GGET
     oSender:SetText( UTF_8( oSender:oGet:buffer ) )
     if oSender:oGet:pos != Nil
        oSender:SetPos( oSender:oGet:pos - 1 )
     end

Return NIL

METHOD SetValue( uValue ) CLASS GGET
  Local lfocus
     lfocus := ::oGet:hasfocus
     if !lfocus
        ::oGet:SetFocus()
     End
     if PCount() == 1
        ::oGet:VarPut( uValue )
     end
     ::Refresh()
     if !lfocus
        ::oGet:SetFocus()
     End

Return NIL

METHOD OnFocus_In_Event( oSender ) CLASS GGET

  if ! Empty( oSender:cPicture ) .and. oSender:oGet:type == "N"
    oSender:oGet:SetFocus()
    oSender:oGet:Picture := StrTran(  Upper(StrTran( oSender:cPicture, ",", "" )), "@E ", "" )
    oSender:oGet:KillFocus()
  endif

  oSender:oGet:SetFocus()
  //oSender:oGet:Clear := .t.
  oSender:DispOutAt( oSender )

  oSender:oGet:Pos = 1
  oSender:SetPos(0)

Return Super:OnFocus_in_event( oSender )

METHOD OnFocus_Out_Event( oSender ) CLASS GGET

  if !( UTF_8( oSender:oGet:buffer ) == oSender:GetText() )
     oSender:oGet:buffer := _UTF_8( oSender:GetText() )
  endif

  oSender:oGet:Assign()
  if ! Empty( oSender:cPicture ) .and. oSender:oGet:type == "N"
     oSender:oGet:Picture := oSender:cPicture
  endif
  oSender:oGet:UpdateBuffer()
  oSender:DispOutAt( oSender )

  if oSender:oGet:BadDate
     oSender:SetFocus()
     return .f.
  end
  oSender:oGet:KillFocus()

RETURN Super:OnFocus_Out_Event( oSender )

METHOD OnKey_Press_Event( oSender, pGdkEventKey ) CLASS GGET

  local  nKey, nType, cKey, cText, cText2

  nKey := HB_GET_GDKEVENTKEY_KEYVAL( pGdkEventKey )// aGdkEventKey[ 6 ]
  nType:= HB_GET_GDKEVENTKEY_TYPE( pGdkEventKey )  // aGdkEventKey[ 1 ]

  Super:OnKey_Press_Event( oSender, pGdkEventKey )

  if !oSender:oGet:hasfocus
     oSender:oGet:SetFocus()
  End
  if !( oSender:oGet:Pos == oSender:GetPos()+1 )
     TraceLog( "Pos Get",Len(oSender:oGet:buffer), "Pos Entry", oSender:GetPos())
     oSender:oGet:Pos := oSender:GetPos()+1
     oSender:oGet:Clear := .f.
  endif
  if !( UTF_8( oSender:oGet:buffer )== oSender:GetText() )
     oSender:oGet:buffer := _UTF_8( oSender:GetText() )
  endif

  do case
     case nKey == GDK_Tab .or. nKey == K_TAB .Or. nKey == GDK_Return .or. nKey == K_ENTER  .or. nKey == 13 .or. nKey == 65421// VK_RETURN
          if !oSender:lCompletion
             gtk_widget_child_focus( gtk_widget_get_toplevel( oSender:pWidget ) ,GTK_DIR_TAB_FORWARD )
             return .T.
          endif

     case nKey == GDK_INSERT
          Set( _SET_INSERT, ! Set( _SET_INSERT ) )
          return .T.

     case nKey == GDK_RIGHT .Or. nKey == K_RIGHT
          oSender:oGet:right()
          oSender:DispOutAt( oSender )
          return .t.

     case nKey == GDK_LEFT .Or. nKey == K_LEFT
          oSender:oGet:Left()
          oSender:DispOutAt( oSender )
          return .t.
     /*
     case nKey == GDK_DOWN .Or. nKey == K_DOWN
          oSender:oGet:Delete()
          oSender:DispOutAt( oSender )
          return .t.
     case nKey == GDK_UP .Or. nKey == K_UP
          oSender:oGet:BackSpace()
          oSender:DispOutAt( oSender )
          return .t.
     */
     case nKey == GDK_Delete .Or. nKey == K_DEL
           return .f.

     /*
         oSender:oGet:Delete()
          oSender:DispOutAt( oSender )
          return .t.
     */

     case nKey == GDK_BackSpace .Or. nKey == K_BS
          oSender:oGet:BackSpace()
          oSender:DispOutAt( oSender )
          return .t.

     case nKey == GDK_HOME .Or. nKey == K_HOME
          oSender:oGet:Home()
          oSender:DispOutAt( oSender )
          return .t.

     case nKey == GDK_END .Or. nKey == K_END
          oSender:oGet:End()
          oSender:DispOutAt( oSender )
          return .t.

//    Caracteres Especiales Soportador hasta ahora
//         "áéíóúÁÉÍÓÚàèìòùÀÈÌÒÙâêîôûÂÊÎÔÛäëïöüÄËÏÖÜãõñÃÕÑ"
//Faltan Caracteres de portar para los lenguages frances, aleman, italiano y varios mas

//                        Shift Shift Ctrl  Ctrl  Alt   Alt
     case Str(nKey,5) $ "65505*65506*65507*65508*65513*65027*"
          return .f.
//                          ~    `      '     ^     "
     case Str(nKey,5) $ "  126*65104*65105*65106*65111*"
          oSender:nTilde = nKey
          return .f.

     case oSender:nTilde != 0 .and. Chr(nKey) $ "aeiounAEIOUN"
          cKey := Chr(nKey)
          cText2 := "aeiouAEIOU"
          do case
             case cKey $ "aeiouAEIOU" .and. oSender:nTilde == 65105
                  cText := "áéíóúÁÉÍÓÚ"
             case cKey $ "aeiouAEIOU" .and. oSender:nTilde == 65104
                  cText := "àèìòùÀÈÌÒÙ"
             case cKey $ "aeiouAEIOU" .and. oSender:nTilde == 65111
                  cText := "äëïöüÄËÏÖÜ"
             case cKey $ "aeiouAEIOU" .and. oSender:nTilde == 65106
                  cText := "âêîôûÂÊÎÔÛ"
             case cKey $ "aeiouAEIOU" .and. oSender:nTilde == 94
                  cText := "âêîôûÂÊÎÔÛ"
             case cKey $ "aonAON" .and. oSender:nTilde == 126
                  cText := "ãõñÃÕÑ"
                  cText2 := "aonAON"
          endcase

          if cText != Nil
            cKey := SubStr(cText,at(Chr(nKey), cText2),1)
          else
            if Set( _SET_INSERT )
              oSender:oGet:Insert( Chr(oSender:nTilde) )
            else
              oSender:oGet:OverStrike( Chr(oSender:nTilde) )
            endif
            cKey := Chr(nKey)
          end
          oSender:nTilde = 0
          
       // ñÑçÇ
     case _UTF_8( nKey ) $ "ñÑçÇ"
          cKey := _UTF_8( nKey )

       // Números
     case nKey >= 65456 .and. nKey < 65466
          cKey := Str(nKey -65456,1)

       // Caracteres Alfabéticos
     case nKey >= 32 .and. nKey < 256 
          cKey :=  Chr(nKey)
          return .t.
  endcase

  if cKey != Nil
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

  TraceLog( Chr(nKey), nKey, _UTF_8( nKey ), oSender:oGet:buffer , _UTF_8( oSender:GetText()))

Return .F.
