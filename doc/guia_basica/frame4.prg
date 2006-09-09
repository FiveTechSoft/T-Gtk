/* Ejemplo de frame*/
#include "gclass.ch"

Function Main()
   Local oWnd, oFrame, oLabel
   Local cText := '<span foreground="blue" size="large"><b>Frame rigth <span foreground="red"'+;
                ' size="xx-large" ><i>bonito!!!!</i></span></b></span>'

   DEFINE WINDOW oWnd TITLE "Test de Frame Label " SIZE 300,300
     DEFINE LABEL oLabel PROMPT cText MARKUP
     DEFINE FRAME oFrame OF oWnd CONTAINER ;
            LABEL oLabel ;
            SHADOW GTK_SHADOW_ETCHED_OUT ;
            ALIGN 1, 0.5
   ACTIVATE WINDOW oWnd

Return NIL
