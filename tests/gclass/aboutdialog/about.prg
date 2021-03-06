/*
 * $Id: about.prg,v 1.4 2006-10-05 15:22:18 xthefull Exp $
*/
#include "gclass.ch"

Function Main()
    Local oWnd, oAbout , oBox
     
    DEFINE WINDOW oWnd TITLE "Esta es mi abotu" 
         DEFINE BOX oBox OF oWnd
           
           DEFINE BUTTON PROMPT "About.." OF oBox ;
                 ACTION ( oAbout := gAboutDialog():New( "My Aplication", "1.1"  )  )
           
           DEFINE BUTTON PROMPT "About Glade " OF oBox ;
                 ACTION About_Glade()
           
           DEFINE BUTTON PROMPT "About Artists.. " OF oBox ;
                 ACTION About_Artists()

    ACTIVATE WINDOW oWnd CENTER
    
Return NIL

STATIC FUNCTION About_Glade()
   Local cGlade
   
   SET RESOURCES cGlade FROM FILE "example.glade" ROOT "about1"
   DEFINE ABOUT CENTER ID "about1" RESOURCE cGlade


RETURN NIL

STATIC FUNCTION About_Artists( )
   Local oImage
   
   DEFINE IMAGE oImage FILE "../../images/gnu-keys.png" LOAD

   DEFINE ABOUT ;
          NAME "Aplication arts" ;
          VERSION "2.0" ;
          ARTISTS { "Rafa", "Joaquim", "Ruth", "Ana" } ;
          DOCUMENTERS { "Jose", "Walter", "Antonio" }  ;
          AUTHORS { "Daniel", "Sarah","Miguel" }      ;
          LOGO oImage ;
          CENTER 

RETURN NIL
