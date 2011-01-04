/*
 * $Id: splash.prg,v 1.1 2006-09-21 10:02:54 xthefull Exp $
 * Ejemplo de un Splash Screen
 * (C) 2005. Rafa Carmona -TheFull-
*/
#include "gclass.ch"

Function Main()
    Local oWindow

     DEFINE WINDOW oWindow TITLE "T-GTK Splash Screen" SIZE 500,200

        Splash_Screen( ,6 )

        DEFINE IMAGE FILE "../../images/GMOORK.gif" OF oWindow CONTAINER

     ACTIVATE WINDOW oWindow INITIATE CENTER

Return NIL

FUNCTION Splash_screen( cImage, nSeconds )
  Local oWnd, oTimer, oImage, oBox,oBoxH

  DEFAULT cImage :=  "../../images/flacoygordo.gif",;
          nSeconds :=  5

   nSeconds *= 1000

  DEFINE WINDOW oWnd

     oWnd:Size( 0, 0 )          // Se calculará el tamaño segun los widgets que metamos despues
     oWnd:SetDecorated( .F. )   // No queremos que nos muestre la ventana.
     oWnd:SetSkipTaskBar( .T. ) // No queremos que salga en la barra de tareas

     DEFINE BOX oBox VERTICAL OF oWnd
            DEFINE IMAGE oImage FILE cImage OF oBox FILL EXPAND
            DEFINE BOX oBoxH OF oBox
               DEFINE LABEL PROMPT "<b>The</b> power of <b>T-Gtk </b>" OF oBoxH MARKUP EXPAND
               DEFINE IMAGE FILE "../../images/rafa2.jpg" OF oBoxH

     DEFINE TIMER oTimer ;
            ACTION End_Splah( oWnd , oTimer ) ;
            INTERVAL nSeconds

     ACTIVATE TIMER oTimer

     SysRefresh()

  ACTIVATE WINDOW oWnd INITIATE CENTER VALID ( oTimer:End() , .T. )

RETURN NIL

STATIC FUNCTION End_Splah( oWnd, oTimer )
     oTimer:End()
     oWnd:End()
Return nil
