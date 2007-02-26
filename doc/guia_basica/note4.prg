/* Ejemplo de Notebook */
#include "gclass.ch"

Function Main()
   Local oWnd, oNote, oBox, oBtn, oLabel

   DEFINE WINDOW oWnd TITLE "Mas pestañas" SIZE 300,300

      DEFINE NOTEBOOK oNote OF oWnd CONTAINER ;
         POSITION GTK_POS_RIGHT ;
         ON CHANGE MsgInfo( "Pag. actual: " + cValToChar( oNote:nPageCurrent ),"")


        DEFINE BUTTON oBtn PROMPT "UN BOTON DENTRO" OF oNote ;
               CONTAINER ;
               ACTION MsgInfo( "Esto es tremendo!!"," Sencillo ?" ) ;
               LABELNOTEBOOK "Un boton"

        DEFINE LABEL oLabel PROMPT "ALA!!!" ;
               OF oNote CONTAINER ;
               LABELNOTEBOOK "Label "

        DEFINE BOX oBox OF oNote VERTICAL ;
               LABELNOTEBOOK "AQUI.Cosas"
     
              DEFINE BUTTON oBtn PROMPT "UN BOTON Box" OF oBox
              
              /* Apreciar el uso de EXPAN FILL */
              DEFINE BUTTON oBtn PROMPT "2 BOTON Box " OF oBox  EXPAND FILL

   ACTIVATE WINDOW oWnd CENTER

Return NIL
