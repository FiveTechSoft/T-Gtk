/* $Id: tutilpdf.prg,v 0.1 2015-11-09 11:56:21 riztan Exp $*/
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
      METHOD Box( nArriba, nIzq, nAbajo, nDerecha )
      METHOD SayImage( cFileImage, x, y, nWidth, nHeight , ljpg ,lPage )
      METHOD Linea( nArriba, nIzq, nAbajo, nDerecha )
      METHOD BoxMsg( )

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
METHOD SayImage( x, y, nWidth, nHeight, cFileImage, ljpg ,lPage ) CLASS TUtilPDF
   Local pImage

    lJpg := iif( (".jpeg" $ cFileImage .or. ".jpg" $ cFileImage ), .T., .F. )

    if lJpg
      pImage := ::oPrinter:LoadImageJpg( cFileImage )
    else
      pImage := ::oPrinter:LoadImagePng( cFileImage )
    endif

    if (lPage)
       nWidth  := ::oPrinter:POINTS2CMS( ::oPrinter:GetPageWidth()  )- 0.5
       nHeight := ::oPrinter:POINTS2CMS( ::oPrinter:GetPageHeight() )- 0.5
       x := 0.25
       y := 0.25
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


******************************************************************************
* Caja de Textos.
* beta:
*   nMode pasa a lTitle para titulo centrado en la hoja.
*   nMode se convierte para align sobre el Box
* Debemos de escoger la fuente que tenemos y dejarla como estaba
* ya que GetTextWidth() la deja selecciona atraves de SetFont, y
* nos interesa que el comando SELEC siga con la fuente que le dijimos
******************************************************************************

METHOD BoxMsg( nArriba, nIzq, nAbajo, nDerecha ,oBrush, oPen,lRound,nZ,nZ2,;
               cText, nRow,nCol,oFont, nClrText,nBkMode ,;
               nAlto, nAncho ,lShadow,nShadow, oBrushShadow,;
               oPenShadow ,lTitle,cPad,lNoBox, nSize ) CLASS TUtilPdf

  Local lEndBrush := .F.
  Local lEndPen   := .F.
  Local aDev,nMode
  Local nLinesArray := 1

  ::cLongText := cText    // Cadena de texto mas grande dentro del array. Por defecto el texto pasado
                          // Si es un array dimensional , ya se recalculara de nuevo
  ::aAltoFonts := {}
  ::nAnchoFont := 0
  ::nAltoFont  := 0
  ::nPos := 0

  DEFAULT nShadow TO 0.25,; // Cantidad de Sombra cms
          nCol TO 0      ,;
          nRow TO 0      ,;
          nAncho TO .5   ,;
          nAlto  TO .5   ,;
          lTitle TO .F. ,;
          oFont  TO ::oPrinter:Font_Active,; // Fuente Activa
          lShadow TO .F.,;
          lNoBox TO .F.

 IF cPad == "LEFT"          ; nMode := HPDF_TALIGN_LEFT
    ELSEIF cPad == "RIGHT"  ; nMode := HPDF_TALIGN_RIGHT
    ELSEIF cPad == "CENTER" .OR. cPad == "CENTERED" ; nMode := HPDF_TALIGN_CENTER
    ELSE
       nMode := HPDF_TALIGN_CENTER
 ENDIF

  ::nAnchoPage :=  ::oPrinter:Points2Cms( ::oPrinter:GetPageWidth() ) / 10 //Dimensiones fisicas en Cms

  ::nAnchoFont := ::oPrinter:GetFontSize() / 10               // Esta en m/m , pasamos a cms
  ::nAltoFont  := ::oPrinter:GetFontSize() / 10

  if lTitle // Centro.Calculamos la nueva posicion de la columna
       nCol := ( ::nAnchoPage / 2 ) - ( ::nAnchoFont / 2 ) // La mitad de todo ;)
  endif

  if lShadow


//METHOD Box( nArriba, nIzq, nAbajo, nDerecha, nWitdh, lStroke, nRed, nGreen, nBlue, lFill, nRed2, nGreen2, nBlue2 ) CLASS TUtilPDF

     if ( Empty( cText ) ) .OR. nArriba # NIL   //Solamente una Caja
        ::Box( nArriba+nShadow-nAlto,;
               nIzq+nShadow-nAncho,;
               nAbajo+nShadow+nAlto,;
               nDerecha+nShadow+nAncho  )
     else
        ::Box( nRow+nShadow-nAlto,;
               nCol+nShadow-nAncho,;
               nRow+::nAltoFont+nShadow+nAlto,;
               nCol+::nAnchoFont+nShadow+nAncho  )
     endif

  endif

  if ( Empty( cText ) ) .OR. nArriba # NIL  // Solamente una caja
     ::Box( nArriba - nAlto,;
            nIzq - nAncho,;
            nAbajo + nAlto,;
            nDerecha+ nAncho )
  else

      if !lNoBox
       ::Box( nRow - nAlto,;
            nCol - nAncho,;
            nRow+::nAltoFont+nAlto,;
            nCol+::nAnchoFont+nAncho  )
      endif

      IF VALTYPE( cText ) == "A"
         ::TextLines( cText,nRow,nCol,oFont,nClrText,;
                      nBkMode,nLinesArray, nMode, nAncho, lTitle )
      ELSE
         // Alineacion dentro de la Caja de Mensaje
         DO CASE
            CASE nMode == 0  // Left
                 nCol -=  nAncho - 0.1
            CASE nMode == 1 // Right
                 nCol +=  nAncho - 0.1
         END CASE
         //TODO: Falta pasar tamaño fuente y color

            DEFAULT nArriba to nRow - nAlto
            DEFAULT nIzq    to nCol - nAncho
            DEFAULT nAbajo  to nRow+::nAltoFont+nAlto
            DEFAULT nDerecha to nCol+::nAnchoFont+nAncho 
           ::oPrinter:CMSAYRECT( nRow, nCol, cText, oFont, 15, 0,0, 0, 0, nArriba, nIzq, nAbajo, nDerecha, nMode )

      ENDIF

  endif

RETURN NIL
