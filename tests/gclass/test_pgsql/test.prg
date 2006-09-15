/*
 *
 * $Id: test.prg,v 1.1 2006-09-15 00:28:09 riztan Exp $
 *
 */

#include "postgres.ch"

Function main()
    Local conn, res, aTemp, i, x,y, pFile
    Local cDb := 'mydb'
    Local cUser := 'NombreUsuario'
    Local cPass := 'AquiVaLaClave'
	 Local iPort := 5432

    CLEAR SCREEN

//	? "Base de Datos: ",cDb
//	? "Usuario: ",cUser

    conn := PQsetdbLogin( 'localhost', STR(iPort), NIL, NIL, cDb, cUser, cPass)
//    ? "PQdb: ",PQdb(conn), "PQuser:",PQuser(conn), "PQpass:",PQpass(conn), "PQhost:",PQhost(conn), "PQport:",PQport(conn), "PQtty:",PQtty(conn), "PQoptions:",PQoptions(conn)
MsgBox("Base de Datos: "+PQdb(conn)+". Usuario: "+PQuser(conn)+". Host: "+PQhost(conn))
    ? PQClose(conn)

    conn := PQConnect(cDb, 'localhost', cuser, cpass, iPort)

    ? "Estatus de la Conexion: ",PQstatus(conn)," ErrorMsg:", PQerrormessage(conn)

    if PQstatus(conn) != CONNECTION_OK
		voy("Error en la Conexion..")
        quit
    endif
/*
    ? "Blocking: ", PQisnonblocking(conn), PQsetnonblocking(conn, .t.), PQisnonblocking(conn)


*/
    pFile := PQcreatetrace( 'trace.log' )
    PQtrace( conn, pFile )


    ? "Verbose: ", PQsetErrorVerbosity(conn, 2)

    ? "Protocol: ", PQprotocolVersion(conn), ;
      " Server Version: ", PQserverVersion(conn), ;
      " Client Encoding: ", PQsetClientEncoding(conn, "ASCII"), "New encode: ", PQclientEncoding(conn)

    //? "PQdb: ",PQdb(conn), "PQuser:",PQuser(conn), PQpass(conn), PQhost(conn), PQport(conn), PQtty(conn), PQoptions(conn)

    res := PQexec('drop table products')
    ? PQresultStatus(res), PQresultErrorMessage(res)

    PQclear(res)

    res := PQexec(conn, 'create table products ( product_no numeric(10), name varchar(20), price numeric(10,2) );')
	//PQexec(conn, 'commit')
    ? "PQresult:",PQresultStatus(res), "PQresultErrorMessage",PQresultErrorMessage(res)
	
    //res := PQexec('select * from weather')
    //? PQresultStatus(res)
    //? res

    res:=PQexec(conn,'SELECT * from products')
    ? "Respuesta: ", PQresultStatus(res), PQoidValue(res),
	PQresultErrorMessage(res)
    res := PQexec(conn,'insert into products(product_no, name, price) values ($1, $2, $3)')
    ? PQoidValue(res)
    res := PQexecParams(conn, 'insert into products(product_no, name, price) values ($1, $2, $3)', {'2', 'bread', '10.95'})
    ? "Oid Row: ", PQoidValue(res), PQoidStatus(res)



    if PQresultStatus(res) != PGRES_COMMAND_OK
        ? PQresultStatus(res), PQresultErrorMessage(res)
    endif
    PQclear(res)

    res := PQexec(conn, 'select price, name, product_no as "produto" from products')

    if PQresultStatus(res) != PGRES_TUPLES_OK
        ? PQresultStatus(res), PQresultErrorMessage(res)
    endif

    ? "Binary: ", PQbinaryTuples(res)
    ? "Rows: ", PQntuples(res), "Cols: ", PQnfields(res)
    ? PQfname(res, 1), PQftable(res, 1), PQftype(res, 1), PQfnumber(res, "name"), PQfmod(res, 1), PQfsize(res, 1), PQgetisnull(res,1,1)
    ? "Prueba :", PQGetValue(res, 1,1), PQGetValue(res, 1, 2), PQGetValue(res, 1,3)
    MsgBox(PQFName(res, 1)+": "+PQGetValue(res, 1,1)+" "+PQFName(res,2)+": "+PQGetValue(res,1,2)+" "+PQFName(res,3)+": "+PQGetValue(res,1,3))

    aTemp := PQmetadata(res)

    for x := 1 to len(aTemp)
        ? "Linha 1: "
        for y := 1 to 6
            ?? aTemp[x,y], ", "
        next
    next

    ? PQFcount(res)

    ? PQlastrec(res)

    ? PQGetvalue(res,1, 2)

    ? PQclear(res)

    ? "Large Objects, always should be in a transaction..."

    res := PQexec(conn, 'begin')
    PQclear(res)

    ? (x := lo_Import( conn, 'test.prg' ))
    ? lo_Export( conn, x, 'test.new' )
    ? lo_Unlink( conn, x )

    res := PQexec(conn, 'commit')
    PQclear(res)

    PQuntrace( conn )
    PQclosetrace( pFile )
    PQClose(conn)
    return nil
