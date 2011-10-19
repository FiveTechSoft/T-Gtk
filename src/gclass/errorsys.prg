/* $Id: errorsys.prg,v 1.1 2006/09/07 17:07:55 xthefull Exp $*/
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
    Errorsys para T-Gtk
    (c)2003-11 Rafael Carmona <rafa.thefull@gmail.com>
    (c)2011    Federico de Maussion

*/

#include "gclass.ch"
#undef TRUE
#undef FALSE
#include "common.ch"
#include "error.ch"
#include "fileio.ch"


#ifdef XHTEST
// Para no cargar el ejecutable con las RDD
ANNOUNCE RDDSYS

REQUEST HB_LANG_ES

// --------------------------------------------------------------------------------------- //

FUNCTION Main()
  VerError()
RETURN .T.

#endif

//-------------------------------------------------

PROCEDURE ErrorSys

   ErrorBlock( { | oError | DefError( oError ) } )

RETURN

STATIC FUNCTION DefError( oError )
   LOCAL cMessage
   LOCAL cDOSError
   LOCAL aStart := Array( 14 )
   LOCAL aOptions
   LOCAL nChoice
   Local cTextclean := ""
   LOCAL n
   LOCAL aRDDS, j, nTarget, e, naux
   LOCAL nArea
   Local lReturn := .F.

   Local cText := "", cText1, oWnd, oScrool,hView, hBuffer, oBox, oBtn, oBoxH, expand, oFont, oExpand, oMemo
   Local cTextExpand := '<span foreground="orange" size="large"><b>Pulse for view <span foreground="red"'+;
                        ' size="large" ><i> details</i></span></b>!</span>'
   Local aStyle := { { "red" ,    BGCOLOR , STATE_NORMAL },;
                     { "yellow" , BGCOLOR , STATE_PRELIGHT },;
                     { "white"  , FGCOLOR , STATE_NORMAL } }
   Local aStyleChild := { { "white", FGCOLOR , STATE_NORMAL },;
                          { "red",   FGCOLOR , STATE_PRELIGHT }}
   Local acSet:={                                                     ;
          'Exact      :','Fixed      :','Decimals   :','Dateformat :',;
          'Epoch      :','Path       :','Default    :','Exclusive  :',;
          'Softseek   :','Unique     :','Deleted    :','Cancel     :',;
          'Debug      :','Typeahead  :','Color      :','Cursor     :',;
          'Console    :','Alternate  :','Altfile    :','Device     :',;
          'Extra      :','Extrafile  :','Printer    :','Printfile  :',;
          'Margin     :','Bell       :','Confirm    :','Escape     :',;
          'Insert     :','Exit       :','Intensity  :','Scoreboard :',;
          'Delimiters :','Delimchars :','Wrap       :','Message    :',;
          'Mcenter    :','Scrollbreak:'                               ;
                }


   // By default, division by zero results in zero
   IF oError:genCode == EG_ZERODIV
      RETURN 0
   ENDIF

   // Set NetErr() of there was a database open error
   IF oError:genCode == EG_OPEN .AND. ;
      oError:osCode == 32 .AND. ;
      oError:canDefault

     nChoice:=Alert("Imposible abrir el fichero '"+oError:filename+"'. Intentos:"+Alltrim(Str(oError:tries)),;
          {"Reintentar","Recuperar","Cancelar"} )
     if nChoice =1
          return .t.
     elseif nChoice= 2
          break(oError)
     else
          NetErr(.t.)
          return (.f.)                                                                    // NOTE
     end
   ENDIF

   // Set NetErr() if there was a lock error on dbAppend()
   IF oError:genCode == EG_APPENDLOCK .AND. ;
      oError:canDefault

     nChoice:=Alert("Imposible insertar registro en el fichero '"+oError:filename+"'. Intentos:"+Alltrim(Str(oError:tries)),;
          {"Reintentar","Recuperar","Ignorar"} )
     if nChoice =1
          return .t.
     elseif nChoice= 2
          break(oError)
     else
          NetErr(.t.)
          return (.f.)                                                                    // NOTE
     end
   ENDIF

// Error de impresora
if ( oError:genCode == EG_PRINT )
     nChoice := Alert( "Error al intentar imprimir", ;
                  { "Reintentar", "Cancelar Impresi�n",;
                    "A fichero"} )

     do case
     case nChoice == 1
          return .t.
     case nChoice == 3
          Set( _SET_PRINTFILE,;
               right(dtos(date()),4) + SubStr( Time(), 1, 2 ) +;
               SubStr( Time(), 4, 2 ) + '.PRN',;
           .t.)
          return .t.
     other
          Break(oError)
     end case
endif

// Ponemos la descripcion en castellano
cDescripcion( oError )


   cMessage := ErrorMessage( oError )

   IF ! Empty( oError:osCode )
      cMessage += " " + "(DOS Error " + LTrim( Str( oError:osCode ) )  + "); " + cErrorDos( oError:osCode )
   ENDIF

   IF ! Empty( oError:subsystem )
      cMessage += " " + oError:subsystem + "/" + Ltrim(Str(oError:subCode))
   END

   IF ! Empty(oError:description)
      cMessage += "  " + oError:description
   END

   IF ! Empty(oError:operation)
      cMessage += ": " + oError:operation
   END

   IF ! Empty(oError:filename)
      cMessage += ": " + oError:filename
   END

//   MsgStop( cMessage, "Error" )

   cText := "Informaci�n General de la Applicaci�n" + CRLF
   cText += "-------------------------------------" + CRLF
   cText += "   Error ocurrido el : " + DToC( Date() ) + " a las " + Time() + CRLF + CRLF

   cText += "   Ruta y Nombre     : " + HB_ArgV( 0 ) + If("(64 bit)" $ hb_compiler(), " (64 bit)", " (32 bit)" ) + CRLF
   cText += "   Tama�o            : " + Alltrim(Transform( FSize( HB_ArgV( 0 ) ), "@e 999,999,999,999" ) ) +" bytes" + CRLF
   cText += "   Creaado           : " + FFecha( HB_ArgV( 0 ) ) + CRLF + CRLF
   cText += "   Estaci�n          : " + NetName() + CRLF + CRLF

   cText += "   Sistema Operativo : "+ Os() + CRLF
   cText += "   Compilador Version: "+ version() + CRLF
   cText += "   Compilador Build  : "+ hb_builddate() + CRLF
   cText += "   Cmpilador C/C++   : "+ hb_compiler() + CRLF
   cText += "   Librer�a Gtk Ver. : "+ MyGtk_Version() + CRLF + CRLF

   cText += "   Multi Threading   : " + If( Hb_MultiThread(),"Si","No" )  + CRLF
   cText += "   VM Optimizacion   : " + Alltrim( str( Hb_VmMode() ) ) + CRLF + CRLF

   // Error object analysis
   cMessage   = ErrorMessage( oError ) + CRLF
   cText += "Descripci�n del error producido" + CRLF+;
            "-------------------------------" + CRLF+;
            "   "+ cMessage

   if ValType( oError:Args ) == "A"
      cText += "   Argumentos :" + CRLF
      for n = 1 to Len( oError:Args )
         cText += "     [" + Str( n, 4 ) + "] = " + ;
	                ValType( oError:Args[ n ] ) + "   " + ;
	                cValToChar( oError:Args[ n ] ) + CRLF
      next
   endif

  cText += CRLF
  cText += '   CANDEFAULT     ' + If( oError:canDefault   , '.T.','.F.' ) + CRLF
  cText += '   CANRETRY       ' + If( oError:canRetry     , '.T.','.F.' ) + CRLF
  cText += '   CANSUBSTITUTE  ' + If( oError:canSubstitute, '.T.','.F.' ) + CRLF
  cText += '   DESCRIPTION    ' + oError:description + CRLF
  cText += '   FILENAME       ' + If( Empty( oError:filename ) , 'No existe fichero en uso', oError:filename ) + CRLF
  cText += '   GENCODE        ' + Alltrim(Str( oError:genCode )) + CRLF
  cText += '   OPERATION      ' + oError:operation   + CRLF
  cText += '   OSCODE         ' + Alltrim(Str( oError:osCode ))+" "+cErrorDos(oError:OsCode) + CRLF
  cText += '   SEVERITY       ' + Alltrim(Str( oError:severity )) + CRLF
  cText += '   SUBCODE        ' + Alltrim(Str( oError:subCode )) + CRLF
  cText += '   SUBSYSTEM      ' + oError:subSystem  + CRLF
  cText += '   TRIES          ' + Alltrim(Str( oError:tries )) + CRLF + CRLF

   cText += CRLF + "Llamadas al Stack" + CRLF
   cText +=        "-----------------" + CRLF

   n := 2

   WHILE ! Empty( ProcName( n ) )
			cText += "Llamada por " + ProcFile( n ) + " --> " + ProcName(n) + "( " + AllTrim( Str( ProcLine( n ) ) ) + " )" + CRLF
			g_print( "Llamada por " + ProcFile( n ) + " --> " + ProcName(n) + "( " + AllTrim( Str( ProcLine( n ) ) ) + " )" + CRLF )
      n++
   ENDDO

   //------------------------------------------------------
   /*
   cText += CRLF + "Variables in use" + CRLF + "================" + CRLF
   cText += "   Procedure     Type   Value" + CRLF
   cText += "   ==========================" + CRLF

   n := 2    // we don't disscard any info again !
   while ( n < 74 )

       if ! Empty( ProcName( n ) )
          cText += "   " + Trim( ProcName( n ) ) + CRLF
          for j = 1 to ParamCount( n )
             cText += "     Param " + Str( j, 3 ) + ":    " + ;
                          ValType( GetParam( n, j ) ) + ;
                          "    " + cValToChar( GetParam( n, j ) ) + CRLF
          next
          for j = 1 to LocalCount( n )
             cText += "     Local " + Str( j, 3 ) + ":    " + ;
                          ValType( GetLocal( n, j ) ) + ;
                          "    " + cValToChar( GetLocal( n, j ) ) + CRLF
          next
       endif

       n++
   end
   */
   cText += CRLF + "Linked RDDs" + CRLF + "-----------" + CRLF
   aRDDs = RddList( 1 )
   for n = 1 to Len( aRDDs )
      cText += "   " + aRDDs[ n ] + CRLF
   next

   cText += CRLF + "DataBases en uso" + CRLF + "----------------" + CRLF
   for n = 1 to 255
      if ! Empty( Alias( n ) )
         cText += CRLF + Str( n, 3 ) + ": " + If( Select() == n,"=> ", "   " ) + ;
                      PadR( Alias( n ), 15 ) + Space( 20 ) + "RddName: " + ;
                      ( Alias( n ) )->( RddName() ) + CRLF
         cText += "     ------------------------------" + CRLF
         cText += "     RecNo    RecCount    BOF   EOF" + CRLF
         cText += "    " + Transform( ( Alias( n ) )->( RecNo() ), "99999" ) + ;
                      "      " + Transform( ( Alias( n ) )->( RecCount() ), "99999" ) + ;
                      "      " + cValToChar( ( Alias( n ) )->( BoF() ) ) + ;
                      "   " + cValToChar( ( Alias( n ) )->( EoF() ) ) + CRLF + CRLF
         cText += "     Indexes en uso " + Space( 23 ) + "TagName" + CRLF
         for j = 1 to 15
            if ! Empty( ( Alias( n ) )->( IndexKey( j ) ) )
               cText += Space( 8 ) + ;
                            If( ( Alias( n ) )->( IndexOrd() ) == j, "=> ", "   " ) + ;
                            PadR( ( Alias( n ) )->( IndexKey( j ) ), 35 ) + ;
                            ( Alias( n ) )->( OrdName( j ) ) + ;
                            CRLF
            endif
         next
         cText += CRLF + "     Relations en uso" + CRLF
         for j = 1 to 8
            if ! Empty( ( nTarget := ( Alias( n ) )->( DbRSelect( j ) ) ) )
               cText += Space( 8 ) + Str( j ) + ": " + ;
                            "TO " + ( Alias( n ) )->( DbRelation( j ) ) + ;
                            " INTO " + Alias( nTarget ) + CRLF
               // uValue = ( Alias( n ) )->( DbRelation( j ) )
               // cText += cValToChar( &( uValue ) ) + CRLF
            endif
         next
      endif
   next

   n = 1
   cText += CRLF + "Classes en uso:" + CRLF
   cText += "---------------" + CRLF
   while ! Empty( __ClassName( n ) )
      cText += "   " + padr( Str( n, 3 ) + " " + __ClassName( n++ ), 25)
      if n % 2 == 0
        cText +=  "      |  "
      else
        cText +=  CRLF
      end
   end
   cText += CRLF + if( n % 2 == 0, CRLF, "" )

   cText += "Estado de valores internos (SET)" + CRLF
   cText += "--------------------------------" + CRLF
   for nAux:= 1 to 38 step 2
     cText += space(3) + padr( acSet[nAux]+ cValToChar( Set(nAux) ), 35)+;
                  "| " + trim( left( acSet[nAux+1] + cValToChar( Set(nAux+1) ), 35) ) + CRLF
   next

  cText1 := UTF_8(cText)

//   MsgStop( cText1, "Error cText" )
   //------------------------------------------------------


   DEFINE WINDOW oWnd TITLE "Errorsys T-Gtk MultiSystem"
           oWnd:lInitiate := .F. //Fuerzo a entrar en otro bucles de procesos.

           DEFINE BOX oBox VERTICAL OF oWnd CONTAINER
                      cMessage := '<span foreground="green"><i>'+;
                                  "Error Description:"+"</i>"+CRLF+;
                                  '<span foreground="black"><b>'+cMessage +'</b></span></span>'

                      DEFINE LABEL TEXT UTF_8( cMessage )MARKUP OF oBox

                      DEFINE EXPANDER oExpand ;
                                      TEXT cTextExpand MARKUP ;
                                      EXPAND FILL OF oBox ;
                                      ACTION oWnd:Center( GTK_WIN_POS_CENTER_ALWAYS )

                      DEFINE SCROLLEDWINDOW oScrool ;
                             SIZE 400,400 OF oExpand CONTAINER

                      DEFINE MEMO oMemo VAR cTextClean OF oScrool CONTAINER
                          oMemo:SetLeft( 10 )
                          oMemo:SetRight( 20 )
                          oMemo:CreateTag( "font", { "font", "Courier New 10" } )
                          oMemo:CreateTag( "info",{ "foreground", "red" , "font", "Courier New 10"} )
                          oMemo:oBuffer:GetIterAtOffSet( aStart, -1 )
                          nLines := MLCOUNT( cText1, 200)
                          for x := 1 to nLines
                              cLineTmp := MEMOLINE( cText1, 200, x ) + CRLF
                              do case
                                 case "---------" $ cLineTmp
                                  oMemo:Insert_Tag( cLineTmp , "info", aStart )
                                 otherwise
                                  oMemo:Insert_Tag( cLineTmp, "font", aStart )
                              endcase
                          next

               DEFINE BOX oBoxH  OF oBox

               DEFINE BUTTON oBtn TEXT "_QUIT" MNEMONIC OF oBoxH EXPAND FILL ;
                            ACTION __Salir( oWnd )


               if oError:canRetry
                  DEFINE BUTTON oBtn TEXT "_Entry" MNEMONIC OF oBoxH EXPAND FILL;
                         ACTION ( lReturn := .T.,oWnd:End() )
               endif

               if oError:CanDefault
                  DEFINE BUTTON oBtn TEXT "_Default" MNEMONIC OF oBoxH EXPAND FILL ;
                         ACTION ( lReturn := .F., oWnd:End() )
               endif

               __Grabar( cText )
/*
               DEFINE FONT oFont NAME "Sans italic bold 13"

               DEFINE BUTTON oBtn TEXT "_Save error.log" MNEMONIC;
                                 ACTION Memowrit( "error.log", cText ) ;
                                 FONT oFont ;
                                 STYLE aStyle ;
                                 STYLE_CHILD aStyleChild ;
                                 OF oBoxH
*/
    ACTIVATE WINDOW oWnd CENTER MODAL


RETURN lReturn

// SALIR DEL PROGRAMA Eliminando todo resido memorial ;-)
// Salimos 'limpiamente' de la memoria del ordenador
Static Function __Salir( oWnd )
       Local nLen := Len( oWnd:aWindows ) - 1
       Local X

       if nLen > 0
          FOR X := nLen To 1
             oWnd:aWindows[x]:bEnd := NIL
             oWnd:aWindows[x]:End()
          NEXT
       endif
       oWnd:End()
       gtk_main_quit()
       QUIT

Return .F.

Static Function __Grabar( cText )

   local nManip                                                      ,;
         cCadena := ''                                               ,;
         nAux                                                        ,;
         nAux1                                                       ,;
         oErr                                                        ,;
         lSw                                                         ,;
         cNumero := Space( 6 )                                       ,;
         nNumero

   errorblock({|e| Break(e)})
   // Comprobamos si existe o no el fichero
begin sequence
   IF !File( 'error.log' )
      nManip := FCreate( 'error.log', 0 )
      // Grabar el n�mero de error en la cabecera
      cNumero := '00001'
      FWrite( nManip, 'K' + cNumero + CRLF + CRLF )
      nNumero := Val( Right( cNumero, 5 ) )
   ELSE
      nManip := FOpen( 'error.log', 2 )
      FRead( nManip, @cNumero, 6 )
      nNumero := Val( Right( cNumero, 5 ) )+1
      cNumero := padl(nNumero,5,'0')
      FSeek( nManip, 0, 0 )
      FWrite( nManip,'K' + cNumero + CRLF )
   ENDIF

   // Nos posicionamos al final del fichero
   FSeek( nManip, 0, 2 )

   FWrite(nManip, '<>' + cNumero +'-- Error --------------------' + CRLF + CRLF )
   FWrite(nManip, cText + CRLF )
   FWrite(nManip,'##' + cNumero + CRLF + CRLF )
   FClose( nManip )

recover using oErr
   alert("Imposible grabar informaci�n del error al disco;"+cErrorDos(oErr:osCode)+";"+oErr:Description,{"Enterado"})
//   errorinhandler()
end sequence


Return .F.


Static Function FSize( cFile )
    Local aDev[ aDir(cFile) ]
    aDir(cFile, ,aDev)
return aDev[1]

Static Function FFecha( cFile )
    Local x := aDir(cFile)
    Local aDev[ x ]
    Local aHora[ x ]
    aDir(cFile, , ,aDev, aHora)
return Alltrim(Transform( aDev[1], "@d " ) +" "+aHora[1])

FUNCTION ErrorMessage( oError )
   LOCAL cMessage

   cMessage := iif( oError:severity > ES_WARNING, "Error", "Warning" ) + " "

   IF Valtype( oError:subsystem ) = "C"
      cMessage += oError:subsystem()
   ELSE
      cMessage += "???"
   ENDIF

   IF Valtype( oError:subCode) = "N"
      cMessage += "/" + LTrim( Str( oError:subCode ) )
   ELSE
      cMessage += "/???"
   ENDIF

   IF Valtype( oError:description ) = "C"
      cMessage += "  " + oError:description
   ENDIF

   DO CASE
   CASE !Empty( oError:filename )
      cMessage += ": " + oError:filename
   CASE !Empty( oError:operation )
      cMessage += ": " + oError:operation
   ENDCASE

RETURN cMessage

/* Funcion que devuelve siempre un tipo x, transformado como caracter*/
Function cValToChar( uVal )

   local cType := ValType( uVal )

   if uVal == nil
      return "nil"
   endif

   do case
      case cType == "C" .or. cType == "M"
           return uVal

      case cType == "D"
           return DToC( uVal )

      case cType == "L"
           return If( uVal, ".T.", ".F." )

      case cType == "N"
           return AllTrim( Str( uVal ) )

      case cType == "B"
           return "{|| ... }"

      case cType == "A"
           return "{ ... }"

      case cType == "O"
           return "Object"

      otherwise
           return ""
   endcase

return nil

function cDescripcion( oErr )
local aTexto := {                                    ;
               'Error en par�metros'                ,;
               'Error de l�mites'                   ,;
               'Desbordamiento de cadena'           ,;
               'Desbordamiento n�merico'            ,;
               'Divisi�n por 0'                     ,;
               'Error num�rico'                     ,;
               'Error de sintaxis'                  ,;
               'Operaci�n demasiado compleja'       ,;
               ''                                   ,;
               ''                                   ,;
               'No hay memoria'                     ,;
               'Funci�n sin definir'                ,;
               'Metodo sin definir'                 ,;
               'La variable no existe'              ,;
               'No existe el alias'                 ,;
               'Mensaje sin definir'                ,;
               'Car�cteres ilegales en el alias'    ,;
               'El alias especificado est� en uso'  ,;
               ''                                   ,;
               'Error de creaci�n'                  ,;
               'Error de apertura'                  ,;
               'Error al cerrar'                    ,;
               'Error al leer'                      ,;
               'Error al escribir'                  ,;
               'Error al imprimir'                  ,;
               ''                                   ,;
               ''                                   ,;
               ''                                   ,;
               ''                                   ,;
               'Operaci�n no soportada'             ,;
               'L�mite excedido'                    ,;
               'Corrupci�n detectada'               ,;
               'Error en el tipo de dato'           ,;
               'Error en la longitud de los datos'  ,;
               'El �rea de trabajo no est� en uso'  ,;
               'El �rea de trabajo no est� indexada',;
               'Se requiere exclusividad'           ,;
               'Se requiere bloqueo'                ,;
               'Escritura no permitida'             ,;
               'Fallo del bloqueo para insertar'    ,;
               'Relaci�n ciclica'                    ;
        }


if oErr:GenCode > 0 .and. oErr:Gencode < 42
     oErr:Description:= aTexto[ oErr:Gencode ]
endif
return oErr:Description

function cErrorDos(nCode)
local aErrorDos:={                     ;
                     'Funci�n erronea'                                 ,;
                     'Fichero no encontrado'                           ,;
                     'Ruta no encontrada'                              ,;
                     'Demasiados ficheros abiertos'                    ,;
                     'Acceso negado'                                   ,;
                     'Manejador erroneo'                               ,;
                     'Memory Control Block destruido'                  ,;
                     'Memoria insuficiente'                            ,;
                     'Bloque de memoria erroneo'                       ,;
                     'Ambiente erroneo'                                ,;
                     'Formato erroneo'                                 ,;
                     'Codigo de acceso erroneo'                        ,;
                     'Datos erroneos'                                  ,;
                     'Reservado'                                       ,;
                     'Unidad erronea'                                  ,;
                     'Intento de borrar el directorio actual'          ,;
                     'No es el mismo dispositivo'                      ,;
                     'No hay m�s ficheros'                             ,;
                     'Disco protegido contra escritura'                ,;
                     'Unidad desconocida'                              ,;
                     'Unidad no esta dispuesta'                        ,;
                     'Comando desconocido'                             ,;
                     'Error de datos (CRC)'                            ,;
                     ''                                                ,;
                     'Error de busqueda'                               ,;
                     ''                                                ,;
                     'Sector no encontrado'                            ,;
                     'Falta papel en la impresora'                     ,;
                     'Fallo de escritura'                              ,;
                     'Fallo de lectura'                                ,;
                     'Fallo general'                                   ,;
                     'Violaci�n compartiendo'                          ,;
                     'Violaci�n de bloqueo'                            ,;
                     'Cambio de disco erroneo'                         ,;
                     'No est� disponible FCB'                          ,;
                     'Desbordamiento compartiendo buffer'              ,;
                     '','','','','','','','','','','','',''            ,;
                     'Petici�n a RED no soportada'                     ,;
                     'Ordenador remoto no listado'                     ,;
                     'Nombre duplicado en RED'                         ,;
                     'Nombre de RED no encontrado'                     ,;
                     'RED ocupada'                                     ,;
                     'Dispositivo de RED ya no existe'                 ,;
                     'Comando BIOS de RED.Limite excedido'             ,;
                     'Error del adaptador de la RED'                   ,;
                     'Respuesta incorrecta desde la RED'               ,;
                     'Error de RED inesperado'                         ,;
                     'Adaptador remoto incompatible'                   ,;
                     'Cola de impresi�n llena'                         ,;
                     'No hay espacio disponible para imprimir fichero' ,;
                     'Fichero de impresi�n borrado. No hay espacio'    ,;
                     'Nombre de RED borrado'                           ,;
                     'Acceso negado'                                   ,;
                     'Dispositivo de RED de tipo inadecuado'           ,;
                     'Nombre de RED no encontrado'                     ,;
                     'Nombre de RED.Limite excedido'                   ,;
                     'BIOS.Sesion de RED.Limite excedido'              ,;
                     'Temporalmente parado'                            ,;
                     'Petici�n de RED no aceptada'                     ,;
                     'Impresi�n parada'                                ,;
                     '','','','','','',''                              ,;
                     'Fichero ya existe'                               ,;
                     ''                                                ,;
                     'No puedo crear directorio'                       ,;
                     'Fallo de la INT 24H'                             ,;
                     'Demasiadas redirecciones'                        ,;
                     'Redirecci�n duplicada'                           ,;
                     'Palabra de paso erronea'                         ,;
                     'Parametros erroneos'                             ,;
                     'Fallo del dispositivo de RED'                     ;
                 }
return if (nCode<=88 .and. nCode>0,aErrorDos[nCode],"")


// Analizamos .....
#ifdef _DGBVIEW_WINDOWS_
    #command !! [ <list,...> ] => aEval( [ \{ <list> \} ],{|e| OutPutDebugString(cValToChar(e) + hb_osnewline())} )
    #pragma BEGINDUMP
    #include <windows.h>
    #include <hbapi.h>
    HB_FUNC( OUTPUTDEBUGSTRING )
    {
      OutputDebugStringA( ( LPSTR ) hb_parc( 1 ) );
    }
    #pragma ENDDUMP
#else
    #command !! [ <list,...> ] => aEval( [ \{ <list> \} ],{|e| g_print(cValToChar(e) + hb_osnewline() )} )
#endif

PROCEDURE InitProfiler( lInfo, lShowTime ,lShowCall, lShowName )
   static oProfile

   DEFAULT lInfo := .F., lShowCall := .F., lShowName := .F., lShowTime := .T.

   IF Empty( oProfile )
      __setProfiler( .T. )
      oProfile := HBProfile():new() // New() is a default method in the class system that calls :init() to initialize the object
      __setProfiler( .T. )          // Turn on profiling.
   ENDIF

   DEFAULT lInfo := .F.

   IF lInfo
      // Take a profile snapshot.
      oProfile:gather()

      // Report on calls greater than 0
      if lShowCall
         !! "Todos los metodos y funciones llamados una o mas veces, ordenados por LLAMADAS"
         !! HBProfileReportToString():new( oProfile:callSort() ):generate( {|o| ValType( o:nCalls ) == 'N' .AND. o:nCalls > 0 } )
      endif
      // Sorted by name
      if lShowName
         !! "Todos los metodos y funciones llamados una o mas veces, ordenados por NOMBRE"
         !! HBProfileReportToString():new( oProfile:nameSort() ):generate( {|o| ValType( o:nCalls ) == 'N' .AND. o:nCalls > 0 } )
      endif
      // Sorted by time
      if lShowTime
         !! "Todos los metodos y funciones llamados una o mas veces, ordenados por TIEMPO"
         !! HBProfileReportToString():new( oProfile:timeSort() ):generate( {|o| ValType( o:nTicks ) == 'N' .AND. o:nTicks > 0 } )
      endif

      // Some closing stats
      !!  "## Totals ######"
      !! "    Total Calls  : " + str( oProfile:totalCalls() )
      !! "    Total Ticks  : " + str( oProfile:totalTicks() )
      !! "    Total Seconds: " + str( oProfile:totalSeconds() )
   ENDIF

Return


// ---------------------------------------------------------------------

Function VerError()
  Local oWnd, oButon
  Local oBoxV, oBoxH, oBox2
  Local oBook, oScroll, oFont
  Local aTitu, oTitu
  Local oTextView := {,,,,,,,,}
  Local acText
  Local oCombo, uCombo, aCombo := {}
  Local nManip, nNumero, cNumero := Space(6)
  Local x
//  Local aStart := Array( 14 )

  if !File( 'error.log' )
  else
    nManip := FOpen( 'error.log', 2 )
    FRead( nManip, @cNumero, 6 )
    nNumero := Val( Right( cNumero, 5 ) )
    cNumero := padl(nNumero,5,'0')
    FSeek( nManip, 0, 0 )
  endif
  for x=nNumero to 1 Step -1
    aAdD( aCombo, padl(x,5,'0') )
  next
  uCombo := cNumero
  acText := aLenaErr(uCombo, nManip)

//  DEFINE FONT oFont NAME "Arial italic 10"

  DEFINE WINDOW oWnd TITLE "Control de Errores"  SIZE 600,300

//  gtk_window_set_icon(oWnd:pWidget, ::oIcon)
  oWnd:SetBorder( 5 )

  DEFINE BOX oBox2 VERTICAL OF oWnd EXPAND FILL

  DEFINE BOX oBoxH OF oBox2

  DEFINE LABEL PROMPT "" EXPAND FILL OF oBoxH

  DEFINE LABEL PROMPT Utf_8(" Error N� ")  OF oBoxH

  DEFINE COMBOBOX oCombo VAR uCombo;
        ITEMS aCombo;
        ON CHANGE ( acText := aLenaErr(uCombo, nManip),;
                    oTextView[1]:SetTExt(acText[1]) ,;
                    oTextView[2]:SetTExt(acText[2]) ,;
                    oTextView[3]:SetTExt(acText[3]) ,;
                    oTextView[4]:SetTExt(acText[4]) ,;
                    oTextView[5]:SetTExt(acText[5]) ,;
                    oTextView[6]:SetTExt(acText[6]) ) ;
        OF oBoxH

  DEFINE NOTEBOOK oBook OF oBox2 EXPAND FILL
  oBook:ShowBorder( .f. )

  aTitu := {"Informaci�n","Descripci�n","Stack","Bases de Datos","Clases","Seteos"}

    DEFINE BOX oBoxV VERTICAL EXPAND FILL
    DEFINE LABEL oTitu PROMPT Utf_8(aTitu[2])
    oBook:Append( oBoxV, oTitu )
    DEFINE SCROLLEDWINDOW oScroll OF oBoxV CONTAINER
      oScroll:SetPolicy( GTK_POLICY_AUTOMATIC, GTK_POLICY_AUTOMATIC )
      DEFINE TEXTVIEW oTextView[2] VAR acText[2] READONLY OF oScroll CONTAINER

    DEFINE BOX oBoxV VERTICAL EXPAND FILL
    DEFINE LABEL oTitu PROMPT Utf_8(aTitu[1])
    oBook:Append( oBoxV, oTitu )
    DEFINE SCROLLEDWINDOW oScroll OF oBoxV CONTAINER
      oScroll:SetPolicy( GTK_POLICY_AUTOMATIC, GTK_POLICY_AUTOMATIC )
      DEFINE TEXTVIEW oTextView[1] VAR acText[1] READONLY OF oScroll CONTAINER

    DEFINE BOX oBoxV VERTICAL EXPAND FILL
    DEFINE LABEL oTitu PROMPT Utf_8(aTitu[3])
    oBook:Append( oBoxV, oTitu )
    DEFINE SCROLLEDWINDOW oScroll OF oBoxV CONTAINER
      oScroll:SetPolicy( GTK_POLICY_AUTOMATIC, GTK_POLICY_AUTOMATIC )
      DEFINE TEXTVIEW oTextView[3] VAR acText[3] READONLY OF oScroll CONTAINER

    DEFINE BOX oBoxV VERTICAL EXPAND FILL
    DEFINE LABEL oTitu PROMPT Utf_8(aTitu[4])
    oBook:Append( oBoxV, oTitu )
    DEFINE SCROLLEDWINDOW oScroll OF oBoxV CONTAINER
      oScroll:SetPolicy( GTK_POLICY_AUTOMATIC, GTK_POLICY_AUTOMATIC )
      DEFINE TEXTVIEW oTextView[4] VAR acText[4] READONLY OF oScroll CONTAINER

    DEFINE BOX oBoxV VERTICAL EXPAND FILL
    DEFINE LABEL oTitu PROMPT Utf_8(aTitu[5])
    oBook:Append( oBoxV, oTitu )
    DEFINE SCROLLEDWINDOW oScroll OF oBoxV CONTAINER
      oScroll:SetPolicy( GTK_POLICY_AUTOMATIC, GTK_POLICY_AUTOMATIC )
      DEFINE TEXTVIEW oTextView[5] VAR acText[5] READONLY OF oScroll CONTAINER

    DEFINE BOX oBoxV VERTICAL EXPAND FILL
    DEFINE LABEL oTitu PROMPT Utf_8(aTitu[6])
    oBook:Append( oBoxV, oTitu )
    DEFINE SCROLLEDWINDOW oScroll OF oBoxV CONTAINER
      oScroll:SetPolicy( GTK_POLICY_AUTOMATIC, GTK_POLICY_AUTOMATIC )
      DEFINE TEXTVIEW oTextView[6] VAR acText[6] READONLY OF oScroll CONTAINER

   ACTIVATE WINDOW oWnd CENTER
FClose( nManip )

RETURN NIL

//-------------------------------------------------------------------

Static Function aLenaErr( cNumero, nManip )
  Local aDev :={"","","","","",""}
  Local aPos:={0,0,0,0,0,0,0}
  Local cError, x, nInicio, nFinal
  Local aCadenas := {'Informaci�n General de la Applicaci�n'  ,;
                     'Descripci�n del error producido'        ,;
                     'Llamadas al Stack'                      ,;
                     'Linked RDDs'                            ,;
                     'Classes en uso:'                        ,;
                     'Estado de valores internos (SET)'       ,;
                     '##'                     }

     // Buscar comienzo error
     FLocate( nManip, '<>' + cNumero )
     nInicio := FilePos( nManip )
     // Buscar final error
     FLocate( nManip, '##' + cNumero )
     nFinal  := FilePos( nManip )
     cError  := Space( nFinal - nInicio + 7 )
     FSeek( nManip, nInicio,  0 )
     FRead( nManip, @cError, nFinal - nInicio + 7 )
     aeval(aCadenas,{|c,n| aPos[n]:=AT(c,cError)})

     For x=1 to 6
       aDev[x] := CRLF + CRLF + Utf_8( SubStr( cError, aPos[x], aPos[x+1]-aPos[x] ) )
     Next
Return aDev

//-------------------------------------------------------------------
#define  BUFFER (62*1024)

Static function FLocate( nManipu, cPalabra )
local nPosChar:=0               ,;
      nT      :=0               ,;
      cBuffer :=Space( BUFFER ) ,;
      lFound  := .F.

FSeek( nManipu,0, 0 )    // Posicionarse al principio del fichero

FOR nT:= 0 TO (FileSize( nManipu )) / BUFFER - 1
    FRead( nManipu, @cBuffer, BUFFER )
    IF (nPosChar := At(cPalabra, cBuffer) ) <> 0
       lFound := .T.
       EXIT
    END IF
NEXT

IF !lFound
   cBuffer := Space( FileSize( nManipu ) % BUFFER )
   FRead( nManipu, @cBuffer, Len(cBuffer) )
   lFound := ( (nPosChar:= At(cPalabra, cBuffer) ) <> 0 )
END IF

IF lFound
   FSeek( nManipu,nPosChar+ (nT * BUFFER) - 1 )
END IF

RETURN lFound

//-------------------------------------------------------------------
static FUNCTION FileSize( nHandle )

   LOCAL nCurrent
   LOCAL nLength

   // Get file position
   nCurrent := FilePos( nHandle )

   // Get file length
   nLength := FSEEK( nHandle, 0, FS_END )

   // Reset file position
   FSEEK( nHandle, nCurrent )

RETURN ( nLength )

//-------------------------------------------------------------------
static FUNCTION FilePos( nHandle )
/*
*/
RETURN ( FSEEK( nHandle, 0, FS_RELATIVE ) )

//-------------------------------------------------------------------
Function MyGtk_Version()
Local nMajor, nMinor, nMicro
Local aGtkVer := Compilado_Gtk_Version(@nMajor, @nMinor, @nMicro)
Local cDev := Alltrim( Str( nMajor ) ) + "." + Alltrim( Str( nMinor ) ) + "." + Alltrim( Str( nMicro ) )
//cDev += "  Binario " + Alltrim( Str( aGtkVer[4] ) ) + " Interface " +Alltrim( Str( aGtkVer[5] ) )
Return cDev

//-------------------------------------------------------------------

#pragma BEGINDUMP

#include <gtk/gtk.h>
#include "hbapi.h"

HB_FUNC ( COMPILADO_GTK_VERSION )
{
  hb_storni( GTK_MAJOR_VERSION, 1 );
  hb_storni( GTK_MINOR_VERSION, 2 );
  hb_storni( GTK_MICRO_VERSION, 3 );

}

//-------------------------------------------------------------------


#pragma ENDDUMP
//----------------------------------------------------------------------------//

