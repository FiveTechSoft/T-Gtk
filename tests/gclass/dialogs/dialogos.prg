/*
 * $Id: dialogos.prg,v 1.1 2006-09-21 09:46:26 xthefull Exp $
 * Ejemplo de Dialogos
 * (C) 2004-05. Rafa Carmona -TheFull-
*/
#include "gclass.ch"

Function Main()
         Local oDlg, oBoxV, oSay, oSay2,oBtn, oFixed

          DEFINE WINDOW oDlg TITLE "T-GTK Dialogs" SIZE 500,300

                 DEFINE BOX oBoxV OF oDlg HOMO
                     DEFINE LABEL oSay TEXT "Es un ejemplo" OF oBoxV
                     DEFINE LABEL oSay2 TEXT "de unos label en un dialgo" OF oBoxV

                     DEFINE FIXED oFixed OF oBoxV
                            DEFINE BUTTON oBtn PROMPT "Umm..." ;
                                   ACTION MsgINfo( hola() );
                                   OF oFixed POS 10,25

          ACTIVATE WINDOW oDlg CENTER  ;
             VALID( MsgBox( "Quieres salir", GTK_MSGBOX_OK+GTK_MSGBOX_CANCEL,GTK_MSGBOX_INFO ) == GTK_MSGBOX_OK )


Return NIL

Static function Hola()
   Local oDlg
   
   DEFINE DIALOG oDlg  TITLE "HOLA"
          
          ADD DIALOG oDlg   ;  /* Dialogo a donde va el boton */
              BUTTON "HOLA"  ;  /* Texto del botón */
              ACTION MsgInfo("Hola","HOLA") /* Accion a ejecutar */
   

   ACTIVATE DIALOG oDlg RUN ;
            VALID ( MsgInfo("Salimos"), .T. ) ;
            ON_YES Hola2( )  ;
            ON_OK oDlg:End
   
   ? "HA"

 Return cValToChar( oDlg:nId ) // Valor devuelto por el dialogo


 static function hola2( nId )
 MsginFo( "HOLA 2 ") 
 return nil
