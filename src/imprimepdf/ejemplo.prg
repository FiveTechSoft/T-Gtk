// T:\harboursvn\contrib\hbhpdf\tests>t:\harboursvn\bin\win\bcc\hbmk2.exe ejemplo.prg -w1
#include "hbclass.ch"
#include "harupdf.ch"
#include "common.ch"
#include "tutilpdf.ch"

PROCEDURE Main(  )

   EjemploFacturaPdf()

RETURN

Function EjemploRaw()
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

   oHairu := TIMPRIMEPDf():New()                                  // Creamos documento

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

Return nil

Function EjemploFacturaPdf()
   Local oFact

   oFact := TFacturaPDF():New( "factura.pdf" )
   oFact:Print()
   oFact:End( .T. )


return nil

/*
 Ejemplo de impresion de una factura.
 */

CLASS TFacturaPDF FROM TIMPRIMEPDF
      DATA nEndBody INIT 22   // Limite donde tiene que llegar las lineas de la factura
      DATA lAlbaran INIT .T.

      METHOD New( cFile ) INLINE Super:New( cFile )
      METHOD Print()
      METHOD Body()
      METHOD Separator( nSpace, lBody )
      METHOD Headers()
      METHOD Footers() VIRTUAL
      METHOD UnaMas()

ENDCLASS

METHOD Print() CLASS TFacturaPDF

       ::Headers()
       ::Body()
       ::Footers()

       ::UnaMas()


RETURN NIL

METHOD UnaMas() CLASS TFacturaPDF

       ::AddPage()
       ::SetLandScape()
       UTILPDF ::oUtil 1, 1 SAY  "IMPRIMEPDF Que grande que vinistes..." FONT ::aFonts[4] SIZE 34 COLOR RGB 1,0.25,.5

RETURN NIL

METHOD Headers() CLASS TFacturaPDF

        // Poner una imagen. OJO JPEG o PNG, algunos pngs parecen no funcionar.
//       ::oUtil:SayBitmap( 0, 0, cImagePath+"gmoork.jpeg" )
//       ::oUtil:SayBitmap( 3, 2, cImagePath+"basn2c16.png" )
 /*
 if ::lAlbaran
    UTILPDF ::oUtil 2,1.5 IMAGE oEmpresa:cLogoAlb SIZE 8,5 JPG
 else
    UTILPDF ::oUtil 2,1.5 IMAGE oEmpresa:cLogoFact SIZE 8,5 JPG
 endif
  */

 UTILPDF ::oUtil LINEA 4.064,10.54 TO 4.064,11.00

 UTILPDF ::oUtil LINEA 4.064,10.54 TO 4.464,10.54

 UTILPDF ::oUtil LINEA 4.064,19.04 TO 4.064,19.50  // up der hor
 UTILPDF ::oUtil LINEA 4.064,19.50 TO 4.464,19.50  // up der vert

 UTILPDF ::oUtil LINEA 8.428,10.54 TO 8.428,11.00
 UTILPDF ::oUtil LINEA 8.028,10.54 TO 8.428,10.54

 UTILPDF ::oUtil LINEA 8.428,19.04 TO 8.428,19.50
 UTILPDF ::oUtil LINEA 8.028,19.50 TO 8.428,19.50

 IF ::lAlbaran        //2.2
     UTILPDF ::oUtil 7.0,1.5   SAY "ALBARAN" FONT ::aFonts[2] SIZE 15
 ELSE
     UTILPDF ::oUtil 7.0,1.5   SAY "FACTURA"
 ENDIF
 /*
 UTILPDF ::oUtil 7.5,1.5 SAY "NUMERO : "+ "::oDbf:Codigo"
 UTILPDF ::oUtil 8.0,1.5 SAY "Fecha: "+ "Fecha( ::oDbf:Fecha )"
 */


 /*
  if oClientes:Seek( ::oDbf:Cliente )
     if !Empty( oClientes:Provedor )
         UTILPRN ::oUtil 8.5,1.5 SAY "Proveedor Nº: " + oClientes:Provedor FONT oFnt4
     endif
     UTILPRN ::oUtil 5.0,11  SAY ::oDbf:Cliente   FONT oFnt4
     UTILPRN ::oUtil 5.5,11  SAY oClientes:Dom1 FONT oFnt4
     UTILPRN ::oUtil 6.0,11  SAY oClientes:Dom2 FONT oFnt4
     UTILPRN ::oUtil 6.5,11  SAY oClientes:Dom3 FONT oFnt4
     UTILPRN ::oUtil 7.0,11  SAY oClientes:Pro  FONT oFnt4

     UTILPRN ::oUtil 7.8,16  SAY "N.I.F/D.N.I: " + oClientes:Cif  FONT oFont
    endif

 if !::lAlbaran  // Si no es un albaran
     UTILPRN ::oUtil 25.5,1.75   SAY ::oDbf:Fpago  FONT oFnt4
     UTILPRN ::oUtil 25.5,10.75  SAY DTOC( ::oDbf:Vto ) FONT oFnt4
     UTILPRN ::oUtil 25.5,13.26  SAY PADR( STR( ::oDbf:Base,10,2 ),10," "  ) FONT ::oFnt
     UTILPRN ::oUtil 25.5,15.20  SAY PADR( STR( ::oDbf:Iva,10,2 ), 10," "  ) FONT ::oFnt
     UTILPRN ::oUtil 25.5,16.90  SAY PADR( STR( ::oDbf:Total,12,2 ),12," " ) FONT oFnt4
 endif
  */

/*
    EJEMPLO
       UTILPDF ::oUtil BOX 1,10 TO 6, 20
       UTILPDF ::oUtil 1.5, 11 SAY  "Nombre:"    ;  UTILPDF ::oUtil 1.5, 15 SAY  "El primer cliente" FONT ::aFonts[2] SIZE 10
       UTILPDF ::oUtil 2.5, 11 SAY  "Dirección:" ;  UTILPDF ::oUtil 2.5, 15 SAY  "No Importa"        FONT ::aFonts[2] SIZE 10
       UTILPDF ::oUtil 3.5, 11 SAY  "Provincia:" ;  UTILPDF ::oUtil 3.5, 15 SAY  "Barcelona"         FONT ::aFonts[2] SIZE 10
       UTILPDF ::oUtil 4.5, 11 SAY  "Ciudad:"    ;  UTILPDF ::oUtil 4.5, 15 SAY  "Bigues i Riells"   FONT ::aFonts[2] SIZE 10
       UTILPDF ::oUtil 5.5, 11 SAY  "Pais:"      ;  UTILPDF ::oUtil 5.5, 15 SAY  "El mundo mundial"  FONT ::aFonts[2] SIZE 10



       UTILPDF ::oUtil ;
               BOX 7,0.75 TO 8, 4.25 ;
               STROKE SIZE 2 COLOR 0,0,1 ;
               FILLRGB 0,0.85,0

       UTILPDF ::oUtil 7.75, 1 SAY  "Numero Albaran"

       UTILPDF ::oUtil BOX 7, 4.25 TO 8, 15 ;
                STROKE SIZE 2 ;
                FILLRGB 0.5,.8,.8
       UTILPDF ::oUtil 7.75, 6.5 SAY  "Concepto" FONT ::aFonts[2] SIZE 15

       UTILPDF ::oUtil BOX 7, 15.1 TO 8, 21 ;
                STROKE SIZE 5 COLOR 0,.8,1;

       UTILPDF ::oUtil 7.75, 17 SAY  "Tiempo" FONT "Times-BoldItalic" SIZE 14 COLOR RGB 1,0,0

*/
RETURN NIL

METHOD Body() CLASS TFacturaPDF
      Local X, nValue := 10
      Local nRandom

      ::nLinea := 10.5 // Comenzamos de nuevo lineas de albaran

      for x := 1 to 2

          UTILPDF ::oUtil Self:nLinea, 1.5 SAY "1233231" FONT ::aFonts[3] SIZE 10
          if mod( nValue, 2 ) = 0
             nvalue := 15
          else
              nvalue := 10
          endif
          nRandom := int( HB_Random(1,14) )
          UTILPDF ::oUtil Self:nLinea, 4.35 SAY  "Conceptos:"+ Alltrim( Str( ::nLinea ) ) FONT ::aFonts[nRandom] SIZE nValue

          UTILPDF ::oUtil Self:nLinea, 17.2 SAY Time() FONT ::aFonts[4] SIZE 12

          ISEPARATOR

      next


RETURN Nil

**********************************************************************************
**********************************************************************************
METHOD Separator( nSpace, lBody ) CLASS TFacturaPDF

   IF ::nLinea >= ::nEndBody
      ::Eject()
      ::nLinea := 9   // En cuerpo empieza en los 9 cms
      ::Headers()
      ::Footers()
   ELSEIF Super:Separator( nSpace )
       ::Headers()
       ::Footers()
   ENDIF

Return NIL


/* Fecha en Spanish para clipper 5.3 English */
Static Func Fecha( dDate )
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
ENDCASE
Return ( Str(Day(dDate),2)+"  "+ cMes +"  del  "+Str(Year(dDate),4) )


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

    METHOD GSave()    INLINE  HPDF_Page_GSave( ::Page_Active )      /* Save the current graphic state */
    METHOD GRestore() INLINE  HPDF_Page_GRestore( ::Page_Active )   /* Restore graphic state */

    METHOD LoadImagePng( cFileImage ) INLINE HPDF_LoadPngImageFromFile( ::pPdf, cFileImage )
    METHOD LoadImageJpg( cFileImage ) INLINE HPDF_LoadJpegImageFromFile( ::pPdf, cFileImage )
    METHOD ImageGetWidth( pImage )  INLINE HPDF_Image_GetWidth( pImage )
    METHOD ImageGetHeight( pImage ) INLINE HPDF_Image_GetHeight( pImage )
    METHOD DrawImage( pImage, x, y, nWidth, nHeight )
    METHOD UseUTF() INLINE HPDF_UseUTFEncodings( ::pPdf )
    METHOD Line( nTop, nLeft, nBottom, nRight, nWitdh, nRed, nGreen, nBlue )


END CLASS

METHOD New( cFile ) CLASS TIMPRIMEPDF
   ::aFonts  := { ;
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


   ::pPdf := HPDF_New()
   ::aPages := {}
   ::AddPage()         // Crea pagina para imprimir

   DEFINE UTILPDF ::oUtil OF Self
   ::cFileName := cFile
   ::UseUTF()

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

   //DEFAULT cEncoding  TO ::cEncoding

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
      METHOD SayBitmap( cFileImage, x, y, nWidth, nHeight )
      METHOD Linea( nArriba, nIzq, nAbajo, nDerecha )

END CLASS

METHOD New( oPrinter ) CLASS TUtilPDF
     ::oPrinter := oPrinter
RETURN Self


******************************************************************************
******************************************************************************
METHOD Text( cText,nRow,nCol, cFont, nSize, nRed,nGreen,nBlue,  nAngle ) CLASS TUtilPDF
  local nPad := 0, nAl, aDev, unDefined := 0

  ::oPrinter:CMSAY( nRow, nCol, cText, cFont, nSize, nRed, nGreen, nBlue, nAngle )

Return Nil

******************************************************************************
******************************************************************************
METHOD Box( nArriba, nIzq, nAbajo, nDerecha, nWitdh, lStroke, nRed, nGreen, nBlue, lFill, nRed2, nGreen2, nBlue2 ) CLASS TUtilPDF

   DEFAULT nRed  TO 0 , nGreen  TO 0 , nBlue  TO 0,;
           nRed2 TO 1 , nGreen2 TO 1 , nBlue2 TO 1


   ::oPrinter:GSave()
   if !empty( nWitdh )
      ::oPrinter:SetLineWidth( nWitdh )
   endif

   ::oPrinter:SetRGBStroke( nRed, nGreen, nBlue )
   ::oPrinter:SetRgbFill( nRed2 , nGreen2, nBlue2  )

   ::oPrinter:Rectangle( nArriba, nIzq, nAbajo, nDerecha )

   ::oPrinter:PageFillStroke( ) // Pinta borde y contenido

   ::oPrinter:GRestore()

Return nil

******************************************************************************
******************************************************************************
METHOD SayBitmap( x, y, cFileImage, nWidth, nHeight ) CLASS TUtilPDF
   Local pImage

    if "png" $ cFileImage
      pImage := ::oPrinter:LoadImagePng( cFileImage )
    else
      pImage := ::oPrinter:LoadImageJpg( cFileImage )
    endif

   if !empty( pImage )
       ::oPrinter:DrawImage( pImage, x, y, nWidth, nHeight )
   endif

RETURN NIL

******************************************************************************
/* Dibujando Lineas con el Pen que tenemos o el pasado */
******************************************************************************
METHOD Linea( nArriba, nIzq, nAbajo, nDerecha, nWidth, nRed, nGreen, nBlue ) CLASS TUtilPDF
   DEFAULT nRed  TO 0 , nGreen  TO 0 , nBlue  TO 0

   ::oPrinter:GSave()

   if !empty( nWidth )
      ::oPrinter:SetLineWidth( nWidth )
   endif
   ::oPrinter:SetRGBStroke( nRed, nGreen, nBlue )
   ::oPrinter:Line( nArriba, nIzq, nAbajo, nDerecha, nWidth, nRed, nGreen, nBlue )

   ::oPrinter:GRestore()

return NIL
