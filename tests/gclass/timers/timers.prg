/*
 * $Id: timers.prg,v 1.2 2010-12-23 16:44:22 xthefull Exp $
 * Ejemplo de Timers
 * (C) 2004-05. Rafa Carmona -TheFull-
*/
#include "gclass.ch"
static nStatic := 0

Function Main()
   Local oWindow, oTimer, oSay, oBoxV, oSay2, oTimer2

   DEFINE WINDOW oWindow TITLE "T-GTK Timers " SIZE 500,200

     DEFINE BOX oBoxV OF oWindow HOMO

      DEFINE LABEL oSay TEXT "Time:" OF oBoxV
      DEFINE LABEL oSay2 TEXT "Second Time:" OF oBoxV

      DEFINE TIMER oTimer  ACTION TimerFunc( oSay ) INTERVAL 100
      DEFINE TIMER oTimer2 ACTION TimerFunc( oSay2, "Second" ) INTERVAL 3000

      ACTIVATE TIMER oTimer
      ACTIVATE TIMER oTimer2

   ACTIVATE WINDOW oWindow ;
                   VALID ( oTimer:End(), oTimer2:End(), .T. )

Return NIL

STATIC FUNCTION TimerFunc( oSay , cValue )
     DEFAULT cValue := ""
     
     nStatic++
     oSay:SetText( cValue + " Time: " + Time() + " "+ cValToChar( nStatic ) )

RETURN nil
