/* Todos los botones puestos.*/
#include "gclass.ch"

Function Main()
         Local oDlg

        DEFINE DIALOG oDlg TITLE "Botones por defecto"
        ACTIVATE DIALOG oDlg CENTER;
                 ON_YES    MsgInfo("ON_YES");
                 ON_NO     MsgInfo("ON_NO") ;
                 ON_OK     MsgInfo("ON_OK") ;
                 ON_CANCEL MsgInfo("ON_CANCEL");
                 ON_CLOSE  MsgInfo("ON_CLOSE");
                 ON_APPLY  MsgInfo("ON_APPLY");
                 ON_HELP   MsgInfo("ON_HELP")
Return NIL
