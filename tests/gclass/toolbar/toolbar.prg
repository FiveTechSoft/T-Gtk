/*
 * $Id: toolbar.prg,v 1.1 2006-09-21 10:05:13 xthefull Exp $
 * Ejemplo de Toolbars
 * Porting Harbour to GTK+ power !
 * (C) 2004-05. Rafa Carmona -TheFull-
*/
#include "gclass.ch"

Function Main()
    Local oWindow, oToolBar, oToolButton, oBoxV, oRadio1, oRadio2, oRadio3, oToolMenu, oImage
    
    DEFINE IMAGE oImage FILE "../../images/Anieyes.gif" LOAD

    DEFINE WINDOW oWindow TITLE "T-GTK Toolbar Example POO" SIZE 500,200
            
            DEFINE BOX oBoxV VERTICAL OF oWindow
               DEFINE TOOLBAR oToolBar  OF oBoxV SHOW ARROW

                  DEFINE TOOLMENU oToolMenu  ;
                         TEXT "Menu Tools" ;
                         IMAGE oImage ;
                         ACTION MsgInfo( "Action" );
                         MENU Build_Menu() ;
                         OF oToolBar
              
                  // Esto es una demostracion de como podemos ejecutar un codeblock,
                  // cuando pulsamos para desplegar el menu.
                  // No creo que tengo mucho sentido, asi que no lo he puesto en el comando...
                  // pero podeis comprender como podemos hacerlo directamente...por si a alguien
                  // le interesa...cosas mas raras se han visto.. ;-)
                  oToolMenu:SetShowMenu( {|| MsgInfo( "oh! Fantastic... :-)", "Harry potter" )} )

                  DEFINE TOOLMENU oToolMenu  ;
                         FROM STOCK GTK_STOCK_OPEN ;
                         ACTION MsgInfo( "OPen..." );
                         MENU Build_Menu() ;
                         OF oToolBar
                  
                  DEFINE TOOLBUTTON oToolButton  ;
                         TEXT "ICONS";
                         STOCK_ID GTK_STOCK_STOP ;
                         ACTION oWindow:End();
                         OF oToolBar

                  DEFINE TOOLBUTTON oToolButton  ;
                         TEXT "TEXT";
                         STOCK_ID GTK_STOCK_EXECUTE ;
                         ACTION Create_win();
                         OF oToolBar

                   DEFINE TOOLBUTTON oToolButton  ;
                         TEXT "BOTH";
                         STOCK_ID GTK_STOCK_CDROM ;
                         ACTION Creadia( oWindow );
                         OF oToolBar

                   DEFINE TOOLBUTTON oToolButton  ;
                         TEXT "Style Toolbar";
                         STOCK_ID GTK_STOCK_REFRESH ;
                         ACTION MyStyle( oToolBar ) ;
                         OF oToolBar

                   DEFINE TOOL SEPARATOR OF oToolBar

                   DEFINE TOOLRADIO oRadio1 TEXT "Radio 1" ;
                          STOCK_ID GTK_STOCK_ZOOM_100 ;
                          ACTION MsgInfo( "Radio 1","HOLA" );
                          OF oToolBar

                   DEFINE TOOLRADIO oRadio2  ;
                          FROM STOCK GTK_STOCK_ZOOM_IN ;
                          GROUP oRadio1;
                          ACTION MsgInfo( "Radio 2","HOLA" );
                          OF oToolBar

                    DEFINE TOOLRADIO oRadio2 TEXT "Radio 3" ;
                          STOCK_ID GTK_STOCK_ZOOM_OUT ;
                          GROUP oRadio1;
                          ACTION MsgInfo( "Radio 3","HOLA" );
                          OF oToolBar

                    DEFINE TOOL SEPARATOR EXPAND OF oToolBar

                    DEFINE TOOLTOGGLE oToolButton  ;
                          TEXT "Al final Toggle";
                          STOCK_ID GTK_STOCK_HOME ;
                          ACTION MsgInfo( "HOLA","HOLA" );
                          ACTIVED;
                          OF oToolBar

    ACTIVATE WINDOW oWindow ;
             VALID ( MsgBox( "Quieres salir", GTK_MSGBOX_OK+GTK_MSGBOX_CANCEL,GTK_MSGBOX_INFO ) == GTK_MSGBOX_OK )

Return NIL

Function Create_Win()
   Local oWnd

   DEFINE WINDOW oWnd SIZE 150,150

          DEFINE BUTTON TEXT "_SALIR" MNEMONIC OF oWnd ;
                 ACTION oWnd:End() CONTAINER

   ACTIVATE WINDOW oWnd MODAL CENTER

Return nil

Function CreaDia( oWnd )
     Local oDlg, oToolbar, oToolButton, oBoxV
     Local nRespuesta

     DEFINE DIALOG oDlg TITLE "Ejemplo de un dialogo ;-)" SIZE 200,200
       DEFINE BOX oBoxV VERTICAL OF oDlg CONTAINER

           DEFINE TOOLBAR oToolBar  OF oBoxV

              DEFINE TOOLMENU oToolMenu  ;
                     FROM STOCK GTK_STOCK_PRINT ;
                     MENU Build_Menu() ;
                     OF oToolBar

              DEFINE TOOLBUTTON oToolButton  ;
                     TEXT "ICONS";
                     STOCK_ID GTK_STOCK_STOP ;
                     OF oToolBar

      ACTIVATE DIALOG oDlg CENTER ;
               ON CANCEL oDlg:End()

 Return nil

/* Cambiamos el style de la toolbar */
Static Function MyStyle( oToolBar )
       static nStyle := 1

      DO CASE
         CASE nStyle  == 1
              oToolBar:SetStyle( GTK_TOOLBAR_ICONS )
         CASE nStyle  == 2
              oToolBar:SetStyle( GTK_TOOLBAR_BOTH_HORIZ )
         CASE nStyle  == 3
              oToolBar:SetStyle( GTK_TOOLBAR_TEXT )
         CASE nStyle  == 4
              oToolBar:SetStyle( GTK_TOOLBAR_BOTH)
              nStyle := 0
      ENDCASE
      nStyle++

RETURN NIL

STATIC FUNCTION BUILD_MENU()
 Local oMenu
  
  DEFINE MENU oMenu
     MENUITEM TITLE "Opcion 1"  ACTION MsgAlert( "Option 1" ) OF oMenu
     MENU SEPARATOR  OF oMenu
     MENUITEM TITLE "Opcion 2"  ACTION MsgAlert( "Option 2" ) OF oMenu
     MENU SEPARATOR  OF oMenu
     MENUITEM IMAGE FROM STOCK GTK_STOCK_HOME ACTION MsgStop( "Image...oh" ) OF oMenu


RETURN oMenu
