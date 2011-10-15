/*
 * $Id: 10/13/2010 5:51:31 PM tdolpexp.prg Z dgarciagil $
 */
   
/*
 * TDOLPHIN PROJECT source code:
 * Export Query information to specific format ( text, excel )
 *
 * Copyright 2010 Daniel Garcia-Gil<danielgarciagil@gmail.com>
 * www - http://tdolphin.blogspot.com/
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
 * along with this software.  If not, write to
 * the Free Software Foundation, Inc., 59 Temple Place, Suite 330,
 * Boston, MA 02111-1307 USA (or visit the web site http://www.gnu.org/).
 *
 * As a special exception, the tdolphin Project gives permission for
 * additional uses of the text contained in its release of tdolphin.
 *
 * The exception is that, if you link the tdolphin libraries with other
 * files to produce an executable, this does not by itself cause the
 * resulting executable to be covered by the GNU General Public License.
 * Your use of that executable is in no way restricted on account of
 * linking the tdolphin library code into it.
 *
 * This exception does not however invalidate any other reasons why
 * the executable file might be covered by the GNU General Public License.
 *
 * This exception applies only to the code released by the tdolphin
 * Project under the name tdolphin.  If you copy code from other
 * tdolphin Project or Free Software Foundation releases into a copy of
 * tdolphin, as the General Public License permits, the exception does
 * not apply to the code that you add in this way.  To avoid misleading
 * anyone as to the status of such modified files, you must delete
 * this exception notice from them.
 *
 * If you write modifications of your own for tdolphin, it is your choice
 * whether to permit this exception to apply to your modifications.
 * If you do not wish that, delete this exception notice.
 *
 */

#ifdef __WIN__
#include "hbclass.ch"
#include "common.ch"
#include "dbstruct.ch"
#include "tdolphin.ch"
#include "dolerr.ch"
#include "fileio.ch"
#ifndef __XHARBOUR__
#include "hbcompat.ch"
#endif

#define USE_HASH
#ifndef CRLF 
#define CRLF Chr( 13 ) + Chr( 10 )
#endif

//Main class to manager exports 
CLASS TDolphinExport 
 
    DATA oQuery        /* Query object */
    DATA aColumns      /* Columns seelct to fill file */
    DATA aPictures     /* Columns's Picture */
 
    DATA cFileName     /* File name */
    DATA hFile
    DATA lAddHeader
    
    DATA nType         /* Export type */
    DATA bOnRow        /* codeblock to evaluate row by row */
    DATA bOnStart      /* codeblock to evaluate at the begin process */
    DATA bOnEnd        /* codeblock to evaluate at the end process */ 
    DATA oExport       /* Export Objet, is direftent by type */
    DATA oMain         /* Self */
    

    METHOD New( nType, oQuery, aColumns, aPictures  )
    
    METHOD Start() INLINE ::oExport:Export()
    METHOD Write( cLine, lNoCRLF ) 
    METHOD Close()  INLINE FClose( ::hFile )
    
    ERROR HANDLER ONERROR()
 
 
ENDCLASS

//----------------------------------------//

METHOD New( nType, oQuery, cFileName, aColumns, aPictures  ) CLASS TDolphinExport 

   DEFAULT nType TO EXP_TEXT

   ::oQuery     = oQuery
   ::aColumns   = aColumns
   ::aPictures  = aPictures
   
   IF Empty( cFileName )
      oQuery:oServer:nInternalError = ERR_INVALIDFILENAME
      oQuery:oServer:CheckError()
   ENDIF
   
   ::cFileName  = cFileName
      

   SWITCH nType
      CASE EXP_TEXT
         ::oExport = TDolphinToText():New( Self )
         EXIT
      CASE EXP_EXCEL
         ::oExport = TDolphinToExcel():New( Self )
         EXIT 
      CASE EXP_DBF
         ::oExport = TDolphinToDbf():New( Self )
         EXIT 
      CASE EXP_HTML
         ::oExport = TDolphinToHtml():New( Self )
         EXIT          
      CASE EXP_WORD
         ::oExport = TDolphinToWord():New( Self )
         EXIT           
      CASE EXP_SQL
         ::oExport = TDolphinToSql():New( Self )
         EXIT           

   ENDSWITCH 

RETURN Self

//----------------------------------------// 

METHOD ONERROR( uParam ) CLASS TDolphinExport

   LOCAL cMsg   := __GetMessage()
   LOCAL a

#ifndef __XHARBOUR__
   IF uParam == nil
      a = __ObjSendMsg( ::oExport, cMsg )
   ELSE
      a = __ObjSendMsg( ::oExport, cMsg, uParam )
   ENDIF
#else   

   IF uParam == nil
      a = hb_execFromArray( @::oExport, cMsg )
   ELSE
      a = hb_execFromArray( @::oExport, cMsg, { uParam } )
   ENDIF
#endif

RETURN a

METHOD Write( cLine, lNoCRLF ) CLASS TDolphinExport

   local crlf := CRLF

   DEFAULT lNoCRLF TO .F.
   
   IF lNoCRLF
      crlf = ""
   ENDIF 

RETURN FWrite( ::hFile, cLine += crlf, Len( cLine ) )

//----------------------------------------// 
// Start export to text
//----------------------------------------// 
 
CLASS TDolphinToText FROM TDolphinExport
 
    DATA cRowDelimiter
    DATA cTextQualifer
    DATA cFieldDelimiter
    DATA lAppend
    
    
    METHOD New( oMain )
    METHOD Export()
   
ENDCLASS 

//----------------------------------------// 

METHOD New( oMain ) CLASS TDolphinToText

   ::oMain = oMain
   ::cRowDelimiter = CRLF
   ::cTextQualifer = ''
   ::cFieldDelimiter = ";"
   ::lAppend = .F.
   ::lAddHeader = .F.
   
RETURN Self

//----------------------------------------// 

METHOD Export() CLASS TDolphinToText

   LOCAL oQuery    := ::oMain:oQuery 
   LOCAL aColumns  := ::oMain:aColumns
   LOCAL aPictures := ::oMain:aPictures
   LOCAL cLine     := "", cField, uField
   LOCAL bOnRow    := ::oMain:bOnRow
   LOCAL bOnStart  := ::oMain:bOnStart
   LOCAL bOnEnd    := ::oMain:bOnEnd
   LOCAL n := 1
   LOCAL nId
   LOCAL cTitle, cHeader := ""
   
   IF hb_IsObject( oQuery )
      IF Empty( aColumns )
         aColumns = {}
         AEval( oQuery:aStructure, {| aRow | AAdd( aColumns, aRow[ MYSQL_FS_NAME ] ) } )
      ENDIF
      IF hb_IsArray( aPictures )
         IF Len( aPictures ) != Len( aColumns )
            aPictures = ASize( aPictures, Len( aColumns ) )
         ENDIF
      ELSE 
         aPictures = Array( Len( aColumns ) )
      ENDIF

      IF ! File( ::oMain:cFileName )
        FClose( FCreate( ::oMain:cFileName ) )
      ENDIF

     IF( ( ::hFile := FOpen( ::oMain:cFileName, FO_WRITE ) ) != -1 )
        Super:hFile = ::hFile
        IF ::lAppend
           FSeek( ::hFile, 0, FS_END )
        ENDIF
     ENDIF      
     
      IF bOnStart != NIL 
         Eval( bOnStart, Self )
      ENDIF
     
     
     IF ::lAddHeader
        FOR EACH cTitle IN aColumns
#ifdef __XHARBOUR__
            nId = HB_EnumINdex()
#else 
            nId = cTitle:__EnumIndex()
#endif          
           cHeader += ( ::cTextQualifer + ;
                       PadR( cTitle,  oQuery:aStructure[ nId ][ MYSQL_FS_LENGTH ] ) + ;
                       ::cTextQualifer + ;
                       ::cFieldDelimiter )        
        NEXT 
         //Remove Last Delimiter
         cHeader = SubStr( cHeader, 1, Len( cHeader ) - 1 ) + ::cRowDelimiter
         FWrite( ::hFile, cHeader, Len( cHeader ) )
     ENDIF
           

     DO WHILE ! oQuery:Eof()
        FOR EACH cField IN aColumns
#ifdef __XHARBOUR__
            nId = HB_EnumINdex()
#else 
            nId = cField:__EnumIndex()
#endif      
            uField = Clip2Str( oQuery:FieldGet( cField ), aPictures[ nId ] )
            
            cLine += ( ::cTextQualifer + ;
                       uField + ;
                       ::cTextQualifer + ;
                       ::cFieldDelimiter )
         NEXT 
         //Remove Last Delimiter
         cLine = SubStr( cLine, 1, Len( cLine ) - 1 ) + ::cRowDelimiter
         IF bOnRow != NIL
            Eval( bOnRow, Self, n, cLine )
         ENDIF
         FWrite( ::hFile, cLine, Len( cLine ) )
         cLine := ""
         n++
         oQuery:Skip()
      ENDDO

      IF bOnEnd != NIL 
         Eval( bOnEnd, Self )
      ENDIF      
      
      ::Close()
      
   ENDIF
         

RETURN NIL

//----------------------------------------// 
// end export to text
//----------------------------------------// 

//----------------------------------------// 
// Start export to excel
//----------------------------------------// 

CLASS TDolphinToExcel FROM TDolphinExport

   DATA lOpened
   DATA cxlSum
   DATA cxlTrue
   DATA cxlFalse
   DATA cxyearformat, cxmonthformat, cxdayformat
   DATA lMakeTotals
   DATA oExcel
   DATA nRow, nCol
   
   
   METHOD New( oMain )
   
   METHOD ConvertToExcel( uVal ) 
   METHOD Export()
   METHOD SetExcelLanguage()

ENDCLASS

//----------------------------------------// 

METHOD New( oMain ) CLASS TDolphinToExcel

   LOCAL oError

   ::oMain       = oMain
   ::lAddHeader  = .T.
   ::lOpened     = .F.
   ::lMakeTotals = .F.

   TRY
      ::oExcel   = GetActiveObject( "Excel.Application" )      
      ::lOpened  = .T.
   CATCH oError
      TRY 
         ::oExcel   := CreateObject( "Excel.Application" )
      CATCH oError
         ::oMain:oQuery:oServer:nInternalError = ERR_NOEXCELINSTALED
         ::oMain:oQuery:oServer:CheckError(, Ole2TxtError())
      END
   END   
   ::SetExcelLanguage()

   
RETURN Self


//----------------------------------------// 

METHOD ConvertToExcel( uVal, nId ) CLASS TDolphinToExcel
   
   LOCAL cType := ValType( uVal )
   LOCAL cDtFmt
   
   SWITCH cType
      CASE "N"
         uVal = Str( uVal, ::oMain:oQuery:aStructure[ nId ][ MYSQL_FS_LENGTH ], ::oMain:oQuery:aStructure[ nId ][ MYSQL_FS_DECIMALS ] )
         exit 
      CASE "L"
         uVal = If( uVal, ::cxlTrue, ::cxlFalse )
         exit 
      CASE "D"
         cDtFmt    := Set( _SET_DATEFORMAT )
//         Set( _SET_DATEFORMAT, StrTran( "YYYY-MM-DD", "Y", Upper( ::cxyearformat ) ) )
         Set( _SET_DATEFORMAT, "YYYY-MM-DD" )
         uVal = DToC( uVal )
         Set(_SET_DATEFORMAT, cDtFmt )

         exit 
   ENDSWITCH
   
RETURN uVal          
   


//----------------------------------------// 

METHOD Export() CLASS TDolphinToExcel
   
   LOCAL oSheet, oBook, oError
   LOCAL cField, aRow, nID, nPasteRow
   LOCAL oQuery    := ::oMain:oQuery
   LOCAL aColumns  := ::oMain:aColumns
   LOCAL aPictures := ::oMain:aPictures   
   LOCAL bOnRow    := ::oMain:bOnRow   
   LOCAL lAddHeader:= ::lAddHeader
   LOCAL bOnStart  := ::oMain:bOnStart
   LOCAL bOnEnd    := ::oMain:bOnEnd
   LOCAL aStructure := oQuery:aStructure
   LOCAL uVal, oExcel := ::oExcel
   LOCAL RetVal := "", cDtFmt
   
   ::nRow = 1
   ::nCol = 0

   TRY 
      oExcel:DisplayAlerts  = .F.
      oExcel:ScreenUpdating = .F.
      
      oBook   = oExcel:WorkBooks:Add()
      oSheet  = oExcel:ActiveSheet()
      
      IF bOnStart != NIL
         Eval( bOnStart, Self )
      ENDIF
      
      IF Empty( aColumns )
         aColumns = {}
         AEval( aStructure, {| aRow | AAdd( aColumns, aRow[ MYSQL_FS_NAME ] ) } )
      ENDIF   

      IF hb_IsArray( aPictures )
         IF Len( aPictures ) != Len( aColumns )
            aPictures = ASize( aPictures, Len( aColumns ) )
         ENDIF
      ELSE 
         aPictures = Array( Len( aColumns ) )
      ENDIF
      //Make header and cell format
      FOR EACH cField IN aColumns
         ++::nCol
         IF lAddHeader
            oSheet:Cells( ::nRow, ::nCol ):Value  = cField       
         ENDIF
         IF aStructure[ ::nCol ][ MYSQL_FS_LENGTH ] < 255
            oSheet:Columns( ::nCol ):ColumnWidth  = Max( Len( cField ), aStructure[ ::nCol ][ MYSQL_FS_LENGTH ] + 2 )
         ENDIF
         DO CASE
            CASE aStructure[ ::nCol ][ MYSQL_FS_CLIP_TYPE ] = "N"
               oSheet:Columns( ::nCol ):NumberFormat = clp2xlnumpic( aPictures[ ::nCol ] )
               oSheet:Columns( ::nCol ):HorizontalAlignment := -4152
            CASE aStructure[ ::nCol ][ MYSQL_FS_CLIP_TYPE ] = "D"
              IF ValType( aPictures[ ::nCol ] ) == 'C' 
                 cDtFmt = Lower( aPictures[ ::nCol ] )
              ELSE
                 cDtFmt = Lower( Set( _SET_DATEFORMAT ) )
              ENDIF
              //convert excel date format
              //year
              cDtFmt = StrTran( cDtFmt, "y", ::cxyearformat )
              //month
              cDtFmt = StrTran( cDtFmt, "m", ::cxmonthformat )
              //day
              cDtFmt = StrTran( cDtFmt, "d", ::cxdayformat )      
              oSheet:Columns( ::nCol ):NumberFormat := cDtFmt
              oSheet:Columns( ::nCol ):HorizontalAlignment := -4152

           CASE aStructure[ ::nCol ][ MYSQL_FS_CLIP_TYPE ] = "M"
              oSheet:Columns( ::nCol ):ColumnWidth  := 254
              oSheet:Columns( ::nCol ):WrapText  := .T.
              
           CASE aStructure[ ::nCol ][ MYSQL_FS_LENGTH ] > 254
              oSheet:Columns( ::nCol ):ColumnWidth  := 254
              oSheet:Columns( ::nCol ):WrapText  := .T.
              
         ENDCASE
      NEXT
      IF lAddHeader
         oSheet:Rows( ::nRow ):Font:Bold   := .T.
         oSheet:Range( oSheet:Cells( ::nRow, 1 ), oSheet:Cells( ::nRow, ::nCol ) ):Select()
         oExcel:Selection:Borders( 9 ):LineStyle := 1   // xlContinuous = 1
         oExcel:Selection:Borders( 9 ):Weight    := -4138   // xlThin = 2, xlHairLine = 1, xlThick = 4, xlMedium = -4138
         ::nRow++  
      ENDIF
      ::nCol = 0
      
      //Fill Sheet 
      __OpenClipboard( oExcel:hWnd )
      nPasteRow = ::nRow
      DO WHILE ! oQuery:Eof()
         FOR EACH cField IN aColumns
#ifdef __XHARBOUR__
            nId = HB_EnumINdex()
#else 
            nId = cField:__EnumIndex()
#endif   

#ifdef USE_HASH   
         uVal = ::ConvertToExcel( oQuery:hRow[ "_" + cField ], nId )
#else          
         uVal = ::ConvertToExcel( oQuery:aRow[ nId ], nId )
#endif
         
         RetVal += StrTran( StrTran( uVal, CRLF, " ; " ), Chr(9), ' ' ) + Chr( 9 )
         
            
         NEXT
         RetVal += CRLF
         ::nRow++

         IF Len( RetVal ) > 16000
            __OpenClipboard()
            __EmptyClipboard()
            __SetClipboardData( RetVal )
            __CloseClipboard()
            oSheet:Cells( nPasteRow, 1 ):Select()
            oSheet:Paste()
            __OpenClipboard()         
            __EmptyClipboard()
            __CloseClipboard()
            RetVal    = ""
            nPasteRow = ::nRow
         ENDIF
         
         IF bOnRow != NIL
            Eval( bOnRow, oQuery:RecNo, Self )
         ENDIF
         ::nCol = 0
         oQuery:Skip()
      ENDDO
      IF ! Empty( RetVal )
         __OpenClipboard()
         __EmptyClipboard()
         __SetClipboardData( RetVal )
         __CloseClipboard()
         oSheet:Cells( nPasteRow, 1 ):Select()
         oSheet:Paste()
         __OpenClipboard()         
         __EmptyClipboard()
         __CloseClipboard()
         RetVal    = ""
         nPasteRow = ::nRow
      ENDIF      
      
      //Make Totals
      IF ::lMakeTotals
         ::nCol = 0
         oSheet:Rows( ::nRow ):Font:Bold   := .T.
         ::nRow--
         oSheet:Range( oSheet:Cells( ::nRow, 1 ), oSheet:Cells( ::nRow, Len( aColumns ) ) ):Select()
         oExcel:Selection:Borders( 9 ):LineStyle := 1   
         oExcel:Selection:Borders( 9 ):Weight    := -4138
         ::nRow++
         FOR EACH cField IN aColumns
            IF aStructure[ ++::nCol ][ MYSQL_FS_CLIP_TYPE ] = "N"
               oSheet:Cells( ::nRow, ::nCol ):Formula := "=" + ::cxlSum + ;
                                   oSheet:Range( oSheet:Cells( 2, ::nCol ), ;
                                   oSheet:Cells( ::nRow - 1, ::nCol ) ):Address( .f., .f. ) + ")"
            ENDIF
         NEXT   
      ENDIF
      oSheet:Cells( 1,1 ):Select()
      
      IF bOnEnd != NIL 
         Eval( bOnEnd, oExcel, ::nRow, ::nCol )
      ENDIF
      oExcel:ScreenUpdating = .T.
      oBook:SaveAs( ::oMain:cFileName )
      
   CATCH oError
      oError:Description = Ole2TxtError()
      oBook:Close( .F. )
      IF ! ::lOpened   
         oExcel:Quit()
      ENDIF

      oQuery:oServer:nInternalError = ERR_EXPORTTOEXCEL
      oQuery:oServer:CheckError( , oError:Description )

   END         
   
   IF ! ::lOpened   
      ::oExcel:Quit()
   ELSE 
      oBook:Close()
   ENDIF
   
RETURN NIL

//----------------------------------------// 

METHOD SetExcelLanguage() CLASS TDolphinToExcel

   local aEng     := { 1033, 2057, 10249, 4105, 9225, 14345, 6153, 8201, 5129, 13321, 7177, 11273, 12297 }
   local aSpanish := {3082,1034,11274,16394,13322,9226,5130,7178,12298,17418,4106,18442,;
                     58378,2058,19466,6154,15370,10250,20490,21514,14346,8202}
   local aGerman  := {1031,3079,5127,4103,2055}
   local aFrench  := {1036,2060,11276,3084,9228,12300,15372,5132,13324,6156,14348,58380,8204,10252,4108,7180}

   local nxlLangID  := .f.

   nxlLangID := ::oExcel:LanguageSettings:LanguageID( 2 )
   ::cxyearformat = Lower( ::oExcel:International( 19 ) ) //xlYearCode=19
   ::cxmonthformat = Lower( ::oExcel:International( 20 ) ) //xlMonthCode=20
   ::cxdayformat = Lower( ::oExcel:International( 21 ) ) //xlDayCode=21

   do case
      case AScan( aEng, nxlLangID ) > 0 // English
         ::cxlSum      = "SUM("
         ::cxlTrue     = "TRUE"
         ::cxlFalse    = "TRUE"

      case AScan( aSpanish, nxlLangID ) > 0 // Spanish
         ::cxlSum      = "SUMA("
         ::cxlTrue     = "VERDADERO"
         ::cxlFalse    = "FALSO"

      case nxlLangID == 1040 .or. nxlLangID == 2064 // Italian
         ::cxlSum      = "SOMMA("
         ::cxlTrue     = "VERO"
         ::cxlFalse    = "FALSO"         

      case AScan( aGerman, nxlLangID ) > 0 // German
         ::cxlSum      = "SUMME("
         ::cxlTrue     = "WAHR"
         ::cxlFalse    = "FALSCH"
            
      case AScan( aFrench, nxlLangID ) > 0 // French
         ::cxlSum      = "SOMME("
         ::cxlTrue     = "VRAI"
         ::cxlFalse    = "FAUX"         

      case nxlLangID == 2070 .or. nxlLangID == 1046 // Portugese
         ::cxlSum      = "SOMA("
         ::cxlTrue     = "VERDADEIRO"
         ::cxlFalse    = "FALSO"         
         
   endcase

return nil   

static function clp2xlnumpic( cPic )

   local cFormat, aPic, c
   local cDecimal  := GetDecimalSep()
   local cThousand := GetThousandSep()
   

   if cPic == nil
      cFormat  := "0"
   else
      if cThousand $ cPic
         cFormat = "#" + cThousand + "##"
      endif
      if cDecimal $ cPic
         cFormat += "0" + cDecimal + "00"
      endif         
   endif

return cFormat

//----------------------------------------// 
// end export to excel
//----------------------------------------// 

//----------------------------------------// 
// Start export to dbf
//----------------------------------------// 

CLASS TDolphinToDbf FROM TDolphinExport

   DATA cDriver
   DATA cAlias
   
   METHOD New( oMain )
   
   METHOD Export()
   
    METHOD Write()  VIRTUAL
    METHOD Close()  VIRTUAL
   

ENDCLASS

//----------------------------------------// 

METHOD New( oMain ) CLASS TDolphinToDbf

   LOCAL oError

   ::oMain       = oMain
   ::cAlias      = "TEMP" + StrZero( Round( hb_Random( 100, 999 ), 2 ), 4 )

   IF ! ( ".dbf" $ Lower( ::oMain:cFileName ) )
      ::oMain:cFileName += ".dbf"
   ENDIF
   
      
RETURN Self

//----------------------------------------// 

METHOD Export() CLASS TDolphinToDbf

   LOCAL aStructure := {}
   LOCAL uField
   LOCAL oQry := ::oMain:oQuery
   LOCAL aColumns := ::oMain:aColumns
   LOCAL nField, cFile, cAlias := ::cAlias
   LOCAL bOnRow    := ::oMain:bOnRow
   LOCAL bOnStart  := ::oMain:bOnStart
   LOCAL bOnEnd    := ::oMain:bOnEnd   
   
   DEFAULT ::cDriver TO "DBFNTX"

   IF bOnStart != NIL
      Eval( bOnStart, Self )
   ENDIF

   IF ! Empty( aColumns )
      FOR EACH uField IN aColumns
         nField = oQry:FieldPos( uField )
         AAdd( aStructure, { Lower( oQry:aStructure[ nField ][ MYSQL_FS_NAME ] ),;
                             oQry:aStructure[ nField ][ MYSQL_FS_CLIP_TYPE ],;
                             oQry:aStructure[ nField ][ MYSQL_FS_LENGTH ],;
                             oQry:aStructure[ nField ][ MYSQL_FS_DECIMALS ] } )
      NEXT                     
   ELSE
      FOR EACH uField IN oQry:aStructure
         AAdd( aStructure, { uField[ MYSQL_FS_NAME ],;
                             uField[ MYSQL_FS_CLIP_TYPE ],;
                             uField[ MYSQL_FS_LENGTH ],;
                             uField[ MYSQL_FS_DECIMALS ] } )
      NEXT                     
   ENDIF

   DbCreate( ::oMain:cFileName, aStructure, ::cDriver )
   
   cFile = SubStr( ::oMain:cFileName, 1, RAt( ".", ::oMain:cFileName ) - 1 )
   
   USE ( cFile ) ALIAS ( cAlias ) EXCLUSIVE
   
   DO WHILE ! oQry:Eof()
      ( cAlias )->( DbAppend() )
      AEval( aStructure, { | aRow, nId | ( cAlias )->( FieldPut( nId, oQry:hRow[ "_" + aRow[ MYSQL_FS_NAME ] ] ) ) } )
      IF bOnRow != NIL 
         Eval( bOnRow, Self, oQry:RecNo )
      ENDIF
      oQry:Skip() 
   ENDDO   

   IF bOnEnd != NIL 
      Eval( bOnEnd, Self )
   ENDIF

   
RETURN NIL      

//----------------------------------------// 
// end export to dbf
//----------------------------------------// 

//----------------------------------------// 
// Start export to html
//----------------------------------------// 

CLASS TDolphinToHtml FROM TDolphinExport
   
   DATA cHeader
   DATA cFooter
   
   METHOD New( oMain )
   
   METHOD Export()

ENDCLASS

//----------------------------------------// 

METHOD New( oMain ) CLASS TDolphinToHtml

   LOCAL oError
   LOCAL cExt
   
   ::lAddHeader  = .T.
   
   ::oMain       = oMain
   
   ::cHeader = '<html>' + CRLF +;
               '<head>' + CRLF +;
               '<meta http-equiv="'+'Content-Type"' + CRLF + ;
               'content="' + 'text/html; charset=UTF-8">'+ CRLF +;
               '</head>'
               
   ::cFooter = '</table>'+ CRLF + ;
               '</body>' + CRLF + ;
               '</html>' 
   
   
   
   cExt = Lower( SubStr( oMain:cFileName, Rat( ".", oMain:cFileName ) + 1 ) )

   IF !( cExt $ "htm;html" )
      oMain:oQuery:oServer:nInternalError = ERR_INVALIDHTMLEXT
      oMain:oQuery:oServer:CheckError()      
   ENDIF
   
      
RETURN Self

//----------------------------------------// 

METHOD Export() CLASS TDolphinToHtml

   LOCAL oQuery    := ::oMain:oQuery 
   LOCAL aColumns  := ::oMain:aColumns
   LOCAL aPictures := ::oMain:aPictures
   LOCAL cLine     := "", cField, uField, cTitle
   LOCAL bOnRow    := ::oMain:bOnRow
   LOCAL bOnStart  := ::oMain:bOnStart
   LOCAL bOnEnd    := ::oMain:bOnEnd
   LOCAL n := 1
   LOCAL nId
   
   
   
   IF hb_IsObject( oQuery )
      IF Empty( aColumns )
         aColumns = {}
         AEval( oQuery:aStructure, {| aRow | AAdd( aColumns, aRow[ MYSQL_FS_NAME ] ) } )
      ENDIF
      IF hb_IsArray( aPictures )
         IF Len( aPictures ) != Len( aColumns )
            aPictures = ASize( aPictures, Len( aColumns ) )
         ENDIF
      ELSE 
         aPictures = Array( Len( aColumns ) )
      ENDIF

      IF ! File( ::oMain:cFileName )
        FClose( FCreate( ::oMain:cFileName ) )
      ENDIF

      IF( ( ::hFile := FOpen( ::oMain:cFileName, FO_WRITE ) ) != -1 )
         Super:hFile = ::hFile
      ENDIF        
     
      IF bOnStart != NIL 
         Eval( bOnStart, Self )
      ENDIF
      ::Write( ::cHeader )
      ::Write( '<body bgcolor="#FFFFFF">' ) 
      ::Write( '<table border="' + '1">' ) 

     IF ::lAddHeader
        ::Write( '<tr>' )
        FOR EACH cTitle IN aColumns
           cLine = '<td>' + cTitle + '</td>'
           ::Write( cLine )
        NEXT 
        ::Write( '</tr>' )
     ENDIF

     DO WHILE ! oQuery:Eof()
        cLine = '<tr>' + CRLF
        FOR EACH cField IN aColumns
#ifdef __XHARBOUR__
            nId = HB_EnumINdex()
#else 
            nId = cField:__EnumIndex()
#endif      
            uField = Clip2Str( oQuery:FieldGet( cField ), aPictures[ nId ] )
            cLine += '<td>' + uField + '</td>'
         NEXT 
         ::Write( cLine )
         //Remove Last Delimiter
         cLine = '</tr>'
         IF bOnRow != NIL
            Eval( bOnRow, Self, n, cLine )
         ENDIF
         ::Write( cLine )
         n++
         oQuery:Skip()
      ENDDO
      
      ::Write( ::cFooter )
      
      IF bOnEnd != NIL 
         Eval( bOnEnd, Self )
      ENDIF      
    
      ::Close()
      
   ENDIF

RETURN NIL

//----------------------------------------// 
// end export to html
//----------------------------------------// 

//----------------------------------------// 
// Start export to word
//----------------------------------------// 

CLASS TDolphinToWord FROM TDolphinExport

   DATA lOpened
   DATA oWord
   DATA nRow
   
   METHOD New( oMain )
   
   METHOD Export()
   

ENDCLASS


//----------------------------------------// 

METHOD New( oMain ) CLASS TDolphinToWord

   LOCAL oError

   ::oMain       = oMain
   ::oMain:lAddHeader  = .T.
   ::lOpened     = .F.
   ::nRow = 1
   

   TRY
      ::oWord   = GetActiveObject( "Word.Application" )      
      ::lOpened  = .T.
   CATCH oError
      TRY 
         ::oWord   := CreateObject( "Word.Application" )
      CATCH oError
         ::oMain:oQuery:oServer:nInternalError = ERR_NOWORDINSTALED
         ::oMain:oQuery:oServer:CheckError(, Ole2TxtError())
      END
   END   

   
RETURN Self



//----------------------------------------// 

METHOD Export() CLASS TDolphinToWord
   
   LOCAL oSheet, oBook, oError
   LOCAL cField, aRow, nID
   LOCAL oQuery    := ::oMain:oQuery
   LOCAL aColumns  := ::oMain:aColumns
   LOCAL aPictures := ::oMain:aPictures   
   LOCAL bOnRow    := ::oMain:bOnRow   
   LOCAL lAddHeader:= ::oMain:lAddHeader
   LOCAL bOnStart  := ::oMain:bOnStart
   LOCAL bOnEnd    := ::oMain:bOnEnd
   LOCAL aStructure := oQuery:aStructure
   LOCAL uVal, oWord := ::oWord
   LOCAL RetVal := "", cDtFmt
   LOCAL nLen, oTable, n

   TRY 
      oWord:Visible = .F.
      oWord:DisplayAlerts  = .F.
      oWord:ScreenUpdating = .F.
      
      oBook   = oWord:Documents:Add()
      oSheet  = oWord:ActiveDocument()
      
      IF bOnStart != NIL
         Eval( bOnStart, Self )
      ENDIF
      
      IF Empty( aColumns )
         aColumns = {}
         AEval( aStructure, {| aRow | AAdd( aColumns, aRow[ MYSQL_FS_NAME ] ) } )
      ENDIF   

      IF hb_IsArray( aPictures )
         IF Len( aPictures ) != Len( aColumns )
            aPictures = ASize( aPictures, Len( aColumns ) )
         ENDIF
      ELSE 
         aPictures = Array( Len( aColumns ) )
      ENDIF
      //Make header
      RetVal = ""  
      nLen := Len( aColumns )    
      oTable = oSheet:Tables():Add( oSheet:Range( 0, 0 ), oQuery:LastRec() , nLen )
      IF lAddHeader
         FOR EACH cField IN aColumns
#ifdef __XHARBOUR__
            nId = HB_EnumINdex()
#else 
            nId = cField:__EnumIndex()
#endif          
            oTable:Cell( ::nRow, nId ):Range:InsertBefore( cField )
         NEXT
      ENDIF

      ::nRow++
      
      DO WHILE !oQuery:Eof()
         FOR EACH cField IN aColumns
#ifdef __XHARBOUR__
            nId = HB_EnumINdex()
#else 
            nId = cField:__EnumIndex()
#endif   

#ifdef USE_HASH   
            uVal = Clip2Str( oQuery:hRow[ "_" + cField ], aPictures[ nId ] )
#else          
            uVal = Clip2Str( oQuery:aRow[ nId ], aPictures[ nId ] )
#endif
            oTable:Cell( ::nRow, nId ):Range:InsertBefore( uVal )
         
         NEXT
         ::nRow++

         IF bOnRow != NIL
            Eval( bOnRow, Self, oQuery:RecNo )
         ENDIF 
        
         oQuery:Skip()
      ENDDO
      
      oTable:AutoFormat( 36 ) //wdTableFormatElegant

      oWord:DisplayAlerts  = .T.
      oWord:ScreenUpdating = .T.
      
      IF bOnEnd != NIL
         Eval( bOnRow, Self )
      ENDIF 

      oBook:SaveAs( ::oMain:cFileName )               
      
      
   CATCH oError
      oWord:DisplayAlerts  = .T.
      oWord:ScreenUpdating = .T.
      oError:Description = Ole2TxtError()
      oBook:Close( .F. )
      IF ! ::lOpened   
         oWord:Quit()
      ENDIF

      oQuery:oServer:nInternalError = ERR_EXPORTTOWORD
      oQuery:oServer:CheckError( , oError:Description )

   END         
   
   IF ! ::lOpened   
      ::oWord:Quit()
   ELSE 
      oBook:Close()
   ENDIF
   
RETURN NIL

//----------------------------------------// 
// End export to word
//----------------------------------------// 

//----------------------------------------// 
// Start export to Sql Scrip
//----------------------------------------// 

CLASS TDolphinToSql FROM TDolphinExport

   DATA lDropTable

   METHOD New( oMain )
   
   METHOD Export()
   

ENDCLASS


//----------------------------------------// 

METHOD New( oMain ) CLASS TDolphinToSql

   LOCAL oError

   IF Len( oMain:oQuery:aTables ) > 1
      oMain:oQuery:oServer:nInternalError = ERR_INVALIDTABLES_EXPORTTOSQL
      oMain:oQuery:oServer:CheckError()
      RETURN Self
   ENDIF      

   ::oMain       = oMain
   
   ::lDropTable = .T.

RETURN Self



//----------------------------------------// 

METHOD Export() CLASS TDolphinToSql

   LOCAL cTable 
   LOCAL oQuery := ::oMain:oQuery
   LOCAL cSql, cCol, aRow, uValue
   LOCAL aColumns := ::oMain:aColumns
   LOCAL nID, lSep, nRow
   LOCAL bOnRow := ::oMain:bOnRow
   LOCAL bOnStart := ::oMain:bOnStart
   LOCAL bOnEnd := ::oMain:bOnEnd
   LOCAL lNull := .F.
   LOCAL cInsert
   
   cTable = oQuery:aTables[ 1 ]

   IF hb_IsObject( oQuery )
      IF Empty( aColumns )
         aColumns = {}
         AEval( oQuery:aStructure, {| aRow | AAdd( aColumns, aRow[ MYSQL_FS_NAME ] ) } )
      ENDIF
   ENDIF

   IF File( ::oMain:cFileName )
     IF FErase( ::oMain:cFileName ) < 0
        ::oMain:oQuery:oServer:nInternalError = ERR_INVALIDFILE_EXPORTTOSQL
        ::oMain:oQuery:oServer:CheckError()
        RETURN NIL
     ENDIF
   ENDIF

   FClose( FCreate( ::oMain:cFileName ) )

   IF( ( ::hFile := FOpen( ::oMain:cFileName, FO_WRITE ) ) != -1 )
      Super:hFile = ::hFile
   ENDIF  
   
   IF bOnStart != NIL 
      Eval( bOnStart, Self )
   ENDIF   
   
   IF ::lDropTable
      cSql = "DROP TABLE IF EXISTS " + cTable + ";" 
      ::Write( cSql )
      cSql = oQuery:oServer:CreateInfo( cTable ) + ";"
      ::Write( cSql )
   ENDIF 
   
   cInsert = "INSERT INTO " + cTable + " ("
   FOR EACH cCol IN aColumns
      cInsert += cCol + ","
   NEXT
   //Remove Last colon
   cInsert = Left( cInsert, Len( cInsert ) - 1 )
   cInsert += ") VALUES "
   oQuery:GoTop()
   nRow = 0
   WHILE nRow < oQuery:nRecCount 
      cSql  = "("
      MySqlDataSeek( oQuery:hResult, nRow )
      aRow = MySqlFetchRow( oQuery:hResult )
      FOR EACH cCol IN aColumns
         
         nID = oQuery:FieldPos( cCol )
    
         lSep = oQuery:aStructure[ nID ][ MYSQL_FS_CLIP_TYPE ] $ "CDM"
         
         uValue = aRow[ nID ]
         
         IF Len( uValue ) == 0 
            uValue = "NULL"
            lNull = .T.
         ENDIF            
         IF lSep .AND. ! lNull
            cSql += "'" + MySqlEscape( uValue, oQuery:oServer:hMysql ) + "'" + ","
         ELSE 
            cSql += uValue + ","
         ENDIF
         lNull = .F.
      NEXT
      nRow ++
      cSql := Left( cSql, Len( cSql ) - 1 )      
      cSql += ");" + CRLF
      ::Write( cInsert + cSql, .T. )
      cSql = ""
      IF bOnRow != NIL 
         Eval( bOnRow, nRow ) 
      ENDIF
   ENDDO   
   IF bOnEnd != NIL 
      Eval( bOnEnd ) 
   ENDIF   
   ::Close()
RETURN NIL
#endif __WIN__
