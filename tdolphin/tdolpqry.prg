/*
 * $Id: 10/13/2010 5:51:31 PM tdolpqry.prg Z dgarciagil $
 */

/*
 * TDOLPHIN PROJECT source code:
 * Manager MySql Queries
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


#include "hbclass.ch"
#include "common.ch"
#include "dbstruct.ch"
#include "tdolphin.ch"
#include "dolerr.ch"

#ifndef __XHARBOUR__
   #include "hbcompat.ch"
#endif


#define USE_HASH /* use hash of fields for faster FieldPos
                    If hash code breaks in any build of (x)Harbour ( can happen )
                    uncomment and recompile to use standard array scan*/


CLASS TDolphinQry

   DATA aColumns,;    // query active columns (select) 
        aTables,;     // query active tables
        aRow,;        // info currect record selected
        aStructure    // type of each field, a copy is here a copy inside each row
   DATA aOldRow       // Value copy
        
   DATA bBof,;        //codeblock to evaluate if the value is the first row
        bEof,;        //codeblock to evaluate if the value is the last row
        bOnFillArray,;//codeblock to evaluate while is filling array
        bOnChangePage,; //codeblock to evaluate when paginmation is activated and change page
        bOnLoadQuery  //codeblock to evaluate before load new Query
   
   DATA cQuery,;        // copy of query that generated this object
        cWhere,;        // copy of WHERE command
        cGroup,;        // copy of GROUP BY command
        cHaving,;       // copy of HAVING command
        cOrder,;        // copy of OREDER BY command
        cLimit          // copy of LIMIT command

   DATA Cargo           // For programmer use
   
   DATA hOldRow                // Hash Last row selected
   DATA hResult                 
   DATA hRow                   // Hash current row selected
   
   DATA lBof                   // Begin of query, compatibility with dbf*/
   DATA lEof                   // End of Query, compatibility with dbf*/
   DATA lAppend
   DATA lPagination

   DATA nFCount                // number of fields in the query
   DATA nRecCount              // number of rows in the current query
   DATA nRecNo                 // Current query row position
   DATA nQryId
   
   
   //Paginations datas
   DATA nCurrentPage           // Current page
   DATA nTotalRows             // Total row without limits
   DATA nPageStep              // total rows for page
   DATA nMaxPages              // Max pages avalaible in query
   DATA nCurrentLimit          // Current limit value
   
   DATA oServer
   DATA oRow
   
   
   METHOD New( cQuery, oServer )
   METHOD End()        INLINE ::oServer:CloseQuery( ::nQryId ), ::oRow := NIL

   METHOD Bof()        INLINE ::lBof  
   
   METHOD BuildDatas( cQuery ) 
   METHOD BuildDataWhere()     /* build a where with oldrow values */
   
   METHOD BuildQuery( aColumns, aTables, cWhere, cGroup, cHaving, ;
                      cOrder, cLimit, lWithRoll )   
                      
   METHOD CheckError( nError )  INLINE ::oServer:CheckError( nError )
                               /*Compatibility with CheckError from TDolphinSrv*/

   METHOD Delete( lAll )       /*Delete current record active*/
#ifdef __WIN__   
   METHOD Export( nType, cFieldName, aColumns, aPictures )   ;
                       INLINE TDolphinExport():New( nType, Self, cFieldName, aColumns, aPictures )
#endif __WIN__
   METHOD Eof()        INLINE ::lEof  
                      
   METHOD FCount()     INLINE    ::nFCount
                                /*returns the number of fields in the query, compatibility with dbf*/

   METHOD FieldLen( cnField )
   METHOD FieldDec( cnField )

   METHOD FieldName( nNum )     /*returns the name of the specified field as a character string.*/
   METHOD FieldPos( cFieldName )
                                /*returns the position of the specified field*/
   METHOD FieldGet( cnField )   /*returns the value of the specified field*/
   METHOD FieldType( cnField )  /*returns the field type of the specified field*/
   METHOD FieldMySqlType( cnField ) 
                                /*returns the MySql field type of the specified field*/
                                
   METHOD FieldPut( cnField, uValue )
                                /*Set the value of a field variable using the ordinal position of the field.
                                  returns the value assigned to the designated field.*/  
                                  
   METHOD FieldToNum( cnField ) HIDDEN                                                            
   
   METHOD FillArray( bOnFillArray, aColumns ) /*Fill and return a array with all query information*/

   METHOD FirstPage()   INLINE ::PrevPage( ::nCurrentPage - 1 )
                                /*Go to first page in pagination*/
   METHOD Find( aValues, aFields, nStart, nEnd, lRefresh )                                
   
   METHOD GetBlankRow()                       
   METHOD GetRow( nRow )        /*Fill aRow and Hash with current data row selected*/
   METHOD GoTo( nRow ) INLINE   ::GetRow( nRow )
                                /*Goto specific Row (RecNo) and fill aRow/Hash*/
                                
   METHOD GetRowObj( nRow )     /*Return TDolphinRow Object*/
                                
   METHOD GoBottom()   INLINE   ::GetRow( ::nRecCount  ) 
                                /*Goto BOTTOM of Query and fill aRow/Hash*/
                                
   METHOD GoTop()      INLINE   ::GetRow( 1 )
                                /*Goto TOP of Query and fill aRow/Hash*/
                                
   METHOD IsEqual( nIdx )                                

   METHOD IsSingleTable() INLINE Len( ::aTables ) == 1  
   METHOD IsCommand()     INLINE ( ::IsSingleTable() .AND. Len( ::aColumns ) == 0 ) .OR. ;
                                 ( Len( ::aTables ) < 1 .AND. Len( ::aColumns ) >= 1 )


   METHOD LastPage() INLINE ::NextPage( ::nMaxPages - ::nCurrentPage )
                               /*Go to Last page in pagination*/

                                  
   METHOD LastRec()    INLINE     ::nRecCount
                               /*returns the number of rows in the current query, compatibility with dbf*/

   METHOD LoadQuery()          /*Load anf fill current query*/
   
   METHOD Locate( aValues, aFields, nStart, nEnd, lSoft, lRefresh )
                               
   METHOD MakePrimaryKeyWhere() 
                               /*Build Make Primary key if exist*/
   
   METHOD GoToPage( nPage ) INLINE If( nPage > ::nCurrentPage, ;
                                      ::NextPage( nPage - ::nCurrentPage ), ;
                                      If( nPage < ::nCurrentPage, ::PrevPage( ::nCurrentPage - nPage ), ) )
       
   METHOD NextPage( nSkip )    /* Go to next page avalaible with pagination active */
   
   
   METHOD PrevPage( nSkip )    /* Go to previous page avalaible with pagination active */
                              
   METHOD RecNo()      INLINE    ::nRecNo
                               /*returns the identity found at the position of the row pointer.*/
                               
   METHOD RecCount()   INLINE ::LastRec()
                               /*Compatibility with TMysql*/
                               
   METHOD Refresh( lBuildData )    
   
   METHOD Save()               /*Save current data*/
                 
   METHOD Seek( cSeek, cnField, nStart, nEnd, lSoft ) 
                               /*Move to the record having the specified cSeek value, in selected field
                                from nStart to nEnd with SoftSeek*/
                 
   METHOD SetData( nNum, uValue ) HIDDEN
                               /*set value into array or hash*/
   
   METHOD SetNewFilter( nType, cFilter, lRefresh )
   METHOD SetWhere( cWhere, lRefresh )   INLINE ::SetNewFilter( SET_WHERE, cWhere, lRefresh )
   METHOD SetGroup( cGroup, lRefresh )   INLINE ::SetNewFilter( SET_GROUP, cGroup, lRefresh )
   METHOD SetHaving( cHaving, lRefresh ) INLINE ::SetNewFilter( SET_HAVING, cHaving, lRefresh )
   METHOD SetOrder( cOrder, lRefresh )   INLINE ::SetNewFilter( SET_ORDER, cOrder, lRefresh )
   METHOD SetLimit( cLimit, lRefresh )   INLINE ::SetNewFilter( SET_LIMIT, cLimit, lRefresh )
   
   METHOD SetPages( nLimit )   /*Activate pagination and Set total rows by page*/
  
   METHOD Skip( nRecords )
   
   METHOD VerifyValue( nIdx, cField ) //HIDDEN
   
   METHOD Undo( cnField )

   METHOD Zap() INLINE ::Delete( .T. )
                               /*Delete all record in table*/
   
   ERROR HANDLER ONERROR()   
   
ENDCLASS


//----------------------------------------------------//


METHOD New( cQuery, uServer ) CLASS TDolphinQry

   DEFAULT uServer TO GetServerDefault()

   IF hb_IsObject( uServer )
      ::oServer = uServer
   ELSEIF hb_IsString( uServer )
      ::oServer = GetServerFromName( uServer )
   ENDIF

   IF ::oServer == NIL   
      Dolphin_DefError( NIL, ERR_NODEFINDEDHOST, .T. )
      RETURN NIL 
   ENDIF   

   ::cQuery  = cQuery
   ::nQryId  = ::oServer:GetQueryId()
   ::oServer:AddQuery( Self )

   ::nRecCount = 0
   ::nRecNo    = 0
   ::nFCount   = 0

   ::aColumns      = {}
   ::aTables       = {}
   ::cWhere        = ""
   ::cGroup        = ""
   ::cHaving       = ""
   ::cOrder        = ""
   ::cLimit        = ""   
   
   ::aRow          = {}
   ::aOldRow       = {}
   
   ::lPagination   = .F.
   
#ifdef USE_HASH     
   ::hRow      = Hash()
   ::hOldRow   = Hash()
#endif /*USE_HASH*/
   ::lEof      = .T.
   ::lBof      = .T.   
   ::lAppend   = .F.

   IF cQuery == NIL 
      RETURN Self 
   ENDIF 

   ::LoadQuery()


RETURN Self


//----------------------------------------------------//

METHOD BuildDatas( cQuery ) CLASS TDolphinQry

   LOCAL aToken, cItem, cSelect, cTables, cFind
   LOCAL aCommands := { "SELECT", ;
                        "WHERE",;
                        "GROUP",;
                        "HAVING",;
                        "LIMIT",;
                        "ORDER",;
                        "FROM",;
                        "DESC",;
                        "ASC" }
   LOCAL nFind
   
   DEFAULT cQuery TO ::cQuery

   aToken := HB_ATokens( cQuery, " " )
   
   FOR EACH cItem IN aToken
      IF AScan( aCommands, {| cCommand | cCommand == Upper( cItem ) } ) > 0
         cItem := "|" + cItem
      ENDIF
   NEXT

   cQuery := ""
   FOR EACH cItem IN aToken
      cQuery += cItem + " "
   NEXT
   cQuery := AllTrim( cQuery )

   aToken := HB_ATokens( cQuery, "|" )

   FOR EACH cItem IN aToken
   
      cFind = Upper( SubStr( cItem, 1, At( " ", cItem ) - 1 ) )
      
      // for comapibility with xharbour
      // xharbour no accept string like switch constant
      nFind = AScan( aCommands, cFind )
      
      SWITCH nFind
         CASE 1 //"SELECT"
            cSelect := AllTrim( SubStr( cItem, 8 ) )
            ::aColumns = ArrayFromSQLString( cSelect )
            EXIT

            
         CASE 2 //"WHERE"
            IF Empty( ::cWhere )
               ::cWhere  := AllTrim( SubStr( cItem, 7 ) )
            ENDIF
            EXIT

         CASE 3 //"GROUP" 
            IF Empty( ::cGroup )
               ::cGroup  := AllTrim( SubStr( cItem, 10 ) )
            ENDIF
            EXIT

         CASE 4 //"HAVING" 
            IF Empty( ::cHaving )
               ::cHaving := AllTrim( SubStr( cItem, 8 ) )
            ENDIF
            EXIT

         CASE 5 //"LIMIT"
            IF Empty( ::cLimit )
               ::cLimit  := AllTrim( SubStr( cItem, 7 ) )
            ENDIF
            IF Val(::cLimit) <= 1
               ::cLimit := ""
            ENDIF
            EXIT 

         CASE 6 //"ORDER"
            IF Empty( ::cOrder )
               ::cOrder  := AllTrim(SubStr( cItem, 10 ))
            ENDIF
            EXIT
            
         CASE 7 //"FROM"
            IF Empty( ::aTables )
               cTables := AllTrim( SubStr( cItem, 6 ) )
               ::aTables := ArrayFromSQLString( cTables )
            ENDIF
            EXIT
            
            
         CASE 8//"DESC" 
            IF ! Empty( ::cOrder )
              ::cOrder  += " DESC"
            ENDIF 
            EXIT
            
         CASE 9 //"ASC" 
            IF ! Empty( ::cOrder )
              ::cOrder  += " ASC"
            ENDIF
            EXIT
            

            EXIT
      ENDSWITCH
   NEXT

RETURN NIL

//----------------------------------------------------//

METHOD BuildDataWhere() CLASS TDolphinQry

   LOCAL uValue
   LOCAL aField
   LOCAL cWhere := ""
   LOCAL nIdx
   
   FOR EACH aField IN ::aStructure 
#ifdef USE_HASH 
      uValue = ::hOldRow[ "_" + D_LowerCase( aField[ MYSQL_FS_NAME ] ) ]
#else 
#ifndef __XHARBOUR__
      nIdx = aField:__EnumIndex()
#else 
      nIdx = HB_EnumINdex()
#endif /*__HARBOUR__*/
      uValue = ::aOldRow[ nIdx ]
#endif /*USE_HASH*/
      IF ValType( uValue ) == "C"
         IF Len( uValue ) < 65536
            uValue = Val2Escape( uValue )
         ELSE 
            uValue = MySqlEscape( uValue )
         ENDIF
      ENDIF
      IF IS_NOT_NULL( aField[ MYSQL_FS_FLAGS ] )
         cWhere += aField[ MYSQL_FS_NAME ] + " = " + ;
                   ClipValue2Sql( uValue, , , .T. ) + " AND "
      ELSE
        cWhere += aField[ MYSQL_FS_NAME ] + If( uValue == NIL .OR. ( HB_IsString( uValue ) .AND. Empty( uValue ) ), " IS ", " = " ) + ;
                   ClipValue2Sql( uValue, , , .F. ) + " AND "
      ENDIF
          
   NEXT
   
   //Delete last AND 
   
   cWhere = Left( cWhere, Len( cWhere ) - 5 )

RETURN cWhere

//----------------------------------------------------//

METHOD BuildQuery( aColumns, aTables, cWhere, cGroup, cHaving, ;
                   cOrder, cLimit, lWithRoll ) CLASS TDolphinQry

   LOCAL cQuery := ""
   
   DEFAULT aColumns TO {}
   DEFAULT aTables  TO {}
   DEFAULT cWhere   TO ""
   DEFAULT cGroup   TO ""
   DEFAULT cHaving  TO ""
   DEFAULT cOrder   TO ""
   DEFAULT cLimit   TO ""
   
   ::aColumns = aColumns
   ::aTables  = aTables
   ::cWhere   = cWhere
   ::cGroup   = cGroup
   ::cHaving  = cHaving
   ::cOrder   = cOrder
   ::cLimit   = cLimit 

   cQuery = BuildQuery( aColumns, aTables, cWhere, cGroup, cHaving, cOrder, cLimit, lWithRoll )
   

RETURN cQuery

//----------------------------------------------------//


METHOD Delete( lAll ) CLASS TDolphinQry

   LOCAL cTable
   LOCAL cQry := ""
   LOCAL cPrimary
   
   DEFAULT lAll TO .F.

#ifndef NOINTERNAL
   IF !::IsSingleTable()
      ::oServer:nInternalError = ERR_INVALIDDELETE
      ::oServer:CheckError()
      RETURN .F. 
   ENDIF
#endif   
   
   cTable := ::aTables[ 1 ]
   cQry   := "DELETE FROM " + cTable

   If ! lAll
      cPrimary = ::MakePrimaryKeyWhere()
      cQry   += " WHERE " + If( ! Empty( cPrimary ), cPrimary, ::BuildDataWhere() )
   EndIf

   If ::oServer:SqlQuery( cQry )
      ::LoadQuery()
   Else 
      RETURN .F. 
   EndIf

RETURN .T.


//----------------------------------------------------//

METHOD FieldGet( cnField ) CLASS TDolphinQry
   
   LOCAL cFieldName
   LOCAL nNum
   LOCAL lError := .F.
   LOCAL uValue

//   ::Cargo:cTitle = Time() + " " + Str( ::xLock )

#ifdef USE_HASH
      IF HB_IsNumeric( cnField )
         cFieldName = "_" + ::FieldName( cnField )
         nNum = cnField
      ELSE 
         nNum := ::FieldToNum( cnField )   
         cFieldName := "_" + D_LowerCase( cnField )
      ENDIF
      IF hGetPos( ::hRow, cFieldName ) > 0
         uValue = ::hRow[ cFieldName ] 
      ELSE
         lError = .T.
      ENDIF
#else      
      IF nNum > 0
         uValue = ::aRow[ nNum ]
      ELSE 
         lError = .T. 
      ENDIF

#endif /*USE_HASH*/
#ifndef NOINTERNAL
   IF lError
      ::oServer:nInternalError = ERR_INVALIDFIELDGET
      ::oServer:CheckError()
      RETURN NIL
   ENDIF   
#endif 
RETURN ::VerifyValue( nNum, uValue )       

//----------------------------------------------------//

METHOD FieldName( nNum ) CLASS TDolphinQry
   LOCAL cName := ""
   
   IF nNum > 0 .AND. nNum <= ::nFCount
      cName = ::aStructure[ nNum ][ MYSQL_FS_NAME ]
#ifndef NOINTERNAL      
   ELSE 
      ::oServer:nInternalError = ERR_INVALIDFIELDNUM
      ::oServer:CheckError()
#endif      
   ENDIF
    
RETURN cName

//----------------------------------------------------//

METHOD FieldLen( cnField ) CLASS TDolphinQry
   LOCAL nNum := ::FieldToNum( cnField )

   IF nNum >= 1 .AND. nNum <= Len( ::aStructure )
      RETURN ::aStructure[ nNum ][ MYSQL_FS_LENGTH ]
   ENDIF

RETURN 0


//----------------------------------------------------//

METHOD FieldDec( cnField ) CLASS TDolphinQry
   LOCAL nNum := ::FieldToNum( cnField )

   IF nNum >= 1 .AND. nNum <= Len( ::aStructure )
      RETURN ::aStructure[ nNum ][ MYSQL_FS_DECIMALS ]
   ENDIF

RETURN 0

//----------------------------------------------------//

METHOD FieldPos( cFieldName ) CLASS TDolphinQry
   LOCAL nPos := 0

   IF ! Empty( cFieldName )
      nPos = AScan( ::aStructure, {| aField | aField[ MYSQL_FS_NAME ] == Lower( cFieldName ) } )
   ENDIF

#ifndef NOINTERNAL
   IF nPos == 0 
      ::oServer:nInternalError = ERR_INVALIDFIELDNAME
      ::oServer:CheckError()
   ENDIF
#endif

RETURN nPos

//----------------------------------------------------//


METHOD FieldType( cnField ) CLASS TDolphinQry
   LOCAL cType := "U"
   LOCAL nNum := ::FieldToNum( cnField )

   IF nNum >= 0 .AND. nNum <= ::nFCount

      cType := ::aStructure[ nNum ][ MYSQL_FS_CLIP_TYPE ]

   ENDIF

RETURN cType

//----------------------------------------------------//


METHOD FieldMySqlType( cnField ) CLASS TDolphinQry
   LOCAL cType := "U"
   LOCAL nNum := ::FieldToNum( cnField )

   IF nNum >= 0 .AND. nNum <= ::nFCount

      cType := ::aStructure[ nNum ][ MYSQL_FS_TYPE ]

   ENDIF

RETURN cType

//----------------------------------------------------//

METHOD FieldPut( cnField, uValue ) CLASS TDolphinQry

   LOCAL nNum := ::FieldToNum( cnField )
   LOCAL cCol
   IF nNum > 0 .AND. nNum <= ::nFCount

#ifdef USE_HASH
      IF ValType( cnField ) == "N" 
         cCol = cCol := "_" + ::aStructure[ nNum ][ MYSQL_FS_NAME ]
      ELSE 
         cCol = "_" + Lower( cnField )
      ENDIF
      IF Valtype( uValue ) == Valtype( ::hRow[ cCol ] ) .OR. ::hRow[ cCol ] == NIL
#else      
      IF Valtype( uValue ) == Valtype( ::aRow[ nNum ] ) .OR. ::aRow[ nNum ] == NIL      
#endif      
         IF ValType( uValue ) == "C"
            uValue := MySqlEscape( AllTrim( uValue ), ::oServer:hMySql )
         ENDIF
#ifdef USE_HASH
         
         HSet( ::hRow, cCol, uValue )
#else 
         ::aRow[ nNum ]    := uValue
#endif /*USE_HASH*/
         RETURN uValue
#ifndef NOINTERNAL         
      ELSE 
         ::oServer:nInternalError = ERR_INVALIDFIELDTYPE
         ::oServer:CheckError()
#endif      
      ENDIF
   ENDIF

RETURN NIL

//---------------------------------------

METHOD FieldToNum( cnField ) CLASS TDolphinQry
   LOCAL nNum

   IF ValType( cnField ) == "C"
      nNum := ::FieldPos( cnField )
   ELSE
      nNum := cnField
   ENDIF
   
RETURN nNum


//---------------------------------------

METHOD FillArray( bOnFillArray, aColumns ) CLASS TDolphinQry

   LOCAL aTable := {}, aRow, uField
   LOCAL n, aGet, i := 0, aStructure := {}
   

   DEFAULT bOnFillArray TO ::bOnFillArray

   IF Empty( aColumns )
      FOR EACH uField IN ::aStructure
         AAdd( aStructure, uField[ MYSQL_FS_NAME ] )
      NEXT
      aColumns = aStructure  
   ELSE
      aStructure = aColumns
   ENDIF
   
#ifndef NOINTERNAL
   FOR EACH uField IN aColumns
      ::FieldPos( uField )
   NEXT 
#endif

   IF ::nRecCount > 0
         
      WHILE ! ::lEof
         aRow = {}
#ifdef USE_HASH         
         AEval( aStructure, { | cField | AAdd( aRow, ::hRow[ "_" + cField ] ) } ) 
#else 
         AEval( aStructure, { | cField | AAdd( aRow, ::aRow[ ::FieldPos( cField ) ] ) } ) 
#endif         
         IF bOnFillArray != NIL 
            Eval( bOnFillArray, aRow, ++i )
         ENDIF
         AAdd( aTable, aRow )
         ::Skip()
      END 
   ENDIF

RETURN aTable 

//----------------------------------------------------//

METHOD Find( aValues, aFields, nStart, nEnd, lRefresh, lSoft ) CLASS TDolphinQry

   LOCAL nNum
   LOCAL nSeek
   LOCAL uValue, cField, nId
   
   DEFAULT lRefresh TO .T.
   DEFAULT lSoft TO .F.
   
   IF ::nRecCount == 0 
      RETURN 0
   ENDIF
   
   FOR EACH cField IN aFields
      cField = ::FieldToNum( cField ) 
   NEXT

   FOR EACH uValue IN aValues
#ifdef __XHARBOUR__
      nId = HB_EnumINdex()
#else 
      nId = uValue:__EnumIndex()
#endif               
      uValue = ClipValue2SQL( uValue, ::aStructure[ aFields[ nId ] ][ MYSQL_FS_CLIP_TYPE ], .F. )
   NEXT
   
   nSeek = MyFind( ::hResult, aFields, aValues, nStart, nEnd, lSoft )
   
   IF nSeek > 0 
      IF lRefresh
         ::GetRow( nSeek )
      ENDIF
   ENDIF   
   
RETURN nSeek 


//----------------------------------------------------//

METHOD GetBlankRow( lRow ) CLASS TDolphinQry
   LOCAL cType
   LOCAL uValue, uItem
   LOCAL nIdx
   LOCAL cCol, aRow
   LOCAL nPad

#ifndef NOINTERNAL
   IF ! ::IsSingleTable()
      ::oServer:nInternalError = ERR_INVALIDGETBLANKROW
      ::oServer:CheckError()
      RETURN NIL 
   ENDIF
#endif 
   
   ::oRow = NIL
   
   DEFAULT lRow TO .T.
   
   ::lAppend := .T.

   aRow    = Array( Len( ::aStructure ) )
   
#ifndef USE_HASH
   ::aRow    = Array( Len( ::aStructure ) )
   ::aOldRow = AClone( aRow )
#endif
   
   FOR EACH uItem IN aRow
     
#ifdef __XHARBOUR__
      nIdx = HB_EnumIndex()
#else 
      nIdx = uItem:__EnumIndex()
#endif

      cType := ::aStructure[ nIdx ][ MYSQL_FS_CLIP_TYPE ]
      SWITCH cType
      
      CASE "M"
         // we can not use PadR in  memo field
         IF ::aStructure[ nIdx ][ MYSQL_FS_DEF ] != NIL
            uValue = ::aStructure[ nIdx ][ MYSQL_FS_DEF ]
         ELSE 
            uValue = ""
         ENDIF 
         EXIT         
      CASE "C"
         IF D_SetPadRight()
            nPad = Min( If( ::aStructure[ nIdx ][ MYSQL_FS_MAXLEN ] > ::aStructure[ nIdx ][ MYSQL_FS_LENGTH ],;
                      ::aStructure[ nIdx ][ MYSQL_FS_MAXLEN ], ::aStructure[ nIdx ][ MYSQL_FS_LENGTH] ), MAX_BLOCKSIZE )
         ELSE 
            nPad = 0 
         ENDIF
         IF ::aStructure[ nIdx ][ MYSQL_FS_DEF ] != NIL
            uValue = PadR( ::aStructure[ nIdx ][ MYSQL_FS_DEF ], Max( Len( ::aStructure[ nIdx ][ MYSQL_FS_DEF ] ), nPad ) )
         ELSE 
            uValue = Space( nPad )
         ENDIF 
         EXIT

      CASE "N"
      CASE "I"
         IF ::aStructure[ nIdx ][ MYSQL_FS_DEF ] != NIL
            uValue = Val( ::aStructure[ nIdx ][ MYSQL_FS_DEF ] )
         ELSE 
            uValue = 0
         ENDIF 
         EXIT

      CASE "L"
         IF ::aStructure[ nIdx ][ MYSQL_FS_DEF ] != NIL
            uValue = ::aStructure[ nIdx ][ MYSQL_FS_DEF ] == "1"
         ELSE 
            uValue = .F.
         ENDIF 
         
         EXIT

      CASE "D"
         IF ::aStructure[ nIdx ][ MYSQL_FS_DEF ] != NIL
            uValue = SqlDate2Clip( ::aStructure[ nIdx ][ MYSQL_FS_DEF ] )
         ELSE 
            uValue = CToD("")
         ENDIF 
      
         EXIT

#ifdef __XHARBOUR__
      DEFAULT
#else 
      OTHERWISE
#endif
         uValue := nil
      END
      ::SetData( nIdx, uValue )
   NEXT
   
   IF lRow
      ::oRow = ::GetRowObj()
   ENDIF
   
RETURN ::oRow

//----------------------------------------------------//

METHOD GetRow( nRow ) CLASS TDolphinQry

   LOCAL cType, uValue, cField
   LOCAL cCol
   LOCAL nIdx
   LOCAL aRow

   DEFAULT nRow  TO ::nRecNo

   
   IF ::hResult <> NIL
      DO CASE
         CASE ::nRecCount < 1
            ::lBof    = .T.
            ::lEof    = .T.
            ::nRecNo  = 1
         CASE nRow > 0 .and. nRow <= ::nRecCount
            ::lBof    = .F.
            ::lEof    = .F.//nRow == ::nRecCount
            ::nRecNo  = Max( nRow, 1 )
         CASE nRow > ::nRecCount
            ::lBof    = .F.
            ::lEof    = .T.
            ::nRecNo  = ::nRecCount
         CASE nRow < 1 
            ::lBof    = .T.
            ::lEof    = .F.
            ::nRecNo  = 1
      ENDCASE

      nRow  = ::nRecNo
      MySqlDataSeek( ::hResult, nRow - 1 )

      aRow    = MySqlFetchRow( ::hResult )
      
#ifndef USE_HASH
      ::aRow    = Array( Len( aRow ) )
      ::aOldRow = Array( Len( aRow ) )
#endif /*USE_HASH*/
      

      //fill ::aRow Info
      IF aRow != NIL .AND. ::nRecCount > 0
         // Convert answer from text field to correct clipper types
         FOR EACH cField IN aRow
#ifdef __XHARBOUR__
            nIdx = HB_EnumIndex()
#else
            nIdx = cField:__EnumIndex()
#endif

            uValue = ::VerifyValue( nIdx, cField )
        
            ::SetData( nIdx, uValue )
         NEXT

      ENDIF
#ifndef NOINTERNAL      
   ELSE 
      ::oServer:nInternalError = ERR_FAILEDGETROW
      ::nRecNo = 0
      ::CheckError()
#endif       
   ENDIF

RETURN ::nRecNo

//----------------------------------------------------//

METHOD GetRowObj( nRow ) CLASS TDolphinQry

   IF nRow != NIL .AND. nRow != ::nRecNo
      ::Goto( nRow )
   ENDIF 
   
   IF ::oRow != NIL 
      ::oRow = NIL 
   ENDIF
#ifdef USE_HASH
   ::oRow = TDolphinRow():New( Self )
#else 
   ::oRow = TDolphinRow():New( Self )
#endif /*USE_HASH*/
RETURN ::oRow

//----------------------------------------------------//

METHOD IsEqual( cnField ) CLASS TDolphinQry
#ifdef USE_HASH
RETURN ::hRow[ "_" + cnField ] == ::hOldRow[ "_" + cnField ]
#else 
RETURN ::aRow( cnField ) == ::aOldRow( cnField ) 
#endif /*USE_HASH*/


//----------------------------------------------------//


METHOD LoadQuery( lBuildData ) CLASS TDolphinQry

   LOCAL oServer := ::oServer
   LOCAL cQuery  := ::cQuery
   LOCAL aField, nIdx, cCol
   LOCAL lCaseSen := D_SetCaseSensitive()

   DEFAULT lBuildData TO .T.

   IF ::bOnLoadQuery != NIL 
      Eval( ::bOnLoadQuery, Self )
   ENDIF

   IF ! oServer:SQLQuery( cQuery )
      RETURN NIL 
   ENDIF
   
   //we need unlock current record locked
   
   IF lBuildData
      ::BuildDatas()
   ENDIF
   
   IF ::hResult != NIL
//      MySqlFreeResult( ::hResult ) /* NOTE: Deprecated */
      ::hResult = NIL
   ENDIF
   
   ::hResult := MySqlStoreResult( oServer:hMysql )
   
   IF ! ( ::hResult == NIL )
      ::aStructure = MySqlResultStructure( ::hResult, lCaseSen, D_LogicalValue() ) 
      ::nRecCount := MySqlNumRows( ::hResult )
      ::nRecNo    = Max( 1, ::nRecNo )
      ::nFCount   = Len( ::aStructure )
   
      IF ::nRecCount > 0
         ::lEof      := .F.
         ::lBof      := .T.
      ELSE
         ::lEof      := .T.
         ::lBof      := .T.
      ENDIF   

#ifdef USE_HASH
      //Build Hash
      //Disable case sensitive
      //all fieldname should be lower case
      hSetCaseMatch( ::hRow    , .F. )
      hSetCaseMatch( ::hOldRow , .F. )
      //set hash
      FOR each aField in ::aStructure
         cCol = aField[ MYSQL_FS_NAME ]
         ::SetData( cCol, NIL )
      NEXT
#endif /*USE_HASH*/
      ::GetRow()
      
   ELSE
      IF MySqlFieldCount( oServer:hMysql ) == 0
         oServer:CheckError()
      ENDIF    
   ENDIF  
   
RETURN NIL 


//----------------------------------------------------//

METHOD Locate( aValues, aFields, nStart, nEnd, lRefresh, lSoft ) CLASS TDolphinQry

   LOCAL nNum
   LOCAL nSeek
   LOCAL uValue, cField, nId
   
   DEFAULT lRefresh TO .T.
   DEFAULT lSoft TO .F.

   IF ::nRecCount == 0 
      RETURN 0
   ENDIF
   
   FOR EACH cField IN aFields
      cField = ::FieldToNum( cField ) 
   NEXT

   FOR EACH uValue IN aValues
#ifdef __XHARBOUR__
      nId = HB_EnumINdex()
#else 
      nId = uValue:__EnumIndex()
#endif               
      uValue = ClipValue2SQL( uValue, ::aStructure[ aFields[ nId ] ][ MYSQL_FS_CLIP_TYPE ], .F. )
   NEXT
   
   nSeek = MyLocate( ::hResult, aFields, aValues, nStart, nEnd, lSoft )

   IF nSeek > 0 
      IF lRefresh
         ::GetRow( nSeek )
      ENDIF
   ENDIF
   
RETURN nSeek 

//----------------------------------------------------//

METHOD MakePrimaryKeyWhere() CLASS TDolphinQry

   LOCAL cWhere := "", aField
   LOCAL nIdx, lPrimary := .F., uValue

//   IF Empty( ::cWhere )

      FOR EACH aField IN ::aStructure
   
         // search for fields part of a primary key
         IF IS_PRIMARY_KEY( aField[ MYSQL_FS_FLAGS ] ) .OR.;
            IS_MULTIPLE_KEY( aField[ MYSQL_FS_FLAGS ] )
   
            cWhere += aField[ MYSQL_FS_NAME ] 
   
            // if a part of a primary key has been changed, use original value
#ifdef __XHARBOUR__         
            nIdx = HB_EnumIndex()
#else 
            nIdx = aField:__EnumIndex()
#endif /*__XHARBOUR__*/   
   
#ifdef USE_HASH
            IF ! ::IsEqual( aField[ MYSQL_FS_NAME ] )
               uValue = ::hOldRow[ "_" + aField[ MYSQL_FS_NAME ] ]
               cWhere += If( ! IS_NOT_NULL( aField[ MYSQL_FS_FLAGS ] ) .AND. ;
                             ( uValue == NIL .OR. ( HB_IsString( uValue ) .AND. Empty( uValue ) ) ), " IS ", " = " )
               cWhere += ClipValue2SQL( uValue, ;
                                        aField[ MYSQL_FS_CLIP_TYPE ], , IS_NOT_NULL( aField[ MYSQL_FS_FLAGS ] ) ) 
            ELSE
               uValue = ::hRow[ "_" + aField[ MYSQL_FS_NAME ] ]
               cWhere += If( ! IS_NOT_NULL( aField[ MYSQL_FS_FLAGS ] ) .AND. ;
                             ( uValue == NIL .OR. ( HB_IsString( uValue ) .AND. Empty( uValue ) ) ), " IS ", " = " )
               cWhere += ClipValue2SQL( uValue,;
                                        aField[ MYSQL_FS_CLIP_TYPE ], , IS_NOT_NULL( aField[ MYSQL_FS_FLAGS ] ) ) 
            ENDIF
#else         
            cWhere += If(  uValue == NIL .OR. ( HB_IsString( uValue ) .AND. Empty( uValue ) ), " IS ", " = " )
            IF ! ::IsEqual( nIdx )
               uValue = ::aOldRow[ nIdx ]
               cWhere += If( ! IS_NOT_NULL( aField[ MYSQL_FS_FLAGS ] ) .AND. ;
                             ( uValue == NIL .OR. ( HB_IsString( uValue ) .AND. Empty( uValue ) ) ), " IS ", " = " )
               cWhere += ClipValue2SQL( uValue, aField[ MYSQL_FS_CLIP_TYPE ] ) 
            ELSE
               uValue = ::aRow[ nIdx ]
               cWhere += If( ! IS_NOT_NULL( aField[ MYSQL_FS_FLAGS ] ) .AND. ;
                             ( uValue == NIL .OR. ( HB_IsString( uValue ) .AND. Empty( uValue ) ) ), " IS ", " = " )
               cWhere += ClipValue2SQL( uValue, aField[ MYSQL_FS_CLIP_TYPE ] )
            ENDIF         
#endif /*USE_HASH*/
            cWhere += " AND "
            lPrimary = .T.
         ENDIF
   
      NEXT
   
      IF lPrimary
      // remove last " AND "
         cWhere := Left( cWhere, Len( cWhere ) - 5 )
      ENDIF
      
//   ENDIF

RETURN cWhere


//----------------------------------------------------//

METHOD NextPage( nSkip, lRefresh ) CLASS TDolphinQry

   DEFAULT nSkip TO 1
   DEFAULT lRefresh TO .T.


   IF ::lPagination

      ::nTotalRows    := ::oServer:GetRowsFromQry( Self )
      ::nMaxPages     = Int( ::nTotalRows / ::nPageStep ) + If( ::nTotalRows % ::nPageStep > 0, 1, 0 )
   
      IF ::nCurrentPage + nSkip < ::nMaxPages
         ::nCurrentLimit += ( ::nPageStep * nSkip ) 
         ::nCurrentPage  += nSkip    
      ELSE 
         ::nCurrentLimit = Max( ::nTotalRows - ::nPageStep, 0 )
         ::nCurrentPage  = ::nMaxPages
      ENDIF

      ::SetLimit( AllTrim( Str( ::nCurrentLimit ) ) + "," + AllTrim( Str( ::nPageStep ) ), lRefresh ) 

      IF ::lPagination .AND. ::bOnChangePage != NIL .AND. lRefresh
         Eval( ::bOnChangePage, .F. )
      ENDIF     

      
   ENDIF

RETURN NIL

//----------------------------------------------------//

METHOD PrevPage( nSkip, lRefresh ) CLASS TDolphinQry

   DEFAULT nSkip TO 1
   DEFAULT lRefresh TO .T.


   IF ::lPagination

      ::nTotalRows    := ::oServer:GetRowsFromQry( Self )
      ::nMaxPages     = Int( ::nTotalRows / ::nPageStep ) + If( ::nTotalRows % ::nPageStep > 0, 1, 0 )
   
      IF ::nCurrentPage - nSkip > 0
         ::nCurrentLimit -= ( ::nPageStep * nSkip )
         ::nCurrentPage  -= nSkip    
         ::nCurrentPage = Max( 1, ::nCurrentPage )
         ::nCurrentLimit = Max( 0, ::nCurrentLimit )
      ELSE 
         ::nCurrentLimit = 0
         ::nCurrentPage  = 1
      ENDIF
      ::SetLimit( AllTrim( Str( ::nCurrentLimit ) ) + "," + AllTrim( Str( ::nPageStep ) ), lRefresh ) 

      IF ::lPagination .AND. ::bOnChangePage != NIL .AND. lRefresh
         Eval( ::bOnChangePage, .T. )
      ENDIF     
   
   ENDIF

RETURN NIL

//----------------------------------------------------//

METHOD Refresh( lBuild ) CLASS TDolphinQry

   DEFAULT lBuild TO .F.

   ::cQuery = BuildQuery( ::aColumns, ::aTables, ::cWhere, ::cGroup, ::cHaving, ::cOrder, ::cLimit )

   ::LoadQuery( lBuild ) 

RETURN ::cQuery

//----------------------------------------------------//

/* Creates an update query for changed fields and submits it to server */
METHOD Save() CLASS TDolphinQry

   LOCAL cTable
   LOCAL aField
   LOCAL cQry := ""
   LOCAL uValue  
   LOCAL uOldValue
   LOCAL nIdx
   LOCAL lSaveOk := .F.
   LOCAL lChanged := .F.
   LOCAL cPrimary
   
#ifndef NOINTERNAL   
   IF ! ::IsSingleTable()
      ::oServer:nInternalError = ERR_INVALIDSAVE
      ::oServer:CheckError()
      RETURN NIL 
   ENDIF
#endif    
   
   cTable = ::aTables[ 1 ]

    IF ::oRow != NIL 
       ::oRow:SetData()
       ::oRow = NIL
    ENDIF 

   IF ! ::lAppend
      cQry += "UPDATE " + D_LowerCase( cTable ) + " SET "
   ELSE
      cQry += "INSERT INTO " + D_LowerCase( cTable ) + " SET "
   ENDIF

   FOR EACH aField IN ::aStructure
      
      IF ::lAppend
         lSaveOk = .T.
         lChanged = .T.
         uValue = ::FieldGet( aField[ MYSQL_FS_NAME ] )
      ELSE
#ifdef USE_HASH
         uValue = ::FieldGet( aField[ MYSQL_FS_NAME ] )
         uOldValue = ::hOldRow[ "_" + aField[ MYSQL_FS_NAME ] ]
#else 
#ifdef __XHARBOUR__
         nIdx = HB_EnumIndex()
#else
         nIdx = aField:__EnumIndex()
#endif /*__XHARBOUR__*/ 
         uValue = ::FieldGet( aField[ MYSQL_FS_NAME ] )
         uOldValue = ::aOldRow[ nIdx ]
#endif /*USE_HASH*/
         IF ! ( uValue == uOldValue ) .and. ! lChanged
            lChanged = .T.
         ENDIF
      ENDIF
      IF lChanged 
         cQry += aField[ MYSQL_FS_NAME ] + "=" + ClipValue2SQL( uValue, , , IS_NOT_NULL( aField[ MYSQL_FS_FLAGS ] ) ) + ","
         lSaveOk = .T.
      ENDIF
      lChanged = .F.
   NEXT

   IF lSaveOk
      // remove last comma
      cQry = Left( cQry, Len( cQry ) - 1 )
      IF !::lAppend
         cPrimary = ::MakePrimaryKeyWhere()
         cQry   += " WHERE " + If( ! Empty( cPrimary ), cPrimary, ::BuildDataWhere() )
      ENDIF

      IF ::oServer:SqlQuery( cQry )
         ::LoadQuery()
      ENDIF         
   ENDIF
   
   ::lAppend = .F.

RETURN lSaveOk

//----------------------------------------------------//

METHOD Seek( uSeek, cnField, nStart, nEnd, lSoft, lRefresh ) CLASS TDolphinQry

   LOCAL nNum
   LOCAL nSeek
   
   DEFAULT lSoft TO .F.
   DEFAULT lRefresh TO .T.

   IF ::nRecCount == 0 
      RETURN 0
   ENDIF

   nNum := ::FieldToNum( cnField )
   
   IF ::aStructure[ nNum ][ MYSQL_FS_CLIP_TYPE ] == "N"
      uSeek = If( ValType( uSeek ) != "N", Val( uSeek ),uSeek )
   ELSEIF ::aStructure[ nNum ][ MYSQL_FS_CLIP_TYPE ] == "D"
      //no supported field type date 
      RETURN 0
   ENDIF

   nSeek = MySeek2( ::hResult, nNum, ClipValue2SQL( uSeek, ::aStructure[ nNum ][ MYSQL_FS_CLIP_TYPE ], .F. ), nStart, nEnd, lSoft )

   IF nSeek > 0 
      IF lRefresh
         ::GetRow( nSeek )
      ENDIF
   ENDIF

RETURN nSeek 


//----------------------------------------------------//


METHOD SetData( cnField, uValue )	CLASS TDolphinQry

   LOCAL cCol
   LOCAL nNum := ::FieldToNum( cnField )
   
#ifdef USE_HASH

   cCol := "_" + ::aStructure[ nNum ][ MYSQL_FS_NAME ]
   HSet( ::hRow, cCol, uValue )
   HSet( ::hOldRow, cCol, uValue )

#else 
   ::aRow[ nNum ]    = uValue
   ::aOldRow[ nNum ] = uValue
#endif /*USE_HASH*/    

RETURN NIL


//----------------------------------------------------//


METHOD SetNewFilter( nType, cFilter, lRefresh ) CLASS TDolphinQry 
   LOCAL cOldFilter

   DEFAULT lRefresh TO .T.
   
   
   SWITCH nType
      CASE SET_WHERE
         cOldFilter = ::cWhere
         ::cWhere = cFilter
         EXIT
      CASE SET_GROUP
         cOldFilter = ::cGroup
         ::cGroup = cFilter 
         EXIT
      CASE SET_HAVING
         cOldFilter = ::cHaving      
         ::cHaving = cFilter
         EXIT
      CASE SET_ORDER
         cOldFilter = ::cOrder      
         ::cOrder = cFilter 
         EXIT
      CASE SET_LIMIT
         cOldFilter = ::cLimit  
         IF ValType( cFilter ) == "C"
            ::cLimit = cFilter
         ELSEIF ValType( cFilter ) == "N"
            ::cLimit = AllTrim( Str( cFilter ) )
         ENDIF
         EXIT
   ENDSWITCH

   ::cQuery := ::BuildQuery( ::aColumns, ::aTables, ::cWhere, ::cGroup, ::cHaving, ::cOrder, ::cLimit )
 
   IF lRefresh 
      ::LoadQuery( .F. )
   ENDIF

RETURN cOldFilter

//----------------------------------------------------//

METHOD SetPages( nLimit ) CLASS TDolphinQry

   DEFAULT nLimit TO 100

   ::lPagination = .T. 
   
   ::nPageStep     = nLimit
   ::nCurrentLimit = 0
   ::nCurrentPage  = 1 
   
   ::nTotalRows    = ::oServer:GetRowsFromQry( Self )
   
   ::nMaxPages     = Int( ::nTotalRows / nLimit ) + If( ::nTotalRows % nLimit > 0, 1, 0 )
   
   ::SetLimit( AllTrim( Str( ::nCurrentLimit ) ) + "," + AllTrim( Str( nLimit ) ), .F. ) 
   

RETURN NIL

//----------------------------------------------------//


METHOD Skip( nRecords ) CLASS TDolphinQry

   LOCAL n := ::nRecNo

   DEFAULT nRecords TO 1

   ::nRecNo += nRecords 

   IF ::GetRow( ::nRecNo ) > 0  .AND. nRecords != 0

      IF ::Eof()
         IF ::bEoF != nil
            Eval( ::bEoF, Self )
         ENDIF
      ENDIF
   
      IF ::BoF()
         IF ::bBoF != nil
            Eval( ::bBoF, Self )
         ENDIF
      ENDIF
      
   ENDIF
  
   
RETURN ::nRecNo - n

//----------------------------------------------------//


METHOD Undo( cnField ) CLASS TDolphinQry

   LOCAL nNum := 0
   LOCAL uRow, uOldRow
   
   IF cnField != NIL 
      nNum := ::FieldToNum( cnField )
   ENDIF

   IF ::oRow != NIL
      uRow = ::oRow:uRow
      uOldRow = ::oRow:uOldRow
   ELSE
#ifdef USE_HASH
      uRow = ::hRow
      uOldRow = ::hOldRow
   ENDIF

   IF nNum == 0 
      uRow = HClone( uOldRow )
   ELSE 
      HSet( uRow, "_" + ::aStructure[ nNum ][ MYSQL_FS_NAME ], uOldRow[ "_" + ::aStructure[ nNum ][ MYSQL_FS_NAME ] ] )
   ENDIF 

#else 
      uRow = ::aRow
      uOldRow = ::aOldRow
   ENDIF
   
   IF nNum == 0 
      uRow = AClone( uOldRow )
   ELSE 
      uRow[ nNum ] = uOldRow[ nNum ]
   ENDIF 
   
#endif /*USE_HASH*/    

   IF ::oRow != NIL 
      ::oRow:uRow = uRow
      ::oRow:uOldRow = uOldRow
   ELSE
#ifdef USE_HASH
      ::hRow = uRow
      ::hOldRow = uOldRow      
#else   
      ::aRow = uRow
      ::aOldRow = uOldRow
#endif /*USE_HASH*/    
   ENDIF


RETURN NIL

//-------------------------------------------------//

METHOD VerifyValue( nIdx, cField ) CLASS TDolphinQry

   LOCAL cType, uValue
   LOCAL nPad

   cType := ::aStructure[ nIdx ][ MYSQL_FS_CLIP_TYPE ] //, ::aStructure[ nIdx ][ MYSQL_FS_TYPE ]
   SWITCH cType
      CASE "L"
         IF cField == NIL
            uValue = If( ::aStructure[ nIdx ][ MYSQL_FS_DEF ] != NIL, ::aStructure[ nIdx ][ MYSQL_FS_DEF ], .F. )
         ELSE
            uValue := If( ValType( cField ) == "L", cField, !( Val( cField ) == 0 ) )
         ENDIF
         EXIT

      CASE "N"
         IF cField == NIL
            uValue = If( ::aStructure[ nIdx ][ MYSQL_FS_DEF ] != NIL, Val( ::aStructure[ nIdx ][ MYSQL_FS_DEF ] ), 0 )
         ELSE
            uValue = If( ValType( cField ) == "N", cField, Val( cField ) )
         ENDIF               
         EXIT

      CASE "D"
         IF Empty( cField )
            uValue := If( ::aStructure[ nIdx ][ MYSQL_FS_DEF ] != NIL, SqlDate2Clip( ::aStructure[ nIdx ][ MYSQL_FS_DEF ] ), CToD( "" ) )
         ELSE
            uValue := If( ValType( cField ) == "D", cField, SqlDate2Clip( cField ) )
         ENDIF
         EXIT
      CASE "M"
         // we can not use PadR in  memo field
         IF ( cField == NIL )
            uValue := ""
         ELSE
            uValue := cField
         ENDIF
         EXIT      
      CASE "T"
      CASE "C"
         IF D_SetPadRight()
            nPad = Min( If( ::aStructure[ nIdx ][ MYSQL_FS_MAXLEN ] > ::aStructure[ nIdx ][ MYSQL_FS_LENGTH ],;
                      ::aStructure[ nIdx ][ MYSQL_FS_MAXLEN ], ::aStructure[ nIdx ][ MYSQL_FS_LENGTH] ), MAX_BLOCKSIZE )
         ELSE 
            nPad = 0 
         ENDIF
         IF ( cField == NIL )
            uValue := PadR( If( ::aStructure[ nIdx ][ MYSQL_FS_DEF ] != NIL, ;
                                ::aStructure[ nIdx ][ MYSQL_FS_DEF ], ""), PadR( ::aStructure[ nIdx ][ MYSQL_FS_DEF ], ;
                                nPad ) )
         ELSE
            uValue := PadR( cField, Max( Len( cField ), nPad ) ) 
         ENDIF
         
         EXIT
#ifdef __XHARBOUR__
      DEFAULT
#else
      OTHERWISE 
#endif
  //       uValue = cField
      ENDSWITCH

RETURN uValue


//----------------------------------------------------//

METHOD ONERROR( uParam1 ) CLASS TDolphinQry
      LOCAL cCol   := __GetMessage()
      LOCAL lAssign := .F., nCol
      LOCAL oError := ErrorNew()
      LOCAL nError := If( SubStr( cCol, 1, 1 ) == "_", 1005, 1004 )      
      LOCAL nPos

#ifdef USE_HASH    

   //the fieldname always are lower case
   
      cCol = Lower( If( Left( cCol, 1 ) == '_' , SubStr( cCol, 2 ), cCol ) )

      IF ! ( uParam1 == NIL ) 
         IF hGetPos( ::hRow, "_"+cCol ) > 0           
            ::FieldPut( cCol, uParam1 )
            RETURN uParam1
         ENDIF
      ELSE
         IF hGetPos( ::hRow, "_" + cCol ) > 0
            RETURN ::FieldGet( cCol )
         ENDIF
      ENDIF
#else
      cCol  = Lower( If( lAssign := ( Left( cCol, 1 ) == '_' ), SubStr( cCol, 2 ), cCol ) )
      IF( nCol := ::FieldPos( cCol ) ) > 0
         RETURN If( lAssign, ::FieldPut( nCol, uParam1 ), ::FieldGet( cCol ) )
      ENDIF
     
#endif /*USE_HASH*/

   oError:SubSystem   = "BASE"
   oError:SubCode     = nError
   oError:Severity    = 2 // ES_ERROR
   oError:Description = "Message not found"
   oError:Operation   = "TDOLPHYNQRY: " + cCol   

   Eval( ErrorBlock(), oError )
      

RETURN NIL

//----------------------------------------------------//


//***
CLASS TDolphinRow

   DATA uRow
   DATA uOldRow
   DATA oQuery
   DATA nRecno 
   
   METHOD New( oQuery )
   METHOD SetData()	

   ERROR HANDLER ONERROR()  
   
ENDCLASS 

//----------------------------------------------------//


METHOD New( oQuery ) CLASS TDolphinRow

   ::oQuery = oQuery
   ::nRecno = oQuery:nRecno
#ifdef USE_HASH
   ::uRow = HClone( oQuery:hRow )
   ::uOldRow = HClone( oQuery:hOldRow )
#else 
   ::uRow = AClone( oQuery:aRow )
   ::uOldRow = AClone( oQuery:aOldRow )
#endif

RETURN Self

//----------------------------------------------------//

METHOD SetData() CLASS TDolphinRow


#ifdef USE_HASH
   ::oQuery:hRow = HClone( ::uRow )
   ::oQuery:hOldRow = HClone( ::uOldRow )
#else 
   ::oQuery:aRow = AClone( ::uRow )
   ::oQuery:aOldRow = AClone( ::uOldRow )
#endif

RETURN NIL

//----------------------------------------------------//

METHOD ONERROR( uParam1 ) CLASS TDolphinRow
      LOCAL cCol   := __GetMessage()
      LOCAL lAssign, nCol
      LOCAL nPos, a 

#ifdef USE_HASH    

   //the fieldname always are lower case
   
      cCol = Lower( If( lAssign := Left( cCol, 1 ) == '_' , SubStr( cCol, 2 ), cCol ) )

      IF ! ( uParam1 == NIL ) 
         IF hGetPos( ::uRow, "_" + cCol ) > 0   
             
            HSet( ::uRow, "_" + cCol, uParam1 )
            RETURN uParam1
         ENDIF
      ELSE
         IF hGetPos( ::uRow, "_" + cCol ) > 0
            RETURN ::uRow[ "_" + cCol ]
         ENDIF
      ENDIF
#else
      cCol  = Lower( If( lAssign := ( Left( cCol, 1 ) == '_' ), SubStr( cCol, 2 ), cCol ) )
      IF( nCol := ::oQuery:FieldPos( cCol ) ) > 0
         RETURN If( lAssign, ::uRow[ nCol ] := uParam1, ::uRow[ nCol ] )
      ENDIF
#endif /*USE_HASH*/



   IF ! lAssign
      cCol = StrTran( cCol, "()", "" )
   ELSE 
      cCol = "_" + cCol
   ENDIF

#ifndef __XHARBOUR__
   IF uParam1 == nil
      a = __ObjSendMsg( ::oQuery, cCol )
   ELSE
      a = __ObjSendMsg( ::oQuery, cCol, uParam1 )
   ENDIF
#else   

   IF uParam1 == nil
      a = hb_execFromArray( @::oQuery, cCol )
   ELSE
      a = hb_execFromArray( @::oQuery, cCol, { uParam1 } )
   ENDIF
#endif 
      

RETURN a

FUNCTION VerifyValue( oQry, nIdx, cField  )
   LOCAL uValue := oQry:VerifyValue( nIdx, cField )
RETURN uValue
