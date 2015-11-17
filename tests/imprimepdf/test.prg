/* $Id: test.prg,v 0.2 2015-11-17 16:33:14 riztan Exp $
 * ImprimePDF para Harbour
 * (c)2011 Rafa Carmona
 */ 

#include "hbclass.ch"
#include "harupdf.ch"
#include "common.ch"
#include "tutilpdf.ch"


PROCEDURE Main(  )

   EjemploFacturaPdf()
   EjemploRaw()

RETURN


Function EjemploRaw()
   Local oHaru, nLinea, samp_text, i, oFact
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
                        "Times-BoldItalic"         ;
                      }

   oHaru := TIMPRIMEPDF():New("test.pdf")                                  // Creamos documento

   oHaru:PageSetSize( HPDF_PAGE_SIZE_A4, HPDF_PAGE_LANDSCAPE ) // Page format

   /* Rejilla guia */
   oHaru:Grid()

   oHaru:SetFont( font_list[5], 10)
   nLinea := 1
   oHaru:CmSay( nLinea, 1, "HARBOUR" )

   nLinea += 0.5
   oHaru:SetFont( font_list[5], 12 )
   oHaru:CMSAY( nLinea, 1, "Power!" )

   nLinea += 1
   oHaru:SetFont( font_list[5], 24 )

   oHaru:CMSAY( nLinea, 1, "(c)2011 by Rafa Carmona" )

   UTILPDF oHaru:oUtil BOX 5,5 TO 6,13
   UTILPDF oHaru:oUtil 5, 5 SAY  "IMPRIMEPDF Texto alineado a la derecha." ;
           FONT "Helvetica" SIZE 12  ;
           TO 6,13 ALIGN HPDF_TALIGN_RIGHT

   UTILPDF oHaru:oUtil BOX 6,5 TO 7,13
   UTILPDF oHaru:oUtil 6, 5 SAY  "IMPRIMEPDF Texto alineado a la izquierda." ;
           TO 7, 13 FONT "Helvetica" SIZE 12 COLOR RGB 1,0.25,.5 ;
           ALIGN HPDF_TALIGN_LEFT


   //Second Page
   oHaru:Addpage()                                            // Add page to document
   oHaru:PageSetSize( HPDF_PAGE_SIZE_A4, HPDF_PAGE_PORTRAIT ) // Page format

   nLinea := 1
   FOR i := 1 TO Len( font_list )
      samp_text := "abcdefgABCDEFG12345!#$%&+-@?"
      oHaru:SetFont( font_list[i], 9 )
      oHaru:CMSAY( nLinea, 1, font_list[i] )
      nLinea += 0.6

      oHaru:SetFont( font_list[i], 20 )
      oHaru:CMSAY( nLinea, 1, samp_text  )
      nLinea += 0.6

   NEXT
   oHaru:End( .t. )

Return nil

Function EjemploFacturaPdf()
   Local oFact

   with object oFact := TFacturaPDF():Create()
       :lAlbaran := .F.
       :lCompras := .T.
       :New( "289912" )
       :Print()
       :End( .T. )
   end

return nil

/*********************************************************************
 Ejemplo de impresion de una factura.
 *********************************************************************/
CLASS TFacturaPDF FROM TIMPRIMEPDF

      DATA nEndBody INIT 22           // Limite donde tiene que llegar las lineas de la factura
      DATA lAlbaran INIT .F.           // Albaran  , si es .F., se tratará de una factura
      DATA lCompras INIT .F.           // Albaran de Compra

      DATA lCabecera INIT .T.          // Cabecera en todas las paginas
      DATA lCopia,nVeces               // Si queremos copias
      DATA nCopies INIT 1              // y cuantas copias quiero del original
      DATA nID                         // ID que identifica a un albaran, factura, o compra
      DATA Directory   INIT "./"       // "./pdfs/"

      METHOD Create( ) INLINE Self
      METHOD New( cFile )
      METHOD Print()
      METHOD Body()
      METHOD Plantilla( nLinea )

      METHOD Separator( nSpace, lBody )
      METHOD Headers()
      METHOD Footers() VIRTUAL
      METHOD UnaMas()
      METHOD CompLinea( nSuma )
      METHOD Lineas()             VIRTUAL
      METHOD LineasFac()          VIRTUAL

ENDCLASS

*********************************************************************
METHOD New( nID, cFile, lCopia ) CLASS TFacturaPDF

    DEFAULT lCopia  TO .F.
    ::lCopia := lCopia

    // Si quiero copias , las que quiero mas el original.
    if ::lCopia
       ::nCopies += 1  // ::nCopies + 1 := El + 1 es por el original + nCopies
    endif

    if empty( cFile )
       if ::lAlbaran
          if ::lCompras
             cFile := "Pedido de Compra_"+alltrim( nID ) // Es una compra
          else
             cFile := "Albaran_"+alltrim( nID )
          endif
       else
          cFile := "Factura_"+alltrim( nID )
       endif
    endif

    // TODO: Comprobar directorio que exista
    ::Super:New( ::Directory + cFile +".pdf" )

RETURN Self

*********************************************************************
METHOD Print() CLASS TFacturaPDF

       ::Headers()
       ::Body()
       ::Footers()
       ::UnaMas()  // Datos adjuntos , etc..

RETURN NIL

*********************************************************************
METHOD UnaMas() CLASS TFacturaPDF
*********************************************************************

       ::AddPage()
       ::SetLandScape()
       UTILPDF ::oUtil 1, 1 SAY  "IMPRIMEPDF Que grande que vinistes..." FONT ::aFonts[4] SIZE 34 COLOR RGB 1,0.25,.5

RETURN NIL

*********************************************************************
METHOD Headers() CLASS TFacturaPDF
*********************************************************************

 ::Plantilla( 9 )

 // Poner una imagen. OJO JPEG o PNG, algunos pngs parecen no funcionar.

 if ::lAlbaran
    UTILPDF ::oUtil 1,1.5 IMAGE "./logotipo.png" SIZE 8,5 
 else
    UTILPDF ::oUtil 1,1.5 IMAGE "./logotipo.png" SIZE 8,5 
 endif

 UTILPDF ::oUtil 1.5,16.5 IMAGE "./imageiso.png" SIZE 3,2.1         // IMAGEISO


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

 UTILPDF ::oUtil 7.5,1.5 SAY "NUMERO : "+ "::Codigo"
 UTILPDF ::oUtil 8.0,1.5 SAY "Fecha  : "+ Fecha( Date() )

 if .t. //oClientes:Seek( ::oDbf:Cliente )
    if  .t. // !Empty( oClientes:Provedor )
        UTILPDF ::oUtil 8.5,1.5 SAY "Proveedor Nº: " + "oClientes:Provedor" FONT ::aFonts[6]
    endif
    UTILPDF ::oUtil 5.0,11  SAY "::oDbf:Cliente"  FONT ::aFonts[10] SIZE 10
    UTILPDF ::oUtil 5.5,11  SAY "oClientes:Dom1"  FONT ::aFonts[10] SIZE 10
    UTILPDF ::oUtil 6.0,11  SAY "oClientes:Dom2"  FONT ::aFonts[10] SIZE 10
    UTILPDF ::oUtil 6.5,11  SAY "oClientes:Dom3"  FONT ::aFonts[10] SIZE 10
    UTILPDF ::oUtil 7.0,11  SAY "oClientes:Pro "  FONT ::aFonts[10] SIZE 10

    UTILPDF ::oUtil 7.8,15  SAY "N.I.F/D.N.I: " + "883932B"  FONT ::aFonts[10] SIZE 10
 endif

 if !::lAlbaran  // Si no es un albaran
     UTILPDF ::oUtil 25.5,1.75   SAY "CONTADO"      FONT ::aFonts[10] SIZE 12                //oDbf:Fpago
     UTILPDF ::oUtil 25.5,10.75  SAY DTOC( date() ) FONT ::aFonts[10] SIZE 12                      //oDbf:Vto
     UTILPDF ::oUtil 25.5,13.26  SAY PADR( STR( 12345,10,2 ),10," "  ) FONT ::aFonts[10] SIZE 12   //oDbf:Base
     UTILPDF ::oUtil 25.5,15.20  SAY PADR( STR( 1232,10,2 ), 10," "  ) FONT ::aFonts[10] SIZE 12   //oDbf:Iva
     UTILPDF ::oUtil 25.5,16.90  SAY PADR( STR( 3432312,12,2 ),12," " ) FONT ::aFonts[10] SIZE 12  //oDbf:Total
 endif


RETURN NIL

*********************************************************************
METHOD Body() CLASS TFacturaPDF
*********************************************************************
      Local X, nValue := 10
      Local nRandom

      ::nLinea := 10.5    // Comenzamos de nuevo lineas de albaran

      for x := 1 to 26   // Forzamos unas cuantas lineas para comprobar como se produce saltos de pagina automaticos

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

*********************************************************************
METHOD Plantilla( nLinea ) CLASS TFacturaPDF
*********************************************************************
  Local nFila := 1
  Local cTexto


if ::lAlbaran
   UTILPDF ::oUtil BOX nLinea,1.5 TO nLinea + 1,13.25 FILLRGB 0.4,1,1
else
   UTILPDF ::oUtil BOX nLinea,1.5 TO nLinea + 1,3     FILLRGB 0.4,1,1
   UTILPDF ::oUtil BOX nLinea,3   TO nLinea + 1,13.25 FILLRGB 0.4,1,1
endif

UTILPDF ::oUtil BOX nLinea,13.25 TO nLinea + 1,14.8  FILLRGB 0.4,1,1
UTILPDF ::oUtil BOX nLinea,14.8  TO nLinea + 1,17    FILLRGB 0.4,1,1
UTILPDF ::oUtil BOX nLinea,17    TO nLinea + 1,19.5  FILLRGB 0.4,1,1

if ::lAlbaran
   UTILPDF ::oUtil BOX nLinea+1,1.5 TO 24.0,19.5
else
   UTILPDF ::oUtil BOX nLinea+1,1.5 TO 24.0,19.5
   UTILPDF ::oUtil LINEA nLinea+1,3 TO if(::lAlbaran,26.5,24),3
endif

UTILPDF ::oUtil LINEA nLinea+1,13.25 TO 24,13.25
UTILPDF ::oUtil LINEA nLinea+1,14.8  TO 24,14.8
UTILPDF ::oUtil LINEA nLinea+1,17.0  TO 24,17

nLinea += .25

if ::lAlbaran
   *UTILPRN ::oUtil nLinea + 0.25,1.65  SAY "Pedido"   FONT oFnt
else
   UTILPDF ::oUtil nLinea + 0.25,1.65  SAY "Albaran"  FONT ::aFonts[2] SIZE 9
endif


UTILPDF ::oUtil nLinea + 0.25,5    SAY "Descripcion / Operaciones " FONT ::aFonts[2] SIZE 10
UTILPDF ::oUtil nLinea + 0.25,13.3 SAY "Cantidad"   FONT ::aFonts[2] SIZE 9
UTILPDF ::oUtil nLinea + 0.25,15   SAY "Precio U."  FONT ::aFonts[2] SIZE 9
UTILPDF ::oUtil nLinea + 0.25,17.5 SAY "Totales"    FONT ::aFonts[2] SIZE 10

 IF ::lAlbaran
     cTexto := "Sociedad Inscrita en el Registro Mercantil de Barcelona."+;
               " Tomo XXXX, Folio XXXX, Hoja B 12122, Inscripción 1ª."
     UTILPDF ::oUtil 22,0.5  SAY cTexto FONT ::aFonts[10] SIZE 7 ROTATE 90
     UTILPDF ::oUtil 27.5,1  SAY "A estos precios se ha de sumar el I.V.A"
 ELSE
     cTexto := "Sociedad Inscrita en el Registro Mercantil de Barcelona."+;
               " Tomo XXX, Folio XXXX, Hoja B 112121, Inscripción 1ª."
     UTILPDF ::oUtil 22,0.5  SAY cTexto             FONT ::aFonts[10] SIZE 7 ROTATE 90        // oEmpresa:cPie
     *cTexto := "Sociedad Inscrita en el Registro Mercantil de Barcelona."+;
     *          " Tomo 31279, Folio 209, Hoja B 192886, Inscripción 1ª."
     *UTILPRN ::oUtil 22,0.5  SAY cTexto FONT oFnt2
 ENDIF

 IF !::lAlbaran

    UTILPDF ::oUtil BOX 24.2,1.5  TO 26.5,19.5
    UTILPDF ::oUtil BOX 24.2,1.5  TO 25.0,19.5

    UTILPDF ::oUtil LINEA 24.2,13.25 TO 26.5,13.25
    UTILPDF ::oUtil LINEA 24.2,17    TO 26.5,17

    UTILPDF ::oUtil 24.70,1.75  SAY "Forma de Pago" FONT "Helvetica-Bold" SIZE 10
    UTILPDF ::oUtil 24.70,10.75 SAY "Vencimiento"   FONT "Helvetica-Bold" SIZE 10
    UTILPDF ::oUtil 24.70,13.5  SAY "Base"          FONT "Helvetica-Bold" SIZE 10
    UTILPDF ::oUtil 24.70,15.5  SAY "I.V.A"         FONT "Helvetica-Bold" SIZE 10
    UTILPDF ::oUtil 24.70,17.5  SAY "TOTAL"         FONT "Helvetica-Bold" SIZE 12

 ENDIF

 IF ::lAlbaran .and. ::lCompras
    UTILPDF ::oUtil BOX 24.2,1.5  TO 25.8,10.5
    //UTILPDF ::oUtil 24.5,2.0  SAY "- PLAZO DE ENTREGA : " + Str( ::oDbf:Plazo, 3 ) + " días" FONT oFnt
    UTILPDF ::oUtil 25,2.0  SAY "- PLAZO DE ENTREGA : " + Str( 30, 3 ) + " días"
    UTILPDF ::oUtil 25.5,2.0  SAY "- DEVOLVER COPIA COMO ACUSE DE RECIBO"
 ENDIF


Return nil


**********************************************************************************
**********************************************************************************
METHOD Separator( nSpace, lBody ) CLASS TFacturaPDF

   IF ::nLinea >= ::nEndBody
      ::Eject()
      ::nLinea := 10.5
      ::Headers()
      ::Footers()
   ELSEIF ::Super:Separator( nSpace )
      ::Headers()
      ::Footers()
   ENDIF

  Return NIL

  *******************************************************************************
/* Funcion que nos comprueba si tenemos que realizar una pagina nueva
  nLinea > 26 Si es mayor de 26 cms ( A4 )
  nSuma  := La caja de total tiene el final de linea en la linea 27*/
*******************************************************************************
METHOD CompLinea( nSuma ) CLASS TFACTURAPDF

 DEFAULT nSuma TO 0

 
 IF If( ::lAlbaran,::nLinea >= ( 23.5 + nSuma  ), ::nLinea >=( 23.5 +nSuma ) ) .OR. ::nLinea < 5 // nLinea < 4 para la caja del total
    g_print ( "AAA" )
    ::nLinea := 10.5
    ::AddPage() // Nueva Pagina
    if ::lCabecera   // Si queremos cabecera en todas las paginas
       ::nLinea := 10.5
       ::Headers( )
       ::Footers()
    endif
   return .t.
 ENDIF

Return .F.


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


