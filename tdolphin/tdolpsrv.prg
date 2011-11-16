/*
 * $Id: 10/13/2010 5:51:32 PM tdolpsrv.prg Z dgarciagil $
 */
   
/*
 * TDOLPHIN PROJECT source code:
 * Manager MySql server connection
 *
 * Copyright 2010 Daniel Garcia-Gil<danielgarciagil@gmail.com>
 * www - http://tdolphin.blogspot.com/
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2, or (at your option)
 * any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this software.  If not, write to
 * the Free Software Foundation, Inc., 59 Temple Place, Suite 330,
 * Boston, MA 02111-1307 USA (or visit the web site http://www.gnu.org/).
 *
 * As a special exception, the tdolphin Project gives permission for
 * additional uses of the text contained in its release of tdolphin.
 *
 * The exception is that, if you link the tdolphin libraries with other
 * files to produce an executable, this does not by itself cause the
 * resulting executable to be covered by the GNU General Public License.
 * Your use of that executable is in no way restricted on account of
 * linking the tdolphin library code into it.
 *
 * This exception does not however invalidate any other reasons why
 * the executable file might be covered by the GNU General Public License.
 *
 * This exception applies only to the code released by the tdolphin
 * Project under the name tdolphin.  If you copy code from other
 * tdolphin Project or Free Software Foundation releases into a copy of
 * tdolphin, as the General Public License permits, the exception does
 * not apply to the code that you add in this way.  To avoid misleading
 * anyone as to the status of such modified files, you must delete
 * this exception notice from them.
 *
 * If you write modifications of your own for tdolphin, it is your choice
 * whether to permit this exception to apply to your modifications.
 * If you do not wish that, delete this exception notice.
 *
 */

#include "hbclass.ch"
#include "common.ch"
#include "dbstruct.ch"
#include "tdolphin.ch"
#include "dolerr.ch"
#include "fileio.ch"

#define CRLF Chr( 13 ) + Chr( 10 )

#ifdef __HARBOUR__
#include "hbcompat.ch"
#ifndef RGB
#define RGB( nR,nG,nB )  ( nR + ( nG * 256 ) + ( nB * 256 * 256 ) )
#endif /*RGB*/
#endif/*__HARBOUR__*/

static aHost := {}
static oServerDefault := NIL

CLASS TDolphinSrv

   CLASSDATA nQueryId
   CLASSDATA nServerId  INIT 1

   DATA bOnError       /*Custom manager error message
                         ( Self, nError, lInternal ) */
   DATA bOnBackUp      /*codeblock to evaluate in backup process*/
             
   DATA bOnRestore     /*codeblock to evaluate in restore process*/      
   DATA bOnMultiQry    /*codeblock to evaluate for each Query in METHOD MultiQuery*/      
#ifdef DEBUG 
   DATA bDebug         /*codeblock to evaluate for each Query, Arg cQuery, ProcName( 1 ), ProcLine( 1 )*/ 
#endif      
   
   DATA cDBName        /*Data base selected*/
   DATA cPassword      /*Data contains the password for user*/
   DATA cHost          /*Host name, may be either a host name or an IP address */
   DATA cUser          /*DAta contains the user's MySQL login ID*/
   DATA cNameHost
   
   DATA cBuild     INIT '22-Sep-10 9:27:25 PM'
                       
   DATA hMysql         /*MySQL connection handle*/
                       
   DATA lReConnect     
   
   DATA Cargo          /*For programmer use*/
                       
   DATA lError         /*Error detection switch*/
                  
   DATA nFlags         /*Client flags*/
   DATA nInternalError /*error manager, no come from MySQL*/
   DATA nPort          /*value is used as the port number for the TCP/IP connection*/
   
   DATA aQueries       /*Array queries actives*/
   
   METHOD New( cHost, cUser, cPassword, nPort, nFlags, bOnError, cDBName )
   
   METHOD AddUser( cHost, cUser, cPassword, cDb, lCreateDB, acPrivilegs, cWithOption )
                              /*The AddUser() enables system administrators to grant privileges to MySQL user accounts. 
                                AddUser also serves to specify other account characteristics such as use of secure 
                                connections and limits on access to server resources. 
                                To use AddUser(), you must have the GRANT OPTION privilege, 
                                and you must have the privileges that you are granting.*/
                                
   METHOD AddQuery( oQuery )          INLINE AAdd( ::aQueries, oQuery )
                              /*used internally*/

   METHOD Backup( aTables, cFile, lDrop, lOver, nStep, cHeader, cFooter, lCancel )  

   METHOD BeginTransaction()          INLINE ::SqlQuery( "BEGIN" )    
   
   METHOD ChangeEngine( cTable, cType )  INLINE ::SqlQuery( "ALTER TABLE " + D_LowerCase( cTable ) + " ENGINE = " + D_LowerCase( cType ) )
      
   METHOD ChangeEngineAll( cType )  
   
   METHOD CheckError( nError )
   
   METHOD CloseQuery( nId )
   
   METHOD CloseAllQuery()             

   METHOD Compact( cTable )
 
   METHOD Connect( cHost, cUser, cPassword, nPort, nFlags, cDBName )	
                              /*to establish a connection to a MySQL database engine running on server*/

   METHOD CommitTransaction()       INLINE MySqlCommit( ::hMySql ) == 0
                              /*Commits the current transaction.*/

   METHOD CreateIndex( cName, cTable, aFNames, nCons, nType )                              
   
   METHOD CreateInfo( cTable )
                              
   METHOD CreateTable( cTable, aStruct, cPrimaryKey, cUniqueKey, cAuto, cExtra )
                              /*creates a table with the cTable name*/

   METHOD DBCreate( cName, lIfNotExist, cCharSet, cCollate )
                              /* Create Database in current active connection*/

                                
   METHOD DBExist( cDB )      INLINE If( ! Empty( cDB ), Len( ::ListDBs( D_LowerCase( cDB ) ) ) > 0, .F. )
                              /* verify is Data Base exist, return logical value*/

   METHOD DeleteDB( cDB, lExists )
                              /*Delete Tables*/
                              
   METHOD DeleteIndex( cName, cTable )         
                              /*Delete Index*/                     
   
   METHOD DeleteTables( acTable, lExists )
                              /*Delete Tables*/
                              
   METHOD DropUser( cUser )             INLINE ::SqlQuery( "DROP USER " + cUser )
                              /*Drop User*/
   
   METHOD Embedded( cDataBase, aOptions, aGroups )
   
   METHOD End()               
   
   METHOD ErrorTxt()          INLINE  If( ::hMysql != NIL, MySqlError( ::hMysql ), "" )
                              /* Returns a string containing the error message for 
                                 the most recently invoked API function that failed.*/
   
   METHOD ErrorNo()           INLINE ::lError := .F., MySqlGetErrNo( ::hMysql )
                              /* Returns the error code for the most recently invoked 
                                API function that can succeed or fail. 
                                A return value of zero means that no error occurred.*/
                                
   METHOD Execute( cQuery )   INLINE ::SqlQuery( cQuery )  
   
   METHOD ExecuteScript( cFile ) 

   METHOD GetAutoIncrement( cTable )
                                /*Retrieve next Auto increment value in specified table;
                                 in current database selected*/   
   
   METHOD GetPrivileges()
   
   METHOD GetQueryId()   
   
   
   METHOD GetRowsFromTable( cTable )
                               /*Retrieve total row avalaible in  specified table;
                                in current database selected*/    

   METHOD GetRowsFromQry( oQuery )
                               /*Retrieve total row avalaible in  specified query;
                                in current database selected*/    
   
   METHOD Insert( cTable, aColumns, aValues )  
                              /*inserts new rows into an existing table.*/

   METHOD IsAutoIncrement( cField, cTable )
                              /* Verify is a field is Auto Increment*/
   
   METHOD LastDownData( cTable, cCol, uDef )
   
   METHOD LastInsertID()      /*Returns the first automatically generated value that was set for an AUTO_INCREMENT
                                column by the most recently executed INSERT statement to affect such a column.*/
   
   METHOD ListDBs( cWild )    /* Returns a array set consisting of database names on the server 
                                 that match the simple regular expression specified by the wild parameter. 
                                 wild may contain the wildcard characters “%” or “_”, 
                                 or may be a "" to match all databases.*/
   
   METHOD ListTables( cWild ) /* Returns a array set consisting of tables names in current satabase 
                                 that match the simple regular expression specified by the wild parameter. 
                                 wild may contain the wildcard characters “%” or “_”, 
                                 or may be a "" to match all tables.*/
                                 
   METHOD MultiQuery( aQuery, lTransaction )
   
   METHOD Ping()                  INLINE If( MySqlPing( ::hMysql ) > 0, ( ::CheckError(), .F.), .T. )
                              /* Checks whether the connection to the server is working. 
                                 If the connection has gone down and auto-reconnect is enabled an attempt 
                                 to reconnect is made. If the connection is down and auto-reconnect is disabled,
                                 ::ping() returns an error.*/

   METHOD Query( cQuery )   INLINE 	TDolphinQry():New( cQuery, Self )
   
   METHOD ReConnect()

   METHOD RenameUser( cFromUser, cServer, cRename )  
                              /*Rename User*/
                              
   METHOD Restore( cFile, lCancel )                              

   METHOD RevokePrivileges( cHost, cUser, cDB, acPrivilegs )
                              /*The RevokePrivileges() enables system administrators to revoke privileges from MySQL accounts.*/
   

   METHOD RollBack()                  INLINE MySqlRollBack( ::hMysql )
                              /* Rolls back the current transaction.*/
                             
   METHOD SelectDB( cDBName ) 
                              /*Select data base in current active connection*/
   
   
   METHOD SelectTable( aColumns, aTables, cWhere, cGroup, cHaving, cOrder, cLimit, lWithRoll )
   
   METHOD SetNameServer( cName )
   
   METHOD SqlQuery( cQuery )  /*Executes the SQL statement pointed to by cQuery, 
                              Normally, the string must consist of a single SQL statement and 
                              you should not add a terminating semicolon (“;”) or \g to the statement. 
                              If multiple-statement execution has been enabled, 
                              the string can contain several statements separated by semicolons.*/
 
   METHOD TableExist( cTable )      INLINE If( ! Empty( cTable ), Len( ::ListTables( D_LowerCase( cTable ) ) ) > 0, .F. )
                              /* verify is table exist, return logical value*/ 
   
   METHOD TableStructure( cTable )  
   
   METHOD Update( cTable, aColumns, aValues, cWhere )
                             /*inserts new rows into an existing table.*/
                                 
ENDCLASS

//----------------------------------------------------//

METHOD New( cHost, cUser, cPassword, nPort, nFlags, cDBName, bOnError, cNameHost ) CLASS TDolphinSrv

   DEFAULT nPort TO 3306 

   ::cHost          = cHost
   ::cUser          = cUser
   ::cPassword      = cPassword
   ::nPort          = nPort
   ::nFlags         = nFlags
   ::lError         = .F.
   ::bOnError       = bOnError
   ::nInternalError = 0
   ::cDBName        = cDBName
   ::aQueries       = {}
      
   ::lReConnect     = .T.

   ::hMysql         = ::Connect() 
   
   ::CheckError()
   IF ::lError
      ::End()
   ENDIF
   
   DEFAULT  cNameHost TO "TEMP" + Alltrim( Str( ::nServerId++ ) )
   
   ::cNameHost = cNameHost
   
   AAdd( aHost, { Self, cNameHost } )
   
   SetServerDefault( Self )

RETURN Self

//----------------------------------------------------//

METHOD Embedded( cDataBase, aOptions, aGroups, bOnError, cNameHost ) CLASS TDolphinSrv
   
   ::lError         = .F.
   ::bOnError       = bOnError
   ::nInternalError = 0
   ::cDBName        = cDataBase
   ::aQueries       = {}
   
   DEFAULT aGroups TO {}
   DEFAULT aOptions TO {}

   aGroups  = CheckArray( aGroups )
   aOptions = CheckArray( aOptions )

   ::hMysql   :=  MysqlEmbedded( cDataBase, aOptions, aGroups )

   ::CheckError()
   IF ::lError
      ::End()
   ENDIF


   DEFAULT  cNameHost TO "TEMP" + Alltrim( Str( ::nServerId++ ) )

   ::cNameHost = cNameHost

   AAdd( aHost, { Self, cNameHost } )
   
   SetServerDefault( Self )


RETURN Self


//----------------------------------------------------//


METHOD AddUser( cHost, cUser, cPassword, cDb, lCreateDB, acPrivilegs, cWithOption ) CLASS TDolphinSrv
   LOCAL lReturn := .f.
   LOCAL cQuery  := ""
   LOCAL cDbOld  := ""
   LOCAL cPriv

   DEFAULT cHost     TO ::cHost
   DEFAULT cUser     TO ""
   DEFAULT cPassword TO ""
   DEFAULT cDb       TO "*"
   DEFAULT lCreateDB TO .f.
   DEFAULT acPrivilegs TO "ALL PRIVILEGES"
   DEFAULT cWithOption     TO ""
   

   IF Empty( cHost ) .OR. Empty( cUser ) .OR. Empty( cDb )
      RETURN lReturn
   ENDIF

   cHost     := Alltrim( cHost )
   cUser     := Alltrim( cUser )
   cPassword := Alltrim( cPassword )
   cDb       := Alltrim( cDb )

   IF !::DBExist( cDb ) .AND. lCreateDB
      ::DBCreate( cDb )
   ENDIF
   
   IF ValType( acPrivilegs ) == "A"
      cPriv = SQLStringFromArray( acPrivilegs )
   ELSE 
      cPriv = acPrivilegs
   ENDIF
   

   cQuery  := "GRANT " + cPriv + " ON " + cDb + ".* TO "
   cQuery  += "'" + cUser + "'@'" + cHost + "'"
   IF !Empty( cPassword )
      cQuery  += " IDENTIFIED BY "
      cQuery  += "'" + cPassword + "'"
   ENDIF
   
   IF !Empty( cWithOption )
      cQuery += " WITH " + cWithOption
   ENDIF

   lReturn := ::SqlQuery( cQuery )

RETURN lReturn

//----------------------------------------------------//

METHOD Backup( aTables, cFile, lDrop, lOverwrite, nStep, cHeader, cFooter, lCancel, bOnBackUp ) CLASS TDolphinSrv
   LOCAL hFile  := 0
   LOCAL oQry   := NIL
   LOCAL cQry   := ""
   LOCAL cText  := "", cText2 := ""
   LOCAL cCol   := ""
   LOCAL nCol   := 0
   LOCAL cTable := ""
   LOCAL nTotTable := 0
   LOCAL nCurrTable := 0
   LOCAL nTRow  := 0
   LOCAL nRecno := 0
   LOCAL nPage  := 0
   LOCAL nError := 0

   DEFAULT lOverwrite TO .F.
   DEFAULT lDrop TO .F.
   DEFAULT nStep TO 500
   DEFAULT lCancel TO .F.
   DEFAULT cFooter TO ""
   DEFAULT cHeader TO;
    "-- CLASS TDolphin, for [x]Harbour" + CRLF +;
    "---------------------------------" + CRLF
   DEFAULT bOnBackUp TO ::bOnBackUp

   aTables = CheckArray( aTables )
   
   ::bOnBackUp = bOnBackUp

#ifndef NOINTERNAL
   IF Empty( ::cDBName )
      ::nInternalError = ERR_NODATABASESELECTED
      ::CheckError()
      RETURN .F.
   ENDIF

   IF File( cFile ) .AND. !lOverwrite
      ::nInternalError = ERR_INVALIDBACKUPFILE
      ::CheckError()
      RETURN .F.
   ENDIF

   IF len( aTables ) == 0
      ::nInternalError = ERR_NOTABLESSELECTED
      ::CheckError()
      RETURN .F.
   ENDIF
#endif 

   IF File( cFile ) 
     IF lOverwrite 
        IF FErase( cFile ) < 0
#ifndef NOINTERNAL
           ::nInternalError = ERR_CANNOTCREATEBKFILE
           ::CheckError()
#endif         
           RETURN .F.
        ENDIF
        FClose( FCreate( cFile ) )
     ENDIF
   ELSE 
      FClose( FCreate( cFile ) )
   ENDIF 
   
   IF( ( hFile := FOpen( cFile, FO_WRITE ) ) != -1 )
      FSeek( hFile, 0, FS_END )
   ELSE 
#ifndef NOINTERNAL
      ::nInternalError = ERR_OPENBACKUPFILE
      ::CheckError()
#endif         
      RETURN .F.
   ENDIF       
   
   IF ::bOnBackUp != NIL
      Eval( ::bOnBackUp, ST_STARTBACKUP )
   ENDIF
   
   cText += cHeader + CRLF

   FOR EACH cTable IN aTables
      cText += "** Table: " + cTable + CRLF
   NEXT

   IF lDrop
      cText += CRLF
      cText += CRLF   
      cText += "** Create database **"
      cText += CRLF
      cText += "CREATE DATABASE IF NOT EXISTS " + ::cDBName
   ENDIF


   nTotTable = Len( aTables )
   
   FWrite( hFile, cText )   
   cText = ""   
   
   FOR EACH cTable IN aTables
      cText += CRLF
      cText += CRLF
      IF lCancel
         EXIT
      ENDIF
      cTable = D_LowerCase( cTable )
      
   
      IF ::bOnBackUp != NIL
#ifdef __XHARBOUR__      
         nCurrTable = HB_EnumIndex()
#else 
         nCurrTable =  cTable:__EnumIndex()
#endif   
         Eval( ::bOnBackUp, ST_LOADINGTABLE, cTable, nTotTable, nCurrTable )      
      ENDIF            
      nTRow := ::GetRowsFromTable( cTable )
      cText  += "** BEGIN " + cTable + CRLF
      IF lDrop
         cText  += "DROP TABLE IF EXISTS " + cTable + CRLF
         cText  += ::CreateInfo( cTable ) + CRLF
      ENDIF

      IF nTRow > 0
         cQry := "SELECT * FROM " + cTable + " LIMIT 1"
         oQry := ::Query( cQry )
         cText += CRLF
         cText += CRLF
         cText += "--" + CRLF
         cText += "-- Dumping data for table " + cTable + CRLF
         cText += "--" + CRLF
         cText += CRLF
         cText += CRLF
         cText += "LOCK TABLES " + cTable + " WRITE;" + CRLF
         cText2  = "INSERT INTO " + cTable + " ("
         FOR nCol := 1 TO oQry:FCount()
            cText2 += oQry:FieldName( nCol ) + ","
         NEXT
         cText2 = Left( cText2, len( cText2 ) - 1 )
         cText2 += ") VALUES "
         oQry:End()
         oQry  := NIL
      ENDIF

      nPage := 0
      
      FWrite( hFile, cText )      
      cText = ""
      FOR nRecno := 0 TO nTRow STEP nStep

         IF lCancel
            EXIT
         ENDIF

         IF ::bOnBackUp != NIL
            Eval( ::bOnBackUp, ST_FILLBACKUP, cTable, nTotTable, nCurrTable, nRecno )      
         ENDIF   

         cQry := "SELECT * FROM " + cTable + " LIMIT " 
         cQry += AllTrim( Str( nRecno ) ) + ", "
         cQry += AllTrim( Str( nStep ) )
         oQry := ::Query( cQry )

         WHILE !oQry:eof() .AND. ! lCancel
         
            cText    += "("
            FOR nCol := 1 TO oQry:FCount()
               IF oQry:FieldType( nCol ) == "D"
                  cText += "'"
                  cText += dtos(oQry:FieldGet( nCol ))
                  cText += "',"
               ELSEIF oQry:FieldType( nCol ) == "N"
                  cText += AllTrim( Str( oQry:FieldGet( nCol ) ) ) + ","
               ELSEIF oQry:FieldType( nCol ) == "L"
                  cText += If( oQry:FieldGet( nCol ), "1", "0" ) + ","
               ELSE
                  cText += "'"
                  cText += MySqlEscape( D_LowerCase( oQry:FieldGet( nCol ) ), ::hMysql )
                  cText += "',"
               ENDIF
            NEXT
            cText := Left( cText, len( cText ) - 1 )
            cText += "),"
            oQry:Skip()
            IF oQry:Eof()
               cText := Left( cText, len( cText ) - 1 ) + CRLF
            ENDIF            
         ENDDO
         IF nTRow > nRecno
            FWrite( hFile, cText2 + cText )
         ENDIF
         cText = ""
         oQry:End()
         oQry  := NIL
      NEXT
      IF ::bOnBackUp != NIL
         Eval( ::bOnBackUp, ST_FILLBACKUP, cTable, nTotTable, nCurrTable, Min( nRecno, nTRow ) )
      ENDIF         
      cText = CRLF
      cText += "UNLOCK TABLES"
      cText += CRLF
      cText += CRLF
      cText += "** END " + cTable + CRLF
      cText += CRLF
      cText += CRLF
      cText2 = ""
   NEXT

   IF ! lCancel

      IF Empty( cFooter )
         cFooter = "-- Dump completed on " + DToC( Date() ) + " " + Time() + CRLF
      ENDIF
      cText += cFooter
       
      IF ::bOnBackUp != NIL
         Eval( ::bOnBackUp, ST_ENDBACKUP, cFile )
      ENDIF   
   
      FWrite( hFile, cText )
      FClose( hFile )
      RETURN .F.
   ELSE
      FClose( hFile )
      IF ::bOnBackUp != NIL
         Eval( ::bOnBackUp, ST_BACKUPCANCEL )
      ENDIF   
   ENDIF

RETURN .T.


//---------------------------------------------//

METHOD ChangeEngineAll( cType ) CLASS TDolphinSrv
   LOCAL cTable

   FOR EACH cTable IN ::ListTables()
      ::SqlQuery( "ALTER TABLE " + cTable + " ENGINE = " + D_LowerCase( cType ) )
   NEXT

RETURN NIL

//----------------------------------------------------//

METHOD CheckError( nError, cExtra ) CLASS TDolphinSrv

   LOCAL lInternal := .F.


   DEFAULT nError TO ::ErrorNo()

   IF nError == 0 
      IF ::nInternalError > 0 
         nError = ::nInternalError
         lInternal = .T.
         ::lError    = .T.
      ENDIF
   ELSE 
      ::lError := .T.   
   ENDIF
   
   IF ::lError
      IF nError == CR_SERVER_GONE_ERROR .AND. ::lReConnect
         ::ReConnect()
      ELSE
         IF ::bOnError != nil
            Eval( ::bOnError, Self, nError, lInternal, cExtra )
         ELSE 
            Dolphin_DefError( Self, nError, lInternal, cExtra )
         ENDIF
      ENDIF
   ENDIF


RETURN NIL


//----------------------------------------------------//

METHOD CloseQuery( nId ) CLASS TDolphinSrv

   LOCAL nPos := AScan( ::aQueries, {| o | o:nQryId == nId } )
   LOCAL oQry
   
   IF nPos > 0 
      oQry = ::aQueries[ nPos ]
      IF oQry:hResult != NIL
         //MySqlFreeResult( oQry:hResult )/* NOTE: Deprecated */
         oQry:hResult = NIL 
      ENDIF 
      ADel( ::aQueries, nPos )
      ASize( ::aQueries, Len( ::aQueries ) - 1 )
   ENDIF

RETURN NIL 


//----------------------------------------------------//

METHOD CloseAllQuery() CLASS TDolphinSrv           

   LOCAL oQry 
   
   FOR EACH oQry IN ::aQueries
    
      ::CloseQuery( oQry:nQryId ) 
      
   NEXT
   
RETURN NIL

//----------------------------------------------------//

METHOD Compact( cTable ) CLASS TDolphinSrv
   LOCAL aTables := {}

   DEFAULT cTable TO ""

   cTable := lower( cTable )

   IF ! Empty( cTable )
      AAdd( aTables, cTable )
   ELSE
      aTables := ::ListTables()
   ENDIF

   FOR EACH cTable IN aTables
      ::SqlQuery( "OPTIMIZE TABLE " + cTable )
   NEXT

RETURN NIL

//----------------------------------------------------//

METHOD Connect( cHost, cUser, cPassword, nPort, nFlags, cDBName ) CLASS TDolphinSrv

   
   DEFAULT cHost     TO ::cHost
   DEFAULT cUser     TO ::cUser
   DEFAULT cPassword TO ::cPassword
   DEFAULT nPort     TO ::nPort
   DEFAULT nFlags    TO ::nFlags
   DEFAULT cDBName   TO ::cDBName
   

RETURN MySqlConnect( cHost, cUser, cPassword, nPort, nFlags, cDBName )

//-----------------------------------------------------------

METHOD CreateIndex( cName, cTable, aFNames, nCons, nType ) CLASS TDolphinSrv

   LOCAL cQuery := "ALTER TABLE "
   LOCAL cField
   LOCAL cConst, cType, cOrden
   LOCAL aIDX_CONST  := { "UNIQUE", "FULLTEXT", "SPATIAL", "PRIMARY KEY" }
   LOCAL aIDX_ORDEN  := { "ASC", "DESC" }
   LOCAL aIDX_TYPE   := { "BTREE", "HASH", "RTREE" }   

   // NOTE: aFNames each item can be array 2 position (1) column name (2) orden type 
   // like numeric, (1) ASC, (2) DESC ie. { "FIELD_NAME", 1 }
   DEFAULT nCons TO 0
   DEFAULT nType TO 0
   

   cQuery += D_LowerCase( cTable ) + " ADD " 
   cQuery += If( nCons == 0, "INDEX ", aIDX_CONST[ nCons ] + " " ) 
   cQuery += D_LowerCase( cName ) + " ("

   FOR EACH cField IN aFNames
      IF ValType( cField ) == "A"
         cQuery += cField[ 1 ] + " " + aIDX_ORDEN[ cField[ 2 ] ] + ","
      ELSE 
         cQuery += cField + ","
      ENDIF 
   NEXT
   
   //remove last coma(,)
   cQuery = Left( cQuery, Len( cQuery ) - 1 ) + ") "
   cQuery += If( nType == 0, "", aIDX_TYPE[ nType ] ) 

RETURN ::SqlQuery( cQuery )

//----------------------------------------------------//

METHOD CreateInfo( cTable ) CLASS TDolphinSrv
   LOCAL oQry   := NIL
   LOCAL cInfo  := ""
   LOCAL aTable := {}
   LOCAL cItem  := ""

   DEFAULT cTable TO ""
   oQry = ::Query( "SHOW CREATE TABLE " + D_LowerCase( cTable ) )
   cInfo := oQry:FieldGet( 2 )
   oQry:End()
   oQry  := NIL

   cInfo := AllTrim( cInfo )
   cInfo := AtRepl( Chr( 10 ), cInfo, "" )
   cInfo := AtRepl( "`", cInfo, "" )

RETURN cInfo


//----------------------------------------------------//
//Table Structure
//Name, Type, Length, Decimal, Not Null (logical), Defaul value
METHOD CreateTable( cTable, aStruct, cPrimaryKey, cUniqueKey, cAuto, cExtra, lIfNotExist, lVer ) CLASS TDolphinSrv

   LOCAL aField
   LOCAL cQuery   
   LOCAL bDefault := { | aRow | If( ! ValType( aRow[ DBS_DEFAULT ] ) == "U", ;
   	                             " DEFAULT " + ClipValue2SQL( aRow[ DBS_DEFAULT ] ), ;
   	                             "" ) }
     
   LOCAL lAutoIncrement
   LOCAL lRet := .T.
   LOCAL nLenStruct := If( ! Empty( aStruct ), Len( aStruct ), 0 ) 

   DEFAULT lVer TO .T.
   DEFAULT lIfNotExist TO .T.
   DEFAULT cPrimaryKey TO ""
   DEFAULT cUniqueKey TO ""
   DEFAULT cExtra TO ""
   

   cPrimaryKey = If( ! Empty( cPrimaryKey ), D_LowerCase( cPrimaryKey ), "" )
   cAuto       = If( ! Empty( cAuto ), D_LowerCase( cAuto ), "" )
   cUniqueKey  = If( ! Empty( cUniqueKey ), D_LowerCase( cUniqueKey ), "" )
   cExtra      = If( ! Empty( cExtra ), D_LowerCase( cExtra ), "" )


#ifndef NOINTERNAL

   IF lVer .AND. nLenStruct > 0
      ::CheckError( VerifyStructure( aStruct ) )
       IF ! ::lError .AND. ! Empty( cPrimarykey ) 
         IF AScan( aStruct, {| aRow | AllTrim( D_LowerCase( aRow[ DBS_NAME ] ) ) == cPrimarykey } ) == 0
            ::nInternalError = ERR_INVALID_STRUCT_PRIKEY
            ::CheckError()
         ENDIF
      ENDIF
   
      IF ! ::lError .AND. ! Empty( cUniquekey )
         IF AScan( aStruct, {| aRow | AllTrim( D_LowerCase( aRow[ DBS_NAME ] ) ) == cUniquekey } ) == 0
            ::nInternalError = ERR_INVALID_STRUCT_UNIQUE
            ::CheckError()
         ENDIF
      ENDIF
      
      IF ! ::lError .AND. ! Empty( cAuto )
         IF AScan( aStruct, {| aRow | AllTrim( D_LowerCase( aRow[ DBS_NAME ] ) ) == cAuto } ) == 0
            ::nInternalError = ERR_INVALID_STRUCT_AUTO
            ::CheckError()
         ENDIF
      ENDIF      

      IF ::lError
         RETURN ::lError 
      ENDIF
   ENDIF
#endif   

   cQuery := "CREATE TABLE " + If( lIfNotExist, " IF NOT EXISTS ", "" ) + D_LowerCase( cTable ) + If( nLenStruct > 0, " (", " " )

   IF nLenStruct > 0
   
      FOR EACH aField IN aStruct
         SWITCH aField[ DBS_TYPE ]
         CASE "C"
            cQuery += aField[ DBS_NAME ] + " char(" + AllTrim( Str( aField[ DBS_LEN ] ) ) + ")" + ;
                      fNotNull( aField, cPrimaryKey, cAuto ) + Eval( bDefault, aField ) + ","
            EXIT
   
         CASE "M"
            cQuery += aField[ DBS_NAME ] + " text" + fNotNull( aField, cPrimaryKey, cAuto ) + ","
            EXIT
   
         CASE "N"
            lAutoIncrement = D_LowerCase( aField[ DBS_NAME ] ) == cAuto
            
            IF aField[ DBS_DEC ] == 0 .AND. aField[ DBS_LEN ] <= 18 
               IF lAutoIncrement
                  cQuery += aField[ DBS_NAME ] + " int("       + AllTrim( Str( aField[ DBS_LEN ] ) ) + ")"
               ELSE
                  DO CASE
                     CASE aField[ DBS_LEN ] <= 4
                        cQuery += aField[ DBS_NAME ] + " smallint("  + AllTrim( Str( aField[ DBS_LEN ] ) ) + ")"
      
                     CASE aField[ DBS_LEN ] <= 6
                        cQuery += aField[ DBS_NAME ] + " mediumint(" + AllTrim( Str( aField[ DBS_LEN ] ) ) + ")"
      
                     CASE aField[ DBS_LEN ] <= 9
                        cQuery += aField[ DBS_NAME ] + " int("       + AllTrim( Str( aField[ DBS_LEN ] ) ) + ")"
      
                     OTHERWISE
                        cQuery += aField[ DBS_NAME ] + " bigint("    + AllTrim( Str( aField[ DBS_LEN ] ) ) + ")"
      
                  ENDCASE
               ENDIF

               cQuery += fNotNull( aField, cPrimaryKey, cAuto ) + ;
                         If( lAutoIncrement, " auto_increment", ;
                             Eval( bDefault, aField ) ) + ","
   
            ELSE
               cQuery += aField[ DBS_NAME ] + " decimal(" + AllTrim( Str( aField[ DBS_LEN ] ) ) + "," + ;
                         AllTrim( Str( aField[ DBS_DEC ] ) ) + ")" + fNotNull( aField, cPrimaryKey, cAuto ) + Eval( bDefault, aField ) + ","
   
            ENDIF
            EXIT
   
         CASE "D"
            cQuery += aField[ DBS_NAME ] + " date " + fNotNull( aField, cPrimaryKey, cAuto ) + Eval( bDefault, aField ) + ","
            EXIT
   
         CASE "L"
            cQuery += aField[ DBS_NAME ] + " tinyint (1)" + fNotNull( aField, cPrimaryKey, cAuto ) + Eval( bDefault, aField ) + ","
            EXIT
   
         CASE "B"
            cQuery += aField[ DBS_NAME ] + " mediumblob " + fNotNull( aField, cPrimaryKey, cAuto ) + Eval( bDefault, aField ) + ","
            EXIT
   
         CASE "I"
            cQuery += aField[ DBS_NAME ] + " mediumint " + fNotNull( aField, cPrimaryKey, cAuto ) + Eval( bDefault, aField ) + ","
            EXIT
   
         CASE "T"
            cQuery += aField[ DBS_NAME ] + " timestamp(" + AllTrim( Str( aField[ DBS_LEN ] ) ) + ")" + fNotNull( aField, cPrimaryKey, cAuto ) + Eval( bDefault, aField ) + ","
            EXIT
   
   #ifdef __XHARBOUR__
         DEFAULT
   #else
         OTHERWISE
   #endif            
            cQuery += aField[ DBS_NAME ] + " char(" + AllTrim(Str(aField[DBS_LEN])) + ")" + fNotNull( aField, cPrimaryKey, cAuto ) + Eval( bDefault, aField ) + ","
   
         END
   
      NEXT
   
      IF ! Empty( cPrimarykey )
         cQuery += ' PRIMARY KEY (' + cPrimaryKey + '),'
      ENDIF
   
      IF ::nInternalError == 0 .AND. ! Empty( cUniquekey )
         cQuery += ' UNIQUE ' + cUniquekey + ' (' + cUniqueKey + '),'
      ENDIF     
   ENDIF

   // remove last comma from list
   IF nLenStruct > 0
      cQuery := Left( cQuery, Len( cQuery ) - 1 ) + ")" + cExtra + ";"
   ELSE 
      cQuery += cExtra + ";"
   ENDIF

RETURN ::SqlQuery( cQuery ) 


//----------------------------------------------------//

METHOD DBCreate( cName, lIfNotExist, cCharSet, cCollate ) CLASS TDolphinSrv

   LOCAL cQuery := "CREATE DATABASE" 
   
   DEFAULT lIfNotExist TO .T.
   
   IF lIfNotExist
      cQuery += " IF NOT EXISTS"
   ENDIF
   
   cQuery += " " + D_LowerCase(  cName )
   
   IF ! Empty( cCharSet )
      cQuery += " CHARACTER SET " + cCharSet
   ENDIF 
   
   IF ! Empty( cCollate )
      cQuery += " COLLATE  " + cCollate
   ENDIF 

RETURN ::SqlQuery( cQuery )

//----------------------------------------------------//

METHOD DeleteDB( cDB, lExists ) CLASS TDolphinSrv

   LOCAL cQuery := "DROP DATABASE "
   
   DEFAULT lExists TO .F.

   cDB = D_LowerCase( cDB )

   IF lExists
      cQuery += " IF EXISTS "
   ENDIF 
   
   cQuery += cDB

RETURN ::SqlQuery( cQuery ) 
   
//----------------------------------------------------//   

METHOD DeleteIndex( cName, cTable, lPrimary ) CLASS TDolphinSrv

   LOCAL cQuery 
   DEFAULT lPrimary TO .F.
   
   cQuery = "DROP INDEX" + If( lPrimary, " PRIMARY ", " " ) + cName + " ON " + D_LowerCase( cTable )

RETURN ::SqlQuery( cQuery )


//----------------------------------------------------//

METHOD DeleteTables( acTables, lExists ) CLASS TDolphinSrv
   
   LOCAL cTables 
   LOCAL cQuery := "DROP TABLE "
   
   DEFAULT lExists TO .F.

   IF ValType( acTables ) == "A"
       cTables = SqlStringFromArray( acTables )
   ELSE 
       cTables = D_LowerCase( acTables )
   ENDIF 

   IF lExists
      cQuery += " IF EXISTS "
   ENDIF 
   
   cQuery += cTables

RETURN ::SqlQuery( cQuery ) 


//----------------------------------------------------//


METHOD End() CLASS TDolphinSrv
   LOCAL nHost

   IF ::hMysql != NIL
      AEval( ::aQueries, {| o | If( o != NIL, o:End(), ) } )
      //MySqlClose( ::hMysql )/* NOTE: Deprecated */      
      ::hMysql = NIL
   ENDIF
  
   nHost = AScan( aHost, { | a | Upper( a[ 2 ] ) == Upper( ::cNameHost ) } ) 
   ADel( aHost, nHost )
   ASize( aHost, Len( aHost ) - 1 )
   
   
RETURN NIL

//----------------------------------------------------//

METHOD ExecuteScript( cFile, bOnScrip ) CLASS TDolphinSrv

   LOCAL cText
   LOCAL aLine

   IF Empty( cFile )
      RETURN NIL
   ENDIF

#ifndef NOINTERNAL
   IF ! File( cFile )
      ::nInternalError = ERR_INVALIDBACKUPFILE
      ::CheckError()
      RETURN .F.
   ENDIF
#endif 
   cText  = D_ReadFile( cFile )

   aLine := hb_ATokens( cText, ";" )
   
   ::MultiQuery( aLine, , bOnScrip )

RETURN NIL

//----------------------------------------------------//

METHOD GetAutoIncrement( cTable ) CLASS TDolphinSrv
   LOCAL nId    := 0
   LOCAL oQuery := NIL
   LOCAL cQuery := ""
   LOCAL cOldDB := ""

   DEFAULT cTable TO ""

   IF Empty( cTable )
      RETURN( nId )
   ENDIF
   
   IF !Empty( ::cDBName )
      cOldDB = ::cDBName
#ifndef NOINTERNAL
   ELSE 
      ::nInternalError = ERR_NODATABASESELECTED
      ::CheckError()
      RETURN nId
#endif       
   ENDIF
      
   ::SelectDB( "information_schema" )

   cQuery := "SELECT auto_increment "
   cQuery += "FROM tables "
   cQuery += "WHERE table_schema = '"
   cQuery += cOldDB + "'"
   cQuery += " AND table_name = '"
   cQuery += cTable + "'"

   oQuery := ::Query( cQuery )
   IF oQuery:LastRec() > 0
      nId := oQuery:FieldGet( 1 )
   ENDIF

   ::SelectDB( cOldDB )
   
   oQuery:End()
   oQuery := NIL

RETURN nId

//----------------------------------------------------//

METHOD GetPrivileges( nType ) CLASS TDolphinSrv

   LOCAL oQry 
   LOCAL cQuery := "SHOW PRIVILEGES"
   LOCAL aPrivilegs := {}
   LOCAL cPriv, lAdd := .F.
   
   DEFAULT nType TO PRIV_DATA
   
   oQry = ::Query( cQuery )
   
   WHILE ! oQry:Eof() 
      
      SWITCH nType
         CASE PRIV_ADMIN
            IF "ADMIN" $ Upper( oQry:CONTEXT )
               lAdd = .T.
            ENDIF 
            EXIT 
         CASE PRIV_DATA
            IF !( "SERVER" $ Upper( oQry:CONTEXT ) )
               lAdd = .T.
            ENDIF 
            EXIT 
         CASE PRIV_TABLE
            IF "TABLE" $ Upper( oQry:CONTEXT )
               lAdd = .T.
            ENDIF 
            EXIT 
            
        CASE PRIV_ALL 
           lAdd = .T.
     ENDSWITCH
     IF lAdd
        AAdd( aPrivilegs, Upper( oQry:FieldGet( 1 ) ) )
        lAdd = .F.
     ENDIF
     oQry:Skip()
   END

RETURN aPrivilegs

//----------------------------------------------------//

METHOD GetQueryId() CLASS TDolphinSrv

   DEFAULT ::nQueryId TO 0
   
   ::nQueryId++

RETURN ::nQueryId

//----------------------------------------------------//

METHOD GetRowsFromTable( cTable ) CLASS TDolphinSrv
   LOCAL nTotal := 0
   LOCAL oQry
   
   oQry = ::Query( "SELECT COUNT(*) FROM " + D_LowerCase( cTable ) )
   
   nTotal = oQry:FieldGet( 1 )
   
   oQry:End() 
   
RETURN nTotal 


//----------------------------------------------------//

METHOD GetRowsFromQry( oQry ) CLASS TDolphinSrv

   LOCAL nTotal := 0
   LOCAL aOldColumns
   LOCAL cQuery
   LOCAL oQryAux
   
#ifndef NOINTERNAL   
   IF ! oQry != NIL .AND. oQry:IsKindOf( "TDOLPHINQRY" )
      ::nInternalError = ERR_MISSINGQRYOBJECT
      ::CheckError()
      RETURN nTotal 
   ENDIF
#endif 

   aOldColumns = AClone( oQry:aColumns )
   
   
   cQuery := BuildQuery( { "COUNT(*)" }, ;
                          oQry:aTables, ;
                          oQry:cWhere, ;
                          oQry:cGroup, ;
                          oQry:cHaving )
   
   oQry:BuildQuery( aOldColumns, ;
                    oQry:aTables,;
                    oQry:cWhere, ;
                    oQry:cGroup, ;
                    oQry:cHaving,; 
                    oQry:cOrder, ;
                    oQry:cLimit )
   
   oQryAux = ::Query( cQuery )
   
   nTotal  = oQryAux:FieldGet( 1 )
   
   oQryAux:End()   

RETURN nTotal

//----------------------------------------------------//

METHOD Insert( cTable, aColumns, aValues ) CLASS TDolphinSrv

   LOCAL cExecute
   LOCAL lRet, n
   
   aColumns = CheckArray( aColumns )
   aValues  = CheckArray( aValues )

#ifndef NOINTERNAL
   IF Empty( aColumns ) .AND. Empty( aValues ) 
      ::nInternalError = ERR_EMPTYVALUES
      ::CheckError()
      RETURN .F.
   ENDIF    
   
   IF Empty( cTable ) 
      ::nInternalError = ERR_EMPTYTABLE
      ::CheckError()
      RETURN .F. 
   ENDIF 
   
   IF Len( aColumns ) # Len( aValues )
      ::nInternalError = ERR_NOMATCHCOLUMNSVALUES
      ::CheckError()
      RETURN .F. 
   ENDIF 
#endif 

   cExecute = BuildInsert( cTable, aColumns, aValues )
   lRet = ::SqlQuery( cExecute )  
  
RETURN lRet

//----------------------------------------------------//

METHOD IsAutoIncrement( cField, cTable ) CLASS TDolphinSrv

   LOCAL lAuto := .F.
   LOCAL aStruct
   LOCAL hRes 

   cField = D_LowerCase( cField )
   cTable = D_LowerCase( cTable )


   hRes = MySqlListFields( ::hMysql, cTable, cField )
   
   IF hRes != NIL
      ::CheckError() 
   ELSE   
      aStruct = MySqlResultStructure( hRes, D_SetCaseSensitive(), D_LogicalValue() ) 
      //MySqlFreeResult( hRes )/* NOTE: Deprecated */
      lAuto = IS_AUTO_INCREMENT( aStruct[ 1, MYSQL_FS_FLAGS ] )
   ENDIF
   
   hRes = NIL
   
RETURN lAuto 

//----------------------------------------------------//


METHOD LastDownData( cTable, cCol, uDef ) CLASS TDolphinSrv
   LOCAL xData  := uDef
   LOCAL oQuery := NIL
   LOCAL cQuery := ""

   DEFAULT cTable TO ""
   DEFAULT cCol   TO ""
   

   IF ! Empty( cTable ) .AND. ! Empty( cCol )
      cQuery := "SELECT " + D_LowerCase( cCol ) + " "
      cQuery += "FROM " + D_LowerCase( cTable ) + " "
      cQuery += "ORDER BY " + cCol + " DESC LIMIT 1"
      oQuery := ::Query( cQuery )
      IF oQuery:LastRec() > 0
         xData = oQuery:FieldGet( 1 )
      ENDIF

      oQuery:End()
      oQuery := NIL
   ENDIF

RETURN xData

//----------------------------------------------------//

METHOD LastInsertID() CLASS TDolphinSrv
   LOCAL oQry
   LOCAL nLast
   
   oQry = ::Query( "SELECT LAST_INSERT_ID() AS last" )
   nlast = oQry:Last 
   oQry:End()
   
RETURN nlast

//----------------------------------------------------//

METHOD ListDBs( cWild ) CLASS TDolphinSrv
   LOCAL aList
   aList = MySqlListDBs( ::hMysql, cWild ) 
   ::CheckError()
   
RETURN aList


//----------------------------------------------------//

   
METHOD ListTables( cWild ) CLASS TDolphinSrv
   LOCAL aList

   aList = MysqlListTbls( ::hMysql, cWild )
   ::CheckError()

RETURN aList

//---------------------------------------------//

METHOD MultiQuery( aQueries, lTransaction, bOnMultiQry ) CLASS TDolphinSrv

   LOCAL oError
   LOCAL cQuery
   LOCAL cLast
   LOCAL nIdx
   LOCAL nTotal
   

   DEFAULT lTransaction TO .T.
   DEFAULT bOnMultiQry  TO ::bOnMultiQry
   
   ::bOnMultiQry = bOnMultiQry

#ifndef NOINTERNAL
   IF Empty( aQueries ) 
      ::nInternalError = ERR_INVALIDQUERYARRAY
      ::CheckError()
      RETURN .F.
   ENDIF
#endif

   TRY
      IF lTransaction
         ::BeginTransaction()
      ENDIF
      
      nTotal = Len( aQueries ) - 1
      FOR EACH cQuery IN aQueries
         cLast = cQuery
         cQuery = StrTran( cQuery, CRLF, "" )
         IF ! Empty( cQuery )
            ::SqlQuery( cQuery )
            
            IF ::bOnMultiQry != NIL
#ifdef __HARBOUR__
               nIdx = cQuery:__EnumIndex() 
#else                      
               nIdx = HB_EnumIndex()
#endif 
               Eval( ::bOnMultiQry, nIdx, nTotal )
            
            ENDIF
         ENDIF
      NEXT
      
      IF lTransaction
         ::CommitTransaction()
      ENDIF
   
   CATCH oError
      MySqlRollBack( ::hMysql )
      ::RollBack()
#ifndef NOINTERNAL      
      ::nInternalError = ERR_MULTIQUERYFAULIRE
      ::CheckError( , cLast)
      RETURN .F.
#endif       
   END 

RETURN .T.

//---------------------------------------------//

METHOD ReConnect() CLASS TDolphinSrv

   LOCAL oQrs
      
   ::hMysql = ::Connect()
   FOR EACH oQrs IN ::aQueries
      oQrs:oServer = Self 
      oQrs:Refresh()
   NEXT

RETURN NIL

//---------------------------------------------//


METHOD RenameUser( cFromUser, cServer, cRename )  

   LOCAL cQry := ""

   cQry += "RENAME USER " 
   cQry += D_LowerCase( ClipValue2SQL( cFromUser ) )
   cQry += "@" + D_LowerCase( ClipValue2SQL( cServer ) )
   cQry += " TO " 
   cQry += D_LowerCase( ClipValue2SQL( cRename ) )
   cQry += "@" + D_LowerCase( ClipValue2SQL( cServer ) )


RETURN ::SqlQuery( cQry )


//---------------------------------------------//

METHOD Restore( cFile, lCancel, bOnRestore ) CLASS TDolphinSrv
   LOCAL aLine  := {}
   LOCAL cLine  := ""
   LOCAL cText  := ""
   LOCAL cTable := ""
   LOCAL nTLine := 0
   LOCAL hFile  := 0
   LOCAL lBegin := .f.
   LOCAL nCurLine := 0
   LOCAL nTotLine := 0
   LOCAL nIdx
   
   DEFAULT lCancel TO .F.
   
   DEFAULT bOnRestore TO ::bOnRestore
   
   ::bOnRestore = bOnRestore
   
#ifndef NOINTERNAL
   IF ! File( cFile )
      ::nInternalError = ERR_INVALIDBACKUPFILE
      ::CheckError()
      RETURN .F.
   ENDIF
#endif 
   
   IF ::bOnRestore != NIL 
      Eval( ::bOnRestore, ST_STARTRESTORE )
   ENDIF

   cText  = D_ReadFile( cFile )

   aLine := hb_ATokens( cText, CRLF )
   
   IF ! lCancel
      nTotLine = Len( aLine )
      FOR EACH cLine IN aLine
      
         IF lCancel
            EXIT
         ENDIF
#ifdef __XHARBOUR__             
         nIdx = HB_EnumIndex()
#else 
         nIdx = cLine:__EnumIndex()
#endif                 
         IF ::bOnRestore != NIL
            Eval( ::bOnRestore, ST_RESTORING, cTable, nTotLine, nIdx )
         ENDIF

         IF "CREATE DATABASE IF NOT EXISTS" $ cLine 
            ::SqlQuery( cLine )
            ::SelectDB( SubStr( cLine, RAt( " ", cLine ) + 1 ) )
            LOOP
         ENDIF
         IF "** BEGIN" $ cLine 
            cTable = SubStr( cLine, 9, Len( cLine ) - 9 ) 
         ENDIF
         IF Right( cLine, 1 ) == ";"
            cLine = SubStr( cLine, 1, Len( cLine ) - 1 )
         ENDIF
         
         IF "DROP TABLE" $ cLine
            ::SqlQuery( cLine )
         ENDIF
         IF "CREATE TABLE" $ cLine
            ::SqlQuery( cLine )
         ENDIF
         IF "LOCK TABLES" $ cLine
            ::SqlQuery( cLine )
         ENDIF
         IF "INSERT INTO" $ cLine
            ::SqlQuery( cLine )
         ENDIF
         IF "UNLOCK TABLES" $ cLine
            ::SqlQuery( cLine )
         ENDIF

      NEXT

   ENDIF
   
   IF ::bOnRestore != NIL
      Eval( ::bOnRestore, IIf( lCancel, ST_RSTCANCEL, ST_ENDRESTORE ) )
   ENDIF
   

RETURN ! lCancel



//---------------------------------------------//

METHOD RevokePrivileges( cHost, cUser, cDB, acPrivilegs ) CLASS TDolphinSrv
   LOCAL lReturn := .f.
   LOCAL cQuery  := ""
   LOCAL cPriv

   DEFAULT cHost     TO ::cHost
   DEFAULT cUser     TO ""
   DEFAULT cDB       TO "*"
   DEFAULT acPrivilegs TO "ALL PRIVILEGES"

   IF Empty( cHost ) .OR. Empty( cUser )
      RETURN lReturn
   ENDIF

   cHost     := Alltrim( cHost )
   cUser     := Alltrim( cUser )
   
   IF ValType( acPrivilegs ) == "A"
      cPriv = SQLStringFromArray( acPrivilegs )
   ELSE 
      cPriv = acPrivilegs
   ENDIF

   cQuery  := "REVOKE " + cPriv + " ON " + cDb + ".* FROM "
   cQuery  += "'" + cUser + "'@'" + cHost + "'"

RETURN ::SqlQuery( cQuery )

//----------------------------------------------------//

METHOD SelectDB( cDBName ) CLASS TDolphinSrv

   LOCAL nError 
   
   ::lError := .F.

#ifndef NOINTERNAL
   IF Empty( cDBName )
      ::nInternalError = ERR_EMPTYDBNAME
      ::CheckError()
      RETURN .F.
   ENDIF
#endif

   IF ( MysqlSelectDB( ::hMysql, cDBName ) ) != 0   // table not exist
      ::cDBName :=""
      ::lError  := .T.
      ::CheckError()
   ELSE                                       // table exist
      ::cDBName := cDBName
      ::lError  := .F.
      RETURN .T.
   ENDIF

RETURN .F.

//----------------------------------------------------//


METHOD SelectTable( aColumns, aTables, cWhere, cGroup, cHaving, cOrder, cLimit, lWithRoll ) CLASS TDolphinSrv

   LOCAL oQuery
   LOCAL cColumns, cTables
   LOCAL cQuery

   cQuery := BuildQuery( aColumns, aTables, cWhere, cGroup, cHaving, cOrder, cLimit, ,lWithRoll ) 

   oQuery = ::Query( cQuery )

RETURN oQuery

//----------------------------------------------------//

METHOD SetNameServer( cName ) CLASS TDolphinSrv

   LOCAL nHost 
   
   nHost = AScan( aHost, {| a | Upper( a[ 2 ] ) == Upper( ::cNameHost ) } )   
   
   IF nHost > 0 
      aHost[ nHost ][ 2 ] = cName
      ::cNameHost = cName
   ENDIF

RETURN NIL

//----------------------------------------------------//

METHOD SQLQuery( cQuery ) CLASS TDolphinSrv

   LOCAL nLen := If( ! Empty( cQuery ), Len( cQuery ), 0 )
   LOCAL nRet
      
   IF nLen > 0
#ifdef DEBUG
      IF ::bDebug != NIL 
         Eval( ::bDebug, cQuery, ProcName( 1 ), ProcLine( 1 ) )      
      ENDIF
#endif   
      IF ( nRet := MySqlQuery( ::hMysql, cQuery, nLen ) ) > 0
         ::CheckError()
      ENDIF
#ifndef NOINTERNAL      
   ELSE 
      ::nInternalError = ERR_NOQUERY
      ::CheckError()
      nRet = ::nInternalError
#endif       
   ENDIF

RETURN nRet == 0

//----------------------------------------------------//

METHOD TableStructure( cTable )  CLASS TDolphinSrv

   LOCAL aStruct := {}
   LOCAL n
   LOCAL hRes 


   hRes = MySqlListFields( ::hMysql, cTable )
   
   IF hRes != NIL
      ::CheckError() 
   ELSE
      aStruct = MySqlResultStructure( hRes, D_SetCaseSensitive(), D_LogicalValue() ) 
      //MySqlFreeResult( hRes ) /* NOTE: Deprecated */
      hRes = NIL      
      IF Len( aStruct ) == 0
         ::CheckError()
      ENDIF
   ENDIF
   
RETURN aStruct
   
//----------------------------------------------------//   
   
METHOD Update( cTable, aColumns, aValues, cWhere ) CLASS TDolphinSrv

   LOCAL cExecute
   LOCAL lRet, n
   LOCAL aStruc, nPos
   LOCAL cValue, cField
   LOCAL lError := .F.
   
   DEFAULT cWhere       TO ""
   
   aColumns = CheckArray( aColumns )
   aValues  = CheckArray( aValues )
   aStruc   = ::TableStructure( cTable )


#ifndef NOINTERNAL   
   IF Empty( aColumns ) .OR. Empty( aValues )
      ::nInternalError = ERR_EMPTYVALUES
      ::CheckError()
      RETURN .F. 
   ENDIF 
      
   IF Empty( cTable ) 
      ::nInternalError = ERR_EMPTYTABLE
      ::CheckError()
      RETURN .F. 
   ENDIF 
   
   IF Len( aColumns ) # Len( aValues )
      ::nInternalError = ERR_NOMATCHCOLUMNSVALUES
      ::CheckError()
      RETURN .F. 
   ENDIF 
  
#endif    
   cExecute := "UPDATE " + D_LowerCase( cTable ) + " SET "
   FOR EACH cField IN aColumns
#ifdef __XHARBOUR__
            n = HB_EnumIndex()
#else                      
            n = cField:__EnumIndex() 
#endif 
      nPos = AScan( aStruc, {| aRow | Lower( AllTrim( aRow[ MYSQL_FS_NAME ] ) )  == Lower( cField ) } )
#ifndef NOINTERNAL         
      IF nPos == 0
         ::nInternalError = ERR_INVALIDFIELDNAME
         ::CheckError()
         RETURN .F.
      ENDIF
#endif      
      IF HB_IsArray( aValues[ n ] ) 
         cValue   = ClipValue2SQL( aValues[ n ][ 1 ], aStruc[ nPos ][ MYSQL_FS_CLIP_TYPE ] )
         IF aStruc[ nPos ][ MYSQL_FS_CLIP_TYPE ] == "M"
            cExecute += cField + " = CONCAT(" + cField + ", " + cValue + "),"
            cExecute += cField + " = " + cField + " + " + cValue + ","
         ENDIF         
      ELSE 
         cValue   = ClipValue2SQL( aValues[ n ], aStruc[ nPos ][ MYSQL_FS_CLIP_TYPE ] )
         cExecute += cField + " = " + cValue + ","
      ENDIF

   NEXT 
   
   IF ! lError
      //Delete last comma 
      cExecute = SubStr( cExecute, 1, Len( cExecute ) - 1 )
      IF !Empty( cWhere )
         cExecute += " WHERE " + cWhere
      ENDIF
      lRet = ::SqlQuery( cExecute )   
   ELSE 
      lRet = .F.
      ::lError = lError
      ::CheckError()
   ENDIF


RETURN lRet   
   
//----------------------------------------------------//
//----------------------------------------------------//
//----------------------------------------------------//
//----------------------------------------------------//

FUNCTION ClipValue2SQL( Value, cType, lTxt, lNoNull ) // Compatibility wint TMysql


   LOCAL cValue := ""
   LOCAL cTxt   
   
   DEFAULT lTxt TO .T.
   DEFAULT cType TO ValType( Value )
   DEFAULT lNoNull TO .F.

   cTxt   := If( lTxt, "'", "" )

   SWITCH cType
      CASE "N"
      CASE "I"

         if Value != NIL .OR. lNoNull
            cValue := AllTrim( Str( Value ) )
         else
            cValue := "NULL"
         endif

         EXIT

      CASE "D"
         if ! Empty( Value ) .OR. lNoNull
            cValue := cTxt + Transform( Dtos( Value ), "@R 9999-99-99" ) + cTxt
         else
            cValue := "NULL"
         endif
         EXIT

      CASE "C"
         if ! Empty( Value ) .OR. lNoNull
            cValue := cTxt + AllTrim( Value ) + cTxt
         else
            cValue := "NULL"
         endif
         EXIT

      CASE "M"
         IF Empty( Value)
            cValue := "" + cTxt + cTxt + ""
         ELSE
            cValue := cTxt + Val2Escape( value ) + cTxt
         ENDIF
         EXIT

      CASE "L"
         cValue := AllTrim( Str( If( Value, 1, 0 ) ) )
         EXIT

      CASE "T"
         cValue := iif( Value < 0, "NULL", Alltrim( Str( Value ) ) )
         EXIT

#ifdef __XHARBOUR__
      DEFAULT
#else 
      OTHERWISE
#endif
         cValue := "" + cTxt + cTxt + ""

   END

RETURN cValue

//----------------------------------------------------//

FUNCTION SqlDate2Clip( cField )
RETURN  SToD( Left( cField, 4 ) + substr( cField, 6, 2 ) + right( cField, 2 ) )

//----------------------------------------------------//
// Return string from array separated with ","
FUNCTION SqlStringFromArray( aArray )
   
   LOCAL cItem, cString := ""
   

   FOR EACH cItem IN aArray
      cString += D_LowerCase( cItem ) + ", "
   NEXT
   
   cString = Left( cString, Len( cString ) - 2 )
   
RETURN cString

//----------------------------------------------------//

STATIC FUNCTION VerifyStructure( aStruct )
   
   LOCAL aRow 
   LOCAL nError
   
   FOR EACH aRow IN aStruct
      IF Len( aRow ) < DBS_DEFAULT 
         nError = ERR_INVALID_STRUCT_ROW_SIZE
         EXIT 
      ENDIF
      IF ValType( aRow[ DBS_NOTNULL ] ) != "U" .AND. ValType( aRow[ DBS_NOTNULL ] ) != "L"  
         nError = ERR_INVALID_STRUCT_NOTNULL_VALUE
         EXIT 
      ENDIF
   NEXT 

RETURN nError
         
//----------------------------------------------------//         

STATIC FUNCTION fNotNull( aField, cPrimaryKey, cAuto )         
   LOCAL cRet := ""
   
   IF ValType( aField[ DBS_NOTNULL ] ) == "L" .AND. aField[ DBS_NOTNULL ]
      cRet = " NOT NULL "
   ELSE 
      IF D_LowerCase( aField[ DBS_NAME ] ) == cPrimaryKey .OR. D_LowerCase( aField[ DBS_NAME ] ) == cAuto
         cRet = " NOT NULL "
      ENDIF
   ENDIF

RETURN cRet

//----------------------------------------------------//         

FUNCTION ArrayFromSqlString( cString )
   
   LOCAL aArray
   
   aArray := HB_ATokens( cString, "," )
   
RETURN aArray

//----------------------------------------------------//         

FUNCTION BuildQuery( aColumns, aTables, cWhere, cGroup, cHaving, cOrder, cLimit, lWithRoll )
   LOCAL cQuery := ""
   LOCAL cColumns
   
   DEFAULT cWhere   TO ""
   DEFAULT cGroup   TO ""
   DEFAULT cHaving  TO ""
   DEFAULT cOrder   TO ""
   DEFAULT cLimit   TO ""
   DEFAULT aTables  TO {}
   DEFAULT aColumns TO {}
   DEFAULT lWithRoll TO .F.


   cColumns = SQLStringFromArray( aColumns )
   
   IF Empty( cColumns )
      cColumns = "*"
   ENDIF

   cQuery := "SELECT " + cColumns

   IF !Empty( aTables )
      cQuery += " FROM "
      cQuery += SQLStringFromArray( aTables )
   ENDIF
   
   IF !Empty( cWhere )
      cQuery += " WHERE "
      cQuery += cWhere
   ENDIF
   IF !Empty( cGroup )
      cQuery += " GROUP BY "
      cQuery += cGroup
      IF lWithRoll
         cQuery += " WITH ROLLUP"
      ENDIF
   ENDIF
   IF !Empty( cHaving )
      cQuery += " HAVING "
      cQuery += cHaving
   ENDIF
   IF !Empty( cOrder )
      cQuery += " ORDER BY "
      cQuery += cOrder
   ENDIF
   IF !Empty( cLimit )
      cQuery += " LIMIT "
      cQuery += cLimit
   ENDIF

RETURN cQuery

//----------------------------------------------------//  

FUNCTION BuildInsert( cTable, aColumns, aValues, lForceValue  )  

   LOCAL cExecute
   LOCAL cValues  := ""
   LOCAL cColumns := ""
   LOCAL uValue
   LOCAL n
   
   DEFAULT lForceValue TO .F.
   
   FOR n = 1 TO Len( aColumns )
      cColumns += aColumns[ n ] + ","
      IF ValType( aValues[ n ] ) == "C" .AND. ! lForceValue
         uValue = Val2Escape( aValues[ n ] ) 
      ELSE 
         uValue = aValues[ n ]
      ENDIF
      cValues += ClipValue2SQL( uValue ) + ","
   NEXT 
   
   //Delete last coma 
   cColumns = SubStr( cColumns, 1, Len( cColumns ) - 1 ) + ") VALUES ( "
   cValues  = SubStr( cValues, 1, Len( cValues ) - 1 ) + ")"
   
   cExecute = "INSERT INTO " + D_LowerCase( cTable ) + " ( " + cColumns + cValues

RETURN cExecute

//----------------------------------------------------//  

FUNCTION Clip2Str( uValue, cPicture )
   
   LOCAL cType := ValType( uValue )
   LOCAL cValue, cdf
   
   SWITCH cType 
      CASE "N"
         cValue = Transform( uValue, cPicture )
         EXIT 
      CASE "L"
         cValue = If( uValue, ".T.", ".F." )
         EXIT 
      CASE "D"
      
         cValue = Transform( uValue, cPicture )
         EXIT 
#ifdef __XHARBOUR__
      DEFAULT
#else 
      OTHERWISE
#endif   
      cValue = Transform( uValue, cPicture )
   ENDSWITCH
   
RETURN cValue            
         

//----------------------------------------------------//  

// Turn On/Off case sensitive use
// return Last Status
FUNCTION D_SetCaseSensitive( lOnOff )

  LOCAL lOldStatus

  STATIC lStatus := .F.

  lOldStatus = lStatus

  IF PCount() == 1 .AND. ValType( lOnOff ) == "L"
     lStatus = lOnOff
  ENDIF

RETURN lOldStatus


// Turn On/Off PadRight
// return Last Status
// default is ON
FUNCTION D_SetPadRight( lOnOff )

  LOCAL lOldStatus

  STATIC lStatus := .T.

  lOldStatus = lStatus

  IF PCount() == 1 .AND. ValType( lOnOff ) == "L"
     lStatus = lOnOff
  ENDIF

RETURN lOldStatus

//----------------------------------------------------//  
// Convert lower case if case sesitive is off
FUNCTION D_LowerCase( cText )

   IF ! D_SetCaseSensitive()
      cText = Lower( AllTrim( cText ) )
   ELSE 
      cText = AllTrim( cText )
   ENDIF
   
RETURN cText
   
//----------------------------------------------------//  
// Set logical values to default Mysql Values (1/0)->lOldStatus
FUNCTION D_LogicalValue( lOnOff )

  LOCAL lOldStatus

  STATIC lStatus := .T.

  lOldStatus = lStatus

  IF PCount() == 1 .AND. ValType( lOnOff ) == "L"
     lStatus = lOnOff
  ENDIF

RETURN lOldStatus
   
//----------------------------------------------------//  

FUNCTION SetServerDefault( oServer ) ; oServerDefault := oServer ; return nil

//----------------------------------------------------//  

FUNCTION GetServerDefault() ; return oServerDefault

//----------------------------------------------------//  

FUNCTION GetServerFromName( cName )
   LOCAL nHost, oServer
   
   IF cName == NIL 
      RETURN NIL
   ENDIF
 
   nHost = AScan( aHost, { | a | Upper( a[ 2 ] ) == Upper( cName ) } ) 

   IF nHost > 0
      oServer = aHost[ nHost ][ 1 ] 
   ENDIF 

RETURN oServer


//----------------------------------------------------//  

FUNCTION _SelectHost( uParam )
   LOCAL lError := .F.
   LOCAL nHost, oServer
   LOCAL cReturn

   IF hb_IsObject( uParam )
      IF uParam:IsKindOf( "TDOLPHINQRY" )
         SetServerDefault( uParam:oServer )
      ELSEIF uParam:IsKindOf( "TDOLPHINSRV" )
         SetServerDefault( uParam )
      ELSE 
         lError = .T.
      ENDIF
   ELSEIF hb_IsString( uParam )
       oServer = GetServerFromName( uParam )
       IF oServer != NIL
          SetServerDefault( oServer )
       ELSE 
          lError = .T.
       ENDIF 
   ENDIF 
   
   IF lError 
      Dolphin_DefError( NIL, ERR_INVALIDHOSTSELECTION, .T. )
      RETURN NIL
   ENDIF 

RETURN GetServerDefault():cNameHost

//----------------------------------------------------//  

PROCEDURE _BackupMySql( oServer, aTables, cFile, lDrop, lOverwrite, ;
                         nStep, cHeader, cFooter, lCancel, bOnBackup )
                         
   DEFAULT oServer TO GetServerDefault()
   
   oServer:Backup( aTables, cFile, lDrop, lOverwrite, ;
                         nStep, cHeader, cFooter, @lCancel, bOnBackup )

RETURN

//----------------------------------------------------//  

PROCEDURE _BeginTransaction( oServer )

   DEFAULT oServer TO GetServerDefault()
   
   oServer:BeginTransaction()

RETURN

//----------------------------------------------------//  

PROCEDURE _CloseHosts( uParam )
   
   LOCAL oServer, nHost

   IF hb_IsObject( uParam )
      uParam:End()
   ELSEIF hb_IsString( uParam )
      uParam = AllTrim( Upper( uParam ) ) 
      IF uParam == "ALL"
         AEval( aHost, {| aRow | aRow[ 1 ]:End() } )
      ELSE 
         oServer = GetServerFromName( uParam )
         IF oServer == NIL 
            Dolphin_DefError( NIL, ERR_INVALIDHOSTSELECTION, .T. )
            RETURN
         ENDIF             
         oServer:End()
      ENDIF
   ENDIF 

RETURN

//----------------------------------------------------//  

PROCEDURE _CommitTransaction( oServer )

   DEFAULT oServer TO GetServerDefault()
   oServer:CommitTransaction()

RETURN

//----------------------------------------------------//  

PROCEDURE _ExecuteScript( oServer, cFile, bOnScrip )

   DEFAULT oServer TO GetServerDefault()
   oServer:ExecuteScript( cFile, bOnScrip )

RETURN  

//----------------------------------------------------//  

PROCEDURE _InsertMysql( oServer, cTable, aColumns, aValues )

   DEFAULT oServer TO GetServerDefault()
   
   oServer:Insert( cTable, aColumns, aValues )

RETURN

//----------------------------------------------------//  

PROCEDURE _UpdateMysql( oServer, cTable, aColumns, aValues, cWhere  )

   DEFAULT oServer TO GetServerDefault()
   
   oServer:Update( cTable, aColumns, aValues, cWhere )

RETURN

//----------------------------------------------------//  

PROCEDURE _RestoreMySql( oServer, cFile, lCancel, bOnRestote )
                         
   DEFAULT oServer TO GetServerDefault()
   
   oServer:Restore( cFile, @lCancel, bOnRestote )

RETURN

//----------------------------------------------------//  

PROCEDURE _RollBack( oServer )

   DEFAULT oServer TO GetServerDefault()
   oServer:RollBack()

RETURN

//----------------------------------------------------//  

FUNCTION _SelectTable( oServer, aColumns, aTables, cWhere,;
                       cGroup, cHaving, cOrder, cLimit, lWithRoll )

   LOCAL oQuery

   DEFAULT oServer TO GetServerDefault()
   
   aColumns = CheckArray( aColumns )
   aTables  = CheckArray( aTables )
   
   oQuery = oServer:SelectTable( aColumns, aTables, cWhere, cGroup, ;
                                 cHaving, cOrder, cLimit, lWithRoll )

RETURN oQuery                                    

//----------------------------------------------------//  

static function CheckArray( aArray )

   if ValType( aArray ) == 'A' .and. ;
      Len( aArray ) == 1 .and. ;
      ValType( aArray[ 1 ] ) == 'A'

      aArray   := aArray[ 1 ]
   endif

return aArray
   
//----------------------------------------------------//  

PROCEDURE Dolphin_DefError( oServer, nError, lInternal, cExtra )
   LOCAL cText := ""
   LOCAL oError
   
   DEFAULT cExtra TO ""

   oError := ErrorNew()
   oError:SubSystem   = If( lInternal, "TDOLPHIN", "MYSQL" )
   oError:SubCode     = nError
   oError:Severity    = 2
   oError:Description = If( lInternal, "Internal Error", oServer:ErrorTxt() ) + " " + cExtra
   
   Eval( ErrorBlock(), oError )   

RETURN 



