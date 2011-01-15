/* Dialogos MODAL y NOMODAL
   Guia basica de T-Gtk
  (c)2005 Rafa Carmona*/

#include "gclass.ch"

Function Main()
   Local oWnd, oBtn,oBox

    DEFINE WINDOW oWnd TITLE "Hola Mundo Dialogos Modales/NOModales."
           DEFINE BOX oBox VERTICAL OF oWnd
              DEFINE BUTTON oBtn TEXT "MODAL" ;
                     ACTION Modal_yes() OF oBox
              DEFINE BUTTON oBtn TEXT "NO MODAL" ;
                     ACTION Modal_no() OF oBox
    ACTIVATE WINDOW oWnd

Return NIL

Static Function Modal_Yes()
   Local oWndModal
      DEFINE DIALOG oWndModal TITLE "Soy Modal" SIZE 100,100
      ACTIVATE DIALOG oWndModal
Return nil

Static Function Modal_NO()
   Local oWndModal
      DEFINE DIALOG oWndModal TITLE "SOY NOMODAL" SIZE 100,100
      ACTIVATE DIALOG oWndModal NOMODAL
Return nil
