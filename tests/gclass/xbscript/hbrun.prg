/*
 * $Id: hbrun.prg,v 1.1 2010-12-27 04:16:28 riztan Exp $
 */

/*
 * Harbour Project source code:
 *    "DOt Prompt" Console and .prg/.hrb runner for the Harbour Language
 *
 * Copyright 2007 Przemyslaw Czerpak <druzus / at / priv.onet.pl>
 * Copyright 2008-2010 Viktor Szakats (harbour.01 syenar.hu)
 * www - http://harbour-project.org
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2, or (at your option)
 * any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this software; see the file COPYING.  If not, write to
 * the Free Software Foundation, Inc., 59 Temple Place, Suite 330,
 * Boston, MA 02111-1307 USA (or visit the web site http://www.gnu.org/).
 *
 * As a special exception, the Harbour Project gives permission for
 * additional uses of the text contained in its release of Harbour.
 *
 * The exception is that, if you link the Harbour libraries with other
 * files to produce an executable, this does not by itself cause the
 * resulting executable to be covered by the GNU General Public License.
 * Your use of that executable is in no way restricted on account of
 * linking the Harbour library code into it.
 *
 * This exception does not however invalidate any other reasons why
 * the executable file might be covered by the GNU General Public License.
 *
 * This exception applies only to the code released by the Harbour
 * Project under the name Harbour.  If you copy code from other
 * Harbour Project or Free Software Foundation releases into a copy of
 * Harbour, as the General Public License permits, the exception does
 * not apply to the code that you add in this way.  To avoid misleading
 * anyone as to the status of such modified files, you must delete
 * this exception notice from them.
 *
 * If you write modifications of your own for Harbour, it is your choice
 * whether to permit this exception to apply to your modifications.
 * If you do not wish that, delete this exception notice.
 *
 */
#ifdef __HARBOUR__

#include "common.ch"
#include "gclass.ch"
#include "fileio.ch"
#include "inkey.ch"
#include "setcurs.ch"
#include "error.ch"

#include "hbgtinfo.ch"

/* NOTE: use hbextern library instead of #include "hbextern.ch"
 *       in dynamic builds it will greatly reduce the size because
 *       all function symbols will be registered by harbour shared
 *       library (.dll, .so, .sl, .dyn, ...) not by this code
 */

REQUEST __HB_EXTERN__

REQUEST HB_GT_CGI
REQUEST HB_GT_PCA
REQUEST HB_GT_STD

#define HB_HISTORY_LEN 500
#define HB_LINE_LEN    256
#define HB_PROMPT      "."

STATIC s_nRow := 2
STATIC s_nCol := 0
STATIC s_aIncDir := {}
STATIC s_aHistory := {}
STATIC s_lPreserveHistory := .T.
STATIC s_lWasLoad := .F.

STATIC s_cDirBase

/* ********************************************************************** */

PROCEDURE RUNXBS( cFile, ... )
   LOCAL cPath, cExt, cLogFile := "comp.log", cTempFile, oErr

   IF PCount() > 0

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

#ifdef __PLATFORM__UNIX
      AADD( s_aIncDir, "-I/usr/include/harbour" )
      AADD( s_aIncDir, "-I/usr/local/include/harbour" )
#endif

      If ( !File(cFile) .or. !File(hb_DirBase(cFile)) ) .and. Len(cFile)>5
#ifdef __PLATFORM__UNIX
         cTempFile := "/tmp/hbruntmp"+GetVar("RAMDOM")+".xbs"
#else
         cTempFile := GetEnv("TEMP")+"\hbruntmp.xbs"
#endif
         memowrit( cTempFile, cFile )
         cFile := cTempFile
      EndIf

      cFile := hbrun_FindInPath( cFile )

      hb_FNameSplit( cFile, NIL, NIL, @cExt )
      cExt := lower( cExt )
      SWITCH cExt
         CASE ".prg"
         CASE ".xbs"
         CASE ".hbs"
         CASE ".hrb"
            EXIT
         OTHERWISE
            cExt := hbrun_FileSig( cFile )
      ENDSWITCH

      SWITCH cExt
         CASE ".prg"
         CASE ".xbs"
         CASE ".hbs"
            FReOpen_Stderr( cLogFile, "w" )
            cFile := HB_COMPILEBUF( HB_ARGV( 0 ), "-n2", "-w0", "-es2", "-q0", ;
                                    s_aIncDir, "-I" + FNameDirGet( cFile ), ;
                                    "-D" + "__HBSCRIPT__HBRUN", cFile )

            If HB_ISNIL(cFile)
               If file(cLogFile)
//                  MsgStop(memoread(cLogFile),"Error")
                  oErr := ErrorNew()
                  oErr:severity    := ES_ERROR
                  oErr:genCode     := EG_LIMIT
                  oErr:subSystem   := "hbrun_RUNXBS"
                  oErr:subCode     := 0
                  oErr:description := "Error de Sintaxis"+CRLF+MemoRead(cLogFile)
                  oErr:canRetry    := .f.
                  oErr:canDefault  := .f.
                  oErr:fileName    := cLogFile
                  oErr:osCode      := 0
                  Eval( ErrorBlock(), oErr )
               Else
                  MsgStop( "Posiblemente no localiza archivo de cabecera ", "Error")
                  AEVAL(  s_aIncDir,{|a| MsgInfo(a) } )
               EndIf
               EXIT
            ENDIF
         OTHERWISE
            s_cDirBase := hb_DirBase()
            hb_argShift( .T. )
            hb_hrbRun( cFile, ... )
            EXIT
      ENDSWITCH
   ENDIF
RETURN

STATIC FUNCTION FNameDirGet( cFileName )
   LOCAL cDir

   hb_FNameSplit( cFileName, @cDir )

   RETURN cDir

/* Public hbrun API */
FUNCTION hbrun_DirBase()
   RETURN s_cDirBase

EXIT PROCEDURE hbrun_exit()

   hbrun_HistorySave()

   RETURN

STATIC FUNCTION hbrun_FileSig( cFile )
   LOCAL hFile
   LOCAL cBuff, cSig, cExt

   cExt := ".prg"
   hFile := FOpen( cFile, FO_READ )
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

STATIC PROCEDURE hbrun_Prompt( cCommand )
   LOCAL GetList
   LOCAL cLine
   LOCAL nMaxRow, nMaxCol
   LOCAL nHistIndex
   LOCAL bKeyUP, bKeyDown, bKeyIns, bKeyResize
   LOCAL lResize := .F.

   IF hb_gtVersion( 0 ) == "CGI"
      OutErr( "hbrun: Error: Interactive session not possible with GTCGI terminal driver" + hb_eol() )
      RETURN
   ENDIF

   CLEAR SCREEN
   SET SCOREBOARD OFF
   GetList := {}

   hbrun_HistoryLoad()

   AADD( s_aHistory, padr( "quit", HB_LINE_LEN ) )
   nHistIndex := Len( s_aHistory ) + 1

   IF ISCHARACTER( cCommand )
      AADD( s_aHistory, PadR( cCommand, HB_LINE_LEN ) )
      hbrun_Info( cCommand )
      hbrun_Exec( cCommand )
   ELSE
      cCommand := ""
   ENDIF

   hb_gtInfo( HB_GTI_RESIZEMODE, HB_GTI_RESIZEMODE_ROWS )

   SetKey( K_ALT_V, {|| hb_gtInfo( HB_GTI_CLIPBOARDPASTE ) } )

   Set( _SET_EVENTMASK, hb_bitOr( INKEY_KEYBOARD, HB_INKEY_GTEVENT ) )

   DO WHILE .T.

      IF cLine == NIL
         cLine := Space( HB_LINE_LEN )
      ENDIF

      hbrun_Info( cCommand )

      nMaxRow := MaxRow()
      nMaxCol := MaxCol()
      @ nMaxRow, 0 SAY HB_PROMPT
      @ nMaxRow, Col() GET cLine ;
                       PICTURE "@KS" + hb_NToS( nMaxCol - Col() + 1 )

      SetCursor( IIF( ReadInsert(), SC_INSERT, SC_NORMAL ) )

      bKeyIns  := SetKey( K_INS, ;
         {|| SetCursor( IIF( ReadInsert( !ReadInsert() ), ;
                          SC_NORMAL, SC_INSERT ) ) } )
      bKeyUp   := SetKey( K_UP, ;
         {|| IIF( nHistIndex > 1, ;
                  cLine := s_aHistory[ --nHistIndex ], ) } )
      bKeyDown := SetKey( K_DOWN, ;
         {|| cLine := IIF( nHistIndex < LEN( s_aHistory ), ;
             s_aHistory[ ++nHistIndex ], ;
             ( nHistIndex := LEN( s_aHistory ) + 1, Space( HB_LINE_LEN ) ) ) } )
      bKeyResize := SetKey( HB_K_RESIZE,;
         {|| lResize := .T., hb_KeyPut( K_ENTER ) } )

      READ

      SetKey( K_DOWN, bKeyDown )
      SetKey( K_UP, bKeyUp )
      SetKey( K_INS, bKeyIns )
      SetKey( HB_K_RESIZE, bKeyResize )

      IF LastKey() == K_ESC .OR. EMPTY( cLine ) .OR. ;
         ( lResize .AND. LastKey() == K_ENTER )
         IF lResize
            lResize := .F.
         ELSE
            cLine := NIL
         ENDIF
         IF nMaxRow != MaxRow() .OR. nMaxCol != MaxCol()
            @ nMaxRow, 0 CLEAR
         ENDIF
         LOOP
      ENDIF

      IF EMPTY( s_aHistory ) .OR. ! ATAIL( s_aHistory ) == cLine
         IF LEN( s_aHistory ) < HB_HISTORY_LEN
            AADD( s_aHistory, cLine )
         ELSE
            ADEL( s_aHistory, 1 )
            s_aHistory[ LEN( s_aHistory ) ] := cLine
         ENDIF
      ENDIF
      nHistIndex := LEN( s_aHistory ) + 1

      cCommand := AllTrim( cLine, " " )
      cLine := NIL
      @ nMaxRow, 0 CLEAR
      hbrun_Info( cCommand )

      hbrun_Exec( cCommand )

      IF s_nRow >= MaxRow()
         Scroll( 2, 0, MaxRow(), MaxCol(), 1 )
         s_nRow := MaxRow() - 1
      ENDIF

   ENDDO

   RETURN

/* ********************************************************************** */

STATIC PROCEDURE hbrun_Usage()

   OutStd( 'Harbour "DOt Prompt" Console / runner ' + HBRawVersion() + hb_eol() +;
           "Copyright (c) 1999-2010, Przemyslaw Czerpak" + hb_eol() + ;
           "http://harbour-project.org/" + hb_eol() +;
           hb_eol() +;
           "Syntax:  hbrun [<file[.prg|.hbs|.hrb]> [<parameters,...>]]" + hb_eol() )

   RETURN

/* ********************************************************************** */

STATIC PROCEDURE hbrun_Info( cCommand )

   IF cCommand != NIL
      hb_DispOutAt( 0, 0, "PP: " )
      hb_DispOutAt( 0, 4, PadR( cCommand, MaxCol() - 3 ), "N/R" )
   ENDIF
   IF Used()
      hb_DispOutAt( 1, 0, ;
         PadR( "RDD: " + PadR( RddName(), 6 ) + ;
               " | Area:" + Str( Select(), 3 ) + ;
               " | Dbf: " + PadR( Alias(), 10 ) + ;
               " | Index: " + PadR( OrdName( IndexOrd() ), 8 ) + ;
               " | # " + Str( RecNo(), 7 ) + "/" + Str( RecCount(), 7 ), ;
               MaxCol() + 1 ), "N/BG" )
   ELSE
      hb_DispOutAt( 1, 0, ;
         PadR( "RDD: " + Space( 6 ) + ;
               " | Area:" + Space( 3 ) + ;
               " | Dbf: " + Space( 10 ) + ;
               " | Index: " + Space( 8 ) + ;
               " | # " + Space( 7 ) + "/" + Space( 7 ), ;
               MaxCol() + 1 ), "N/BG" )
   ENDIF
   IF s_lPreserveHistory
      hb_DispOutAt( 1, MaxCol(), "o", "R/BG" )
   ENDIF

   RETURN

/* ********************************************************************** */

STATIC PROCEDURE hbrun_Err( oErr, cCommand )

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

/* ********************************************************************** */

PROCEDURE hbrun_Exec( cCommand )
   LOCAL pHRB, cHRB, cFunc, bBlock, cEol

   cEol := hb_eol()
   cFunc := "STATIC FUNC __HBDOT()" + cEol + ;
            "RETURN {||" + cEol + ;
            "   " + cCommand + cEol + ;
            "   RETURN __MVSETBASE()" + cEol + ;
            "}" + cEol

   BEGIN SEQUENCE WITH {|oErr| hbrun_Err( oErr, cCommand ) }

      cHRB := HB_COMPILEFROMBUF( cFunc, HB_ARGV( 0 ), "-n", "-q2", s_aIncDir )
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

   __MVSETBASE()
   
   RETURN

STATIC FUNCTION HBRawVersion()
   RETURN StrTran( Version(), "Harbour " )

/* ********************************************************************** */

#define _HISTORY_DISABLE_LINE "no"

STATIC PROCEDURE hbrun_HistoryLoad()
   LOCAL cHistory
   LOCAL cLine

   s_lWasLoad := .T.

   IF s_lPreserveHistory
      cHistory := StrTran( MemoRead( hbrun_HistoryFileName() ), Chr( 13 ) )
      IF Left( cHistory, Len( _HISTORY_DISABLE_LINE + Chr( 10 ) ) ) == _HISTORY_DISABLE_LINE + Chr( 10 )
         s_lPreserveHistory := .F.
      ELSE
         FOR EACH cLine IN hb_ATokens( StrTran( cHistory, Chr( 13 ) ), Chr( 10 ) )
            IF ! Empty( cLine )
               AAdd( s_aHistory, PadR( cLine, HB_LINE_LEN ) )
            ENDIF
         NEXT
      ENDIF
   ENDIF

   RETURN

STATIC PROCEDURE hbrun_HistorySave()
   LOCAL cHistory
   LOCAL cLine

   IF s_lWasLoad .AND. s_lPreserveHistory
      cHistory := ""
      FOR EACH cLine IN s_aHistory
         IF !( Lower( AllTrim( cLine ) ) == "quit" )
            cHistory += AllTrim( cLine ) + hb_eol()
         ENDIF
      NEXT
      hb_MemoWrit( hbrun_HistoryFileName(), cHistory )
   ENDIF

   RETURN

STATIC FUNCTION hbrun_HistoryFileName()
   LOCAL cEnvVar
   LOCAL cDir
   LOCAL cFileName

#if defined( __PLATFORM__WINDOWS )
   cEnvVar := "APPDATA"
#else
   cEnvVar := "HOME"
#endif

#if defined( __PLATFORM__DOS )
   cFileName := "hbrunhst.ini"
#else
   cFileName := ".hbrun_history"
#endif

   IF ! Empty( GetEnv( cEnvVar ) )
      cDir := GetEnv( cEnvVar ) + hb_ps() + ".harbour"
   ELSE
      cDir := hb_dirBase()
   ENDIF

   IF ! hb_dirExists( cDir )
      MakeDir( cDir )
   ENDIF

   RETURN cDir + hb_ps() + cFileName

STATIC FUNCTION hbrun_FindInPath( cFileName )
   LOCAL cDir
   LOCAL cName
   LOCAL cExt

   LOCAL cDirPATH

   hb_FNameSplit( cFileName, @cDir, @cName, @cExt )

   FOR EACH cExt IN iif( Empty( cExt ), { ".hbs", ".hrb" }, { cExt } )

      /* Check original filename (in supplied path or current dir) */
      IF hb_FileExists( cFileName := hb_FNameMerge( cDir, cName, cExt ) )
         RETURN cFileName
      ENDIF

      IF Empty( cDir )

         /* Check in the dir of this executable. */
         IF ! Empty( hb_DirBase() )
            IF hb_FileExists( cFileName := hb_FNameMerge( hb_DirBase(), cName, cExt ) )
               RETURN cFileName
            ENDIF
         ENDIF

         /* Check in the PATH. */
         #if defined( __PLATFORM__WINDOWS ) .OR. ;
             defined( __PLATFORM__DOS ) .OR. ;
             defined( __PLATFORM__OS2 )
         FOR EACH cDirPATH IN hb_ATokens( GetEnv( "PATH" ), hb_osPathListSeparator(), .T., .T. )
         #else
         FOR EACH cDirPATH IN hb_ATokens( GetEnv( "PATH" ), hb_osPathListSeparator() )
         #endif
            IF ! Empty( cDirPATH )
               IF hb_FileExists( cFileName := hb_FNameMerge( hbrun_DirAddPathSep( hbrun_StrStripQuote( cDirPATH ) ), cName, cExt ) )
                  RETURN cFileName
               ENDIF
            ENDIF
         NEXT
      ENDIF
   NEXT

   RETURN NIL

STATIC FUNCTION hbrun_DirAddPathSep( cDir )

   IF ! Empty( cDir ) .AND. !( Right( cDir, 1 ) == hb_ps() )
      cDir += hb_ps()
   ENDIF

   RETURN cDir

STATIC FUNCTION hbrun_StrStripQuote( cString )
   RETURN iif( Left( cString, 1 ) == '"' .AND. Right( cString, 1 ) == '"',;
               SubStr( cString, 2, Len( cString ) - 2 ),;
               cString )


#pragma BEGINDUMP

#include <stdio.h>
#include <hbapi.h>


HB_FUNC( FREOPEN_STDERR )
{
   hb_retnl( ( LONG ) freopen( hb_parc( 1 ), hb_parc( 2 ), stderr ) );
}    


#pragma ENDDUMP

#endif
