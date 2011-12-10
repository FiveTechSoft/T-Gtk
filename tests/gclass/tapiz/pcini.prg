/*
    LGPL Licence.

    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this software; see the file COPYING.  If not, write to
    the Free Software Foundation, Inc., 59 Temple Place, Suite 330,
    Boston, MA 02111-1307 USA (or visit the web site http://www.gnu.org/).

    LGPL Licence.
    (c)2007 Federico de Maussion <fj_demaussion@yahoo.com.ar>
*/

#include "hbclass.ch"

//----------------------------------------------------------------------------//

CLASS PC_Ini

   DATA cFileName, Contents

   METHOD New( cIniFile ) CONSTRUCTOR
   METHOD Get( cSection, cEntry, uDefault, uVar )
   METHOD Set( cSection, cEntry, uValue )
   METHOD Save()

   METHOD DelSection( cSection )
   METHOD DelEntry( cSection, cEntry )

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( cFileName ) CLASS PC_Ini
   local Done, hFile, cFile, cLine, cIdent, nPos
   local CurrArray 

   if ! Empty( cFileName ) .and. At( ".", cFileName ) == 0
      cFileName += ".ini"
   endif

   ::Contents := {}
   ::cFileName := cFileName
   CurrArray := ::Contents  

   if File(cFileName)
      hFile := fopen( cFilename, 0 )
   else
      hFile := fcreate( cFilename )
   endif

   if hFile == -1
      QOut( "DosFile:Read : No file open" )
   else
      cLine := ''
      Done := .f.
      while !Done 

         cFile := space(4096)
         Done := (fread(hFile, @cFile, 4096) <= 0)

         cFile := cLine + cFile
         while !empty(cFile)

            if (nPos := at(chr(10), cFile)) > 0
               cLine := AllTrim(left(cFile, nPos - 2))
               cFile := substr(cFile, nPos + 1)

               if !empty(cLine)
                  if Left(cLine, 1) == '[' // new section
                     if (nPos := At(']', cLine)) > 1
                        cLine := substr(cLine, 2, nPos - 2);

                     else
                        cLine := substr(cLine, 2)
                     endif

                     AAdd(::Contents, { cLine, { } } )
                     CurrArray := ::Contents[Len(::Contents)][2]

                  elseif Left(cLine, 1) == ';' 
                     AAdd( CurrArray, { NIL, cLine } )

                  else
                     if (nPos := At('=', cLine)) > 0
                        cIdent := Left(cLine, nPos - 1)
                        cLine := SubStr(cLine, nPos + 1)

                        AAdd( CurrArray, { cIdent, cLine } )

                     else
                        AAdd( CurrArray, { cLine, '' } )
                     endif
                  endif
                  cLine := '' 
               endif

            else
               cLine := cFile
               cFile := ''
            endif
         end
      end

      fclose(hFile)
   endif

Return Self  
//----------------------------------------------------------------------------//

METHOD Get( cSection, cEntry, uValue ) CLASS PC_Ini
   local cResult := ""
   local i, j, cFind
   local cType := ValType( uValue )

   if Empty(cSection)
      j := AScan( ::Contents, {|x| Upper(x[1]) == Upper(cEntry) } )

      if j > 0
          cResult := ::Contents[j][2]
      endif

   else
      i := AScan( ::Contents, {|x| Upper(x[1]) == Upper(cSection)} )

      if i > 0
         j := AScan( ::Contents[i][2], {|x| Upper(x[1]) == Upper(cEntry) } )

         if j > 0
            cResult := ::Contents[i][2][j][2]
         endif
      endif
   endif

   if Empty( cResult )
     ::Set( cSection, cEntry, uValue)
     cResult := uValue
   else
      if cType == "D"
           cResult = SToD( cResult )
      elseif cType == "N"
           cResult = Val( cResult )
      elseif cType == "L"
           cResult = ( Upper( cResult ) == ".T." )
      end
   end

return cResult 

//----------------------------------------------------------------------------//

METHOD Set( cSection, cEntry, uValue ) CLASS PC_Ini
   local i, j, cFind
   local cType := ValType( uValue )

   i := AScan( ::Contents, {|x| Upper(x[1]) == Upper(cSection)} )

   if i > 0
     j := AScan( ::Contents[i][2], {|x| Upper(x[1]) == Upper(cEntry) } )

     if j > 0
        ::Contents[i][2][j][2] := xVal( uValue )
     else
        AAdd( ::Contents[i][2], {cEntry, xVal( uValue )} )
     endif

   else
     AAdd( ::Contents, { cSection, {{cEntry, xVal( uValue )}}} )
   endif 

return uValue

//----------------------------------------------------------------------------//

METHOD DelSection( cSection ) CLASS PC_Ini
   local i

   if !Empty(cSection)
      cSection := Upper(cSection)
      if (i := AScan( ::Contents, {|x| Upper(x[1]) == cSection .and. ValType(x[2]) == 'A'})) > 0
         ADel( ::Contents, i )
         ASize( ::Contents, Len(::Contents) - 1 )
      endif
   endif
return nil

//----------------------------------------------------------------------------//

METHOD DelEntry( cSection, cEntry ) CLASS PC_Ini
   local i, j

   cSection := Upper(cSection)
   i := AScan( ::Contents, {|x| Upper(x[1]) == cSection} )

   if i > 0
      cEntry := Upper(cEntry)
      j := AScan( ::Contents[i][2], {|x| Upper(x[1]) == cEntry} )

      ADel( ::Contents[i][2], j )
      ASize( ::Contents[i][2], Len( ::Contents[i][2] ) - 1 )
   endif
return nil

//----------------------------------------------------------------------------//

METHOD Save() CLASS PC_Ini
   local i, j, hFile

   hFile := fcreate(::cFilename)

   for i := 1 to Len(::Contents)
      if ::Contents[i][1] == NIL
         fwrite(hFile, ::Contents[i][2] + Chr(13) + Chr(10))

      elseif ValType(::Contents[i][2]) == 'A'
         fwrite(hFile, '[' + ::Contents[i][1] + ']' + Chr(13) + Chr(10))
         for j := 1 to Len(::Contents[i][2])

            if ::Contents[i][2][j][1] == NIL
               fwrite(hFile, ::Contents[i][2][j][2] + Chr(13) + Chr(10))

            else
               fwrite(hFile, ::Contents[i][2][j][1] + '=' + ::Contents[i][2][j][2] + Chr(13) + Chr(10))
            endif
         next
         fwrite(hFile, Chr(13) + Chr(10))

      elseif ValType(::Contents[i][2]) == 'C'
         fwrite(hFile, ::Contents[i][1] + '=' + ::Contents[i][2] + Chr(13) + Chr(10))

      endif
   next
   fclose(hFile)
return nil

//----------------------------------------------------------------------------//

Static Function xVal( xValor )
   local cDev
   local cType := ValType( xValor )

   if  cType = "N"
     cDev := alltrim( str( xValor ) )
   elseif  cType = "D"
     cDev := DToS( xValor )
   elseif  cType = "L"
     cDev := If( xValor, ".T.", ".F." )
   else
     cDev := xValor
   end

return cDev
