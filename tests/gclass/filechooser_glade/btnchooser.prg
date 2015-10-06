/*
 * $Id: btnchooser.prg,v 1.1 2015-10-05 23:24:10 riztan Exp $
 * Porting Harbour to GTK+ power !
 * (C) 2015. Rafa Carmona -TheFull-
 * (C) 2015. Riztan Gutierrez
*/

#include "gclass.ch"

Function Main()
   Local oWindow, oFChooser, oBox, oContinuar, oCancelar
   local oRes

   if !file( "filechooser.ui" )
      ? "no encuentra el fichero de recurso"
      return nil
   endif

   SetGtkBuilder( .t. )

   SET RESOURCES oRes FROM FILE "filechooser.ui"      

   DEFINE WINDOW oWindow TITLE "T-Gtk. gFileChooserWidget Test." ;
          SIZE 500,300;
          ID "window1" RESOURCE oRes

   DEFINE BOX oBox VERTICAL OF oWindow

   DEFINE FILECHOOSERWIDGET oFChooser;
          ID "filechooserwidget1" RESOURCE oRes 
/*
   DEFINE FILECHOOSERWIDGET oBtn ;
          MODE GTK_FILE_CHOOSER_ACTION_OPEN ;
          OF oBox 
*/
   oFChooser:SetMultiple( .t. )
   oFChooser:SetFilter("*.prg")


   DEFINE BUTTON oContinuar ; //TEXT "Abrir" ;
          ACTION MsgInfo( valToPrg( gtk_file_chooser_get_uris( oFChooser:pWidget ) )) ; 
          ID "button1" RESOURCE oRes


   DEFINE BUTTON oCancelar ; //TEXT "Cancelar" ;
          ACTION oWindow:End() ;
          ID "button2" RESOURCE oRes

//SysRefresh()

   ACTIVATE WINDOW oWindow
return .t.



