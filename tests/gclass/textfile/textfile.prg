#include "gclass.ch"

Function Main()
     Local oFile := gTextFile():New( "crea.txt", "W" )
    
    oFile:WriteLn( "Esto es lo que vamos a escribir para saber" )
    oFile:WriteLn( "que todo es correcto" )
    oFile:WriteLn( "Puede ser " + CRLF + " si si si " )

    oFile:Close()

    oFile :=  gTextFile():New( "crea.txt", "R" )
    
    Msginfo( oFile:GetText(), "Texto" )
    
    oFile:Close()

Return NIL
   
