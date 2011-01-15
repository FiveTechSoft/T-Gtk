/* Ejemplo de Notebook */
#include "gclass.ch"

Function Main()
   Local oWnd, oNote, oBox, oLabel
   Local cText := '<span foreground="blue" size="large"><b>Esto es <span foreground="red"'+;
                ' size="xx-large" ><i>bonito!</i></span></b>!!!!</span>'


   DEFINE WINDOW oWnd TITLE "Bonita etiqueta.Notebook" SIZE 100,100
       DEFINE LABEL oLabel PROMPT cText MARKUP
       DEFINE NOTEBOOK oNote OF oWnd CONTAINER
              DEFINE BOX oBox OF oNote ;
                    LABELNOTEBOOK oLabel
              DEFINE BOX oBox OF oNote ;
                    LABELNOTEBOOK "Sin duda"

   ACTIVATE WINDOW oWnd CENTER

Return NIL
