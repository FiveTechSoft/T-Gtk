#include "gclass.ch"
 
function Main( )
   local oWnd
   local oBox
   local aArray := {}
   local n, j
   local oMenu, oItem,  oMainMenu, oBoxV
   
   for n = 1 to 20
      AAdd( aArray, {} )
      for j = 1 to 10 
         if j > 1
            AAdd( aArray[ n ], "Col - " + StrZero( j, 2 ) ) 
         else 
            AAdd( aArray[ n ], "Row " + StrZero( n, 2 ) ) 
         endif
      next 
   next
   
   USE ../../CUSTOMER.DBF NEW SHARED 

   define window oWnd title "DBF Browse test" size 640, 480

   define box oBoxV vertical of oWnd   
   
   define barmenu oMainMenu of oBoxV
   
   menubar oMenu of oMainMenu
   
      menuitem root oItem title "By Function" of oMenu

      menuitem oItem title "Dbf" ;
               action DbfBrowse();
               of oMenu

      menuitem oItem title "Array" ;
               action DbfBrowse( aArray );
               of oMenu 
   oMenu:Activate()
                  
   menubar oMenu of oMainMenu
    
      menuitem root oItem title "By Define" of oMenu

      menuitem oItem title "Dbf" ;
               action BrowseDbf( oWnd );
               of oMenu 

      menuitem oItem title "Array" ;
               action BrowseArray( oWnd, aArray );
               of oMenu 
               
   oMenu:Activate()
   
   activate window oWnd center
   
return nil


function BrowseDbf( oParent )

   local oWnd, oBrw, n := 0
   local aHeader := { "Name", "LastName", "Logical", "RecNo" }
   local aField  := { FieldWBlock( "first", Select() ), ;
                      FieldWBlock( "last", Select() ), ;
                      FieldWBlock( "set", Select() ), ;
                      {|| ( Alias() )->( RecNo() ) } }


   ( Alias() )->( DbGoTop() )

   DEFINE WINDOW oWnd TITLE "Browse dinamic" SIZE 800,600 of oParent
    
         DEFINE BROWSE oBrw ;
                ALIAS Alias();
                HEADER aHeader;
                FIELDS  aField;
                OF oWnd CONTAINER
   
           
   ACTIVATE WINDOW oWnd CENTER 

return nil


function BrowseArray( oParent, aArray )

   local oWnd, oBrw

   DEFINE WINDOW oWnd TITLE "Browse dinamic" SIZE 800,600 of oParent
    
         DEFINE BROWSE oBrw ;
                DATASOURCE aArray;
                OF oWnd CONTAINER
           
   ACTIVATE WINDOW oWnd CENTER 

return nil
