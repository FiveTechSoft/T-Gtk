#include "gclass.ch"

Function main()
  Local oWnd, oBox, oTable, oBtn, oExpand
  Local cText := '<span foreground="red" background="black"><b><i>T-Gtk power!!</i></b> </span>'

  DEFINE WINDOW oWnd TITLE "Table"

         DEFINE TABLE oTable ;
                 ROWS 3 COLS 4 ;
                 HOMO ;
                 OF oWnd;

         // Arriba a la izquierda
         DEFINE BUTTON PROMPT "Boton 1" OF oTable ;
                 TABLEATTACH 0,1,0,1

         // Arriba a la derecha
         DEFINE BUTTON TEXT "Boton 2" OF oTable ;
                 TABLEATTACH 3,4,0,2

         // La parte de abajo , entera
         DEFINE IMAGE FILE "../../images/Anieyes.gif" OF oTable ;
                TABLEATTACH 0,2,1,2

         DEFINE LABEL PROMPT cText OF oTable ;
                TABLEATTACH 2,3,1,2 MARKUP FILL EXPAND

         DEFINE BOX oBox OF oTable VERTICAL ;
                TABLEATTACH 2,3,2,4

                DEFINE EXPANDER oExpand LABEL "Expander" OF oBox
                      DEFINE TOGGLE oBtn TEXT "Toggle" OF oExpand CONTAINER

                DEFINE BUTTON TEXT "BotonBox" OF oBox FILL EXPAND

   ACTIVATE WINDOW oWnd CENTER

return nil

