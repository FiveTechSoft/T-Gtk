/* CLASS TTexFile basada en el trabajo de Eddie Runia <eddie@runia.comu>
 * y donada al dominio publico.
 * View /xharbour/contrib/inherit.prg
 *
 * Reescrita por Rafa Carmona y manteniendo el mismo tipo de licencia 
 * como dominio publico.
 */

#include "hbclass.ch"
#xtranslate Default( <IsNil>, <Value> ) => IIF( <IsNil> == NIL, <Value>, <IsNil> )

CLASS gTextFile
      DATA cFileName             // Filename spec. by user
      DATA hFile                 // File handle
      DATA nLine                 // Current linenumber
      DATA nError                // Last error
      DATA lEoF                  // End of file
      DATA cBlock                // Storage block
      DATA nBlockSize            // Size of read-ahead buffer
      DATA cMode                 // Mode of file use, R = read, W = write
      
      METHOD New()       // Constructor
      METHOD Run()       // Get/set data
      METHOD Dispose()   // Clean up code
      METHOD close()     // Close without write , "W", chr( 26 )
      METHOD Read()      // Read line
      METHOD WriteLn()   // Write line
      METHOD Write()     // Write without CR
      METHOD Goto()      // Go to line
      METHOD GetText( )  // Return TEXT of file

END CLASS

//
// Method TextFile:New -> Create a new text file
//
// <cFile>      file name. No wild characters
// <cMode>      mode for opening. Default "R"
// <nBlockSize> Optional maximum blocksize
//
METHOD New( cFileName, cMode, nBlock ) CLASS gTextFile

   ::nLine     := 0
   ::lEoF      := .F.
   ::cBlock    := ""
   ::cFileName := cFileName
   ::cMode     := Default( cMode, "R" )
 
   if ::cMode == "R"
      ::hFile := fOpen( cFileName )
   elseif ::cMode == "W"
      ::hFile := fCreate( cFileName )
   else
      g_print( "DosFile Init: Unknown file mode:", ::cMode )
   endif

   ::nError := fError()
   if ::nError != 0
      ::lEoF := .T.
      g_print( "Error ", ::nError)
   endif
   
   ::nBlockSize := Default( nBlock, 4096 )
    
Return Self


METHOD Run( xTxt, lCRLF ) CLASS gTextFile
   local xRet

   if ::cMode == "R"
      xRet := ::Read()
   else
      xRet := ::WriteLn( xTxt, lCRLF )
   endif

return xRet


//
// Dispose -> Close the file handle
//
METHOD Dispose() CLASS gTextFile

   ::cBlock := NIL
   if ::hFile != -1
      if ::cMode == "W" .and. ::nError != 0
         ::Write( Chr(26) )                     // Do not forget EOF marker
      endif
      if !fClose(::hFile)
         ::nError := fError()
         QOut( "Dos Error closing ", ::cFileName, " Code ", ::nError)
      endif
   endif

Return self

//
// Close without chr(26)
METHOD Close() CLASS gTextFile
   
   ::cBlock := NIL
   if ::hFile != -1
      if !fClose(::hFile)
         ::nError := fError()
         QOut( "Dos Error closing ", ::cFileName, " Code ", ::nError)
      endif
   endif

Return Self
//
// Read a single line
// lRemoveCRLF == If remove CRLF of the long text , default .F.
//
METHOD Read( lRemoveCRLF ) CLASS gTextFile
   local cRet  := ""
   local cBlock
   local nCrPos
   local nEoFPos
   local nRead
   lRemoveCRLF := Default( lRemoveCRLF, .F. )

   if ::hFile == -1
      QOut( "DosFile:Read : No file open" )
   elseif ::cMode != "R"
      QOut( "File ", ::cFileName, " not open for reading" )
      BREAK
   elseif !::lEoF

      if Len(::cBlock) == 0                     // Read new block
         cBlock := fReadStr( ::hFile, ::nBlockSize )
         if len(cBlock) == 0
            ::nError := fError()                // Error or EOF
            ::lEoF   := .T.
         else
            ::cBlock := cBlock
         endif
      endif

      if !::lEoF
         ::nLine++
         nCRPos := At(Chr(10), ::cBlock)
         if nCRPos != 0                         // More than one line read
            cRet     := Substr( ::cBlock, 1, nCRPos ) // Quitado el -1, cogemos CADENA entera
            ::cBlock := Substr( ::cBlock, nCRPos + 1)
         else                                   // No complete line
            cRet     := ::cBlock
            ::cBlock := ""
            cRet     += ::Read()                // Read the rest
            if !::lEoF
               ::nLine--                        // Adjust erroneous line count
            endif
         endif
         nEoFPos := At( Chr(26), cRet )
         if nEoFPos != 0                        // End of file read
            cRet   := Substr( cRet, 1, nEoFPos-1 )
            ::lEoF := .T.
         endif
         if lRemoveCRLF         
            cRet := Strtran( cRet, Chr(13), "" )   // Remove CR
         endif
      endif
   endif
return cRet


//
// WriteLn -> Write a line to a file
//
// <xTxt>  Text to write. May be any type. May also be an array containing
//         one or more strings
// <lCRLF> End with Carriage Return/Line Feed (Default == TRUE)
//
METHOD WriteLn( xTxt, lCRLF ) CLASS gTextFile
   local cBlock

   if ::hFile == -1
      QOut( "DosFile:Write : No file open" )
   elseif ::cMode != 'W'
      QOut( "File ", ::cFileName," not opened for writing" )
      BREAK
   else
      cBlock := cValToChar( xTxt )                  // Convert to string
      if Default( lCRLF, .T. )
         cBlock += HB_OSNEWLINE() //Chr(10)+Chr(13)
      endif
      fWrite( ::hFile, cBlock, len(cBlock) )
      if fError() != 0
         ::nError := fError()                   // Not completely written !
      endif
      ::nLine := ::nLine + 1
   endif
Return self


METHOD Write( xTxt ) CLASS gTextFile
Return ::WriteLn( xTxt, .F. )


//
// Go to a specified line number
//
METHOD Goto( nLine ) CLASS gTextFile
   local nWhere := 1

   if Empty(::hFile)
      QOut( "DosFile:Goto : No file open" )
   elseif  ::cMode != "R"
      QOut( "File ", ::cFileName, " not open for reading" )
      BREAK
   else
      ::lEoF   := .F.                           // Clear (old) End of file
      ::nLine  := 0                             // Start at beginning
      ::cBlock := ""
      fSeek(::hFile, 0)                         // Go top
      do while !::lEoF .and. nWhere < nLine
         nWhere++
         ::Read()
      enddo
   endif
Return !::lEoF

METHOD GetText( ) CLASS gTextFile
    Local cText := "", cLine
    local nWhere := 1
  
    ::Goto( 1 )
      
    while !::lEoF 
       cLine := ::Read() 
       cText += cLine
       ::Goto( ++nWhere )
    end while

Return cText
