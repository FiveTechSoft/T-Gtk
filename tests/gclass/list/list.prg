/*
 * $Id: list.prg,v 1.1 2006-09-21 09:59:22 xthefull Exp $
 * Ejemplo de List simples ( GTK+-2.0 )
 * Porting Harbour to GTK+ power !
 * (C) 2004-05. Rafa Carmona -TheFull-
*/

#include "gclass.ch"

Function Main()
    Local oWindow, oBtn, oBox, cList := "Esto es texto", oList

    DEFINE WINDOW oWindow TITLE "T-Gtk.Ejemplo de Listas simples." SIZE 200,200

     DEFINE BOX oBox VERTICAL OF oWindow
      DEFINE BUTTON oBtn TEXT "Value of VAR cList" ;
             ACTION MsgInfo( cValtoChar( cList )+ ":"+ Valtype(cList),"Valor de cList:Tipo" ) ;
             OF oBox

      DEFINE LIST oList VAR cList ITEMS { 123, "Esto es texto", 3 }  OF oBox

    ACTIVATE WINDOW oWindow

Return NIL

