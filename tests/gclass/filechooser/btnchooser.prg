/*
 * $Id: btnchooser.prg,v 1.1 2006-09-21 09:46:26 xthefull Exp $
 * Porting Harbour to GTK+ power !
 * (C) 2004-05. Rafa Carmona -TheFull-
*/

#include "gclass.ch"

Function Main()
   Local oWindow, oBtn, oBox, oBtn2, cFile
   local oRes

if !file( "filechooser.ui" )
 ? "no encuentra el archivo"
 return nil
endif

 SetGtkBuilder( .t. )

 SET RESOURCES oRes FROM FILE "filechooser.ui"      

   DEFINE WINDOW oWindow TITLE "T-Gtk. gFileChooserWidget Test." ;
          ID "window1" RESOURCE oRes

   DEFINE BOX oBox VERTICAL OF oWindow

   DEFINE FILECHOOSERWIDGET oBtn;
          ID "filechooserwidget1" RESOURCE oRes 

   DEFINE BUTTON oBtn2 TEXT "Abrir" ;
          ACTION MsgInfo( valToPrg( gtk_file_chooser_get_uris( oBtn:pWidget ) ));  //MsgInfo(oBtn:GetFileName());
          ID "button1" RESOURCE oRes

/*
   DEFINE FILECHOOSERWIDGET oBtn ;
          MODE GTK_FILE_CHOOSER_ACTION_OPEN ;
          OF oBox 
*/


   oBtn:SetMultiple( .t. )
   oBtn:SetFilter("*.prg")

//SysRefresh()

   ACTIVATE WINDOW oWindow
return .t.

function otro()
   Local oWindow, oBtn, oBox, oBtn2, cFile
//       DEFINE BOX oBox VERTICAL OF oWindow


 
         /* 
           DEFINE FILECHOOSERBUTTON oBtn ;
                 MODE GTK_FILE_CHOOSER_ACTION_SELECT_FOLDER ;
                  OF oBox
           
           oBtn:SetMultiple( .t. )
           ? oBtn:GetMultiple( .t. )

           if "WIN" $ UPPER( OS() )
              oBtn:SetFolder( "C:\" ) 
              cFile := CURDRIVE() + ":\" +CurDir()+"\btnchooser.prg"
           elseif "Linux" $ UPPER( OS() )
              oBtn:SetFolder( "/home" ) 
              cFile := CURDRIVE() + "/" +CurDir()+"/btnchooser.prg"
           endif
                   
           DEFINE FILECHOOSERBUTTON oBtn2 ;
                  TEXT "Fichero";
                  PATH_INIT cFile ;
                  MODE GTK_FILE_CHOOSER_ACTION_OPEN ;
                  OF oBox;
                  ON SELECT Msginfo( cFileName )

           oBtn2:SetAction( 5 )
           oBtn2:SetFilter("*.prg")
           oBtn2:SetMultiple( .F. )
           ?  oBtn2:GetMultiple()
           gtk_file_chooser_set_select_multiple( oBtn2:pWidget, .T. )
           ?  oBtn2:GetMultiple()
? gtk_widget_get_name( oBtn2:pWidget )

oBtn2:Set_Property("select-multiple", .t. )

           DEFINE BUTTON TEXT "Show paths" ;
                         ACTION MsgInfo( oBtn:GetFolder() + CRLF+;
                                         oBtn2:GetFileName() , "Info" ) ;
                         OF oBox 
//           SysRefresh() 
*/
   ACTIVATE WINDOW oWindow

Return NIL



