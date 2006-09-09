#include "gclass.ch"

Function Main()
         Local oDlg

         DEFINE DIALOG oDlg TITLE "Hola Mundo" SIZE 300,200
         ACTIVATE DIALOG oDlg CENTER;
                  NOSEPARATOR ;
                  RESIZABLE    /* Permitimos redimensionar dialogo */

Return NIL
