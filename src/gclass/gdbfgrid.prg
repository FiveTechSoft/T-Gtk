/* $Id: gdbfgrid.prg,v 1.3 2010-12-24 01:06:17 dgarciagil Exp $*/
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
    Browse a la Dbf
    (c)2005 Joaquim Ferrer Godoy <quim_ferrer@yahoo.es>
*/

#include "hbclass.ch"
#include "dbstruct.ch"
#include "gtkapi.ch"

#define SCROLL_VERTICAL  1

#define COL_TYPE_TEXT    0
#define COL_TYPE_CHECK   1
#define COL_TYPE_SHADOW  2
#define COL_TYPE_BOX     3
#define COL_TYPE_RADIO   4
#define COL_TYPE_BITMAP  5

#define DATATYPE_RDD     1
#define DATATYPE_ODBF    2
#define DATATYPE_ARRAY   3
#define DATATYPE_OBJECT  4
#define DATATYPE_MYSQL   5

CLASS gDbfGrid FROM gWidget

   DATA   hParent, hWnd, hContainer
   DATA   oScroll, oBox
   DATA   aColumns, aHeaders, abFields, aColSizes, aDbfStruct
   DATA   cAlias, nArea
   DATA   bSkip, bChange, bGoTop, bGoBottom, bLogicLen
   DATA   bKeyEvent, bGotFocus, bLostFocus
   DATA   lHitTop, lHitBottom
   DATA   lPaint AS LOGICAL INIT .T.
   DATA   lArrow AS LOGICAL INIT .T.
   DATA   lFocus AS LOGICAL INIT .F.
   DATA   nLen, nColumns, nRowPos, nColPos, nAt, nWidth, nHeight
   DATA   nFontSize  AS NUMERIC INIT 8
   DATA   nLineStyle AS NUMERIC INIT 1
   DATA   nDataType, uData


   METHOD New( hParent, nRow, nCol, aHeaders, aColSizes, abFields, cAlias, ;
               nWidth, nHeight, bChange, cFont, uClrFore, uClrBack ) CONSTRUCTOR

   METHOD AddColumn( oCol ) INLINE AAdd( ::aColumns, oCol )
   METHOD LoadColumns()
/**
 * LoadColumns()
 * Nos permite crear si queremos las columnas y encabezados en el metodo New()
 * asi desde el preprocesado se puede construir desde comando xBase.
 * Tambien provee la creacion de las columnas y headers 'despues' del metodo New()
 * por lo que da mayor flexibilidad
 **/

   METHOD DrawHeaders( nPEvent )
   METHOD DrawLine( nRow )
   METHOD DrawRows()
   METHOD DrawSelect() INLINE If( ::lFocus, ::DrawLine( ::nRowPos, .t. ), )
   METHOD SetFont( cFont )
   METHOD Set3DLook()  INLINE aeval( ::aColumns, {|oCol| oCol:nColType := COL_TYPE_BOX } )
   METHOD SetColor( uClrFore, uClrBack )

   METHOD GoUp()
   METHOD GoDown()
   METHOD GoTop()
   METHOD GoBottom()
   METHOD GoLeft()
   METHOD GoRight()
   METHOD Skip( n )

   METHOD SetDbf( uDatabase )
   METHOD SetoDBF( uDatabase )
   METHOD SetArray( aArray )
   METHOD SetDolphin( oRS )

   METHOD KeyEvent( nKey )
   METHOD ClickEvent( nRow, nCol, nWidth, nHeight )
   METHOD ScrollEvent( nOrientation, nValue )
   METHOD ColResizEvent( nCol, nValue )

   METHOD GotFocus()
   METHOD LostFocus()

   METHOD nRowCount()           INLINE gtk_browse_row_count( ::hWnd )
   METHOD nRowHeight( nHeight ) INLINE gtk_browse_row_height( nHeight )

   METHOD PageDown( nLines )
   METHOD PageUp( nLines )

   METHOD Paint( nPEvent )
   METHOD SetFocus()            INLINE gtk_widget_grab_focus( ::hWnd )
   METHOD SetDataSrc( uDataSrc )


   METHOD UpStable()
   METHOD Refresh()             INLINE gtk_widget_queue_draw( ::hWnd )

ENDCLASS

//------------------------------------------------------//

function DbfBrowse( uData )

   local oWnd
   local cTitle
   local oBrw

   DEFAULT  uData    := Alias()

   cTitle = If( ValType( uData ) == 'C', uData, ;
                If( ValType( uData ) == 'O', uData:ClassName(), 'DbfBrowse' ) )

   oWnd = gWindow():New( cTitle, , 640, 480 )


   oBrw = gDbfGrid():New( oWnd, , , , , , uData, , , , , , , .T., .T., , .T., , , , , , , , , , , , ,  )

   //center, ! maximized, modal
   oWnd:Activate(, .T., .F., .F., .T. )

return nil


//------------------------------------------------------//

METHOD SetDataSrc( uDataSrc ) class gDbfGrid

   local cType
   local cClass

   cType = ValType( uDataSrc )

   switch cType

      case "C"

         ::cAlias     = uDataSrc
         ::nArea      = Select( uDataSrc )

         if ! Empty( uDataSrc )
            ::aDbfStruct = ( ::cAlias )->( dbstruct() )
            ::nArea      = Select( uDataSrc )
         endif

         ::nDataType := DATATYPE_RDD
         ::SetDbf()
         eval( ::bGoTop )
         exit

      case "A"
         ::nDataType := DATATYPE_ARRAY
         uDataSrc = CheckArray( uDataSrc )
         ::SetArray( uDataSrc )
         exit

      case "O"

         cClass = uDataSrc:ClassName()
         switch cClass
            case "TDATABASE"
               ::nDataType = DATATYPE_ODBF
               ::SetoDBF( uDataSrc )
               eval( ::bGoTop )
               exit
            case "TDOLPHINQRY"
               ::nDataType = DATATYPE_MYSQL
               ::SetDolphin( uDataSrc )
               eval( ::bGoTop )
               exit
         endswitch

   endswitch


return nil


//------------------------------------------------------//

METHOD New( uParent, nRow, nCol, aHeaders, aColSizes, abFields, cAlias, nWidth,;
            nHeight, bChange, cFont, uClrFore, uClrBack,;
            lExpand, lFill, nPadding ,lContainer,;
            x, y, uLabelTab , lEnd, lSecond, lResize, lShrink,;
            left_ta,right_ta,top_ta,bottom_ta,xOptions_ta,yOptions_ta ) CLASS gDbfGrid


   DEFAULT cAlias := NIL, nWidth := 200, nHeight := 200

   ::hParent := uParent:pWidget

   ::hWnd       = gtk_browse_new( Self )
   ::pWidget    := ::hWnd

   ::aColumns   = {}
   ::nColumns   = 0
/*
   ::cAlias     = cAlias
   ::nArea      = Select()

   if !Empty( cAlias )
      ::aDbfStruct = ( ::cAlias )->( dbstruct() )
      ::nArea      = Select( cAlias )
   endif
*/


   ::lHitTop    = .f.
   ::lHitBottom = .f.
   ::nRowPos    = 1
   ::nColPos    = 1
   ::nWidth     = nWidth
   ::nHeight    = nHeight
   ::aHeaders   = CheckArray( aHeaders )
   ::abFields   = CheckArray( abFields )
   ::aColSizes  = CheckArray( aColSizes )
   ::bChange    = bChange


   ::oScroll := TScrolledBar():New()
   gtk_browse_scroll_connect( ::pWidget, ::oScroll:hWnd )

   ::oBox := GBoxVH():New(.T.,,.T., uParent, lExpand, lFill, nPadding, lContainer, x, y,uLabelTab,;
                lSecond, lResize, lShrink, left_ta, right_ta, top_ta, bottom_ta, xOptions_ta, yOptions_ta )   // Meto la caja , en el Parent

   gtk_box_pack_start( ::oBox:pWidget, ::oScroll:hWnd, .T., .T., .F. )     // Meto en la caja, el scroll
   gtk_container_add( ::oScroll:hWnd, ::pWidget )                          // Meto en el scroll, el browse
   ::oBox:Show()                                                           // Mostramos la caja
   ::Show()                                                                // Mostramos el Browse


   ::SetDataSrc( cAlias )

/*
   if !empty( cAlias )
      ::SetDbf()
      eval( ::bGoTop )
   endif
*/


   if cFont != NIL
      ::SetFont( cFont )
      ::nRowHeight( ::nFontSize * 2 ) // Acomodamos tamaño de la fuente
   endif

   ::LoadColumns()

   if uClrFore != NIL
      ::SetColor( uClrFore, uClrBack )
   endif

return Self

//------------------------------------------------------//

METHOD LoadColumns() CLASS gDbfGrid

   local n, oColumn
   if ::aHeaders != NIL
      ::nColumns := len( ::aHeaders )
      for n = 1 to ::nColumns
          oColumn := DbfGridColumn():New( ::aHeaders[ n ] )
          AAdd( ::aColumns, oColumn )
          if len( ::abFields ) > 0
             oColumn:uData = ::abFields[ n ]
          endif
          if Len( ::aColSizes ) > 0
             oColumn:nWidth = ::aColSizes[ n ]
          else
             if ::cAlias != "" .and. ::uData == NIL
                // * ancho de la fuente <-> 20 es el ancho 'minimo'
                oColumn:nWidth = Max( Max( Len( ::aHeaders[ n ] ) * ::nFontSize  + 2 * ::nFontSize, ;
                                      (::aDbfStruct[n, DBS_LEN] * ::nFontSize) + 2 * ::nFontSize ), 20 )
                if oColumn:nHeadWidth > oColumn:nWidth
                   oColumn:nWidth = oColumn:nHeadWidth
                endif
             else
                oColumn:nWidth = Max( Max( Len( ::aHeaders[ n ] ) * ::nFontSize  + 2 * ::nFontSize, ;
                                      Len( cValToChar( Eval( oColumn:uData ) ) ) * ::nFontSize + 2 * ::nFontSize ), 20 )
             endif
          endif
      next
   endif


return nil

//------------------------------------------------------//

METHOD DrawHeaders( nPEvent ) CLASS gDbfGrid

   local aHeaders := {}, aColSizes := {}, aBmpFiles := {}
   local n

   for n = 1 to Len( ::aColumns )
      AAdd( aHeaders, ::aColumns[ n ]:cHeading )
      AAdd( aColSizes, ::aColumns[ n ]:nWidth )
      AAdd( aBmpFiles, ::aColumns[ n ]:cBmpFile )
   next

   gtk_browse_drawheaders( ::hWnd, nPEvent, aHeaders, aColSizes, aBmpFiles, ::nColPos, ::lArrow )

return nil

//------------------------------------------------------//

METHOD DrawLine( nRow, lSelected ) CLASS gDbfGrid

   local n := ::nColPos, nColPos := 1, nWidth := ::nWidth,;
              nCols := Len( ::aColumns )
   local uFieldGet, uType
   local hWnd := ::hWnd, nRowAct := ::nRowPos
   local cfgColor, cbgColor

   DEFAULT nRow := ::nRowPos, lSelected := .f.

   while nColPos < nWidth .and. n <= nCols

      if "BLOCK" $ ::aColumns[ n ]:uData:ClassName()
         uFieldGet := eval( ::aColumns[ n ]:uData )
      elseif "ARRAY" $ ::aColumns[ n ]:uData:ClassName()
         uFieldGet := ::aColumns[ n ]:uData[ ::nAt ]
      endif
      uType := valtype( uFieldGet )

      do case
         case uType == "N" .AND. ::aColumns[ n ]:nColType != COL_TYPE_BITMAP
              uFieldGet = str( uFieldGet )
         case uType == "L"
              if ::aColumns[ n ]:nColType == COL_TYPE_TEXT
                 uFieldGet = if( uFieldGet, ".T.", ".F." )
              endif
         case uType == "D"
              uFieldGet = dtoc( uFieldGet )
      endcase

      cfgColor := if( valtype( ::aColumns[ n ]:cfgColor ) = "B",;
                      Eval(  ::aColumns[ n ]:cfgColor ), ::aColumns[ n ]:cfgColor )

      cbgColor := if( valtype( ::aColumns[ n ]:cbgColor ) = "B",;
                      Eval(  ::aColumns[ n ]:cbgColor ), ::aColumns[ n ]:cbgColor )

      gtk_browse_drawcell( hWnd, nRow, nColPos,;
                           uFieldGet, ;
                           If( n == Len( ::aColumns ) .or. ;
                           nColPos + ::aColumns[ n ]:nWidth > ::nWidth,;
                           ::nWidth - nColPos -2,;
                           ::aColumns[ n ]:nWidth -2 ), ;
                           If( lSelected, ::aColumns[ n ]:lDrawSelect, lSelected ),;
                           ::lArrow, ;
                           ::aColumns[ n ]:nColType, ;
                           cfgColor, ;
                           cbgColor, ;
                           ::nLineStyle )

      nColPos += ::aColumns[ n++ ]:nWidth
   enddo

return nil

//------------------------------------------------------//

METHOD DrawRows() CLASS gDbfGrid

   local n := 1, nLines := ::nRowCount(), nSkipped := 1

   if ( ::nLen := Eval( ::bLogicLen, Self ) ) > 0

      ::Skip( 1 - ::nRowPos )

      while n <= nLines .and. nSkipped == 1
         ::DrawLine( n )
         nSkipped = ::Skip( 1 )

         if nSkipped == 1
            n++
         else
            exit
         endif
      end
      ::Skip( ::nRowPos - n )

      if ::nLen < ::nRowPos
         ::nRowPos = ::nLen
      endif
      ::lFocus := .t.
      ::DrawSelect()
   endif

   if ! empty( ::cAlias )
      ::lHitTop    = ( ::cAlias )->( BoF() )
      ::lHitBottom = ( ::cAlias )->( EoF() )
   endif

return nil

//------------------------------------------------------//

METHOD SetFont( cFont ) CLASS gDbfGrid

   gtk_browse_set_font( ::hWnd, cFont )
   ::nFontSize = gtk_browse_get_font_size( ::hWnd )

return nil

//------------------------------------------------------//

METHOD SetColor( uClrFore, uClrBack ) CLASS gDbfGrid
    Local i
    // Ponemos TODAS las columnas de el color pasado.
    For i = 1 TO Len( ::aColumns )
        ::aColumns[ i ]:cfgColor := uClrFore
        if uClrBack != NIL
          ::aColumns[ i ]:cbgColor := uClrBack
        endif
    Next

return nil

//------------------------------------------------------//

METHOD GoUp() CLASS gDbfGrid

   local nLines := ::nRowCount()

   if ( ::nLen := Eval( ::bLogicLen, Self ) ) < 1
      return nil
   endif

   if ! ::lHitTop
      ::DrawLine()
      if ::Skip( -1 ) == -1
         ::lHitBottom = .f.
         if ::nRowPos > 1 // Si hay header, si no 0 )
            ::nRowPos--
         else
            gtk_browse_ScrollUp( ::hWnd, nLines )
         endif
         if ::oScroll != NIL
            ::oScroll:GoUp()
         endif
      else
         ::lHitTop = .t.
      endif

      ::DrawSelect()

      if ::bChange != nil
         Eval( ::bChange, Self )
      endif
   endif

return nil

//------------------------------------------------------//

METHOD GoDown() CLASS gDbfGrid

  local nLines := ::nRowCount() - 1

   if ( ::nLen := Eval( ::bLogicLen, Self ) ) < 1
      return nil
   endif

   if ! ::lHitBottom
      ::DrawLine()
      if ::Skip( 1 ) == 1
         ::lHitTop = .f.
         if ::nRowPos < nLines
            ::nRowPos++
         else
            gtk_browse_ScrollDown( ::hWnd )
         endif
         if ::oScroll != NIL
            ::oScroll:GoDown()
         endif
      else
         ::lHitBottom = .t.
      endif

      ::DrawSelect()

      if ::bChange != nil
         Eval( ::bChange, Self )
      endif
   endif

return nil

//------------------------------------------------------//

METHOD GoTop() CLASS gDbfGrid

   if ( ::nLen := Eval( ::bLogicLen, Self ) ) < 1
      return nil
   endif

   if ! ::lHitTop
      Eval( ::bGoTop, Self )
      ::lHitBottom = .f.
      ::lHitTop    = .t.
      ::nRowPos    = 1

      if ::bChange != nil
         Eval( ::bChange, Self )
      endif
      if ::oScroll != NIL
         ::oScroll:SetAdjustment( len( ::aColumns ), ::nLen )
         ::oScroll:GoTo( 1 )
      endif

      ::Refresh()
   endif

return nil

//------------------------------------------------------//

METHOD GoBottom() CLASS gDbfGrid

   local nSkipped
   local nLines := ::nRowCount() - 1
   local n

   if ( ::nLen := Eval( ::bLogicLen, Self ) ) < 1
      return nil
   endif

   if ! ::lHitBottom
      Eval( ::bGoBottom, Self )
      ::lHitBottom = .t.
      ::lHitTop    = .f.

      nSkipped = ::Skip( -( nLines - 1 ) )
      ::nRowPos = 1 - nSkipped

      for n = 1 to -nSkipped + 1
          ::DrawLine( n )
          ::Skip( 1 )
      next
      ::DrawSelect()

      if ::bChange != nil
         Eval( ::bChange, Self )
      endif
      if ::oScroll != NIL
         ::oScroll:GoTo( ::nLen )
      endif
   endif

return nil

//------------------------------------------------------//

METHOD GoLeft() CLASS gDbfGrid

   if ::nColPos > 1
      ::nColPos--
      ::Refresh()
      if ::oScroll != NIL
         ::oScroll:GoLeft()
      endif
   endif

return nil

//------------------------------------------------------//

METHOD GoRight() CLASS gDbfGrid

   if ::nColPos < Len( ::aColumns )
      ::nColPos++
      ::Refresh()
      if ::oScroll != NIL
         ::oScroll:GoRight()
      endif
   endif

return nil

//------------------------------------------------------//

METHOD PageUp( nLines ) CLASS gDbfGrid

   local nSkipped

   DEFAULT nLines := ::nRowCount() - 1

   nSkipped = ::Skip( -nLines )

   if ( ::nLen := Eval( ::bLogicLen, Self ) ) < 1
      return nil
   endif

   if ! ::lHitTop
      if nSkipped == 0
         ::lHitTop = .t.
      else
         ::lHitBottom = .f.
         if -nSkipped < nLines
            ::nRowPos = 1

         else
            nSkipped = ::Skip( -nLines )
            ::Skip( -nSkipped )

         endif
	 ::DrawRows()
	 ::DrawSelect()
         if ::bChange != nil
            Eval( ::bChange, Self )
         endif
      endif
      if ::oScroll != NIL
         ::oScroll:nVvalue -= nLines
         ::oScroll:GoTo( ::oScroll:nVvalue )
      endif

   endif

return nil

//------------------------------------------------------//

METHOD PageDown( nLines ) CLASS gDbfGrid

   local nSkipped, n

   DEFAULT nLines := ::nRowCount() - 1
   if ( ::nLen := Eval( ::bLogicLen, Self ) ) < 1
      return nil
   endif

   if ! ::lHitBottom
      ::DrawLine()
      nSkipped = ::Skip( ( nLines * 2 ) - ::nRowPos )

      if nSkipped != 0
         ::lHitTop = .f.
      endif

      do case
         case nSkipped == 0 .or. nSkipped < nLines
              if nLines - ::nRowPos < nSkipped
                 ::Skip( -( nLines ) )
                 for n = 1 to ( nLines - 1 )
                     ::Skip( 1 )
                     ::DrawLine( n )
                 next
                 ::Skip( 1 )
              endif
              ::nRowPos = Min( ::nRowPos + nSkipped, nLines )
              ::lHitBottom = .t.

         otherwise
              for n = nLines to 1 step -1
                  ::DrawLine( n )
                  ::Skip( -1 )
              next
              ::Skip( ::nRowPos )
      endcase

      if ::bChange != nil
         Eval( ::bChange, Self )
      endif
      if ::oScroll != NIL
         ::oScroll:nVvalue += nLines
         ::oScroll:GoTo( ::oScroll:nVvalue )
      endif

      ::DrawSelect()
   endif

return nil

//------------------------------------------------------//

METHOD KeyEvent( nKey ) CLASS gDbfGrid

   if ::bKeyEvent != nil
      Eval( ::bKeyEvent, Self , nKey )
   endif
  
   do case
      case nKey == K_UP       ; ::GoUp()     ; return .T.
      case nKey == K_DOWN     ; ::GoDown()   ; return .T.
      case nKey == K_HOME     ; ::GoTop()    ; return .T.
      case nKey == K_END      ; ::GoBottom() ; return .T.
      case nKey == K_PAGEUP   ; ::PageUp()   ; return .T.
      case nKey == K_PAGEDOWN ; ::PageDown() ; return .T.
      case nKey == K_LEFT     ; ::GoLeft()   ; return .T.
      case nKey == K_RIGHT    ; ::GoRight()  ; return .T.
   endcase

Return .F.

//------------------------------------------------------//

METHOD ClickEvent( nRow, nCol, nWidth, nHeight ) CLASS gDbfGrid

   local nRowAt   := int( nRow / ::nRowHeight )
   local nSkipped, nValue

   ::SetFocus()
   ::nHeight = nHeight

   ::nLen := Eval( ::bLogicLen, Self )			// Modif fjdemaussion
							// Si no hay datos en el brows daba error
   if nRowAt == 0 .or. nRowAt == ::nRowPos .or. nRowAt > ::nLen
      return nil
   endif
  
   ::DrawLine()
   if ( nSkipped := ::Skip( nRowAt - ::nRowPos ) ) != 0
      ::nRowPos  := nRowAt
   endif
   
   if ::bChange != nil
       Eval( ::bChange, Self )
   endif
   
   ::DrawSelect()
   
   if ::oScroll != NIL
      ::oScroll:nVvalue := gtk_adjustment_get_value( ::oScroll:hVadjust )
      ::oScroll:nVvalue += nSkipped
      gtk_adjustment_set_value( ::oScroll:hVadjust, ::oScroll:nVvalue )
   endif
   
return nil

//------------------------------------------------------//

METHOD ScrollEvent( nOrientation, nValue ) CLASS gDbfGrid

   if nOrientation == SCROLL_VERTICAL
 
      if nValue - ::oScroll:nVvalue != 0
         if ::Skip( nValue - ::oScroll:nVvalue ) != 0
            ::DrawRows()
         endif 
         if ::nLen   == nValue
            ::nRowPos = ::nRowCount() -1
            ::DrawRows()
         endif   
         ::oScroll:nVvalue := nValue
         
         if ::bChange != NIL
            Eval( ::bChange, Self )
         endif

      endif
      
   else

      if nValue != ::oScroll:nHvalue
         ::nColPos         = nValue
         ::oScroll:nHvalue = nValue
         ::Refresh()
      endif

  endif

return nil

//------------------------------------------------------//

METHOD ColResizEvent( nCol, nValue ) CLASS gDbfGrid

  if nCol > 0
     ::aColumns [ nCol ]:nWidth += nValue
  endif 
   //::aColSizes[ nCol ]:= nValue

return nil

//------------------------------------------------------//

METHOD GotFocus() CLASS gDbfGrid

   if ( ::nLen := Eval( ::bLogicLen, Self ) ) < 1	// Modif fjdemaussion
      return nil					// Si no hay datos en el brows daba error
   endif
  ::lFocus = .t.
  if ::bChange != nil
     Eval( ::bChange, Self )
  endif
  if ::bGotFocus != NIL
     eval( ::bGotFocus, Self )
  endif   
  ::DrawLine( ::nRowPos, .t. )
 
return( .t. )

//------------------------------------------------------//

METHOD LostFocus() CLASS gDbfGrid
  

   if ( ::nLen := Eval( ::bLogicLen, Self ) ) < 1	// Modif fjdemaussion
      return nil					// Si no hay datos en el brows daba error
   endif
  ::lFocus = .f.
  if ::bLostFocus != NIL
     eval( ::bLostFocus, Self )
  endif 
  ::DrawLine( ::nRowPos, .t. ) 

return( .t. )

//------------------------------------------------------//

METHOD Paint( nPEvent, nWidth ) CLASS gDbfGrid

  ::nWidth = nWidth
  
  if ::oScroll != NIL
     ::oScroll:SetAdjustment( len( ::aColumns ), eval( ::bLogicLen ) )   
  endif
  
  ::DrawHeaders( nPEvent )
  ::DrawRows()

return nil

//------------------------------------------------------//

METHOD UpStable() CLASS gDbfGrid

 local nRecNo := ( ::cAlias )->( RecNo() )
 local nVSkip := 1

  if !empty( ::cAlias )
     ( ::cAlias )->( dbgotop() )
     do while ! ( ::cAlias )->( eof() )
        if nRecNo == ( ::cAlias )->( RecNo() )
           ( ::cAlias )->( dbgoto( nRecNo ) )
           exit
        else
           ( ::cAlias )->( DbSkip() )
        endif
      nVSkip++
     enddo

     ::nLen := eval( ::bLogicLen, Self )
     if ::oScroll != NIL
        ::oScroll:SetAdjustment( len( ::aColumns ), ::nLen ) 
        ::oScroll:GoTo( nVSkip )
     endif   

     if ::bChange != nil
        Eval( ::bChange, Self )
     endif
   
     ::Refresh()
  endif
   
return nil

//------------------------------------------------------//

METHOD Skip( n ) CLASS gDbfGrid

   if ::bSkip != nil
      return Eval( ::bSkip, n, Self )
   endif

return If( ! Empty( ::cAlias ), ( ::cAlias )->( DBSkipper( n ) ), 0 )

//------------------------------------------------------//

METHOD SetDbf( uDatabase ) CLASS gDbfGrid

   local n
   local aFlds

   if uDatabase == NIL .or. !empty( ::cAlias )  
      ::bGoBottom  = { || ( ::cAlias )->( DbGoBottom() ) }
      ::bGoTop     = { || ( ::cAlias )->( DbGoTop() ) }
      ::bLogicLen  = { || ( ::cAlias )->( OrdKeyCount() ) }   
      if Len( ::aHeaders ) == 0
         for n = 1 to Len( ::aDbfStruct ) 
            AAdd( ::aHeaders, ::aDbfStruct[ n ][ DBS_NAME ] )
         next
      endif
      if Len( ::abFields ) == 0
         for n = 1 to Len( ::aHeaders )
            AAdd( ::abFields, FieldWBlock( ::aDbfStruct[ n ][ DBS_NAME ] , ::nArea ) )                  
         next
      else 
         aFlds = ::abFields[ 1 ]
         if ValType( aFlds ) == "B"
            aFlds = Eval( ::abFields[ 1 ] )
            if ValType( aFlds ) == "A"
               ::abFields = aFlds 
            endif
         endif
      endif
     
      ::uData = NIL
   else
      ::SetoDBF( uDatabase ) 
   endif
   
return nil

//------------------------------------------------------//

METHOD SetoDBF( uDatabase ) CLASS gDbfGrid

   if valtype( uDatabase ) == "O"
      if upper( uDatabase:ClassName() ) == "TDATABASE"
         ::bLogicLen = { || uDatabase:RecCount() }
         ::bGoTop    = { || uDatabase:GoTop() }
         ::bGoBottom = { || uDatabase:GoBottom() }
         ::bSkip     = { | nSkip | uDatabase:Skipper( nSkip ) }
      endif
   endif

return nil 

//------------------------------------------------------//

METHOD SetDolphin( oRS ) CLASS gDbfGrid

   local n

   ::uData = oRS

   ::bLogicLen = { || oRS:RecCount() }
   ::bGoTop    = { || If( oRS:LastRec() > 0, oRS:GoTop(), NIL ) }
   ::bGoBottom = { || If( oRS:LastRec() > 0, oRS:GoBottom(), nil ) }
   if oRS:lPagination
      ::bSkip     = {| n | If ( n != NIL, If( n + oRS:nRecNo < 1 .AND. oRS:nCurrentPage > 1,;
                                         ( oRS:PrevPage(, .T. ), 0 ), ;
                                         If( n + oRS:nRecNo > oRS:nRecCount .AND. oRS:nCurrentPage < oRS:nTotalRows,;
                                             ( oRS:NextPage( , .T. ), 0 ), oRS:Skip( n ) ) ), oRS:Skip( n ) )  }
   else
      ::bSkip     = {| n | oRS:Skip( n ) }
   endif

   if Len( ::aHeaders ) == 0
      for n = 1 to Len( oRS:aStructure ) 
         AAdd( ::aHeaders, oRS:aStructure[ n ][ 1 ] )
      next
      if Len( ::abFields ) == 0
         for n = 1 to Len( ::aHeaders )
            AAdd( ::abFields, AddDataDolphin( Self, n ) )                  
         next
      endif
   endif

return nil 

//------------------------------------------------------//
 
METHOD SetArray( aArray ) CLASS gDbfGrid

 local n, nLen
 
   ::uData = aArray

   for n := 1 to ::nColumns
       ::aColumns[ n ]:uData := aArray[ n ]
   next    
 
   ::cAlias    = ""
   ::nAt       = 1
   ::bLogicLen = { || ::nLen := len( aArray[1] ) }
   ::bGoTop    = { || ::nAt  := 1 }
   ::bGoBottom = { || ::nAt  := eval( ::bLogicLen ) }
   ::bSkip     = { | nSkip, nOld | nOld := ::nAt, ::nAt += nSkip,;
                   ::nAt := Min( Max( ::nAt, 1 ), eval( ::bLogicLen, Self ) ),;
                   ::nAt - nOld }
   if Len( ::aHeaders ) == 0
      
      if ValType( aArray[ 1 ] ) != "C"
         nLen = Len( aArray[ 1 ] ) 
      else 
         nLen = 1 
      endif
      
      for n = 1 to nLen
         AAdd( ::aHeaders, "Col-" + AllTrim( Str( n ) ) )
      next
      if Len( ::abFields ) == 0
         for n = 1 to Len( ::aHeaders )
            AAdd( ::abFields, AddDataArray( Self, n ) )                  
         next
      endif
   endif

return nil

//------------------------------------------------------//

static function CheckArray( aArray )
   
   if ValType( aArray ) == 'A' .and. ;
      Len( aArray ) == 1 .and. ;
      ValType( aArray[ 1 ] ) == 'A'
      aArray   = aArray[ 1 ]
   elseif ValType( aArray ) == "U"
      aArray = {}
   endif

return aArray

//------------------------------------------------------//

static function AddDataArray( Self, n ) 
   if ValType( ::uData[ ::nAt ] ) == "A" 
      return  { || ::uData[ ::nAt ][ n ] }
   else 
      return  { || ::uData[ ::nAt ] }
   endif 
return nil

//------------------------------------------------------//

static function AddDataDolphin( Self, n ) 
return  { || ::uData:FieldGet( n ) }

//------------------------------------------------------//


