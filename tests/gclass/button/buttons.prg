/*
 * $Id: buttons.prg,v 1.1 2006-09-16 20:12:01 xthefull Exp $
 * Ejemplo de las posibilidades de los botones.
 * (C) 2004-05. Rafa Carmona -TheFull-
*/
#include "gclass.ch"

Function Main()
   Local oWnd, oBox,oBtn,oBoxV, oFont, oAccel, oBtn2, oBtn_Gordo
   Local aStyleChild := { { "yellow", FGCOLOR  , STATE_NORMAL },;
                          { "red"  ,  FGCOLOR  , STATE_PRELIGHT } }
   Local aStyle := { { "red"    , BGCOLOR , STATE_NORMAL },;
                     { "yellow" , BGCOLOR , STATE_PRELIGHT },;
                     { "white"  , FGCOLOR , STATE_NORMAL } } 


   DEFINE FONT oFont NAME "Arial italic 14"

   DEFINE WINDOW oWnd TITLE "T-GTK Buttons" 
      DEFINE BOX oBox OF oWnd VERTICAL SPACING 1
         DEFINE BUTTON PROMPT "Text"  OF oBox 
         DEFINE BUTTON PROMPT "Text with Font" FONT oFont OF oBox
         DEFINE BUTTON oBtn PROMPT "_Text with Style" OF oBox MNEMONIC ;
                FONT oFont ;
                STYLE aStyle

         DEFINE BUTTON oBtn PROMPT "_Text with Style Child" OF oBox MNEMONIC ;
                FONT oFont ;
                STYLE_CHILD aStyleChild
         
         DEFINE BUTTON OF oBox FROM STOCK GTK_STOCK_DIALOG_INFO
         
         /* Jugando a crear botones personalizados*/
         DEFINE BUTTON oBtn2 OF oBox ACTION MsgInfo( "Ohhh!!! T-gtk Power","Information" )
            DEFINE BOX oBoxV OF oBtn2 VERTICAL CONTAINER 
                DEFINE IMAGE FILE "../../images/rafa2.jpg" OF oBoxV 
                DEFINE LABEL PROMPT "<b>The</b> power of <b>T-Gtk </b>" OF oBoxV MARKUP EXPAND FILL

         DEFINE BUTTON oBtn OF oBox EXPAND FILL 
            DEFINE BOX oBoxV OF oBtn CONTAINER 
                DEFINE IMAGE FILE "../../images/Anieyes.gif" OF oBoxV 
                DEFINE LABEL PROMPT "<b>The</b> power of <b>T-Gtk </b>" ;
                       OF oBoxV MARKUP EXPAND FILL ;
                       VALIGN TOP ;
                       HALIGN RIGHT 

         DEFINE BUTTON oBtn_Gordo OF oBox ACTION MsgAlert( "OJO...a el gordo...","alerta" )
                DEFINE IMAGE FILE "../../images/flacoygordo.gif" OF oBtn_Gordo CONTAINER

         // Vamos a definir 2 teclas de aceleracion F2 y SHIFT_F2
         DEFINE ACCEL_GROUP oAccel OF oWnd
             ADD ACCELGROUP oAccel OF oBtn2      SIGNAL "clicked"  KEY "F2"
             ADD ACCELGROUP oAccel OF oBtn_Gordo SIGNAL "clicked"  KEY "F2" MODE GDK_SHIFT_MASK

  ACTIVATE WINDOW oWnd CENTER 


Return NIL

