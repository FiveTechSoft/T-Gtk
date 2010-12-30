#include "tgtk.ch"

#define CRLF hb_osnewline()

//---------------------------------------------------------------------------//

function WQout( aParams )

    local cOut := ""

    if valtype( aParams ) == "A"
       AEval( aParams, { | c |  cOut :=  cOut + CRLF + cValToChar( c ) } )
       Msginfo( cOut )
    endif

return nil

/* Salida a consola, con todos los valores, útil para ver valores sin parar el programa en un punto*/
function gQout( aParams )

    local cOut := ""

    if valtype( aParams ) == "A"
       AEval( aParams, { | c |  cOut :=  cOut + CRLF + ValToPrg( c ) } )
       g_print( cOut )
    endif

return nil
