/* Ejemplo de frame*/
#include "gclass.ch"

Function Main()
   Local oWnd, oFrame, oBox
   DEFINE WINDOW oWnd TITLE "Test de Frame " SIZE 400,400
      DEFINE BOX oBox OF oWnd VERTICAL HOMO

          DEFINE FRAME oFrame OF oBox EXPAND FILL ;
                  TEXT "Frame Shadow In" ;
                  SHADOW GTK_SHADOW_IN

          DEFINE FRAME oFrame OF oBox EXPAND FILL ;
                  TEXT "Frame Shadow Out";
                  SHADOW GTK_SHADOW_OUT

          DEFINE FRAME oFrame OF oBox EXPAND FILL ;
                  TEXT "Frame Shadow Etched in" ;
                  SHADOW GTK_SHADOW_ETCHED_IN

          DEFINE FRAME oFrame OF oBox EXPAND FILL ;
                  TEXT "Frame Shadow Etched out" ;
                  SHADOW GTK_SHADOW_ETCHED_OUT

   ACTIVATE WINDOW oWnd CENTER


Return NIL
