/*
 * $Id: about.prg,v 1.1 2006-09-22 19:43:53 xthefull Exp $
*/
#include "gclass.ch"

Function Main()
     Local oWnd
     
     DEFINE WINDOW oWnd TITLE "Esta es mi abotu" 
        
         DEFINE BOX oBox OF oWnd VERTICAL 
        
           DEFINE BUTTON PROMPT "About....." OF oBox ;
                 ACTION gAboutDialog():New( "My Aplication", "1.1", .T. )
           
           DEFINE BUTTON PROMPT "About from Glade " OF oBox ;
                 ACTION About_Glade()

    ACTIVATE WINDOW oWnd

Return NIL

STATIC FUNCTION About_Glade()
   Local cGlade
   
   SET RESOURCES cGlade FROM FILE "example.glade" ROOT "about1"
   
   DEFINE ABOUT ID "about1" RESOURCE cGlade


RETURN NIL
