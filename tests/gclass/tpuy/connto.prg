/*
 *
 * Copyright 2010 Daniel Garcia-Gil<danielgarciagil@gmail.com>
 * www - http://tdolphin.blogspot.com/
 *
 */

/* Modificaciones por Riztan Gutierrez - riztan (at) gmail (dot) com */

#include "gclass.ch"
#include "xhb.ch"

FUNCTION ConnectTo( cNameConn )
   LOCAL hIni, hConn
   LOCAL oServer   
   LOCAL cDBType,cServer, cUser, cPassword, nPort, cDBName,nFlags    
   LOCAL oErr

   DEFAULT cNameConn := ""

   hIni      := HB_ReadIni( "connect.ini" )

   If HHasKey( hIni, cNameConn )
      hConn     := hIni[cNameConn]
   Else
      MsgStop( "Conexion "+cNameConn+". No existe " )
      Return NIL
   Endif

   oServer   := NIL
   cDBType   := hConn["dbtype"]
   cServer   := hConn["host"]
   cUser     := hConn["user"]
   cPassword := hConn["psw"]
   nPort     := val(hConn["port"])
   cDBName   := hConn["dbname"]
   nFlags    := val(hConn["flags"])

   If Upper(cDBType)=="MYSQL"
      TRY
      
         oServer = TDolphinSrv():New( cServer, ;
                                   cUser, ;
                                   cPassword, ;
                                   nPort, nFlags, cDBName )
                                
      CATCH oErr 
        RETURN NIL
      END
   else
MsgAlert( "Aun no disponible conexión tipo [<b>"+cDbType+"</b>]." MARKUP )
return NIL
   endif
   
RETURN oServer


//eof
