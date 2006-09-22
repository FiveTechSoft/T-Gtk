/**
 * Test de ABM usando DbGrid
 * (C) 2005 Rafa Carmona 
 * 07-12-2005 Modificado por Joaquim Ferrer
 *
 * Notas By Quim, acerca de registros borrados.
 * El browse DbfGrid se basa en la longitud de registros que devuelve bLogicLen.
 * bLogicLen es un codeblock que se puede asignar, pero al evaluarse, por defecto 
 * devuelve lo que devuelva OrdKeyCount().
 * Tanto OrdKeyCount() como LastRec() como RecCount() devuelven el numero total
 * de registros físicos de una DBF, CONTANDO con los registros borrados. 
 * No les afecta SET DELETED ni SET FILTER, siempre devuelven el total.
 * La solución pasa por crear los indices con la clausula FOR !deleted() y utilizar
 * como viene por defecto, bLogiclen == OrdKeyCount() que ahora SI tiene en cuenta
 * los registros borrados.
 **/
 
#include "gclass.ch"
#include "set.ch"
    
function main()

  Local oWnd, oBox, oToolBar, oToolButton, oBrw, oLabel, oToolBtnHide, oStatus
  Local oBox2, oLabel_bo,oFont, oFrame, oNotebook
  Local oBox1, oEntry, cBusca := ""

  static lDeleted := .t.
  
  USE ../../CUSTOMER.DBF NEW SHARED ALIAS "CUSTUM"
  INDEX ON Field->First TO "Name"   FOR !deleted()
  INDEX ON Field->Last  TO "Apel"   FOR !deleted()
  INDEX ON Field->First TO "NOT_DEL" 

  SET INDEX TO Name, Apel, NOT_DEL

  dbsetorder(1)

  DEFINE WINDOW oWnd TITLE "ABM of T-Gtk" SIZE 600,300
        DEFINE BOX oBox VERTICAL OF oWnd

           DEFINE STATUSBAR oStatus TEXT "(c)2005 Rafa Carmona" INSERT_END OF oBox
           
           DEFINE TOOLBAR oToolBar OF oBox
              
               DEFINE TOOLBUTTON oToolButton  ;
                                 TEXT UTF_8( "Añadir cliente" );
                                 STOCK_ID GTK_STOCK_ADD ;
                                 ACTION ( Edit_Cliente( .T. ) ) ;
                                 OF oToolBar
               
               DEFINE TOOLBUTTON oToolButton  ;
                                 TEXT UTF_8( "Editar cliente" );
                                 STOCK_ID GTK_STOCK_APPLY ;
                                 ACTION ( Edit_Cliente( ) ) ;
                                 OF oToolBar
               
               DEFINE TOOLBUTTON oToolButton  ;
                                 TEXT "Borrar cliente";
                                 STOCK_ID GTK_STOCK_DELETE ;
                                 ACTION KeyBrowse( oBrw, GDK_Delete );
                                 OF oToolBar
               
               DEFINE TOOL SEPARATOR EXPAND OF oToolBar

               DEFINE TOOLBUTTON oToolBtnHide  ;
                                 TEXT "Ver Registros BORRADOS";
                                 STOCK_ID GTK_STOCK_REFRESH ;
                                 ACTION ( lDeleted := !lDeleted,;
                                          if( lDeleted, ( oToolBtnHide:SetLabel( "Ver Registros BORRADOS" ),;
                                                          oNoteBook:SetCurrentPage( 1 ),;
                                                          ( "CUSTUM" )->( OrdSetFocus( 1 ) ), oBrw:GoTop() ),;
                                                        ( oToolBtnHide:SetLabel( "Ocultar Registros BORRADOS" ), ;
                                                          oNoteBook:SetCurrentPage( 3 ),;
                                                         ( "CUSTUM" )->( OrdSetFocus( 3 ) ), oBrw:GoTop() ) ),;
                                           oBrw:GoTop(), oBrw:UpStable() ) ;
                                 OF oToolBar
               		         
               DEFINE TOOLBUTTON oToolButton  ;
                                 STOCK_ID GTK_STOCK_QUIT ;
                                 ACTION oWnd:End();
                                 OF oToolBar
           
             DEFINE BOX oBox1 OF oBox
                  DEFINE ENTRY oEntry VAR cBusca OF oBox1 EXPAND FILL
                  DEFINE BUTTON PROMPT "Seek LAST" OF oBox1 ;
                          ACTION (  ("custum")->( DbSeek( cBusca ) ), oBrw:UpStable(), oBrw:SetFocus() )
             
               DEFINE BROWSE oBrw ;
                    FIELDS Field->First, Field->Last ;
                    HEADERS "Name","Apellido" ;
                    ALIAS "CUSTUM" ;
                    COLSIZES 150,100 ;
                    FONT "Tahoma 10" ;
                    ON CHANGE ( oLabel_Bo:SetText( if( ( "CUSTUM" )->( Deleted() ),"REGISTRO BORRADO", "" ) ),;
                                oLabel:SetText( "Registro actual:" + cValToChar( Recno() ) ) );
                    OF oBox EXPAND FILL  

                    ADD COLUMN TO BROWSE oBrw ;
                        DATA Field->Set ;
                        HEADER "SET" ;
                        TYPE COL_TYPE_RADIO ;
                        SIZE 50
           
                    ADD COLUMN TO BROWSE oBrw ;
                        DATA Field->Street;
                        HEADER "Street" ;
                        SIZE 150
           
              /* Cuando presionemos INTRO, editamos cliente */
              oBrw:bKeyEvent := {|o,nkey| KeyBrowse( o, nKey ) }
             
              DEFINE NOTEBOOK oNoteBook OF oBox ;
                     POSITION GTK_POS_BOTTOM;
                     ON CHANGE ( ( "CUSTUM" )->( OrdSetFocus( oNoteBook:nPageCurrent ),;
                                  oBrw:GoTop(), oBrw:Refresh() ) )

                     DEFINE FRAME OF oNoteBook LABELNOTEBOOK " Nombre "
                     *   DEFINE LABEL TEXT "Ordenacion por nombre " OF oFrame CONTAINER
                     DEFINE FRAME OF oNoteBook LABELNOTEBOOK " Apellidos "
                     *   DEFINE LABEL TEXT "Ordenacion por apellidos " OF oFrame CONTAINER
                     DEFINE FRAME OF oNoteBook LABELNOTEBOOK " Nombre + Borrados "
                     *   DEFINE LABEL TEXT "Ordenacion por Ciudad. Este es especial " OF oFrame CONTAINER
              
              DEFINE FONT oFont NAME "Arial italic 14"
              
              DEFINE BOX oBox2 OF oBox  HOMO
                   
                   DEFINE LABEL oLabel_Bo PROMPT "" ;
                          OF oBox2 ;
                          FONT oFont

                   DEFINE LABEL oLabel PROMPT "Registro actual:" + cValToChar( Recno() ) ;
                          OF oBox2


   ACTIVATE WINDOW oWnd CENTER 
   

return nil

static function edit_cliente( lNew ) 
   Local oWnd, oTable, oBox, oBox2
   Local aValues := Array( 4 )
   Local cTitle
   
   Default lNew := .F.

   if lNew
     aValues[1] := SPACE( 10 )
     aValues[2] := SPACE( 20 )
     aValues[3] := .F.
     aValues[4] := SPACE( 20 ) 
   else
     aValues[1] := ( "CUSTUM" )->First 
     aValues[2] := ( "CUSTUM" )->Last 
     aValues[3] := ( "CUSTUM" )->Set 
     aValues[4] := ( "CUSTUM" )->Street
   endif
 
   // Si lo bloqueo, entonce puedo modificar
   if ( "CUSTUM" )->( RLock() )
      if lNew
        ( "CUSTUM" )->( DbAppend() )
        cTitle := "Nuevo cliente...:"
      else
        cTitle := "Editando cliente...:" + ( "CUSTUM" )->First
      endif

       DEFINE WINDOW oWnd TITLE cTitle SIZE 300,300
         DEFINE BOX oBox OF oWnd VERTICAL
          
          // Vamos a usar una tabla ;-)
          DEFINE TABLE oTable ROWS 4 COLS 2 OF oBox
             DEFINE LABEL PROMPT "Nombre"   OF oTable TABLEATTACH 0,1,0,1 HALIGN LEFT
             DEFINE LABEL PROMPT "Apellido" OF oTable TABLEATTACH 0,1,1,2 HALIGN LEFT
             DEFINE LABEL PROMPT "SET"      OF oTable TABLEATTACH 0,1,2,3 HALIGN LEFT
             DEFINE LABEL PROMPT "Calle"    OF oTable TABLEATTACH 0,1,3,4 HALIGN LEFT
             DEFINE ENTRY VAR aValues[1] ;
                          COMPLETION { "Raul", "Juan", "Sara", "Sarah", "Salvador" } ;
                          OF oTable TABLEATTACH 1,2,0,1
             DEFINE ENTRY VAR aValues[2]    OF oTable TABLEATTACH 1,2,1,2
             DEFINE CHECKBOX TEXT "Set" VAR aValues[3] OF oTable  TABLEATTACH 1,2,2,3
             DEFINE ENTRY VAR aValues[4]    OF oTable  TABLEATTACH 1,2,3,4
           
          DEFINE BOX oBox2 OF oBox HOMO
               DEFINE BUTTON PROMPT "Save" ACTION ( ( "CUSTUM" )->First  := aValues[1],;
                                                    ( "CUSTUM" )->Last   := aValues[2],;
                                                    ( "CUSTUM" )->Set    := aValues[3],;
                                                    ( "CUSTUM" )->Street := aValues[4],;
                                                    oWnd:End() ) OF oBox2 EXPAND FILL
               DEFINE BUTTON FROM STOCK GTK_STOCK_QUIT  ACTION oWnd:End() OF oBox2 EXPAND FILL
        
        ACTIVATE WINDOW oWnd MODAL CENTER;
               VALID ( ( "CUSTUM" )->( DBUnLock() ),.T. ) // Usamos la clausula VALID para desbloquear el registo ;-)
  endif

Return NIL

static function borra_cliente() 

  if MsgNoYes( UTF_8( "¿ Esta seguro de borrar el cliente ?" +CRLF+ Field->First ), "Atencion" )
     if ( "CUSTUM" )->( RLock() )
        ( "CUSTUM" )->( DbDelete() )
        ( "CUSTUM" )->( DBUnLock() )
     endif
  endif

Return NIL

STATIC FUNCTION KEYBROWSE( oBrw, nKey )
    
    DO CASE
       CASE nKey == GDK_Return
            Edit_Cliente( )
            oBrw:UpStable()       
       CASE nKey == GDK_Delete
            borra_cliente()
            oBrw:UpStable()
    ENDCASE

RETURN NIL
            
