/* Ejemplo de frame*/
#include "gclass.ch"

Function Main()
   Local oWnd, oFrame
   DEFINE WINDOW oWnd TITLE "Test de Frame " SIZE 200,200
     DEFINE FRAME oFrame OF oWnd CONTAINER ;
            TEXT "Frame centrado" ;
            SHADOW GTK_SHADOW_ETCHED_OUT ;
            ALIGN 0.5, 0.5
   ACTIVATE WINDOW oWnd

Return NIL
