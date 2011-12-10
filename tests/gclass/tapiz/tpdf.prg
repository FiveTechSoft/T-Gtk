/*
 * $Id: tpdft.prg 16754 2011-05-11 16:05:43Z vszakats $
 */

//-------------------------\\
//
//    Program tPdf.prg
//
//    Original   : Victor K.    . http://www.ihaveparts.com
//
//    Class Code : Pritpal Bedi . http://www.vouchcac.com
//
//    Federico de Maussion      .  http://www.pc-soft.com.ar
//        Modificacion de clase
//        Implementacion de Codigo de Barras
//
//-------------------------\\


#include "hbclass.ch"
#include "pdf.ch"

//-------------------------\\

CREATE CLASS tPdf

    DATA aReport INIT Array( PARAMLEN )
    DATA Title INIT ""
    DATA Author INIT ""
    DATA Creator INIT ""
    DATA Subject INIT ""
    DATA Keywords INIT ""


    METHOD Init( cFile, nLen, lOptimize ) CONSTRUCTOR
    METHOD AtSay( cString, nRow, nCol, cUnits, lExact, cId )
    METHOD Normal()
    METHOD Bold()
    METHOD Italic()
    METHOD UnderLine( cString )
    METHOD BoldItalic()
    METHOD BookAdd( cTitle, nLevel, nPage, nLine )
    METHOD BookClose()
    METHOD BookOpen()
    METHOD Box( x1, y1, x2, y2, nBorder, nShade, cUnits, cColor, cId )
    METHOD Box1( nTop, nLeft, nBottom, nRight, nBorderWidth, cBorderColor, cBoxColor )
    METHOD Center( cString, nRow, nCol, cUnits, lExact, cId )
    METHOD Close()
    METHOD Image( cFile, nRow, nCol, cUnits, nHeight, nWidth, cId )
    METHOD Length( cString )
    METHOD NewLine( n )
    METHOD NewPage( _cPageSize, _cPageOrient, _nLpi, _cFontName, _nFontType, _nFontSize )
    METHOD PageSize( _cPageSize )
    METHOD PageOrient( _cPageOrient )
    METHOD PageNumber( n )
    METHOD Reverse( cString )
    METHOD RJust( cString, nRow, nCol, cUnits, lExact, cId )
    METHOD SetFont( _cFont, _nType, _nSize, cId )
    METHOD SetLPI(_nLpi)
    METHOD StringB( cString )
    METHOD TextCount( cString, nTop, nLeft, nLength, nTab, nJustify, cUnits )
    METHOD Text( cString, nTop, nLeft, nLength, nTab, nJustify, cUnits, cColor, lPrint )
    METHOD OpenHeader( cFile )
    METHOD EditOnHeader()
    METHOD EditOffHeader()
    METHOD CloseHeader()
    METHOD DeleteHeader( cId )
    METHOD EnableHeader( cId )
    METHOD DisableHeader( cId )
    METHOD SaveHeader( cId )
    METHOD Header( cFunction, cId, arr )
    METHOD DrawHeader()
    METHOD Margins( nTop, nLeft, nBottom )
    METHOD CreateHeader( _file, _size, _orient, _lpi, _width )
    METHOD ImageInfo( cFile )
    METHOD TIFFInfo( cFile )
    METHOD JPEGInfo( cFile )
    METHOD PNGInfo( cFile )
    METHOD BookCount( nRecno, nCurLevel )
    METHOD BookFirst( nRecno, nCurLevel, nObj )
    METHOD BookLast( nRecno, nCurLevel, nObj )
    METHOD BookNext( nRecno, nCurLevel, nObj )
    METHOD BookParent( nRecno, nCurLevel, nObj )
    METHOD BookPrev( nRecno, nCurLevel, nObj )
    METHOD CheckLine( nRow )
    METHOD ClosePage()
    METHOD GetFontInfo( cParam )
    METHOD M2R( mm )
    METHOD M2X( n )
    METHOD M2Y( n )
    METHOD R2D( nRow )
    METHOD R2M( nRow )
    METHOD X2M( n )
    METHOD TextPrint( nI, nLeft, lParagraph, nJustify, nSpace, nNew, nLength, nLineLen, nLines, nStart, cString, cDelim, cColor, lPrint )
    METHOD TextNextPara( cString, cDelim, nI )
/*
    METHOD FilePrint( cFile )
    METHOD Execute( cFile )
*/    
    //Inofrmacion del PDF
    METHOD InfoPDF( cTitle, cAuthor, cCreator, Subject, cKey )
    
    // Para Codigos de Barra
    METHOD Code39( nRow, nCol, cCode, lCheck, Color, lHorz, nWidth, nHeigth )
    METHOD Int25( nRow, nCol, cCode, lCheck, Color, lHorz, nWidth, nHeigth ) INLINE ::Code25( nRow, nCol, cCode, lCheck, Color, lHorz, nWidth, nHeigth, 1 )
    METHOD Ind25( nRow, nCol, cCode, lCheck, Color, lHorz, nWidth, nHeigth ) INLINE ::Code25( nRow, nCol, cCode, lCheck, Color, lHorz, nWidth, nHeigth, 2 )
    METHOD Mat25( nRow, nCol, cCode, lCheck, Color, lHorz, nWidth, nHeigth ) INLINE ::Code25( nRow, nCol, cCode, lCheck, Color, lHorz, nWidth, nHeigth, 3 )
    METHOD Code25( nRow, nCol, cCode, lCheck, Color, lHorz, nWidth, nHeigth, nTipo )
    METHOD Ean13( nRow, nCol, cCode, lCheck, Color, lHorz, nWidth, nHeigth )
    
    METHOD _UPC( cCode, nLen )
    
    METHOD Ean8( nRow, nCol, cCode, lCheck, Color, lHorz, nWidth, nHeigth )
    METHOD UPCA( nRow, nCol, cCode, lCheck, Color, lHorz, nWidth, nHeigth )
    METHOD Ean5( nRow, nCol, cCode, lCheck, Color, lHorz, nWidth, nHeigth )
    METHOD Codabar( nRow, nCol, cCode, lCheck, Color, lHorz, nWidth, nHeigth )
    METHOD Code128( nRow, nCol, cCode, lCheck, Color, lHorz, nWidth, nHeigth )
    METHOD Valida_Ean8( cCode ) INLINE ::Valida_UPC( cCode, 7 )
    METHOD Valida_Upca( cCode ) INLINE ::Valida_UPC( cCode, 11 )
    METHOD Valida_UPC( cCode, nLen ) 
    METHOD Valida_Ean13( cCode ) 
    
    METHOD Gen_Code( cBarra, nRow, nCol, lHorz, Color, nWidth, nHeigth )

ENDCLASS

//-------------------------\\

METHOD Init( cFile, nLen, lOptimize ) CLASS TPdf
local cTemp, nI, nJ, n1, n2 := 896, n12

DEFAULT nLen      TO 200
DEFAULT lOptimize TO .f.

//::aReport := array( PARAMLEN )

::aReport[ FONTNAME     ] := 1
::aReport[ FONTSIZE     ] := 10
::aReport[ LPI          ] := 6
::aReport[ PAGESIZE     ] := "LETTER"
::aReport[ PAGEORIENT   ] := "P"
::aReport[ PAGEX        ] := 8.50 * 72
::aReport[ PAGEY        ] := 11.00 * 72
::aReport[ REPORTWIDTH  ] := nLen    // 200 // should be as parameter
::aReport[ REPORTPAGE   ] := 0
::aReport[ REPORTLINE   ] := 0       // 5
::aReport[ FONTNAMEPREV ] := 0
::aReport[ FONTSIZEPREV ] := 0
::aReport[ PAGEBUFFER   ] := ""
::aReport[ REPORTOBJ    ] := 1       //2
::aReport[ DOCLEN       ] := 0
::aReport[ TYPE1        ] := { "Times-Roman", "Times-Bold", "Times-Italic", "Times-BoldItalic", ;
                               "Helvetica", "Helvetica-Bold", "Helvetica-Oblique", "Helvetica-BoldOblique", ;
                               "Courier", "Courier-Bold", "Courier-Oblique", "Courier-BoldOblique" }
::aReport[ MARGINS      ] := .t.
::aReport[ HEADEREDIT   ] := .f.
::aReport[ NEXTOBJ      ] := 0
::aReport[ PDFTOP       ] := 1      // top
::aReport[ PDFLEFT      ] := 10     // left & right
::aReport[ PDFBOTTOM    ] := ::aReport[ PAGEY ] / 72 * ::aReport[ LPI ] - 1 // bottom, default "LETTER", "P", 6
::aReport[ HANDLE       ] := fcreate( cFile )
::aReport[ PAGES        ] := {}
::aReport[ REFS         ] := { 0, 0 }
::aReport[ BOOKMARK     ] := {}
::aReport[ HEADER       ] := {}
::aReport[ FONTS        ] := {}
::aReport[ IMAGES       ] := {}
::aReport[ PAGEIMAGES   ] := {}
::aReport[ PAGEFONTS    ] := {}

cTemp := FontsDat()
n1    := len( cTemp ) / ( 2 * n2 )
::aReport[ FONTWIDTH    ] := array( n1, n2 )

::aReport[ OPTIMIZE     ] := lOptimize
::aReport[ NEXTOBJ      ] := ::aReport[ REPORTOBJ ] + 4

n12 := 2 * n2
for nI := 1 to n1
   for nJ := 1 to n2
      ::aReport[ FONTWIDTH ][ nI ][ nJ ] := bin2i( substr( cTemp, ( nI - 1 ) * n12 + ( nJ - 1 ) * 2 + 1, 2 ) )
   next
next

::aReport[ DOCLEN       ] := 0
cTemp                     := "%PDF-1.3" + CRLF
::aReport[ DOCLEN       ] += len( cTemp )

fwrite( ::aReport[ HANDLE ], cTemp )

RETURN self

//-------------------------\\

METHOD AtSay( cString, nRow, nCol, cUnits, lExact, cId ) CLASS TPdf
local _nFont, lReverse, nAt

DEFAULT nRow   TO ::aReport[ REPORTLINE ]
DEFAULT cUnits TO "R"
DEFAULT lExact TO .f.
DEFAULT cId    TO ""

   IF ::aReport[ HEADEREDIT ]
      return ::Header( "PDFATSAY", cId, { cString, nRow, nCol, cUnits, lExact } )
   ENDIF

   IF ( nAt := at( "#pagenumber#", cString ) ) > 0
      cString := left( cString, nAt - 1 ) + ltrim(str( ::PageNumber())) + substr( cString, nAt + 12 )
   ENDIF

   lReverse := .f.
   IF cUnits == "M"
      nRow := ::M2Y( nRow )
      nCol := ::M2X( nCol )
   ELSEIF cUnits == "R"
      IF .not. lExact
         ::CheckLine( nRow )
         nRow := nRow + ::aReport[ PDFTOP]
      ENDIF
      nRow := ::R2D( nRow )
      nCol := ::M2X( ::aReport[ PDFLEFT ] ) + ;
              nCol * 100.00 / ::aReport[ REPORTWIDTH ] * ;
              ( ::aReport[ PAGEX ] - ::M2X( ::aReport[ PDFLEFT ] ) * 2 - 9.0 ) / 100.00
   ELSEIF cUnits == "D"
      nRow := ::aReport[ PAGEY ] - nRow
//      nCol := ::aReport[ PAGEY ] nCol )
   ENDIF
   IF !empty( cString )
      cString := ::StringB( cString )
      IF right( cString, 1 ) == chr(255) //reverse
         cString := left( cString, len( cString ) - 1 )
         ::Box( ::aReport[ PAGEY ] - nRow - ::aReport[ FONTSIZE ] + 2.0 , nCol, ::aReport[ PAGEY ] - nRow + 2.0, nCol + ::M2X( ::length( cString )) + 1,,100, "D")
         ::aReport[ PAGEBUFFER ] += " 1 g "
         lReverse := .t.
      ELSEIF right( cString, 1 ) == chr(254) //underline
         cString := left( cString, len( cString ) - 1 )
         ::Box( ::aReport[ PAGEY ] - nRow + 0.5,  nCol, ::aReport[ PAGEY ] - nRow + 1, nCol + ::M2X( ::length( cString )) + 1,,100, "D")
      ENDIF

      // version 0.01
      IF ( nAt := at( chr(253), cString )) > 0 // some color text inside
         ::aReport[ PAGEBUFFER ] += CRLF + ;
         Chr_RGB( substr( cString, nAt + 1, 1 )) + " " + ;
         Chr_RGB( substr( cString, nAt + 2, 1 )) + " " + ;
         Chr_RGB( substr( cString, nAt + 3, 1 )) + " rg "
         cString := stuff( cString, nAt, 4, "")
      ENDIF
      // version 0.01

      _nFont := ascan( ::aReport[ FONTS ], {|arr| arr[1] == ::aReport[ FONTNAME ]} )
      IF !( ::aReport[ FONTNAME ] == ::aReport[ FONTNAMEPREV ] )
         ::aReport[ FONTNAMEPREV ] := ::aReport[ FONTNAME ]
         ::aReport[ PAGEBUFFER ] += CRLF + "BT /Fo" + ltrim(str( _nFont )) + " " + ltrim(transform( ::aReport[ FONTSIZE ], "999.99")) + " Tf " + ltrim(transform( nCol, "9999.99" )) + " " + ltrim(transform( nRow, "9999.99" )) + " Td (" + cString + ") Tj ET"
      ELSEIF ::aReport[ FONTSIZE ] != ::aReport[ FONTSIZEPREV ]
         ::aReport[ FONTSIZEPREV ] := ::aReport[ FONTSIZE ]
         ::aReport[ PAGEBUFFER ] += CRLF + "BT /Fo" + ltrim(str( _nFont )) + " " + ltrim(transform( ::aReport[ FONTSIZE ], "999.99")) + " Tf " + ltrim(transform( nCol, "9999.99" )) + " " + ltrim(transform( nRow, "9999.99" )) + " Td (" + cString + ") Tj ET"
      ELSE
         ::aReport[ PAGEBUFFER ] += CRLF + "BT " + ltrim(transform( nCol, "9999.99" )) + " " + ltrim(transform( nRow, "9999.99" )) + " Td (" + cString + ") Tj ET"
      ENDIF
      IF lReverse
         ::aReport[ PAGEBUFFER ] += " 0 g "
      ENDIF
   ENDIF

RETURN self

//-------------------------\\

METHOD Normal() CLASS TPdf
local cName := ::GetFontInfo( "NAME" )

   IF cName == "Times"
      ::aReport[ FONTNAME ] := 1
   ELSEIF cName == "Helvetica"
      ::aReport[ FONTNAME ] := 5
   ELSE
      ::aReport[ FONTNAME ] := 9
   ENDIF
   aadd( ::aReport[ PAGEFONTS ], ::aReport[ FONTNAME ] )
   IF ascan( ::aReport[ FONTS ], { |arr| arr[1] == ::aReport[ FONTNAME ] } ) == 0
      aadd( ::aReport[ FONTS ], { ::aReport[ FONTNAME ], ++::aReport[ NEXTOBJ ] } )
   ENDIF
RETURN self

//-------------------------\\

METHOD Italic() CLASS TPdf
local cName := ::GetFontInfo( "NAME" )

   IF cName == "Times"
      ::aReport[ FONTNAME ] := 3
   ELSEIF cName == "Helvetica"
      ::aReport[ FONTNAME ] := 7
   ELSE
      ::aReport[ FONTNAME ] := 11
   ENDIF
   aadd( ::aReport[ PAGEFONTS ], ::aReport[ FONTNAME ] )
   IF ascan( ::aReport[ FONTS ], { |arr| arr[1] == ::aReport[ FONTNAME ] } ) == 0
      aadd( ::aReport[ FONTS ], { ::aReport[ FONTNAME ], ++::aReport[ NEXTOBJ ] } )
   ENDIF
RETURN self

//-------------------------\\

METHOD Bold() CLASS TPdf
local cName := ::GetFontInfo( "NAME" )

   IF     cName == "Times"
      ::aReport[ FONTNAME ] := 2
   ELSEIF cName == "Helvetica"
      ::aReport[ FONTNAME ] := 6
   ELSEIF cName == "Courier"
      ::aReport[ FONTNAME ] := 10    // Courier // 0.04
   ENDIF

   aadd( ::aReport[ PAGEFONTS ], ::aReport[ FONTNAME ] )
   IF ascan( ::aReport[ FONTS ], { |arr| arr[1] == ::aReport[ FONTNAME ] } ) == 0
      aadd( ::aReport[ FONTS ], { ::aReport[ FONTNAME ], ++::aReport[ NEXTOBJ ] } )
   ENDIF

RETURN self

//-------------------------\\

METHOD BoldItalic() CLASS TPdf
local cName := ::GetFontInfo( "NAME" )

IF     cName == "Times"
   ::aReport[ FONTNAME ] := 4
ELSEIF cName == "Helvetica"
   ::aReport[ FONTNAME ] := 8
ELSEIF cName == "Courier"
   ::aReport[ FONTNAME ] := 12 // 0.04
ENDIF

aadd( ::aReport[ PAGEFONTS ], ::aReport[ FONTNAME ] )
IF ascan( ::aReport[ FONTS ], { |arr| arr[1] == ::aReport[ FONTNAME ] } ) == 0
   aadd( ::aReport[ FONTS ], { ::aReport[ FONTNAME ], ++::aReport[ NEXTOBJ ] } )
ENDIF

RETURN self

//-------------------------\\

METHOD BookAdd( cTitle, nLevel, nPage, nLine ) CLASS TPdf

aadd( ::aReport[ BOOKMARK ], { nLevel, alltrim( cTitle ), 0, 0, 0, 0, 0, 0, nPage, IIF( nLevel == 1, ::aReport[ PAGEY ], ::aReport[ PAGEY ] - nLine * 72 / ::aReport[ LPI ] ) })

RETURN self

//-------------------------\\

METHOD BookClose( ) CLASS TPdf

::aReport[ BOOKMARK ] := nil

RETURN self

//-------------------------\\

METHOD BookOpen( ) CLASS TPdf

::aReport[ BOOKMARK ] := {}

RETURN self

//-------------------------\\

METHOD Box( x1, y1, x2, y2, nBorder, nShade, cUnits, cColor, cId ) CLASS TPdf
local cBoxColor

DEFAULT nBorder TO 0
DEFAULT nShade  TO 0
DEFAULT cUnits  TO "M"
DEFAULT cColor  TO ""

   cBoxColor := ""
   IF !empty( cColor )
      cBoxColor := " " + Chr_RGB( substr( cColor, 2, 1 )) + " " + ;
                         Chr_RGB( substr( cColor, 3, 1 )) + " " + ;
                         Chr_RGB( substr( cColor, 4, 1 )) + " rg "
      IF empty( alltrim( cBoxColor ) )
         cBoxColor := ""
      ENDIF
   ENDIF

   IF ::aReport[ HEADEREDIT ]
      return ::Header( "PDFBOX", cId, { x1, y1, x2, y2, nBorder, nShade, cUnits } )
   ENDIF

   IF cUnits == "M"
      y1 += 0.5
      y2 += 0.5

      IF nShade > 0
         ::aReport[ PAGEBUFFER ] += CRLF + transform( 1.00 - nShade / 100.00, "9.99") + " g " + cBoxColor + ltrim(str(::M2X( y1 ))) + " " + ltrim(str(::M2Y( x1 ))) + " " + ltrim(str(::M2X( y2 - y1 ))) + " -" + ltrim(str(::M2X( x2 - x1 ))) + " re f 0 g"
      ENDIF

      IF nBorder > 0
         ::aReport[ PAGEBUFFER ] += CRLF + "0 g " + ltrim(str(::M2X( y1 ))) + " " + ltrim(str(::M2Y( x1 ))) + " " + ltrim(str(::M2X( y2 - y1 ))) + " -" + ltrim(str(::M2X( nBorder ))) + " re f"
         ::aReport[ PAGEBUFFER ] += CRLF + "0 g " + ltrim(str(::M2X( y2 - nBorder ))) + " " + ltrim(str(::M2Y( x1 ))) + " " + ltrim(str(::M2X( nBorder ))) + " -" + ltrim(str(::M2X( x2 - x1 ))) + " re f"
         ::aReport[ PAGEBUFFER ] += CRLF + "0 g " + ltrim(str(::M2X( y1 ))) + " " + ltrim(str(::M2Y( x2 - nBorder ))) + " " + ltrim(str(::M2X( y2 - y1 ))) + " -" + ltrim(str(::M2X( nBorder ))) + " re f"
         ::aReport[ PAGEBUFFER ] += CRLF + "0 g " + ltrim(str(::M2X( y1 ))) + " " + ltrim(str(::M2Y( x1 ))) + " " + ltrim(str(::M2X( nBorder ))) + " -" + ltrim(str(::M2X( x2 - x1 ))) + " re f"
      ENDIF
   ELSEIF cUnits == "D"    // "Dots"
      IF nShade > 0
         ::aReport[ PAGEBUFFER ] += CRLF + transform( 1.00 - nShade / 100.00, "9.99") + " g " + cBoxColor + ltrim(str( y1 )) + " " + ltrim(str( ::aReport[ PAGEY ] - x1 )) + " " + ltrim(str( y2 - y1 )) + " -" + ltrim(str( x2 - x1 )) + " re f 0 g"
      ENDIF

      IF nBorder > 0
/*
            1
         Ú-----¿
       4 ³     ³ 2
         À-----Ù
            3
*/
         ::aReport[ PAGEBUFFER ] += CRLF + "0 g " + ltrim(str( y1 )) + " " + ltrim(str( ::aReport[ PAGEY ] - x1 )) + " " + ltrim(str( y2 - y1 )) + " -" + ltrim(str( nBorder )) + " re f"
         ::aReport[ PAGEBUFFER ] += CRLF + "0 g " + ltrim(str( y2 - nBorder )) + " " + ltrim(str( ::aReport[ PAGEY ] - x1 )) + " " + ltrim(str( nBorder )) + " -" + ltrim(str( x2 - x1 )) + " re f"
         ::aReport[ PAGEBUFFER ] += CRLF + "0 g " + ltrim(str( y1 )) + " " + ltrim(str( ::aReport[ PAGEY ] - x2 + nBorder )) + " " + ltrim(str( y2 - y1 )) + " -" + ltrim(str( nBorder )) + " re f"
         ::aReport[ PAGEBUFFER ] += CRLF + "0 g " + ltrim(str( y1 )) + " " + ltrim(str( ::aReport[ PAGEY ] - x1 )) + " " + ltrim(str( nBorder )) + " -" + ltrim(str( x2 - x1 )) + " re f"
      ENDIF
   ENDIF
RETURN self

//-------------------------\\

METHOD Box1( nTop, nLeft, nBottom, nRight, nBorderWidth, cBorderColor, cBoxColor ) CLASS TPdf

DEFAULT nBorderWidth to 0.5
DEFAULT cBorderColor to chr(0) + chr(0) + chr(0)
DEFAULT cBoxColor to chr(255) + chr(255) + chr(255)

   ::aReport[ PAGEBUFFER ] +=  CRLF + ;
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
                         CRLF + ltrim( str ( ::aReport[ PAGEY ] - nBottom + nBorderWidth / 2)) + " " + ;
                         CRLF + ltrim( str ( nRight - nLeft -  nBorderWidth )) + ;
                         CRLF + ltrim( str ( nBottom - nTop - nBorderWidth )) + " " + ;
                         " re" + ;
                         CRLF + "B"
return nil

//-------------------------\\

METHOD Center( cString, nRow, nCol, cUnits, lExact, cId ) CLASS TPdf
local nLen, nAt

DEFAULT nRow TO ::aReport[ REPORTLINE ]
DEFAULT cUnits TO "R"
DEFAULT lExact TO .f.
DEFAULT nCol TO IIF( cUnits == "R", ::aReport[ REPORTWIDTH ] / 2, ::aReport[ PAGEX ] / 72 * 25.4 / 2 )

   IF ::aReport[ HEADEREDIT ]
      return ::Header( "PDFCENTER", cId, { cString, nRow, nCol, cUnits, lExact } )
   ENDIF

   IF ( nAt := at( "#pagenumber#", cString ) ) > 0
      cString := left( cString, nAt - 1 ) + ltrim(str( ::PageNumber())) + substr( cString, nAt + 12 )
   ENDIF

   nLen := ::length( cString ) / 2
   IF cUnits == "R"
      IF .not. lExact
         ::CheckLine( nRow )
         nRow := nRow + ::aReport[ PDFTOP]
      ENDIF
   ENDIF
   ::AtSay( cString, ::R2M( nRow ), IIF( cUnits == "R", ::aReport[ PDFLEFT ] + ( ::aReport[ PAGEX ] / 72 * 25.4 - 2 * ::aReport[ PDFLEFT ] ) * nCol / ::aReport[ REPORTWIDTH ], nCol ) - nLen, "M", lExact )
RETURN self

//-------------------------\\

METHOD Close() CLASS TPdf
local nI, cTemp, nCurLevel, nObj1, nLast, nCount, nFirst, nRecno, nBooklen

//   FIELD FIRST, PREV, NEXT, LAST, COUNT, PARENT, PAGE, COORD, TITLE, LEVEL

   ::ClosePage()

   // kids
   ::aReport[ REFS ][ 2 ] := ::aReport[ DOCLEN ]
   cTemp := ;
   "1 0 obj"+CRLF+;
   "<<"+CRLF+;
   "/Type /Pages /Count " + ltrim(str(::aReport[ REPORTPAGE ])) + CRLF +;
   "/Kids ["

   for nI := 1 to ::aReport[ REPORTPAGE ]
      cTemp += " " + ltrim(str( ::aReport[ PAGES ][ nI ] )) + " 0 R"
   next

   cTemp += " ]" + CRLF + ;
   ">>" + CRLF + ;
   "endobj" + CRLF

   ::aReport[ DOCLEN ] += len( cTemp )
   fwrite( ::aReport[ HANDLE ], cTemp )

   // info
   ++::aReport[ REPORTOBJ ]
   aadd( ::aReport[ REFS ], ::aReport[ DOCLEN ] )
   cTemp := ltrim(str( ::aReport[ REPORTOBJ ] )) + " 0 obj" + CRLF + ;
            "<<" + CRLF + ;
            "/Producer (TPDF 1.23,  http://www.pc-soft-df.com.ar/)" + CRLF + ;
            "/Title ("+::Title+")" + CRLF + ;
            "/Author ("+::Author+")" + CRLF + ;
            "/Creator ("+::Creator+")" + CRLF + ;
            "/Subject ("+::Subject+")" + CRLF + ;
            "/Keywords ("+::Keywords+")" + CRLF + ;
            "/CreationDate (D:" + str(year(date()), 4) + padl( month(date()), 2, "0") + padl( day(date()), 2, "0") + substr( time(), 1, 2 ) + substr( time(), 4, 2 ) + substr( time(), 7, 2 ) + ")" + CRLF + ;
            ">>" + CRLF + ;
            "endobj" + CRLF
   ::aReport[ DOCLEN ] += len( cTemp )
   fwrite( ::aReport[ HANDLE ], cTemp )

   // root
   ++::aReport[ REPORTOBJ ]
   aadd( ::aReport[ REFS ], ::aReport[ DOCLEN ] )
   cTemp := ltrim(str( ::aReport[ REPORTOBJ ] )) + " 0 obj" + CRLF + ;
   "<< /Type /Catalog /Pages 1 0 R /Outlines " + ltrim(str( ::aReport[ REPORTOBJ ] + 1 )) + " 0 R" + IIF( ( nBookLen := len( ::aReport[ BOOKMARK ] )) > 0, " /PageMode /UseOutlines", "") + " >>" + CRLF + "endobj" + CRLF
   ::aReport[ DOCLEN ] += len( cTemp )
   fwrite( ::aReport[ HANDLE ], cTemp )

   ++::aReport[ REPORTOBJ ]
   nObj1 := ::aReport[ REPORTOBJ ]

   IF nBookLen > 0

      nRecno := 1
      nFirst := ::aReport[ REPORTOBJ ] + 1
      nLast  := 0
      nCount := 0
      while nRecno <= nBookLen
         nCurLevel := ::aReport[ BOOKMARK ][ nRecno ][ BOOKLEVEL ]
         ::aReport[ BOOKMARK ][ nRecno ][ BOOKPARENT ] := ::BookParent( nRecno, nCurLevel, ::aReport[ REPORTOBJ ] )
         ::aReport[ BOOKMARK ][ nRecno ][ BOOKPREV ]   := ::BookPrev( nRecno, nCurLevel, ::aReport[ REPORTOBJ ] )
         ::aReport[ BOOKMARK ][ nRecno ][ BOOKNEXT ]   := ::BookNext( nRecno, nCurLevel, ::aReport[ REPORTOBJ ] )
         ::aReport[ BOOKMARK ][ nRecno ][ BOOKFIRST ]  := ::BookFirst( nRecno, nCurLevel, ::aReport[ REPORTOBJ ] )
         ::aReport[ BOOKMARK ][ nRecno ][ BOOKLAST ]   := ::BookLast( nRecno, nCurLevel, ::aReport[ REPORTOBJ ] )
         ::aReport[ BOOKMARK ][ nRecno ][ BOOKCOUNT ]  := ::BookCount( nRecno, nCurLevel )
         IF nCurLevel == 1
            nLast := nRecno
            ++nCount
         ENDIF
         ++nRecno
      enddo

      nLast += ::aReport[ REPORTOBJ ]

      cTemp := ltrim(str( ::aReport[ REPORTOBJ ] )) + " 0 obj" + CRLF + "<< /Type /Outlines /Count " + ltrim(str( nCount )) + " /First " + ltrim(str( nFirst )) + " 0 R /Last " + ltrim(str( nLast )) + " 0 R >>" + CRLF + "endobj" //+ CRLF
      aadd( ::aReport[ REFS ], ::aReport[ DOCLEN ] )
      ::aReport[ DOCLEN ] += len( cTemp )
      fwrite( ::aReport[ HANDLE ], cTemp )

      ++::aReport[ REPORTOBJ ]
      nRecno := 1
      FOR nI := 1 to nBookLen
         //cTemp := IIF ( nI > 1, CRLF, "") + ltrim(str( ::aReport[ REPORTOBJ ] + nI - 1)) + " 0 obj" + CRLF + ;
         cTemp := CRLF + ltrim(str( ::aReport[ REPORTOBJ ] + nI - 1)) + " 0 obj" + CRLF + ;
                 "<<" + CRLF + ;
                 "/Parent " + ltrim(str( ::aReport[ BOOKMARK ][ nRecno ][ BOOKPARENT ])) + " 0 R" + CRLF + ;
                 "/Dest [" + ltrim(str( ::aReport[ PAGES ][ ::aReport[ BOOKMARK ][ nRecno ][ BOOKPAGE ] ] )) + " 0 R /XYZ 0 " + ltrim( str( ::aReport[ BOOKMARK ][ nRecno ][ BOOKCOORD ])) + " 0]" + CRLF + ;
                 "/Title (" + alltrim( ::aReport[ BOOKMARK ][ nRecno ][ BOOKTITLE ]) + ")" + CRLF + ;
                 IIF( ::aReport[ BOOKMARK ][ nRecno ][ BOOKPREV ] > 0, "/Prev " + ltrim(str( ::aReport[ BOOKMARK ][ nRecno ][ BOOKPREV ])) + " 0 R" + CRLF, "") + ;
                 IIF( ::aReport[ BOOKMARK ][ nRecno ][ BOOKNEXT ] > 0, "/Next " + ltrim(str( ::aReport[ BOOKMARK ][ nRecno ][ BOOKNEXT ])) + " 0 R" + CRLF, "") + ;
                 IIF( ::aReport[ BOOKMARK ][ nRecno ][ BOOKFIRST ] > 0, "/First " + ltrim(str( ::aReport[ BOOKMARK ][ nRecno ][ BOOKFIRST ])) + " 0 R" + CRLF, "") + ;
                 IIF( ::aReport[ BOOKMARK ][ nRecno ][ BOOKLAST ] > 0, "/Last " + ltrim(str( ::aReport[ BOOKMARK ][ nRecno ][ BOOKLAST ])) + " 0 R" + CRLF, "") + ;
                 IIF( ::aReport[ BOOKMARK ][ nRecno ][ BOOKCOUNT ] != 0, "/Count " + ltrim(str( ::aReport[ BOOKMARK ][ nRecno ][ BOOKCOUNT ])) + CRLF, "") + ;
                 ">>" + CRLF + "endobj" + CRLF
//                 "/Dest [" + ltrim(str( ::aReport[ BOOKMARK ][ nRecno ][ BOOKPAGE ] * 3 )) + " 0 R /XYZ 0 " + ltrim( str( ::aReport[ BOOKMARK ][ nRecno ][ BOOKCOORD ])) + " 0]" + CRLF + ;
//                 "/Dest [" + ltrim(str( ::aReport[ PAGES ][ nRecno ] )) + " 0 R /XYZ 0 " + ltrim( str( ::aReport[ BOOKMARK ][ nRecno ][ BOOKCOORD ])) + " 0]" + CRLF + ;

         aadd( ::aReport[ REFS ], ::aReport[ DOCLEN ] + 2 )
         ::aReport[ DOCLEN ] += len( cTemp )
         fwrite( ::aReport[ HANDLE ], cTemp )
         ++nRecno
      NEXT
      ::BookClose()

      ::aReport[ REPORTOBJ ] += nBookLen - 1
   ELSE
      cTemp := ltrim(str( ::aReport[ REPORTOBJ ] )) + " 0 obj" + CRLF + "<< /Type /Outlines /Count 0 >>" + CRLF + "endobj" + CRLF
      aadd( ::aReport[ REFS ], ::aReport[ DOCLEN ] )
      ::aReport[ DOCLEN ] += len( cTemp )
      fwrite( ::aReport[ HANDLE ], cTemp )
   ENDIF

   cTemp := CRLF
   ::aReport[ DOCLEN ] += len( cTemp )

   ++::aReport[ REPORTOBJ ]
   cTemp += "xref" + CRLF + ;
   "0 " + ltrim(str( ::aReport[ REPORTOBJ ] )) + CRLF +;
   padl( ::aReport[ REFS ][ 1 ], 10, "0") + " 65535 f" + CRLF

   for nI := 2 to len( ::aReport[ REFS ] )
      cTemp += padl( ::aReport[ REFS ][ nI ], 10, "0") + " 00000 n" + CRLF
   next

   cTemp += "trailer << /Size " + ltrim(str( ::aReport[ REPORTOBJ ] )) + " /Root " + ltrim(str( nObj1 - 1 )) + " 0 R /Info " + ltrim(str( nObj1 - 2 )) + " 0 R >>" + CRLF + ;
            "startxref" + CRLF + ;
            ltrim(str( ::aReport[ DOCLEN ] )) + CRLF + ;
            "%%EOF" + CRLF
   fwrite( ::aReport[ HANDLE ], cTemp )

   fclose( ::aReport[ HANDLE ] )

   ::aReport := nil

RETURN self

//-------------------------\\

METHOD Image( cFile, nRow, nCol, cUnits, nHeight, nWidth, cId ) CLASS TPdf

DEFAULT nRow    TO ::aReport[ REPORTLINE ]
DEFAULT nCol    TO 0
DEFAULT nHeight TO 0
DEFAULT nWidth  TO 0
DEFAULT cUnits  TO "R"
DEFAULT cId TO  ""

   IF ::aReport[ HEADEREDIT ]
      return ::Header( "PDFIMAGE", cId, { cFile, nRow, nCol, cUnits, nHeight, nWidth } )
   ENDIF

   IF cUnits == "M"
      nRow    := ::aReport[ PAGEY ] - ::M2Y( nRow )
      nCol    := ::M2X( nCol )
      nHeight := ::aReport[ PAGEY ] - ::M2Y( nHeight )
      nWidth  := ::M2X( nWidth )
   ELSEIF cUnits == "R"
      //IF .not. lExact
      //   ::CheckLine( nRow )
      //   nRow := nRow + ::aReportStyle[ PDFTOP]
      //ENDIF
      nRow := ::aReport[ PAGEY ] - ::R2D( nRow )
      nCol := ::M2X( ::aReport[ PDFLEFT ] ) + ;
              nCol * 100.00 / ::aReport[ REPORTWIDTH ] * ;
              ( ::aReport[ PAGEX ] - ::M2X( ::aReport[ PDFLEFT ] ) * 2 - 9.0 ) / 100.00
      nHeight := ::aReport[ PAGEY ] - ::R2D( nHeight )
      nWidth := ::M2X( ::aReport[ PDFLEFT ] ) + ;
              nWidth * 100.00 / ::aReport[ REPORTWIDTH ] * ;
              ( ::aReport[ PAGEX ] - ::M2X( ::aReport[ PDFLEFT ] ) * 2 - 9.0 ) / 100.00
   ELSEIF cUnits == "D"
   ENDIF

   aadd( ::aReport[ PAGEIMAGES ], { cFile, nRow, nCol, nHeight, nWidth } )

RETURN self

//-------------------------\\

METHOD Length( cString ) CLASS TPdf
local nWidth := 0.00, nI, nLen, nArr, nAdd := ( ::aReport[ FONTNAME ] - 1 ) % 4

   nLen := len( cString )
   IF right( cString, 1 ) == chr( 255 ) .or. right( cString, 1 ) == chr( 254 )
      --nLen
   ENDIF
   IF ::GetFontInfo("NAME") == "Times"
      nArr := 1
   ELSEIF ::GetFontInfo("NAME") == "Helvetica"
      nArr := 2
   ELSE
      nArr := 3
   ENDIF

   For nI:= 1 To nLen
      nWidth += ::aReport[ FONTWIDTH ][ nArr ][ ( asc( substr( cString, nI, 1 )) - 32 ) * 4 + 1 + nAdd ] * 25.4 * ::aReport[ FONTSIZE ] / 720.00 / 100.00
   Next
RETURN nWidth

//-------------------------\\

METHOD NewLine( n ) CLASS TPdf

DEFAULT n TO 1
   IF ::aReport[ REPORTLINE ] + n + ::aReport[ PDFTOP] > ::aReport[ PDFBOTTOM ]
      ::NewPage()
      ::aReport[ REPORTLINE ] += 1
   ELSE
      ::aReport[ REPORTLINE ] += n
   ENDIF

RETURN ::aReport[ REPORTLINE ]

//-------------------------\\

METHOD NewPage( _cPageSize, _cPageOrient, _nLpi, _cFontName, _nFontType, _nFontSize ) CLASS TPdf

DEFAULT _cPageSize   TO ::aReport[ PAGESIZE ]
DEFAULT _cPageOrient TO ::aReport[ PAGEORIENT ]
DEFAULT _nLpi        TO ::aReport[ LPI ]
DEFAULT _cFontName   TO ::GetFontInfo( "NAME" )
DEFAULT _nFontType   TO ::GetFontInfo( "TYPE" )
DEFAULT _nFontSize   TO ::aReport[ FONTSIZE ]

   IF !empty( ::aReport[ PAGEBUFFER ] )
      ::ClosePage()
   ENDIF

   ::aReport[ PAGEFONTS  ] := {}
   ::aReport[ PAGEIMAGES ] := {}

   ++::aReport[ REPORTPAGE ]

   ::PageSize( _cPageSize )
   ::PageOrient( _cPageOrient )
   ::SetLPI( _nLpi )

   ::SetFont( _cFontName, _nFontType, _nFontSize )

   ::DrawHeader()

   ::aReport[ REPORTLINE   ] := 0
   ::aReport[ FONTNAMEPREV ] := 0
   ::aReport[ FONTSIZEPREV ] := 0

RETURN self

//-------------------------\\

METHOD PageSize( _cPageSize ) CLASS TPdf
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

DEFAULT _cPageSize TO "LETTER"

   nSize := ascan( aSize, { |arr| arr[ 1 ] == _cPageSize } )

   IF nSize = 0 
      nSize := 1
   ENDIF

   ::aReport[ PAGESIZE ] := aSize[ nSize ][ 1 ]

   IF ::aReport[ PAGEORIENT ] == "P"
      ::aReport[ PAGEX ] := aSize[ nSize ][ 2 ] * 72
      ::aReport[ PAGEY ] := aSize[ nSize ][ 3 ] * 72
   ELSE
      ::aReport[ PAGEX ] := aSize[ nSize ][ 3 ] * 72
      ::aReport[ PAGEY ] := aSize[ nSize ][ 2 ] * 72
   ENDIF

RETURN self

//-------------------------\\

METHOD PageOrient( _cPageOrient ) CLASS TPdf

DEFAULT _cPageOrient TO "P"

   ::aReport[ PAGEORIENT ] := _cPageOrient
   ::PageSize( ::aReport[ PAGESIZE ] )
RETURN self

//-------------------------\\

METHOD PageNumber( n ) CLASS TPdf

DEFAULT n TO 0
   IF n > 0
      ::aReport[ REPORTPAGE ] := n // NEW !!!
   ENDIF
RETURN ::aReport[ REPORTPAGE ]

//-------------------------\\

METHOD Reverse( cString ) CLASS TPdf

RETURN cString + chr(255)

//-------------------------\\

METHOD RJust( cString, nRow, nCol, cUnits, lExact, cId ) CLASS TPdf
local nLen, nAdj := 1.0, nAt

DEFAULT nRow TO ::aReport[ REPORTLINE ]
DEFAULT cUnits TO "R"
DEFAULT lExact TO .f.

   IF ::aReport[ HEADEREDIT ]
      return ::Header( "PDFRJUST", cId, { cString, nRow, nCol, cUnits, lExact } )
   ENDIF

   IF ( nAt := at( "#pagenumber#", cString ) ) > 0
      cString := left( cString, nAt - 1 ) + ltrim(str( ::PageNumber())) + substr( cString, nAt + 12 )
   ENDIF

   nLen := ::length( cString )

   IF cUnits == "R"
      IF .not. lExact
         ::CheckLine( nRow )
         nRow := nRow + ::aReport[ PDFTOP]
      ENDIF
   ENDIF
   ::AtSay( cString, ::R2M( nRow ), IIF( cUnits == "R", ::aReport[ PDFLEFT ] + ( ::aReport[ PAGEX ] / 72 * 25.4 - 2 * ::aReport[ PDFLEFT ] ) * nCol / ::aReport[ REPORTWIDTH ] - nAdj, nCol ) - nLen, "M", lExact )
RETURN self

//-------------------------\\

METHOD SetFont( _cFont, _nType, _nSize, cId ) CLASS TPdf

DEFAULT _cFont TO "Times"
DEFAULT _nType TO 0
DEFAULT _nSize TO 10

   IF ::aReport[ HEADEREDIT ]
      return ::Header( "PDFSETFONT", cId, { _cFont, _nType, _nSize } )
   ENDIF

   _cFont := upper( _cFont )
   ::aReport[ FONTSIZE ] := _nSize

   IF _cFont == "TIMES"
      ::aReport[ FONTNAME ] := _nType + 1
   ELSEIF _cFont == "HELVETICA"
      ::aReport[ FONTNAME ] := _nType + 5
   ELSE
      ::aReport[ FONTNAME ] := _nType + 9 // 0.04
   ENDIF

   aadd( ::aReport[ PAGEFONTS ], ::aReport[ FONTNAME ] )

   IF ascan( ::aReport[ FONTS ], { |arr| arr[1] == ::aReport[ FONTNAME ] } ) == 0
      aadd( ::aReport[ FONTS ], { ::aReport[ FONTNAME ], ++::aReport[ NEXTOBJ ] } )
   ENDIF
RETURN self

//-------------------------\\

METHOD SetLPI(_nLpi) CLASS TPdf
local cLpi := alltrim(str(_nLpi))

DEFAULT _nLpi TO 6

   cLpi := iif(cLpi$"1;2;3;4;6;8;12;16;24;48",cLpi,"6")
   ::aReport[ LPI ] := val( cLpi )

   ::PageSize( ::aReport[ PAGESIZE ] )
RETURN self

//-------------------------\\

METHOD StringB( cString ) CLASS TPdf

cString := strtran( cString, "(", "\(" )
cString := strtran( cString, ")", "\)" )

RETURN cString

//-------------------------\\

METHOD TextCount( cString, nTop, nLeft, nLength, nTab, nJustify, cUnits ) CLASS TPdf

RETURN ::Text( cString, nTop, nLeft, nLength, nTab, nJustify, cUnits, .f. )

//-------------------------\\

METHOD Text( cString, nTop, nLeft, nLength, nTab, nJustify, cUnits, cColor, lPrint ) CLASS TPdf
local cDelim := chr(0)+chr(9)+chr(10)+chr(13)+chr(26)+chr(32)+chr(138)+chr(141)
local nI, cTemp, cToken, k, nL, nRow, nLines, nLineLen, nStart
local lParagraph, nSpace, nNew, nTokenLen, nCRLF, nTokens, nLen

DEFAULT nTab     TO -1
DEFAULT cUnits   TO "R"
DEFAULT nJustify TO 4
DEFAULT lPrint   TO .t.
DEFAULT cColor   TO ""

   IF cUnits == "M"
      nTop := ::M2R( nTop )
   ELSEIF cUnits == "R"
      nLeft := ::X2M( ::M2X( ::aReport[ PDFLEFT ] ) + ;
              nLeft * 100.00 / ::aReport[ REPORTWIDTH ] * ;
              ( ::aReport[ PAGEX ] - ::M2X( ::aReport[ PDFLEFT ] ) * 2 - 9.0 ) / 100.00 )
   ENDIF

   ::aReport[ REPORTLINE ] := nTop - 1

   nSpace    := ::length( " " )
   nLines    := 0
   nCRLF     := 0
   nNew      := nTab
   cString   := alltrim( cString )
   nTokens   := numtoken( cString, cDelim )

   nStart    := 1

   IF nJustify == 1 .or. nJustify == 4
      nLeft := nLeft
   ELSEIF nJustify == 2
      nLeft := nLeft - nLength / 2
   ELSEIF nJustify == 3
      nLeft := nLeft - nLength
   ENDIF

   nL := nLeft
   nL += nNew * nSpace
   nLineLen := nSpace * nNew - nSpace

   lParagraph := .t.
   nI := 1

   while nI <= nTokens
      cToken := token( cString, cDelim, nI )
      nTokenLen := ::length( cToken )
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
                  IF nJustify != 2
                     nL += nSpace * nNew
                  ENDIF
                  lParagraph := .f.
               ENDIF
               IF nJustify == 2
                  nL := nLeft + ( nLength - ::length( cTemp ) ) / 2
               ELSEIF nJustify == 3
                  nL := nLeft + nLength - ::length( cTemp )
               ENDIF
               while k <= nLen .and. ( ( nLineLen += ::length( substr( cToken, k, 1 ))) <= nLength )
                  nLineLen += ::length( substr( cToken, k, 1 ))
                  cTemp += substr( cToken, k, 1 )
                  ++k
               enddo
               IF empty( cTemp ) // single character > nlength
                  cTemp := substr( cToken, k, 1 )
                  ++k
               ENDIF
               ++nLines
               IF lPrint
                  nRow := ::NewLine( 1 )
                  ::AtSay( cColor + cTemp, ::R2M( nRow + ::aReport[ PDFTOP] ), nL, "M" )
               ENDIF
            enddo
            ++nI
            nStart := nI
         ELSE
            ::TextPrint( nI - 1, nLeft, @lParagraph, nJustify, nSpace, nNew, nLength, @nLineLen, @nLines, @nStart, cString, cDelim, cColor, lPrint )
         ENDIF

      ELSEIF ( nI == nTokens ) .or. ( nI < nTokens .and. ( nCRLF := ::TextNextPara( cString, cDelim, nI ) ) > 0 )
         IF nI == nTokens
            nLineLen += nSpace + nTokenLen
         ENDIF
         ::TextPrint( nI, nLeft, @lParagraph, nJustify, nSpace, nNew, nLength, @nLineLen, @nLines, @nStart, cString, cDelim, cColor, lPrint )
         ++nI

         IF nCRLF > 1
            nLines += nCRLF - 1
         ENDIF
         IF lPrint
            /*nRow :=*/ ::NewLine( nCRLF - 1 )
         ENDIF

      ELSE
         nLineLen += nSpace + nTokenLen
         ++nI
      ENDIF
   enddo

RETURN nLines

//-------------------------\\

METHOD UnderLine( cString ) CLASS TPdf

RETURN cString + chr(254)

//-------------------------\\

METHOD OpenHeader( cFile ) CLASS TPdf
local nAt, cCmd

DEFAULT cFile TO ""

   IF !empty( cFile )
      cFile := alltrim( cFile )
      IF len( cFile ) > 12 .or. ;
         at( " ", cFile ) > 0 .or. ;
         ( at( " ", cFile ) == 0 .and. len( cFile ) > 8 ) .or. ;
         ( ( nAt := at( ".", cFile )) > 0 .and. len( substr( cFile, nAt + 1 )) > 3 )

         cCmd := "copy " + cFile + " temp.tmp > nul"
         RunExternal( cCmd )

         cFile := "temp.tmp"
      ENDIF
      // ::aReport[ HEADER ] := FT_RestArr( cFile, @nErrorCode )
      ::aReport[ HEADER ] := File2Array( cFile )
   ELSE
      ::aReport[ HEADER ] := {}
   ENDIF
   ::aReport[ MARGINS ] := .t.

RETURN self

//-------------------------\\

METHOD EditOnHeader() CLASS TPdf

::aReport[ HEADEREDIT ] := .t.
::aReport[ MARGINS ] := .t.

RETURN self

//-------------------------\\

METHOD EditOffHeader() CLASS TPdf

::aReport[ HEADEREDIT ] := .f.
::aReport[ MARGINS    ] := .t.

RETURN self

//-------------------------\\

METHOD CloseHeader() CLASS TPdf

   ::aReport[ HEADER ] := {}
   ::aReport[ MARGINS ] := .f.
RETURN self

//-------------------------\\

METHOD DeleteHeader( cId ) CLASS TPdf

local nRet := -1, nId
   cId := upper( cId )
   nId := ascan( ::aReport[ HEADER ], {| arr | arr[ 3 ] == cId })
   IF nId > 0
      nRet := len( ::aReport[ HEADER ] ) - 1
      aDel( ::aReport[ HEADER ], nId )
      aSize( ::aReport[ HEADER ], nRet )
      ::aReport[ MARGINS ] := .t.
   ENDIF
RETURN nRet

//-------------------------\\

METHOD EnableHeader( cId ) CLASS TPdf
local nId
   cId := upper( cId )
   nId := ascan( ::aReport[ HEADER ], {| arr | arr[ 3 ] == cId })
   IF nId > 0
      ::aReport[ HEADER ][ nId ][ 1 ] := .t.
      ::aReport[ MARGINS ] := .t.
   ENDIF
RETURN self

//-------------------------\\

METHOD DisableHeader( cId ) CLASS TPdf
local nId
   cId := upper( cId )
   nId := ascan( ::aReport[ HEADER ], {| arr | arr[ 3 ] == cId })
   IF nId > 0
      ::aReport[ HEADER ][ nId ][ 1 ] := .f.
      ::aReport[ MARGINS ] := .t.
   ENDIF
RETURN self

//-------------------------\\

METHOD SaveHeader( cFile ) CLASS TPdf
local cCmd

Array2File( "temp.tmp", ::aReport[ HEADER ] )

cCmd := "copy temp.tmp " + cFile + " > nul"
RunExternal( cCmd )

RETURN self

//-------------------------\\

METHOD Header( cFunction, cId, arr ) CLASS TPdf
local nId, nI, nLen, nIdLen
   nId := 0
   IF !empty( cId )
      cId := upper( cId )
      nId := ascan( ::aReport[ HEADER ], {| arr | arr[ 3 ] == cId })
   ENDIF
   IF nId == 0
      nLen := len( ::aReport[ HEADER ] )
      IF empty( cId )
         cId := cFunction
         nIdLen := len( cId )
         for nI := 1 to nLen
            IF ::aReport[ HEADER ][ nI ][ 2 ] == cId
               IF val( substr( ::aReport[ HEADER ][ nI ][ 3 ], nIdLen + 1 ) ) > nId
                  nId := val( substr( ::aReport[ HEADER ][ nI ][ 3 ], nIdLen + 1 ) )
               ENDIF
            ENDIF
         next
         ++nId
         cId += ltrim(str(nId))
      ENDIF
      aadd( ::aReport[ HEADER ], { .t., cFunction, cId } )
      ++nLen
      for nI := 1 to len( arr )
         aadd( ::aReport[ HEADER ][ nLen ], arr[ nI ] )
      next
   ELSE
      aSize( ::aReport[ HEADER ][ nId ], 3 )
      for nI := 1 to len( arr )
         aadd( ::aReport[ HEADER ][ nId ], arr[ nI ] )
      next
   ENDIF
RETURN cId

//-------------------------\\

METHOD DrawHeader() CLASS TPdf
local nI, _nFont, _nSize, nLen := len( ::aReport[ HEADER ] )

   IF nLen > 0

      // save font
      _nFont := ::aReport[ FONTNAME ]
      _nSize := ::aReport[ FONTSIZE ]

      for nI := 1 to nLen
         IF ::aReport[ HEADER ][ nI ][ 1 ] // enabled
            do case
            case ::aReport[ HEADER ][ nI ][ 2 ] == "PDFATSAY"
               ::AtSay( ::aReport[ HEADER ][ nI ][ 4 ], ::aReport[ HEADER ][ nI ][ 5 ], ::aReport[ HEADER ][ nI ][ 6 ], ::aReport[ HEADER ][ nI ][ 7 ], ::aReport[ HEADER ][ nI ][ 8 ], ::aReport[ HEADER ][ nI ][ 3 ] )

            case ::aReport[ HEADER ][ nI ][ 2 ] == "PDFCENTER"
               ::Center( ::aReport[ HEADER ][ nI ][ 4 ], ::aReport[ HEADER ][ nI ][ 5 ], ::aReport[ HEADER ][ nI ][ 6 ], ::aReport[ HEADER ][ nI ][ 7 ], ::aReport[ HEADER ][ nI ][ 8 ], ::aReport[ HEADER ][ nI ][ 3 ] )

            case ::aReport[ HEADER ][ nI ][ 2 ] == "PDFRJUST"
               ::RJust( ::aReport[ HEADER ][ nI ][ 4 ], ::aReport[ HEADER ][ nI ][ 5 ], ::aReport[ HEADER ][ nI ][ 6 ], ::aReport[ HEADER ][ nI ][ 7 ], ::aReport[ HEADER ][ nI ][ 8 ], ::aReport[ HEADER ][ nI ][ 3 ] )

            case ::aReport[ HEADER ][ nI ][ 2 ] == "PDFBOX"
               ::Box( ::aReport[ HEADER ][ nI ][ 4 ], ::aReport[ HEADER ][ nI ][ 5 ], ::aReport[ HEADER ][ nI ][ 6 ], ::aReport[ HEADER ][ nI ][ 7 ], ::aReport[ HEADER ][ nI ][ 8 ], ::aReport[ HEADER ][ nI ][ 9 ], ::aReport[ HEADER ][ nI ][ 10 ], ::aReport[ HEADER ][ nI ][ 3 ] )

            case ::aReport[ HEADER ][ nI ][ 2 ] == "PDFSETFONT"
               ::SetFont( ::aReport[ HEADER ][ nI ][ 4 ], ::aReport[ HEADER ][ nI ][ 5 ], ::aReport[ HEADER ][ nI ][ 6 ], ::aReport[ HEADER ][ nI ][ 3 ] )

            case ::aReport[ HEADER ][ nI ][ 2 ] == "PDFIMAGE"
               ::Image( ::aReport[ HEADER ][ nI ][ 4 ], ::aReport[ HEADER ][ nI ][ 5 ], ::aReport[ HEADER ][ nI ][ 6 ], ::aReport[ HEADER ][ nI ][ 7 ], ::aReport[ HEADER ][ nI ][ 8 ], ::aReport[ HEADER ][ nI ][ 9 ], ::aReport[ HEADER ][ nI ][ 3 ] )

            endcase
         ENDIF
      next
      ::aReport[ FONTNAME ] := _nFont
      ::aReport[ FONTSIZE ] := _nSize

      IF ::aReport[ MARGINS ]
         ::Margins()
      ENDIF

   ELSE
      IF ::aReport[ MARGINS ]
         ::aReport[ PDFTOP] := 1 // top
         ::aReport[ PDFLEFT ] := 10 // left & right
         ::aReport[ PDFBOTTOM ] := ::aReport[ PAGEY ] / 72 * ::aReport[ LPI ] - 1 // bottom, default "LETTER", "P", 6

         ::aReport[ MARGINS ] := .f.
      ENDIF
   ENDIF
RETURN self

//-------------------------\\

METHOD Margins( nTop, nLeft, nBottom ) CLASS TPdf
local nI, nLen := len( ::aReport[ HEADER ] ), nTemp, aTemp, nHeight

   for nI := 1 to nLen
      IF ::aReport[ HEADER ][ nI ][ 1 ] // enabled

         IF ::aReport[ HEADER ][ nI ][ 2 ] == "PDFSETFONT"

         ELSEIF ::aReport[ HEADER ][ nI ][ 2 ] == "PDFIMAGE"
            IF ::aReport[ HEADER ][ nI ][ 8 ] == 0 // picture in header, first at all, not at any page yet
               aTemp := ::ImageInfo( ::aReport[ HEADER ][ nI ][ 4 ] )
               nHeight := aTemp[ IMAGE_HEIGHT ] / aTemp[ IMAGE_YRES ] * 25.4
               IF ::aReport[ HEADER ][ nI ][ 7 ] == "D"
                  nHeight := ::M2X( nHeight )
               ENDIF
            ELSE
               nHeight := ::aReport[ HEADER ][ nI ][ 8 ]
            ENDIF

            IF ::aReport[ HEADER ][ nI ][ 7 ] == "M"

               nTemp := ::aReport[ PAGEY ] / 72 * 25.4 / 2

               IF ::aReport[ HEADER ][ nI ][ 5 ] < nTemp
                  nTemp := ( ::aReport[ HEADER ][ nI ][ 5 ] + nHeight ) * ::aReport[ LPI ] / 25.4 // top
                  IF nTemp > ::aReport[ PDFTOP]
                     ::aReport[ PDFTOP] := nTemp
                  ENDIF
               ELSE
                  nTemp := ::aReport[ HEADER ][ nI ][ 5 ] * ::aReport[ LPI ] / 25.4 // top
                  IF nTemp < ::aReport[ PDFBOTTOM ]
                     ::aReport[ PDFBOTTOM ] := nTemp
                  ENDIF
               ENDIF

            ELSEIF ::aReport[ HEADER ][ nI ][ 7 ] == "D"
               nTemp := ::aReport[ PAGEY ] / 2

               IF ::aReport[ HEADER ][ nI ][ 5 ] < nTemp
                  nTemp := ( ::aReport[ HEADER ][ nI ][ 5 ] + nHeight ) * ::aReport[ LPI ] / 72 // top
                  IF nTemp > ::aReport[ PDFTOP]
                     ::aReport[ PDFTOP] := nTemp
                  ENDIF
               ELSE
                  nTemp := ::aReport[ HEADER ][ nI ][ 5 ] * ::aReport[ LPI ] / 72 // top
                  IF nTemp < ::aReport[ PDFBOTTOM ]
                     ::aReport[ PDFBOTTOM ] := nTemp
                  ENDIF

               ENDIF

            ENDIF

         ELSEIF ::aReport[ HEADER ][ nI ][ 2 ] == "PDFBOX"

            IF ::aReport[ HEADER ][ nI ][ 10 ] == "M"

               nTemp := ::aReport[ PAGEY ] / 72 * 25.4 / 2

               IF ::aReport[ HEADER ][ nI ][ 4 ] < nTemp .and. ;
                  ::aReport[ HEADER ][ nI ][ 6 ] < nTemp
                  nTemp := ::aReport[ HEADER ][ nI ][ 6 ] * ::aReport[ LPI ] / 25.4 // top
                  IF nTemp > ::aReport[ PDFTOP]
                     ::aReport[ PDFTOP] := nTemp
                  ENDIF
               ELSEIF ::aReport[ HEADER ][ nI ][ 4 ] < nTemp .and. ;
                      ::aReport[ HEADER ][ nI ][ 6 ] > nTemp

                  nTemp := ( ::aReport[ HEADER ][ nI ][ 4 ] + ::aReport[ HEADER ][ nI ][ 8 ] ) * ::aReport[ LPI ] / 25.4 // top
                  IF nTemp > ::aReport[ PDFTOP]
                     ::aReport[ PDFTOP] := nTemp
                  ENDIF

                  nTemp := ( ::aReport[ HEADER ][ nI ][ 6 ] - ::aReport[ HEADER ][ nI ][ 8 ] ) * ::aReport[ LPI ] / 25.4 // top
                  IF nTemp < ::aReport[ PDFBOTTOM ]
                     ::aReport[ PDFBOTTOM ] := nTemp
                  ENDIF

               ELSEIF ::aReport[ HEADER ][ nI ][ 4 ] > nTemp .and. ;
                      ::aReport[ HEADER ][ nI ][ 6 ] > nTemp
                  nTemp := ::aReport[ HEADER ][ nI ][ 4 ] * ::aReport[ LPI ] / 25.4 // top
                  IF nTemp < ::aReport[ PDFBOTTOM ]
                     ::aReport[ PDFBOTTOM ] := nTemp
                  ENDIF
               ENDIF

            ELSEIF ::aReport[ HEADER ][ nI ][ 10 ] == "D"
               nTemp := ::aReport[ PAGEY ] / 2

               IF ::aReport[ HEADER ][ nI ][ 4 ] < nTemp .and. ;
                  ::aReport[ HEADER ][ nI ][ 6 ] < nTemp
                  nTemp := ::aReport[ HEADER ][ nI ][ 6 ] / ::aReport[ LPI ] // top
                  IF nTemp > ::aReport[ PDFTOP]
                     ::aReport[ PDFTOP] := nTemp
                  ENDIF
               ELSEIF ::aReport[ HEADER ][ nI ][ 4 ] < nTemp .and. ;
                      ::aReport[ HEADER ][ nI ][ 6 ] > nTemp

                  nTemp := ( ::aReport[ HEADER ][ nI ][ 4 ] + ::aReport[ HEADER ][ nI ][ 8 ] ) / ::aReport[ LPI ] // top
                  IF nTemp > ::aReport[ PDFTOP]
                     ::aReport[ PDFTOP] := nTemp
                  ENDIF

                  nTemp := ( ::aReport[ HEADER ][ nI ][ 6 ] - ::aReport[ HEADER ][ nI ][ 8 ] ) / ::aReport[ LPI ] // top
                  IF nTemp < ::aReport[ PDFBOTTOM ]
                     ::aReport[ PDFBOTTOM ] := nTemp
                  ENDIF

               ELSEIF ::aReport[ HEADER ][ nI ][ 4 ] > nTemp .and. ;
                      ::aReport[ HEADER ][ nI ][ 6 ] > nTemp
                  nTemp := ::aReport[ HEADER ][ nI ][ 4 ] / ::aReport[ LPI ] // top
                  IF nTemp < ::aReport[ PDFBOTTOM ]
                     ::aReport[ PDFBOTTOM ] := nTemp
                  ENDIF
               ENDIF

            ENDIF

         ELSE
            IF ::aReport[ HEADER ][ nI ][ 7 ] == "R"
               nTemp := ::aReport[ HEADER ][ nI ][ 5 ] // top
               IF ::aReport[ HEADER ][ nI ][ 5 ] > ::aReport[ PAGEY ] / 72 * ::aReport[ LPI ] / 2
                  IF nTemp < ::aReport[ PDFBOTTOM ]
                     ::aReport[ PDFBOTTOM ] := nTemp
                  ENDIF
               ELSE
                  IF nTemp > ::aReport[ PDFTOP]
                     ::aReport[ PDFTOP] := nTemp
                  ENDIF
               ENDIF
            ELSEIF ::aReport[ HEADER ][ nI ][ 7 ] == "M"
               nTemp := ::aReport[ HEADER ][ nI ][ 5 ] * ::aReport[ LPI ] / 25.4 // top
               IF ::aReport[ HEADER ][ nI ][ 5 ] > ::aReport[ PAGEY ] / 72 * 25.4 / 2
                  IF nTemp < ::aReport[ PDFBOTTOM ]
                     ::aReport[ PDFBOTTOM ] := nTemp
                  ENDIF
               ELSE
                  IF nTemp > ::aReport[ PDFTOP]
                     ::aReport[ PDFTOP] := nTemp
                  ENDIF
               ENDIF
            ELSEIF ::aReport[ HEADER ][ nI ][ 7 ] == "D"
               nTemp := ::aReport[ HEADER ][ nI ][ 5 ] / ::aReport[ LPI ] // top
               IF ::aReport[ HEADER ][ nI ][ 5 ] > ::aReport[ PAGEY ] / 2
                  IF nTemp < ::aReport[ PDFBOTTOM ]
                     ::aReport[ PDFBOTTOM ] := nTemp
                  ENDIF
               ELSE
                  IF nTemp > ::aReport[ PDFTOP]
                     ::aReport[ PDFTOP] := nTemp
                  ENDIF
               ENDIF
            ENDIF
         ENDIF
      ENDIF
   next

   IF nTop != NIL
      ::aReport[ PDFTOP] := nTop
   ENDIF
   IF nLeft != NIL
      ::aReport[ PDFLEFT ] := nLeft
   ENDIF
   IF nBottom != NIL
      ::aReport[ PDFBOTTOM ] := nBottom
   ENDIF

   ::aReport[ MARGINS ] := .f.

RETURN self

//-------------------------\\

METHOD CreateHeader( _file, _size, _orient, _lpi, _width ) CLASS TPdf
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

DEFAULT _size TO ::aReport[ PAGESIZE ]
DEFAULT _orient TO ::aReport[ PAGEORIENT ]
DEFAULT _lpi TO ::aReport[ LPI ]
DEFAULT _width TO 200

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

   ::EditOnHeader()

   IF _size == "LEGAL"
      nAdd := 76.2
   ENDIF

   IF _orient == "P"
      ::Box(   5.0, 5.0, 274.0 + nAdd, 210.0,  1.0 )
      ::Box(   6.5, 6.5, 272.5 + nAdd, 208.5,  0.5 )

      ::Box(  11.5, 9.5,  22.0       , 205.5,  0.5, 5 )
      ::Box(  23.0, 9.5,  33.5       , 205.5,  0.5, 5 )
      ::Box(  34.5, 9.5, 267.5 + nAdd, 205.5,  0.5 )

   ELSE
      ::Box(  5.0, 5.0, 210.0, 274.0 + nAdd, 1.0 )
      ::Box(  6.5, 6.5, 208.5, 272.5 + nAdd, 0.5 )

      ::Box( 11.5, 9.5,  22.0, 269.5 + nAdd, 0.5, 5 )
      ::Box( 23.0, 9.5,  33.5, 269.5 + nAdd, 0.5, 5 )
      ::Box( 34.5, 9.5, 203.5, 269.5 + nAdd, 0.5 )
   ENDIF

   ::SetFont("Arial", BOLD, 10)
   ::AtSay( "Test Line 1", aReportStyle[ nStyle ][ 1 ], 1, "R", .t. )

   ::SetFont("Times", BOLD, 18)
   ::Center( "Test Line 2", aReportStyle[ nStyle ][ 2 ],,"R", .t. )

   ::SetFont("Times", BOLD, 12)
   ::Center( "Test Line 3", aReportStyle[ nStyle ][ 3 ],,"R", .t. )

   ::SetFont("Arial", BOLD, 10)
   ::AtSay( "Test Line 4", aReportStyle[ nStyle ][ 4 ], 1, "R", .t. )

   ::SetFont("Arial", BOLD, 10)
   ::AtSay( "Test Line 5", aReportStyle[ nStyle ][ 5 ], 1, "R", .t. )

   ::AtSay( dtoc( date()) + " " + TimeAsAMPM( time() ), aReportStyle[ nStyle ][ 6 ], 1, "R", .t. )
   ::RJust( "Page: #pagenumber#", aReportStyle[ nStyle ][ 6 ], ::aReport[ REPORTWIDTH ], "R", .t. )

   ::EditOffHeader()
   ::SaveHeader( _file )
RETURN self

//-------------------------\\

METHOD ImageInfo( cFile ) CLASS TPdf
local cTemp := upper(substr( cFile, rat(".", cFile) + 1 )), aTemp := {}
   do case
   case cTemp == "TIF"
      aTemp := ::TIFFInfo( cFile )
   case cTemp == "JPG"
      aTemp := ::JPEGInfo( cFile )
   case cTemp == "PNG"
      aTemp :=::PNGInfo( cFile )
   endcase
   
RETURN aTemp

//-------------------------\\

METHOD TIFFInfo( cFile ) CLASS TPdf
local c40    := chr(0)+chr(0)+chr(0)+chr(0)
//local aType  := {"BYTE","ASCII","SHORT","LONG","RATIONAL","SBYTE","UNDEFINED","SSHORT","SLONG","SRATIONAL","FLOAT","DOUBLE"}
local aCount := { 1, 1, 2, 4, 8, 1, 1, 2, 4, 8, 4, 8 }
local nTemp, nHandle, cValues, c2, nFieldType, nCount, nPos, nTag, nValues
local nOffset, cTemp, cIFDNext, nIFD, nFields, cTag, nn

local nWidth := 0, nHeight := 0, nBits := 0, nFrom := 0, nLength := 0, xRes := 0, yRes := 0, aTemp := {}

   nHandle := fopen( cFile )

   c2 := "  "
   fread( nHandle, @c2, 2 )
   fread( nHandle, @c2, 2 )

   cIFDNext := "    "
   fread( nHandle, @cIFDNext, 4 )

   cTemp  := space(12)


   while !( cIFDNext == c40 ) //read IFD"s

      nIFD := bin2l( cIFDNext )

      fseek( nHandle, nIFD )

      fread( nHandle, @c2, 2 )
      nFields := bin2i( c2 )

      for nn := 1 to nFields
         fread( nHandle, @cTemp, 12 )

         nTag       := bin2w( substr( cTemp, 1, 2 ) )
         nFieldType := bin2w( substr( cTemp, 3, 2 ) )
         nCount     := bin2l( substr( cTemp, 5, 4 ) )
         nOffset    := bin2l( substr( cTemp, 9, 4 ) )

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
         //cTag := ""
         do case
         case nTag == 256
            cTag := "ImageWidth"

            IF nFieldType ==  SHORT
               nWidth := bin2w( substr( cValues, 1, 2 ))
            ELSEIF nFieldType ==  LONG
               nWidth := bin2l( substr( cValues, 1, 4 ))
            ENDIF

         case nTag == 257
            cTag := "ImageLength"
            IF nFieldType ==  SHORT
               nHeight := bin2w(substr( cValues, 1, 2 ))
            ELSEIF nFieldType ==  LONG
               nHeight := bin2l(substr( cValues, 1, 4 ))
            ENDIF

         case nTag == 258
            cTag := "BitsPerSample"
            nTemp := 0
            IF nFieldType == SHORT
               nTemp := bin2w( cValues )
            ENDIF
            nBits := nTemp
         case nTag == 259
            cTag := "Compression"
            /*nTemp := 0
            IF nFieldType == SHORT
               nTemp := bin2w( cValues )
            ENDIF*/
         case nTag == 262
            cTag := "PhotometricInterpretation"
            /*nTemp := -1
            IF nFieldType == SHORT
               nTemp := bin2w( cValues )
            ENDIF*/
         case nTag == 264
            cTag := "CellWidth"
         case nTag == 265
            cTag := "CellLength"
         case nTag == 266
            cTag := "FillOrder"
         case nTag == 273
            cTag := "StripOffsets"
            IF nFieldType ==  SHORT
               nFrom := bin2w(substr( cValues, 1, 2 ))
            ELSEIF nFieldType ==  LONG
               nFrom := bin2l(substr( cValues, 1, 4 ))
            ENDIF

         case nTag == 277
            cTag := "SamplesPerPixel"
         case nTag == 278
            cTag := "RowsPerStrip"
         case nTag == 279
            cTag := "StripByteCounts"
            IF nFieldType ==  SHORT
               nLength := bin2w(substr( cValues, 1, 2 ))
            ELSEIF nFieldType ==  LONG
               nLength := bin2l(substr( cValues, 1, 4 ))
            ENDIF

            nLength *= nCount // Count all strips !!!

         case nTag == 282
            cTag := "XResolution"
            xRes := bin2l(substr( cValues, 1, 4 ))
         case nTag == 283
            cTag := "YResolution"
            yRes := bin2l(substr( cValues, 1, 4 ))
         case nTag == 284
            cTag := "PlanarConfiguration"
         case nTag == 288
            cTag := "FreeOffsets"
         case nTag == 289
            cTag := "FreeByteCounts"
         case nTag == 296
            cTag := "ResolutionUnit"
            /*nTemp := 0
            IF nFieldType == SHORT
               nTemp := bin2w( cValues )
            ENDIF*/
         case nTag == 305
            cTag := "Software"
         case nTag == 306
            cTag := "DateTime"
         case nTag == 315
            cTag := "Artist"
         case nTag == 320
            cTag := "ColorMap"
         case nTag == 338
            cTag := "ExtraSamples"
         case nTag == 33432
            cTag := "Copyright"
         otherwise
            cTag := "Unknown"
         endcase
      next
      fread( nHandle, @cIFDNext, 4 )
   enddo
   HB_SYMBOL_UNUSED( cTag )  // TOFIX
   fclose( nHandle )

   aadd( aTemp, nWidth )
   aadd( aTemp, nHeight )
   aadd( aTemp, xRes )
   aadd( aTemp, yRes )
   aadd( aTemp, nBits )
   aadd( aTemp, nFrom )
   aadd( aTemp, nLength )

return aTemp

//-------------------------\\

METHOD JPEGInfo( cFile ) CLASS TPdf
local c255, nAt, nHandle
local nWidth, nHeight, nBits := 8, nFrom := 0
local nLength, xRes, yRes, aTemp := {}

   nHandle := fopen( cFile )

   c255 := space(1024)
   fread( nHandle, @c255, 1024 )

   xRes := asc(substr( c255, 15, 1 )) * 256 + asc(substr( c255, 16, 1 ))
   yRes := asc( substr( c255, 17, 1 )) * 256 + asc(substr( c255, 18, 1 ))

   nAt := at( chr(255) + chr(192), c255 ) + 5
   nHeight := asc(substr( c255, nAt, 1 )) * 256 + asc(substr( c255, nAt + 1, 1 ))
   nWidth := asc( substr( c255, nAt + 2, 1 )) * 256 + asc(substr( c255, nAt + 3, 1 ))

   fclose( nHandle )

   nLength := filesize( cFile )

   aadd( aTemp, nWidth )
   aadd( aTemp, nHeight )
   aadd( aTemp, xRes )
   aadd( aTemp, yRes )
   aadd( aTemp, nBits )
   aadd( aTemp, nFrom )
   aadd( aTemp, nLength )

return aTemp

//-------------------------\\

METHOD PNGInfo( cFile ) CLASS TPdf
local c255, nAt, nHandle
local nWidth:= 0, nHeight:= 0, nBits := 8, nFrom := 135
local nLength:= filesize( cFile ), xRes:= 0, yRes:= 0, aTemp := {}


LOCAL nPLTEPos
LOCAL nDistTonPhys := 0
LOCAL nPhys
LOCAL cPalletData  := ""
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
      nPhys := At( "pHYs", c255 )
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

   Fclose( nHandle )

   nLength := filesize( cFile )

   Aadd( aTemp, xRes )
   Aadd( aTemp, yRes )
   Aadd( aTemp, xRes )
   Aadd( aTemp, yRes )
   Aadd( aTemp, nBits )
   Aadd( aTemp, nFrom )
   Aadd( aTemp, nLength - nFrom - 16 )
   Aadd( aTemp, nColor )
   Aadd( aTemp, cPalletData )
   Aadd( aTemp, nDistTonPhys )

RETURN aTemp

//-------------------------\\

METHOD BookCount( nRecno, nCurLevel ) CLASS TPdf
local nTempLevel, nCount := 0, nLen := len( ::aReport[ BOOKMARK ] )
   ++nRecno
   while nRecno <= nLen
      nTempLevel := ::aReport[ BOOKMARK ][ nRecno ][ BOOKLEVEL ]
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

//-------------------------\\

METHOD BookFirst( nRecno, nCurLevel, nObj ) CLASS TPdf
local nFirst := 0, nLen := len( ::aReport[ BOOKMARK ] )
   ++nRecno
   IF nRecno <= nLen
      IF nCurLevel + 1 == ::aReport[ BOOKMARK ][ nRecno ][ BOOKLEVEL ]
         nFirst := nRecno
      ENDIF
   ENDIF
return IIF( nFirst == 0, nFirst, nObj + nFirst )

//-------------------------\\

METHOD BookLast( nRecno, nCurLevel, nObj ) CLASS TPdf
local nLast := 0, nLen := len( ::aReport[ BOOKMARK ] )
   ++nRecno
   IF nRecno <= nLen
      IF nCurLevel + 1 == ::aReport[ BOOKMARK ][ nRecno ][ BOOKLEVEL ]
         while nRecno <= nLen .and. nCurLevel + 1 <= ::aReport[ BOOKMARK ][ nRecno ][ BOOKLEVEL ]
            IF nCurLevel + 1 == ::aReport[ BOOKMARK ][ nRecno ][ BOOKLEVEL ]
               nLast := nRecno
            ENDIF
            ++nRecno
         enddo
      ENDIF
   ENDIF
return IIF( nLast == 0, nLast, nObj + nLast )

//-------------------------\\

METHOD BookNext( nRecno, nCurLevel, nObj ) CLASS TPdf
local nTempLevel, nNext := 0, nLen := len( ::aReport[ BOOKMARK ] )
   ++nRecno
   while nRecno <= nLen
      nTempLevel := ::aReport[ BOOKMARK ][ nRecno ][ BOOKLEVEL ]
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

//-------------------------\\

METHOD BookParent( nRecno, nCurLevel, nObj ) CLASS TPdf
local nTempLevel
local nParent := 0
   --nRecno
   while nRecno > 0
      nTempLevel := ::aReport[ BOOKMARK ][ nRecno ][ BOOKLEVEL ]
      IF nTempLevel < nCurLevel
         nParent := nRecno
         exit
      ENDIF
      --nRecno
   enddo
return IIF( nParent == 0, nObj - 1, nObj + nParent )

//-------------------------\\

METHOD BookPrev( nRecno, nCurLevel, nObj ) CLASS TPdf
local nTempLevel
local nPrev := 0
   --nRecno
   while nRecno > 0
      nTempLevel := ::aReport[ BOOKMARK ][ nRecno ][ BOOKLEVEL ]
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

//-------------------------\\

METHOD CheckLine( nRow ) CLASS TPdf

   IF nRow + ::aReport[ PDFTOP] > ::aReport[ PDFBOTTOM ]
      ::NewPage()
      nRow := ::aReport[ REPORTLINE ]
   ENDIF
   ::aReport[ REPORTLINE ] := nRow
RETURN self

//-------------------------\\

METHOD GetFontInfo( cParam ) CLASS TPdf
local cRet
   IF cParam == "NAME"
      IF left( ::aReport[ TYPE1 ][ ::aReport[ FONTNAME ] ], 5 ) == "Times"
         cRet := "Times"
      ELSEIF left( ::aReport[ TYPE1 ][ ::aReport[ FONTNAME ] ], 9 ) == "Helvetica"
         cRet := "Helvetica"
      ELSE
         cRet := "Courier" // 0.04
      ENDIF
   ELSE // size
      cRet := int(( ::aReport[ FONTNAME ] - 1 ) % 4)
   ENDIF

return cRet

//-------------------------\\

METHOD M2R( mm ) CLASS TPdf

return int( ::aReport[ LPI ] * mm / 25.4 )

//-------------------------\\

METHOD M2X( n ) CLASS TPdf

return n * 72 / 25.4

//-------------------------\\

METHOD M2Y( n ) CLASS TPdf

return ::aReport[ PAGEY ] -  n * 72 / 25.4

//-------------------------\\

METHOD R2D( nRow ) CLASS TPdf

return ::aReport[ PAGEY ] - nRow * 72 / ::aReport[ LPI ]

//-------------------------\\

METHOD R2M( nRow ) CLASS TPdf

return 25.4 * nRow / ::aReport[ LPI ]

//-------------------------\\

METHOD X2M( n ) CLASS TPdf

return n * 25.4 / 72

//-------------------------\\

METHOD TextPrint( nI, nLeft, lParagraph, nJustify, nSpace, nNew, nLength, nLineLen, nLines, nStart, cString, cDelim, cColor, lPrint ) CLASS TPdf
local nFinish, nL, nB, nJ, cToken, nRow

   nFinish := nI

   nL := nLeft
   IF lParagraph
      IF nJustify != 2
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
      nRow := ::NewLine( 1 )
   ENDIF
   nB := nSpace
   IF nJustify == 4
      nB := ( nLength - nLineLen + ( nFinish - nStart ) * nSpace ) / ( nFinish - nStart )
   ENDIF
   for nJ := nStart to nFinish
      cToken := token( cString, cDelim, nJ )
      IF lPrint
         // version 0.02
         ::AtSay( cColor + cToken, ::R2M( nRow + ::aReport[ PDFTOP ] ), nL, "M" )
      ENDIF
      nL += ::Length( cToken ) + nB
   next

   nStart := nFinish + 1

   lParagraph := .f.

   nLineLen := 0.00
   nLineLen += nSpace * nNew

RETURN self

//-------------------------\\

METHOD TextNextPara( cString, cDelim, nI ) CLASS TPdf
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

//-------------------------\\

METHOD ClosePage() CLASS TPdf
local cTemp, cBuffer, nBuffer, nRead, nI, k, nImage, nFont, nImageHandle

   aadd( ::aReport[ REFS  ], ::aReport[ DOCLEN    ] )

   aadd( ::aReport[ PAGES ], ::aReport[ REPORTOBJ ] + 1 )

   cTemp := ;
     ltrim(str( ++::aReport[ REPORTOBJ ] )) + " 0 obj" + CRLF + ;
     "<<" + CRLF + ;
     "/Type /Page /Parent 1 0 R" + CRLF + ;
     "/Resources " + ltrim(str( ++::aReport[ REPORTOBJ ] )) + " 0 R" + CRLF + ;
     "/MediaBox [ 0 0 " + ltrim(transform( ::aReport[ PAGEX ], "9999.99")) + " " + ;
     ltrim(transform(::aReport[ PAGEY ], "9999.99")) + " ]" + CRLF + ;
     "/Contents " + ltrim(str( ++::aReport[ REPORTOBJ ] )) + " 0 R" + CRLF + ;
     ">>" + CRLF + ;
    "endobj" + CRLF


   ::aReport[ DOCLEN ] += len( cTemp )
   fwrite( ::aReport[ HANDLE ], cTemp )

   aadd( ::aReport[ REFS ], ::aReport[ DOCLEN ] )
   cTemp := ;
   ltrim(str(::aReport[ REPORTOBJ ] - 1)) + " 0 obj" + CRLF + ;
   "<<"+CRLF+;
   "/ColorSpace << /DeviceRGB /DeviceGray >>" + CRLF + ; //version 0.01
   "/ProcSet [ /PDF /Text /ImageB /ImageC ]"

   IF len( ::aReport[ PAGEFONTS ] ) > 0
      cTemp += CRLF + ;
      "/Font" + CRLF + ;
      "<<"

      for nI := 1 to len( ::aReport[ PAGEFONTS ] )
         nFont := ascan( ::aReport[ FONTS ], { |arr| arr[1] == ::aReport[ PAGEFONTS ][ nI ] } )
         cTemp += CRLF + "/Fo" + ltrim(str( nFont )) + " " + ltrim(str( ::aReport[ FONTS ][ nFont ][ 2 ])) + " 0 R"
      next

      cTemp += CRLF + ">>"
   ENDIF

   IF len( ::aReport[ PAGEIMAGES ] ) > 0
      cTemp += CRLF + "/XObject" + CRLF + "<<"
      for nI := 1 to len( ::aReport[ PAGEIMAGES ] )
         nImage := ascan( ::aReport[ IMAGES ], { |arr| arr[1] == ::aReport[ PAGEIMAGES ][ nI ][ 1 ] } )
         IF nImage == 0
            aadd( ::aReport[ IMAGES ], { ::aReport[ PAGEIMAGES ][ nI ][ 1 ], ++::aReport[ NEXTOBJ ], ::ImageInfo( ::aReport[ PAGEIMAGES ][ nI ][ 1 ] ) } )
            nImage := len( ::aReport[ IMAGES ] )
         ENDIF
         cTemp += CRLF + "/Image" + ltrim(str( nImage )) + " " + ltrim(str( ::aReport[ IMAGES ][ nImage ][ 2 ])) + " 0 R"
      next
      cTemp += CRLF + ">>"
   ENDIF

   cTemp += CRLF + ">>" + CRLF + "endobj" + CRLF

   ::aReport[ DOCLEN ] += len( cTemp )
   fwrite( ::aReport[ HANDLE ], cTemp )

   aadd( ::aReport[ REFS ], ::aReport[ DOCLEN ] )
   cTemp := ltrim(str( ::aReport[ REPORTOBJ ] )) + " 0 obj << /Length " + ;
   ltrim(str( ::aReport[ REPORTOBJ ] + 1 )) + " 0 R >>" + CRLF +;
   "stream"

   ::aReport[ DOCLEN ] += len( cTemp )
   fwrite( ::aReport[ HANDLE ], cTemp )

   IF len( ::aReport[ PAGEIMAGES ] ) > 0
      cTemp := ""
      for nI := 1 to len( ::aReport[ PAGEIMAGES ] )
         cTemp += CRLF + "q"
         nImage := ascan( ::aReport[ IMAGES ], { |arr| arr[1] == ::aReport[ PAGEIMAGES ][ nI ][ 1 ] } )
         cTemp += CRLF + ltrim(str( IIF( ::aReport[ PAGEIMAGES ][ nI ][ 5 ] == 0, ::M2X( ::aReport[ IMAGES ][ nImage ][ 3 ][ IMAGE_WIDTH ] / ::aReport[ IMAGES ][ nImage ][ 3 ][ IMAGE_XRES ] * 25.4 ), ::aReport[ PAGEIMAGES ][ nI ][ 5 ]))) + ;
         " 0 0 " + ;
         ltrim(str( IIF( ::aReport[ PAGEIMAGES ][ nI ][ 4 ] == 0, ::M2X( ::aReport[ IMAGES ][ nImage ][ 3 ][ IMAGE_HEIGHT ] / ::aReport[ IMAGES ][ nImage ][ 3 ][ IMAGE_YRES ] * 25.4 ), ::aReport[ PAGEIMAGES ][ nI ][ 4 ]))) + ;
         " " + ltrim(str( ::aReport[ PAGEIMAGES ][ nI ][ 3 ] )) + ;
         " " + ltrim(str( ::aReport[ PAGEY ] - ::aReport[ PAGEIMAGES ][ nI ][ 2 ] - ;
         IIF( ::aReport[ PAGEIMAGES ][ nI ][ 4 ] == 0, ::M2X( ::aReport[ IMAGES ][ nImage ][ 3 ][ IMAGE_HEIGHT ] / ::aReport[ IMAGES ][ nImage ][ 3 ][ IMAGE_YRES ] * 25.4 ), ::aReport[ PAGEIMAGES ][ nI ][ 4 ]))) + " cm"
         cTemp += CRLF + "/Image" + ltrim(str( nImage )) + " Do"
         cTemp += CRLF + "Q"
      next
      ::aReport[ PAGEBUFFER ] := cTemp + ::aReport[ PAGEBUFFER ]
   ENDIF

   cTemp := ::aReport[ PAGEBUFFER ]

   cTemp += CRLF + "endstream" + CRLF + ;
   "endobj" + CRLF

   ::aReport[ DOCLEN ] += len( cTemp )
   fwrite( ::aReport[ HANDLE ], cTemp )

   aadd( ::aReport[ REFS ], ::aReport[ DOCLEN ] )
   cTemp := ltrim(str( ++::aReport[ REPORTOBJ ] )) + " 0 obj" + CRLF + ;
   ltrim(str(len( ::aReport[ PAGEBUFFER ] ))) + CRLF + ;
   "endobj" + CRLF

   ::aReport[ DOCLEN ] += len( cTemp )
   fwrite( ::aReport[ HANDLE ], cTemp )

   for nI := 1 to len( ::aReport[ FONTS ] )
      IF ::aReport[ FONTS ][ nI ][ 2 ] > ::aReport[ REPORTOBJ ]

         aadd( ::aReport[ REFS ], ::aReport[ DOCLEN ] )

         cTemp := ;
         ltrim(str( ::aReport[ FONTS ][ nI ][ 2 ] )) + " 0 obj" + CRLF + ;
         "<<" + CRLF + ;
         "/Type /Font" + CRLF + ;
         "/Subtype /Type1" + CRLF + ;
         "/Name /Fo" + ltrim(str( nI )) + CRLF + ;
         "/BaseFont /" + ::aReport[ TYPE1 ][ ::aReport[ FONTS ][ nI ][ 1 ] ] + CRLF + ;
         "/Encoding /WinAnsiEncoding" + CRLF + ;
         ">>" + CRLF + ;
         "endobj" + CRLF

         ::aReport[ DOCLEN ] += len( cTemp )
         fwrite( ::aReport[ HANDLE ], cTemp )

      ENDIF
   next

   for nI := 1 to len( ::aReport[ IMAGES ] )
      IF ::aReport[ IMAGES ][ nI ][ 2 ] > ::aReport[ REPORTOBJ ]

         aadd( ::aReport[ REFS ], ::aReport[ DOCLEN ] )

         cTemp :=  ;
          ltrim(str( ::aReport[ IMAGES ][ nI ][ 2 ] )) + " 0 obj" + CRLF + ;
          "<<" + CRLF + ;
          "/Type /XObject" + CRLF + ;
          "/Subtype /Image" + CRLF + ;
          "/Name /Image" + ltrim(str(nI)) + CRLF 
         IF At( ".PNG", Upper( ::aReport[ IMAGES, nI, 1 ] ) ) > 0
            cTemp += ;
            "/Filter[/FlateDecode]" + CRLF +;
            "/DecodeParms[<</Predictor 15/Columns " + Ltrim( Str( ::aReport[ IMAGES, nI, 3, IMAGE_WIDTH ] ) ) + Iif( ::aReport[ IMAGES, nI, 3, 8 ] == 2, "/Colors " + Ltrim( Str( ::areport[ IMAGES, nI, 3, 8 ] + 1 ) ), "" ) + ">>]" + CRLF
         ELSE
            cTemp += ;
            "/Filter [" + IIF( at( ".jpg", lower( ::aReport[ IMAGES ][ nI ][ 1 ]) ) > 0, " /DCTDecode", "" ) + " ]" + CRLF 
         ENDIF
          cTemp += ;
          "/Width " + ltrim(str( ::aReport[ IMAGES ][ nI ][ 3 ][ IMAGE_WIDTH ] )) + CRLF + ;
          "/Height " + ltrim(str( ::aReport[ IMAGES ][ nI ][ 3 ][ IMAGE_HEIGHT ] )) + CRLF + ;
          "/BitsPerComponent " + ltrim(str( ::aReport[ IMAGES ][ nI ][ 3 ][ IMAGE_BITS ] )) + CRLF
         IF ::aReport[ IMAGES, nI, 3, 8 ] == 2
           cTemp += ;
           "/ColorSpace /" + IIF( ::aReport[ IMAGES ][ nI ][ 3 ][ IMAGE_BITS ] == 1, "DeviceGray", "DeviceRGB") + CRLF
         ELSE
           cTemp += ;
           "/ColorSpace[/Indexed/DeviceRGB 255 " + Ltrim( Str( ::aReport[ IMAGES, nI, 2 ] + 1 ) ) + " 0 R]" + CRLF
         ENDIF
          cTemp += ;
          "/Length " + ltrim(str( ::aReport[ IMAGES ][ nI ][ 3 ][ IMAGE_LENGTH ])) + CRLF + ;
          ">>" + CRLF + ;
          "stream" + CRLF

         ::aReport[ DOCLEN ] += len( cTemp )
         fwrite( ::aReport[ HANDLE ], cTemp )

         nImageHandle := fopen( ::aReport[ IMAGES ][ nI ][ 1 ] )
         fseek( nImageHandle, ::aReport[ IMAGES ][ nI ][ 3 ][ IMAGE_FROM ] )

         nBuffer := 8192
         cBuffer := space( nBuffer )
         k := 0
         while k < ::aReport[ IMAGES ][ nI ][ 3 ][ IMAGE_LENGTH ]
            IF k + nBuffer <= ::aReport[ IMAGES ][ nI ][ 3 ][ IMAGE_LENGTH ]
               nRead := nBuffer
            ELSE
               nRead := ::aReport[ IMAGES ][ nI ][ 3 ][ IMAGE_LENGTH ] - k
            ENDIF
            fread( nImageHandle, @cBuffer, nRead )

            ::aReport[ DOCLEN ] += nRead
            fwrite( ::aReport[ HANDLE ], cBuffer, nRead )
            k += nRead
         enddo

         cTemp := CRLF + "endstream" + CRLF + "endobj" + CRLF

         ::aReport[ DOCLEN ] += len( cTemp )
         fwrite( ::aReport[ HANDLE ], cTemp )

         fClose( nImageHandle )
      ENDIF
   next

   ::aReport[ REPORTOBJ  ] := ::aReport[ NEXTOBJ ]

   ::aReport[ NEXTOBJ    ] := ::aReport[ REPORTOBJ ] + 4

   ::aReport[ PAGEBUFFER ] := ""

RETURN self

/*
//-------------------------\\

METHOD FilePrint( cFile ) CLASS TPdf
local cPathAcro := "C:\progra~1\Adobe\Acroba~1.0\Reader"
local cRun := cPathAcro + "\AcroRd32.exe /t " + cFile + " " + ;
            chr(34) + "HP LaserJet 5/5M PostScript" + chr(34) + " " + ;
            chr(34) + "LPT1" + chr(34)

IF ( ! RunExternal( cRun, "print" ) )
   alert( "Error printing to PDF reader." )
   break
ENDIF

RETURN self

//-------------------------\\

METHOD Execute( cFile ) CLASS TPdf
//  Replace cPathAcro with the path at your system
local cPathAcro := "C:\progra~1\Adobe\Acroba~1.0\Reader"
local cRun := cPathAcro + "\AcroRd32.exe /t " + cFile + " " + chr(34) + "HP LaserJet 5/5M PostScript" + chr(34) + " " + chr(34) + "LPT1" + chr(34)

IF (! RunExternal( cRun, "open", cFile ) )
   alert("Error printing to PDF reader.")
   break
ENDIF

RETURN self
*/

//-------------------------\\

METHOD InfoPDF( cTitle, cAuthor, cCreator, cSubject, cKey ) CLASS TPdf
   DEFAULT cTitle TO ""
   DEFAULT cAuthor TO ""
   DEFAULT cCreator TO ""
   DEFAULT cSubject TO "", cKey TO ""
   
   ::Title    := cTitle
   ::Author   := cAuthor
   ::Creator  := cCreator
   ::Subject  := cSubject
   ::Keywords := cKey

RETURN nil

//-------------------------\\

METHOD Code39( nRow, nCol, cCode, lCheck, Color, lHorz, nWidth, nHeigth ) CLASS TPdf
    local cCar,m, n, n1,n2, cBarra := "",  nCheck := 0

    local cCars := "1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ-. *$/+%"
    local aBarras := { "1110100010101110",;
                       "1011100010101110",;
                       "1110111000101010",;
                       "1010001110101110",;
                       "1110100011101010",;
                       "1011100011101010",;
                       "1010001011101110",;
                       "1110100010111010",;
                       "1011100010111010",;
                       "1010001110111010",;
                       "1110101000101110",;
                       "1011101000101110",;
                       "1110111010001010",;
                       "1010111000101110",;
                       "1110101110001010",;//E
                       "1011101110001010",;
                       "1010100011101110",;
                       "1110101000111010",;
                       "1011101000111010",;
                       "1010111000111010",;
                       "1110101010001110",; //K
                       "1011101010001110",;
                       "1110111010100010",;
                       "1010111010001110",;
                       "1110101110100010",;
                       "1011101110100010",;//p
                       "1010101110001110",;
                       "1110101011100010",;
                       "1011101011100010",;
                       "1010111011100010",;
                       "1110001010101110",;
                       "1000111010101110",;
                       "1110001110101010",;
                       "1000101110101110",;
                       "1110001011101010",;
                       "1000111011101010",;//Z
                       "1000101011101110",;
                       "1110001010111010",;
                       "1000111010111010",; // " "
                       "1000101110111010",;
                       "1000100010100010",;
                       "1000100010100010",;
                       "1000101000100010",;
                       "1010001000100010" }

    DEFAULT lCheck TO .f.
    
    cCode := upper(cCode)
    if len( cCode ) > 32
        cCode := left( cCode, 32 )
    end
    cCode := "*" + cCode + "*"
    for n:= 1 to len( cCode )
        cCar := substr( cCode, n, 1 )
        m:=at( cCar, cCars )
        if n > 0 // otros caracteres se ignoran :-))
            cBarra := cBarra + aBarras[ m ]
            nCheck += ( m - 1 )
        end
    next

   if lCheck
    cBarra += aBarras[ nCheck % 43 + 1 ]
   end
   
   ::Gen_Code( cBarra, nRow, nCol, lHorz, Color, nWidth, nHeigth )

RETURN nil

//-------------------------\\

METHOD Code25( nRow, nCol, cCode, lCheck, Color, lHorz, nWidth, nHeigth, nTipo ) CLASS TPdf
    local n, cBar := "", cIz := "", cDer := "", nLen := 0, nCheck := 0, cBarra := ""
    local m
    // D = Delgado, A = Ancho
    local aBar := { "DDAAD", "ADDDA", "DADDA", "AADDD", "DDADA", "ADADD", "DAADD", ;
                    "DDDAA", "ADDAD", "DADAD" }
                 
    local aInit := { "1010", "110", "10000" }
    
    local aStop := { "1101", "101", "10000" }

    DEFAULT lCheck TO .f.
    
    cCode := trans( cCode, "@9" ) // elimina caracteres

    nLen := len( cCode )
    
//    if nTipo = 1
      if ( nLen % 2 = 1 .and. !lCheck )
        nLen++
        cCode := "0" + cCode
      end
//    end
    
    if lCheck
        for n := 1 to len( cCode ) step 2
            nCheck += val( substr( cCode, n, 1 ) ) * 3 + val( substr( cCode, n + 1, 1 ) )
        next
        cCode += right( str( nCheck, 10, 0 ), 1 )
    end

    // preencoding .. interlaving
    
    if nTipo = 1
      for n := 1 to nLen step 2
        cIz := aBar[ val( substr( cCode, n, 1 ) ) + 1 ]
        cDer := aBar[ val( substr( cCode, n + 1, 1 ) ) + 1 ]
        for m:=1 to 5
          cBarra += substr( cIz, m, 1 ) + substr( cDer, m, 1 )
        next
      next
    else
      for n := 1 to nLen
        cBarra += aBar[ val( substr( cCode, n, 1 ) ) + 1 ] + "D"
      next
    endif
    
    cBar := aInit[ nTipo ]
    
    if nTipo = 1
      for n := 1 to len( cBarra ) step 2
        if substr( cBarra, n, 1 ) = "A"
            cBar += "11"
        else
            cBar += "1"
        end
        if substr( cBarra, n + 1, 1 ) = "A"
            cBar += "00"
        else
            cBar += "0"
        end
      next
    elseif nTipo = 3
      for n := 1 to len( cBarra ) step 2
        if substr( cBarra, n, 1 ) = "A"
            cBar += "11"
        else
            cBar += "1"
        end
        if substr( cBarra, n + 1, 1 ) = "A"
            cBar += "00"
        else
            cBar += "0"
        end
      next
    else
      for n := 1 to len( cBarra )
        if substr( cBarra, n, 1 ) = "A"
          cBar += "110"
        else
          cBar += "10"
        end
      next  
    end

    cBar += aStop[ nTipo ]
    
   ::Gen_Code( cBar, nRow, nCol, lHorz, Color, nWidth, nHeigth )

RETURN nil

//-------------------------\\

METHOD Ean13( nRow, nCol, cCode, lCheck, Color, lHorz, nWidth, nHeigth, nPorc ) CLASS TPdf
   local l, s1, s2, control, n, ac, cad, cBarra, cadena2, n1, n2, NUmero
   local Izda, Dcha, String, Mascara
// local primero := "ooooooooeoeeooeeoeooeeeooeooeeoeeooeoeeeoooeoeoeoeoeeooeeoeo"
   // I = Impar, P = Par
   local Parity := { "IIIIII","IIPIPP","IIPPIP","IIPPPI","IPIIPP","IPPIIP","IPPPII","IPIPIP","IPIPPI","IPPIPI" }
   local derecha := { "1110010","1100110","1101100","1000010","1011100","1001110","1010000","1000100","1001000","1110100" }
   local impar   := { "0001101","0011001","0010011","0111101","0100011","0110001","0101111","0111011","0110111","0001011" }
   local par     := { "0100111","0110011","0011011","0100001","0011101","0111001","0000101","0010001","0001001","0010111" }

   if Len( cCode ) != 13
     cCode := ::Valida_Ean13( cCode )
   end

   // preparacion de la cadena de impresion
   dcha := SUBSTR( cCode, 8, 6 )
   izda := substr( cCode, 2, 6 )
   mascara := Parity[ val( substr( cCode, 1, 1 ) ) + 1 ]
   *  ? mascara
   // barra de delimitacion
   cBarra := "101"
   // parte izda
   for n=1 to 6
      numero := val( substr( izda, n, 1 ) )
      if substr( mascara, n, 1 ) = "I"
         cBarra += impar[ numero + 1 ]
      else
         cBarra += Par[ numero + 1 ]
      end
   next
   cBarra += "01010"
   // LADO DERECHO
   for n=1 to 6
      numero := val( substr( dcha, n, 1 ) )
      cBarra += derecha[ numero + 1 ]
   next
   cBarra +=  "101"

   ::Gen_Code( cBarra, nRow, nCol, lHorz, Color, nWidth, nHeigth, { nPorc, 3, 46, 50, Len( cBarra ) - 3 } )
   
//    ::go_code(_ean13Bl(),nRow,nCol,oPrint,lHorz,Color,nWidth,nHeigth)

RETURN nil

//-------------------------\\

METHOD _UPC( cCode, nLen ) CLASS TPdf
   local l,s1,s2,control,n,ac,cad,cadena, n1, n2, NUmero
   local Izda, Dcha, String, Mascara

   local derecha := { "1110010","1100110","1101100","1000010","1011100","1001110","1010000","1000100","1001000","1110100" }
   local impar   := { "0001101","0011001","0010011","0111101","0100011","0110001","0101111","0111011","0110111","0001011" }

   nLen := Len( cCode )
   // preparacion de la cadena de impresion
   dcha := Right( cCode, nLen / 2 )
   izda := Left( cCode, nLen / 2 )
   // barra de delimitacion
   cadena := "101"
   // parte izda
   for n = 1 to len( Izda )
      numero := val( substr( izda, n, 1 ) )
      cadena += impar[ numero + 1 ]
   next
   cadena += "01010"
   // LADO DERECHO
   for n = 1 to len( dcha )
      numero := val( substr( dcha, n, 1 ) )
      cadena += derecha[ numero + 1 ]
   next
   cadena += "101"

RETURN cadena

//-------------------------\\

METHOD Ean8( nRow, nCol, cCode, lCheck, Color, lHorz, nWidth, nHeigth, nPorc, lBanner ) CLASS TPdf
   local l, s1, s2, control, n, ac, cad, cBarra, cadena2, n1, n2, NUmero
   local Izda, Dcha, String, Mascara
   local nLen

   default nHeigth to 1.5
   default lBanner to .f.
   
   if Len( cCode ) != 8
     cCode := ::Valida_UPC( cCode, 7 )
   end
   
   cBarra := ::_UPC( cCode )

   ::Gen_Code( cBarra, nRow, nCol, lHorz, Color, nWidth, nHeigth, { nPorc, 3, 32, 36, Len( cBarra ) - 3 } )
   
//    if lBanner
//        barlen( cBarra, 7, oPrint, nRow, nCol, Color, lHorz, nWidth, nHeigth, cFont )
//    end

RETURN nil

//-------------------------\\

METHOD UPCA( nRow, nCol, cCode, lCheck, Color, lHorz, nWidth, nHeigth, nPorc, lBanner ) CLASS TPdf
   local l, s1, s2, control, n, ac, cad, cBarra, cadena2, n1, n2, NUmero
   local Izda, Dcha, String, Mascara
   local nLen

   default nHeigth to 1.5
//   default nWidth to 1.5
   default lBanner to .f.
   
   nWidth := 1.203
//   nWidth := 1.1368421053

   if Len( cCode ) != 12
     cCode := ::Valida_UPC( cCode, 11 )
   end
   
   cBarra := ::_UPC( cCode )

   ::Gen_Code( cBarra, nRow, nCol, lHorz, Color, nWidth, nHeigth, { nPorc, 10, 46, 50, Len( cBarra ) - 10 } )

//    if lBanner
//      ::UPCA_barlen(cCode,oPrint,nRow,nCol,Color,lHorz,nWidth,nHeigth,cFont)
//    end

RETURN nil

//-------------------------\\

METHOD Ean5(  nRow, nCol, cCode, lCheck, Color, lHorz, nWidth, nHeigth, lBanner  ) CLASS TPdf
   local l, k, control, n, cBarras := "1011", nCar
   local Izda, Dcha
   local parity  := { "PPIII", "PIPII", "PIIPI", "PIIIP", "IPPII", "IIPPI", "IIIPP", "IPIPI", "IPIIP", "IIPIP" }
   local impar   := { "0001101","0011001","0010011","0111101","0100011","0110001","0101111","0111011","0110111","0001011" }
   local par     := { "0100111","0110011","0011011","0100001","0011101","0111001","0000101","0010001","0001001","0010111" }
   
   default nHeigth to 1.5
   default lBanner to .f.
   
   cCode := left ( alltrim( cCode ) + "00000", 5 )             // padding with "0"

   control :=  ( val( substr( cCode, 1, 1 ) ) + val( substr( cCode, 3, 1 ) ) + ;
                 val( substr( cCode, 5, 1 ) ) ) * 3 + ;
               ( val( substr( cCode, 2, 1 ) ) + val( substr( cCode, 4, 1 ) ) ) * 9
      
   control := right( str( control, 5 ), 1 )

   control := parity[ Val( control ) + 1 ]

   for n:=1 to 5
      nCar := val( substr( cCode, n, 1 ) )

      if substr( control, n, 1 ) = "I"
         cBarras += impar[ nCar + 1 ]
      else
         cBarras += Par[ nCar + 1 ]
      end
      if n < 5
         cBarras += "01"
      end
   next
   
  ::Gen_Code( cBarras, nRow, nCol, lHorz, Color, nWidth, nHeigth )

return cBarras

//-------------------------\\

METHOD Codabar( nRow, nCol, cCode, lCheck, Color, lHorz, nWidth, nHeigth ) CLASS TPdf
   local cChar := "0123456789-$:/.+ABCDTN*E"
   local abar := {"101010001110", "101011100010", "101000101110", "111000101010", "101110100010",;
                  "111010100010", "100010101110", "100010111010", "100011101010", "111010001010",;
                  "101000111010", "101110001010", "11101011101110", "11101110101110", "11101110111010",;
                  "10111011101110", "10111000100010", "10001000101110", "10100011100010", "10111000100010",;
                  "10001000101110", "10100010001110", "10100011100010" }

    local n, cBarra := "", nCar
    
    cCode := upper( cCode )
    
    for n:=1 to len( cCode )
      if ( nCar := at( substr( cCode, n, 1 ), cChar ) ) > 0
        cBarra += aBar[ nCar ]
      endif
    next

   ::Gen_Code( cBarra, nRow, nCol, lHorz, Color, nWidth, nHeigth )
    
RETURN nil

//-------------------------\\

METHOD Code128( nRow, nCol, cCode, lCheck, Color, lHorz, nWidth, nHeigth, cMode ) CLASS TPdf

   local nSum:=0, cBarra, cCar
   local cTemp, n, nCAr, nCount:=0
   local lCodeC := .f. ,lCodeA:= .f.
   local aCode := { "212222", "222122", "222221", "121223", "121322", "131222", "122213",;
                    "122312", "132212", "221213", "221312", "231212", "112232", "122132",;
                    "122231", "113222", "123122", "123221", "223211", "221132", "221231",;
                    "213212", "223112", "312131", "311222", "321122", "321221", "312212",;
                    "322112", "322211", "212123", "212321", "232121", "111323", "131123",;
                    "131321", "112313", "132113", "132311", "211313", "231113", "231311",;
                    "112133", "112331", "132131", "113123", "113321", "133121", "313121",;
                    "211331", "231131", "213113", "213311", "213131", "311123", "311321",;
                    "331121", "312113", "312311", "332111", "314111", "221411", "431111",;
                    "111224", "111422", "121124", "121421", "141122", "141221", "112214",;
                    "112412", "122114", "122411", "142112", "142211", "241211", "221114",;
                    "213111", "241112", "134111", "111242", "121142", "121241", "114212",;
                    "124112", "124211", "411212", "421112", "421211", "212141", "214121",;
                    "412121", "111143", "111341", "131141", "114113", "114311", "411113",;
                    "411311", "113141", "114131", "311141", "411131", "211412", "211214",;
                    "211232", "2331112" }


   // control de errores
   if !empty(cMode)
     if valtype(cMode)="C" .and. Upper(cMode) $ "ABC"
       cMode := Upper(cMode)
     else
       alert("Code 128 Modes are A,B o C. Character values.")
     end
   end
   if empty(cMode) // modo variable
     // an lisis de tipo  de c¢digo...
     if str( val( cCode ), len( cCode ) ) = cCode // s¢lo n£meros
       lCodeC := .t.
       cTemp := aCode[106]
       nSum := 105
       if ( len( cCode ) % 2 = 1 )
         cCode := "0" + cCode
       end
     else
       for n:=1 to len( cCode )
         nCount += if( substr( cCode, n, 1 ) > 31, 1, 0 ) // no cars. de control
       next
       if nCount < len(cCode) /2
         lCodeA := .t.
         cTemp := aCode[ 104 ]
         nSum := 103
       else
         cTemp := aCode[ 105 ]
         nSum := 104
       end
     end
   else
     if cMode == "C"
       lCodeC := .t.
       cTemp:=aCode[ 106 ]
       nSum := 105
       if ( len( cCode ) % 2 = 1 )
         cCode := "0" + cCode
       end
     elseif cMode == "A"
       lCodeA := .t.
       cTemp := aCode[ 104 ]
       nSum := 103
     else
       cTemp := aCode[ 105 ]
       nSum := 104
     end
   end

   nCount := 0 // caracter registrado
   for n:= 1 to len( cCode )
     nCount ++
     cCar := substr( cCode, n, 1 )
     if lCodeC
       if len( cCode ) = n  // ultimo caracter
         CTemp += aCode[ 101 ] // SHIFT Code B
         nCar := asc( cCar ) - 31
       else
         nCar := Val( substr( cCode, n, 2 ) ) + 1
         n++
       end
     elseif lCodeA
       if cCar > "_" // Shift Code B
         cTemp += aCode[ 101 ]
         nCar := asc( cCar ) - 31
       elseif cCar <= " "
         nCar := asc( cCar ) + 64
       else
         nCar := asc( cCar ) - 31
       endif
     else // code B standard
       if cCar <= " " // shift code A
         cTemp += aCode[ 102 ]
         nCar := asc( cCar ) + 64
       else
         nCar := asc( cCar ) - 31
       end
     endif
     nSum += ( nCar - 1 ) * nCount
     cTemp := cTemp + aCode[ nCar ]
   next
   nSum := nSum % 103 + 1
   cTemp := cTemp + aCode[ nSum ] + aCode[ 107 ]
   cBarra := ""
   for n:=1 to len( cTemp ) step 2
      cBarra += replicate("1", val( substr( cTemp, n , 1 ) ) )
      cBarra += replicate("0", val( substr( cTemp, n + 1 ,1 ) ) )
   next

   ::Gen_Code( cBarra, nRow, nCol, lHorz, Color, nWidth, nHeigth )
    
RETURN nil

//-------------------------\\

METHOD Valida_UPC( cCode, nLen ) CLASS TPdf
   local s1,s2,n,l,control

   default nLen to 11
   default cCode to "0"
   
   // valid values for nLen are 11,7
   cCode := left( alltrim( cCode ) + "000000000000", nLen )   // padding with "0"

   // calculo del digito de control
   s1:=0                                         // suma de impares
   s2:=0                                         // suma de pares
   for n=1 to nLen step 2
      s1:=s1+val(substr(cCode,n,1))
      s2:=s2+val(substr(cCode,n+1,1))
   next
   control:=(s1*3)+s2

RETURN cCode += Str( 10 - Mod( control, 10 ), 1 ) //

//-------------------------\\

METHOD Valida_Ean13( cCode ) CLASS TPdf
   local s1,s2,l,Control,n
   s1:=0                                         // suma de impares
   s2:=0                                         // suma de pares
   for n=1 to 6
      s1:=s1+val(substr(cCode,(n*2)-1,1))
      s2:=s2+val(substr(cCode,(n*2),1))
   next
   control:=(s2*3)+s1

RETURN cCode += Str( 10 - Mod( control, 10 ), 1 ) //cCode

//-------------------------\\

METHOD Gen_Code( cBarra, nx, ny, lHoRz, Color, nWidth, nLen, aPorc ) CLASS TPdf
    local n, nLen1 := 0, nL
    
    DEFAULT lHoRz TO .t.
    DEFAULT nWidth TO 0.60 // 1/3 M/mm
    DEFAULT nLen TO 25 // mm.
    
    if aPorc != Nil
      if aPorc[1] != Nil
        nLen1 := nLen * aPorc[1]
      End
    End


    for n:=1 to len(cBarra)
      if substr( cBarra, n, 1 ) = "1"
        nL := nLen
        if lHoRz
          if nLen1 != 0
            if ( n > aPorc[2] .and. n < aPorc[3] ) .Or. ( n > aPorc[4] .and. n < aPorc[5] )
              nL := nLen1
            end
          end
         ::aReport[ PAGEBUFFER ] += CRLF + "0 g " + ltrim(str( ny )) + " " + ltrim(str( ::aReport[ PAGEY ] - nx )) +;
                                    " " + ltrim(str( nWidth )) + " -" + ltrim(str( nL )) + " re f"
        else
          if nLen1 != 0
            if ( n > aPorc[2] .and. n < aPorc[3] ) .Or. ( n > aPorc[4] .and. n < aPorc[5] )
              nL := nLen1
            end
          end
         ::aReport[ PAGEBUFFER ] += CRLF + "0 g " + ltrim(str( ny + (nLen-nL))) + " " + ltrim(str( ::aReport[ PAGEY ] - nx )) +;
                                    " " + ltrim(str( nL )) + " -" + ltrim(str( nWidth )) + " re f"
        end

      end
      if lHoRz
        ny += nWidth
      else
        nx += nWidth
      end
    next

RETURN nil

//-------------------------\\
//-------------------------\\
//-------------------------\\
//-------------------------\\
//-------------------------\\

static function FilePos( nHandle )
return FSEEK( nHandle, 0, FS_RELATIVE )

/*
//-------------------------\\

static function stuff( cStr, nBeg, nDel, cIns )
return PosIns( PosDel( cStr, nBeg, nDel ), cIns, nBeg )
*/
//-------------------------\\

static function Chr_RGB( cChar )
return str(asc( cChar ) / 255, 4, 2)

//-------------------------\\

static function TimeAsAMPM( cTime )
   IF VAL(cTime) < 12
      cTime += " am"
   ELSEIF VAL(cTime) == 12
      cTime += " pm"
   ELSE
      cTime := STR(VAL(cTime) - 12, 2) + SUBSTR(cTime, 3) + " pm"
   ENDIF
   cTime := left( cTime, 5 ) + substr( cTime, 10 )
return cTime

//-------------------------\\

static function FileSize( cFile )

   LOCAL nLength
   LOCAL nHandle

   nHandle := fOpen( cFile )
   nLength := fSeek( nHandle, 0, FS_END )
   fClose( nHandle )

return nLength

//-------------------------\\

static FUNCTION NumToken( cString, cDelimiter )
RETURN AllToken( cString, cDelimiter )

//-------------------------\\

static FUNCTION Token( cString, cDelimiter, nPointer )
RETURN AllToken( cString, cDelimiter, nPointer, 1 )

//-------------------------\\

static function AtToken( cString, cDelimiter, nPointer )
return AllToken( cString, cDelimiter, nPointer, 2 )

//-------------------------\\

static function AllToken( cString, cDelimiter, nPointer, nAction )
local nTokens := 0
local nPos    := 1
local nLen    := len( cString )
local nStart
local cRet    := 0

DEFAULT cDelimiter TO chr(0)+chr(9)+chr(10)+chr(13)+chr(26)+chr(32)+chr(138)+chr(141)
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

//-------------------------\\
//
// next 3 function written by Peter Kulek
// modified for compatibility with common.ch by V.K.
// modified DATE processing by V.K.
//
static function Array2File( cFile, aRay, nDepth, hFile )
local nBytes := 0
local i
local lOpen  := ( hFile != nil )

nDepth := iif( ISNUMBER( nDepth ), nDepth, 0 )
//if hFile == NIL
if !lOpen
   if ( hFile := fCreate( cFile,FC_NORMAL ) ) == -1
      return nBytes
   endif
endif
nDepth++
nBytes += WriteData( hFile,aRay )
if ISARRAY( aRay )
   for i := 1 to len( aRay )
      nBytes += Array2File( cFile,aRay[i],nDepth,hFile )
   next
endif
nDepth--
// if nDepth == 0
if !lOpen
   fClose(hFile)
endif

return nBytes

//-------------------------\\

static function WriteData(hFile,xData)
local cData  := valtype(xData)

   if ISCHARACTER(xData)
       cData += i2bin( len( xData ) ) + xData
   elseif ISNUMBER(xData)
       cData += i2bin( len( alltrim( str( xData ) ) ) ) + alltrim( str( xData ) )
   elseif ISDATE( xData )
       cData += i2bin( 8 )+dtos(xData)
   elseif ISLOGICAL(xData)
       cData += i2bin( 1 )+iif( xData,"T","F" )
   elseif ISARRAY( xData )
       cData += i2bin( len( xData ) )
   else
       cData += i2bin( 0 )   // NIL
   endif

return fWrite( hFile, cData, len( cData ) )

//-------------------------\\

static function File2Array( cFile, nLen, hFile )
LOCAL cData,cType,nDataLen,nBytes
local nDepth := 0
local aRay   := {}
local lOpen  := ( hFile != nil )

if hFile == NIL        // First Timer
   if ( hFile := fOpen( cFile,FO_READ ) ) == -1
      return aRay
   endif
   cData := space( 3 )
   fRead( hFile, @cData, 3 )
   if !( left( cData,1 ) == "A" )     //  If format of file != array
      fClose( hFile )            //////////
      return aRay
   endif
   nLen := bin2i( right( cData,2 ) )
endif

do while nDepth < nLen
    cData  := space( 3 )
    nBytes := fRead( hFile, @cData, 3 )
    if nBytes < 3
       exit
    endif
    cType    := padl( cData,1 )
    nDataLen := bin2i( right( cData,2 ) )
    if !( cType == "A" )
       cData := space( nDataLen )
       nBytes:= fRead( hFile, @cData, nDataLen )
       if nBytes < nDataLen
           exit
       endif
    endif
    nDepth++
    aadd( aRay,NIL )
    if cType=="C"
        aRay[ nDepth ] := cData
    elseif cType=="N"
        aRay[ nDepth ] := val(cData)
    elseif cType=="D"
        aRay[ nDepth ] := ctod( left( cData, 4 ) + "/" + substr( cData, 5, 2 ) + "/" + substr( cData, 7, 2 )) //stod(cData)
    elseif cType=="L"
        aRay[ nDepth ] := ( cData=="T" )
    elseif cType=="A"
        aRay[ nDepth ] := File2Array( , nDataLen, hFile )
    endif
enddo

if !lOpen
    fClose( hFile )
endif

return aRay

//-------------------------\\

static FUNCTION NumAt( cSearch, cString )

   LOCAL n := 0, nAt, nPos := 0
   WHILE ( nAt := at( cSearch, substr( cString, nPos + 1 ) )) > 0
           nPos += nAt
           ++n
   ENDDO

RETURN n

//-------------------------\\

static function RunExternal( cCmd, cVerb, cFile )
local lRet := .t.

    if cVerb != nil
// TOFIX: This requires hbwhat, which in turns requires xhb.
//        This has to be solved differently.
//      ShellExecute( GetDeskTopWindow(), cVerb, cFile, , , 1 )
        HB_SYMBOL_UNUSED( cFile )
    else
      run( cCmd )
    endif

return lRet

//-------------------------\\
