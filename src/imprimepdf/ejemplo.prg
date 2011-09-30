// T:\harboursvn\contrib\hbhpdf\tests>t:\harboursvn\bin\win\bcc\hbmk2.exe ejemplo.prg -w1
#include "hbclass.ch"
#include "harupdf.ch"
#include "common.ch"

PROCEDURE Main(  )
   Local oHairu, nLinea, samp_text, i, oFact
   LOCAL font_list  := { ;
                        "Courier",                  ;
                        "Courier-Bold",             ;
                        "Courier-Oblique",          ;
                        "Courier-BoldOblique",      ;
                        "Helvetica",                ;
                        "Helvetica-Bold",           ;
                        "Helvetica-Oblique",        ;
                        "Helvetica-BoldOblique",    ;
                        "Times-Roman",              ;
                        "Times-Bold",               ;
                        "Times-Italic",             ;
                        "Times-BoldItalic",         ;
                        "Symbol",                   ;
                        "ZapfDingbats"              ;
                      }

   EjemploFacturaPdf()
/*
   oHairu := TIMPRIMEPDFPdf():New()                                  // Creamos documento

   oHairu:PageSetSize( HPDF_PAGE_SIZE_A4, HPDF_PAGE_LANDSCAPE ) // Page format

   oHairu:SetFont( font_list[1], 10)
   nLinea := 1
   oHairu:CmsSay( nLinea, 1, "HARBOUR" )

   nLinea += 0.5
   oHairu:SetFont( font_list[1], 12 )
   oHairu:CMSAY( nLinea, 1, "power" )

   nLinea += 1
   oHairu:SetFont( font_list[5], 24 )
   oHairu:CMSAY( nLinea, 1, "(c)2011 by Rafa Carmona" )

   //Second Page
   oHairu:Addpage()                                            // Add page to document
   oHairu:PageSetSize( HPDF_PAGE_SIZE_A4, HPDF_PAGE_PORTRAIT ) // Page format

   nLinea := 1
   FOR i := 1 TO Len( font_list )
      samp_text := "abcdefgABCDEFG12345!#$%&+-@?"
      oHairu:SetFont( font_list[i], 9 )
      oHairu:CMSAY( nLinea, 1, font_list[i] )
      nLinea += 0.6

      oHairu:SetFont( font_list[i], 20 )
      oHairu:CMSAY( nLinea, 1, samp_text  )
      nLinea += 0.6

   NEXT
   oHairu:End( "test.pdf", .t. )

*/

RETURN

Function EjemploFacturaPdf()
   Local oFact

   oFact := TFacturaPDF():New( "factura.pdf" )
   oFact:Print()
   oFact:End( )


return nil

//  ------------------------------------------------------------------------------------
#xcommand DEFINE UTILPDF  <oUtil>  ;
          [ < of: PRINTER,OF> <oPrinter> ]  ;
          [ BRUSH <oBrush> ] ;
          [ PEN   <oPen>   ] ;
         =>;
         [ <oUtil> := ] TUtilPdf():New( <oPrinter>,<oBrush>,<oPen> )

// TODO: Deberiamos poner establecer un color de una manera mas sencilla
#xcommand UTILPDF <oUtil> ;
          [ <nRow>,<nCol> SAY <cText> ];
          [ FONT <cFont> ] [SIZE <nSize> ];
          [ ROTATE <nAngle>];
          [ COLOR [ RED <nRed>] [GREEN <nGreen>] [BLUE <nBlue>] ];
         =>;
           <oUtil>:Text( <cText>,<nRow>,<nCol>,<cFont>,<nSize>, <nRed>,<nGreen>,<nBlue>, <nAngle>)

#xcommand ISEPARATOR [ <nSpace> ] [<lBody: BODY>];
         =>;
           ::Separator( <nSpace> , <.lBody.>)

//TODO: BRUSH, PEN, ROUND
#xcommand UTILPDF <oUtil> ;
          BOX <nX>,<nY> TO <nX2>,<nY2> ;
          [ BORDE [ SIZE <nWitdh>] [ COLOR [ RED <nRed>] [GREEN <nGreen>] [BLUE <nBlue>] ] ];
         =>;
           <oUtil>:Box( <nX>,<nY>,<nX2>,<nY2>,<nWitdh>,<nRed>,<nGreen>,<nBlue> )

/*
 Ejemplo de impresion de una factura.
 */

CLASS TFacturaPDF FROM TIMPRIMEPDF
      DATA nEndBody INIT 22   // Limite donde tiene que llegar las lineas de la factura

      METHOD New( cFile ) INLINE Super:New( cFile )
      METHOD Print()
      METHOD Body()
      METHOD Separator( nSpace, lBody )
      METHOD Headers()
      METHOD Footers() VIRTUAL

ENDCLASS

METHOD Print() CLASS TFacturaPDF

       ::Headers()
       ::Body()
       ::Footers()

       ::AddPage()

       UTILPDF ::oUtil 1, 1 SAY  "Que grande que vinistes..."

RETURN NIL

METHOD Headers() CLASS TFacturaPDF


       UTILPDF ::oUtil ;
               BOX 3,0.75 TO 4, 4.25 ;
               BORDE SIZE 2 COLOR BLUE 1

       UTILPDF ::oUtil 3.5, 1 SAY  "Numero Albaran"

//       ::Rectangle( 3, 4.25, 15, 4 )
        UTILPDF ::oUtil BOX 3, 4.25 TO 4, 15
        UTILPDF ::oUtil 3.5, 5 SAY  "Concepto" FONT ::aFonts[2] SIZE 15

RETURN NIL

METHOD Body() CLASS TFacturaPDF
      Local X, nValue := 10
      Local nRandom

      ::nLinea := 5                      // En cuerpo empieza en los 5 cms

      for x := 1 to 40

          UTILPDF ::oUtil Self:nLinea, 1.5 SAY "1233231" FONT ::aFonts[3] SIZE 10
          if mod( nValue, 2 ) = 0
             nvalue := 15
          else
              nvalue := 10
          endif
          nRandom := int( HB_Random(1,14) )
          UTILPDF ::oUtil Self:nLinea, 4.35 SAY  "Conceptos:"+ Alltrim( Str( ::nLinea ) ) FONT ::aFonts[nRandom] SIZE nValue
          ISEPARATOR
      Next


RETURN Nil

**********************************************************************************
**********************************************************************************
METHOD Separator( nSpace, lBody ) CLASS TFacturaPDF

   IF ::nLinea >= ::nEndBody
      ::Eject()
      ::nLinea := 5   // En cuerpo empieza en los 5 cms
      ::Headers()
      ::Footers()
   ELSEIF Super:Separator( nSpace )
       ::Headers()
       ::Footers()
   ENDIF

Return NIL



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

    METHOD New( cFile ) CONSTRUCTOR
    METHOD Init( ) INLINE ::New()

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

    METHOD GSave()    INLINE  HPDF_Page_GSave( ::Page_Active )      /* Save the current graphic state */
    METHOD GRestore() INLINE  HPDF_Page_GRestore( ::Page_Active )   /* Restore graphic state */



END CLASS

METHOD New( cFile ) CLASS TIMPRIMEPDF
   :: aFonts  := { ;
                    "Courier",                  ;
                    "Courier-Bold",             ;
                    "Courier-Oblique",          ;
                    "Courier-BoldOblique",      ;
                    "Helvetica",                ;
                    "Helvetica-Bold",           ;
                    "Helvetica-Oblique",        ;
                    "Helvetica-BoldOblique",    ;
                    "Times-Roman",              ;
                    "Times-Bold",               ;
                    "Times-Italic",             ;
                    "Times-BoldItalic",         ;
                    "Symbol",                   ;
                    "ZapfDingbats"              ;
                  }

   ::pPdf := HPDF_New()
   ::aPages := {}
   ::AddPage()         // Crea pagina para imprimir

   DEFINE UTILPDF ::oUtil OF Self
   ::cFileName := cFile

RETURN Self

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
   ::GSave()
   HPDF_Page_BeginText( ::Page_Active )

   if !empty( cFont  ) .OR. !empty( nSize )
      ::SetFont( cFont, nSize )
   endif
    if !empty( nAngle  )
       nRad1 := nAngle / 180 * 3.141592 /* Calcurate the radian value. */
       HPDF_Page_SetTextMatrix( ::Page_Active, cos(nRad1), sin(nRad1), -sin(nRad1), cos(nRad1), ::CMS2POINTS( nColCms ), ::GetPageHeight() - ::CMS2POINTS( nRowCms ) )
    else
       HPDF_Page_MoveTextPos(::Page_Active , ::CMS2POINTS( nColCms ), ::GetPageHeight() - ::CMS2POINTS( nRowCms ))
    endif
    HPDF_Page_SetRGBFill( ::Page_Active, nRed, nGreen, nBlue) // 0 ... 1
    HPDF_Page_ShowText(::Page_Active, cText )

  // HPDF_Page_TextOut( ::Page_Active, ::CMS2POINTS( nColCms ), ::GetPageHeight() - ::CMS2POINTS( nRowCms ), cText )

   HPDF_Page_EndText( ::Page_Active )
   ::GRestore()

RETURN NIL

//HPDF_Page_Rectangle( hPage, nX, nY, nWidth, nHeight )
METHOD Rectangle( nTop, nLeft, nBottom, nRight ) CLASS TIMPRIMEPDF
   Local rect := Array( 4 )
   #define rLEFT   1
   #define rTOP    2
   #define rRIGHT  3
   #define rBOTTOM 4

   rect[ rLEFT   ] := ::CMS2POINTS( nLeft )
   rect[ rTOP    ] := ::GetPageHeight() - ::CMS2POINTS( nTop )
   rect[ rRIGHT  ] := ::CMS2POINTS( nRight )
   rect[ rBOTTOM ] := ::GetPageHeight() - ::CMS2POINTS( nBottom )

   HPDF_Page_SetLineCap( ::Page_Active, HPDF_ROUND_END)
   HPDF_Page_Rectangle( ::Page_Active, rect[ rLEFT ], rect[ rBOTTOM ], rect[ rRIGHT ] - rect[ rLEFT ], ;
                                       rect[ rTOP ] - rect[ rBOTTOM ] )

RETURN NIL
*******************************************************************************
METHOD SetFont( cFontName, nSize, cEncoding  ) CLASS TIMPRIMEPDF

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

METHOD __Eject() CLASS TIMPRIMEPDF
     ::AddPage()
RETURN NIL


 ******************************************************************************
 ******************************************************************************
CLASS TUtilPdf

      DATA oPrinter  // Objeto Hairu en el que trabajar
      DATA oBrush    // Brocha a usar la clase por defecto
      DATA oPen      // Lapiz a usar  la clase por defecto
      DATA nColor INIT 0   // Color de la fuente a usar por defecto

      HIDDEN:
      DATA nAnchoFont, nAltoFont,nAnchoPage
      DATA cLongText   // Texto mas largo dentro de un array o Texto pasado. Uso interno
      DATA aAltoFonts  // Alto de las Fuentes del bi-array, para el salto de linea
      DATA nPos        // Posicion de la fuente dentro del array bi que es la mas ancha
      DATA aFonts      // Array con las fuentes a usar desde un fichero externo

      EXPORT:
      METHOD New( oPrinter ) CONSTRUCTOR
      METHOD Text()
      METHOD Box( nArriba, nIzq, nAbajo, nDerecha , oBrush, oPen, lRound, nZ, nZ2 )

END CLASS

METHOD New( oPrinter ) CLASS TUtilPDF
     ::oPrinter := oPrinter
RETURN Self


******************************************************************************
/* Texto en CMS un poco mas elegante de como hasta ahora
   pero con un brush de fondo */
******************************************************************************
METHOD Text( cText,nRow,nCol, cFont, nSize, nRed,nGreen,nBlue,  nAngle ) CLASS TUtilPDF
  local nPad := 0, nAl, aDev, unDefined := 0

  ::oPrinter:CMSAY( nRow, nCol, cText, cFont, nSize, nRed,nGreen,nBlue,  nAngle)

Return Nil

// TODO: Colores de Border
//       Colores de Relleno
METHOD Box( nArriba, nIzq, nAbajo, nDerecha, nWitdh, nRed, nGreen, nBlue ) CLASS TUtilPDF

   DEFAULT nRed TO 0 , nGreen TO 0 , nBlue TO 0

   ::oPrinter:GSave()
   if !empty( nWitdh )
      ::oPrinter:SetLineWidth( nWitdh )
   endif

   ::oPrinter:SetRGBStroke( nRed, nGreen, nBlue)
   ::oPrinter:SetRgbFill( 0 , 1, 0  )  // QUITAR : Pruebas


   ::oPrinter:Rectangle( nArriba, nIzq, nAbajo, nDerecha )

   //HPDF_Page_Stroke( ::Page_Active )                     // Pinta el borde
   //HPDF_Page_Fill( ::Page_Active )                       // Pinta el contenido
   HPDF_Page_FillStroke( ::oPrinter:Page_Active )          // Pinta borde y contenido

   ::oPrinter:GRestore()

Return nil
