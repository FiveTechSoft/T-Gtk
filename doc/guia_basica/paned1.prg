#include "gclass.ch"

Function Main()
   Local oWindow,oPaned
   DEFINE WINDOW oWindow TITLE "Test de Paneles " SIZE 200,200

     DEFINE PANED oPaned OF oWindow
            DEFINE LABEL PROMPT "HOLA"   OF oPaned
            DEFINE LABEL PROMPT "HOLA 2" OF oPaned SECOND_PANED

   ACTIVATE WINDOW oWindow

Return NIL
