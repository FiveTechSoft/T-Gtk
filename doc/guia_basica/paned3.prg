#include "gclass.ch"

Function Main()
   Local oWindow, oBox, oPaned
   DEFINE WINDOW oWindow TITLE "Test de Paneles " SIZE 200,200

     DEFINE PANED oPaned OF oWindow VERTICAL
            DEFINE BOX oBox OF oPaned HOMO
            DEFINE LABEL PROMPT "HOLA"           OF oBox
            DEFINE LABEL PROMPT "HOLA tambien"   OF oBox
            DEFINE LABEL PROMPT "HOLA 2" OF oPaned SECOND_PANED

   ACTIVATE WINDOW oWindow

Return NIL
