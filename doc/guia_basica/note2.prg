/* Ejemplo de Notebook */
#include "gclass.ch"

Function Main()
   Local oWnd, oNote, oBox, oBoxNote

   DEFINE WINDOW oWnd TITLE "Ejemplo de Notebook" SIZE 300,300

      DEFINE BOX oBox OF oWnd
			     DEFINE NOTEBOOK oNote OF oBox EXPAND FILL
 					    DEFINE BOX oBoxNote OF oNote ;
                    LABELNOTEBOOK "Etiqueta del notebook"

   ACTIVATE WINDOW oWnd CENTER

Return NIL
