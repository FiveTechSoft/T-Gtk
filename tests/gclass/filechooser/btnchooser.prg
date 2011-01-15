/*
 * $Id: btnchooser.prg,v 1.1 2006-09-21 09:46:26 xthefull Exp $
 * Porting Harbour to GTK+ power !
 * (C) 2004-05. Rafa Carmona -TheFull-
*/

#include "gclass.ch"

Function Main()
   Local oWindow, oBtn, oBox, oBtn2, cFile

   DEFINE WINDOW oWindow TITLE "T-Gtk. gFileChooserButton Test." 
       DEFINE BOX oBox VERTICAL OF oWindow
          
           DEFINE FILECHOOSERBUTTON oBtn ;
                 MODE GTK_FILE_CHOOSER_ACTION_SELECT_FOLDER ;
                  OF oBox
           
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

           DEFINE BUTTON TEXT "Show paths" ;
                         ACTION MsgInfo( oBtn:GetFolder() + CRLF+;
                                         oBtn2:GetFileName() , "Info" ) ;
                         OF oBox 
           SysRefresh() 

   ACTIVATE WINDOW oWindow

Return NIL

