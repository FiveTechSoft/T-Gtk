/* $Id: timprimepdf.prg,v 0.1 2015-11-09 11:56:21 riztan Exp $*/
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
    (c)2015 Rafael Carmona <rafa.thefull@gmail.com>
*/
#include "hbclass.ch"
#include "harupdf.ch"
#include "common.ch"
#include "tutilpdf.ch"
/*
 ******************************************************************************
  Clase TIMPRIMEPDF
  Nos permite generar ficheros pdf a traves de la libreria Hairu.
  Esta clase nos provee la facilidad de trabajar con cms.
 ******************************************************************************
 */
CLASS TIMPRIMEPDF
    DATA pPdf                  // Pointer
    DATA aPages                // Array Pages creates
    DATA Page_Active           // Page active
    DATA PointToInch INIT 72
    DATA Font_Active           // Font Active
    DATA nSpace_Separator   INIT 0.5
    DATA nEndLine              // Fin de la ultima linea
    DATA nLinea INIT 1
    DATA nFila  INIT 1
    DATA oUtil
    DATA cFontDefault INIT "Courier"
    DATA cFileName    INIT "tgtk.pdf"
    DATA aFonts
    DATA aEncodings
    DATA cEncoding   INIT "ISO8859-15"
    DATA lUTF8toISO  INIT .T.     // Esta versión de HARU no tiene soporte de UTF8, hacemos conversion automaticamente del texto a imprimir
    DATA def_font
    
    METHOD New( cFile ) CONSTRUCTOR
    METHOD Init( cFile ) INLINE ::New( cFile ) 

    MESSAGE Date      METHOD _DateTime( nLinea, nFila )
    MESSAGE MesFecha  METHOD _MesFecha_( dDate )

    METHOD SaveAs( cFileToSave )  INLINE HPDF_SaveToFile( ::pPdf, cFileToSave )
    METHOD SetCompresion( cMode ) INLINE HPDF_SetCompressionMode( ::pPdf, cMode )

    METHOD AddPage()
    METHOD PageSetSize( nSize, nDirection ) INLINE HPDF_Page_SetSize( ::Page_Active, nSize, nDirection )
    METHOD GetPageHeight() INLINE HPDF_Page_GetHeight( ::Page_Active )
    METHOD GetPageWidth()  INLINE HPDF_Page_GetWidth( ::Page_Active )
    METHOD GetFontSize()   INLINE HPDF_PAGE_GETCURRENTFONTSIZE( ::Page_Active )
    METHOD GetFontName()   INLINE HPDF_Font_GetFontName( ::Font_Active )
    
    METHOD SetFontSize( nSize )
    METHOD SetFont( cFontName, nSize, cEncoding  )

    METHOD CMSAY( nRowCms, nColCms, cText, nSize )
    METHOD CMS2POINTS( nCms )
    METHOD POINTS2CMS( nPoints )
    METHOD Rectangle( nTop, nLeft, nRight, nBottom )
    METHOD SetRgbStroke( nRed, nGreen, nBlue ) INLINE HPDF_Page_SetRGBStroke( ::page_active, nRed, nGreen, nBlue)
    METHOD SetRgbFill( nRed, nGreen, nBlue  )  INLINE HPDF_Page_SetRGBFill( ::Page_Active, nRed, nGreen, nBlue) // 0 ... 1
    METHOD PageFill()                          INLINE HPDF_Page_Fill( ::Page_Active )
    METHOD PageFillStroke()                    INLINE HPDF_Page_FillStroke( ::Page_Active )
    METHOD PageStroke()                        INLINE HPDF_Page_Stroke( ::Page_Active )


    METHOD Separator( nJump )
    METHOD CompLinea( nSuma )
    METHOD SetPortrait()  INLINE ( ::PageSetSize( HPDF_PAGE_SIZE_A4, HPDF_PAGE_PORTRAIT ),;
                                   ::nEndLine := ::POINTS2CMS( ::GetPageHeight() ) )
    METHOD SetLandScape()  INLINE ( ::PageSetSize( HPDF_PAGE_SIZE_A4, HPDF_PAGE_LANDSCAPE ),;
                                   ::nEndLine := ::POINTS2CMS( ::GetPageHeight() ) )


    //Methods Destructores
    METHOD End( lPageCount )

    METHOD PageCount()
    MESSAGE Eject     METHOD __Eject()
    METHOD SetLineWidth( nWidth ) INLINE HPDF_Page_SetLineWidth( ::Page_Active, nWidth )

    METHOD GSave()    INLINE  HPDF_Page_GSave( ::Page_Active )      // Save the current graphic state 
    METHOD GRestore() INLINE  HPDF_Page_GRestore( ::Page_Active )   // Restore graphic state 
/* 
    METHOD GSave()    VIRTUAL
    METHOD GRestore() VIRTUAL
*/
    METHOD LoadImagePng( cFileImage ) INLINE HPDF_LoadPngImageFromFile( ::pPdf, cFileImage )
    METHOD LoadImageJpg( cFileImage ) INLINE HPDF_LoadJpegImageFromFile( ::pPdf, cFileImage )
    METHOD ImageGetWidth( pImage )  INLINE HPDF_Image_GetWidth( pImage )
    METHOD ImageGetHeight( pImage ) INLINE HPDF_Image_GetHeight( pImage )
    METHOD DrawImage( pImage, x, y, nWidth, nHeight )
    METHOD UseUTF() INLINE HPDF_UseUTFEncodings( ::pPdf )
    METHOD Line( nTop, nLeft, nBottom, nRight, nWitdh, nRed, nGreen, nBlue )
    METHOD SetEncoder( cEncoding ) INLINE HPDF_SetCurrentEncoder  ( ::pPdf, cEncoding )
    Method LoadTTF( cFont )  INLINE HPDF_LoadTTFontFromFile ( ::pPdf, "/home/rafa/pol/fonts/"+cFont +".ttf", HPDF_TRUE)
    METHOD CMSAYRECT(nRowCms, nColCms, cText, cFont, nSize, nRed, nGreen, nBlue, nAngle, nBottom, nRight, nJustify)
    METHOD CreateFonts()

    METHOD Grid()  INLINE  print_grid( ::pPDF, ::Page_Active )

END CLASS

METHOD New( cFile ) CLASS TIMPRIMEPDF
   ::CreateFonts()
   
   ::pPdf := HPDF_New()
   ::aPages := {}
   ::AddPage()         // Crea pagina para imprimir

   DEFINE UTILPDF ::oUtil OF Self
   ::cFileName := cFile

RETURN Self

METHOD CreateFonts() CLASS TIMPRIMEPDF
   ::aFonts  := { ;
                    "Courier",                  ; // 1
                    "Courier-Bold",             ; // 2 
                    "Courier-Oblique",          ; // 3
                    "Courier-BoldOblique",      ; // 4
                    "Helvetica",                ; // 5
                    "Helvetica-Bold",           ; // 6
                    "Helvetica-Oblique",        ; // 7
                    "Helvetica-BoldOblique",    ; // 8
                    "Times-Roman",              ; // 9
                    "Times-Bold",               ; // 10
                    "Times-Italic",             ; // 11
                    "Times-BoldItalic",         ; // 12
                    "Symbol",                   ; // 13
                    "ZapfDingbats"              ; // 14 
                  }

  ::aEncodings := { ;
            "StandardEncoding",;
            "MacRomanEncoding",;
            "WinAnsiEncoding", ;
            "ISO8859-2",       ;
            "ISO8859-3",       ;
            "ISO8859-4",       ;
            "ISO8859-5",       ;
            "ISO8859-9",       ;
            "ISO8859-10",      ;
            "ISO8859-13",      ;
            "ISO8859-14",      ;
            "ISO8859-15",      ;
            "ISO8859-16",      ;
            "CP1250",          ;
            "CP1251",          ;
            "CP1252",          ;
            "CP1254",          ;
            "CP1257",          ;
            "KOI8-R",          ;
            "Symbol-Set",      ;
            "ZapfDingbats-Set" }

RETURN NIL

*******************************************************************************
METHOD End( lPageCount ) CLASS TIMPRIMEPDF

  DEFAULT lPageCount TO .F.

  if lPageCount
     ::PageCount(  )
  endif

  ::SaveAs( ::cFileName ) // Save File

  HPDF_Free( ::pPdf )
RETURN NIL

*******************************************************************************
METHOD AddPage() CLASS TIMPRIMEPDF

   ::Page_Active := HPDF_AddPage( ::pPdf )
   ::SetFont( ::cFontDefault, 10)  // Important, definir font
   AADD( ::aPages, ::Page_Active )
   ::nEndLine := ::POINTS2CMS( ::GetPageHeight() )

RETURN ::Page_Active

*******************************************************************************
METHOD CMSAY( nRowCms, nColCms, cText, cFont, nSize, nRed, nGreen, nBlue, nAngle ) CLASS TIMPRIMEPDF
   Local uFont := ::GetFontName()
   Local uSize := ::GetFontSize()
   Local nRad1

   DEFAULT nRed TO 0 , nGreen TO 0 , nBlue TO 0

   if ::lUTF8toISO
      cText := _UTF_8 ( cText )
   endif

   ::GSave()
   if !empty( cFont  ) .OR. !empty( nSize )
      ::SetFont( cFont, nSize )
   endif

   HPDF_Page_BeginText( ::Page_Active )

    if !empty( nAngle  )
       nRad1 := nAngle / 180 * 3.141592 
       HPDF_Page_SetTextMatrix( ::Page_Active, cos(nRad1), sin(nRad1), -sin(nRad1), cos(nRad1), ::CMS2POINTS( nColCms ), ::GetPageHeight() - ::CMS2POINTS( nRowCms ) )
    else
       HPDF_Page_MoveTextPos(::Page_Active , ::CMS2POINTS( nColCms ), ::GetPageHeight() - ::CMS2POINTS( nRowCms ))
    endif

    HPDF_Page_SetRGBFill( ::Page_Active, nRed, nGreen, nBlue) // 0 ... 1
    HPDF_Page_ShowText(::Page_Active, cText )

   //HPDF_Page_TextOut( ::Page_Active, ::CMS2POINTS( nColCms ), ::GetPageHeight() - ::CMS2POINTS( nRowCms ), cText )

   HPDF_Page_EndText( ::Page_Active )
   ::GRestore()

RETURN NIL

*******************************************************************************
METHOD CMSAYRECT(nRowCms, nColCms, cText, cFont, nSize, nRed, nGreen, nBlue, nAngle, nBottom, nRight, nAlign) CLASS TIMPRIMEPDF 
   Local uFont := ::GetFontName()
   Local uSize := ::GetFontSize()
   Local nRad1
   Local rect := Array( 4 )

   rect[ rLEFT   ] := ::CMS2POINTS( nColCms )

   rect[ rTOP    ] := ::GetPageHeight() - ::CMS2POINTS( nRowCms )
   rect[ rRIGHT  ] := ::CMS2POINTS( nRight )
   rect[ rBOTTOM ] := ::GetPageHeight() - ::CMS2POINTS( nBottom )

   DEFAULT nRed TO 0 , nGreen TO 0 , nBlue TO 0,;
           nAlign TO HPF_TALIGN_JUSTIFY

   if ::lUTF8toISO
      cText := _UTF_8 ( cText )
   endif

   ::GSave()
   if !empty( cFont  ) .OR. !empty( nSize )
      ::SetFont( cFont, nSize )
   endif

   HPDF_Page_BeginText( ::Page_Active )

    if !empty( nAngle  )
       nRad1 := nAngle / 180 * 3.141592 
       HPDF_Page_SetTextMatrix( ::Page_Active, cos(nRad1), sin(nRad1), -sin(nRad1), cos(nRad1), ::CMS2POINTS( nColCms ), ::GetPageHeight() - ::CMS2POINTS( nRowCms ) )
    else
       HPDF_Page_MoveTextPos(::Page_Active , ::CMS2POINTS( nColCms ), ::GetPageHeight() - ::CMS2POINTS( nRowCms ))
    endif

    HPDF_Page_SetRGBFill( ::Page_Active, nRed, nGreen, nBlue) // 0 ... 1
    HPDF_Page_TextRect( ::Page_Active, rect[ rLEFT ], rect[ rTOP ], rect[ rRIGHT ], rect[ rBOTTOM ],;
               cText, nAlign, NIL)

   HPDF_Page_EndText( ::Page_Active )
   ::GRestore()

RETURN NIL

*******************************************************************************
METHOD Rectangle( nTop, nLeft, nBottom, nRight ) CLASS TIMPRIMEPDF
   Local rect := Array( 4 )

   rect[ rLEFT   ] := ::CMS2POINTS( nLeft )
   rect[ rTOP    ] := ::GetPageHeight() - ::CMS2POINTS( nTop )
   rect[ rRIGHT  ] := ::CMS2POINTS( nRight )
   rect[ rBOTTOM ] := ::GetPageHeight() - ::CMS2POINTS( nBottom )

   HPDF_Page_SetLineCap( ::Page_Active, HPDF_ROUND_END)
   HPDF_Page_Rectangle( ::Page_Active, rect[ rLEFT ], rect[ rBOTTOM ], rect[ rRIGHT ] - rect[ rLEFT ], ;
                                       rect[ rTOP ] - rect[ rBOTTOM ] )

RETURN NIL

*******************************************************************************
METHOD Line( nTop, nLeft, nBottom, nRight, nWitdh, nRed, nGreen, nBlue ) CLASS TIMPRIMEPDF
   Local rect := Array( 4 )

   rect[ rLEFT   ] := ::CMS2POINTS( nLeft )
   rect[ rTOP    ] := ::GetPageHeight() - ::CMS2POINTS( nTop )
   rect[ rRIGHT  ] := ::CMS2POINTS( nRight )
   rect[ rBOTTOM ] := ::GetPageHeight() - ::CMS2POINTS( nBottom )

   HPDF_Page_MoveTo( ::Page_Active, rect[ rLEFT   ] , rect[ rTOP ] )
   HPDF_Page_LineTo( ::Page_Active, rect[ rRIGHT  ],  rect[ rBOTTOM ])
   ::PageStroke()

RETURN NIL

*******************************************************************************
METHOD DrawImage( pImage, x, y, nWidth, nHeight )  CLASS TIMPRIMEPDF

   x := ::GetPageHeight() - ::CMS2POINTS( x )
   y := ::CMS2POINTS( y )

   if empty( nWidth )
      nWidth := ::ImageGetWidth( pImage )
   else
      nWidth := ::CMS2POINTS( nWidth )
   endif

   if empty( nHeight )
      nHeight := ::ImageGetHeight( pImage )
   else
      nHeight := ::CMS2POINTS( nHeight  )
   endif

   //Nota: Restamos la mitad del alto para obtener la posicion real de X
   x -= nHeight

   HPDF_Page_DrawImage( ::Page_Active, pImage, y, x, nWidth, nHeight )

RETURN NIL

*******************************************************************************
METHOD SetFont( cFontName, nSize, cEncoding  ) CLASS TIMPRIMEPDF
   
   DEFAULT cEncoding  TO ::cEncoding , nSize TO 10

   ::Font_Active := HPDF_GetFont( ::pPdf, cFontName, cEncoding  )
   
   if !empty( nSize )
      ::SetFontSize( nSize )
   endif

RETURN NIL

*******************************************************************************
METHOD SetFontSize( nSize ) CLASS TIMPRIMEPDF
   HPDF_Page_SetFontAndSize( ::Page_Active, ::Font_Active, nSize )
RETURN NIL

*******************************************************************************
METHOD CMS2POINTS( nCms ) CLASS TIMPRIMEPDF
RETURN ( nCms/2.54*::PointToInch )

*******************************************************************************
METHOD POINTS2CMS( nPoints ) CLASS TIMPRIMEPDF
RETURN ( nPoints / ::PointToInch * 2.54 )

*******************************************************************************
/* Funcion que nos comprueba si tenemos que realizar una pagina nueva
  El salto de pagina se produce cuando la Linea sobrepasa la dimension
  fisica de la hoja en vertical.
  Esto nos da como resultado usar cualquier tipo de papel sin complicaciones.
  Si salta pagina devuelve .T. , sino .F.
  */
*******************************************************************************
METHOD CompLinea( nSuma ) CLASS TIMPRIMEPDF
       Static nPage := 1

       DEFAULT nSuma TO 0

       IF ::nLinea > ( ::nEndLine + nSuma  )
          ::Addpage()  // Add page to document
          ::nLinea := 1
          Return .T.
       ENDIF

Return .F.

*******************************************************************************
METHOD Separator( nSpace , nSuma ) CLASS TIMPRIMEPDF
     Local lRet

   if Empty( nSpace ) /* Si no paso espacio, por defecto */
      nSpace := ::nSpace_Separator
   endif

   ::nLinea += nSpace
   lRet := ::CompLinea( nSuma )  // Retorna si se ha producido salto de pagina

Return lRet

*******************************************************************************
*******************************************************************************
METHOD PageCount( )  CLASS TIMPRIMEPDF
   Local x
   Local nFilesLong := Len( ::aPages )
   Local nHojas := nFilesLong
   Local nEndCol
   Local nEndLine
   Local cInfo_Page

   if nFilesLong <= 1  // Solamente una pagina, Si hay copia son X Copias
      Return Nil
   endif

   FOR x := 1 TO  nFilesLong
      ::Page_Active := ::aPages[ x ]
      nEndCol   := ::Points2Cms( ::GetPageWidth() )  - 3
      nEndLine  := ::POINTS2CMS( ::GetPageHeight() ) - 1
      cInfo_Page := "Hoja " + Alltrim( Str( x ) ) +" de " + Alltrim( Str( nFilesLong ) )
      ::CMSAY( nEndLine +.5, nEndCol, cInfo_Page, "Courier" )
   NEXT

Return NIl

******************************************************************************
******************************************************************************
METHOD __Eject() CLASS TIMPRIMEPDF
     ::AddPage()
RETURN NIL

METHOD _DateTime( nLinea, nFila ) CLASS TIMPRIMEPDF

  DEFAULT nLinea TO 0.5
  DEFAULT nFila  TO 15

  UTILPDF Self:oUtil nLinea,nFila SAY "Fecha: " + DTOC( Date() )+" Hora: "+ Time() FONT ::aFonts[2] SIZE 8

Return Self

******************************************************************************
******************************************************************************
METHOD _MesFecha_( dDate ) CLASS TIMPRIMEPDF

  Local cMes

  DO CASE
     CASE Month(dDate) == 1 ; cMes := "Enero"
     CASE Month(dDate) == 2 ; cMes := "Febrero"
     CASE Month(dDate) == 3 ; cMes := "Marzo"
     CASE Month(dDate) == 4 ; cMes := "Abril"
     CASE Month(dDate) == 5 ; cMes := "Mayo"
     CASE Month(dDate) == 6 ; cMes := "Junio"
     CASE Month(dDate) == 7 ; cMes := "Julio"
     CASE Month(dDate) == 8 ; cMes := "Agosto"
     CASE Month(dDate) == 9 ; cMes := "Septiembre"
     CASE Month(dDate) == 10; cMes := "Octubre"
     CASE Month(dDate) == 11; cMes := "Noviembre"
     CASE Month(dDate) == 12; cMes := "Diciembre"
     OTHERWISE
       cMes := "Incorrecto"
  ENDCASE

Return  cMes

/*
STATIC PROCEDURE print_grid( pPdf, pPage )
   local height, width
   
RETURN
*/

