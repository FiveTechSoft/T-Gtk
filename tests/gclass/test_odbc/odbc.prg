//---------------------------------------------------------------------------//
// Ejemplo de conexion entre Browse T-Gtk y ODBC
// Usando la libreria de Harbour /source/odbc
//---------------------------------------------------------------------------//
#include "gclass.ch"

//----------------------------------------------------------------------------//
// Procedimiento principal de arranque

procedure main()
   LOCAL cConStr   := ;
      "DBQ=./bd1.mdb;" + ;
      "Driver={Microsoft Access Driver (*.mdb)}"

    LOCAL oDataSource := TODBC():New( cConStr )
    
    oDataSource:SetSQL( "SELECT * FROM table1" )
    if oDataSource:Open()
       GestBrw( oDataSource )
       oDataSource:Close()
    else
       MsgStop( "No fue posible abrir bd1.mdb" )
    endif

    oDataSource:Destroy()

return 

static procedure GestBrw( oDataSource )

    local oBrw
    local nKey, n, nFld
    local oWnd

    if oDataSource:RecCount() < 1 // Comprobamos que hay registros
        MsgAlert( "No hay registros" )
        return
    endif

    DEFINE WINDOW oWnd TITLE "Browse dinamic ODBC" SIZE 800,600
        
        DEFINE BROWSE oBrw ;
               OF oWnd CONTAINER

        // Movimientos 
        oBrw:bLogicLen = { || oDataSource:RecCount() }
        oBrw:bGoTop    = { || oDataSource:First() }
        oBrw:bGoBottom = { || oDataSource:Last() }
        oBrw:bSkip     = { | nSkip | Skipped( nSkip, oDataSource ) }
  
        nFld := len( oDataSource:Fields )

        FOR n := 1 TO nFld  
            ADD COLUMN  TO BROWSE oBrw ;
                DATA  ODBCFget( oDataSource:Fields[n]:FieldName, oDataSource ) ;
                HEADER oDataSource:Fields[n]:FieldName ;
                SIZE 150
        NEXT

    ACTIVATE WINDOW oWnd

RETURN 

//----------------------------------------------------------------------------//
STATIC FUNCTION ODBCFGet( cFieldName, oDataSource )
   
   IF VALTYPE( cFieldName ) = "C"
      // For changing value rather write a decent SQL statement
      RETURN {| x | iif( x == NIL, oDataSource:FieldByName(cFieldName):value, "" ) }
   ENDIF

RETURN ""

//----------------------------------------------------------------------------//
STATIC FUNCTION Skipped( nRecs, oDataSource )

   LOCAL nSkipped := 0
   IF .not. oDataSource:Eof()
      IF nRecs == 0
         // ODBC doesn't have skip(0)
      ELSEIF nRecs > 0 
         DO WHILE nSkipped < nRecs
           IF .NOT. oDataSource:Eof()
             oDataSource:next( )
             IF oDataSource:Eof()
               oDataSource:prior( )
               EXIT
             ENDIF
             nSkipped++
           ENDIF  
         ENDDO
      ELSEIF nRecs < 0
         DO WHILE nSkipped > nRecs
           IF .NOT. oDataSource:Bof()
             oDataSource:prior( )
             IF oDataSource:Bof()
               EXIT
             ENDIF
             nSkipped--
           ENDIF  
         ENDDO
      ENDIF
   ENDIF
RETURN nSkipped
