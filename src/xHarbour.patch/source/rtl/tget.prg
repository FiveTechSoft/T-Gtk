/*
 * $Id: tget.prg,v 1.1 2006-10-04 08:35:28 rosenwla Exp $
 */

/*
 * Harbour Project source code:
 * Get Class
 *
 * Copyright 1999 Ignacio Ortiz de Z�niga <ignacio@fivetech.com>
 * www - http://www.harbour-project.org
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2, or (at your option)
 * any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this software; see the file COPYING.  If not, write to
 * the Free Software Foundation, Inc., 59 Temple Place, Suite 330,
 * Boston, MA 02111-1307 USA (or visit the web site http://www.gnu.org/).
 *
 * As a special exception, the Harbour Project gives permission for
 * additional uses of the text contained in its release of Harbour.
 *
 * The exception is that, if you link the Harbour libraries with other
 * files to produce an executable, this does not by itself cause the
 * resulting executable to be covered by the GNU General Public License.
 * Your use of that executable is in no way restricted on account of
 * linking the Harbour library code into it.
 *
 * This exception does not however invalidate any other reasons why
 * the executable file might be covered by the GNU General Public License.
 *
 * This exception applies only to the code released by the Harbour
 * Project under the name Harbour.  If you copy code from other
 * Harbour Project or Free Software Foundation releases into a copy of
 * Harbour, as the General Public License permits, the exception does
 * not apply to the code that you add in this way.  To avoid misleading
 * anyone as to the status of such modified files, you must delete
 * this exception notice from them.
 *
 * If you write modifications of your own for Harbour, it is your choice
 * whether to permit this exception to apply to your modifications.
 * If you do not wish that, delete this exception notice.
 *
 */

#include "hbclass.ch"
#include "color.ch"
#include "common.ch"
#include "setcurs.ch"
#include "getexit.ch"
#include "inkey.ch"
#include "button.ch"
#include "hblang.ch"

/* TODO: :posInBuffer( <nRow>, <nCol> ) --> nPos
         Determines a position within the edit buffer based on screen
         coordinates.
         Xbase++ compatible method */

#define GET_CLR_UNSELECTED      0
#define GET_CLR_ENHANCED        1
#define GET_CLR_CAPTION         2
#define GET_CLR_ACCEL           3

//----------------------------------------------------------------------------//


CLASS Get

   // Exported
   
   DATA oGUI
   DATA BadDate
   DATA Block
   DATA xBuffer	
   DATA Cargo
   DATA Changed
   DATA Clear
   DATA Col
   DATA DecPos
   DATA ExitState
   DATA HasFocus
   DATA Minus
   DATA Name
   DATA Original
   DATA Pos
   DATA PostBlock
   DATA PreBlock
   DATA Reader
   DATA Rejected
   DATA Row
   DATA SubScript
   DATA Type
   DATA TypeOut

   #ifdef HB_COMPAT_C53
   DATA Control
   DATA Message
   DATA Caption
   DATA nLastExitState
   DATA CapRow
   DATA CapCol
   #endif

   METHOD New( nRow, nCol, bVarBlock, cVarName, cPicture, cColorSpec )

   METHOD Assign()
   #ifdef HB_COMPAT_XPP
   MESSAGE _Assign METHOD Assign()
   #endif
   
   ACCESS Buffer					INLINE TraceLog(::xBuffer), ::xBuffer
   ASSIGN Buffer( xBuffer )			INLINE (::xBuffer := xBuffer)
   
   ACCESS ColorSpec                 INLINE ::cColorSpec
   ASSIGN ColorSpec( cColorSpec )   INLINE ::SetColorSpec( cColorSpec )
   ACCESS Picture                   INLINE ::cPicture
   ASSIGN Picture( cPicture )       INLINE ::SetPicture( cPicture )

   METHOD Display( lForced )
   METHOD ColorDisp( cColorSpec ) INLINE ::ColorSpec := cColorSpec, ::Display(), Self
   METHOD KillFocus()
   METHOD Reset()
   METHOD SetFocus()
   METHOD Undo()
   METHOD UnTransform( cBuffer )
   METHOD UpdateBuffer() INLINE  if( ::hasfocus, ( ::xBuffer := ::PutMask( ::VarGet() ), ::Display() ), ), Self
   METHOD VarGet()
   METHOD VarPut(xValue, lReFormat)

   METHOD End()
   #ifdef HB_COMPAT_XPP
   MESSAGE _End METHOD End()
   #endif

   METHOD Home()
   MESSAGE Left() METHOD _Left()
   MESSAGE Right() METHOD _Right()
   METHOD ToDecPos()
   METHOD WordLeft()
   METHOD WordRight()

   METHOD BackSpace( lDisplay )
   MESSAGE Delete() METHOD _Delete()
   METHOD DelEnd()
   METHOD DelLeft()
   METHOD DelRight()
   METHOD DelWordLeft()
   METHOD DelWordRight()

   METHOD Insert( cChar )
   METHOD OverStrike( cChar )

   #ifdef HB_COMPAT_C53
   METHOD HitTest(mrow, mcol)
   #endif


   PROTECTED:           /*  P R O T E C T E D  */

   DATA cColorSpec            // Used only for METHOD ColorSpec
   DATA cPicture              // Used only for METHOD Picture

   METHOD SetColorSpec( cColorSpec )
   METHOD SetPicture( cPicture )


   HIDDEN:              /*  H I D D E N  */

   DATA cPicMask, cPicFunc, nMaxLen, lEdit, lDecRev, lPicComplex
   DATA nDispLen, nDispPos, nOldPos, lCleanZero, cDelimit, nMaxEdit
   DATA lMinusPrinted, xVarGet
   DATA lDispLen INIT .F.

   METHOD ParsePict( cPicture )
   METHOD DeleteAll()
   METHOD IsEditable( nPos )
   METHOD Input( cChar )
   METHOD PutMask( cBuffer, lEdit )
   METHOD FirstEditable( )
   METHOD LastEditable( )

   METHOD HasScroll() INLINE ::nDispLen != ::nMaxLen

ENDCLASS

//---------------------------------------------------------------------------//

METHOD New( nRow, nCol, bVarBlock, cVarName, cPicture, cColorSpec ) CLASS Get

   //DEFAULT nRow       TO Row()
   //DEFAULT nCol       TO Col()
   DEFAULT cVarName   TO ""
   DEFAULT bVarBlock  TO IIF( ValType( cVarName ) == 'C', MemvarBlock( cVarName ), NIL )
   DEFAULT cPicture   TO ""
   DEFAULT cColorSpec TO BuildGetColor(cColorSpec) // SetColor()

   ::HasFocus       := ;
   ::lEdit          := ;
   ::BadDate        := ;
   ::Changed        := ;
   ::Clear          := ;
   ::lCleanZero     := ;
   ::lMinusPrinted  := ;
   ::Minus          := ;
   ::Rejected       := ;
   ::TypeOut        := .f.
   ::DecPos         := ;
   ::Pos            := ;
   ::PostBlock      := ;
   ::PreBlock       := ;
   ::Reader         := ;
   ::SubScript      := NIL
   ::ExitState      := ;
   ::nLastExitState := ;
   ::nOldPos        := 0
   ::nDispPos       := 1
   ::Block          := bVarBlock
   ::Col            := nCol
   ::Row            := nRow
   ::ColorSpec      := cColorSpec
   ::Picture        := cPicture
   ::Name           := cVarName
   //::Original     := ::VarGet()
   ::Type           := ValType( ::VarGet() )   // Must know the type at creation
   ::cDelimit       := if( SET(_SET_DELIMITERS), SET(_SET_DELIMCHARS), NIL )

   #ifdef HB_COMPAT_C53
   ::CapCol         := ;
   ::CapRow         := 0
   ::Caption        := ""
   #endif
return Self

//---------------------------------------------------------------------------//

METHOD ParsePict( cPicture ) CLASS Get

   local cChar
   local nAt
   local nFor
   local cNum

   cNum := ""

   if Left( cPicture, 1 ) == "@"

      nAt := At( " ", cPicture )

      if nAt == 0
         ::cPicFunc := Upper( cPicture )
         ::cPicMask := ""
      else
         ::cPicFunc := Upper( SubStr( cPicture, 1, nAt - 1 ) )
         ::cPicMask := LTrim( SubStr( cPicture, nAt + 1 ) )
      endif

//      AnalyzePicture( @::cPicFunc )

      if "D" IN ::cPicFunc

         ::cPicMask := Set( _SET_DATEFORMAT )
         ::cPicMask := StrTran( ::cPicmask, "y", "9" )
         ::cPicMask := StrTran( ::cPicmask, "Y", "9" )
         ::cPicMask := StrTran( ::cPicmask, "m", "9" )
         ::cPicMask := StrTran( ::cPicmask, "M", "9" )
         ::cPicMask := StrTran( ::cPicmask, "d", "9" )
         ::cPicMask := StrTran( ::cPicmask, "D", "9" )

      endif

      if ( nAt := At( "S", ::cPicFunc ) ) > 0
         for nFor := nAt + 1 to Len( ::cPicFunc )
            if ! IsDigit( SubStr( ::cPicFunc, nFor, 1 ) )
               exit
            else
               cNum += SubStr( ::cPicFunc, nFor, 1 )
            endif
         next
         if Val(cNum) > 0
            ::nDispLen := Val(cNum)
            ::lDispLen := .t.
         else
            ::lDispLen := .f.
         endif
         ::cPicFunc := SubStr( ::cPicFunc, 1, nAt - 1 ) + SubStr( ::cPicFunc, nFor )
      else
         ::lDispLen := .f.
      endif

      if "Z" IN ::cPicFunc
         ::lCleanZero := .t.
      else
         ::lCleanZero := .f.
      endif
      ::cPicFunc := StrTran(::cPicFunc, "Z", "")

      if ::cPicFunc == "@"
         ::cPicFunc := ""
      endif
   else
      ::cPicFunc   := ""
      ::cPicMask   := cPicture
      ::lCleanZero := .f.
      ::lDispLen   := .f.
   endif

   if ::type == "D"
      // ::cPicMask := LTrim( ::cPicMask )
      // avoid user date picture to force default date picture in
      // accordance with set date format. See below.
      ::cPicMask := ""
   endif

   // Comprobar si tiene la , y el . cambiado (Solo en Xbase++)

   ::lDecRev := "," IN Transform( 1.1, "9.9" )

   // Generate default picture mask if not specified

   if Empty( ::cPicMask ) .and. !Empty( ::type )

      Switch ::type
      case "D"

         ::cPicMask := Set( _SET_DATEFORMAT )
         ::cPicMask := StrTran( ::cPicmask, "y", "9" )
         ::cPicMask := StrTran( ::cPicmask, "Y", "9" )
         ::cPicMask := StrTran( ::cPicmask, "m", "9" )
         ::cPicMask := StrTran( ::cPicmask, "M", "9" )
         ::cPicMask := StrTran( ::cPicmask, "d", "9" )
         ::cPicMask := StrTran( ::cPicmask, "D", "9" )
         exit

      case "N"

         cNum := Str( ::xVarGet )
         if ( nAt := At( iif( ::lDecRev, ",", "." ), cNum ) ) > 0
            ::cPicMask := Replicate( '9', nAt - 1 ) + iif( ::lDecRev, ",", "." )
            ::cPicMask += Replicate( '9', Len( cNum ) - Len( ::cPicMask ) )
         else
            ::cPicMask := Replicate( '9', Len( cNum ) )
         endif
         exit

       case "C"
          If ::cPicFunc == "@9"
             ::cPicMask := Replicate( "9", Len( ::VarGet() ) )
             ::cPicFunc := ""
          Endif
          exit

      end
   endif

   // Comprobar si tiene caracteres embebidos no modificables en la plantilla

   ::lPicComplex := .f.

   IF ! Empty( ::cPicMask )
      For each cChar in ::cPicMask
         IF cChar == 'a'
            ::cPicMask[ HB_EnumIndex() ] := 'A'
         ELSEIF cChar == 'n'
            ::cPicMask[ HB_EnumIndex() ] := 'N'
         ELSEIF !(cChar IN "!ANX9#")
            ::lPicComplex := .t.
            EXIT
         ENDIF
      NEXT
   ENDIF

//   if ::HasFocus  // TODO: Delete this line if the "if ::hasfocus" in ::Picture
                  //       is correct.
      if ::type == "N"
         ::decpos := At( iif( ::lDecRev .or. "E" IN ::cPicFunc, ",", "." ), ;
                     Transform( 1, if( Empty( ::cPicFunc ), "", ::cPicFunc + " " ) + ::cPicMask ) )
         if ::decpos == 0
            ::decpos := iif( ::xBuffer == NIL, NIL, Len( ::xBuffer ) + 1 )
         endif
      else
         ::decpos := NIL

         IF ::type == 'L'
            ::cPicMask := Upper( ::cPicMask )
         ENDIF
      endif
//   endif

return ::cPicFunc + ' ' + ::cPicMask

//---------------------------------------------------------------------------//

METHOD Assign() CLASS Get

   if ::hasfocus
   ::VarPut( ::unTransform(), .f.  )
   endif

return Self

//---------------------------------------------------------------------------//

METHOD Display( lForced ) CLASS Get

//   LOCAL nOldCursor := SetCursor( SC_NONE )
   LOCAL xBuffer
   LOCAL xVar
   LOCAL cCaption
   LOCAL cClrCap := hb_ColorIndex( ::ColorSpec, GET_CLR_CAPTION )
   LOCAL cClrAcc := hb_ColorIndex( ::ColorSpec, GET_CLR_ACCEL )
   LOCAL lIsIntense := SET( _SET_INTENSITY)

   DEFAULT lForced TO .t.

   IF Empty( cClrCap )
		cClrCap := hb_ColorIndex( SetColor(), CLR_STANDARD )
   ENDIF
   IF Empty( cClrAcc )
		cClrAcc := hb_ColorIndex( SetColor(), CLR_BACKGROUND )
   ENDIF

   IF ::xBuffer == NIL
      xVar      := ::VarGet() // In VarGet() is setting ::xVarGet needed to
                              // ::Picture.
      ::Picture := ::cPicture
      xBuffer   := ::PutMask( xVar, .f. )
   ELSE
      xBuffer   := ::xBuffer
   ENDIF

   IF ! ::lMinusPrinted .AND. ! Empty( ::DecPos ) .AND. ::minus .AND. SubStr( xBuffer, ::DecPos - 1, 1 ) == "0"
      xBuffer := SubStr( xBuffer, 1, ::DecPos - 2 ) + "-." + SubStr( xBuffer, ::DecPos + 1 )
   ENDIF

   IF ::HasScroll() .and. ::Pos != NIL
      IF ::nDispLen > 8
         ::nDispPos := Max( 1, Min( ::Pos - ::nDispLen + 4, ::nMaxLen - ::nDispLen + 1 ) )
      ELSE
         ::nDispPos := Max( 1, Min( ::Pos - int( ::nDispLen / 2 ), ::nMaxLen - ::nDispLen + 1 ) )
      ENDIF
   ENDIF

   IF xBuffer != NIL .and. ( lForced .or. ( ::nDispPos != ::nOldPos ) )
	  
      ::oGUI:DispOutAt( ::Row, ::Col + if( ::cDelimit == NIL, 0, 1 ),;
             Substr( xBuffer, ::nDispPos, ::nDispLen ), ;
             hb_ColorIndex( ::ColorSpec, iif( ::HasFocus, GET_CLR_ENHANCED, GET_CLR_UNSELECTED ) ), .T. )
      IF ! ( ::cDelimit == NIL )
		 ::oGUI:DispOutAt( ::Row, ::Col, Substr( ::cDelimit, 1, 1), hb_ColorIndex( ::ColorSpec, iif( ::HasFocus, GET_CLR_ENHANCED, GET_CLR_UNSELECTED ) ), .T. )
         ::oGUI:DispOutAt( ::Row, ::Col + ::nDispLen + 1, Substr( ::cDelimit, 2, 1), hb_ColorIndex( ::ColorSpec, iif( ::HasFocus, GET_CLR_ENHANCED, GET_CLR_UNSELECTED ) ), .T. )
      ENDIF
   ENDIF

   IF !Empty( ::Caption )
     cCaption := StrTran( ::Caption, "&", "" )
     ::oGUI:DispOutAt( ::Row, ::Col - Len( cCaption ) - 1, cCaption, cClrCap, .T., 1 )
     IF "&" $ ::Caption
       ::oGUI:DispOutAt( ::Row, ::Col - Len( cCaption ) - 2 + At( "&", ::Caption ), cCaption[At( "&", ::Caption )], cClrAcc, .T., 1 )
     ENDIF
   ENDIF

   ::nOldPos := ::nDispPos

   IF ::Pos != NIL
      ::oGUI:SetPos( ::Row, ::Col + ::Pos - ::nDispPos + if( ::cDelimit == NIL, 0, 1 ) )
   ENDIF

   //SetCursor( nOldCursor )

   //HBConsoleUnlock()

return Self

//---------------------------------------------------------------------------//

METHOD End() CLASS Get

   local nLastCharPos, nPos, nFor

   if ::HasFocus != nil .and. ::HasFocus
      nLastCharPos := Min( Len( RTrim( ::xBuffer ) ) + 1, ::nMaxEdit )
      if ::Pos != nLastCharPos
         nPos := nLastCharPos
      else
         nPos := ::nMaxEdit
      endif
      for nFor := nPos to ::FirstEditable() step -1
         if ::IsEditable( nFor )
            ::Pos := nFor
            exit
         endif
      next
      ::TypeOut := .f.
      ::Clear := .f.
      ::Display( .f. )
   endif

return Self

//---------------------------------------------------------------------------//

METHOD Home() CLASS Get

   if ::HasFocus
      ::Pos := ::FirstEditable( )
      ::TypeOut := .f.
      ::Clear := .f.
      ::Display( .f. )
   endif

return Self

//---------------------------------------------------------------------------//

METHOD Reset() CLASS Get

   if ::hasfocus
      ::xBuffer := ::PutMask( ::VarGet(), .f. )
      ::pos := ::FirstEditable( )
      ::TypeOut := .f.
   endif

return Self

//---------------------------------------------------------------------------//

METHOD Undo() CLASS Get

   if ::hasfocus
      ::VarPut( ::Original, .t. )
      ::pos := ::FirstEditable( )
      ::updateBuffer() // 7/01/2004 9:44a.m. was ::Display()
   endif

return Self

//---------------------------------------------------------------------------//

METHOD SetFocus() CLASS Get

   local xVarGet

   if !::HasFocus

      xVarGet := ::VarGet() // In VarGet() is setting ::xVarGet

      ::hasfocus   := .t.
      ::rejected   := .f.
      ::typeout    := .f.

      ::Original   := xVarGet
      ::type       := ValType( xVarGet )
      ::Picture    := ::cPicture
      ::xBuffer    := ::PutMask( xVarGet, .f. )
      ::changed    := .f.
      ::clear      := ( "K" IN ::cPicFunc .or. ::type == "N")
      //::nMaxLen    := IIF( ::xBuffer == NIL, 0, Len( ::xBuffer ) )
      ::pos        := 0
      ::lEdit      := .f.

      ::pos := ::FirstEditable( )

      if ::pos = 0
         ::TypeOut = .t.
      endif

      if ::type == "N"
         ::decpos := At( iif( ::lDecRev .or. "E" IN ::cPicFunc, ",", "." ), ::xBuffer )
         if ::decpos == 0
            ::decpos := iif( ::xBuffer == NIL, NIL, Len( ::xBuffer ) + 1 )
         endif
         /* No, tested with clipper, ::minus .F. on ::setFocus of a negative variable get
         ::minus := ( xVarGet < 0 )
         */
         ::lMinusPrinted := ( xVarGet < 0 )
         ::minus := .F.
      else
         ::decpos := NIL
         ::lMinusPrinted := ::minus  := .f.
      endif


      if ::type == "D"
         ::BadDate := IsBadDate( ::xBuffer, ::cPicFunc )
      else
         ::BadDate := .f.
      endif

      if ::xBuffer != NIL
         if ::nDispLen == NIL .or. !::lDispLen
            ::nDispLen := ::nMaxLen
         endif

         ::Display( .T. )
      else
         ::Display()
      endif
   else
      ::Display()
   endif
	TraceLog(::xBuffer, ::cPicMask, ::type)
return Self

//---------------------------------------------------------------------------//

METHOD KillFocus() CLASS Get

   if ::lEdit
      ::Assign()
   endif

   ::hasfocus := .f.
//   ::xBuffer   := ::PutMask( )
   ::xBuffer   := NIL
   ::Original := NIL
   ::pos      := NIL

   ::Display()
   ::xVarGet  := NIL

   ::typeout := .f.  /* Clipper compatible */

return Self

//---------------------------------------------------------------------------//

METHOD VarPut( xValue, lReFormat ) CLASS Get

   LOCAL nCounter, aGetVar, aIndex, nDim

   DEFAULT lReFormat TO .t.

   if ::Block != nil .and. xValue != nil

      IF ::SubScript == NIL
         Eval( ::Block, xValue )
      ELSE
         aIndex := ::SubScript
         nDim := Len( aIndex )
         aGetVar := Eval( ::Block )
         FOR nCounter := 1 TO nDim - 1
            aGetVar := aGetVar[ aIndex[ nCounter ] ]
         NEXT
         aGetVar[ aIndex[ nCounter ] ] := xValue
      ENDIF

      if lReFormat
         if !::hasfocus
            ::Original := xValue
         endif
         ::Type    := ValType( xValue )
         ::xVarGet := xValue
         ::lEdit   := .f.
         ::Picture( ::cPicture )
      endif
   endif
return xValue

//---------------------------------------------------------------------------//

METHOD VarGet() CLASS Get

   LOCAL xVarGet, aIndex, nDim, aGetVar, nCounter

   IF ! HB_IsBlock( ::Block )
      ::xVarGet := NIL
      ::Type    := 'U'
      RETURN NIL
   ENDIF

   IF ::SubScript == NIL
      xVarGet := Eval( ::Block )
   ELSE
      aIndex := ::SubScript
      nDim := Len( aIndex )
      aGetVar := Eval( ::Block )
      FOR nCounter := 1 TO nDim - 1
         aGetVar := aGetVar[ aIndex[ nCounter ] ]
      NEXT
      xVarGet := aGetVar[ aIndex[ nCounter ] ]
   ENDIF

  ::xVarGet := xVarGet
  ::Type    := ValType( xVarGet )

RETURN xVarGet

//---------------------------------------------------------------------------//

METHOD Untransform( cBuffer ) CLASS Get

   local xValue, lUntransform := .T.
   local cChar
   local nFor, nPad := 0
   local cMaskDel := ""

   DEFAULT cBuffer TO ::xBuffer

   /*
   if !::lEdit
      return ::VarGet()
   endif
   */
   if cBuffer == NIL
      return NIL
   endif

   Switch ::type
   case "C"

      if "R" IN ::cPicFunc
         For each cChar in ::cPicMask
            cMaskDel += if( (cChar IN "ANX9#!"), " ", "X" )
         Next
         cBuffer := StrDel( cBuffer, cMaskDel )
         cBuffer += Substr( ::xVarGet, Len( cBuffer ) + 1 )
      else
         cBuffer += SubStr( ::xVarGet, ::nMaxLen + 1 )
      endif

      xValue := cBuffer
      exit

   case "N"
      if "X" IN ::cPicFunc
         if Right( cBuffer, 2 ) == "DB"
            ::minus := .t.
         endif
      endif
      if ! ::minus
         for nFor := 1 to ::nMaxLen
            if ::IsEditable( nFor ) .and. IsDigit( SubStr( cBuffer, nFor, 1 ) )
               exit
            endif
            if SubStr( cBuffer, nFor, 1 ) IN "-(" .and. SubStr( cBuffer, nFor, 1 ) != SubStr( ::cPicMask, nFor, 1 )
               ::minus := .t.
               exit
            endif
         next
      endif

      /* 14/08/2004 - <maurilio.longo@libero.it>
                      If there should be a decimal point (or comma) but this is missing
                      re-add it. Clipper does it. A little sample is inside ChangeLog
                      for this fix.
      */
      if ::decPos < Len( cBuffer ) .and. Empty( cBuffer[ ::decPos ] ) .and. if( ::lDecRev, "," , "." ) IN ::cPicture
         cBuffer[ ::decPos ] := if( "E" IN ::cPicFunc .or. ::lDecRev, ",", "." )
      endif

      cBuffer := Space( ::FirstEditable() - 1 ) + ;
                 SubStr( cBuffer, ::FirstEditable(), ::LastEditable() - ::FirstEditable() + 1 )

      if "D" IN ::cPicFunc
         for nFor := ::FirstEditable( ) to ::LastEditable( )
            cMaskDel += if( ::IsEditable( nFor ), " ", "X" )
         next
      else
         if "E" IN ::cPicFunc .or. ::lDecRev
            cBuffer := Left( cBuffer, ::FirstEditable() - 1 ) + ;
                       StrTran( SubStr( cBuffer, ::FirstEditable( ), ;
                                                 ::LastEditable( ) - ::FirstEditable( ) + 1 ), ;
                                        ".", " " ) +;
                       SubStr( cBuffer, ::LastEditable() + 1 )

            cBuffer := Left( cBuffer, ::FirstEditable() - 1 ) + ;
                       StrTran( SubStr( cBuffer, ::FirstEditable( ), ;
                                                 ::LastEditable( ) - ::FirstEditable( ) + 1 ), ;
                                        ",", "." ) + ;
                       SubStr( cBuffer, ::LastEditable() + 1 )

         else
/*
2005/07/30 - Eduardo Fernandes <modalsist@yahoo.com.br>
The two IFs bellow was disabled because cause wrong get value if we type
a numeric var greater than 999 in the picture "@R 9,999.99".
Added: lUntransform := ( "R" IN ::cPicFunc )

            if "R" IN ::cPicFunc
               lUntransform := Empty( ::xBuffer )
            endif

            if ":" IN ::cPicture
               lUntransform := .T.
            endif
*/
            lUntransform := ( "R" IN ::cPicFunc )

            if lUntransform
               cBuffer := Left( cBuffer, ::FirstEditable() - 1 ) + ;
                          StrTran( SubStr( cBuffer, ::FirstEditable( ), ;
                                                    ::LastEditable( ) - ::FirstEditable( ) + 1 ), ;
                                           ",", " " ) + ;
                          SubStr( cBuffer, ::LastEditable() + 1 )
            endif

         endif

         // Tony (ABC)   12/22/2005      3:53PM
         // The mask to delete has to be created according to the whole buffer!!
         // Because it is applied below as:   cBuffer := StrDel( cBuffer, cMaskDel )
         for nFor := 1 to len(cBuffer)
//         for nFor := ::FirstEditable( ) to ::LastEditable( )
             cMaskDel += iif( ::IsEditable( nFor ) .or. SubStr( cBuffer, nFor, 1 ) == ".", " ", "X" )
             if ::IsEditable( nFor ) .or. SubStr( cBuffer, nFor, 1 ) == "."
                nPad ++
             endif
         next
      endif

      // Tony (ABC)   12/22/2005      3:53PM
      // I found that cMaskDel was shorter than cBuffer. Fixed bug.
      cBuffer := StrDel( cBuffer, cMaskDel )

      cBuffer := StrTran( cBuffer, "$", " " )
      cBuffer := StrTran( cBuffer, "*", " " )
      cBuffer := StrTran( cBuffer, "-", " " )
      cBuffer := StrTran( cBuffer, "(", " " )
      cBuffer := StrTran( cBuffer, ")", " " )

      cBuffer := PadL( StrTran( cBuffer, " ", "" ), nPad )

      // cBuffer := PadL( StrTran( cBuffer, " ", "" ), Len( cBuffer ) )
                 // It replace left, right and medium spaces.
                 // Don't replace for Alltrim()

      //xValue  := 0 + Val( cBuffer )    // 0 + ... avoids setting the

      /* 13/08/2004 - <maurilio.longo@libero.it>
                    We're talking about a number and a few lines of code before this
                    point ::minus is set to .T. if there is a "-(" inside number and
                    a few lines after we make a Val(cBuffer), so, this buffer has to
                    contain only numbers (and a "-" or ".", at max);
                    that said, while there was this loop?
                    I've replaced it with the iif( ::minus... ) which is shorter and
                    evaluates correctly a buffer containing "  -.10"

      if ::minus
         For each cChar in cBuffer
            if IsDigit( cChar )
               nFor := HB_EnumIndex()
               exit
            endif
         Next
         nFor--
         if nFor > 0
            cBuffer := Left( cBuffer, nFor-1 ) + "-" + SubStr( cBuffer, nFor+1 )
         else
            cBuffer := "-" + cBuffer
         endif
      endif */

      xValue := iif( ::minus, -Val( cBuffer ), Val( cBuffer ) )
      exit

   case "L"
      cBuffer := Upper( cBuffer )
      xValue := "T" IN cBuffer .or. "Y" IN cBuffer .or. hb_langmessage( HB_LANG_ITEM_BASE_TEXT + 1 ) IN cBuffer
      exit

   case "D"
      if "E" IN ::cPicFunc
         cBuffer := SubStr( cBuffer, 4, 3 ) + SubStr( cBuffer, 1, 3 ) + SubStr( cBuffer, 7 )
      endif
      xValue := CToD( cBuffer )
      exit

   end
return xValue

//---------------------------------------------------------------------------//

METHOD overstrike( cChar ) CLASS Get

   if ::type == "N" .and. ! ::lEdit .and. ::Clear
      ::pos := ::FirstEditable( )
   endif

   if ::Pos > ::nMaxEdit
      ::Rejected := .t.
      return Self
   endif

   cChar := ::Input( cChar )

   if cChar == ""
      ::Rejected := .t.
      return Self
   else
      ::Rejected := .f.
   endif

   if ::Clear .and. ::pos == ::FirstEditable( )
      ::DeleteAll()
      ::Clear := .f.
      ::lEdit := .f.
   endif

   if ! ::lEdit
      ::lEdit  := .t.
      //::xBuffer := ::PutMask( ::VarGet(), .t. )
   endif

   if ::pos == 0
      ::pos = 1
   endif

   do while ! ::IsEditable( ::pos ) .and. ::pos <= ::nMaxEdit
      ::pos++
   enddo

   if ::pos > ::nMaxEdit
      ::pos := ::FirstEditable( )
   endif

   ::xBuffer := SubStr( ::xBuffer, 1, ::Pos - 1 ) + cChar + SubStr( ::xBuffer, ::Pos + 1 )

   // To conform UPDATED() behaviour with that of Clipper
   ::Changed := .T.

   // UPDATED() function previously did not return .T. even if a key press is
   // accepted.
   //   ::Changed := ValType( ::Original ) != ValType( ::unTransform() ) .or.;
   //                !( ::unTransform() == ::Original )
   ::Right( .f. )

   if ::type == "D"
      ::BadDate := IsBadDate( ::xBuffer, ::cPicFunc )
   else
      ::BadDate := .f.
   endif

   ::Display()

return Self

//---------------------------------------------------------------------------//

METHOD Insert( cChar ) CLASS Get

   local n
   local nMaxEdit := ::nMaxEdit

   if ::type == "N" .and. ! ::lEdit .and. ::Clear
      ::pos := ::FirstEditable( )
   endif

   if ::Pos > ::nMaxEdit
      ::Rejected := .t.
      return Self
   endif

   cChar := ::Input( cChar )

   if cChar == ""
      ::Rejected := .t.
      return Self
   else
      ::Rejected := .f.
   endif

   if ::Clear .and. ::pos == ::FirstEditable( )
      ::DeleteAll()
      ::Clear := .f.
      ::lEdit := .f.
   endif

   if ! ::lEdit
      ::lEdit  := .t.
      //::xBuffer := ::PutMask( ::VarGet(), .t. )
   endif

   if ::pos == 0
      ::pos = 1
   endif

   do while ! ::IsEditable( ::pos ) .and. ::pos <= ::nMaxEdit
      ::pos++
   enddo

   if ::pos > ::nMaxEdit
      ::pos := ::FirstEditable( )
   endif

   if ::lPicComplex
      // Calculating diferent nMaxEdit for ::lPicComplex

      for n := ::Pos to nMaxEdit
         if !::IsEditable( n )
           exit
         endif
      next
      nMaxEdit := n
      ::xBuffer := Left( Substr( ::xBuffer, 1, ::Pos-1 ) + cChar +;
                  Substr( ::xBuffer, ::Pos, nMaxEdit-1-::Pos ) +;
                  Substr( ::xBuffer, nMaxEdit ), ::nMaxLen )
   else
      ::xBuffer := Left( Substr( ::xBuffer, 1, ::Pos-1 ) + cChar + Substr( ::xBuffer, ::Pos ), ::nMaxEdit )
   endif

   // To conform UPDATED() behaviour with that of Clipper
   ::Changed := .T.

   // UPDATED() function previously did not return .T. even if a key press is
   // accepted.
   //   ::Changed := ValType( ::Original ) != ValType( ::unTransform() ) .or.;
   //                !( ::unTransform() == ::Original )
   ::Right( .f. )

   if ::type == "D"
      ::BadDate := IsBadDate( ::xBuffer, ::cPicFunc )
   else
      ::BadDate := .f.
   endif

   ::Display()

return Self

//---------------------------------------------------------------------------//

METHOD _Right( lDisplay ) CLASS Get

   local nPos

   DEFAULT lDisplay TO .t.

   if ! ::hasfocus
      return Self
   endif

   ::TypeOut := .f.
   ::Clear   := .f.

   if ::pos == ::nMaxEdit
      ::TypeOut := .t.
      return Self
   endif

   nPos := ::Pos + 1

   do while ! ::IsEditable( nPos ) .and. nPos <= ::nMaxEdit
      nPos++
   Enddo

   if nPos <= ::nMaxEdit
      ::Pos := nPos
   else
      ::TypeOut := .t.
   endif

   if lDisplay
      ::Display( .f. )
   endif

return Self

//---------------------------------------------------------------------------//

METHOD _Left( lDisplay ) CLASS Get

   local nPos

   DEFAULT lDisplay TO .t.

   if ! ::hasfocus
      return Self
   endif

   ::TypeOut := .f.
   ::Clear   := .f.

   if ::pos == ::FirstEditable( )
      ::TypeOut := .t.
      return Self
   endif

   nPos := ::Pos - 1

   do while ! ::IsEditable( nPos ) .and. nPos > 0
      nPos--
   Enddo

   if nPos > 0
      ::Pos := nPos
   else
      ::TypeOut := .t.
   endif

   if lDisplay
      ::Display( .f. )
   endif

return Self

//---------------------------------------------------------------------------//

METHOD WordLeft() CLASS Get

   local nPos, nFirstEditable

   if ! ::hasfocus
      return Self
   endif

   ::TypeOut := .f.
   ::Clear   := .f.

   nFirstEditable := ::FirstEditable()

   if ::pos == nFirstEditable
      ::TypeOut := .t.
      return Self
   endif

   nPos := ::Pos

   do while nPos > nFirstEditable .and. ( SubStr( ::xBuffer, nPos - 1, 1 ) == " " .or. ! ::IsEditable( nPos - 1 ) )
      nPos--
   enddo

   do while nPos > nFirstEditable .and. ! ( SubStr( ::xBuffer, nPos - 1, 1 ) == " " .or. ! ::IsEditable( nPos - 1 ) )
      nPos--
   enddo

   ::Pos := nPos

   ::Display( .f. )

return Self

//---------------------------------------------------------------------------//

METHOD WordRight() CLASS Get

   local nPos, nLastEditable

   if ! ::hasfocus
      return Self
   endif

   ::TypeOut := .f.
   ::Clear   := .f.

   nLastEditable := ::LastEditable()

   if ::pos == nLastEditable
      ::TypeOut := .t.
      return Self
   endif

   nPos := ::Pos

   do while nPos < nLastEditable .and. ! ( SubStr( ::xBuffer, nPos, 1 ) == " " .or. ! ::IsEditable( nPos ) )
      nPos++
   enddo

   do while nPos < nLastEditable .and. ( SubStr( ::xBuffer, nPos, 1 ) == " " .or. ! ::IsEditable( nPos ) )
      nPos++
   enddo

   ::Pos := nPos

   ::Display( .f. )

return Self

//---------------------------------------------------------------------------//

METHOD ToDecPos() CLASS Get

   if ! ::HasFocus .or. ::DecPos == NIL
      return Self
   endif

   if ::pos == ::FirstEditable( )
      ::DeleteAll()
   endif

   ::TypeOut := .f.
   ::Clear  := .f.
   ::lEdit  := .t.
   ::xBuffer := ::PutMask( ::UnTransform(), .f. )
   ::pos    := ::DecPos + 1

   ::Display( .t. )

return Self

//---------------------------------------------------------------------------//

METHOD IsEditable( nPos ) CLASS Get

   local cChar

   if Empty( ::cPicMask )
      return .t.
   endif

   if ::nMaxEdit == NIL .or. nPos > ::nMaxEdit
      return .f.
   endif

   cChar := UPPER( SubStr( ::cPicMask, nPos, 1 ) )

   Switch ::type
   case "C"
      return cChar IN "!ANXLY9#"
   case "N"
      return cChar IN "9#$*"
   case "D"
      return cChar IN "9"
   case "L"
      return cChar IN "LY"
   end

return .f.

//---------------------------------------------------------------------------//

METHOD Input( cChar ) CLASS Get

   local cPic

   Switch ::type
   case "N"

      Switch cChar
      case "-"
         ::minus := .t.  /* The minus symbol can be write in any place */
         exit

      case "."
      case ","
         ::toDecPos()
         return ""

      case "0"
      case "1"
      case "2"
      case "3"
      case "4"
      case "5"
      case "6"
      case "7"
      case "8"
      case "9"
         exit

      Default
         return ""

      end
      exit

   case "D"

      if !( cChar IN "0123456789" )
         return ""
      endif
      exit

   case "L"

      if !( Upper( cChar ) IN "YNTF"+hb_langmessage( HB_LANG_ITEM_BASE_TEXT + 1 )+hb_langmessage( HB_LANG_ITEM_BASE_TEXT + 2 ) )
         return ""
      endif
      Do Case
         case UPPER( cChar ) == hb_langmessage( HB_LANG_ITEM_BASE_TEXT + 1 )
            cChar := "Y"
         case UPPER( cChar ) == hb_langmessage( HB_LANG_ITEM_BASE_TEXT + 2 )
            cChar := "N"
      endcase
      exit

   end

   if ! Empty( ::cPicFunc )
      // Dirty HACK for solve the the "@RE" TRANSFORMation... "N" -> "  /N  /  "
      if "R" IN ::cPicFunc .AND. "E" IN ::cPicFunc
         cChar := SubStr( Transform( cChar, ::cPicFunc ), 4, 1 ) // Needed for @RE
      else
         cChar := Left( Transform( cChar, ::cPicFunc ), 1 ) // Left needed for @D
      endif
   endif

   if ! Empty( ::cPicMask )
      cPic  := Substr( ::cPicMask, ::pos, 1 )

      //      cChar := Transform( cChar, cPic )
      // Above line eliminated because some get picture template symbols for
      // numeric input not work in text input. eg: $ and *

      Switch cPic
      case "A"
         if ! IsAlpha( cChar )
            cChar := ""
         endif
         exit

      case "N"
         if ! IsAlpha( cChar ) .and. ! IsDigit( cChar )
            cChar := ""
         endif
         exit

      case "9"
         if ! IsDigit( cChar ) .and. cChar != "-"
            cChar := ""
         endif
         exit

      case "#"
         if ! IsDigit( cChar ) .and. !( cChar == " " ) .and. !( cChar IN ".+-" )
            cChar := ""
         endif
         exit

      case "L"
         if !( Upper( cChar ) IN "YNTF"+;
                         hb_langmessage( HB_LANG_ITEM_BASE_TEXT + 1 )+;
                         hb_langmessage( HB_LANG_ITEM_BASE_TEXT + 2 ) )
            cChar := ""
         endif
         exit

      case "Y"
         if !( Upper( cChar ) IN "YN" )
            cChar := ""
         endif
         exit

      case "$"
      case "*"
         if ::type == "N"
            if ! IsDigit( cChar ) .and. cChar != "-"
               cChar := ""
            endif
         else
            cChar := Transform( cChar, cPic )
         endif
         exit

      Default
         cChar := Transform( cChar, cPic )
      end
   endif
return cChar

//---------------------------------------------------------------------------//

METHOD PutMask( xValue, lEdit ) CLASS Get

   local cChar
   local cBuffer
   local cPicFunc
   local cMask
   local cMaskDel

   local nFor
   local nAt
   local nNoEditable := 0


   DEFAULT lEdit  TO ::HasFocus
   DEFAULT xValue TO ::UnTransform()
   DEFAULT xValue TO ::xVarGet
   DEFAULT xValue TO ::VarGet()

   IF ::Type == NIL
      ::Type := ValType( xValue )
      ::Picture := ::cPicture
   ENDIF

   cPicFunc := ::cPicFunc
   cMask    := ::cPicMask

   DEFAULT cMask  TO ""

   if xValue == NIL .OR. ValType( xValue ) IN "AB"
      ::nMaxLen := 0
      return NIL
   endif

   if ::HasFocus
      cPicFunc := StrTran( cPicfunc, "B", "" )
      if cPicFunc == "@"
         cPicFunc := ""
      endif
   endif
   if lEdit .and. ::lEdit
      if ( "*" IN cMask ) .or. ( "$" IN cMask )
         cMask := StrTran( StrTran( cMask, "*", "9" ), "$", "9" )
      endif
   endif

   cBuffer := Transform( xValue, if( Empty( cPicFunc ), if( ::lCleanZero .and. !::HasFocus, "@Z ", "" ), cPicFunc + if( ::lCleanZero .and. !::HasFocus, "Z", "" ) + " " ) + cMask )

   if ::type == "N"
      if ( "(" IN cPicFunc .or. ")" IN cPicFunc ) .and. xValue >= 0
         cBuffer += " "
      endif

      if ( ( "C" IN cPicFunc .and. xValue <  0 ) .or.;
           ( "X" IN cPicFunc .and. xValue >= 0 ) ) .and.;
           !( "X" IN cPicFunc .and. "C" IN cPicFunc )
         cBuffer += "   "
      endif

      if xValue < 0
         ::lMinusPrinted := .t.
      else
         ::lMinusPrinted := .f.
      endif
   endif

   /*
   if ::nMaxLen == NIL
      ::nMaxLen := Len( cBuffer )
   endif
   */

   ::nMaxLen  := Len( cBuffer )
   ::nMaxEdit := ::nMaxLen
   if ::nDispLen == NIL .or. !::lDispLen
      ::nDispLen := ::nMaxLen
   endif


   if lEdit .and. ::type == "N" .and. ! Empty( cMask )
      if "E" IN cPicFunc
         cMask := Left( cMask, ::FirstEditable() - 1 ) + StrTran( SubStr( cMask, ::FirstEditable( ), ::LastEditable( ) - ::FirstEditable( ) + 1 ), ",", chr(1) ) + SubStr( cMask, ::LastEditable() + 1 )
         cMask := Left( cMask, ::FirstEditable() - 1 ) + StrTran( SubStr( cMask, ::FirstEditable( ), ::LastEditable( ) - ::FirstEditable( ) + 1 ), ".", ","    ) + SubStr( cMask, ::LastEditable() + 1 )
         cMask := Left( cMask, ::FirstEditable() - 1 ) + StrTran( SubStr( cMask, ::FirstEditable( ), ::LastEditable( ) - ::FirstEditable( ) + 1 ), chr(1), "." ) + SubStr( cMask, ::LastEditable() + 1 )
      endif
      for each cChar in cMask
         if cChar IN ",." .and. SubStr( cBuffer, HB_EnumIndex(), 1 ) IN ",."
            cBuffer := Substr( cBuffer, 1, HB_EnumIndex() - 1 ) + cChar + Substr( cBuffer, HB_EnumIndex() + 1 )
         endif
      next
      if ::lEdit .and. Empty(xValue)
         cBuffer := StrTran(cBuffer, "0", " ")
      endif
      if ::lDecRev
         cBuffer := Left( cBuffer, ::FirstEditable() - 1 ) + StrTran( SubStr( cBuffer, ::FirstEditable( ), ::LastEditable( ) - ::FirstEditable( ) + 1 ), ",", chr(1) ) + SubStr( cBuffer, ::LastEditable() + 1 )
         cBuffer := Left( cBuffer, ::FirstEditable() - 1 ) + StrTran( SubStr( cBuffer, ::FirstEditable( ), ::LastEditable( ) - ::FirstEditable( ) + 1 ), ".", ","    ) + SubStr( cBuffer, ::LastEditable() + 1 )
         cBuffer := Left( cBuffer, ::FirstEditable() - 1 ) + StrTran( SubStr( cBuffer, ::FirstEditable( ), ::LastEditable( ) - ::FirstEditable( ) + 1 ), chr(1), "." ) + SubStr( cBuffer, ::LastEditable() + 1 )
      endif
   endif

   if ::type == "N"
      if "(" IN ::cPicFunc .or. ")" IN ::cPicFunc
         ::nMaxEdit--
      endif
      if "C" IN ::cPicFunc .or. "X" IN ::cPicFunc
         ::nMaxEdit -= 3
      endif
   endif

   If ::type == "D" .and. ::BadDate .and. ::xBuffer != nil
      cBuffer := ::xBuffer
   Endif

return cBuffer

//---------------------------------------------------------------------------//

METHOD BackSpace( lDisplay ) CLASS Get

   local nPos := ::Pos, nMinus

   DEFAULT lDisplay TO .t.


   if nPos > 1 .and. nPos == ::FirstEditable() .and. ::minus
      /* For delete the parethesis (negative indicator) in a non editable position */

      nMinus := At( "(", SubStr( ::xBuffer, 1, nPos-1 ) )

      if nMinus > 0 .and. SubStr( ::cPicMask, nMinus, 1 ) != "("

         ::lEdit := .t.

         ::xBuffer := SubStr( ::xBuffer, 1, nMinus - 1 ) + " " +;
                     SubStr( ::xBuffer, nMinus + 1 )

         ::Changed := .T.

         if lDisplay
            ::Display()
         endif

         return Self

      endif

   endif

   ::Left()

   if ::Pos < nPos
      ::Delete( lDisplay )
   endif

return Self

//---------------------------------------------------------------------------//

METHOD _Delete( lDisplay ) CLASS Get

   LOCAL nMaxLen := ::nMaxLen, n

   DEFAULT lDisplay TO .t.

   ::Clear := .f.
   ::lEdit := .t.

   if ::lPicComplex
      // Calculating diferent nMaxLen for ::lPicComplex
      for n := ::Pos to nMaxLen
         if !::IsEditable( n )
           exit
         endif
      next
      nMaxLen := n - 1
   endif

   if ::type == "N" .and. SubStr( ::xBuffer, ::Pos, 1 ) IN "(-"
      ::minus := .f.
   endif

   ::xBuffer := PadR( SubStr( ::xBuffer, 1, ::Pos - 1 ) + ;
               SubStr( ::xBuffer, ::Pos + 1, nMaxLen - ::Pos ) + " " +;
               SubStr( ::xBuffer, nMaxLen + 1 ), ::nMaxLen )

   if ::type == "D"
      ::BadDate := IsBadDate( ::xBuffer, ::cPicFunc )
   else
      ::BadDate := .f.
   endif
   ::Changed    := .T.

   if lDisplay
      ::Display()
   endif

return Self

//---------------------------------------------------------------------------//

METHOD DeleteAll() CLASS Get

   local xValue

   ::lEdit := .t.

   Switch ::type
   case "C"
      xValue := Space( ::nMaxlen )
      exit
   case "N"
      xValue  := 0
      ::minus := .f.
      exit
   case "D"
      xValue := CToD( "" )
      ::BadDate := .f.
      exit
   case "L"
      xValue := .f.
      exit
   end

   ::xBuffer := ::PutMask( xValue, .t. )
   ::Pos    := ::FirstEditable( )

return Self

//---------------------------------------------------------------------------//

METHOD DelEnd() CLASS Get

   local nPos := ::Pos

   if ! ::hasfocus
      return Self
   endif

   ::Pos := ::nMaxEdit

   ::Delete( .f. )
   do while ::Pos > nPos
      ::BackSpace( .f. )
   enddo

   ::Display()

return Self

//---------------------------------------------------------------------------//

METHOD DelLeft() CLASS Get

   ::Left( .f. )
   ::Delete( .f. )
   ::Right()

return Self

//---------------------------------------------------------------------------//

METHOD DelRight() CLASS Get

   ::Right( .f. )
   ::Delete( .f. )
   ::Left()

return Self

//---------------------------------------------------------------------------//

METHOD DelWordLeft() CLASS Get

   if ! ::hasfocus
      return Self
   endif

   ::WordLeft()
   ::DelWordRight()

return Self

//---------------------------------------------------------------------------//

METHOD DelWordRight() CLASS Get

   local nCount, nPos

   if ! ::hasfocus
      return Self
   endif

   ::TypeOut := .f.
   ::Clear   := .f.

   if ::pos == ::nMaxEdit
      ::TypeOut := .t.
      return Self
   endif

   // Counts how many characters must be deleted
   nPos := ::Pos
   nCount := 0
   do while nPos <= ::nMaxEdit .and. ! SubStr( ::xBuffer, nPos, 1 ) == " " .and. ::IsEditable( nPos )
      nPos++
      nCount++
   enddo
   do while nPos <= ::nMaxEdit .and. SubStr( ::xBuffer, nPos, 1 ) == " " .and. ::IsEditable( nPos )
      nPos++
      nCount++
   enddo

   do while nCount > 0
      ::Delete( .f. )
      nCount--
   Enddo

   ::Display()

return Self

//---------------------------------------------------------------------------//

/* The METHOD ColorSpec and DATA cColorSpec allow to replace the
 * property ColorSpec for a function to control the content and
 * to carry out certain actions to normalize the data.
 * The particular case is that the function receives a single color and
 * be used for GET_CLR_UNSELECTED and GET_CLR_ENHANCED.
 *
  // QUESTIONS, is realy necessary this method? the ::colorspec generated was
  not clipper 5.x compatible, and also was not respecting SET INTENSITY
*/
METHOD SetColorSpec( cColorSpec ) CLASS Get

//   local cClrUnSel, cClrEnh

   if cColorSpec != NIL

/*      cClrUnSel := iif( !Empty( hb_ColorIndex( cColorSpec, GET_CLR_UNSELECTED ) ),;
                                hb_ColorIndex( cColorSpec, GET_CLR_UNSELECTED ),;
                                hb_ColorIndex( SetColor(), GET_CLR_UNSELECTED ) )

      cClrEnh   := iif( !Empty( hb_ColorIndex( cColorSpec, GET_CLR_ENHANCED ) ),;
                                hb_ColorIndex( cColorSpec, GET_CLR_ENHANCED ),;
                                cClrUnSel )
*/

      ::cColorSpec := buildGetColor(cColorSpec)

   endif

return ::cColorSpec

//---------------------------------------------------------------------------//

/* The METHOD Picture and DATA cPicture allow to replace the
 * property Picture for a function to control the content and
 * to carry out certain actions to normalize the data.
 * The particular case is that the Picture is loaded later on
 * to the creation of the object, being necessary to carry out
 * several tasks to adjust the internal data of the object.
 */

METHOD SetPicture( cPicture ) CLASS Get

   if cPicture != NIL

      ::nDispLen := NIL

      ::cPicture := cPicture

      // if ::xVarGet != NIL
         ::ParsePict( cPicture )
      // endif

//      ::xBuffer  := ::PutMask( )
//      ::nMaxLen := IIF( ::xBuffer == NIL, 0, Len( ::xBuffer ) )

      if ::nDispLen == NIL .or. !::lDispLen
         ::nDispLen := ::nMaxLen
      endif

   endif

return ::cPicture

//---------------------------------------------------------------------------//

#ifdef HB_COMPAT_C53
METHOD HitTest( mRow, mCol ) CLASS GET

    IF ( Valtype( ::Control ) == "O" )
        Return ::Control:HitTest( mRow, mCol )
    ENDIF

    IF ::Row != mRow
        return HTNOWHERE
    ENDIF

    IF ::nDispLen == NIL
        ::nDispLen := 1
    ENDIF

    IF mCol >= ::Col .AND. mCol <= ::Col + ::nDispLen + IIF( ::cDelimit == NIL, 0, 2 )
       return HTCLIENT
    ENDIF

return HTNOWHERE
#endif

//---------------------------------------------------------------------------//

METHOD FirstEditable( ) CLASS GET

   Local nFor

   If ::nMaxLen != NIL

      If ::IsEditable( 1 )
         return 1
      Endif

      For nFor := 2 to ::nMaxLen
         If ::IsEditable( nFor )
            Return nFor
         Endif
      Next

   Endif

   ::TypeOut := .t.

 Return 0

//---------------------------------------------------------------------------//

METHOD LastEditable( ) CLASS GET

   Local nFor

   If ::nMaxLen != NIL

      For nFor := ::nMaxLen to 1 step -1
         If ::IsEditable( nFor )
            Return nFor
         Endif
      Next

   Endif

   ::TypeOut := .t.

 Return 0

//---------------------------------------------------------------------------//

STATIC FUNCTION IsBadDate( cBuffer, cPicFunc )

   local nFor, nLen

   if "E" IN cPicFunc
      cBuffer := SubStr( cBuffer, 4, 3 ) + SubStr( cBuffer, 1, 3 ) + SubStr( cBuffer, 7 )
   endif

   If !Empty( Ctod( cBuffer ) )
      return .f.
   Endif

   nLen := len( cBuffer )

   For nFor := 1 to nLen
      If IsDigit( Substr( cBuffer, nFor, 1 ) )
         return .t.
      Endif
   Next

 return .f.

/*
static procedure AnalyzePicture( cPicture )
   Local cChar, lS := .f.

   For each cChar in Substr( cPicture, 2 )
      do case
      case cChar == "S"
         lS := .t.
      case cChar $ "!()L0ABCDEKRXZ"
         lS := .f.
      case cChar $ "0123456789" .and. lS
      other
         cPicture := Left( cPicture, HB_EnumIndex() )
      endcase
   Next
Return
*/

STATIC FUNCTION BuildGetColor( cColorSpec )
   Local cCur
   Local aTokens

   If ! ValType( cColorSpec ) == "C"
      cColorSpec := Nil                          // Clipper compatibility
   Endif

   cCur := SetColor()

   If Set( _SET_INTENSITY )

      Default cColorSpec To __guiColor( cCur, CLR_UNSELECTED + 1 ) +","+;
                            __guiColor( cCur, CLR_ENHANCED   + 1 ) +","+;
                            __guiColor( cCur, CLR_STANDARD   + 1 ) +","+;
                            __guiColor( cCur, CLR_BACKGROUND + 1 )

   Else
      Default cColorSpec To __guiColor( cCur, CLR_STANDARD   + 1 )

   Endif

                          /* NOTE */
   aTokens := HB_ATOKENS( cCur := Upper( cColorSpec ), "," )

   If Len( aTokens ) == 1
      cColorSpec := cCur + "," + cCur + "," + cCur + "," + cCur

   Elseif Len( aTokens ) == 2
      cColorSpec := cCur + "," + aTokens[ 1 ] + "," + aTokens[ 1 ]

   Elseif Len( aTokens ) == 3
      cColorSpec := cCur + "," + aTokens[ 1 ]

   Else
      cColorSpec := aTokens[1] + "," + aTokens[2] + "," + ;
                    aTokens[3] + "," + aTokens[4]

   Endif

Return cColorSpec


#ifdef HB_COMPAT_C53

FUNCTION __GuiColor( cPair, nPos )
RETURN hb_colorindex( cpair, npos - 1 )

FUNCTION Isdefcolor()
RETURN Upper( SetColor() ) == "W/N,N/W,N/N,N/N,N/W"

#endif

