/*
 *
 * $Id: main.prg,v 1.1 2008-10-22 19:59:27 riztan Exp $
 *
 */

#include "postgres.ch"
#include "gclass.ch"

#define TGTK_ICON "gtk-execute"

Function Main()
    Local oDlg, oBoxMenu,oBar, oBoxH, oTable1
    Local oBoxV_1,oBoxV_2, oBtn1, oBtn2,oImage,oImage1,oImage2
    Local oLabel1,oLabel2,oLabel3,oLabel4,oLabel5
    Local oHost,cHost:="localhost"+SPACE(30)
    Local oDB,cDB:="postgres"+SPACE(30)
    Local oUser,cUser:="postgres"+SPACE(30)
    Local oPass,cPass:=""+SPACE(30)
    Local oPort,nPort:=5432
    Local oLabel
    Local conn, res, aTemp, i, x,y, pFile

    SET CENTURY ON
    SET DATE ITALIAN

    DEFINE WINDOW oDlg; 
           TITLE "T-Gtk. Login to PostgreSQL";
           ICON_NAME GTK_STOCK_CONNECT
           //SIZE  250,300  //ICON_NAME "gtk-execute"

//           gtk_window_set_modal( oDlg, FALSE )

           DEFINE BOX oBoxMenu VERTICAL OF oDlg

           DEFINE BOX oBoxH OF oBoxMenu EXPAND FILL SPACING 5

           DEFINE BOX oBoxV_1 VERTICAL OF oBoxH CONTAINER SPACING 5

/*
                  DEFINE IMAGE oImage2; 
                         FILE "../../images/pgadmin3.xpm"; 
                         SIZE 20,10 ;
                         OF oBoxV_2 EXPAND FILL
*/

                  DEFINE LABEL oLabel1 TEXT "Servidor:";
                         OF oBoxV_1 EXPAND FILL ;
                         VALIGN 1;
                         JUSTIFY GTK_JUSTIFY_LEFT

                  DEFINE ENTRY oHost;
                         VAR cHost ;
                         OF oBoxV_1

                  DEFINE LABEL oLabel1 TEXT "Base de Datos:";
                         OF oBoxV_1 EXPAND FILL ;
                         VALIGN 1;
                         JUSTIFY GTK_JUSTIFY_LEFT

                  DEFINE ENTRY oDB;
                         VAR cDB ;
                         OF oBoxV_1

                  DEFINE LABEL oLabel3 TEXT "Usuario:";
                         OF oBoxV_1 EXPAND FILL ;
                         VALIGN 1;
                         JUSTIFY GTK_JUSTIFY_LEFT

                  DEFINE ENTRY oUser;
                         VAR cUser ;
                         OF oBoxV_1

                  DEFINE LABEL oLabel4 TEXT "Password:";
                         OF oBoxV_1 EXPAND FILL ;
                         VALIGN 1;
                         JUSTIFY GTK_JUSTIFY_LEFT

                  DEFINE ENTRY oPass;
                         VAR cPass PASSWORD;
                         OF oBoxV_1

                  DEFINE LABEL oLabel5 TEXT "Puerto:";
                         OF oBoxV_1 EXPAND FILL ;
                         VALIGN 1;
                         JUSTIFY GTK_JUSTIFY_LEFT

                  DEFINE ENTRY oPort;
                         VAR nPort ;
                         OF oBoxV_1


           DEFINE BOX oBoxV_2 VERTICAL OF oBoxH CONTAINER SPACING 5

                  DEFINE IMAGE oImage; 
                         FILE "../../images/tgtk-logo.png"; 
                         OF oBoxV_2 EXPAND FILL

                  DEFINE IMAGE oImage1; 
                         FILE "./images/logo_postgresql.png" ; 
                         OF oBoxV_2 EXPAND FILL

                  DEFINE BUTTON oBtn1 ;
                         TEXT " Conectar" ;
                         FROM STOCK GTK_STOCK_CONNECT;
                         ACTION Prueba( Login( cHost, cDB, cUser, cPass, nPort ) );
                         OF oBoxV_2  ;
                         SIZE 170,0
                     DEFINE TOOLTIP ;
                            WIDGET oBtn1 ;
                            TEXT "Conectar la Base de Datos "+ALLTRIM(cHost) 

                  DEFINE BUTTON oBtn2 ;
                         TEXT "Cancelar" ;
                         FROM STOCK GTK_STOCK_CANCEL;
                         ACTION oDlg:End();
                         OF oBoxV_2  ;
                         SIZE 170,0
                     DEFINE TOOLTIP ;
                            WIDGET oBtn2 ;
                            TEXT "Cancelar" 


    ACTIVATE WINDOW oDlg

//    conn := PQsetdbLogin( cHost, STR(iPort), NIL, NIL, cDb, cUser, cPass)

Return NIL


FUNCTION Prueba( lLogin )

   If lLogin
      MsgInfo("Finalizado...")
   Endif

Return .T.



