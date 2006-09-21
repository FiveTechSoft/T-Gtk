#include "gclass.ch"
#include "vte.ch"

Function Main()
   Local oWnd, oTerminal, oTable, oFont
   
   DEFINE FONT oFont NAME "Arial italic 10"

   DEFINE WINDOW oWnd TITLE "Terminal for T-Gtk"  SIZE 400,400
       
       DEFINE TABLE oTable ;
                 ROWS 2 COLS 2;
                 OF oWnd;
         
         DEFINE IMAGE FILE "../../images/rafa2.jpg" OF oTable ;
                TABLEATTACH 0,1,0,1,0,0

         DEFINE TERMINAL oTerminal OF oTable ;
                FONT oFont ;
                TABLEATTACH 1,2,1,2 
         
         oTerminal:Console() 
         oTerminal:Transparent( .T. ) 
         
   ACTIVATE WINDOW oWnd CENTER 


Return NIL
