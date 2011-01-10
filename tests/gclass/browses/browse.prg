/* $Id: browse.prg,v 1.1 2006-09-11 16:48:16 xthefull Exp $*/
/**
 * Browse dinamic
 * (C) 2006 Rafa Carmona 
*/
#include "gclass.ch"
 
REQUEST HB_CODEPAGE_ESISO
 
function Main( )
   Local  oWnd
   Local oBox ,aFields , uData, x, oBrw, cType 
  /* 
   USE ../../CUSTOMER.DBF NEW SHARED    
   DbfBrowse( uData ) */
   
   HB_CDPSELECT( "ESISO" )
   SET_AUTO_UTF8( .T. )
   DEFINE WINDOW oWnd TITLE "Browse dinamic" SIZE 800,600
    
        USE ../../CUSTOMER.DBF NEW SHARED 
        aFields := array( fcount() )
        afields( aFields )
       
         DEFINE BROWSE oBrw ;
                ALIAS Alias();
                OF oWnd CONTAINER
           
         FOR X := 1 To Len( aFields )
             cType := VALTYPE( Field->&( aFields[X] ) ) 
             DO CASE  
                CASE cType = "N"
                     uData := &( "{|| cValToChar( Field->" + aFields[X] +" )  }" )
                     ADD COLUMN  TO BROWSE oBrw ;
                          DATA uData ;
                          HEADER aFields[X] ;
                          SIZE 150

                CASE cType = "C"
                     uData := &( "{|| Field->" + aFields[X] +" }" )
                     ADD COLUMN  TO BROWSE oBrw ;
                          DATA uData ;
                          HEADER aFields[X];
                          SIZE 150

                CASE cType = "L"
                     uData := &( "{|| Field->" + aFields[X] +"  }" )
                     ADD COLUMN  TO BROWSE oBrw ;
                          DATA uData ;
                          HEADER aFields[X] ;
                          TYPE COL_TYPE_RADIO ;
                          SIZE 50
             ENDCASE
         NEXT
    
    ACTIVATE WINDOW oWnd CENTER 


RETURN NIL
