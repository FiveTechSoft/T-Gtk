#include "gclass.ch"

Function Main()
    Local oWnd, oTable
    DEFINE WINDOW oWnd TITLE "Table"
        DEFINE TABLE oTable ;
                 ROWS 2 COLS 2 ;
                 OF oWnd
         // Arriba a la izquierda
         DEFINE BUTTON PROMPT "Boton 1" OF oTable ;
                 TABLEATTACH 0,1,0,1
         // Arriba a la derecha
         DEFINE BUTTON TEXT "Boton 2, como 2" OF oTable ;
                 TABLEATTACH 1,2,0,1
         // La parte de abajo , entera
         DEFINE BUTTON TEXT "BOTON ENTERO" OF oTable ;
                TABLEATTACH 0,2,1,2

    ACTIVATE WINDOW oWnd

Return NIL
