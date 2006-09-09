/* 2 Botones estandar mas el propio .*/
#include "gclass.ch"

Function Main()
         Local oDlg

        DEFINE DIALOG oDlg TITLE "Botones por defecto"

           ADD DIALOG oDlg   ;  /* Dialogo a donde va el boton */
               BUTTON "HOLA"  ;  /* Texto del botón */
               ACTION MsgInfo("Hola","HOLA") /* Accion a ejecutar */

        ACTIVATE DIALOG oDlg CENTER;
                 ON_OK     MsgInfo("ON_OK") ;
                 ON_CLOSE  oDlg:End()
Return NIL
