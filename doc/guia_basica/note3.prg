/* Ejemplo de Notebook */
#include "gclass.ch"

Function Main()
   Local oWnd, oNote, oBox

   DEFINE WINDOW oWnd TITLE "Ejemplo de Notebook a la derecha" SIZE 300,300

      DEFINE NOTEBOOK oNote OF oWnd CONTAINER ;
             POSITION GTK_POS_RIGHT

            DEFINE BOX oBox OF oNote ;
                LABELNOTEBOOK "Etiqueta del notebook"


   ACTIVATE WINDOW oWnd CENTER

Return NIL
