#include "pdf.ch"

memvar aReport

/*
function pdfAtSay( cString, nRow, nCol, cUnits, lExact )
function pdfBold()
function pdfBoldItalic()
function pdfBookAdd( cTitle, nLevel, nPage, nLine )
function pdfBookClose( )
function pdfBookCount( nRecno, nCurLevel )
function pdfBookFirst( nRecno, nCurLevel, nObj )
function pdfBookLast( nRecno, nCurLevel, nObj )
function pdfBookNext( nRecno, nCurLevel, nObj )
function pdfBookOpen( )
function pdfBookParent( nRecno, nCurLevel, nObj )
function pdfBookPrev( nRecno, nCurLevel, nObj )
function pdfBox( x1, y1, x2, y2, nBorder, nShade, cUnits )
function pdfCenter( cString, nRow, nCol, cUnits, lExact )
function pdfCheckLine( nRow )
function pdfClose()
function pdfClosePage()
function pdfGetFontInfo( cParam )
function pdfItalic()
function pdfLen( cString )
function pdfM2X( n )
function pdfM2Y( n )
function pdfNewPage( _cPageSize, _cPageOrient, _nLpi, _cFontName, _nFontType, _nFontSize )
function pdfNormal()
function pdfOpen()
function pdfPageSize( _cPageSize )
function pdfPageOrient( _cPageOrient )
function pdfR2D( nRow )
function pdfR2M( nRow )
function pdfReverse( cString )
function pdfRJust( cString, nRow, nCol, cUnits, lExact )
function pdfSetFont( _cFont, _nType, _nSize )
function pdfSetLPI(_nLpi)
function pdfStringB( cString )
function pdfUnderLine( cString )
function TimeAsAMPM( cTime )
*/

/*
*/
function pdfAtSay( cString, nRow, nCol, cUnits, lExact, cId )
/*
*/
local _nFont, lReverse, nId, nAt

DEFAULT nRow to aReport[ REPORTLINE ]
DEFAULT cUnits to "R"
DEFAULT lExact to .f.
DEFAULT cId to ""

   IF aReport[ HEADEREDIT ]
      return pdfHeader( "PDFATSAY", cId, { cString, nRow, nCol, cUnits, lExact } )
   ENDIF

   IF ( nAt := at( "#pagenumber#", cString ) ) > 0
      cString := left( cString, nAt - 1 ) + ltrim(str( pdfPageNumber())) + substr( cString, nAt + 12 )
   ENDIF

   lReverse = .f.
   IF cUnits == "M"
      nRow := pdfM2Y( nRow )
      nCol := pdfM2X( nCol )
   ELSEIF cUnits == "R"
      IF .not. lExact
         pdfCheckLine( nRow )
         nRow := nRow + aReport[ PDFTOP ]
      ENDIF
      nRow := pdfR2D( nRow )
      nCol := pdfM2X( aReport[ PDFLEFT ] ) + ;
              nCol * 100.00 / aReport[ REPORTWIDTH ] * ;
              ( aReport[ PAGEX ] - pdfM2X( aReport[ PDFLEFT ] ) * 2 - 9.0 ) / 100.00
   ENDIF
   IF !empty( cString )
      cString := pdfStringB( cString )
      IF right( cString, 1 ) == chr(255) //reverse
         cString := left( cString, len( cString ) - 1 )
         //pdfBox( nCol, nRow + aReport[ FONTSIZE ] - 2.0,  nCol + pdfM2X( pdfLen( cString )) + 1, nRow + 2 * aReport[ FONTSIZE ] - 1.5,,100, "D")
         pdfBox( aReport[ PAGEY ] - nRow - aReport[ FONTSIZE ] + 2.0 , nCol, aReport[ PAGEY ] - nRow + 2.0, nCol + pdfM2X( pdfLen( cString )) + 1,,100, "D")
         aReport[ PAGEBUFFER ] += " 1 g "
         lReverse = .t.
      ELSEIF right( cString, 1 ) == chr(254) //underline
         cString := left( cString, len( cString ) - 1 )
         //pdfBox( nCol, nRow - 1.5,  nCol + pdfM2X( pdfLen( cString )) + 1, nRow - 1,,100, "D")
         pdfBox( aReport[ PAGEY ] - nRow + 0.5,  nCol, aReport[ PAGEY ] - nRow + 1, nCol + pdfM2X( pdfLen( cString )) + 1,,100, "D")
      ENDIF

      // version 0.01
      IF ( nAt := at( chr(253), cString )) > 0 // some color text inside
         aReport[ PAGEBUFFER ] += CRLF + ;
         Chr_RGB( substr( cString, nAt + 1, 1 )) + " " + ;
         Chr_RGB( substr( cString, nAt + 2, 1 )) + " " + ;
         Chr_RGB( substr( cString, nAt + 3, 1 )) + " rg "
         cString := stuff( cString, nAt, 4, "")
      ENDIF
      // version 0.01

      _nFont := ascan( aReport[ FONTS ], {|arr| arr[1] == aReport[ FONTNAME ]} )
      IF aReport[ FONTNAME ] <> aReport[ FONTNAMEPREV ]
         aReport[ FONTNAMEPREV ] := aReport[ FONTNAME ]
         aReport[ PAGEBUFFER ] += CRLF + "BT /Fo" + ltrim(str( _nFont )) + " " + ltrim(transform( aReport[ FONTSIZE ], "999.99")) + " Tf " + ltrim(transform( nCol, "9999.99" )) + " " + ltrim(transform( nRow, "9999.99" )) + " Td (" + cString + ") Tj ET"
      ELSEIF aReport[ FONTSIZE ] <> aReport[ FONTSIZEPREV ]
         aReport[ FONTSIZEPREV ] := aReport[ FONTSIZE ]
         aReport[ PAGEBUFFER ] += CRLF + "BT /Fo" + ltrim(str( _nFont )) + " " + ltrim(transform( aReport[ FONTSIZE ], "999.99")) + " Tf " + ltrim(transform( nCol, "9999.99" )) + " " + ltrim(transform( nRow, "9999.99" )) + " Td (" + cString + ") Tj ET"
      ELSE
         aReport[ PAGEBUFFER ] += CRLF + "BT " + ltrim(transform( nCol, "9999.99" )) + " " + ltrim(transform( nRow, "9999.99" )) + " Td (" + cString + ") Tj ET"
      ENDIF
      IF lReverse
         aReport[ PAGEBUFFER ] += " 0 g "
      ENDIF
   ENDIF
return nil
/*
*/
function pdfBold()
/*
*/
   IF pdfGetFontInfo("NAME") = "Times"
      aReport[ FONTNAME ] := 2
   ELSEIF pdfGetFontInfo("NAME") = "Helvetica"
      aReport[ FONTNAME ] := 6
   ELSE
      aReport[ FONTNAME ] := 10 // Courier // 0.04
   ENDIF
   aadd( aReport[ PAGEFONTS ], aReport[ FONTNAME ] )
   IF ascan( aReport[ FONTS ], { |arr| arr[1] == aReport[ FONTNAME ] } ) == 0
      aadd( aReport[ FONTS ], { aReport[ FONTNAME ], ++aReport[ NEXTOBJ ] } )
   ENDIF
return nil
/*
*/
function pdfBoldItalic()
/*
*/
   IF pdfGetFontInfo("NAME") = "Times"
      aReport[ FONTNAME ] := 4
   ELSEIF pdfGetFontInfo("NAME") = "Helvetica"
      aReport[ FONTNAME ] := 8
   ELSE
      aReport[ FONTNAME ] := 12 // 0.04
   ENDIF
   aadd( aReport[ PAGEFONTS ], aReport[ FONTNAME ] )
   IF ascan( aReport[ FONTS ], { |arr| arr[1] == aReport[ FONTNAME ] } ) == 0
      aadd( aReport[ FONTS ], { aReport[ FONTNAME ], ++aReport[ NEXTOBJ ] } )
   ENDIF
return nil
/*
*/
function pdfBookAdd( cTitle, nLevel, nPage, nLine )
/*
*/
   aadd( aReport[ BOOKMARK ], { nLevel, alltrim( cTitle ), 0, 0, 0, 0, 0, 0, nPage, IIF( nLevel == 1, aReport[ PAGEY ], aReport[ PAGEY ] - nLine * 72 / aReport[ LPI ] ) })
return Nil
/*
*/
function pdfBookClose( )
/*
*/
   aReport[ BOOKMARK ] := nil
return Nil
/*
*/
static function pdfBookCount( nRecno, nCurLevel )
/*
*/
local nTempLevel := 0, nCount := 0, nLen := len( aReport[ BOOKMARK ] )
   ++nRecno
   while nRecno <= nLen
      nTempLevel := aReport[ BOOKMARK ][ nRecno ][ BOOKLEVEL ]
      IF nTempLevel <= nCurLevel
         exit
      ELSE
         IF nCurLevel + 1 == nTempLevel
            ++nCount
         ENDIF
      ENDIF
      ++nRecno
   enddo
return -1 * nCount
/*
*/
static function pdfBookFirst( nRecno, nCurLevel, nObj )
/*
*/
local nFirst := 0, nLen := len( aReport[ BOOKMARK ] )
   ++nRecno
   IF nRecno <= nLen
      IF nCurLevel + 1 == aReport[ BOOKMARK ][ nRecno ][ BOOKLEVEL ]
         nFirst := nRecno
      ENDIF
   ENDIF
return IIF( nFirst == 0, nFirst, nObj + nFirst )
/*
*/
static function pdfBookLast( nRecno, nCurLevel, nObj )
/*
*/
local nLast := 0, nLen := len( aReport[ BOOKMARK ] )
   ++nRecno
   IF nRecno <= nLen
      IF nCurLevel + 1 == aReport[ BOOKMARK ][ nRecno ][ BOOKLEVEL ]
         while nRecno <= nLen .and. nCurLevel + 1 <= aReport[ BOOKMARK ][ nRecno ][ BOOKLEVEL ]
            IF nCurLevel + 1 == aReport[ BOOKMARK ][ nRecno ][ BOOKLEVEL ]
               nLast := nRecno
            ENDIF
            ++nRecno
         enddo
      ENDIF
   ENDIF
return IIF( nLast == 0, nLast, nObj + nLast )
/*
*/
static function pdfBookNext( nRecno, nCurLevel, nObj )
/*
*/
local nTempLevel := 0, nNext := 0, nLen := len( aReport[ BOOKMARK ] )
   ++nRecno
   while nRecno <= nLen
      nTempLevel := aReport[ BOOKMARK ][ nRecno ][ BOOKLEVEL ]
      IF nCurLevel > nTempLevel
         exit
      ELSEIF nCurLevel == nTempLevel
         nNext := nRecno
         exit
      ELSE
         // keep going
      ENDIF
      ++nRecno
   enddo
return IIF( nNext == 0, nNext, nObj + nNext )
/*
*/
function pdfBookOpen( )
/*
*/
   aReport[ BOOKMARK ] := {}
return Nil
/*
*/
static function pdfBookParent( nRecno, nCurLevel, nObj )
/*
*/
local nTempLevel := 0
local nParent := 0
   --nRecno
   while nRecno > 0
      nTempLevel := aReport[ BOOKMARK ][ nRecno ][ BOOKLEVEL ]
      IF nTempLevel < nCurLevel
         nParent := nRecno
         exit
      ENDIF
      --nRecno
   enddo
return IIF( nParent == 0, nObj - 1, nObj + nParent )
/*
*/
static function pdfBookPrev( nRecno, nCurLevel, nObj )
/*
*/
local nTempLevel := 0
local nPrev := 0
   --nRecno
   while nRecno > 0
      nTempLevel := aReport[ BOOKMARK ][ nRecno ][ BOOKLEVEL ]
      IF nCurLevel > nTempLevel
         exit
      ELSEIF nCurLevel == nTempLevel
         nPrev := nRecno
         exit
      ELSE
         // keep going
      ENDIF
      --nRecno
   enddo
return IIF( nPrev == 0, nPrev, nObj + nPrev )
/*
*/
function pdfBox( x1, y1, x2, y2, nBorder, nShade, cUnits, cColor, cId )
/*
*/
local cBoxColor
DEFAULT nBorder to 0
DEFAULT nShade to 0
DEFAULT cUnits to "M"
DEFAULT cColor to ""

   // version 0.02
   cBoxColor := ""
   IF !empty( cColor )
      cBoxColor := " " + Chr_RGB( substr( cColor, 2, 1 )) + " " + ;
                         Chr_RGB( substr( cColor, 3, 1 )) + " " + ;
                         Chr_RGB( substr( cColor, 4, 1 )) + " rg "
      IF empty( alltrim( cBoxColor ) )
         cBoxColor := ""
      ENDIF
   ENDIF
   // version 0.02

   IF aReport[ HEADEREDIT ]
      return pdfHeader( "PDFBOX", cId, { x1, y1, x2, y2, nBorder, nShade, cUnits } )
   ENDIF

   IF cUnits == "M"
      y1 += 0.5
      y2 += 0.5

      IF nShade > 0
         // version 0.02
         aReport[ PAGEBUFFER ] += CRLF + transform( 1.00 - nShade / 100.00, "9.99") + " g " + cBoxColor + ltrim(str(pdfM2X( y1 ))) + " " + ltrim(str(pdfM2Y( x1 ))) + " " + ltrim(str(pdfM2X( y2 - y1 ))) + " -" + ltrim(str(pdfM2X( x2 - x1 ))) + " re f 0 g"
      ENDIF

      IF nBorder > 0
         aReport[ PAGEBUFFER ] += CRLF + "0 g " + ltrim(str(pdfM2X( y1 ))) + " " + ltrim(str(pdfM2Y( x1 ))) + " " + ltrim(str(pdfM2X( y2 - y1 ))) + " -" + ltrim(str(pdfM2X( nBorder ))) + " re f"
         aReport[ PAGEBUFFER ] += CRLF + "0 g " + ltrim(str(pdfM2X( y2 - nBorder ))) + " " + ltrim(str(pdfM2Y( x1 ))) + " " + ltrim(str(pdfM2X( nBorder ))) + " -" + ltrim(str(pdfM2X( x2 - x1 ))) + " re f"
         aReport[ PAGEBUFFER ] += CRLF + "0 g " + ltrim(str(pdfM2X( y1 ))) + " " + ltrim(str(pdfM2Y( x2 - nBorder ))) + " " + ltrim(str(pdfM2X( y2 - y1 ))) + " -" + ltrim(str(pdfM2X( nBorder ))) + " re f"
         aReport[ PAGEBUFFER ] += CRLF + "0 g " + ltrim(str(pdfM2X( y1 ))) + " " + ltrim(str(pdfM2Y( x1 ))) + " " + ltrim(str(pdfM2X( nBorder ))) + " -" + ltrim(str(pdfM2X( x2 - x1 ))) + " re f"
      ENDIF
   ELSEIF cUnits == "D"// "Dots"
      //x1, y1, x2, y2 - nTop, nLeft, nBottom, nRight
      IF nShade > 0
         // version 0.02
         aReport[ PAGEBUFFER ] += CRLF + transform( 1.00 - nShade / 100.00, "9.99") + " g " + cBoxColor + ltrim(str( y1 )) + " " + ltrim(str( aReport[ PAGEY ] - x1 )) + " " + ltrim(str( y2 - y1 )) + " -" + ltrim(str( x2 - x1 )) + " re f 0 g"
      ENDIF

      IF nBorder > 0
         aReport[ PAGEBUFFER ] += CRLF + "0 g " + ltrim(str( y1 )) + " " + ltrim(str( aReport[ PAGEY ] - x1 )) + " " + ltrim(str( y2 - y1 )) + " -" + ltrim(str( nBorder )) + " re f"
         aReport[ PAGEBUFFER ] += CRLF + "0 g " + ltrim(str( y2 - nBorder )) + " " + ltrim(str( aReport[ PAGEY ] - x1 )) + " " + ltrim(str( nBorder )) + " -" + ltrim(str( x2 - x1 )) + " re f"
         aReport[ PAGEBUFFER ] += CRLF + "0 g " + ltrim(str( y1 )) + " " + ltrim(str( aReport[ PAGEY ] - x2 + nBorder )) + " " + ltrim(str( y2 - y1 )) + " -" + ltrim(str( nBorder )) + " re f"
         aReport[ PAGEBUFFER ] += CRLF + "0 g " + ltrim(str( y1 )) + " " + ltrim(str( aReport[ PAGEY ] - x1 )) + " " + ltrim(str( nBorder )) + " -" + ltrim(str( x2 - x1 )) + " re f"
      ENDIF
   ENDIF

return nil
/*
*/
function pdfBox1( nTop, nLeft, nBottom, nRight, nBorderWidth, cBorderColor, cBoxColor )
/*
*/
DEFAULT nBorderWidth to 0.5
DEFAULT cBorderColor to chr(0) + chr(0) + chr(0)
DEFAULT cBoxColor to chr(255) + chr(255) + chr(255)

   aReport[ PAGEBUFFER ] +=  CRLF + ;
                         Chr_RGB( substr( cBorderColor, 1, 1 )) + " " + ;
                         Chr_RGB( substr( cBorderColor, 2, 1 )) + " " + ;
                         Chr_RGB( substr( cBorderColor, 3, 1 )) + ;
                         " RG" + ;
                         CRLF + ;
                         Chr_RGB( substr( cBoxColor, 1, 1 )) + " " + ;
                         Chr_RGB( substr( cBoxColor, 2, 1 )) + " " + ;
                         Chr_RGB( substr( cBoxColor, 3, 1 )) + ;
                         " rg" + ;
                         CRLF + ltrim(str( nBorderWidth )) + " w" + ;
                         CRLF + ltrim( str ( nLeft + nBorderWidth / 2 )) + " " + ;
                         CRLF + ltrim( str ( aReport[ PAGEY ] - nBottom + nBorderWidth / 2)) + " " + ;
                         CRLF + ltrim( str ( nRight - nLeft -  nBorderWidth )) + ;
                         CRLF + ltrim( str ( nBottom - nTop - nBorderWidth )) + " " + ;
                         " re" + ;
                         CRLF + "B"
return nil
/*
*/
function pdfCenter( cString, nRow, nCol, cUnits, lExact, cId )
/*
*/
local nLen, nAt
DEFAULT nRow to aReport[ REPORTLINE ]
DEFAULT cUnits to "R"
DEFAULT lExact to .f.
DEFAULT nCol to IIF( cUnits == "R", aReport[ REPORTWIDTH ] / 2, aReport[ PAGEX ] / 72 * 25.4 / 2 )

   IF aReport[ HEADEREDIT ]
      return pdfHeader( "PDFCENTER", cId, { cString, nRow, nCol, cUnits, lExact } )
   ENDIF

   IF ( nAt := at( "#pagenumber#", cString ) ) > 0
      cString := left( cString, nAt - 1 ) + ltrim(str( pdfPageNumber())) + substr( cString, nAt + 12 )
   ENDIF

   nLen := pdfLen( cString ) / 2
   IF cUnits == "R"
      IF .not. lExact
         pdfCheckLine( nRow )
         nRow := nRow + aReport[ PDFTOP ]
      ENDIF
   ENDIF
   pdfAtSay( cString, pdfR2M( nRow ), IIF( cUnits == "R", aReport[ PDFLEFT ] + ( aReport[ PAGEX ] / 72 * 25.4 - 2 * aReport[ PDFLEFT ] ) * nCol / aReport[ REPORTWIDTH ], nCol ) - nLen, "M", lExact )
return nil
/*
*/
static function pdfCheckLine( nRow )
/*
*/
   IF nRow + aReport[ PDFTOP ] > aReport[ PDFBOTTOM ]
      pdfNewPage()
      nRow := aReport[ REPORTLINE ]
   ENDIF
   aReport[ REPORTLINE ] := nRow
return nil
/*
*/
function pdfClose()
/*
*/
local nI, cTemp, nCurLevel, nRec, nObj1, nLast, nCount, nFirst, nRecno, nBooklen
local aImageInfo, cBuffer, nBuffer, nRead, nLen, k, nImageHandle

   FIELD FIRST, PREV, NEXT, LAST, COUNT, PARENT, PAGE, COORD, TITLE, LEVEL

   pdfClosePage()

   // kids
   aReport[ REFS ][ 2 ] := aReport[ DOCLEN ]
   cTemp := ;
   "1 0 obj"+CRLF+;
   "<<"+CRLF+;
   "/Type /Pages /Count " + ltrim(str(aReport[ REPORTPAGE ])) + CRLF +;
   "/Kids ["

   for nI := 1 to aReport[ REPORTPAGE ]
      cTemp += " " + ltrim(str( aReport[ PAGES ][ nI ] )) + " 0 R"
   next

   cTemp += " ]" + CRLF + ;
   ">>" + CRLF + ;
   "endobj" + CRLF

   aReport[ DOCLEN ] += len( cTemp )
   fwrite( aReport[ HANDLE ], cTemp )

   // info
   ++aReport[ REPORTOBJ ]
   aadd( aReport[ REFS ], aReport[ DOCLEN ] )
   cTemp := ltrim(str( aReport[ REPORTOBJ ] )) + " 0 obj" + CRLF + ;
            "<<" + CRLF + ;
            "/Producer ()" + CRLF + ;
            "/Title ()" + CRLF + ;
            "/Author ()" + CRLF + ;
            "/Creator ()" + CRLF + ;
            "/Subject ()" + CRLF + ;
            "/Keywords ()" + CRLF + ;
            "/CreationDate (D:" + str(year(date()), 4) + padl( month(date()), 2, "0") + padl( day(date()), 2, "0") + substr( time(), 1, 2 ) + substr( time(), 4, 2 ) + substr( time(), 7, 2 ) + ")" + CRLF + ;
            ">>" + CRLF + ;
            "endobj" + CRLF
   aReport[ DOCLEN ] += len( cTemp )
   fwrite( aReport[ HANDLE ], cTemp )

   // root
   ++aReport[ REPORTOBJ ]
   aadd( aReport[ REFS ], aReport[ DOCLEN ] )
   cTemp := ltrim(str( aReport[ REPORTOBJ ] )) + " 0 obj" + CRLF + ;
   "<< /Type /Catalog /Pages 1 0 R /Outlines " + ltrim(str( aReport[ REPORTOBJ ] + 1 )) + " 0 R" + IIF( ( nBookLen := len( aReport[ BOOKMARK ] )) > 0, " /PageMode /UseOutlines", "") + " >>" + CRLF + "endobj" + CRLF
   aReport[ DOCLEN ] += len( cTemp )
   fwrite( aReport[ HANDLE ], cTemp )

   ++aReport[ REPORTOBJ ]
   nObj1 := aReport[ REPORTOBJ ]

   IF nBookLen > 0

      nRecno := 1
      nFirst := aReport[ REPORTOBJ ] + 1
      nLast := 0
      nCount := 0
      while nRecno <= nBookLen
         nCurLevel := aReport[ BOOKMARK ][ nRecno ][ BOOKLEVEL ]
         aReport[ BOOKMARK ][ nRecno ][ BOOKPARENT ] := pdfBookParent( nRecno, nCurLevel, aReport[ REPORTOBJ ] )
         aReport[ BOOKMARK ][ nRecno ][ BOOKPREV ]   := pdfBookPrev( nRecno, nCurLevel, aReport[ REPORTOBJ ] )
         aReport[ BOOKMARK ][ nRecno ][ BOOKNEXT ]   := pdfBookNext( nRecno, nCurLevel, aReport[ REPORTOBJ ] )
         aReport[ BOOKMARK ][ nRecno ][ BOOKFIRST ]  := pdfBookFirst( nRecno, nCurLevel, aReport[ REPORTOBJ ] )
         aReport[ BOOKMARK ][ nRecno ][ BOOKLAST ]   := pdfBookLast( nRecno, nCurLevel, aReport[ REPORTOBJ ] )
         aReport[ BOOKMARK ][ nRecno ][ BOOKCOUNT ]  := pdfBookCount( nRecno, nCurLevel )
         IF nCurLevel == 1
            nLast := nRecno
            ++nCount
         ENDIF
         ++nRecno
      enddo

      nLast += aReport[ REPORTOBJ ]

      cTemp := ltrim(str( aReport[ REPORTOBJ ] )) + " 0 obj" + CRLF + "<< /Type /Outlines /Count " + ltrim(str( nCount )) + " /First " + ltrim(str( nFirst )) + " 0 R /Last " + ltrim(str( nLast )) + " 0 R >>" + CRLF + "endobj" //+ CRLF
      aadd( aReport[ REFS ], aReport[ DOCLEN ] )
      aReport[ DOCLEN ] += len( cTemp )
      fwrite( aReport[ HANDLE ], cTemp )

      ++aReport[ REPORTOBJ ]
      nRecno := 1
      FOR nI := 1 to nBookLen
         //cTemp := IIF ( nI > 1, CRLF, "") + ltrim(str( aReport[ REPORTOBJ ] + nI - 1)) + " 0 obj" + CRLF + ;
         cTemp := CRLF + ltrim(str( aReport[ REPORTOBJ ] + nI - 1)) + " 0 obj" + CRLF + ;
                 "<<" + CRLF + ;
                 "/Parent " + ltrim(str( aReport[ BOOKMARK ][ nRecno ][ BOOKPARENT ])) + " 0 R" + CRLF + ;
                 "/Dest [" + ltrim(str( aReport[ PAGES ][ aReport[ BOOKMARK ][ nRecno ][ BOOKPAGE ] ] )) + " 0 R /XYZ 0 " + ltrim( str( aReport[ BOOKMARK ][ nRecno ][ BOOKCOORD ])) + " 0]" + CRLF + ;
                 "/Title (" + alltrim( aReport[ BOOKMARK ][ nRecno ][ BOOKTITLE ]) + ")" + CRLF + ;
                 IIF( aReport[ BOOKMARK ][ nRecno ][ BOOKPREV ] > 0, "/Prev " + ltrim(str( aReport[ BOOKMARK ][ nRecno ][ BOOKPREV ])) + " 0 R" + CRLF, "") + ;
                 IIF( aReport[ BOOKMARK ][ nRecno ][ BOOKNEXT ] > 0, "/Next " + ltrim(str( aReport[ BOOKMARK ][ nRecno ][ BOOKNEXT ])) + " 0 R" + CRLF, "") + ;
                 IIF( aReport[ BOOKMARK ][ nRecno ][ BOOKFIRST ] > 0, "/First " + ltrim(str( aReport[ BOOKMARK ][ nRecno ][ BOOKFIRST ])) + " 0 R" + CRLF, "") + ;
                 IIF( aReport[ BOOKMARK ][ nRecno ][ BOOKLAST ] > 0, "/Last " + ltrim(str( aReport[ BOOKMARK ][ nRecno ][ BOOKLAST ])) + " 0 R" + CRLF, "") + ;
                 IIF( aReport[ BOOKMARK ][ nRecno ][ BOOKCOUNT ] <> 0, "/Count " + ltrim(str( aReport[ BOOKMARK ][ nRecno ][ BOOKCOUNT ])) + CRLF, "") + ;
                 ">>" + CRLF + "endobj" + CRLF
//                 "/Dest [" + ltrim(str( aReport[ BOOKMARK ][ nRecno ][ BOOKPAGE ] * 3 )) + " 0 R /XYZ 0 " + ltrim( str( aReport[ BOOKMARK ][ nRecno ][ BOOKCOORD ])) + " 0]" + CRLF + ;
//                 "/Dest [" + ltrim(str( aReport[ PAGES ][ nRecno ] )) + " 0 R /XYZ 0 " + ltrim( str( aReport[ BOOKMARK ][ nRecno ][ BOOKCOORD ])) + " 0]" + CRLF + ;

         aadd( aReport[ REFS ], aReport[ DOCLEN ] + 2 )
         aReport[ DOCLEN ] += len( cTemp )
         fwrite( aReport[ HANDLE ], cTemp )
         ++nRecno
      NEXT
      pdfBookClose()

      aReport[ REPORTOBJ ] += nBookLen - 1
   ELSE
      cTemp := ltrim(str( aReport[ REPORTOBJ ] )) + " 0 obj" + CRLF + "<< /Type /Outlines /Count 0 >>" + CRLF + "endobj" + CRLF
      aadd( aReport[ REFS ], aReport[ DOCLEN ] )
      aReport[ DOCLEN ] += len( cTemp )
      fwrite( aReport[ HANDLE ], cTemp )
   ENDIF

   cTemp := CRLF
   aReport[ DOCLEN ] += len( cTemp )

   ++aReport[ REPORTOBJ ]
   cTemp += "xref" + CRLF + ;
   "0 " + ltrim(str( aReport[ REPORTOBJ ] )) + CRLF +;
   padl( aReport[ REFS ][ 1 ], 10, "0") + " 65535 f" + CRLF

   for nI := 2 to len( aReport[ REFS ] )
      cTemp += padl( aReport[ REFS ][ nI ], 10, "0") + " 00000 n" + CRLF
   next

   cTemp += "trailer << /Size " + ltrim(str( aReport[ REPORTOBJ ] )) + " /Root " + ltrim(str( nObj1 - 1 )) + " 0 R /Info " + ltrim(str( nObj1 - 2 )) + " 0 R >>" + CRLF + ;
            "startxref" + CRLF + ;
            ltrim(str( aReport[ DOCLEN ] )) + CRLF + ;
            "%%EOF" + CRLF
   fwrite( aReport[ HANDLE ], cTemp )
   fclose( aReport[ HANDLE ] )

   aReport := nil

return nil
/*
*/
static function pdfClosePage()
/*
*/
local cTemp, cBuffer, nBuffer, nRead, nI, k, nImage, nFont, nImageHandle
local aImageInfo

   aadd( aReport[ REFS ], aReport[ DOCLEN ] )

   aadd( aReport[ PAGES ], aReport[ REPORTOBJ ] + 1 )

   cTemp := ;
   ltrim(str( ++aReport[ REPORTOBJ ] )) + " 0 obj" + CRLF + ;
   "<<" + CRLF + ;
   "/Type /Page /Parent 1 0 R" + CRLF + ;
   "/Resources " + ltrim(str( ++aReport[ REPORTOBJ ] )) + " 0 R" + CRLF + ;
   "/MediaBox [ 0 0 " + ltrim(transform( aReport[ PAGEX ], "9999.99")) + " " + ;
   ltrim(transform(aReport[ PAGEY ], "9999.99")) + " ]" + CRLF + ;
   "/Contents " + ltrim(str( ++aReport[ REPORTOBJ ] )) + " 0 R" + CRLF + ;
   ">>" + CRLF + ;
   "endobj" + CRLF

   aReport[ DOCLEN ] += len( cTemp )
   fwrite( aReport[ HANDLE ], cTemp )

   aadd( aReport[ REFS ], aReport[ DOCLEN ] )
   cTemp := ;
   ltrim(str(aReport[ REPORTOBJ ] - 1)) + " 0 obj" + CRLF + ;
   "<<"+CRLF+;
   "/ColorSpace << /DeviceRGB /DeviceGray >>" + CRLF + ; //version 0.01
   "/ProcSet [ /PDF /Text /ImageB /ImageC ]"

   IF len( aReport[ PAGEFONTS ] ) > 0
      cTemp += CRLF + ;
      "/Font" + CRLF + ;
      "<<"

      for nI := 1 to len( aReport[ PAGEFONTS ] )
         nFont := ascan( aReport[ FONTS ], { |arr| arr[1] == aReport[ PAGEFONTS ][ nI ] } )
         //IF nFont == 0
         //   alert("New font after!!!")
         //ENDIF
         cTemp += CRLF + "/Fo" + ltrim(str( nFont )) + " " + ltrim(str( aReport[ FONTS ][ nFont ][ 2 ])) + " 0 R"
      next

      cTemp += CRLF + ">>"
   ENDIF

   IF len( aReport[ PAGEIMAGES ] ) > 0
      cTemp += CRLF + "/XObject" + CRLF + "<<"
      for nI := 1 to len( aReport[ PAGEIMAGES ] )
         nImage := ascan( aReport[ IMAGES ], { |arr| arr[1] == aReport[ PAGEIMAGES ][ nI ][ 1 ] } )
         IF nImage == 0
            aadd( aReport[ IMAGES ], { aReport[ PAGEIMAGES ][ nI ][ 1 ], ++aReport[ NEXTOBJ ], pdfImageInfo( aReport[ PAGEIMAGES ][ nI ][ 1 ] ) } )
            nImage := len( aReport[ IMAGES ] )
         ENDIF
         cTemp += CRLF + "/Image" + ltrim(str( nImage )) + " " + ltrim(str( aReport[ IMAGES ][ nImage ][ 2 ])) + " 0 R"
      next
      cTemp += CRLF + ">>"
   ENDIF

   cTemp += CRLF + ">>" + CRLF + "endobj" + CRLF

   aReport[ DOCLEN ] += len( cTemp )
   fwrite( aReport[ HANDLE ], cTemp )

   aadd( aReport[ REFS ], aReport[ DOCLEN ] )
   cTemp := ltrim(str( aReport[ REPORTOBJ ] )) + " 0 obj << /Length " + ;
   ltrim(str( aReport[ REPORTOBJ ] + 1 )) + " 0 R >>" + CRLF +;
   "stream"

   aReport[ DOCLEN ] += len( cTemp )
   fwrite( aReport[ HANDLE ], cTemp )

   IF len( aReport[ PAGEIMAGES ] ) > 0
      cTemp := ""
      for nI := 1 to len( aReport[ PAGEIMAGES ] )
         cTemp += CRLF + "q"
         nImage := ascan( aReport[ IMAGES ], { |arr| arr[1] == aReport[ PAGEIMAGES ][ nI ][ 1 ] } )
         cTemp += CRLF + ltrim(str( IIF( aReport[ PAGEIMAGES ][ nI ][ 5 ] == 0, pdfM2X( aReport[ IMAGES ][ nImage ][ 3 ][ IMAGE_WIDTH ] / aReport[ IMAGES ][ nImage ][ 3 ][ IMAGE_XRES ] * 25.4 ), aReport[ PAGEIMAGES ][ nI ][ 5 ]))) + ;
         " 0 0 " + ;
         ltrim(str( IIF( aReport[ PAGEIMAGES ][ nI ][ 4 ] == 0, pdfM2X( aReport[ IMAGES ][ nImage ][ 3 ][ IMAGE_HEIGHT ] / aReport[ IMAGES ][ nImage ][ 3 ][ IMAGE_YRES ] * 25.4 ), aReport[ PAGEIMAGES ][ nI ][ 4 ]))) + ;
         " " + ltrim(str( aReport[ PAGEIMAGES ][ nI ][ 3 ] )) + ;
         " " + ltrim(str( aReport[ PAGEY ] - aReport[ PAGEIMAGES ][ nI ][ 2 ] - ;
         IIF( aReport[ PAGEIMAGES ][ nI ][ 4 ] == 0, pdfM2X( aReport[ IMAGES ][ nImage ][ 3 ][ IMAGE_HEIGHT ] / aReport[ IMAGES ][ nImage ][ 3 ][ IMAGE_YRES ] * 25.4 ), aReport[ PAGEIMAGES ][ nI ][ 4 ]))) + " cm"
         cTemp += CRLF + "/Image" + ltrim(str( nImage )) + " Do"
         cTemp += CRLF + "Q"
      next
      aReport[ PAGEBUFFER ] := cTemp + aReport[ PAGEBUFFER ]
   ENDIF

   cTemp := aReport[ PAGEBUFFER ]

   cTemp += CRLF + "endstream" + CRLF + ;
   "endobj" + CRLF

   aReport[ DOCLEN ] += len( cTemp )
   fwrite( aReport[ HANDLE ], cTemp )

   aadd( aReport[ REFS ], aReport[ DOCLEN ] )
   cTemp := ltrim(str( ++aReport[ REPORTOBJ ] )) + " 0 obj" + CRLF + ;
   ltrim(str(len( aReport[ PAGEBUFFER ] ))) + CRLF + ;
   "endobj" + CRLF

   aReport[ DOCLEN ] += len( cTemp )
   fwrite( aReport[ HANDLE ], cTemp )

   for nI := 1 to len( aReport[ FONTS ] )
      IF aReport[ FONTS ][ nI ][ 2 ] > aReport[ REPORTOBJ ]

         aadd( aReport[ REFS ], aReport[ DOCLEN ] )

         cTemp := ;
         ltrim(str( aReport[ FONTS ][ nI ][ 2 ] )) + " 0 obj" + CRLF + ;
         "<<" + CRLF + ;
         "/Type /Font" + CRLF + ;
         "/Subtype /Type1" + CRLF + ;
         "/Name /Fo" + ltrim(str( nI )) + CRLF + ;
         "/BaseFont /" + aReport[ TYPE1 ][ aReport[ FONTS ][ nI ][ 1 ] ] + CRLF + ;
         "/Encoding /WinAnsiEncoding" + CRLF + ;
         ">>" + CRLF + ;
         "endobj" + CRLF

         aReport[ DOCLEN ] += len( cTemp )
         fwrite( aReport[ HANDLE ], cTemp )

      ENDIF
   next

   for nI := 1 to len( aReport[ IMAGES ] )
      IF aReport[ IMAGES ][ nI ][ 2 ] > aReport[ REPORTOBJ ]

         aadd( aReport[ REFS ], aReport[ DOCLEN ] )

         // "/Filter /CCITTFaxDecode" for B&W only ?
         cTemp :=  ;
         ltrim(str( aReport[ IMAGES ][ nI ][ 2 ] )) + " 0 obj" + CRLF + ;
         "<<" + CRLF + ;
         "/Type /XObject" + CRLF + ;
         "/Subtype /Image" + CRLF + ;
         "/Name /Image" + ltrim(str(nI)) + CRLF
//         "/Filter [" + IIF( at( ".JPG", upper( aReport[ IMAGES ][ nI ][ 1 ]) ) > 0, " /DCTDecode", "" ) + " ]" + CRLF + ;
         IF At( ".PNG", Upper( aReport[ IMAGES, nI, 1 ] ) ) > 0
            cTemp += "/Filter[/FlateDecode]" + CRLF
            cTemp += "/DecodeParms[<</Predictor 15/Columns " + Ltrim( Str( aReport[ IMAGES, nI, 3, IMAGE_WIDTH ] ) ) + Iif( aReport[ IMAGES, nI, 3, 8 ] == 2, "/Colors " + Ltrim( Str( aReport[ IMAGES, nI, 3, 8 ] + 1 ) ), "" ) + ">>]" + CRLF
         ELSE
            cTemp += "/Filter [" + Iif( At( ".JPG", Upper( aReport[ IMAGES, nI, 1 ] ) ) > 0, " /DCTDecode", "" ) + " ]" + CRLF
         ENDIF
         cTemp += "/Width " + ltrim(str( aReport[ IMAGES ][ nI ][ 3 ][ IMAGE_WIDTH ] )) + CRLF + ;
         "/Height " + ltrim(str( aReport[ IMAGES ][ nI ][ 3 ][ IMAGE_HEIGHT ] )) + CRLF + ;
         "/BitsPerComponent " + ltrim(str( aReport[ IMAGES ][ nI ][ 3 ][ IMAGE_BITS ] )) + CRLF
         IF At( ".PNG", Upper( aReport[ IMAGES, nI, 1 ] ) ) = 0
           cTemp += "/ColorSpace /" + IIF( aReport[ IMAGES ][ nI ][ 3 ][ IMAGE_SPACE ] == 1, "DeviceGray", "DeviceRGB") + CRLF + ;
           "/Length " + ltrim(str( aReport[ IMAGES ][ nI ][ 3 ][ IMAGE_LENGTH ])) + CRLF + ;
           ">>" + CRLF + ;
           "stream" + CRLF
         else
           IF aReport[ IMAGES, nI, 3, 8 ] == 2
            cTemp += "/ColorSpace/" + Iif( aReport[ IMAGES, nI, 3, IMAGE_SPACE ] == 1, "DeviceGray", "DeviceRGB" ) + CRLF + ;
                    "/Length " + Ltrim( Str( aReport[ IMAGES, nI, 3, IMAGE_LENGTH ] ) ) + CRLF + ;
                    ">>" + CRLF + ;
                    "stream" + CRLF
           ELSE
            cTemp += "/ColorSpace[/Indexed/DeviceRGB 255 " + Ltrim( Str( aReport[ IMAGES, nI, 2 ] + 1 ) ) + " 0 R]" + CRLF + ;
                    "/Length " + Ltrim( Str( aReport[ IMAGES, nI, 3, IMAGE_LENGTH ] ) ) + CRLF + ;
                    ">>" + CRLF + ;
                    "stream" + CRLF

           ENDIF
         ENDIF

         aReport[ DOCLEN ] += len( cTemp )
         fwrite( aReport[ HANDLE ], cTemp )

         nImageHandle := fopen( aReport[ IMAGES ][ nI ][ 1 ] )
         fseek( nImageHandle, aReport[ IMAGES ][ nI ][ 3 ][ IMAGE_FROM ] )

         nBuffer := 8192
         cBuffer := space( nBuffer )
         k := 0
         while k < aReport[ IMAGES ][ nI ][ 3 ][ IMAGE_LENGTH ]
            IF k + nBuffer <= aReport[ IMAGES ][ nI ][ 3 ][ IMAGE_LENGTH ]
               nRead := nBuffer
            ELSE
               nRead := aReport[ IMAGES ][ nI ][ 3 ][ IMAGE_LENGTH ] - k
            ENDIF
            fread( nImageHandle, @cBuffer, nRead )

            aReport[ DOCLEN ] += nRead
            fwrite( aReport[ HANDLE ], cBuffer, nRead )
            k += nRead
         enddo

         cTemp := CRLF + "endstream" + CRLF + ;
         "endobj" + CRLF

         aReport[ DOCLEN ] += len( cTemp )
         fwrite( aReport[ HANDLE ], cTemp )

      ENDIF
   next

   aReport[ REPORTOBJ ] := aReport[ NEXTOBJ ]

   aReport[ NEXTOBJ ] := aReport[ REPORTOBJ ] + 4

   aReport[ PAGEBUFFER ] := ""

return nil
/*
*/
static function pdfGetFontInfo( cParam )
/*
*/
local cRet
   IF cParam == "NAME"
      IF left( aReport[ TYPE1 ][ aReport[ FONTNAME ] ], 5 ) == "Times"
         cRet := "Times"
      ELSEIF left( aReport[ TYPE1 ][ aReport[ FONTNAME ] ], 9 ) == "Helvetica"
         cRet := "Helvetica"
      ELSE
         cRet := "Courier" // 0.04
      ENDIF
   ELSE // size
      cRet := int(( aReport[ FONTNAME ] - 1 ) % 4)
   ENDIF
return cRet
/*
*/
function pdfImage( cFile, nRow, nCol, cUnits, nHeight, nWidth, cId )
/*
*/
local nImage

DEFAULT nRow to aReport[ REPORTLINE ]
DEFAULT nCol to 0
DEFAULT nHeight to 0
DEFAULT nWidth to 0
DEFAULT cUnits to "R"
DEFAULT cId to ""

   IF aReport[ HEADEREDIT ]
      return pdfHeader( "PDFIMAGE", cId, { cFile, nRow, nCol, cUnits, nHeight, nWidth } )
   ENDIF

   IF cUnits == "M"
      nRow := aReport[ PAGEY ] - pdfM2Y( nRow )
      nCol := pdfM2X( nCol )
      nHeight := aReport[ PAGEY ] - pdfM2Y( nHeight )
      nWidth := pdfM2X( nWidth )
   ELSEIF cUnits == "R"
      nRow := aReport[ PAGEY ] - pdfR2D( nRow )
      nCol := pdfM2X( aReport[ PDFLEFT ] ) + ;
              nCol * 100.00 / aReport[ REPORTWIDTH ] * ;
              ( aReport[ PAGEX ] - pdfM2X( aReport[ PDFLEFT ] ) * 2 - 9.0 ) / 100.00
      nHeight := aReport[ PAGEY ] - pdfR2D( nHeight )
      nWidth := pdfM2X( aReport[ PDFLEFT ] ) + ;
              nWidth * 100.00 / aReport[ REPORTWIDTH ] * ;
              ( aReport[ PAGEX ] - pdfM2X( aReport[ PDFLEFT ] ) * 2 - 9.0 ) / 100.00
   ELSEIF cUnits == "D"
   ENDIF

   aadd( aReport[ PAGEIMAGES ], { cFile, nRow, nCol, nHeight, nWidth } )

return nil
/*
*/
function pdfItalic()
/*
*/
   IF pdfGetFontInfo("NAME") = "Times"
      aReport[ FONTNAME ] := 3
   ELSEIF pdfGetFontInfo("NAME") = "Helvetica"
      aReport[ FONTNAME ] := 7
   ELSE
      aReport[ FONTNAME ] := 11 // 0.04
   ENDIF
   aadd( aReport[ PAGEFONTS ], aReport[ FONTNAME ] )
   IF ascan( aReport[ FONTS ], { |arr| arr[1] == aReport[ FONTNAME ] } ) == 0
      aadd( aReport[ FONTS ], { aReport[ FONTNAME ], ++aReport[ NEXTOBJ ] } )
   ENDIF
return nil
/*
*/
function pdfLen( cString )
/*
*/
local nWidth := 0.00, nI, nLen, nArr, nAdd := ( aReport[ FONTNAME ] - 1 ) % 4

   nLen := len( cString )
   IF right( cString, 1 ) == chr(255) .or. right( cString, 1 ) == chr(254 )// reverse or underline
      --nLen
   ENDIF
   IF pdfGetFontInfo("NAME") = "Times"
      nArr := 1
   ELSEIF pdfGetFontInfo("NAME") = "Helvetica"
      nArr := 2
   ELSE
      nArr := 3 // 0.04
   ENDIF
   For nI:= 1 To nLen
      nWidth += aReport[ FONTWIDTH ][ nArr ][ ( asc( substr( cString, nI, 1 )) - 32 ) * 4 + 1 + nAdd ] * 25.4 * aReport[ FONTSIZE ] / 720.00 / 100.00
   Next
return nWidth
/*
*/
static function pdfM2R( mm )
/*
*/
return int( aReport[ LPI ] * mm / 25.4 )
/*
*/
static function pdfM2X( n )
/*
*/
return n * 72 / 25.4
/*
*/
static function pdfM2Y( n )
/*
*/
return aReport[ PAGEY ] -  n * 72 / 25.4
/*
*/
function pdfNewLine( n )
/*
*/
DEFAULT n to 1
   IF aReport[ REPORTLINE ] + n + aReport[ PDFTOP ] > aReport[ PDFBOTTOM ]
      pdfNewPage()
      aReport[ REPORTLINE ] += 1
   ELSE
      aReport[ REPORTLINE ] += n
   ENDIF
return aReport[ REPORTLINE ]
/*
*/
function pdfNewPage( _cPageSize, _cPageOrient, _nLpi, _cFontName, _nFontType, _nFontSize )
/*
*/
local _nFont, _nSize, nAdd := 76.2
DEFAULT _cPageSize to aReport[ PAGESIZE ]
DEFAULT _cPageOrient to aReport[ PAGEORIENT ]
DEFAULT _nLpi to aReport[ LPI ]
DEFAULT _cFontName to pdfGetFontInfo("NAME")
DEFAULT _nFontType to pdfGetFontInfo("TYPE")
DEFAULT _nFontSize to aReport[ FONTSIZE ]

   IF !empty(aReport[ PAGEBUFFER ])
      pdfClosePage()
   ENDIF

   aReport[ PAGEFONTS ] := {}
   aReport[ PAGEIMAGES ] := {}

   ++aReport[ REPORTPAGE ] // NEW !!!

   pdfPageSize( _cPageSize )
   pdfPageOrient( _cPageOrient )
   pdfSetLPI( _nLpi )

   pdfSetFont( _cFontName, _nFontType, _nFontSize )

   pdfDrawHeader()

   aReport[ REPORTLINE ] := 0//5
   aReport[ FONTNAMEPREV ] := 0
   aReport[ FONTSIZEPREV ] := 0

   // version 0.07
   aReport[ PDFBOTTOM    ] := aReport[ PAGEY ] / 72 * aReport[ LPI ] - 1 // bottom, default "LETTER", "P", 6
return nil
/*
*/
function pdfNormal()
/*
*/
   IF pdfGetFontInfo("NAME") = "Times"
      aReport[ FONTNAME ] := 1
   ELSEIF pdfGetFontInfo("NAME") = "Helvetica"
      aReport[ FONTNAME ] := 5
   ELSE
      aReport[ FONTNAME ] := 9 // 0.04
   ENDIF
   aadd( aReport[ PAGEFONTS ], aReport[ FONTNAME ] )
   IF ascan( aReport[ FONTS ], { |arr| arr[1] == aReport[ FONTNAME ] } ) == 0
      aadd( aReport[ FONTS ], { aReport[ FONTNAME ], ++aReport[ NEXTOBJ ] } )
   ENDIF
return nil
/*
*/
function pdfOpen( cFile, nLen, lOptimize )
/*
*/
local cTemp, nI, nJ, n1, n2 := 896, n12
DEFAULT nLen to 200
DEFAULT lOptimize to .f.

   PUBLIC aReport := array( PARAMLEN )

   aReport[ FONTNAME     ] := 1
   aReport[ FONTSIZE     ] := 10
   aReport[ LPI          ] := 6
   aReport[ PAGESIZE     ] := "LETTER"
   aReport[ PAGEORIENT   ] := "P"
   aReport[ PAGEX        ] := 8.5 * 72
   aReport[ PAGEY        ] := 11.0 * 72
   aReport[ REPORTWIDTH  ] := nLen // 200 // should be as parameter
   aReport[ REPORTPAGE   ] := 0
   aReport[ REPORTLINE   ] := 0//5
   aReport[ FONTNAMEPREV ] := 0
   aReport[ FONTSIZEPREV ] := 0
   aReport[ PAGEBUFFER   ] := ""
   aReport[ REPORTOBJ    ] := 1//2
   aReport[ DOCLEN       ] := 0
   aReport[ TYPE1        ] := { "Times-Roman", "Times-Bold", "Times-Italic", "Times-BoldItalic", "Helvetica", "Helvetica-Bold", "Helvetica-Oblique", "Helvetica-BoldOblique", "Courier", "Courier-Bold", "Courier-Oblique", "Courier-BoldOblique"  } // 0.04
   aReport[ MARGINS      ] := .t.
   aReport[ HEADEREDIT   ] := .f.
   aReport[ NEXTOBJ      ] := 0
   aReport[ PDFTOP       ] := 1 // top
   aReport[ PDFLEFT      ] := 10 // left & right
   aReport[ PDFBOTTOM    ] := aReport[ PAGEY ] / 72 * aReport[ LPI ] - 1 // bottom, default "LETTER", "P", 6
   aReport[ HANDLE       ] := fcreate( cFile )
   aReport[ PAGES        ] := {}
   aReport[ REFS         ] := { 0, 0 }
   aReport[ BOOKMARK     ] := {}
   aReport[ HEADER       ] := {}
   aReport[ FONTS        ] := {}
   aReport[ IMAGES       ] := {}
   aReport[ PAGEIMAGES   ] := {}
   aReport[ PAGEFONTS    ] := {}

   cTemp := memoread("fonts.dat") // times, times-bold, times-italic, times-bolditalic, helvetica..., courier... // 0.04
   n1 := len( cTemp ) / ( 2 * n2 )
   aReport[ FONTWIDTH ] := array( n1, n2 )

   aReport[ OPTIMIZE     ] := lOptimize

   aReport[ NEXTOBJ ] := aReport[ REPORTOBJ ] + 4

   n12 := 2 * n2 // 0.04
   for nI := 1 to n1
      for nJ := 1 to n2
         aReport[ FONTWIDTH ][ nI ][ nJ ] := bin2i(substr( cTemp, ( nI - 1 ) * n12 + ( nJ - 1 ) * 2 + 1, 2 ))
      next
   next

   aReport[ DOCLEN ] := 0
   cTemp := "%PDF-1.3" + CRLF
   aReport[ DOCLEN ] += len( cTemp )
   fwrite( aReport[ HANDLE ], cTemp )

return nil
/*
*/
function pdfPageSize( _cPageSize )
/*
*/
local nSize, aSize := { { "LETTER",    8.50, 11.00 }, ;
                        { "LEGAL" ,    8.50, 14.00 }, ;
                        { "LEDGER",   11.00, 17.00 }, ;
                        { "EXECUTIVE", 7.25, 10.50 }, ;
                        { "A4",        8.27, 11.69 }, ;
                        { "A3",       11.69, 16.54 }, ;
                        { "JIS B4",   10.12, 14.33 }, ;
                        { "JIS B5",    7.16, 10.12 }, ;
                        { "JPOST",     3.94,  5.83 }, ;
                        { "JPOSTD",    5.83,  7.87 }, ;
                        { "COM10",     4.12,  9.50 }, ;
                        { "MONARCH",   3.87,  7.50 }, ;
                        { "C5",        6.38,  9.01 }, ;
                        { "DL",        4.33,  8.66 }, ;
                        { "B5",        6.93,  9.84 } }

DEFAULT _cPageSize to "LETTER"

   nSize := ascan( aSize, { |arr| arr[ 1 ] = _cPageSize } )

   IF nSize = 0
      nSize := 1
   ENDIF

   aReport[ PAGESIZE ] := aSize[ nSize ][ 1 ]

   IF aReport[ PAGEORIENT ] = "P"
      aReport[ PAGEX ] := aSize[ nSize ][ 2 ] * 72
      aReport[ PAGEY ] := aSize[ nSize ][ 3 ] * 72
   ELSE
      aReport[ PAGEX ] := aSize[ nSize ][ 3 ] * 72
      aReport[ PAGEY ] := aSize[ nSize ][ 2 ] * 72
   ENDIF

   // version 0.07
   aReport[ PDFBOTTOM    ] := aReport[ PAGEY ] / 72 * aReport[ LPI ] - 1
return nil
/*
*/
function pdfPageOrient( _cPageOrient )
/*
*/
DEFAULT _cPageOrient to "P"

   aReport[ PAGEORIENT ] := _cPageOrient
   pdfPageSize( aReport[ PAGESIZE ] )
return nil
/*
*/
static function pdfR2D( nRow )
/*
*/
return aReport[ PAGEY ] - nRow * 72 / aReport[ LPI ]
/*
*/
static function pdfR2M( nRow )
/*
*/
return 25.4 * nRow / aReport[ LPI ]
/*
*/
function pdfPageNumber( n )
/*
*/
DEFAULT n to 0
   IF n > 0
      aReport[ REPORTPAGE ] := n // NEW !!!
   ENDIF
return aReport[ REPORTPAGE ]
/*
*/
function pdfReverse( cString )
/*
*/
return cString + chr(255)
/*
*/
function pdfRJust( cString, nRow, nCol, cUnits, lExact, cId )
/*
*/
local nLen, nAdj := 1.0, nAt
DEFAULT nRow to aReport[ REPORTLINE ]
DEFAULT cUnits to "R"
DEFAULT lExact to .f.

   IF aReport[ HEADEREDIT ]
      return pdfHeader( "PDFRJUST", cId, { cString, nRow, nCol, cUnits, lExact } )
   ENDIF

   IF ( nAt := at( "#pagenumber#", cString ) ) > 0
      cString := left( cString, nAt - 1 ) + ltrim(str( pdfPageNumber())) + substr( cString, nAt + 12 )
   ENDIF

   nLen := pdfLen( cString )

   IF cUnits == "R"
      IF .not. lExact
         pdfCheckLine( nRow )
         nRow := nRow + aReport[ PDFTOP ]
      ENDIF
   ENDIF
   pdfAtSay( cString, pdfR2M( nRow ), IIF( cUnits == "R", aReport[ PDFLEFT ] + ( aReport[ PAGEX ] / 72 * 25.4 - 2 * aReport[ PDFLEFT ] ) * nCol / aReport[ REPORTWIDTH ] - nAdj, nCol ) - nLen, "M", lExact )
return nil
/*
*/
function pdfSetFont( _cFont, _nType, _nSize, cId )
/*
*/
DEFAULT _cFont to "Times"
DEFAULT _nType to 0
DEFAULT _nSize to 10

   IF aReport[ HEADEREDIT ]
      return pdfHeader( "PDFSETFONT", cId, { _cFont, _nType, _nSize } )
   ENDIF

   _cFont := upper( _cFont )
   aReport[ FONTSIZE ] := _nSize

   IF _cFont == "TIMES"
      aReport[ FONTNAME ] := _nType + 1
   ELSEIF _cFont == "HELVETICA"
      aReport[ FONTNAME ] := _nType + 5
   ELSE
      aReport[ FONTNAME ] := _nType + 9 // 0.04
   ENDIF

   aadd( aReport[ PAGEFONTS ], aReport[ FONTNAME ] )

   IF ascan( aReport[ FONTS ], { |arr| arr[1] == aReport[ FONTNAME ] } ) == 0
      aadd( aReport[ FONTS ], { aReport[ FONTNAME ], ++aReport[ NEXTOBJ ] } )
   ENDIF
return nil
/*
*/
function pdfSetLPI(_nLpi)
/*
*/
local cLpi := alltrim(str(_nLpi))
DEFAULT _nLpi to 6

   cLpi := iif(cLpi$"1;2;3;4;6;8;12;16;24;48",cLpi,"6")
   aReport[ LPI ] := val( cLpi )

   pdfPageSize( aReport[ PAGESIZE ] )
return nil
/*
*/
function pdfStringB( cString )
/*
*/
   cString := strtran( cString, "(", "\(" )
   cString := strtran( cString, ")", "\)" )
return cString
/*
*/
function pdfTextCount( cString, nTop, nLeft, nLength, nTab, nJustify, cUnits )
/*
*/
return pdfText( cString, nTop, nLeft, nLength, nTab, nJustify, cUnits, .f. )
/*
*/
function pdfText( cString, nTop, nLeft, nLength, nTab, nJustify, cUnits, cColor, lPrint )
/*
*/
local cDelim := chr(0)+chr(9)+chr(10)+chr(13)+chr(26)+chr(32)+chr(138)+chr(141)
local nI, cTemp, cToken, k, nL, nRow, nLines, nLineLen, nJ, nStart, nFinish
local lParagraph, nSpace, nNew, nTokenLen, nCRLF, nTokens, nLen, nB, nRat
DEFAULT nTab to -1
DEFAULT cUnits to 'R'
DEFAULT nJustify to 4 // justify
DEFAULT lPrint to .t.
DEFAULT cColor to ""

   IF cUnits == "M"
      nTop := pdfM2R( nTop )
   ELSEIF cUnits == "R"
      nLeft := pdfX2M( pdfM2X( aReport[ PDFLEFT ] ) + ;
              nLeft * 100.00 / aReport[ REPORTWIDTH ] * ;
              ( aReport[ PAGEX ] - pdfM2X( aReport[ PDFLEFT ] ) * 2 - 9.0 ) / 100.00 )
   ENDIF

   aReport[ REPORTLINE ] := nTop - 1

   nSpace := pdfLen( " " )
   nLines := 0
   nCRLF := 0

   nNew := nTab

   cString := alltrim( cString )
   nTokens := numtoken( cString, cDelim )
   nTokenLen := 0.00
   nStart := 1

   IF nJustify == 1 .or. nJustify == 4
      nLeft := nLeft
   ELSEIF nJustify == 2
      nLeft := nLeft - nLength / 2
   ELSEIF nJustify == 3
      nLeft := nLeft - nLength
   ENDIF

   nL := nLeft
   nL += nNew * nSpace // first always paragraph
   nLineLen := nSpace * nNew - nSpace

   lParagraph := .t.
   nI := 1

   while nI <= nTokens
      cToken := token( cString, cDelim, nI )
      nTokenLen := pdfLen( cToken )
      nLen := len( cToken )

      IF nLineLen + nSpace + nTokenLen > nLength
         IF nStart == nI // single word > nLength
            k := 1
            while k <= nLen
               cTemp := ""
               nLineLen := 0.00
               nL := nLeft
               IF lParagraph
                  nLineLen += nSpace * nNew
                  IF nJustify <> 2
                     nL += nSpace * nNew
                  ENDIF
                  lParagraph := .f.
               ENDIF
               IF nJustify == 2
                  nL := nLeft + ( nLength - pdfLen( cTemp ) ) / 2
               ELSEIF nJustify == 3
                  nL := nLeft + nLength - pdfLen( cTemp )
               ENDIF
               while k <= nLen .and. ( ( nLineLen += pdfLen( substr( cToken, k, 1 ))) <= nLength )
                  nLineLen += pdfLen( substr( cToken, k, 1 ))
                  cTemp += substr( cToken, k, 1 )
                  ++k
               enddo
               IF empty( cTemp ) // single character > nlength
                  cTemp := substr( cToken, k, 1 )
                  ++k
               ENDIF
               ++nLines
               IF lPrint
                  nRow := pdfNewLine( 1 )
                  // version 0.02
                  pdfAtSay( cColor + cTemp, pdfR2M( nRow + aReport[ PDFTOP ] ), nL, "M" )
               ENDIF
            enddo
            ++nI
            nStart := nI
         ELSE
            pdfTextPrint( nI - 1, nLeft, @lParagraph, nJustify, nSpace, nNew, nLength, @nLineLen, @nLines, @nStart, cString, cDelim, cColor, lPrint )
         ENDIF
/*
            nFinish := nI - 1

            nL := nLeft
            IF lParagraph
               IF nJustify <> 2
                  nL += nSpace * nNew
               ENDIF
            ENDIF

            IF nJustify == 3 // right
               nL += nLength - nLineLen
            ELSEIF nJustify == 2 // center
               nL += ( nLength - nLineLen ) / 2
            ENDIF

            ++nLines
            IF lPrint
               nRow := pdfNewLine( 1 )
            ENDIF
            nB := nSpace
            IF nJustify == 4
               nB := ( nLength - nLineLen + ( nFinish - nStart ) * nSpace ) / ( nFinish - nStart )
            ENDIF
            for nJ := nStart to nFinish
                cToken := token( cString, cDelim, nJ )
                IF lPrint
                   pdfAtSay( cToken, pdfR2M( nRow + aReportStyle[ aReport[ REPORTSTYLE ] ][ 6 ] ), nL, "M" )
                ENDIF
               nL += pdfLen ( cToken ) + nB
            next
            nStart := nFinish + 1
         ENDIF

         lParagraph := .f.

         nLineLen := 0.00
         nLineLen += nSpace * nNew
*/
      ELSEIF ( nI == nTokens ) .or. ( nI < nTokens .and. ( nCRLF := pdfTextNextPara( cString, cDelim, nI ) ) > 0 )
         IF nI == nTokens
            nLineLen += nSpace + nTokenLen
         ENDIF
         pdfTextPrint( nI, nLeft, @lParagraph, nJustify, nSpace, nNew, nLength, @nLineLen, @nLines, @nStart, cString, cDelim, cColor, lPrint )
            /*
            nFinish := nI

            nL := nLeft
            IF lParagraph
               IF nJustify <> 2
                  nL += nSpace * nNew
               ENDIF
            ENDIF

            IF nJustify == 3 // right
               nL += nLength - nLineLen
            ELSEIF nJustify == 2 // center
               nL += ( nLength - nLineLen ) / 2
            ENDIF

            ++nLines
            IF lPrint
               nRow := pdfNewLine( 1 )
            ENDIF
            nB := nSpace
            IF nJustify == 4
               nB := ( nLength - nLineLen + ( nFinish - nStart ) * nSpace ) / ( nFinish - 1 - nStart )
            ENDIF
            for nJ := nStart to nFinish
                cToken := token( cString, cDelim, nJ )
                IF lPrint
                   pdfAtSay( cToken, pdfR2M( nRow + aReportStyle[ aReport[ REPORTSTYLE ] ][ 6 ] ), nL, "M" )
                ENDIF
               nL += pdfLen ( cToken ) + nB
            next
            nStart := nFinish + 1

         lParagraph := .f.

         nLineLen := 0.00
         nLineLen += nSpace * nNew
         */
         ++nI

         IF nCRLF > 1
            nLines += nCRLF - 1
         ENDIF
         IF lPrint
            nRow := pdfNewLine( nCRLF - 1 )
         ENDIF

      ELSE
         nLineLen += nSpace + nTokenLen
         ++nI
      ENDIF
   enddo

return nLines
/*
*/
static function pdfTextPrint( nI, nLeft, lParagraph, nJustify, nSpace, nNew, nLength, nLineLen, nLines, nStart, cString, cDelim, cColor, lPrint )
/*
*/
local nFinish, nL, nB, nJ, cToken, nRow

   nFinish := nI

   nL := nLeft
   IF lParagraph
      IF nJustify <> 2
         nL += nSpace * nNew
      ENDIF
   ENDIF

   IF nJustify == 3 // right
      nL += nLength - nLineLen
   ELSEIF nJustify == 2 // center
      nL += ( nLength - nLineLen ) / 2
   ENDIF

   ++nLines
   IF lPrint
      nRow := pdfNewLine( 1 )
   ENDIF
   nB := nSpace
   IF nJustify == 4
      nB := ( nLength - nLineLen + ( nFinish - nStart ) * nSpace ) / ( nFinish - nStart )
   ENDIF
   for nJ := nStart to nFinish
      cToken := token( cString, cDelim, nJ )
      IF lPrint
         // version 0.02
         pdfAtSay( cColor + cToken, pdfR2M( nRow + aReport[ PDFTOP ] ), nL, "M" )
      ENDIF
      nL += pdfLen ( cToken ) + nB
   next

   nStart := nFinish + 1

   lParagraph := .f.

   nLineLen := 0.00
   nLineLen += nSpace * nNew

return nil
/*
*/
static function pdfTextNextPara( cString, cDelim, nI )
/*
*/
local nAt, cAt, nCRLF, nNew, nRat, nRet := 0
   // check if next spaces paragraph(s)
   nAt := attoken( cString, cDelim, nI ) + len( token( cString, cDelim, nI ) )
   cAt := substr( cString, nAt, attoken( cString, cDelim, nI + 1 ) - nAt )
   nCRLF := numat( chr(13) + chr(10), cAt )
   nRat := rat( chr(13) + chr(10), cAt )
   nNew := len( cAt ) - nRat - IIF( nRat > 0, 1, 0 )
   IF nCRLF > 1 .or. ( nCRLF == 1 .and. nNew > 0 )
      nRet := nCRLF
   ENDIF
return nRet
/*
*/
function pdfUnderLine( cString )
/*
*/
return cString + chr(254)
/*
*/
static function pdfX2M( n )
/*
*/
return n * 25.4 / 72
/*
*/
static function TimeAsAMPM( cTime )
/*
*/
   IF VAL(cTime) < 12
      cTime += " am"
   ELSEIF VAL(cTime) = 12
      cTime += " pm"
   ELSE
      cTime := STR(VAL(cTime) - 12, 2) + SUBSTR(cTime, 3) + " pm"
   ENDIF
   cTime := left( cTime, 5 ) + substr( cTime, 10 )
return cTime

/*
*/
function pdfOpenHeader( cFile )
local nErrorCode := 0, nAt
DEFAULT cFile to ""
   IF !empty( cFile )
      cFile := alltrim( cFile )
      IF len( cFile ) > 12 .or. ;
         at( ' ', cFile ) > 0 .or. ;
         ( at( ' ', cFile ) == 0 .and. len( cFile ) > 8 ) .or. ;
         ( ( nAt := at( '.', cFile )) > 0 .and. len( substr( cFile, nAt + 1 )) > 3 )
         RUN( "copy " + cFile + " temp.tmp > nul")
         cFile := "temp.tmp"
      ENDIF
      aReport[ HEADER ] := File2Array( cFile )
   ELSE
      aReport[ HEADER ] := {}
   ENDIF
   aReport[ MARGINS ] := .t.
return nil
/*
*/
function pdfEditOnHeader()
   aReport[ HEADEREDIT ] := .t.
   aReport[ MARGINS ] := .t.
return nil
/*
*/
function pdfEditOffHeader()
   aReport[ HEADEREDIT ] := .f.
   aReport[ MARGINS ] := .t.
return nil
/*
*/
function pdfCloseHeader()
   aReport[ HEADER ] := {}
   aReport[ MARGINS ] := .f.
return nil
/*
*/
function pdfDeleteHeader( cId )
local nRet := -1, nId
   cId := upper( cId )
   nId := ascan( aReport[ HEADER ], {| arr | arr[ 3 ] == cId })
   IF nId > 0
      nRet := len( aReport[ HEADER ] ) - 1
      aDel( aReport[ HEADER ], nId )
      aSize( aReport[ HEADER ], nRet )
      aReport[ MARGINS ] := .t.
   ENDIF
return nRet
/*
*/
function pdfEnableHeader( cId )
local nId
   cId := upper( cId )
   nId := ascan( aReport[ HEADER ], {| arr | arr[ 3 ] == cId })
   IF nId > 0
      aReport[ HEADER ][ nId ][ 1 ] := .t.
      aReport[ MARGINS ] := .t.
   ENDIF
return nil
/*
*/
function pdfDisableHeader( cId )
local nId
   cId := upper( cId )
   nId := ascan( aReport[ HEADER ], {| arr | arr[ 3 ] == cId })
   IF nId > 0
      aReport[ HEADER ][ nId ][ 1 ] := .f.
      aReport[ MARGINS ] := .t.
   ENDIF
return nil
/*
*/
function pdfSaveHeader( cFile )
local nErrorCode := 0, cTemp
   Array2File( 'temp.tmp', aReport[ HEADER ] )
   RUN( "copy temp.tmp " + cFile + " > nul")
   ferase("temp.tmp")
return nil
/*
*/
function pdfHeader( cFunction, cId, arr )
local nId, nI, nLen, nIdLen
   nId := 0
   IF !empty( cId )
      cId := upper( cId )
      nId := ascan( aReport[ HEADER ], {| arr | arr[ 3 ] == cId })
   ENDIF
   IF nId == 0
      nLen := len( aReport[ HEADER ] )
      IF empty( cId )
         cId := cFunction
         nIdLen := len( cId )
         for nI := 1 to nLen
            IF aReport[ HEADER ][ nI ][ 2 ] == cId
               IF val( substr( aReport[ HEADER ][ nI ][ 3 ], nIdLen + 1 ) ) > nId
                  nId := val( substr( aReport[ HEADER ][ nI ][ 3 ], nIdLen + 1 ) )
               ENDIF
            ENDIF
         next
         ++nId
         cId += ltrim(str(nId))
      ENDIF
      aadd( aReport[ HEADER ], { .t., cFunction, cId } )
      ++nLen
      for nI := 1 to len( arr )
         aadd( aReport[ HEADER ][ nLen ], arr[ nI ] )
      next
   ELSE
      aSize( aReport[ HEADER ][ nId ], 3 )
      for nI := 1 to len( arr )
         aadd( aReport[ HEADER ][ nId ], arr[ nI ] )
      next
   ENDIF
return cId
/*
*/
function pdfDrawHeader()
local nI, _nFont, _nSize, nLen := len( aReport[ HEADER ] )

   IF nLen > 0

      // save font
      _nFont := aReport[ FONTNAME ]
      _nSize := aReport[ FONTSIZE ]

      for nI := 1 to nLen
         IF aReport[ HEADER ][ nI ][ 1 ] // enabled
            do case
            case aReport[ HEADER ][ nI ][ 2 ] == "PDFATSAY"
               pdfAtSay( aReport[ HEADER ][ nI ][ 4 ], aReport[ HEADER ][ nI ][ 5 ], aReport[ HEADER ][ nI ][ 6 ], aReport[ HEADER ][ nI ][ 7 ], aReport[ HEADER ][ nI ][ 8 ], aReport[ HEADER ][ nI ][ 3 ] )

            case aReport[ HEADER ][ nI ][ 2 ] == "PDFCENTER"
               pdfCenter( aReport[ HEADER ][ nI ][ 4 ], aReport[ HEADER ][ nI ][ 5 ], aReport[ HEADER ][ nI ][ 6 ], aReport[ HEADER ][ nI ][ 7 ], aReport[ HEADER ][ nI ][ 8 ], aReport[ HEADER ][ nI ][ 3 ] )

            case aReport[ HEADER ][ nI ][ 2 ] == "PDFRJUST"
               pdfRJust( aReport[ HEADER ][ nI ][ 4 ], aReport[ HEADER ][ nI ][ 5 ], aReport[ HEADER ][ nI ][ 6 ], aReport[ HEADER ][ nI ][ 7 ], aReport[ HEADER ][ nI ][ 8 ], aReport[ HEADER ][ nI ][ 3 ] )

            case aReport[ HEADER ][ nI ][ 2 ] == "PDFBOX"
               pdfBox( aReport[ HEADER ][ nI ][ 4 ], aReport[ HEADER ][ nI ][ 5 ], aReport[ HEADER ][ nI ][ 6 ], aReport[ HEADER ][ nI ][ 7 ], aReport[ HEADER ][ nI ][ 8 ], aReport[ HEADER ][ nI ][ 9 ], aReport[ HEADER ][ nI ][ 10 ], aReport[ HEADER ][ nI ][ 3 ] )

            case aReport[ HEADER ][ nI ][ 2 ] == "PDFSETFONT"
               pdfSetFont( aReport[ HEADER ][ nI ][ 4 ], aReport[ HEADER ][ nI ][ 5 ], aReport[ HEADER ][ nI ][ 6 ], aReport[ HEADER ][ nI ][ 3 ] )

            case aReport[ HEADER ][ nI ][ 2 ] == "PDFIMAGE"
               pdfImage( aReport[ HEADER ][ nI ][ 4 ], aReport[ HEADER ][ nI ][ 5 ], aReport[ HEADER ][ nI ][ 6 ], aReport[ HEADER ][ nI ][ 7 ], aReport[ HEADER ][ nI ][ 8 ], aReport[ HEADER ][ nI ][ 9 ], aReport[ HEADER ][ nI ][ 3 ] )

            endcase
         ENDIF
      next
      aReport[ FONTNAME ] := _nFont
      aReport[ FONTSIZE ] := _nSize

      IF aReport[ MARGINS ]
         pdfMargins()
      ENDIF

   ELSE
      IF aReport[ MARGINS ]
         aReport[ PDFTOP ] := 1 // top
         aReport[ PDFLEFT ] := 10 // left & right
         aReport[ PDFBOTTOM ] := aReport[ PAGEY ] / 72 * aReport[ LPI ] - 1 // bottom, default "LETTER", "P", 6

         aReport[ MARGINS ] := .f.
      ENDIF
   ENDIF
return nil
/*
*/
function pdfMargins( nTop, nLeft, nBottom )
local nI, nLen := len( aReport[ HEADER ] ), nTemp, aTemp, nHeight

// version 0.07 begin
DEFAULT nTop to 1 // top
DEFAULT nLeft to 10 // left & right
DEFAULT nBottom to aReport[ PAGEY ] / 72 * aReport[ LPI ] - 1 // bottom, default "LETTER", "P", 6

   aReport[ PDFTOP ] := nTop
   aReport[ PDFLEFT ] := nLeft
   aReport[ PDFBOTTOM ] := nBottom

// version 0.07 end

   for nI := 1 to nLen
      IF aReport[ HEADER ][ nI ][ 1 ] // enabled

         IF aReport[ HEADER ][ nI ][ 2 ] == "PDFSETFONT"

         ELSEIF aReport[ HEADER ][ nI ][ 2 ] == "PDFIMAGE"
            IF aReport[ HEADER ][ nI ][ 8 ] == 0 // picture in header, first at all, not at any page yet
               aTemp := pdfImageInfo( aReport[ HEADER ][ nI ][ 4 ] )
               nHeight := aTemp[ IMAGE_HEIGHT ] / aTemp[ IMAGE_YRES ] * 25.4
               IF aReport[ HEADER ][ nI ][ 7 ] == "D"
                  nHeight := pdfM2X( nHeight )
               ENDIF
            ELSE
               nHeight := aReport[ HEADER ][ nI ][ 8 ]
            ENDIF

            IF aReport[ HEADER ][ nI ][ 7 ] == "M"

               nTemp := aReport[ PAGEY ] / 72 * 25.4 / 2

               IF aReport[ HEADER ][ nI ][ 5 ] < nTemp
                  nTemp := ( aReport[ HEADER ][ nI ][ 5 ] + nHeight ) * aReport[ LPI ] / 25.4 // top
                  IF nTemp > aReport[ PDFTOP ]
                     aReport[ PDFTOP ] := nTemp
                  ENDIF
               ELSE
                  nTemp := aReport[ HEADER ][ nI ][ 5 ] * aReport[ LPI ] / 25.4 // top
                  IF nTemp < aReport[ PDFBOTTOM ]
                     aReport[ PDFBOTTOM ] := nTemp
                  ENDIF
               ENDIF

            ELSEIF aReport[ HEADER ][ nI ][ 7 ] == "D"
               nTemp := aReport[ PAGEY ] / 2

               IF aReport[ HEADER ][ nI ][ 5 ] < nTemp
                  nTemp := ( aReport[ HEADER ][ nI ][ 5 ] + nHeight ) * aReport[ LPI ] / 72 // top
                  IF nTemp > aReport[ PDFTOP ]
                     aReport[ PDFTOP ] := nTemp
                  ENDIF
               ELSE
                  nTemp := aReport[ HEADER ][ nI ][ 5 ] * aReport[ LPI ] / 72 // top
                  IF nTemp < aReport[ PDFBOTTOM ]
                     aReport[ PDFBOTTOM ] := nTemp
                  ENDIF

               ENDIF

            ENDIF

         ELSEIF aReport[ HEADER ][ nI ][ 2 ] == "PDFBOX"

            IF aReport[ HEADER ][ nI ][ 10 ] == "M"

               nTemp := aReport[ PAGEY ] / 72 * 25.4 / 2

               IF aReport[ HEADER ][ nI ][ 4 ] < nTemp .and. ;
                  aReport[ HEADER ][ nI ][ 6 ] < nTemp
                  nTemp := aReport[ HEADER ][ nI ][ 6 ] * aReport[ LPI ] / 25.4 // top
                  IF nTemp > aReport[ PDFTOP ]
                     aReport[ PDFTOP ] := nTemp
                  ENDIF
               ELSEIF aReport[ HEADER ][ nI ][ 4 ] < nTemp .and. ;
                      aReport[ HEADER ][ nI ][ 6 ] > nTemp

                  nTemp := ( aReport[ HEADER ][ nI ][ 4 ] + aReport[ HEADER ][ nI ][ 8 ] ) * aReport[ LPI ] / 25.4 // top
                  IF nTemp > aReport[ PDFTOP ]
                     aReport[ PDFTOP ] := nTemp
                  ENDIF

                  nTemp := ( aReport[ HEADER ][ nI ][ 6 ] - aReport[ HEADER ][ nI ][ 8 ] ) * aReport[ LPI ] / 25.4 // top
                  IF nTemp < aReport[ PDFBOTTOM ]
                     aReport[ PDFBOTTOM ] := nTemp
                  ENDIF

               ELSEIF aReport[ HEADER ][ nI ][ 4 ] > nTemp .and. ;
                      aReport[ HEADER ][ nI ][ 6 ] > nTemp
                  nTemp := aReport[ HEADER ][ nI ][ 4 ] * aReport[ LPI ] / 25.4 // top
                  IF nTemp < aReport[ PDFBOTTOM ]
                     aReport[ PDFBOTTOM ] := nTemp
                  ENDIF
               ENDIF

            ELSEIF aReport[ HEADER ][ nI ][ 10 ] == "D"
               nTemp := aReport[ PAGEY ] / 2

               IF aReport[ HEADER ][ nI ][ 4 ] < nTemp .and. ;
                  aReport[ HEADER ][ nI ][ 6 ] < nTemp
                  nTemp := aReport[ HEADER ][ nI ][ 6 ] / aReport[ LPI ] // top
                  IF nTemp > aReport[ PDFTOP ]
                     aReport[ PDFTOP ] := nTemp
                  ENDIF
               ELSEIF aReport[ HEADER ][ nI ][ 4 ] < nTemp .and. ;
                      aReport[ HEADER ][ nI ][ 6 ] > nTemp

                  nTemp := ( aReport[ HEADER ][ nI ][ 4 ] + aReport[ HEADER ][ nI ][ 8 ] ) / aReport[ LPI ] // top
                  IF nTemp > aReport[ PDFTOP ]
                     aReport[ PDFTOP ] := nTemp
                  ENDIF

                  nTemp := ( aReport[ HEADER ][ nI ][ 6 ] - aReport[ HEADER ][ nI ][ 8 ] ) / aReport[ LPI ] // top
                  IF nTemp < aReport[ PDFBOTTOM ]
                     aReport[ PDFBOTTOM ] := nTemp
                  ENDIF

               ELSEIF aReport[ HEADER ][ nI ][ 4 ] > nTemp .and. ;
                      aReport[ HEADER ][ nI ][ 6 ] > nTemp
                  nTemp := aReport[ HEADER ][ nI ][ 4 ] / aReport[ LPI ] // top
                  IF nTemp < aReport[ PDFBOTTOM ]
                     aReport[ PDFBOTTOM ] := nTemp
                  ENDIF
               ENDIF

            ENDIF

         ELSE
            IF aReport[ HEADER ][ nI ][ 7 ] == "R"
               nTemp := aReport[ HEADER ][ nI ][ 5 ] // top
               IF aReport[ HEADER ][ nI ][ 5 ] > aReport[ PAGEY ] / 72 * aReport[ LPI ] / 2
                  IF nTemp < aReport[ PDFBOTTOM ]
                     aReport[ PDFBOTTOM ] := nTemp
                  ENDIF
               ELSE
                  IF nTemp > aReport[ PDFTOP ]
                     aReport[ PDFTOP ] := nTemp
                  ENDIF
               ENDIF
            ELSEIF aReport[ HEADER ][ nI ][ 7 ] == "M"
               nTemp := aReport[ HEADER ][ nI ][ 5 ] * aReport[ LPI ] / 25.4 // top
               IF aReport[ HEADER ][ nI ][ 5 ] > aReport[ PAGEY ] / 72 * 25.4 / 2
                  IF nTemp < aReport[ PDFBOTTOM ]
                     aReport[ PDFBOTTOM ] := nTemp
                  ENDIF
               ELSE
                  IF nTemp > aReport[ PDFTOP ]
                     aReport[ PDFTOP ] := nTemp
                  ENDIF
               ENDIF
            ELSEIF aReport[ HEADER ][ nI ][ 7 ] == "D"
               nTemp := aReport[ HEADER ][ nI ][ 5 ] / aReport[ LPI ] // top
               IF aReport[ HEADER ][ nI ][ 5 ] > aReport[ PAGEY ] / 2
                  IF nTemp < aReport[ PDFBOTTOM ]
                     aReport[ PDFBOTTOM ] := nTemp
                  ENDIF
               ELSE
                  IF nTemp > aReport[ PDFTOP ]
                     aReport[ PDFTOP ] := nTemp
                  ENDIF
               ENDIF
            ENDIF
         ENDIF
      ENDIF
   next

   aReport[ MARGINS ] := .f.

return nil
/*
*/
function pdfCreateHeader( _file, _size, _orient, _lpi, _width )
local ;
   aReportStyle := {                                                  ;
                     { 1,     2,   3,   4,    5,     6    }, ; //"Default"
                     { 2.475, 4.0, 4.9, 6.4,  7.5,  64.0  }, ; //"P6"
                     { 3.3  , 5.4, 6.5, 8.6, 10.0,  85.35 }, ; //"P8"
                     { 2.475, 4.0, 4.9, 6.4,  7.5,  48.9  }, ; //"L6"
                     { 3.3  , 5.4, 6.5, 8.6, 10.0,  65.2  }, ; //"L8"
                     { 2.475, 4.0, 4.9, 6.4,  7.5,  82.0  }, ; //"P6"
                     { 3.3  , 5.4, 6.5, 8.6, 10.0, 109.35 }  ; //"P8"
                   }
local nStyle := 1, nAdd := 0.00

DEFAULT _size to aReport[ PAGESIZE ]
DEFAULT _orient to aReport[ PAGEORIENT ]
DEFAULT _lpi to aReport[ LPI ]
DEFAULT _width to 200

   IF _size == "LETTER"
      IF _orient == "P"
         IF _lpi == 6
            nStyle := 2
         ELSEIF _lpi == 8
            nStyle := 3
         ENDIF
      ELSEIF _orient == "L"
         IF _lpi == 6
            nStyle := 4
         ELSEIF _lpi == 8
            nStyle := 5
         ENDIF
      ENDIF
   ELSEIF _size == "LEGAL"
      IF _orient == "P"
         IF _lpi == 6
            nStyle := 6
         ELSEIF _lpi == 8
            nStyle := 7
         ENDIF
      ELSEIF _orient == "L"
         IF _lpi == 6
            nStyle := 4
         ELSEIF _lpi == 8
            nStyle := 5
         ENDIF
      ENDIF
   ENDIF

   pdfEditOnHeader()

   IF _size == "LEGAL"
      nAdd := 76.2
   ENDIF

   IF _orient == "P"
      pdfBox(   5.0, 5.0, 274.0 + nAdd, 210.0,  1.0 )
      pdfBox(   6.5, 6.5, 272.5 + nAdd, 208.5,  0.5 )

      pdfBox(  11.5, 9.5,  22.0       , 205.5,  0.5, 5 )
      pdfBox(  23.0, 9.5,  33.5       , 205.5,  0.5, 5 )
      pdfBox(  34.5, 9.5, 267.5 + nAdd, 205.5,  0.5 )

   ELSE
      pdfBox(  5.0, 5.0, 210.0, 274.0 + nAdd, 1.0 )
      pdfBox(  6.5, 6.5, 208.5, 272.5 + nAdd, 0.5 )

      pdfBox( 11.5, 9.5,  22.0, 269.5 + nAdd, 0.5, 5 )
      pdfBox( 23.0, 9.5,  33.5, 269.5 + nAdd, 0.5, 5 )
      pdfBox( 34.5, 9.5, 203.5, 269.5 + nAdd, 0.5 )
   ENDIF

   pdfSetFont("Helvetica", BOLD, 10) // 0.04
   pdfAtSay( "Test Line 1", aReportStyle[ nStyle ][ 1 ], 1, "R", .t. )

   pdfSetFont("Times", BOLD, 18)
   pdfCenter( "Test Line 2", aReportStyle[ nStyle ][ 2 ],,"R", .t. )

   pdfSetFont("Times", BOLD, 12)
   pdfCenter( "Test Line 3", aReportStyle[ nStyle ][ 3 ],,"R", .t. )

   pdfSetFont("Helvetica", BOLD, 10) // 0.04
   pdfAtSay( "Test Line 4", aReportStyle[ nStyle ][ 4 ], 1, "R", .t. )

   pdfSetFont("Helvetica", BOLD, 10) // 0.04
   pdfAtSay( "Test Line 5", aReportStyle[ nStyle ][ 5 ], 1, "R", .t. )

   pdfAtSay( dtoc( date()) + " " + TimeAsAMPM( time() ), aReportStyle[ nStyle ][ 6 ], 1, "R", .t. )
   pdfRJust( "Page: #pagenumber#", aReportStyle[ nStyle ][ 6 ], aReport[ REPORTWIDTH ], "R", .t. )

   pdfEditOffHeader()
   pdfSaveHeader( _file )

return nil
/*
*/
function pdfImageInfo( cFile )
local cTemp := upper(substr( cFile, rat('.', cFile) + 1 )), aTemp := {}
   do case
   case cTemp == "TIF"
      aTemp := pdfTIFFInfo( cFile )
   case cTemp == "JPG"
      aTemp := pdfJPEGInfo( cFile )
   case cTemp == "PNG"
      aTemp := pdfPngInfo( cFile )
   endcase
return aTemp
/*
*/
function pdfTIFFInfo( cFile )
local c40 := chr(0)+chr(0)+chr(0)+chr(0)
local aType := {"BYTE","ASCII","SHORT","LONG","RATIONAL","SBYTE","UNDEFINED","SSHORT","SLONG","SRATIONAL","FLOAT","DOUBLE"}
local aCount := { 1, 1, 2, 4, 8, 1, 1, 2, 4, 8, 4, 8 }
local nTemp, nHandle, cValues, c2, nI, nFieldType, nCount, nPos, nTag, nValues
local nOffset, cTemp, cIFDNext, nIFD, nFields, cTag, nPages, nn

local nWidth := 0, nHeight := 0, nBits := 0, nFrom := 0, nLength := 0, xRes := 0, yRes := 0, aTemp := {}, nSpace

   nHandle := fopen( cFile )

   c2 := '  '
   fread( nHandle, @c2, 2 )
/*
if c2 == 'II' .or. c2 == 'MM'
else
   alert("Not II or MM")
endif
*/
   fread( nHandle, @c2, 2 )
/*
if c2 <> '*' + chr(0)
   alert("Not *")
endif
*/
   cIFDNext := '    '
   fread( nHandle, @cIFDNext, 4 )

   cTemp := space(12)
   nPages := 0

   while cIFDNext <> c40 //read IFD's

      nIFD := bin2l( cIFDNext )

      fseek( nHandle, nIFD )
      //?'*** IFD ' + ltrim(str( ++nPages ))

      fread( nHandle, @c2, 2 )
      nFields := bin2i( c2 )

      for nn := 1 to nFields
         fread( nHandle, @cTemp, 12 )

         nTag := bin2w( substr( cTemp, 1, 2 ) )
         nFieldType := bin2w(substr( cTemp, 3, 2 ))
      /*
      1 = BYTE       8-bit unsigned integer.
      2 = ASCII      8-bit byte that contains a 7-bit ASCII code; the last byte
                     must be NUL (binary zero).
      3 = SHORT      16-bit (2-byte) unsigned integer.
      4 = LONG       32-bit (4-byte) unsigned integer.
      5 = RATIONAL   Two LONGs: the first represents the numerator of a
                     fraction; the second, the denominator.

      In TIFF 6.0, some new field types have been defined:

      6 = SBYTE      An 8-bit signed (twos-complement) integer.
      7 = UNDEFINED  An 8-bit byte that may contain anything, depending on
                     the definition of the field.
      8 = SSHORT     A 16-bit (2-byte) signed (twos-complement) integer.
      9 = SLONG      A 32-bit (4-byte) signed (twos-complement) integer.
      10 = SRATIONAL Two SLONG�s: the first represents the numerator of a
                     fraction, the second the denominator.
      11 = FLOAT     Single precision (4-byte) IEEE format.
      12 = DOUBLE    Double precision (8-byte) IEEE format.
      */
         nCount := bin2l(substr( cTemp, 5, 4 ))
         nOffset := bin2l(substr( cTemp, 9, 4 ))

         IF nCount > 1 .or. nFieldType == RATIONAL .or. nFieldType == SRATIONAL
            nPos := filepos( nHandle )
            fseek( nHandle, nOffset)

            nValues := nCount * aCount[ nFieldType ]
            cValues := space( nValues )
            fread( nHandle, @cValues, nValues )
            fseek( nHandle, nPos )
         ELSE
            cValues := substr( cTemp, 9, 4 )
         ENDIF

         IF nFieldType ==  ASCII
            --nCount
         ENDIF
         //?'Tag'
         //??' ' + padr( nTag, 10 )
         cTag := ''
         do case
         case nTag == 256
               /*
               ImageWidth
               Tag = 256 (100.H)
               Type = SHORT or LONG
               The number of columns in the image, i.e., the number of pixels per scanline.
               */
            //??'ImageWidth'
            cTag := 'ImageWidth'
/*
               IF nFieldType <> SHORT .and. nFieldType <> LONG
                  alert('Wrong Type for ImageWidth')
               ENDIF
*/
            IF nFieldType ==  SHORT
               nWidth := bin2w(substr( cValues, 1, 2 ))
            ELSEIF nFieldType ==  LONG
               nWidth := bin2l(substr( cValues, 1, 4 ))
            ENDIF

         case nTag == 257
               /*
               ImageLength
               Tag = 257 (101.H)
               Type = SHORT or LONG
               The number of rows (sometimes described as scanlines) in the image.
               */
            //??'ImageLength'
            cTag := 'ImageLength'
/*
               IF nFieldType <> SHORT .and. nFieldType <> LONG
                  alert('Wrong Type for ImageLength')
               ENDIF
*/
            IF nFieldType ==  SHORT
               nHeight := bin2w(substr( cValues, 1, 2 ))
            ELSEIF nFieldType ==  LONG
               nHeight := bin2l(substr( cValues, 1, 4 ))
            ENDIF

         case nTag == 258
               /*
               BitsPerSample
               Tag = 258 (102.H)
               Type = SHORT
               The number of bits per component.
               Allowable values for Baseline TIFF grayscale images are 4 and 8, allowing either
               16 or 256 distinct shades of gray.
               */
            //??'BitsPerSample'
            cTag := 'BitsPerSample'
            nTemp := 0
            IF nFieldType == SHORT
               nTemp := bin2w( cValues )
            ELSE
               //alert('Wrong Type for BitsPerSample')
            ENDIF
            nBits := nTemp
            //IF nTemp <> 4 .and. nTemp <> 8
            //   alert('Wrong Value for BitsPerSample')
            //ENDIF
         case nTag == 259
               /*
               Compression
               Tag = 259 (103.H)
               Type = SHORT
               Values:
               1 = No compression, but pack data into bytes as tightly as possible, leaving no unused
               bits (except at the end of a row). The component values are stored as an array of
               type BYTE. Each scan line (row) is padded to the next BYTE boundary.
               2 = CCITT Group 3 1-Dimensional Modified Huffman run length encoding. See
               Section 10 for a description of Modified Huffman Compression.
               32773 = PackBits compression, a simple byte-oriented run length scheme. See the
               PackBits section for details.
               Data compression applies only to raster image data. All other TIFF fields are
               unaffected.
               Baseline TIFF readers must handle all three compression schemes.
               */
            //??'Compression'
            cTag := 'Compression'
            nTemp := 0
            IF nFieldType == SHORT
               nTemp := bin2w( cValues )
            ELSE
               //alert('Wrong Type for Compression')
            ENDIF
            //IF nTemp <> 1 .and. nTemp <> 2 .and. nTemp <> 32773
            //   alert('Wrong Value for Compression')
            //ENDIF
         case nTag == 262
               /*
               PhotometricInterpretation
               Tag = 262 (106.H)
               Type = SHORT
               Values:
               0 = WhiteIsZero. For bilevel and grayscale images: 0 is imaged as white. The maxi-mum
               value is imaged as black. This is the normal value for Compression=2.
               1 = BlackIsZero. For bilevel and grayscale images: 0 is imaged as black. The maxi-mum
               value is imaged as white. If this value is specified for Compression=2, the
               image should display and print reversed.
               */
            //??'PhotometricInterpretation'
            cTag := 'PhotometricInterpretation'
            nTemp := -1
            IF nFieldType == SHORT
               nTemp := bin2w( cValues )
            ELSE
               //alert('Wrong Type for PhotometricInterpretation')
            ENDIF
            IF nTemp <> 0 .and. nTemp <> 1 .and. nTemp <> 2 .and. nTemp <> 3
               //alert('Wrong Value for PhotometricInterpretation')
            ENDIF
         case nTag == 264
               /*
               CellWidth
               The width of the dithering or halftoning matrix used to create a dithered or
               halftoned bilevel file.Tag = 264 (108.H)
               Type = SHORT
               N = 1
               No default. See also Threshholding.
               */
            //??'CellWidth'
            cTag := 'CellWidth'
            IF nFieldType <> SHORT
               //alert('Wrong Type for CellWidth')
            ENDIF
         case nTag == 265
               /*
               CellLength
               The length of the dithering or halftoning matrix used to create a dithered or
               halftoned bilevel file.
               Tag = 265 (109.H)
               Type = SHORT
               N = 1
               This field should only be present if Threshholding = 2
               No default. See also Threshholding.
               */
            //??'CellLength'
            cTag := 'CellLength'
            IF nFieldType <> SHORT
               //alert('Wrong Type for CellLength')
            ENDIF
         case nTag == 266
               /*
               FillOrder
               The logical order of bits within a byte.
               Tag = 266 (10A.H)
               Type = SHORT
               N = 1
               */
            //??'FillOrder'
            cTag := 'FillOrder'
            IF nFieldType <> SHORT
               //alert('Wrong Type for FillOrder')
            ENDIF
         case nTag == 273
               /*
               StripOffsets
               Tag = 273 (111.H)
               Type = SHORT or LONG
               For each strip, the byte offset of that strip.
               */
            //??'StripOffsets'
            cTag := 'StripOffsets'
            IF nFieldType <> SHORT .and. nFieldType <> LONG
               //alert('Wrong Type for StripOffsets')
            ENDIF

            IF nFieldType ==  SHORT
               nFrom := bin2w(substr( cValues, 1, 2 ))
            ELSEIF nFieldType ==  LONG
               nFrom := bin2l(substr( cValues, 1, 4 ))
            ENDIF

         case nTag == 277
               /*
               SamplesPerPixel
               Tag = 277 (115.H)
               Type = SHORT
               The number of components per pixel. This number is 3 for RGB images, unless
               extra samples are present. See the ExtraSamples field for further information.
               */
            //??'SamplesPerPixel'
            cTag := 'SamplesPerPixel'
            IF nFieldType <> SHORT
               //alert('Wrong Type for SamplesPerPixel')
            ENDIF
         case nTag == 278
               /*
               RowsPerStrip
               Tag = 278 (116.H)
               Type = SHORT or LONG
               The number of rows in each strip (except possibly the last strip.)
               For example, if ImageLength is 24, and RowsPerStrip is 10, then there are 3
               strips, with 10 rows in the first strip, 10 rows in the second strip, and 4 rows in the
               third strip. (The data in the last strip is not padded with 6 extra rows of dummy
               data.)
               */
            //??'RowsPerStrip'
            cTag := 'RowsPerStrip'
            IF nFieldType <> SHORT .and. nFieldType <> LONG
               //alert('Wrong Type for RowsPerStrip')
            ENDIF
         case nTag == 279
               /*
               StripByteCounts
               Tag = 279 (117.H)
               Type = SHORT or LONG
               For each strip, the number of bytes in that strip after any compression.
               */
            //??'StripByteCounts'
            cTag := 'StripByteCounts'
            IF nFieldType <> SHORT .and. nFieldType <> LONG
               //alert('Wrong Type for StripByteCounts')
            ENDIF

            IF nFieldType ==  SHORT
               nLength := bin2w(substr( cValues, 1, 2 ))
            ELSEIF nFieldType ==  LONG
               nLength := bin2l(substr( cValues, 1, 4 ))
            ENDIF

            nLength *= nCount // Count all strips !!!

         case nTag == 282
               /*
               XResolution
               Tag = 282 (11A.H)
               Type = RATIONAL
               The number of pixels per ResolutionUnit in the ImageWidth (typically, horizontal
               - see Orientation) direction.
               */
            //??'XResolution'
            cTag := 'XResolution'
            IF nFieldType <> RATIONAL
               //alert('Wrong Type for XResolution')
            ENDIF
            xRes := bin2l(substr( cValues, 1, 4 ))
         case nTag == 283
               /*
               YResolution
               Tag = 283 (11B.H)
               Type = RATIONAL
               The number of pixels per ResolutionUnit in the ImageLength (typically, vertical)
               direction.
               */
            //??'YResolution'
            cTag := 'YResolution'
            IF nFieldType <> RATIONAL
               //alert('Wrong Type for YResolution')
            ENDIF
            yRes := bin2l(substr( cValues, 1, 4 ))
         case nTag == 284
            //??'PlanarConfiguration'
            cTag := 'PlanarConfiguration'
            IF nFieldType <> SHORT
               //alert('Wrong Type for PlanarConfiguration')
            ENDIF
         case nTag == 288
               /*
               FreeOffsets
               For each string of contiguous unused bytes in a TIFF file, the byte offset of the
               string.
               Tag = 288 (120.H)
               Type = LONG
               Not recommended for general interchange.
               See also FreeByteCounts.
               */
            //??'FreeOffsets'
            cTag := 'FreeOffsets'
            IF nFieldType <> LONG
               //alert('Wrong Type for FreeOffsets')
            ENDIF
         case nTag == 289
               /*
               FreeByteCounts
               For each string of contiguous unused bytes in a TIFF file, the number of bytes in
               the string.
               Tag = 289 (121.H)
               Type = LONG
               Not recommended for general interchange.
               See also FreeOffsets.
               */
            //??'FreeByteCounts'
            cTag := 'FreeByteCounts'
            IF nFieldType <> LONG
               //alert('Wrong Type for FreeByteCounts')
            ENDIF
         case nTag == 296
               /*
               ResolutionUnit
               Tag = 296 (128.H)
               Type = SHORT
               Values:
               1 = No absolute unit of measurement. Used for images that may have a non-square
               aspect ratio but no meaningful absolute dimensions.
               2 = Inch.
               3 = Centimeter.
               Default = 2 (inch).
               */
            //??'ResolutionUnit'
            cTag := 'ResolutionUnit'
            nTemp := 0
            IF nFieldType == SHORT
               nTemp := bin2w( cValues )
            ELSE
               //alert('Wrong Type for ResolutionUnit')
            ENDIF
            IF nTemp <> 1 .and. nTemp <> 2 .and. nTemp <> 3
               //alert('Wrong Value for ResolutionUnit')
            ENDIF
         case nTag == 305
            //??'Software'
            cTag := 'Software'
            IF nFieldType <> ASCII
               //alert('Wrong Type for Software')
            ENDIF
         case nTag == 306
               /*
               DateTime
               Date and time of image creation.
               Tag = 306 (132.H)
               Type = ASCII
               N = 2 0
               The format is: YYYY:MM:DD HH:MM:SS, with hours like those on a 24-hour
               clock, and one space character between the date and the time. The length of the
               string, including the terminating NUL, is 20 bytes.
               */
            //??'DateTime'
            cTag := 'DateTime'
            IF nFieldType <> ASCII
               //alert('Wrong Type for DateTime')
            ENDIF
         case nTag == 315
               /*
               Artist
               Person who created the image.
               Tag = 315 (13B.H)
               Type = ASCII
               Note: some older TIFF files used this tag for storing Copyright information.
               */
            //??'Artist'
            cTag := 'Artist'
            IF nFieldType <> ASCII
               //alert('Wrong Type for Artist')
            ENDIF
         case nTag == 320
               /*
               ColorMap
               Tag = 320 (140.H)
               Type = SHORT
               N = 3 * (2**BitsPerSample)
               This field defines a Red-Green-Blue color map (often called a lookup table) for
               palette color images. In a palette-color image, a pixel value is used to index into an
               RGB-lookup table. For example, a palette-color pixel having a value of 0 would
               be displayed according to the 0th Red, Green, Blue triplet.
               In a TIFF ColorMap, all the Red values come first, followed by the Green values,
               then the Blue values. In the ColorMap, black is represented by 0,0,0 and white is
               represented by 65535, 65535, 65535.
               */
            //??'ColorMap'
            cTag := 'ColorMap'
            IF nFieldType <> SHORT
               //alert('Wrong Type for ColorMap')
            ENDIF
         case nTag == 338
               /*
               ExtraSamples
               Description of extra components.
               Tag = 338 (152.H)
               Type = SHORT
               N = m
               */
            //??'ExtraSamples'
            cTag := 'ExtraSamples'
            IF nFieldType <> SHORT
               //alert('Wrong Type for ExtraSamples')
            ENDIF
         case nTag == 33432
               /*
               Copyright
               Copyright notice.
               Tag = 33432 (8298.H)
               Type = ASCII
               Copyright notice of the person or organization that claims the copyright to the
               image. The complete copyright statement should be listed in this field including
               any dates and statements of claims. For example, �Copyright, John Smith, 19xx.
               All rights reserved.
               */
            //??'Copyright'
            cTag := 'Copyright'
            IF nFieldType <> ASCII
               //alert('Wrong Type for Copyright')
            ENDIF
         otherwise
            //??'Unknown'
            cTag := 'Unknown'
         endcase
      /*
      ??padr( cTag, 30 )
      ??' type ' + padr(aType[ nFieldType ], 10) + ' count ' + ltrim(str(nCount)) + ' <'
      do case
         case nFieldType ==  BYTE
              for nI := 1 to nCount
                  ??' ' + ltrim(str(asc( substr( cValues, nI, 1 ))))
              next
         case nFieldType ==  ASCII
              ??' '
              for nI := 1 to nCount
                  ??substr( cValues, nI, 1 )
              next
         case nFieldType ==  SHORT
              for nI := 1 to nCount
                  ??' ' + ltrim(str(bin2w(substr( cValues, ( nI - 1 ) * 2 + 1, 2 ))))
              next
         case nFieldType ==  LONG
              for nI := 1 to nCount
                  ??' ' + ltrim(str(bin2l(substr( cValues, ( nI - 1 ) * 4 + 1, 4 ))))
              next
         case nFieldType ==  RATIONAL
              for nI := 1 to nCount
                  ??' ' + ltrim(str(bin2l(substr( cValues, ( nI - 1 ) * 8 + 1, 4 )))) + '/' + ltrim(str(bin2l(substr( cValues, nI + 4, 4 ))))
              next
         case nFieldType ==  SBYTE
              for nI := 1 to nCount
                  ??' ' + ltrim(str(asc( substr( cValues, nI, 1 ))))
              next
         case nFieldType ==  UNDEFINED
              for nI := 1 to nCount
                  ??' ' + substr( cValues, nI, 1 )
              next
         case nFieldType ==  SSHORT
              for nI := 1 to nCount
                  ??' ' + ltrim(str(bin2i(substr( cValues, ( nI - 1 ) * 2 + 1, 2 ))))
              next
         case nFieldType ==  SLONG
              for nI := 1 to nCount
                  ??' ' + ltrim(str(bin2l(substr( cValues, ( nI - 1 ) * 4 + 1, 4 ))))
              next
         case nFieldType == SRATIONAL
              for nI := 1 to nCount
                  ??' ' + ltrim(str(bin2l(substr( cValues, ( nI - 1 ) * 8 + 1, 4 )))) + '/' + ltrim(str(bin2l(substr( cValues, nI + 4, 4 ))))
              next
         case nFieldType == FLOAT
         case nFieldType == DOUBLE
              for nI := 1 to nCount
                  ??' ' + ltrim(str(ctof(substr( cValues, ( nI - 1 ) * 8 + 1, 8 ))))
              next

      endcase
      ??' >'
      */
      next
      fread( nHandle, @cIFDNext, 4 )
   enddo

   fclose( nHandle )

   aadd( aTemp, nWidth )
   aadd( aTemp, nHeight )
   aadd( aTemp, xRes )
   aadd( aTemp, yRes )
   aadd( aTemp, nBits )
   aadd( aTemp, nFrom )
   aadd( aTemp, nLength )

   nSpace := 0
   aadd( aTemp, nSpace )
return aTemp
/*
*/
function pdfJPEGInfo( cFile )
local c255, nAt, nHandle
local nWidth := 0, nHeight := 0, nBits := 8, nFrom := 0, nLength := 0, xRes := 0, yRes := 0, aTemp := {}
local nBuffer := 20000
local nSpace := 3 // 3 - RGB, 1 - GREY, 4 - CMYK

   nHandle := fopen( cFile )

   c255 := space( nBuffer )
   fread( nHandle, @c255, nBuffer )

   xRes := asc(substr( c255, 15, 1 )) * 256 + asc(substr( c255, 16, 1 ))
   yRes := asc( substr( c255, 17, 1 )) * 256 + asc(substr( c255, 18, 1 ))

   //nAt := at( chr(255) + chr(192), c255 ) + 5
   nAt := rat( chr(255) + chr(192), c255 ) + 5
   nHeight := asc(substr( c255, nAt, 1 )) * 256 + asc(substr( c255, nAt + 1, 1 ))
   nWidth := asc( substr( c255, nAt + 2, 1 )) * 256 + asc(substr( c255, nAt + 3, 1 ))

   nSpace := asc( substr( c255, nAt + 4, 1 ))

   nLength := filesize( nHandle )

   fclose( nHandle )

   aadd( aTemp, nWidth )
   aadd( aTemp, nHeight )
   aadd( aTemp, xRes )
   aadd( aTemp, yRes )
   aadd( aTemp, nBits )
   aadd( aTemp, nFrom )
   aadd( aTemp, nLength )
   aadd( aTemp, nSpace )

return aTemp
/*
*/
function Pdfpnginfo( cFile )

LOCAL c255
LOCAL nAt
LOCAL nHandle
LOCAL nWidth       := 0
LOCAL nHeight      := 0
LOCAL nBits        := 8
LOCAL nFrom        := 135
LOCAL nPLTEPos
LOCAL nDistTonPhys := 0
LOCAL nPhys
LOCAL nLength      := filesize( cFile )
LOCAL xRes         := 0
LOCAL cPalletData  := ""
LOCAL yRes         := 0
LOCAL aTemp        := {}
LOCAL nIendPos     := nLength - 16
LOCAL nb
LOCAL cData        := ""
LOCAL nColor

   nHandle := Fopen( cFile )

   c255 := Space( 1024 )
   Fread( nHandle, @c255, 1024 )

   //   xRes := asc(SubStr( c255, 15, 1 )) * 256 + asc(SubStr( c255, 16, 1 ))
   //   yRes := asc( SubStr( c255, 17, 1 )) * 256 + asc(SubStr( c255, 18, 1 ))

   //   nAt := At( Chr(255) + Chr(192), c255 ) + 5
   //   nHeight := asc(SubStr( c255, nAt, 1 )) * 256 + asc(SubStr( c255, nAt + 1, 1 ))
   //   nWidth := asc( SubStr( c255, nAt + 2, 1 )) * 256 + asc(SubStr( c255, nAt + 3, 1 ))
   nPLTEPos := At( "PLTE", c255 )

   IF nPLTEPos > 0
      nPhys := At( 'pHYs', c255 )
      nFrom := At( "IDAT", c255 ) + 3

      nPLTEPos     += 4
      nDistTonPhys := 768
      cPalletData  := Substr( c255, nPLTEPos, nDistTonPhys )

   ENDIF

   xRes   := ( Asc( Substr( c255, 17, 1 ) ) ) + ( Asc( Substr( c255, 18, 1 ) ) ) + ( Asc( Substr( c255, 19, 1 ) ) ) + ( Asc( Substr( c255, 20, 1 ) ) )
   yRes   := ( Asc( Substr( c255, 21, 1 ) ) ) + ( Asc( Substr( c255, 22, 1 ) ) ) + ( Asc( Substr( c255, 23, 1 ) ) ) + ( Asc( Substr( c255, 24, 1 ) ) )
   nBits  := ( Asc( Substr( c255, 25, 1 ) ) )
   nColor := ( Asc( Substr( c255, 26, 1 ) ) )
   cData  := Substr( c255, At( "IDAT", c255 ) + 4 )
   nb     := At( "IDAT", c255 )

   nLength := filesize( nHandle )

   Fclose( nHandle )

   Aadd( aTemp, xRes )
   Aadd( aTemp, yRes )
   Aadd( aTemp, xRes )
   Aadd( aTemp, yRes )
   Aadd( aTemp, nBits )
   Aadd( aTemp, nFrom )
//   Aadd( aTemp, nLength )
   Aadd( aTemp, nLength - nFrom - 16 )
   Aadd( aTemp, nColor )
   Aadd( aTemp, cPalletData )
   Aadd( aTemp, nDistTonPhys )

RETURN aTemp
/*
*/
FUNCTION FilePos( nHandle )
/*
*/
RETURN ( FSEEK( nHandle, 0, FS_RELATIVE ) )
/*
*/
FUNCTION pdfFilePrint( cFile )
/*
*/
LOCAL cPrg := GetOpenCommand( "pdf" )
LOCAL cRun := cPrg + " /t " + cFile + " " + chr(34) + GetDefaultPrn() + chr(34)

IF !EMPTY(cPrg)
   RUN( cRun )
ENDIF

RETURN !EMPTY(cPrg)
/*
*/
FUNCTION Chr_RGB( cChar )
/*
*/
RETURN str(asc( cChar ) / 255, 4, 2)
/*
*/
FUNCTION NumToken( cString, cDelimiter )
/*
*/
RETURN AllToken( cString, cDelimiter )
/*
*/
FUNCTION Token( cString, cDelimiter, nPointer )
/*
*/
RETURN AllToken( cString, cDelimiter, nPointer, 1 )
/*
*/
FUNCTION AtToken( cString, cDelimiter, nPointer )
/*
*/
RETURN AllToken( cString, cDelimiter, nPointer, 2 )
/*
*/
FUNCTION AllToken( cString, cDelimiter, nPointer, nAction )
/*
*/
LOCAL nTokens := 0, nPos := 1, nLen := len( cString ), nStart := 0, cToken := "", cRet
DEFAULT cDelimiter to chr(0)+chr(9)+chr(10)+chr(13)+chr(26)+chr(32)+chr(138)+chr(141)
DEFAULT nAction to 0

// nAction == 0 - numtoken
// nAction == 1 - token
// nAction == 2 - attoken

      while nPos <= nLen
            if .not. substr( cString, nPos, 1 ) $ cDelimiter
               nStart := nPos
               while nPos <= nLen .and. .not. substr( cString, nPos, 1 ) $ cDelimiter
                     ++nPos
               enddo
               ++nTokens
               IF nAction > 0
                  IF nPointer == nTokens
                     IF nAction == 1
                        cRet := substr( cString, nStart, nPos - nStart )
                     ELSE
                        cRet := nStart
                     ENDIF
                     exit
                  ENDIF
               ENDIF
            endif
            if substr( cString, nPos, 1 ) $ cDelimiter
               while nPos <= nLen .and. substr( cString, nPos, 1 ) $ cDelimiter
                     ++nPos
               enddo
            endif
            cRet := nTokens
      ENDDO
RETURN cRet
/*
*/
FUNCTION NumAt( cSearch, cString )
   LOCAL n := 0, nAt := 0, nPos := 0
   WHILE ( nAt := at( cSearch, substr( cString, nPos + 1 ) )) > 0
           nPos += nAt
           ++n
   ENDDO
RETURN n
/*
*/
FUNCTION FileSize( nHandle )

   LOCAL nCurrent
   LOCAL nLength

   // Get file position
   nCurrent := FilePos( nHandle )

   // Get file length
   nLength := FSEEK( nHandle, 0, FS_END )

   // Reset file position
   FSEEK( nHandle, nCurrent )

RETURN ( nLength )

// next 3 function written by Peter Kulek
//modified for compatibility with common.ch by V.K.
//modified DATE processing by V.K.
function Array2File(cFile,aRay,nDepth,hFile)
local nBytes := 0
local i
nDepth := if(ISNUMBER(nDepth),nDepth,0)
if hFile == NIL
   if (hFile := fCreate(cFile,FC_NORMAL)) == -1
      return(nBytes)
   endif
endif
nDepth++
nBytes += WriteData(hFile,aRay)
if ISARRAY(aRay)
   for i := 1 to len(aRay)
      nBytes += Array2File(cFile,aRay[i],nDepth,hFile)
   next
endif
nDepth--
if nDepth == 0
   fClose(hFile)
endif
return(nBytes)

static function WriteData(hFile,xData)
local cData  := valtype(xData)
local nLen
   if ISCHARACTER(xData)
       cData += i2bin(len(xData))+xData
   elseif ISNUMBER(xData)
       cData += i2bin(len(alltrim(str(xData))) )+alltrim(str(xData))
   elseif ISDATE(xData)
       cData += i2bin(8)+dtos(xData)
   elseif ISLOGICAL(xData)
       cData += i2bin(1)+if(xData,'T','F')
   elseif ISARRAY(xData)
       cData += i2bin(len(xData))
   else
       cData += i2bin(0)   // NIL
   endif
return( fWrite(hFile,cData,len(cData)) )

function File2Array(cFile,nLen,hFile)
LOCAL cData,cType,nDataLen,nBytes
local nDepth := 0
local aRay   := {}
if hFile == NIL
     if (hFile:=fOpen(cFile,FO_READ)) == -1
         return(aRay)
     endif
     cData := space(3)
     fRead(hFile,@cData,3)
     if left(cData,1) != 'A'
         return( aRay)
     endif
     nLen := bin2i(right(cData,2))
endif
do while nDepth < nLen
    cData  := space(3)
    nBytes := fRead(hFile,@cData,3)
    if nBytes<3
       exit
    endif
    cType:= padl(cData,1)
    nDataLen:= bin2i(right(cData,2))
    if cType != 'A'
       cData := space(nDataLen)
       nBytes:= fRead(hFile,@cData,nDataLen)
       if nBytes<nDataLen
           exit
       endif
    endif
    nDepth++
    aadd(aRay,NIL)
    if cType=='C'
        aRay[nDepth] := cData
    elseif cType=='N'
        aRay[nDepth] := val(cData)
    elseif cType=='D'
        aRay[nDepth] := ctod( left( cData, 4 ) + "/" + substr( cData, 5, 2 ) + "/" + substr( cData, 7, 2 )) //stod(cData)
    elseif cType=='L'
        aRay[nDepth] := (cData=='T')
    elseif cType=='A'
        aRay[nDepth] := File2Array(,nDataLen,hFile)
    endif
enddo
if cFile!=NIL
    fClose(hFile)
endif
return(aRay)
// end of 3rd function written by Peter Kulek

// WRAPPERs
function GetOpenCommand( cExt )
return ""
/*

function GetOpenCommand( cExt )
Local oReg, cVar1 := "", cVar2 := "", nPos

If ! ValType( cExt ) == "C"
   Return ""
Endif

If ! Left( cExt, 1 ) == "."
   cExt := "." + cExt
Endif

oReg := TReg32():New( HKEY_CLASSES_ROOT, cExt, .f. )
cVar1 := RTrim( StrTran( oReg:Get( Nil, "" ), Chr(0), " " ) ) // i.e look for (Default) key
oReg:close()

If ! Empty( cVar1 )
   oReg := TReg32():New( HKEY_CLASSES_ROOT, cVar1 + "\shell\open\command" )
   cVar2 := RTrim( StrTran( oReg:Get( Nil, "" ), Chr(0), " " ) )  // i.e look for (Default) key
   oReg:close()

   If ( nPos := RAt( " %1", cVar2 ) ) > 0        // look for param placeholder without the quotes (ie notepad)
      cVar2 := SubStr( cVar2, 1, nPos )
   Elseif ( nPos := RAt( '"%', cVar2 ) ) > 0     // look for stuff like "%1", "%L", and so forth (ie, with quotes)
      cVar2 := SubStr( cVar2, 1, nPos - 1 )
   Endif
Endif

Return RTrim( cVar2 )
*/

// Wrapper
Function GetDefaultPrn()
return ""
/*

Function GetDefaultPrn()
Local oReg, cVar := ""

oReg := TReg32():New( HKEY_CURRENT_CONFIG, "System\CurrentControlSet\Control\Print\Printers", .f. )
cVar := oReg:Get( "Default", "" )
oReg:close()

return cVar
*/
