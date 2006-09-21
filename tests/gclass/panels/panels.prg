/*
 * $Id: panels.prg,v 1.1 2006-09-21 10:00:47 xthefull Exp $
 * Ejemplo de Panels ( Splitters )
 * Porting Harbour to GTK+ power !
 * (C) 2004-05. Rafa Carmona -TheFull-
*/

#include "gclass.ch"

Function Main()
    Local oWindow, oBtn, oBox, oPaned, cCombo := "1", oBook

    DEFINE WINDOW oWindow TITLE "Test de Paneles " SIZE 300,300
       DEFINE PANED oPaned OF oWindow EXPAND FILL CUTTERPOS 40

         DEFINE BOX oBox VERTICAL OF oPaned
           DEFINE BUTTON oBtn TEXT "Pulsa" ACTION MsgInfo("Hola","Hola") OF oBox EXPAND FILL
           DEFINE BUTTON oBtn TEXT "Otro boton" ACTION MsgAlert("Hola","Otro boton") OF oBox

         DEFINE NOTEBOOK oBook OF oPaned SECOND_PANED 
           DEFINE IMAGE FILE "../../images/glade.png" LABELNOTEBOOK "Text" OF oBook
           DEFINE BOX oBox VERTICAL LABELNOTEBOOK "Box " OF oBook


        DEFINE PANED oPaned OF oBox EXPAND FILL CUTTERPOS 150
           DEFINE BUTTON oBtn TEXT "1"   ACTION MsgStop("Hola","Holas") RESIZE OF oPaned
        
        DEFINE BOX oBox VERTICAL OF oPaned SHRINK SECOND_PANED 
           DEFINE BUTTON oBtn TEXT "2.1"   ACTION MsgStop("Hola","Holas") OF oBox
           DEFINE BUTTON oBtn TEXT "2.2"   ACTION MsgInfo("Hola","Holas") EXPAND FILL OF oBox

   ACTIVATE WINDOW oWindow
Return NIL

