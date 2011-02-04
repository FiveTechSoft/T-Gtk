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

        oEventBox:AddEvents("button-press-mask")
        gtk_signal_connect( oEventBox:pWidget, "button-press-event", { ||evento() } )
   ACTIVATE WINDOW oWnd CENTER


return nil

function evento()
  msgInfo( "HOLA / HELLO")
return nil

