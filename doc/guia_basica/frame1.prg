/* Ejemplo de frame*/
#include "gclass.ch"

Function Main()
   Local oWnd, oFrame
   DEFINE WINDOW oWnd TITLE "Test de Frame " SIZE 200,200
     DEFINE FRAME oFrame OF oWnd CONTAINER ;
            TEXT "Frame"
   ACTIVATE WINDOW oWnd


Return NIL
