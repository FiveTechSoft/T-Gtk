/* $Id: errorsys.prg,v 1.2 2008-12-02 21:37:48 riztan Exp $*/
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
    (c)2003 Rafael Carmona <thefull@wanadoo.es>
*/
#include "gclass.ch"
#include "common.ch"
#include "error.ch"

PROCEDURE ErrorSys

   ErrorBlock( { | oError | DefError( oError ) } )

RETURN

FUNCTION DefError( oError )
   LOCAL cMessage
   LOCAL cDOSError

   LOCAL aOptions
   LOCAL nChoice

   LOCAL n
   LOCAL nArea
   Local lReturn := .F.

   Local cText := "", oWnd, oScrool,hView, hBuffer, oBox, oBtn, oBoxH, expand, oFont, oExpand, oMemo
   Local cTextExpand := '<span foreground="orange" size="large"><b>Pulse for view <span foreground="red"'+;
                        ' size="large" ><i> details</i></span></b>!</span>'
   Local aStyle := { { "red" ,    BGCOLOR , STATE_NORMAL },;
                     { "yellow" , BGCOLOR , STATE_PRELIGHT },; 
                     { "white"  , FGCOLOR , STATE_NORMAL } }
   Local aStyleChild := { { "white", FGCOLOR , STATE_NORMAL },;
                          { "red",   FGCOLOR , STATE_PRELIGHT }}


   // By default, division by zero results in zero
   IF oError:genCode == EG_ZERODIV
      RETURN 0
   ENDIF

   // Set NetErr() of there was a database open error
   IF oError:genCode == EG_OPEN .AND. ;
      oError:osCode == 32 .AND. ;
      oError:canDefault
      NetErr( .T. )
      RETURN .F.
   ENDIF

   // Set NetErr() if there was a lock error on dbAppend()
   IF oError:genCode == EG_APPENDLOCK .AND. ;
      oError:canDefault
      NetErr( .T. )
      RETURN .F.
   ENDIF

   cMessage := ErrorMessage( oError )

   IF ! Empty( oError:osCode )
      cDOSError := "(DOS Error " + LTrim( Str( oError:osCode ) ) + ")"
   ENDIF

   IF ! Empty( oError:osCode )
      cMessage += " " + cDOSError
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

*   MsgStop( cMessage, "Error" )

   cText += "Application" + CRLF
   cText += "===========" + CRLF
   cText += "   Path and name: " + HB_ArgV( 0 ) + " (32 bits)" + HB_OsNewLine()


   cText += "   Error occurred at: " + ;
                DToC( Date() ) + ", " + Time() + CRLF

   // Error object analysis
   cMessage   = ErrorMessage( oError ) + CRLF
   cText += "   " + "Error description:" + cMessage

   if ValType( oError:Args ) == "A"
      cText += "   Args:" + CRLF
      for n = 1 to Len( oError:Args )
         cText += "     [" + Str( n, 4 ) + "] = " + ;
	                ValType( oError:Args[ n ] ) + "   " + ;
	                cValToChar( oError:Args[ n ] ) + CRLF
      next
   endif

   cText += CRLF + "Stack Calls" + CRLF
   cText += "===========" + CRLF

   n := 2

   WHILE ! Empty( ProcName( n ) )
			cText += "Called from " + ProcFile( n ) + "->" + ProcName(n) + "(" + AllTrim( Str( ProcLine( n ) ) ) + ")" + CRLF
			g_print( "Called from " + ProcFile( n ) + "->" + ProcName(n) + "(" + AllTrim( Str( ProcLine( n ) ) ) + ")" + CRLF )
      n++
   ENDDO

    DEFINE WINDOW oWnd TITLE "Errorsys T-Gtk MultiSystem"
          // oWnd:lInitiate := .F. //Fuerzo a entrar en otro bucles de procesos.

           DEFINE BOX oBox VERTICAL OF oWnd CONTAINER
                      cMessage := '<span foreground="green"><i>'+;
                                  "Error Description:"+"</i>"+CRLF+;
                                  '<span foreground="black"><b>'+cMessage +'</b></span></span>'

                      DEFINE LABEL TEXT cMessage MARKUP OF oBox

                      DEFINE EXPANDER oExpand ;
                                      TEXT cTextExpand MARKUP ;
                                      EXPAND FILL OF oBox ;
                                      ACTION oWnd:Center( GTK_WIN_POS_CENTER_ALWAYS )

                      DEFINE SCROLLEDWINDOW oScrool ;
                             SIZE 400,400 OF oExpand CONTAINER

                      DEFINE MEMO oMemo VAR cText OF oScrool CONTAINER
                          oMemo:SetLeft( 10 ) 
                          oMemo:SetRight( 20 )
               
               DEFINE BOX oBoxH  OF oBox

               DEFINE BUTTON oBtn TEXT "_QUIT" MNEMONIC OF oBoxH EXPAND FILL ;
                            ACTION ( lReturn := NIL, oWnd:End() )

               if oError:canRetry
                  DEFINE BUTTON oBtn TEXT "_Entry" MNEMONIC OF oBoxH EXPAND FILL;
                         ACTION ( lReturn := .T.,oWnd:End() )
               endif

               if oError:CanDefault
                  DEFINE BUTTON oBtn TEXT "_Default" MNEMONIC OF oBoxH EXPAND FILL ;
                         ACTION ( lReturn := .F., oWnd:End() )
               endif

               DEFINE FONT oFont NAME "Sans italic bold 13" 
               
               DEFINE BUTTON oBtn TEXT "_Save error.log" MNEMONIC;
                                 ACTION Memowrit( "error.log", cText ) ;
                                 FONT oFont ;
                                 STYLE aStyle ;
                                 STYLE_CHILD aStyleChild ;
                                 OF oBoxH

    ACTIVATE WINDOW oWnd CENTER INITIATE
    
    if lReturn == NIL
       GetWndMain():End()      
       ErrorLevel( 1 )
       QUIT
    endif    

RETURN lReturn

// SALIR DEL PROGRAMA Eliminando todo resido memorial ;-)
// Salimos 'limpiamente' de la memoria del ordenador
Static Function __Salir( oWnd )
       Local nLen := Len( oWnd:aWindows ) - 1
       Local X
/*
       if nLen > 0
          FOR X := nLen To 1
             oWnd:aWindows[x]:bEnd := NIL
             oWnd:aWindows[x]:End()
          NEXT
       endif
*/
       oWnd:End()       
       GetWndMain():End()
       ErrorLevel( 1 )
       QUIT

Return .F.

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
