/* Ejemplo de fixed */
#include "gclass.ch"

Function Main()
   Local oWnd, oFixed

   DEFINE WINDOW oWnd TITLE "Coordenadas Absolutas " SIZE 300,300
       DEFINE FIXED oFixed OF oWnd
          DEFINE LABEL TEXT "MI LABEL EN 10,10" POS 10,10 OF oFixed
          DEFINE LABEL TEXT "MI LABEL EN 10,30" POS 10,30 OF oFixed
          DEFINE BUTTON PROMPT "BOTON 50,100" POS 50,100 OF oFixed
          DEFINE IMAGE FILE "anieyes.gif" POS 10,130 OF oFixed

   ACTIVATE WINDOW oWnd

Return NIL
