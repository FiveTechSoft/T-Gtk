#include "gclass.ch"

Function Main()
    Local oWnd, oBtn

    DEFINE WINDOW oWnd TITLE "Dialog 9"
           DEFINE BUTTON oBtn TEXT "Create Dialog" OF oWnd CONTAINER ;
                  ACTION  CreateDialog()
    ACTIVATE WINDOW oWnd

RETURN NIL

Function CreateDialog()
    Local oDlg

    DEFINE DIALOG oDlg TITLE "NOS PARAMOS"

           ADD DIALOG oDlg   ;  /* Dialogo a donde va el boton */
               BUTTON "HOLA"  ;  /* Texto del bot�n */
               ACTION oDlg:End() /* Accion a ejecutar */

    ACTIVATE DIALOG oDlg RUN ;
             ON_CANCEL .T.               

    DO CASE
       CASE oDlg:nId == -6  // CANCELAMOS
             MsgInfo( "Atencion, que cancelamos")
       CASE oDlg:nId == 1 //Primer button introducido con ADD BUTTON
            MsgInfo( "Presionastes tu propio boton" )
    ENDCASE

    g_print( "Esto continua cuando se haya destruido el dialogo")

return nil
