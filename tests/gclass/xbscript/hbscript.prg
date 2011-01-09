/*
 * $Id: hbscript.prg,v 1.1 2010-12-27 04:16:28 riztan Exp $
 * GUI T-Gtk para Harbour
 * Uso de scripts.
 * (c)2010 Riztan Gutierrez
 * Demo en script
 */

#include "gclass.ch"
#include "tgtkext.ch"
#include "common.ch"

STATIC s_aIncDir := {}


FUNCTION MAIN( cFile, ... )

local cMemo,cPath
   LOCAL pHRB, cHRB, cFunc, bBlock, cEol

   cPath := getenv( "HB_INSTALL_INC" )
   IF !EMPTY( cPath )
      AADD( s_aIncDir, "-I" + cPath )
   ENDIF

   cPath := getenv( "TGTK_INC" )
   IF !EMPTY( cPath )
      AADD( s_aIncDir, "-I" + cPath )
   ENDIF

   AEVAL( HB_aTokens( GetEnv("PATH"), hb_osPathListSeparator() ), ;
          {|a| IIF( "inc"$a, AADD( s_aIncDir, "-I" + a ),) } )

default cFile := 'test.prg'

cMemo := memoread(cFile)


REQUEST MSG_INFO
REQUEST GTREEVIEW
REQUEST GSTATUSBAR
REQUEST GTOOLTIP
REQUEST GTOGGLEBUTTON
REQUEST GENTRY
REQUEST GSPINBUTTON
REQUEST GCHECKBOX
REQUEST GTK_CALENDAR_GET_DATE
REQUEST MSG_INFO
REQUEST MSGBOX
REQUEST GMENUBAR
REQUEST GMENU
REQUEST GMENUITEM
REQUEST GMENUTEAROFF
REQUEST GMENUSEPARATOR
REQUEST GMENUITEMCHECK
REQUEST GMENUITEMIMAGE
REQUEST XHB_LIB
request wqout
/*
 HB_COMPILEBUF( HB_ARGV( 0 ), "-n2", "-w0", "-es2", "-q0", ;
               s_aIncDir, "-I" + FNameDirGet( cFile ), "-D" + "__HBSCRIPT__HBRUN", cFile )

? hbrun_filesig(cFile)
*/

hbrun_Exec('CLEA SCRE ; ? Val("01") ; ? "bien"  ')
RUNXBS( cmemo,"1" ) 
? hbrun_DirBase()

//? hb_compilefrombuf( HB_ARGV( 0 ), "-n2","-w","-es" )

//HB_COMPILEFROMBUF( cMemo, HB_ARGV( 0 ), "-n2", "-w0", "-es2", "-q0", ;
//               s_aIncDir, "-I" + FNameDirGet( cFile ), "-D" + "__HBSCRIPT__HBRUN" )

//   cHRB := HB_COMPILEFROMBUF( cMemo, HB_ARGV( 0 ), "-n2", "-w0", "-es2", s_aIncDir, "-I\tgtkdevel\include" , "-D" + "__HBSCRIPT__HBRUN" )
//? cHRB
//EVAL( ErrorBlock(), "ERROR PROVOCADO POR MI" )

/*   BEGIN SEQUENCE WITH {|oErr| hbrun_Err( oErr, cMemo ) }

      IF cHRB == NIL
         EVAL( ErrorBlock(), "Syntax error." )
      ELSE
         pHRB := hb_hrbLoad( cHRB )
         IF pHrb != NIL
            bBlock := hb_hrbDo( pHRB )
            DevPos( s_nRow, s_nCol )
            Eval( bBlock )
            s_nRow := Row()
            s_nCol := Col()
            IF s_nRow < 2
               s_nRow := 2
            ENDIF
         ENDIF
      ENDIF
    ENDSEQUENCE
*/

return nil


STATIC FUNCTION FNameDirGet( cFileName )
   LOCAL cDir

   hb_FNameSplit( cFileName, @cDir )

RETURN cDir

#include "fileio.ch"

FUNCTION hbrun_FileSig( cFile )
   LOCAL hFile
   LOCAL cBuff, cSig, cExt

   cExt := ".prg"
   hFile := FOpen( cFile, "R" )
   IF hFile != F_ERROR
      cSig := hb_hrbSignature()
      cBuff := Space( Len( cSig ) )
      FRead( hFile, @cBuff, Len( cSig ) )
      FClose( hFile )
      IF cBuff == cSig
         cExt := ".hrb"
      ENDIF
   ENDIF

RETURN cExt

PROCEDURE hbrun_Err( oErr, cCommand )

   LOCAL xArg, cMessage

   cMessage := "Sorry, could not execute:;;" + cCommand + ";;"
   IF oErr:ClassName == "ERROR"
      cMessage += oErr:Description
      IF ISARRAY( oErr:Args ) .AND. Len( oErr:Args ) > 0
         cMessage += ";Arguments:"
         FOR EACH xArg IN oErr:Args
            cMessage += ";" + HB_CStr( xArg )
         NEXT
      ENDIF
   ELSEIF ISCHARACTER( oErr )
      cMessage += oErr
   ENDIF
   cMessage += ";;" + ProcName( 2 ) + "(" + hb_NToS( ProcLine( 2 ) ) + ")"

   Alert( cMessage )

   BREAK( oErr )

