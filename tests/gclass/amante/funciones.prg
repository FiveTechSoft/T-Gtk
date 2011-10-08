/*
Funciones diversas de ayuda a los distintos mantenimientos
(c)2011 Rafa Carmona
*/

/*
  cQry   := Select a realizar
  uField := Campo que queremos introducir en el array
  Devuelve un array simple

*/
MEMVAR oServer
#include "gclass.ch"
#include "tdolphin.ch"

function FillSimpleArray( cQry, uField, lAlltrim )
   Local aCadenas := {}
   Local oData
   
   if lAlltrim = NIL
      lAlltrim :=.T.
   endif
   
   oData   := oServer:Query( cQry )
   while !oData:Eof() 
         AADD( aCadenas, if( valtype( oData:&uField ) = "C" .and. lAlltrim, alltrim( oData:&uField ),oData:&uField ) )
         oData:Skip()
   end while

return aCadenas

function DeleteQry( cQry ) 
Local lResult := .f., oError
  try
    lResult := oServer:Execute( cQry )
  catch oError
    MsgStop( oError:Description, "Alerta" )
  end
return lResult