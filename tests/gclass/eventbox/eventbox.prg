/**
 * Example EventBox background color and Label
 **/
 
#include "gclass.ch"

function main()

  Local oWnd, oBox, oEventBox, oLabel, oFont

  DEFINE WINDOW oWnd TITLE "Event Box Example" 
     
     DEFINE FONT oFont NAME "Arial 28"
      
     DEFINE BOX oBox VERTICAL OF oWnd
        DEFINE EVENTBOX oEventBox OF oBox EXPAND FILL
        oEventBox:Style( "black", BGCOLOR, STATE_NORMAL ) 
         
        /*Use clausule CONTAINER for PUT widget in EventBox */
        DEFINE LABEL oLabel PROMPT "Ohh!! Is Label in EventBox"  OF oEventBox CONTAINER FONT oFont 
        oLabel:Style( "green", FGCOLOR, STATE_NORMAL ) 

   ACTIVATE WINDOW oWnd CENTER 
   

return nil

