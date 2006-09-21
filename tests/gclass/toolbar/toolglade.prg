/*
 * $Id: toolglade.prg,v 1.1 2006-09-21 10:05:13 xthefull Exp $
 * Ejemplo de Toolbars y Menus directamente de Glade
 * Porting Harbour to GTK+ power !
 * (C) 2004-05. Rafa Carmona -TheFull-
*/
#include "gclass.ch"

Function Main()
    Local oWindow, oToolBar, oMenu, cGlade
    
     SET RESOURCES cGlade FROM FILE "example.glade"

     DEFINE WINDOW oWindow ID "window1" RESOURCE cGlade
     
         DEFINE MENU oMenu ID "menu1" RESOURCE cGlade
         DEFINE MENUITEM ACTION MsgInfo("desde glade" ) ID "item1" RESOURCE cGlade
         DEFINE MENUITEM ACTION MsgInfo("Uff..connect bank" ) ID "item2" RESOURCE cGlade
         DEFINE MENUITEM ACTION MsgAlert("If box empty...?" ) ID "box1" RESOURCE cGlade

         DEFINE TOOLMENU  ;
                ACTION MsgInfo( "Action" );
                MENU oMenu ;
                ID "toolmenu1" RESOURCE cGlade
                  
         // Para poner aceleradores, selecciona el boton, vete al apartado de 'common'
         // y presiona 'Accerelators-->Edit' y descubre como hacerlo.
         DEFINE BUTTON ID "button1" RESOURCE cGlade ACTION MsgInfo( "If press key F1 ...i show" ,"Atention" )
         DEFINE STATUSBAR TEXT "Example ToolMenu from Glade by Rafa Carmona" ID "statusbar1" RESOURCE cGlade 

    ACTIVATE WINDOW oWindow 

Return NIL
