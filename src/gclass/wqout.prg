#include "tgtk.ch"

#define CRLF chr(13) + chr(10)

//---------------------------------------------------------------------------//

function WQout( aParams )

    local cOut := ""

    if valtype( aParams ) == "A"
       AEval( aParams, { | c |  cOut :=  cOut + CRLF + cValToChar( c ) } )
       Msginfo( cOut )
    endif

return nil
