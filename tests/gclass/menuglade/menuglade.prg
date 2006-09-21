/*
 * $Id: menuglade.prg,v 1.1 2006-09-21 09:59:22 xthefull Exp $
 * Ejemplo de control de menus de glade
 * Porting Harbour to GTK+ power !
 * (C) 2004-05. Rafa Carmona -TheFull-
*/

#include "gclass.ch"

Function main( )
    Local cResource, oWnd, oMenuItem

    SET RESOURCES cResource FROM FILE "menu.glade"

    DEFINE WINDOW oWnd ID "window1" RESOURCE cResource

          DEFINE MENUITEM IMAGE oMenuItem ;
                 ACTION MsgStop("EH!!Abrimos","New") ;
                 ID "abrir1" ;
                 RESOURCE cResource ;

           DEFINE MENUITEM IMAGE ;
                 ACTION oWnd:End();
                 ID "salir1" ;
                 RESOURCE cResource ;

           // Lo quiero ver como radio, y que este activo
           DEFINE MENUITEM CHECK ;
                 ACTION MsgAlert( "Check!","Hola" );
                 ASRADIO ACTIVE;
                 ID "item1" ;
                 RESOURCE cResource ;

          DEFINE MENUITEM ACTION Acerca() ;
                 ID "acerca_de1" ;
                 RESOURCE cResource ;
         
         // Poniendo un acelerador desde codigo fuente a un menuitem
         DEFINE ACCEL_GROUP oAccel OF oWnd
               ADD ACCELGROUP oAccel OF oMenuItem ;
                   SIGNAL "activate" ;
                   KEY GDK_F5 ;
                   FLAGS GTK_ACCEL_VISIBLE

    ACTIVATE WINDOW oWnd

Return NIL

Static Function Acerca()

       MsgInfo( "Programacion de Menus desde Glade","T-Gtk" )

return nil


