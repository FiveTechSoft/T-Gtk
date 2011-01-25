/*
 * $Id:  $
 * Ejemplo de Spinner
 * (C) 2011 Rafa Carmona
*/
#include "gclass.ch"

Function Main()
   Local oWnd, oBox, oSpinner, oBtnStart, oBtn
   
   DEFINE WINDOW oWnd TITLE "T-GTK Spinner" SIZE 300,300
      DEFINE BOX oBox OF oWnd VERTICAL SPACING 1
         DEFINE BUTTON PROMPT "Start" ACTION oSpinner:Start() OF oBox 
         DEFINE BUTTON PROMPT "Stop"  ACTION oSpinner:Stop()  OF oBox 
         DEFINE SPINNER oSpinner START EXPAND FILL OF oBOX
         
  ACTIVATE WINDOW oWnd CENTER 

Return NIL
