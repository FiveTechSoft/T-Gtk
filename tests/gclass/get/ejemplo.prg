#include "gclass.ch"

REQUEST HB_LANG_ES

FUNCTION Main()
   Local cTitle, aValues := {,,,,}
   Local oWnd, oTable, oBox, lAcepta, oBox2

   SET DECI TO 2
   SET DATE FORMAT TO "dd/mm/yyyy"
   SET CENTURY ON
   SET EPOCH TO ( YEAR( DATE() ) - 50 )
   SET Delete On

   HB_LANGSELECT("ES")

     aValues[1] := SPACE( 30 )
     aValues[2] := Date()
     aValues[3] := SPACE( 13 )
     aValues[4] := 0
     aValues[5] := SPACE( 14 )

     cTitle := "Editando Ejemplo...:"

   DEFINE WINDOW oWnd TITLE cTitle // SIZE 300,300
     oWnd:SetBorder( 3 )

//     gtk_window_set_icon(oWnd:pWidget, aAplic[ICONO])

     DEFINE BOX oBox OF oWnd VERTICAL

     // Vamos a usar una tabla ;-)
     DEFINE TABLE oTable ROWS 4 COLS 2 OF oBox
       DEFINE LABEL PROMPT "Nombre" OF oTable TABLEATTACH 0,1,0,1 HALIGN LEFT
       DEFINE LABEL PROMPT "Fec. Nac." OF oTable TABLEATTACH 0,1,1,2 HALIGN LEFT
       DEFINE LABEL PROMPT "CUIT" OF oTable TABLEATTACH 0,1,2,3 HALIGN LEFT
       DEFINE LABEL PROMPT "Sueldo" OF oTable TABLEATTACH 0,1,3,4 HALIGN LEFT
       DEFINE LABEL PROMPT "Observ." OF oTable TABLEATTACH 0,1,4,5 HALIGN LEFT

       DEFINE GET VAR aValues[1] PICTURE Replicate("!",35) OF oTable TABLEATTACH 1,2,0,1
       DEFINE GET VAR aValues[2] PICTURE "@D" OF oTable TABLEATTACH 1,2,1,2
       DEFINE GET VAR aValues[3] PICTURE "@R 99-99999999-9" OF oTable TABLEATTACH 1,2,2,3 VALID ValidCuit( aValues[3] )
       DEFINE GET VAR aValues[4] PICTURE "@E 99,999,999.99" OF oTable TABLEATTACH 1,2,3,4
       DEFINE GET VAR aValues[5] PICTURE Replicate("X",14) OF oTable TABLEATTACH 1,2,4,5

     DEFINE BOX oBox2 OF oBox HOMO
       DEFINE BUTTON PROMPT "Grabar" ACTION ( lAcepta := .t., oWnd:End() ) OF oBox2 EXPAND FILL
       DEFINE BUTTON PROMPT "Salir" ACTION oWnd:End() OF oBox2 EXPAND FILL

  ACTIVATE WINDOW oWnd MODAL CENTER

RETURN NIL
//-------------------------------------------------------------------

FUNCTION CUIT( cuit1 )
Local cuit, Control, n, x
Local XA, XB, XC, XD, XE, XF, XG, XH, XI, XJ

If "-" $ cuit1
 cuit = StrTran(cuit1,"-","")
elseIf "-" $cuit1
 cuit = StrTran(cuit1,"-","")
else
  cuit = cuit1
endif

cuit = Alltrim(cuit)

&&Individualiza y multiplica los dígitos.
XA = Val(SubStr(cuit, 01, 1)) * 5
XB = Val(SubStr(cuit, 02, 1)) * 4
XC = Val(SubStr(cuit, 03, 1)) * 3
XD = Val(SubStr(cuit, 04, 1)) * 2
XE = Val(SubStr(cuit, 05, 1)) * 7
XF = Val(SubStr(cuit, 06, 1)) * 6
XG = Val(SubStr(cuit, 07, 1)) * 5
XH = Val(SubStr(cuit, 08, 1)) * 4
XI = Val(SubStr(cuit, 09, 1)) * 3
XJ = Val(SubStr(cuit, 10, 1)) * 2

&&Suma los resultantes.
x = XA + XB + XC + XD + XE + XF + XG + XH + XI + XJ

&&Calcula el dígito de control.
Control = alltrim(str(Mod((11 - Mod(x,11)), 11)))

n = Control = Right(CUIT, 1)
RETURN n

//-------------------------------------------------------------------

function ValidCuit( cuit )
  Local lDev := .f.

  if Empty(cuit)
    lDev := .t.
  elseif !Cuit(cuit)
    MsgInfo( UTF_8( "    El CUIT ingresado no es"+CRLF+;
                  "      Valido, por fabor"+CRLF+;
                  "controlelo e Ingreselo nuevamente"+CRLF ), "Atencion" )
  else
    lDev := .t.
  endif


Return lDev

