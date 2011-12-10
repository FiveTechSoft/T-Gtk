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
    (c)2007 Federico de Maussion <fj_demaussion@yahoo.com.ar>
*/
#include "gclass.ch"
#include "pc-soft.ch"
#include "fileio.ch"

//-------------------------------------------------

function  Dif_Date( dA, dB )
  Local aFecha := { , , }, nA, nB, nR

  if dA > dB
    nA := dB
    dB := dA
    dA := nA
  end

  nA := ( Year( dA ) * 365 ) + ( Month( dA ) * 30 ) + Day( dA )
  nB := ( Year( dB ) * 365 ) + ( Month( dB ) * 30 ) + Day( dB )
  nR := nB - nA

  aFecha[1] := Abs( nR / 365 )
  nR -= (aFecha[1] * 365)
  aFecha[2] := Abs( nR / 30 )
  nR -= (aFecha[2] * 30)
  aFecha[3] := nR

Return aFecha

//-------------------------------------------------

function  ISNIL( a )
Return  a == Nil

//-------------------------------------------------

function  ISBLOCK( a )
 Return  Valtype(a) == "B"

//-------------------------------------------------

function  ISOBJECT( a )
 Return  Valtype(a) == "O"

//-------------------------------------------------

function nValor( cVal)
  Local nDev
  cVal := Strtran(cVal, ".", "")
  cVal := Strtran(cVal, ",", ".")

 Return Val(cVal)

//-------------------------------------------------

function aCotar(cText)
Local x
Local cDev:="", nLen := 100
for x = 1 to len(cText)
  cDev += SubStr(cText,x,nLen) + CRLF
  x += nLen-1
next

return cDev

//-------------------------------------------------------------------

FUNCTION MyPrint( cFileNamePrint, nPage )

RETURN PdfHelp( cFileNamePrint, nPage )

//-------------------------------------------------------------------

FUNCTION PdfHelp( cFileNamePrint, nPage )
Local oAplic

  if "Linux" $ OS()
    oAplic := GetAplic()
    if nPage == Nil
      winexec( oAplic:cPDF + " " + cFileNamePrint )
    else
      if oAplic:cPDF == "evince"
        winexec( oAplic:cPDF + " --page-index=" + AllTrim( Str( nPage ) ) + " " + cFileNamePrint )
      else
        winexec( oAplic:cPDF + " " + cFileNamePrint + " " + AllTrim( Str( nPage ) ) )
      endif
    endif
  else
    if nPage == Nil
      winexec("FoxitReader.exe "+cFileNamePrint )
    else
      winexec("FoxitReader.exe "+cFileNamePrint + " -n " + AllTrim( Str( nPage ) ) )
    end
  endif

RETURN .t.

//-------------------------------------------------------------------

FUNCTION MyMsg( cLabel, cTite )
   Local lAcceso := .f.
   LOCAL oWnd, oBtnAcep, oBtnCanc
   LOCAL oBoxH,oBoxH2
   LOCAL oBoxV, oImage, oAplic

   oAplic := GetAplic()

   DEFAULT cTite := "InformaciÛn", cLabel := ""

   DEFINE WINDOW oWnd TITLE UTF_8(cTite) //TYPE_HINT 3

  gtk_window_set_icon(oWnd:pWidget, oAplic:oIcon)

     DEFINE BOX oBoxV VERTICAL OF oWnd EXPAND FILL
       DEFINE BOX oBoxH OF oBoxV EXPAND FILL
         DEFINE IMAGE oImage FILE "pixmaps/info.png" OF oBoxH EXPAND FILL
           DEFINE LABEL PROMPT cLabel OF oBoxH EXPAND FILL HALIGN GTK_LEFT

    DEFINE BOX oBoxH2 OF oBoxV HOMO
      DEFINE BUTTON  PROMPT UTF_8(" Si ") of oBoxH2 ACTION (lAcceso := .t., oWnd:END()) EXPAND FILL
      DEFINE BUTTON  PROMPT " No " of oBoxH2 ACTION oWnd:END() EXPAND FILL

   ACTIVATE WINDOW oWnd CENTER MODAL

RETURN lAcceso

//-------------------------------------------------

FUNCTION MyInfo( cLabel, cTite )
   Local lAcceso := .f.
   LOCAL oWnd, oBtnAcep, oBtnCanc
   LOCAL oBoxH,oBoxH2
   LOCAL oBoxV, oImage, oAplic

   oAplic := GetAplic()

   DEFAULT cTite := "InformaciÛn", cLabel := ""

   DEFINE WINDOW oWnd TITLE UTF_8(cTite) //TYPE_HINT 3

  gtk_window_set_icon(oWnd:pWidget, oAplic:oIcon)

     DEFINE BOX oBoxV VERTICAL OF oWnd EXPAND FILL
       DEFINE BOX oBoxH OF oBoxV EXPAND FILL
         DEFINE IMAGE oImage FILE "pixmaps/info.png" OF oBoxH EXPAND FILL
           DEFINE LABEL PROMPT cLabel OF oBoxH EXPAND FILL HALIGN GTK_LEFT

      DEFINE BUTTON  PROMPT " Aceptar " of oBoxV ACTION oWnd:END() //EXPAND FILL

   ACTIVATE WINDOW oWnd CENTER MODAL

RETURN lAcceso

//-------------------------------------------------------------------

FUNCTION CUIT( cuit1 )
Local cuit, x
Local dig_resu1, oper1
Local aCUIT := { 5, 4, 3, 2, 7, 6, 5, 4, 3, 2 }

If "-" $ cuit1
 cuit = StrTran(cuit1,"-","")
elseIf "/" $ cuit1
 cuit = StrTran(cuit1,"/","")
else
  cuit = cuit1
endif

cuit = Alltrim(cuit)
// el par·metro d_cuit es el CUIT, alfanum., sin los guiones )
dig_resu1 := oper1 := 0

&&Individualiza y multiplica los dÌgitos.
FOR x := 1 To 10
oper1 := Val( Substr( cuit, x, 1 ) )
dig_resu1 += oper1 * aCUIT[ x ]
NEXT

&&Calcula el dÌgito de control.
dig_resu1 = alltrim(str(Mod((11 - Mod(dig_resu1,11)), 11)))

RETURN ( dig_resu1 = Right(cuit, 1) )

//-------------------------------------------------------------------

function ValidCuit( cuit )
  Local lDev := .f.
//     MyInfo("  Cuit : "+cuit ,"Alerta")

  if Empty(cuit)
    lDev := .t.
  elseif !Cuit(cuit)
    MyInfo( UTF_8( "    El CUIT ingresado no es"+CRLF+;
                  "      Valido, por fabor"+CRLF+;
                  "controlelo e Ingreselo nuevamente"+CRLF ), "Atencion" )
  else
    lDev := .t.
  endif


Return lDev

//-------------------------------------------------------------------


/*
*
* Metodo estatico para generar un CUIT/CUIL.
*
* @param dniInt DNI como numerico
* @param xyChar Sexo de la persona como Charater.
* Masculino: m - Femenino: f - Para Personas Juridicas: cualquier otro caracter
*
* @return El CUIT/CUIL como Charater
*
*/

Function Cuit_Cuil( ndni, cSexo)
  Local xyStc

  if Upper(cSexo) == 'F'
    xyStc := 27
  elseif Upper(cSexo) == 'M'
    xyStc := 20
  else
    xyStc := 30
  end

return calcular(xyStc, ndni)

//-------------------------------------------------------------------
/*
*
* Metodo privado que calcula el CUIT/CUIL
*
*/

static function calcular(xyStc, dniStc)
  local tmp1, tmp2, digitoStc, i
  local acum := 0
  local n := 2
  Local dig_resu1, oper1, cuit, x
  Local aCUIT := { 5, 4, 3, 2, 7, 6, 5, 4, 3, 2 }

  cuit := Str(xyStc,2)+StrZero(dniStc,8)
// el par·metro d_cuit es el CUIT, alfanum., sin los guiones )
dig_resu1 := oper1 := 0

&&Individualiza y multiplica los dÌgitos.
FOR x := 1 To 10
oper1 := Val( Substr( cuit, x, 1 ) )
dig_resu1 += oper1 * aCUIT[ x ]
NEXT

n := IF( dig_resu1 % 11 = 0, 0, 11 - ( dig_resu1 % 11 ) )

//  n = Mod((11 - Mod(dig_resu1,11)), 11)

  if n > 9
    if xyStc == 20
      xyStc = 23
      digitoStc = 9
    elseif  xyStc == 27
      xyStc = 23
     digitoStc = 4
    else
      xyStc = 33
      digitoStc = 9
    end
  else
    digitoStc = n
  end

Return Str(xyStc,2) + StrZero(dniStc,8) + Str(digitoStc,1)
//Return Str(xyStc,2) + "-" + StrZero(dniStc,8) + "-" + Str(digitoStc,1);

//-------------------------------------------------------------------

FUNCTION Is_Iso( cChar )
   Local x
   Local aIso := {"·","È","Ì","Û","˙","‡","Ë","Ï","Ú","˘","¸","Ò",;
                  "¡","…","Õ","”","⁄","¿","»","Ã","“","Ÿ","‹","—","∫","™"}

/*   Local aIso := {"·","È","Ì","Û","˙","‡","Ë","Ï","Ú","˘","‰","Î","Ô",;
                  "ˆ","¸","‚","Í","Ó","Ù","˚","„","ı","Ò","Á","¡","…",;
                  "Õ","”","⁄","¿","»","Ã","“","Ÿ","ƒ","À","œ","÷","‹",;
                  "¬"," ","Œ","‘","€","√","’","—","«"}
*/

   for x = 1 to Len( aIso )
      aIso[x] := UTF_8(aIso[x])
   next

   for x = 1 to Len( aIso )
      if aIso[x] $ cChar
        Return .f.
      endif
   next

Return .t.


//-------------------------------------------------------------------

FUNCTION Is_Utf_8( cChar )
   Local x
   Local aIso := {"·","È","Ì","Û","˙","‡","Ë","Ï","Ú","˘","¸","Ò",;
                  "¡","…","Õ","”","⁄","¿","»","Ã","“","Ÿ","‹","—","∫","™"}

/*   Local aIso := {"·","È","Ì","Û","˙","‡","Ë","Ï","Ú","˘","‰","Î","Ô",;
                  "ˆ","¸","‚","Í","Ó","Ù","˚","„","ı","Ò","Á","¡","…",;
                  "Õ","”","⁄","¿","»","Ã","“","Ÿ","ƒ","À","œ","÷","‹",;
                  "¬"," ","Œ","‘","€","√","’","—","«"}
*/
   for x = 1 to Len( aIso )
      if aIso[x] $ cChar
        Return .f.
      endif
   next

Return .t.

//-------------------------------------------------------------------
/*
FUNCTION MyUpper( cChar )
   Local cDev := ""
   Local x, nAt, cLetra

   for x = 1 to Len( cChar )
      cLetra := Substr(cChar,x,1)
      nAt := AT( cLetra, "abcdefghijklmnopqrstuvwxyz·ÈÌÛ˙‡ËÏÚ˘‰ÎÔˆ¸‚ÍÓÙ˚„ıÒÁ" )
      if nAt > 0
        cDev += SubStr("ABCDEFGHIJKLMNOPQRSTUVWXYZ¡…Õ”⁄¿»Ã“ŸƒÀœ÷‹¬ Œ‘€√’—«",nAt,1)
      else
        cDev += cLetra
      endif
   next

Return cDev
*/
//-------------------------------------------------------------------

FUNCTION iso( xCad )
   Local x

   if Valtype(xCad) == "A"
     for x = 1 to Len( xCad )
       if Valtype(xCad[x]) $ "CM"
         if !Is_Iso( xCad[x] )
           xCad[x] := _Utf_8( xCad[x] )
         end
       end
     next
   elseif Valtype(xCad) $ "CM"
     if !Is_Iso( xCad )
       xCad := _Utf_8( xCad )
     end
   end

Return xCad

//-------------------------------------------------------------------

FUNCTION Utf( xCad )
   Local x

   if Valtype(xCad) == "A"
     for x = 1 to Len( xCad )
       if Valtype(xCad[x]) $ "CM"
         if !Is_Utf_8( xCad[x] )
           xCad[x] := Utf_8( xCad[x] )
         end
       elseif Valtype(xCad[x]) $ "A"
         xCad[x] := Utf( xCad[x] )
       end
     next
   elseif Valtype(xCad) $ "CM"
     if !Is_Utf_8( xCad )
       xCad := Utf_8( xCad )
     end
   end

Return xCad

//-------------------------------------------------------------------
Function FileCopy(cSource, cDest, lMode)

  Local nDestHand
  Local cBuffer   := Space(512)
  Local lDone     := .F.
  Local nSrcBytes, nDestBytes, nTotBytes := 0
  Local lStillOpen, nSrcHand

  lStillOpen := .F.
  cSource  := cSource

  nSrcHand := fOpen(cSource, FO_READ)

  if nSrcHand <= 0
    cSource := _Utf_8(cSource)
    nSrcHand := fOpen(cSource, FO_READ)
  end

  if nSrcHand > 0

   nDestHand := fCreate(cDest)

     if nDestHand > 0
       Do while ! lDone
         nSrcBytes  := fRead(nSrcHand, @cBuffer, 512)
         nDestBytes := fWrite(nDestHand, cBuffer, nSrcBytes)
         if nDestBytes < nSrcBytes
           lStillOpen := .T.
           lDone      := .T.
         else
           lDone := (nSrcBytes == 0)
         endif
         nTotBytes += nDestBytes
       Enddo
       fClose(nSrcHand)
       fClose(nDestHand)
     else
       fClose(nSrcHand)
     end
  else
    MyMsg( _UTF_8( cSource  ), UTF_8("Error") )
  endif
Return(nTotBytes)


//-------------------------------------------------------------------
Function My_inkey( nSec)
 Local h := Seconds()
 do while (Seconds()-h < nSec)
   SysRefresh()
 end

return nil

//-------------------------------------------------------------------

FUNCTION Literal( Total1 )
Local Long,val1,val2,val3,val4,x1x2x3,x2x3,x4x5,x1,x2,x3,x4,x5,conta1
Local letra,letra1,parte2,parte3,parte4,parte5,parteA,Y,parteC
Local totalX,totalA,total2,total3,n, p
local unidad, decena, dece1, dece2, cond, ciento
****************
*
* GENERA EL JORNAL EN LETRAS
* la variable que recibe del prog. principal es total1(numerica)
* la variable que entrega la subrut. es letra(string)

*declaracion de variables de memoria*

STORE "             uno          dos          tres         cuatro       cinco        "+;
      "seis         siete        ocho         nueve        " TO unidad

STORE "             diez         veinte       treinta      cuarenta     cincuenta    "+;
      "sesenta      setenta      ochenta      noventa      " TO decena

STORE "             once         doce         trece        catorce      quince       "+;
      "dieciseis    diecisiete   dieciocho    diecinueve   " TO dece1

STORE "             veintiuno    veintidos    veintitres   veinticuatro veinticinco  "+;
      "veintiseis   veintisiete  veintiocho   veintinueve  " TO dece2

STORE "             ciento                                              quinientos   "+;
      "             setecientos               novecientos  " TO ciento
* C/periodo tiene una longitud de 13 caracteres*

* Calculo que transforma una exp. numerica en exp. literal*

STORE " " TO val1,val2,val3,val4
STORE  0  TO x1x2x3,x2x3,x4x5,x1,x2,x3,x4,x5,conta1
STORE " " TO letra,letra1,parte2,parte3,parte4,parte5
STORE " " TO parteA,Y,parteC
*
totalX = STR(INT(total1))
totalA = LTRIM(totalX)
long = LEN(totalA)
total2 = (REPLICATE("0",9 - long)) + totalA
total3 = RIGHT(STR(total1,12,2),2)
n = 13
*
val1 = SUBSTR(total2,1,1)+SUBSTR(total2,2,1)+SUBSTR(total2,3,1)
val2 = SUBSTR(total2,4,1)+SUBSTR(total2,5,1)+SUBSTR(total2,6,1)
val3 = SUBSTR(total2,7,1)+SUBSTR(total2,8,1)+SUBSTR(total2,9,1)
val4 = SUBSTR(total3,1,1)+SUBSTR(total3,2,1)
*
DO CASE
   CASE VAL(val1) <> 0
        cond = 3
   CASE VAL(val2) <> 0
        cond = 2
   OTHERWISE
        cond = 1
ENDCASE
*
p = 1
DO WHILE p <= cond
   DO CASE
      CASE p = 3
           x1x2x3 = INT(VAL(val1))
           x2x3 = INT(VAL(SUBSTR(val1,2,2)))
           x1 = INT(VAL(SUBSTR(val1,1,1)))
           x2 = INT(VAL(SUBSTR(val1,2,1)))
           x3 = INT(VAL(SUBSTR(val1,3,1)))
*
      CASE p = 2
           x1x2x3 = INT(VAL(val2))
           x2x3 = INT(VAL(SUBSTR(val2,2,2)))
           x1 = INT(VAL(SUBSTR(val2,1,1)))
           x2 = INT(VAL(SUBSTR(val2,2,1)))
           x3 = INT(VAL(SUBSTR(val2,3,1)))
*
      CASE p = 1
           x1x2x3 = INT(VAL(val3))
           x1 = INT(VAL(SUBSTR(val3,1,1)))
           x2 = INT(VAL(SUBSTR(val3,2,1)))
           x3 = INT(VAL(SUBSTR(val3,3,1)))
           x4x5 = INT(VAL(val4))
           x4 = INT(VAL(SUBSTR(val4,1,1)))
           x5 = INT(VAL(SUBSTR(val4,2,1)))
   ENDCASE
*
   IF x1x2x3 <> 0
      DO CASE
         CASE x1x2x3 = 100
              parteA = "CIEN"
         CASE x1 = 1 .OR. x1 = 5 .OR. x1 = 7 .OR. x1 = 9
              parteA = RTRIM(SUBSTR(ciento,n*x1,n))
         CASE x1 = 2 .OR. x1 = 3 .OR. x1 = 4 .OR. x1 = 6 .OR. x1 = 8
              parteA = RTRIM(SUBSTR(unidad,n*x1,n)) + "CIENTOS"
         CASE x1 = 0
              parteA = " "
      ENDCASE
*
      DO CASE
         CASE x2>=3 .AND. x3<>0
              parte2=parteA+RTRIM(SUBSTR(decena,n*x2,n))+" Y"+RTRIM(SUBSTR(unidad,n*x3,n))
         CASE x2<>0 .AND. x3=0
              parte2=parteA+RTRIM(SUBSTR(decena,n*x2,n))
         CASE x2=2 .AND. x3<>0
              parte2=parteA+RTRIM(SUBSTR(dece2,n*x3,n))
         CASE x2=1 .AND. x3<>0
              parte2=parteA+RTRIM(SUBSTR(dece1,n*x3,n))
         CASE x2=0 .AND. X3<>0
              parte2=parteA+RTRIM(SUBSTR(unidad,n*x3,n))
         CASE x2=0 .AND. x3=0
              parte2=parteA
      ENDCASE
      IF p>1  .AND. x3=1 .AND. x2x3<>11
         Y=RTRIM(LTRIM(parte2))
         parteC =SUBSTR(Y,1,LEN(Y)-1)
      ENDIF
   ENDIF
   IF p=1
      DO CASE
         CASE VAL(val3)<>0 .AND. x4x5 <> 0
              letra1=TRIM(parte2)+" CON "+RTRIM(total3)+"/100 cents. "
         CASE VAL(val3)<>0 .AND. x4x5=0
              letra1=LTRIM(parte2)
         CASE VAL(val3)=0 .AND. x4x5 <> 0
              letra1= " CON "+RTRIM(total3)+"/100 cents. "
         CASE VAL(val3)=0 .AND. x4x5 = 0
              letra1=parte2
      ENDCASE
   ENDIF
*
   IF p=2
      DO CASE
         CASE x3=1 .AND. x2x3<>11
              parte4=parteC+" MIL "
         CASE x1x2x3<>0
              parte4=LTRIM(TRIM(parte2))+" MIL "
         CASE x1x2x3=0
             parte4=" "
      ENDCASE
   ENDIF
 *
   IF p=3
      DO CASE
         CASE x1=0 .AND. x2=0 .AND. x3=1
              parte5="UN MILLON "
         CASE x3=1 .AND. x2x3<>11
              parte5=parteC+" MILLONES "
         CASE x1x2x3<>0
              parte5=LTRIM(TRIM(parte2))+" MILLONES "
         CASE x1x2x3=0
              parte5=" "
      ENDCASE
   ENDIF
*
   DO CASE
      CASE cond=1
           letra = IIF(VAL(val3) >=1 ,UPPER(letra1),UPPER(SUBSTR(letra1,6,LEN(letra1)-6)))
      CASE cond=2
           letra = UPPER(parte4+LTRIM(letra1))
      CASE cond=3
           letra = UPPER(parte5+LTRIM(parte4)+LTRIM(letra1))
   ENDCASE
   parte2 = " "
   parteC = " "
   Y = " "
   p = p + 1
ENDDO WHILE
RETURN( letra )


//-------------------------------------------------------------------

//-------------------------------------------------------------------


//-------------------------------------------------------------------


//-------------------------------------------------------------------

#pragma BEGINDUMP

#include <gtk/gtk.h>
#include "hbapi.h"

#if defined(HB_OS_WIN_32)
#include <Windows.h>
#endif

HB_FUNC( MYWINEXEC )
{
#if defined(HB_OS_WIN_32)
   WORD wMode = hb_pcount() > 1 ? hb_parni( 2 ) : 2;

   hb_retl( WinExec( hb_parc( 1 ), wMode ) );
#endif
}

//-------------------------------------------------------------------

HB_FUNC ( SELECDIR )
{
    GtkWidget *pFileSelection;
    //GtkWidget *pDialog;
    gchar *cFolder;

    cFolder =  hb_parc( 1 );

    /* CreaciÛn de la ventana de selecciÛn */

    pFileSelection = gtk_file_chooser_dialog_new("Seleccionar Directorio",
                                      NULL,
                                      GTK_FILE_CHOOSER_ACTION_SELECT_FOLDER,
                                      GTK_STOCK_CANCEL, GTK_RESPONSE_CANCEL,
                                      GTK_STOCK_OPEN, GTK_RESPONSE_ACCEPT,
                                      NULL);
    /* seleccionar Directrio por Defecto */
    gtk_file_chooser_set_current_folder( GTK_FILE_CHOOSER(pFileSelection), cFolder ) ;
    /* Limitar las acciones a esta ventana */
    gtk_window_set_modal(GTK_WINDOW(pFileSelection), TRUE);

        if (gtk_dialog_run (GTK_DIALOG (pFileSelection)) == GTK_RESPONSE_ACCEPT)
          {
            char *filename;

            filename = gtk_file_chooser_get_filename (GTK_FILE_CHOOSER (pFileSelection));
            hb_retc( filename );
            g_free( filename );
          }

    gtk_widget_destroy( pFileSelection );
}

//-------------------------------------------------------------------
//-------------------------------------------------------------------


#pragma ENDDUMP
//-------------------------------------------------------------------
