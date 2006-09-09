#include "gclass.ch"

Function Main()
   Local oWindow, oBox, oPaned, oPaned2
   DEFINE WINDOW oWindow TITLE "Test de Paneles " SIZE 200,200

     DEFINE PANED oPaned OF oWindow VERTICAL
            DEFINE PANED oPaned2 OF oPaned
                 DEFINE BUTTON PROMPT "Boton 1" OF oPaned2
                 DEFINE BUTTON PROMPT "Boton 2" OF oPaned2 SECOND_PANED
            DEFINE LABEL PROMPT "HOLA 2" OF oPaned SECOND_PANED

   ACTIVATE WINDOW oWindow

Return NIL
