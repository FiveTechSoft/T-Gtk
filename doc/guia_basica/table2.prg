#include "gclass.ch"

Function Main()
    Local oWnd, oTable
    DEFINE WINDOW oWnd TITLE "Table"
        DEFINE TABLE oTable ;
                 ROWS 2 COLS 2 ;
                 HOMO ;
                 OF oWnd

         // Arriba a la izquierda
         DEFINE BUTTON PROMPT "Boton 1" OF oTable ;
                 TABLEATTACH 0,1,0,1

         // Abajo a la derecha
         DEFINE BUTTON TEXT "Boton ocupan lo mismo" OF oTable ;
                 TABLEATTACH 1,2,1,2

    ACTIVATE WINDOW oWnd CENTER

Return NIL
