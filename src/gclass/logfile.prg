#include "fileio.ch"

#define CRLF HB_OsNewLine()

function LogFile( cFile, aInfo )

   local hFile, cLine := DToC( Date() ) + " " + Time() + ": ", n

   for n = 1 to Len( aInfo )
      cLine += cValToChar( aInfo[ n ] ) + Chr( 9 )
   next
   cLine += CRLF

   if ! File( cFile )
      FClose( FCreate( cFile ) )
   endif

   if( ( hFile := FOpen( cFile, FO_WRITE ) ) != -1 )
      FSeek( hFile, 0, FS_END )
      FWrite( hFile, cLine, Len( cLine ) )
      FClose( hFile )
   endif

return nil