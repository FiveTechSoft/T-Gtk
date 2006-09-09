/* Ventana MODAL y NOMODAL
   Guia b?sica de T-Gtk
   (c)2005 Rafa Carmona*/

#include "gclass.ch"

Function Main()
   Local oWnd, oBtn

    DEFINE WINDOW oWnd TITLE "Hola Mundo"
           DEFINE BOX oBox VERTICAL OF oWnd
              DEFINE BUTTON oBtn TEXT "MODAL" ;
                     ACTION Modal_yes() OF oBox
              DEFINE BUTTON oBtn TEXT "NO MODAL" ;
                     ACTION Modal_no() OF oBox
    ACTIVATE WINDOW oWnd

Return NIL

Static Function Modal_Yes()
   Local oWndModal
      DEFINE WINDOW oWndModal TITLE "Soy Modal"
      ACTIVATE WINDOW oWndModal MODAL
Return nil

Static Function Modal_NO()
   Local oWndModal
      DEFINE WINDOW oWndModal TITLE "SOY NOMODAL"
      ACTIVATE WINDOW oWndModal
Return nil