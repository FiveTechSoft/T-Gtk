/*
 * $Id: testprinter.prg,v 1.1 2006-09-21 10:00:47 xthefull Exp $
 * Ejemplo de impresion bajo Gnu/Linux
 * Porting Harbour to GTK+ power !
 * (C) 2004-05. Rafa Carmona -TheFull-
*/
#include "gclass.ch"

Function Main()
    Local oPrn,oWnd,oBtn

    DEFINE WINDOW oWnd

           DEFINE BUTTON oBtn ;
                  TEXT "IMPRIMIR" ;
                  ACTION PrintMe();
                  OF oWnd CONTAINER

    ACTIVATE WINDOW oWnd CENTER

RETURN NIL

Function PrintMe()
         Local oPrn := gPrinter():New( "Nombre_Printer", .T., .F., 1, "hoa" )

         if !oPrn:lCancel
             oPrn:StartPage()
             oPrn:Say( 190, 150, "One" )
             oPrn:Say( 150, 150, "Two" )
             oPrn:Say( 170, 150, "Three" )
             oPrn:EndPage()

             oPrn:End()
          else
              ? "Se cancela impresion"
          endif
        MsgInfo( "Se termino impresion" )
Return NIL
