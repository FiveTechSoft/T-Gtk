/*
 * $Id: assistant.prg,v 1.1 2007-03-02 21:17:11 xthefull Exp $
 * Ejemplo de GtkAssistant POO GTK 2.10
 * Porting Harbour to GTK+ power !
 * (C) 2007. Rafa Carmona -TheFull-
*/
#include "gclass.ch"

Function Main()
     Local oAssistant, oPage1, oPage2, oPage3, oBtn
     
     DEFINE ASSISTANT oAssistant ;
            ON CANCEL oAssistant:End() ;
            ON CLOSE  oAssistant:End() ;
            ON APPLY  ( oAssistant:bEnd := NIL,;          // Aqui no nos interesa que pregunte si queremos salir
                        MsgInfo( "Realized changes in your computer" ) ) ;
            SIZE 650,540
            
            // Please, view put simple button 
            DEFINE BUTTON oBtn FROM STOCK GTK_STOCK_HELP;
                  ACTION MsgInfo( "Help me, please , for page:"+ str( oAssistant:GetCurrentPage(),2 ) )
            oAssistant:AddWidget( oBtn )
            
            oPage1 := Create_Page1( oAssistant )
            oPage2 := Create_Page2( oAssistant )
            oPage3 := Create_Page3( oAssistant )

            APPEND ASSISTANT oAssistant ;
                   WIDGET oPage1 ;
                   COMPLETE ;
                   TYPE GTK_ASSISTANT_PAGE_INTRO  ;
                   TITLE "Wellcome a T-Gtk GUI" ; 
                   IMAGE HEADER "../../images/rafa2.jpg" ; 
                   IMAGE SIDE   "../../images/anieyes.gif"

            APPEND ASSISTANT oAssistant ;
                   WIDGET oPage2 ;
                   TITLE "License GPL" ;
                   IMAGE HEADER"../../images/gnu-keys.png"  
            
            APPEND ASSISTANT oAssistant ;
                   WIDGET oPage3 ;
                   TITLE "GMOORK, symbol of  T-Gtk.";
                   IMAGE SIDE   "../../images/gmoork.gif";
                   TYPE GTK_ASSISTANT_PAGE_CONFIRM ;
                   COMPLETE

     ACTIVATE ASSISTANT oAssistant ;
              CENTER ;
              VALID ( MsgBox( " Do you cancel assistant ?", GTK_MSGBOX_OK+GTK_MSGBOX_CANCEL,GTK_MSGBOX_INFO ) == GTK_MSGBOX_OK )
                                    
Return NIL

STATIC FUNCTION Create_Page1( oAssistant )
  Local oBox, oImage
  
  DEFINE BOX oBox VERTICAL HOMO
       DEFINE IMAGE FILE "../../images/logo.png" OF oBox
  oBox:SetBorder( 10 )
       
RETURN oBox

STATIC FUNCTION Create_Page2( oAssistant )
  Local oBox, oScroll, oTextView, oCheck
  Local cText := "",  nWhere := 1
  Local oRadio1, oRadio2, oBox2, oImage
  Local cTextExpand := '<span foreground="blue" size="large"><b>Are you ready ? Please, select option: </b></span>'
  Local oFile := gTextFile():New( "license.txt", "R" )
  Local aStart := Array( 14 )

  DEFINE BOX oBox VERTICAL
      DEFINE SCROLLEDWINDOW oScroll OF oBox CONTAINER
         DEFINE TEXTVIEW oTextView VAR cText OF oScroll CONTAINER READONLY
         
         DEFINE IMAGE oImage FILE "../../images/gnu-keys.png" LOAD
     
         // Eh!, you localicate you position with GetIterAtOffset
         oTextView:oBuffer:GetIterAtOffSet( aStart, -1 ) 
         
         oTextView:CreateTag( "center", { "justification", GTK_JUSTIFY_CENTER } )
         oTextView:Insert_Tag( " ", "center", aStart )
         oTextView:Insert_Pixbuf( aStart, oImage )
         oTextView:Insert( CRLF )
         
         oTextView:oBuffer:GetIterAtOffSet( aStart, -1 ) 
         oFile:Goto( 1 )
         while !oFile:lEoF 
               oTextView:Insert_Tag( oFile:Read(), "center", aStart )
               oFile:Goto( ++nWhere )
         end while
    
         oFile:Close()

         DEFINE LABEL TEXT cTextExpand MARKUP OF oBox 

         DEFINE BOX oBox2 OF oBox HOMO
            
            DEFINE RADIO oRadio1 MNEMONIC TEXT "_No, I don't agree." OF oBox2 ;
                   ACTION If( oRadio1:GetActive(), oAssistant:SetComplete( oBox, .F. ) , )

            DEFINE RADIO oRadio2 GROUP oRadio1 MNEMONIC;
                   TEXT "Yes, I _Agree." OF oBox2;
                   ACTION If( oRadio2:GetActive(), oAssistant:SetComplete( oBox, .T. ) , )

RETURN oBox

STATIC FUNCTION Create_Page3( oAssistant )
  Local oBox
  
  DEFINE BOX oBox VERTICAL  
       DEFINE LABEL TEXT "<b>GMOORK</b> is my dog, Alaska Malamute race." + CRLF+;
                         "I think is very cool for symbol of T-Gtk." MARKUP OF oBox 
       DEFINE IMAGE FILE "../../images/gmoork.gif" OF oBox EXPAND FILL

RETURN oBox
