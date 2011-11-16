/*
 * $Id: 10/13/2010 5:51:30 PM function.c Z dgarciagil $
 */

/*
 * TDOLPHIN PROJECT source code:
 * wrapper function to libmysql.lib
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
 * along with this software; see the file COPYING.  If not, write to
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
#include <windows.h>   
#include <winnls.h>
#endif //#ifdef __WIN__
#include <hbapi.h>
#include <hbapiitm.h>
#include <hbapifs.h>
#include <hbstack.h>
#include <hbvm.h>
#include <mysql.h>
#include <locale.h>



#ifdef __HARBOUR__
#define hb_retclenAdopt( szText, ulLen )     hb_retclen_buffer( (szText), (ulLen) )
#endif //__HARBOUR__

const char * SQL2ClipType( long lType, BOOL bLogical );

//static PHB_SYMB symClip2MySql = NULL;
static char * szLang;

//char * LToStr( long w )
//{
//   static char dbl[ HB_MAX_DOUBLE_LENGTH ];
//   sprintf( dbl, "%f", ( double ) w );
//   * strchr( dbl, '.' ) = 0;
//   
//   return ( char * ) dbl;
//}  
//
//LPSTR DToStr( double w )
//{
//   static char dbl[ HB_MAX_DOUBLE_LENGTH ];
//   sprintf( dbl, "%f", w );
// //  * strchr( dbl, '.' ) = 0;
//   
//   return ( char * ) dbl;
//} 

//------------------------------------------------//

static HB_GARBAGE_FUNC( MYSQL_release )
{
   void ** ph = ( void ** ) Cargo;

   /* Check if pointer is not NULL to avoid multiple freeing */
   if( ph && * ph )
   {
      /* Destroy the object */
      mysql_close( ( MYSQL * ) * ph );

      /* set pointer to NULL to avoid multiple freeing */
      * ph = NULL;
   }
}

//------------------------------------------------//
//

static HB_GARBAGE_FUNC( MYSQL_RES_release )
{
   void ** ph = ( void ** ) Cargo;

   /* Check if pointer is not NULL to avoid multiple freeing */
   if( ph && * ph )
   {
      /* Destroy the object */
      mysql_free_result( ( MYSQL_RES * ) * ph );

      /* set pointer to NULL to avoid multiple freeing */
      * ph = NULL;
   }
}

//------------------------------------------------//
#ifndef __XHARBOUR__    
static const HB_GC_FUNCS s_gcMYSQLFuncs =
{
   MYSQL_release,
   hb_gcDummyMark
};

static const HB_GC_FUNCS s_gcMYSQL_RESFuncs =
{
   MYSQL_RES_release,
   hb_gcDummyMark
};

#endif //__XHARBOUR__

//------------------------------------------------//

static void hb_MYSQL_ret( MYSQL * p )
{
   if( p )
   {
#ifndef __XHARBOUR__    
      void ** ph = ( void ** ) hb_gcAllocate( sizeof( MYSQL * ), &s_gcMYSQLFuncs );
#else
      void ** ph = ( void ** ) hb_gcAlloc( sizeof( MYSQL * ), MYSQL_release );
#endif //__XHARBOUR__
      * ph = p;

      hb_retptrGC( ph );
   }
   else
      hb_retptr( NULL );
}

//------------------------------------------------//


static void hb_MYSQL_RES_ret( MYSQL_RES * p )
{
   if( p )
   {
#ifndef __XHARBOUR__
      void ** ph = ( void ** ) hb_gcAllocate( sizeof( MYSQL_RES * ), &s_gcMYSQL_RESFuncs );
#else      
      void ** ph = ( void ** ) hb_gcAlloc( sizeof( MYSQL_RES * ), MYSQL_RES_release );
#endif

      * ph = p;

      hb_retptrGC( ph );
   }
   else
      hb_retptr( NULL );
}

static MYSQL * hb_MYSQL_par( int iParam )
{
#ifndef __XHARBOUR__      
   void ** ph = ( void ** ) hb_parptrGC( &s_gcMYSQLFuncs, iParam );
#else
   void ** ph = ( void ** ) hb_parptrGC( MYSQL_release, iParam );
#endif //__XHARBOUR__

   return ph ? ( MYSQL * ) * ph : NULL;
}

//------------------------------------------------//

static MYSQL_RES * hb_MYSQL_RES_par( int iParam )
{
#ifndef __XHARBOUR__  
   void ** ph = ( void ** ) hb_parptrGC( &s_gcMYSQL_RESFuncs, iParam );
#else 
   void ** ph = ( void ** ) hb_parptrGC( MYSQL_RES_release, iParam );
#endif   
   return ph ? ( MYSQL_RES * ) * ph : NULL;
}


//------------------------------------------------//

HB_FUNC( VAL2ESCAPE )
{
   char *FromBuffer ;
   ULONG iSize;
   char *ToBuffer;
   BOOL bResult = FALSE ;
   iSize= hb_parclen( 1 ) ;

   FromBuffer = ( char * )hb_parc( 1 ) ;
   if ( iSize )
   {
     ToBuffer = ( char * ) hb_xgrab( ( iSize*2 ) + 1 );
     if ( ToBuffer )
     {
       iSize = mysql_escape_string( ToBuffer, FromBuffer, iSize );
       hb_retclenAdopt( ( char * ) ToBuffer, iSize ) ;
       bResult = TRUE ;
     }
   }
   if ( !bResult )
   {
     hb_retclen( ( char * ) FromBuffer, iSize ) ;
   }
}


//------------------------------------------------//
// returns parameter bitwise 
HB_FUNC( MYAND )
{
   hb_retnl( hb_parnl( 1 ) & hb_parnl( 2 ) );
}

//------------------------------------------------//
//unsigned long mysql_real_escape_string(MYSQL *mysql, char *to, const char *from, unsigned long length)
HB_FUNC( MYSQLESCAPE )
{
   char *FromBuffer ;
   ULONG iSize;
   char *ToBuffer;
   BOOL bResult = FALSE ;
   iSize= hb_parclen( 1 ) ;

   FromBuffer = ( char * )hb_parc( 1 ) ;
   if ( iSize )
   {
     ToBuffer = ( char * ) hb_xgrab( ( iSize*2 ) + 1 );
     if ( ToBuffer )
     {
       iSize = mysql_real_escape_string( ( MYSQL * ) hb_MYSQL_par( 2 ), ToBuffer, FromBuffer, iSize );
       hb_retclenAdopt( ( char * ) ToBuffer, iSize ) ;
       bResult = TRUE ;
     }
   }
   if ( !bResult )
   {
     hb_retclen( ( char * ) FromBuffer, iSize ) ;
   }
}



//------------------------------------------------//
// mysql_result, field pos, cSearch, nStart, nEnd
HB_FUNC( MYSEEK ) 
{
   MYSQL_RES * result = ( MYSQL_RES * ) hb_MYSQL_RES_par( 1 );
   MYSQL_ROW row;
   unsigned int uii;
   int uiStart = ISNUM( 4 ) ? ( unsigned int ) hb_parni( 4 ) - 1 : 0 ;
   int uiEnd, uiOk = -1;
   unsigned int uiField = hb_parni( 2 ) - 1;
   char * cSearch = ( char *) hb_parc( 3 );
   unsigned long * pulFieldLengths;
   BOOL bSoft = hb_parl( 6 );
   
   
   if (result > 0)
   {
      if( ! ISNUM( 5 ) )
         uiEnd = mysql_num_rows( result );
      else 
      	 uiEnd = hb_parni( 5 ); 

      while( uiStart < uiEnd )
      {
      	mysql_data_seek(result, uiStart);
      	row = mysql_fetch_row( result );
      	pulFieldLengths = mysql_fetch_lengths( result ) ;
        
        if( pulFieldLengths[ uiField ] != 0 )
        {
         	if( bSoft )
         	   pulFieldLengths[ uiField ] = strlen( cSearch );
       	  
         	if( row )
             uii = strcoll( ( const char * ) row[ uiField ], cSearch );         	  
//         		 uii = hb_strnicmp( ( const char * ) row[ uiField ], ( const char * ) cSearch, ( long ) pulFieldLengths[ uiField ] );
   
           if( uii == 0 )
           { 
           	 uiOk = uiStart;
           	 break;
           }     
        }
        uiStart++;
      }      	 

   }
   uiOk = uiOk >=0 ? uiOk + 1 : 0;
   hb_retnl( ( long ) uiOk  );
}



//------------------------------------------------//
// my_bool mysql_commit(MYSQL *mysql)
HB_FUNC( MYSQLCOMMIT )
{
	 int iret = 1;
   MYSQL * hMysql =  ( MYSQL * )hb_MYSQL_par( 1 );

   if( hMysql )
      iret = ( int )mysql_commit( hMysql );
   
   hb_retni( iret );
}	


//------------------------------------------------//
// MYSQL *mysql_real_connect( MYSQL*, char * host, char * user, char * password, char * db, uint port, char *, uint flags )
HB_FUNC( MYSQLCONNECT ) // -> MYSQL*
{
   MYSQL * mysql;
   const char *szHost = ( const char * ) hb_parc( 1 );
   const char *szUser = ( const char * ) hb_parc( 2 );
   const char *szPass = ( const char * ) hb_parc( 3 );
   unsigned int port  = ISNUM( 4 ) ? ( unsigned int ) hb_parni( 4 ) :  MYSQL_PORT;
   unsigned int flags = ISNUM( 5 ) ? ( unsigned int ) hb_parni( 5 ) :  0;
   const char *szdb = ISCHAR( 6 ) ? ( const char * ) hb_parc( 6 ): 0;
   mysql = mysql_init( NULL );
   if ( ( mysql != NULL ) )
   {
   	  mysql_real_connect( mysql, szHost, szUser, szPass, szdb, port, NULL, flags );
   	  hb_MYSQL_ret( mysql );
   }
   else
   {
     hb_retptr( NULL );
   }
}  

//------------------------------------------------//
//void mysql_close(MYSQL *mysql)
HB_FUNC( MYSQLCLOSE )//->none
{
#ifndef __XHARBOUR__  
   void ** ph = ( void ** ) hb_parptrGC( &s_gcMYSQLFuncs, 1 );
#else
   void ** ph = ( void ** ) hb_parptrGC( MYSQL_release, 1 );
#endif //__XHARBOUR__   

   /* Check if pointer is not NULL to avoid multiple freeing */
   if( ph && * ph )
   {
      /* Destroy the object */
      mysql_close( ( MYSQL * ) * ph );

      /* set pointer to NULL to avoid multiple freeing */
      * ph = NULL;
   }
}

//------------------------------------------------//
//void mysql_data_seek(MYSQL_RES *result, my_ulonglong offset)
HB_FUNC( MYSQLDATASEEK ) // ->void
{
   mysql_data_seek( ( MYSQL_RES * )hb_MYSQL_RES_par( 1 ), ( unsigned int )hb_parni( 2 ) );
   hb_ret();
}



//------------------------------------------------//
// char *mysql_error(MYSQL *mysql)
HB_FUNC( MYSQLERROR ) //-> A null-terminated character string that describes the error. 
                      //   An empty string if no error occurred.
{
   hb_retc( ( char * ) mysql_error( ( MYSQL * ) hb_MYSQL_par( 1 ) ) );
}


//------------------------------------------------//
// unsigned int mysql_num_fields( MYSQL_RES * )
HB_FUNC( MYSQLFIELDCOUNT ) //-> num fields
{
   hb_retnl( mysql_field_count( ( ( MYSQL * )hb_MYSQL_par( 1 ) ) ) );
}


//------------------------------------------------//
// void mysql_free_result( MYSQL_RES * )
HB_FUNC( MYSQLFREERESULT ) // VOID
{
   mysql_free_result( ( MYSQL_RES * )hb_MYSQL_RES_par( 1 ) );
}


//------------------------------------------------//
//unsigned int mysql_errno(MYSQL *mysql) 
// MYSQL_RES, [ num_fields ]
HB_FUNC( MYSQLFETCHROW ) // -> array current row data
{
   MYSQL_RES *mresult = ( MYSQL_RES * )hb_MYSQL_RES_par( 1 );
   UINT ui, uiNumFields;
   ULONG *pulFieldLengths ;
   MYSQL_ROW mrow;
   PHB_ITEM itRow;

   if( hb_pcount() > 1 )
      uiNumFields = hb_parnl( 2 );
   else
   	  uiNumFields = mysql_num_fields( mresult );

   itRow           = hb_itemArrayNew( uiNumFields );
   mrow            = mysql_fetch_row( mresult );
   pulFieldLengths = mysql_fetch_lengths( mresult ) ;
   
   if ( mrow )
   {
     for ( ui = 0; ui < uiNumFields; ui++ )
     {
       if ( mrow[ ui ] == NULL )
       {
         hb_arraySetC( itRow, ui + 1, NULL );
       }
       else  
       {
         hb_arraySetCL( itRow, ui + 1, mrow[ ui ], pulFieldLengths[ ui ] );
       }
     }
   }
   hb_itemReturnRelease( itRow );

}


//------------------------------------------------//
//unsigned int mysql_errno(MYSQL *mysql)
HB_FUNC( MYSQLGETERRNO )//->An error code value for the last mysql_xxx()
{
   hb_retnl( mysql_errno( ( MYSQL * ) hb_MYSQL_par( 1 ) ) );
}

//------------------------------------------------//
//MYSQL_RES *mysql_list_tables(MYSQL *mysql, const char *wild)
HB_FUNC( MYSQLLISTTBLS ) //->Array List Table
{
   MYSQL * mysql = ( MYSQL * ) hb_MYSQL_par( 1 );
   const char *szwild = ( const char* ) hb_parc( 2 );
   MYSQL_RES * mresult = NULL;
   MYSQL_ROW mrow;
   long nr, i;
   PHB_ITEM itemReturn;

   if( mysql )
      mresult = mysql_list_tables( mysql, szwild );

   if( mresult )
   {
      nr = ( LONG ) mysql_num_rows( mresult );

      itemReturn = hb_itemArrayNew( nr );
      
      for ( i = 0; i < nr; i++ )
      {
     	   PHB_ITEM pString;
         mrow = mysql_fetch_row( mresult );
         pString = hb_itemPutC( NULL, mrow[ 0 ] );
         hb_itemArrayPut( itemReturn, i+1, pString );
         hb_itemRelease( pString );
      }
      mysql_free_result( mresult );
      
   }else
   itemReturn = hb_itemArrayNew( 0 );

   hb_itemReturn( itemReturn );
   hb_itemRelease( itemReturn );         

}

//------------------------------------------------//
//MYSQL_RES *mysql_list_dbs(MYSQL *mysql, const char *wild)
HB_FUNC( MYSQLLISTDBS ) //->Array List Databases
{
   MYSQL * mysql = ( MYSQL * ) hb_MYSQL_par( 1 );
   const char *szwild = ( const char* ) hb_parc( 2 );
   MYSQL_RES * mresult = NULL;
   MYSQL_ROW mrow;
   long nr, i;
   PHB_ITEM itemReturn;

   if( mysql )
      mresult = mysql_list_dbs( mysql, szwild );
   if( mresult )
   {
      nr = ( LONG ) mysql_num_rows( mresult );

      itemReturn = hb_itemArrayNew( nr );
      for ( i = 0; i < nr; i++ )
      {
     	   PHB_ITEM pString;
         mrow = mysql_fetch_row( mresult );
         pString = hb_itemPutC( NULL, mrow[ 0 ] );
         hb_itemArrayPut( itemReturn, i+1, pString );
         hb_itemRelease( pString );         
      }
      mysql_free_result( mresult );      
   }else
   itemReturn = hb_itemArrayNew( 0 );

   hb_itemReturn( itemReturn );
   hb_itemRelease( itemReturn );         

}

//------------------------------------------------//
//my_ulonglong mysql_num_rows(MYSQL_RES *result)
HB_FUNC( MYSQLNUMROWS ) // -> The number of rows in the result set.
{
   hb_retnll( ( LONGLONG )mysql_num_rows( ( ( MYSQL_RES * )hb_MYSQL_RES_par( 1 ) ) ) );
}


//------------------------------------------------//
//int mysql_options(MYSQL *mysql, enum mysql_option option, const void *arg)
HB_FUNC( MYSQLOPTION )
{
	const void *arg = ( const void * ) hb_param( 1, HB_IT_ANY );
	MYSQL *mysql = ( MYSQL * ) hb_MYSQL_par( 1 );
  int iret = 1;
	if( mysql )
	   iret = mysql_options( mysql, ( enum mysql_option )hb_parnl( 2 ), arg );
	   
	hb_retni( iret );
}

//------------------------------------------------//
//int mysql_ping(MYSQL *mysql)
HB_FUNC( MYSQLPING )//Zero if the connection to the server is alive. Nonzero if an error occurred
{
   int nping = 1;
   MYSQL * hMysql =  ( MYSQL * )hb_MYSQL_par( 1 );
   
   if( hMysql )
      nping = mysql_ping( hMysql );
   
   hb_retni( nping );
}

//------------------------------------------------//
//int mysql_real_query(MYSQL *mysql, const char *stmt_str, unsigned long length)
HB_FUNC( MYSQLQUERY ) //
{
   hb_retnl( ( long ) mysql_real_query( ( MYSQL * )hb_MYSQL_par( 1 ),
              ( const char * ) hb_parc( 2 ),
              ( unsigned long ) hb_parnl( 3 ) ) ) ;
}

//------------------------------------------------//
// my_bool mysql_rollback(MYSQL *mysql)
HB_FUNC( MYSQLROLLBACK )
{
	 int iret = 1;
   MYSQL * hMysql =  ( MYSQL * )hb_MYSQL_par( 1 );

   if( hMysql )
      iret = ( int )mysql_rollback( hMysql );
   
   hb_retni( iret );
}	


//------------------------------------------------//
//int mysql_select_db(MYSQL *mysql, const char *db)
HB_FUNC( MYSQLSELECTDB ) //-> Zero for success. Nonzero if an error occurred.
{
   const   char * db = ( const char* ) hb_parc( 2 );
   hb_retnl( ( long ) mysql_select_db( ( MYSQL * ) hb_MYSQL_par( 1 ), db ) );
}

//------------------------------------------------//
//MYSQL_RES *mysql_list_fields(MYSQL *mysql, const char *table, const char *wild)
HB_FUNC( MYSQLLISTFIELDS ) // -> MYSQL_RES *
{
   hb_MYSQL_RES_ret( mysql_list_fields( ( MYSQL * )hb_MYSQL_par( 1 ), hb_parc( 2 ), hb_parc( 3 ) ) );
}


//------------------------------------------------//
// Build a Array with table structure 
HB_FUNC( MYSQLRESULTSTRUCTURE ) //-> Query result Structure
{
	MYSQL_RES * mresult = ( MYSQL_RES * ) hb_MYSQL_RES_par( 1 );
	unsigned int num_fields;
	PHB_ITEM itemReturn = hb_itemArrayNew( 0 );
	PHB_ITEM itemField = hb_itemNew( NULL );
	MYSQL_FIELD *mfield;
	BOOL bCase = hb_parl( 2 );
	BOOL bNoLogical = hb_param( 3, HB_IT_LOGICAL ) ? hb_parl( 3 ) : FALSE;
	
	
	if( mresult )
  {
  	 unsigned int i;
     num_fields = mysql_num_fields( mresult );
     for( i = 0; i < num_fields; i++)
     {
     	  mfield = mysql_fetch_field( mresult ) ;
        hb_arrayNew( itemField, 9 );

        // The fieldname are convert to lower case
     	  hb_arraySetC( itemField, 1, hb_strLower( mfield->name, strlen( mfield->name ) ) ) ;  

        // only table name are affect by case sensitive      
        if( bCase )
           hb_arraySetC( itemField, 2, mfield->table );  
        else
        	 hb_arraySetC( itemField, 2, hb_strLower( mfield->table, strlen( mfield->table ) ) ) ;  
       
//        MessageBox( 0, mfield->name, "ok", 0 );	         	   
        hb_arraySetC( itemField, 3, mfield->def );
        hb_arraySetNL( itemField, 4, mfield->type );
        hb_arraySetNL( itemField, 5, mfield->length );
        hb_arraySetNL( itemField, 6, mfield->max_length );
        hb_arraySetNL( itemField, 7, mfield->flags );
        hb_arraySetNL( itemField, 8, mfield->decimals );   
        hb_arraySetC( itemField, 9, SQL2ClipType( ( long ) mfield->type, bNoLogical ) );
     	  hb_arrayAddForward( itemReturn, itemField );
      }
  } else
     itemReturn = hb_itemArrayNew( 0 );

   hb_itemRelease( itemField );
   hb_itemReturnRelease( itemReturn );
}

////------------------------------------------------//
//// Build a Array with table structure 
//HB_FUNC( DOLPHINFILLARRAY ) //-> Query result Structure
//{
//	MYSQL_RES * mresult = ( MYSQL_RES * ) hb_MYSQL_RES_par( 1 );
//	PHB_ITEM pBlock = hb_param( 2, HB_IT_BLOCK ) ? hb_param( 2, HB_IT_BLOCK ) : NULL;
//	unsigned int num_fields, ui;
//	PHB_ITEM itemReturn = hb_itemArrayNew( 0 );
//	PHB_ITEM itemRow = hb_itemNew( NULL );
//	MYSQL_ROW mrow;
//	ULONG *pulFieldLengths ;
//  PHB_ITEM self = hb_param( 3, HB_IT_ARRAY );
//	     	  
//	int i = 0;
//	
//	
//	if( symClip2MySql == NULL )
//	   symClip2MySql = hb_dynsymSymbol( hb_dynsymFind( "VERIFYVALUE" ) );
//	   
//	
//	if( mresult )
//  {
//     num_fields = mysql_num_fields( mresult );
//     pulFieldLengths = mysql_fetch_lengths( mresult ) ;
//   	 mysql_data_seek( mresult, 0 );
//     while( mrow = mysql_fetch_row( mresult ) )
//     {
//        if ( mrow )
//        {
//          hb_arrayNew( itemRow, num_fields );
//          for ( ui = 0; ui < num_fields; ui++ )
//          {
//            if ( mrow[ ui ] == NULL )
//            {
//              hb_arraySetC( itemRow, ui + 1, NULL );
//            }
//            else  
//            {
//              PHB_ITEM pReturn;
//              hb_vmPushSymbol( symClip2MySql );
//              hb_vmPushNil();
//              hb_vmPush( self );
//              hb_vmPushLong( ui + 1 );
//              hb_vmPushString( mrow[ ui ], pulFieldLengths[ ui ] );
//              hb_vmDo( 3 );	
//              pReturn = hb_stackReturnItem();
//              if( HB_IS_STRING( pReturn ) )
//                 hb_arraySetC( itemRow, ui + 1, hb_parc( -1 ) ) ;
//              else if( HB_IS_NUMERIC( pReturn ) )
//                hb_arraySetNL( itemRow, ui + 1, hb_parnl( -1 ) );
//              else if( HB_IS_LOGICAL( pReturn ) )
//                hb_arraySetL( itemRow, ui + 1, hb_parl( -1 ) );
//              else if( HB_IS_DATE( pReturn ) )
//                hb_arraySetDS( itemRow, ui + 1, hb_pards( -1 ) );
//             else
//                MessageBox( 0, "error", "ok", 0 );
//            }
//          }
//          if( pBlock)
//            {
//               PHB_ITEM pParam = hb_itemPutNI( NULL, ++i );
//               hb_evalBlock( pBlock, itemRow, pParam, 0 );
//            }
//          hb_arrayAddForward( itemReturn, itemRow );
//        }
//      }
//   }
//
//   hb_itemRelease( itemRow );
//   hb_itemReturnRelease( itemReturn );
//}


//------------------------------------------------//
// MYSQL_RES *mysql_store_result(MYSQL *mysql)
HB_FUNC( MYSQLSTORERESULT ) // -> MYSQL_RES 
{
   hb_MYSQL_RES_ret( mysql_store_result( ( MYSQL * )hb_MYSQL_par( 1 ) ) );
}

//------------------------------------------------//
// convert MySql field type to clipper field type
const char * SQL2ClipType( long lType, BOOL bNoLogical ) //-> Clipper field type 
{
	 const char * sType;
	 
   switch ( lType ){

      case FIELD_TYPE_DECIMAL     :
         sType = "N";
         break;

      case FIELD_TYPE_NEWDECIMAL  :
         sType = "N";
         break;

      case FIELD_TYPE_TINY        :
         sType = bNoLogical ? "L" : "N";
         break;

      case FIELD_TYPE_SHORT       :
         sType = "N";
         break;
         
      case FIELD_TYPE_LONG        :
         sType = "N";
         break;
         
      case FIELD_TYPE_FLOAT       :
         sType = "N";
         break;
         
      case FIELD_TYPE_DOUBLE      :
         sType = "N";
         break;
         
      case FIELD_TYPE_NULL        :
         sType = "U";
         break;
         
      case FIELD_TYPE_TIMESTAMP   :
         sType = "T";
         break;
         
      case FIELD_TYPE_LONGLONG    :
         sType = "N";
         break;
         
      case FIELD_TYPE_INT24       :
         sType = "N";
         break;
         
      case FIELD_TYPE_DATE        :
         sType = "D";
         break;
         
      case FIELD_TYPE_TIME        :
         sType = "C";
         break;
         
      case FIELD_TYPE_DATETIME    :
         sType = "C";
         break;
         
      case FIELD_TYPE_YEAR        :
         sType = "N";
         break;
         
      case FIELD_TYPE_MEDIUM_BLOB :
         sType = "M";
         break;
      	
      case FIELD_TYPE_LONG_BLOB   :
         sType = "M";
         break;

      case FIELD_TYPE_BLOB        :
         sType = "M";
         break;

      case FIELD_TYPE_STRING      :
         sType = "C";
         break;

      case MYSQL_TYPE_VAR_STRING  :
         sType = "C";
         break;
         
      case FIELD_TYPE_BIT         :      	
         sType = bNoLogical ? "L" : "N";
         break;
      case FIELD_TYPE_NEWDATE     :
      case FIELD_TYPE_ENUM        :
      case FIELD_TYPE_SET         :
      case FIELD_TYPE_TINY_BLOB   :         
      case FIELD_TYPE_GEOMETRY    :
      default:
      	sType = "U";

 }

   return sType;
}

//------------------------------------------------//
// convert MySql field type to char
const char * SQLType2Char( long lType ) //-> Clipper field type 
{
	 const char * sType;
	 
   switch ( lType ){

      case FIELD_TYPE_DECIMAL     :
      case FIELD_TYPE_NEWDECIMAL  :
         sType = "DECIMAL";
         break;

      case FIELD_TYPE_TINY        :
         sType = "TINY";
         break;

      case FIELD_TYPE_SHORT       :
         sType = "SHORT";
         break;
         
      case FIELD_TYPE_LONG        :
         sType = "LONG";
         break;
         
      case FIELD_TYPE_FLOAT       :
         sType = "FLOAT";
         break;
         
      case FIELD_TYPE_DOUBLE      :
         sType = "DOUBLE";
         break;
         
      case FIELD_TYPE_NULL        :
         sType = "NULL";
         break;
         
      case FIELD_TYPE_TIMESTAMP   :
         sType = "TIME STAMP";
         break;
         
      case FIELD_TYPE_LONGLONG    :
         sType = "LONGLONG";
         break;
         
      case FIELD_TYPE_INT24       :
         sType = "INT24";
         break;
         
      case FIELD_TYPE_DATE        :
         sType = "DATE";
         break;
         
      case FIELD_TYPE_TIME        :
         sType = "TIME";
         break;
         
      case FIELD_TYPE_DATETIME    :
         sType = "DATETIME";
         break;
         
      case FIELD_TYPE_YEAR        :
         sType = "YEAR";
         break;
         
      case FIELD_TYPE_MEDIUM_BLOB :
         sType = "MEDIUM BLOB";
         break;
      	
      case FIELD_TYPE_LONG_BLOB   :
         sType = "LONG BLOB";
         break;

      case FIELD_TYPE_BLOB        :
         sType = "BLOB";
         break;

      case FIELD_TYPE_STRING      :
         sType = "STRING";
         break;
      
      case MYSQL_TYPE_VAR_STRING  :
      	 sType = "BIGINT";
      	 break;
         
      case FIELD_TYPE_BIT         :      	
         sType = "TINYINT";
         break;
      case FIELD_TYPE_NEWDATE     :
         sType = "NEW DATE";
         break;

      case FIELD_TYPE_ENUM        :
         sType = "ENUM";
         break;

      case FIELD_TYPE_SET         :
         sType = "SET";
         break;

      case FIELD_TYPE_TINY_BLOB   :         
         sType = "TINY BLOB";
         break;
      	
      default:
      	sType = "U";

 }

   return sType;
}

//------------------------------------------------//

HB_FUNC( SQL2CLIPTYPE )
{
	hb_retc( SQL2ClipType( hb_parnl( 1 ), hb_parl( 2 ) ) );
}

//------------------------------------------------//

HB_FUNC( SQLTYPE2CHAR )
{
	hb_retc( SQLType2Char( hb_parnl( 1 ) ) );
}

//------------------------------------------------//
// Function taked from mysql.c (xHarbour)
HB_FUNC( FILETOSQLBINARY )
{
   BOOL bResult = FALSE ;
   char *szFile = ( char * )hb_parc( 1 );
   HB_FHANDLE fHandle;
   ULONG iSize;
   char *ToBuffer;
   char *FromBuffer;
   if ( szFile && hb_parclen( 1 ) )
   {
     fHandle    = hb_fsOpen( ( const char * ) szFile,2 );
     if ( fHandle > 0 )
     {
       iSize      = hb_fsFSize( szFile, FALSE );
       if ( iSize > 0 )
       {
         FromBuffer = ( char * ) hb_xgrab( iSize );
         if ( FromBuffer )
         {
           iSize      = hb_fsReadLarge( fHandle , ( BYTE * ) FromBuffer , iSize );
           if ( iSize > 0 )
           {
             ToBuffer   = ( char * ) hb_xgrab( ( iSize*2 ) + 1 );
             if ( ToBuffer )
             {
               if ISNUM( 2 )
               {
                 iSize = mysql_real_escape_string( ( MYSQL * ) hb_MYSQL_par( 2 ), ToBuffer, FromBuffer, iSize );
               }
               else
               {
                 iSize = mysql_escape_string( ToBuffer, FromBuffer, iSize );
               }
               hb_retclenAdopt( ( char * ) ToBuffer, iSize );
               bResult = TRUE ;
             }
           }
           hb_xfree( FromBuffer );
         }
       }
       hb_fsClose( fHandle );
     }
   }
   if ( !bResult )
   {
     hb_retc( "" ) ;
   }
}

//------------------------------------
HB_FUNC( D_READFILE )
{
   char *szFile = ( char * )hb_parc( 1 );
   HB_FHANDLE fHandle;
   ULONG iSize;
   char *FromBuffer;
   BOOL bError = FALSE;
   
   if ( szFile && hb_parclen( 1 ) )
   {
     fHandle    = hb_fsOpen( ( const char * ) szFile, HB_FA_ALL );
     if ( fHandle > 0 )
     {
       iSize      = hb_fsFSize( szFile, FALSE );
       if ( iSize > 0 )
       {
         FromBuffer = ( char * ) hb_xgrab( iSize );
         if ( FromBuffer )
         {
           iSize      = hb_fsReadLarge( fHandle , ( BYTE * ) FromBuffer , iSize );
         }else
         	   bError = TRUE;
       }else
          bError = TRUE;
     }else 
        bError = TRUE;
   }else 
      bError = TRUE;
    
   hb_fsClose( fHandle );
   
   if( bError )
      hb_retc( "" ) ;
   else
      hb_retclenAdopt( ( char * ) FromBuffer, iSize );
  
}

//------------------------------------
HB_FUNC( MYSQLEMBEDDED )  
{
   MYSQL *mysql;
   const char *szDataBase = hb_parc( 1 );
	 PHB_ITEM pArrayOption  = hb_param( 2, HB_IT_ARRAY );
	 PHB_ITEM pArrayGroup   = hb_param( 3, HB_IT_ARRAY );
	 PHB_ITEM pItem;
	 int j, argc, iGroups;
	 char **server_options;
	 char **server_groups;
	 int iError = 0; 

   //build server options
	 argc           = hb_arrayLen( pArrayOption );
   if( argc > 0 ){
      char * p;
   	  server_options = ( char ** )hb_xgrab( sizeof( char *) * ( argc + 1 ) ) ;
      for( j = 0; j < argc; j++ )
      {
   	    pItem = hb_itemArrayGet( pArrayOption, j + 1 );
   	    p = hb_itemGetC( pItem ) ;
   	    server_options[ j ] = p;
      }
      server_options[ j ] = (char *) NULL ;
      hb_itemRelease( pItem );
   }

   //build groups
   iGroups       = hb_arrayLen( pArrayGroup );
   if( iGroups > 0 ) {
      char * p;
      server_groups = ( char ** )hb_xgrab( sizeof( char * )* ( iGroups + 1) );
      for( j = 0; j < iGroups; j++ )
      {
   	    pItem = hb_itemArrayGet( pArrayGroup, j + 1 );
   	    p = hb_itemGetC( pItem ) ;
       	server_groups[ j ] = p;
      }
      server_groups[ j ] = ( char *) NULL;
      hb_itemRelease( pItem );
   }

   //Initialize MySQL Embedded libmysqld.
   if( mysql_library_init(argc, server_options, server_groups ) == 0 )
   { 

      //Initialize MySQL Library. */
      if( ( mysql = mysql_init( NULL ) ) != NULL )
      {
         //Force use of embedded libmysqld. */
         mysql_options(mysql, MYSQL_OPT_USE_EMBEDDED_CONNECTION, NULL);
         
         //Connect to MySQL.
        if(mysql_real_connect(mysql, NULL, NULL, NULL, szDataBase, 0, NULL, 0) == NULL)
        {
            mysql_close(mysql);
            mysql_library_end();
            iError = 1;
        }
      }
    }

    if( iError == 1 )
    {
    	 if( server_options )
          hb_xfree( ( void * ) server_options );
       if( server_groups )
          hb_xfree( ( void * ) server_groups );
       hb_retnl( ( long ) 0 );
    }

   hb_MYSQL_ret( mysql );
}

//------------------------------------

unsigned int InternalSeek( MYSQL_RES* presult, int iData, unsigned int uiField, BOOL bSoft, char * cSearch )
{
   MYSQL_ROW row;
   unsigned long * pulFieldLengths;
   unsigned int uii;
   char * szSource;
   int iLen = strlen( cSearch );
   
   mysql_data_seek(presult, iData);
   row = mysql_fetch_row( presult );
   pulFieldLengths = mysql_fetch_lengths( presult ) ;
        
   if( pulFieldLengths[ uiField ] != 0 )
   {
      if( bSoft )
      {
         szSource = ( char * ) hb_xgrab( iLen );        
         hb_strncpy( szSource, row[ uiField ], iLen );
         hb_strLower( szSource, iLen  );
         hb_strLower( cSearch, iLen );
      }
      else
      {
         szSource = ( char * ) hb_xgrab(  pulFieldLengths[uiField] );
         hb_strncpy( szSource, row[ uiField ], pulFieldLengths[uiField] );
      }
//         pulFieldLengths[ uiField ] = strlen( cSearch );
      setlocale( LC_COLLATE, szLang );
      
      uii = strcoll( ( const char * ) szSource, cSearch );         
      hb_xfree( szSource );
//      uii = hb_stricmp( ( const char * ) szSource, cSearch );//, ( long ) pulFieldLengths[ uiField ] );
   }
   return uii;
}

//------------------------------------------------//
// mysql_result, field pos, cSearch, nStart, nEnd
HB_FUNC( MYSEEK2 ) 
{
   MYSQL_RES * result = ( MYSQL_RES * ) hb_MYSQL_RES_par( 1 );
   unsigned int uii, uii2;
   int uiStart = ISNUM( 4 ) ? ( unsigned int ) hb_parni( 4 ) - 1 : 0 ;
   int uiStart2;
   int uiEnd, uiOk = -1;
   unsigned int uiField = hb_parni( 2 ) - 1;
   char * cSearch = ( char *) hb_parc( 3 );
   BOOL bSoft = hb_parl( 6 );
   int iMid;
   int iLastFound;
   
   if (result > 0)
   {
      if( ! ISNUM( 5 ) )
         uiEnd = mysql_num_rows( result );
      else 
      	 uiEnd = hb_parni( 5 ); 
      //we need check first record
      uii = InternalSeek( result, 0, uiField, bSoft, cSearch );
      if( uii == 0 ) 
         uiOk = 0;
         
      iMid = ( uiEnd + uiStart ) / 2;
      while( uiStart < iMid && uiOk < 0 )
      {
         uii = InternalSeek( result, iMid, uiField, bSoft, cSearch );

         if( uii == -1 )
            uiStart = iMid;
         else if( uii == 1 )
            uiEnd = iMid; 
         else 
         {
             iLastFound = iMid;
             uiStart2 = uiStart2 = iLastFound - 1;
             while( iLastFound > uiStart2 )
             {
                uii2 = InternalSeek( result, uiStart2, uiField, bSoft, cSearch );
                
                if( uii2 != 0 )
                {
                  break;
                }  
                else 
                  iLastFound = uiStart2;
                  
                uiStart2 = iLastFound - 1;
                if( uiStart2 < 0 )
                {
                  break;
                }
             }
             uiOk = iLastFound;
             break;
         }
          iMid = ( uiEnd + uiStart ) / 2;
      }      	 

   }
   
   uiOk = uiOk >=0 ? uiOk + 1 : 0;
   hb_retnl( ( long ) uiOk  );
}

//------------------------------------
unsigned int InternalLocate( MYSQL_RES* presult, int iData, PHB_ITEM pFields, PHB_ITEM pValues, BOOL bSoft )
{
   MYSQL_ROW row;
   unsigned int uii;
   int i, j;
   long lField, lLen;
   char * cSearch;
   char * szSource;
   
   mysql_data_seek(presult, iData);
   row = mysql_fetch_row( presult );
	 i   = hb_arrayLen( pFields );
   if( i > 0 ){
      for( j = 0; j < i; j++ )
      { 
        lField = hb_arrayGetNL( pFields, j + 1 ) - 1;
        if ( row[ lField ] )
        {
           cSearch = hb_arrayGetC( pValues, j + 1 );
      	   lLen = strlen( cSearch );
      	   szSource = ( char * )hb_xgrab( lLen );
           if( bSoft )
           {
              hb_strncpy( szSource, row[ lField ], lLen );
              hb_strLower( szSource, lLen  );
              hb_strLower( cSearch, lLen );
           }
           else
      	       hb_strncpy( szSource, row[ lField ], lLen );
      	       
   //   	    uii = hb_strnicmp( ( const char * ) row[ lField ], cSearch, strlen( cSearch ) );
           setlocale( LC_COLLATE, szLang );
           uii = strcoll( ( const char * ) szSource, cSearch );
           hb_xfree( szSource );
      	    if( uii != 0 )
      	    {
      	        break; 
      	    }
      	 }
      }      
   }

   return uii;
}

//------------------------------------------------//

HB_FUNC( SET_MYLANG )
{
   char * szl = szLang;
   if( hb_pcount() > 0 )
      szLang = ( char * )hb_parc( 1 );
      
   hb_retc( szl );
}

//------------------------------------------------//
// mysql_result, field pos, cSearch, nStart, nEnd
HB_FUNC( MYLOCATE ) 
{
   MYSQL_RES * result = ( MYSQL_RES * ) hb_MYSQL_RES_par( 1 );
   unsigned int uii, uii2;
   int uiStart = ISNUM( 4 ) ? ( unsigned int ) hb_parni( 4 ) - 1 : 0 ;
   int uiStart2;
   int uiEnd, uiOk = -1;
	 PHB_ITEM pArrayFields  = hb_param( 2, HB_IT_ARRAY );
	 PHB_ITEM pArrayValues  = hb_param( 3, HB_IT_ARRAY );
   int iMid;
   int iLastFound;
   BOOL bSoft = hb_parl( 6 );
   
   
   if (result > 0)
   {
      if( ! ISNUM( 5 ) )
         uiEnd = mysql_num_rows( result );
      else 
      	 uiEnd = hb_parni( 5 ); 

      //we need check first record
      uii = InternalLocate( result, 0, pArrayFields, pArrayValues, bSoft );
      if( uii == 0 ) 
         uiOk = 0;
      
      iMid = ( uiEnd + uiStart ) / 2;
      
      while( uiStart < iMid && uiOk < 0 )
      {
         uii = InternalLocate( result, iMid, pArrayFields, pArrayValues, bSoft );
       		 
         if( uii == -1 )
            uiStart = iMid;
         else if( uii == 1 )
            uiEnd = iMid; 
         else 
         {
             iLastFound = iMid;
             uiStart2 = uiStart2 = iLastFound - 1;
             while( iLastFound > uiStart2 )
             {
                uii2 = InternalLocate( result, uiStart2, pArrayFields, pArrayValues, bSoft );
                
                if( uii2 != 0 )
                {
                  break;
                }  
                else 
                  iLastFound = uiStart2;
                  
                uiStart2 = iLastFound - 1;
                if( uiStart2 < 0 )
                {
                  break;
                }                
             }
             uiOk = iLastFound;
             break;
         }
         iMid = ( uiEnd + uiStart ) / 2;
      }      	 

   }
   
   uiOk = uiOk >=0 ? uiOk + 1 : 0;
   hb_retnl( ( long ) uiOk  );
}

//------------------------------------------------//
// mysql_result, field pos, cSearch, nStart, nEnd
HB_FUNC( MYFIND ) 
{
   MYSQL_RES * result = ( MYSQL_RES * ) hb_MYSQL_RES_par( 1 );
   MYSQL_ROW row;
   unsigned int uii;
   int uiStart = ISNUM( 4 ) ? ( unsigned int ) hb_parni( 4 ) - 1 : 0 ;
   int uiEnd, uiOk = -1, i, j;
	 PHB_ITEM pArrayFields  = hb_param( 2, HB_IT_ARRAY );
	 PHB_ITEM pArrayValues  = hb_param( 3, HB_IT_ARRAY );
	 long lField, lencSearch;
	 char * cSearch;
	 char * cSrc;
	 BOOL bSoft = hb_parl( 6 );
   
   if (result > 0)
   {
      if( ! ISNUM( 5 ) )
         uiEnd = mysql_num_rows( result );
      else 
      	 uiEnd = hb_parni( 5 ); 

      while( uiStart < uiEnd )
      {
      	mysql_data_seek(result, uiStart);
      	row = mysql_fetch_row( result );

        i = hb_arrayLen( pArrayFields );
      
        if( i > 0 ){
            for( j = 0; j < i; j++ )
            { 
         	    lField = hb_arrayGetNL( pArrayFields, j + 1 ) - 1;
         	    cSearch = hb_arrayGetC( pArrayValues, j + 1 );

         	    if( row[ lField ] )
         	    {
                 cSrc = ( char * )hb_xgrab( ( lencSearch = strlen( cSearch ) ) );
                 if( bSoft )
                 {
                    hb_strncpy( cSrc, row[ lField ], lencSearch );
                    hb_strLower( cSrc, lencSearch  );
                    hb_strLower( cSearch, lencSearch );
                 }
                 else
            	       hb_strncpy( cSrc, row[ lField ], lencSearch );

//         	    uii = hb_strnicmp( ( const char * ) row[ lField ], cSearch, strlen( cSearch ) );
                 uii = strcoll( ( const char * ) cSrc, cSearch );
                 hb_xfree( cSrc );
              }
         	    if( uii != 0 )
         	    {
         	        break; 
         	    }
            }      
         }
         if( uii == 0 )
         { 
         	 uiOk = uiStart;
         	 break;
         }     
         uiStart++;
      }      	 

   }
   uiOk = uiOk >=0 ? uiOk + 1 : 0;
   hb_retnl( ( long ) uiOk  );
}

#ifdef __WIN__
HB_FUNC( GETDECIMALSEP )
{ 
  LCID lcid = GetThreadLocale();
  LPSTR value;
  GetLocaleInfo(lcid, LOCALE_SDECIMAL, ( LPSTR )&value, sizeof(value) / sizeof(TCHAR) );
  hb_retc( ( LPSTR )&value );
}  

HB_FUNC( GETTHOUSANDSEP )
{ 
  LCID lcid = GetThreadLocale();
  LPSTR value;
  GetLocaleInfo(lcid, LOCALE_STHOUSAND, ( LPSTR )&value, sizeof(value) / sizeof(TCHAR) );
  hb_retc( ( LPSTR )&value );
}  


HB_FUNC( __OPENCLIPBOARD )
{
   hb_retl( OpenClipboard( ( HWND ) hb_parnl( 1 ) ) );
}

HB_FUNC( __SETCLIPBOARDDATA )
{
   ULONG ulLen;
   HGLOBAL hMem;
   void far * pMem;

   ulLen = hb_parclen( 1 );
   hMem = GlobalAlloc( GHND, ulLen + 1 );
   if( ! hMem )
   {
      hb_retl( 0 );
      return;
   }

   pMem = GlobalLock( hMem );
   memcpy( ( char * ) pMem, ( char * ) hb_parc( 1 ), ulLen );
   GlobalUnlock( hMem );
   hb_retl( ( BOOL ) SetClipboardData( CF_TEXT, hMem ) );

}

HB_FUNC( __EMPTYCLIPBOARD )   //
{
   hb_retl( EmptyClipboard() );
}

HB_FUNC( __CLOSECLIPBOARD )   // ()  --> lSuccess
{
   hb_retl( CloseClipboard() );
}
#endif //__WIN__
