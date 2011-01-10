/* $Id: browse_alleman.prg,v 1.1 2006-09-13 12:02:24 clneumann Exp $*/
/**
 * Browse for german umlauts (metafonia)
 * 
*/
#include "gclass.ch"
 
function Main( )
   Local  oWnd
   Local oBox ,aFields , uData, x, oBrw, cType 
   
   DEFINE WINDOW oWnd TITLE "dynamic Browse" SIZE 800,600
    
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
                          HEADER UTF_8( aFields[X] ) ;
                          SIZE 150

                CASE cType = "C"
                     uData := &( "{|| UTF_8( fumwgtk(Field->" + aFields[X] +") )  }" )
                     ADD COLUMN  TO BROWSE oBrw ;
                          DATA uData ;
                          HEADER UTF_8( aFields[X] ) ;
                          SIZE 150

                CASE cType = "L"
                     uData := &( "{|| Field->" + aFields[X] +"  }" )
                     ADD COLUMN  TO BROWSE oBrw ;
                          DATA uData ;
                          HEADER UTF_8( aFields[X] ) ;
                          TYPE COL_TYPE_RADIO ;
                          SIZE 50
             ENDCASE
         NEXT
    
    ACTIVATE WINDOW oWnd CENTER 

RETURN NIL

function fumwgtk(ctext)
ctext := strtran(ctext,"é","ƒ")
ctext := strtran(ctext,"ô","÷")
ctext := strtran(ctext,"ö","‹")
ctext := strtran(ctext,"·","ﬂ")
ctext := strtran(ctext,"Ñ","‰")
ctext := strtran(ctext,"î","ˆ")
ctext := strtran(ctext,"Å","¸")
RETURN ctext
