#include "gclass.ch"

Function Main()
    Local oWnd, oBtn

    DEFINE WINDOW oWnd TITLE "Dialog 8"
           DEFINE BUTTON oBtn TEXT "Create Dialog" OF oWnd CONTAINER ;
                  ACTION  CreateDialog()
    ACTIVATE WINDOW oWnd

RETURN NIL

Function CreateDialog()
    Local oDlg

    DEFINE DIALOG oDlg TITLE "NO PARA EL FLUJO DE EJECUCION" SIZE 200,200
    ACTIVATE DIALOG oDlg // Eso NO PARA EL FLUJO DE EJECUCION
    g_print( "Esto continua sin que hayamos destruido el dialogo")

return nil
