/*
 *
 * $Id: test.prg,v 1.2 2008-10-22 19:59:27 riztan Exp $
 *
 */

/*
 *  Ejemplo basado en el test de Rodrigo Moreno en la contrib de 
 *  xHarbour.
 *
 *  Riztan Gutierrez.
 */
#include "postgres.ch"
#include "gclass.ch"

Function Login(cHost,cDB,cUser,cPass,nPort)
    Local conn, res, aTemp, i, x,y, pFile,nTime,cTime,cSql
    Local cPQStatus

    Local cStatus_Conexion:="<b>Estatus de la conexión:</b> "
    Local cConexion_Error :="<b>Error:</b> "

    Default cHost := 'localhost'
    Default cDb   := 'postgres'
    Default cUser := 'postgres'
    Default cPass := '1234'
	 Default nPort := 5432

    conn := PQsetdbLogin( cHost, STR(nPort), NIL, NIL, cDB, cUser, cPass)

    conn := PQConnect(cDB, cHost, cUser, cPass, nPort)


    if PQStatus(conn) != CONNECTION_OK
       cPQStatus := Alltrim( STR( PQStatus(conn) ) )
       MsgStop( cStatus_Conexion+cPQStatus+CRLF+;
                cConexion_Error+( PQErrorMessage(conn) ),;
                "Error en la conexión" )
       Return .F.
       // quit
    endif

    pg_verbose( conn, PQERRORS_VERBOSE )


    // ---- Informacion sobre protocolo de comunicacion.
    MsgInfo( "<b>Protocolo.</b>(1.0, 2.0, 3.0)"+CRLF+;
             "2.0 corresponde a version PostgreSQL menor a 7.4 "+CRLF+;
             "<span color='red'><b>Nota: 1.0 ya no es soportado en libpq</b></span>"+CRLF+CRLF+;
             "<b>En esta conexion... </b> "+Alltrim( Str( PQprotocolVersion(conn) ) ),;
             "Protocolo de Conexion" )


    // ---- Version del Servidor.
    MsgInfo( "<b>PostgreSQL Server Version:</b> "+Alltrim( Str( PQServerVersion(conn) ) ),;
             "Version del Servidor." )


    // ---- Codificacion utilizada en cliente.
    MsgInfo( "<b>Client Encoding:</b> "+;
             pg_encoding_to_char( PQclientEncoding(conn) ),;
             "Codificacion Cliente" )

    nTime := SECONDS()
    res   := PQexec(conn, 'select * from products limit 1;')
    cTime := AllTrim(Str( SECONDS()-nTime ))

/*
    MsgInfo( "<b>Instruccion:</b> 'select * from products limit 1;'"+CRLF+CRLF+;
             "ResultStatus "+Str(PQRESULTSTATUS(res))+" = "+PQResStatus(PQRESULTSTATUS(res))+CRLF+;
             "<span color='blue'>Respuesta en: "+cTime+" segundos</span>",;
             "Resultado" )  
*/

    If PQResultStatus(res) = PGRES_TUPLES_OK

       nTime := SECONDS()
       res   := PQexec(conn, 'drop table products;')
       cTime := AllTrim(Str( SECONDS()-nTime ))

       MsgInfo( "<b>Instruccion:</b> 'drop table products;'"+CRLF+CRLF+;
                "ResultStatus "+Str(PQRESULTSTATUS(res))+" = "+PQResStatus(PQRESULTSTATUS(res))+CRLF+;
                "<span color='blue'>Respuesta en: "+cTime+" segundos</span>",;
                "Resultado" )

    EndIf


//    MsgInfo( "ErrorMessage "+PQErrorMessage(res) )

    PQclear(res)


    nTime := SECONDS()
    res   := PQexec(conn, 'create table customer ( '+;
                          'FIRST    varchar(20),   '+;
                          'LAST     varchar(20),   '+;
                          'SET      boolean,       '+;
                          'STREET   varchar(30),   '+;
                          'CITY     varchar(30),   '+;
                          'STATE    varchar(2),    '+;
                          'ZIP      varchar(10),   '+;
                          'HIREDATE date,          '+;
                          'MARRIED  boolean,       '+;
                          'AGE      numeric(2),    '+;
                          'SALARY   numeric(10,2), '+;
                          'NOTES    text, '+;
                          'CONSTRAINT "llave-primaria" '+;
                                'PRIMARY KEY (FIRST,LAST,STREET,CITY) '+;
                          ');')

    cTime := AllTrim(Str( SECONDS()-nTime ))

    MsgInfo( "Al intentar crear la tabla <b>customer</b>. "+CRLF+;
             "ResultStatus "+Str(PQRESULTSTATUS(res))+" = "+PQResStatus(PQRESULTSTATUS(res))+CRLF+;
             "<span color='blue'>Respuesta en: "+cTime+" segundos</span>",;
             "Resultado" )

    // ---- Tomando valores de customer.dbf y llevarlos a la tabla de postgresql
    SELECT A
    USE "../../CUSTOMER.DBF"
    
    nTime := SECONDS()
    WHILE !Eof()

       res := PQExec(conn, 'insert into customer values ('+;
                           xToSQL(A->FIRST)   +','+;    
                           xToSQL(A->LAST)    +','+;    
                           xToSQL(A->SET)     +','+;    
                           xToSQL(A->STREET)  +','+;    
                           xToSQL(A->CITY)    +','+;    
                           xToSQL(A->STATE)   +','+;    
                           xToSQL(A->ZIP)     +','+;    
                           xToSQL(A->HIREDATE)+','+;    
                           xToSQL(A->MARRIED) +','+;    
                           xToSQL(A->AGE)     +','+;    
                           xToSQL(A->SALARY)  +','+;    
                           xToSQL(A->NOTES)+');')

       SKIP
    ENDDO
    cTime := AllTrim(Str( SECONDS()-nTime ))
    
    USE

    MsgInfo( "Al insertar los registros en la tabla <b>customer</b>. "+CRLF+;
             "ResultStatus "+Str(PQRESULTSTATUS(res))+" = "+PQResStatus(PQRESULTSTATUS(res))+CRLF+;
             "<span color='blue'>Respuesta en: "+cTime+" segundos</span>",;
             "Resultado" )


    PQclear(res)

    res := PQexec(conn,'select * from customer;')

    MsgInfo( "select * from <b>customer</b>. "+CRLF+;
             "ResultStatus "+Str(PQRESULTSTATUS(res))+" = "+PQResStatus(PQRESULTSTATUS(res))+CRLF+;
             "<span color='blue'>Respuesta en: "+cTime+" segundos</span>",;
             "Resultado" )
    
    IF PQRESULTSTATUS(res) = PGRES_TUPLES_OK
       MsgInfo( "select * from <b>customer</b>; "+CRLF+;
                "Tuplas Binarias?: "+CStr(PQbinaryTuples(res))+CRLF+;
                "Nro de Lineas   : <b>"+Alltrim( CStr( PQntuples(res) ) )+"</b>"+CRLF+;
                "Nro de Columnas : <b>"+Alltrim( CStr( PQnfields(res) ) )+"</b>",;
                "Resultado de la Consulta.";
              )
    ENDIF


    // Cerrando la conexion
    PQClose(conn)


Return .T.




Static Function pg_verbose(conn,nMode)
   Local cVerboseMode

   PQsetErrorVerbosity(conn, nMode)

   switch nMode

      case 0 
         cVerboseMode:="TERSE" 
         exit
      case 1 
         cVerboseMode:="DEFAULT"
         exit
      case 2 
         cVerboseMode:="VERBOSE"
         exit
    end 

    MsgInfo( "<b>Modo Verboso: </b>" + cVerboseMode )

Return


//--------------------------------------------------------------//
// Funcion Variante de CStr.
FUNCTION XtoSQL( xExp )

   LOCAL cType

   IF xExp == NIL
      RETURN 'NIL'
   ENDIF

   cType := ValType( xExp )

   DO CASE
      CASE cType = 'C'
         RETURN "'"+xExp+"'"

      CASE cType = 'D'
           RETURN "'"+Transform(xExp,"DD/MM/YYYY")+"'"

      CASE cType = 'L'
         RETURN IIF( xExp, 'true', 'false' )

      CASE cType = 'N'
         RETURN Alltrim(Str( xExp ))

      CASE cType = 'M'
         RETURN "'"+Alltrim(xExp)+"'"

      CASE cType = 'A'
         RETURN "'{ Array of " +  LTrim( Str( Len( xExp ) ) ) + " Items }'"

      CASE cType = 'B'
         RETURN "'{|| Block }'"

      CASE cType = 'O'
         RETURN "'{ " + xExp:ClassName() + " Object }'"

      OTHERWISE
         RETURN "'Type: " + Alltrim(cType)+"'"
   ENDCASE

RETURN ""

//EOF
