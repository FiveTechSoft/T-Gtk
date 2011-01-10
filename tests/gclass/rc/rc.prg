#include "gclass.ch"

STATIC  s_cPathThemes, oWnd 

FUNCTION Main()
   Local aThemes := {}, aDirectorys, oBox, oNote, oBox1,oBox2, oSay
   Local nSiguiente := 1, oCombo, cValueCombo
  
   
   
   aThemes = FillThemes()
   
   if Len( aThemes ) == 0
      MsgStop( "NO hay temas instalados" )
      return nil
   endif
   
   Aplica_themes( aThemes[1] )  
   
   DEFINE WINDOW oWnd TITLE "Theme:" + aThemes[1] SIZE 300,100
          
          DEFINE BOX oBox OF oWnd
                cValueCombo := aThemes[1]
                DEFINE COMBOBOX oCombo VAR cValueCombo ;
                       ITEMS aThemes ;
                       ON CHANGE ( Aplica_themes( oCombo:GetValue() ), oSay:SetValue( oCombo:GetValue() ) )  OF oBox 
                
           /*DEFINE BUTTON PROMPT "Cambiar" OF oBox ACTION ( if( nSiguiente > Len( aThemes ), nSiguiente := 1 ,nSiguiente++ ),;
                                                          Aplica_themes( aThemes[nSiguiente] ) ) 
           */
           DEFINE NOTEBOOK oNote OF oBox
                  DEFINE BOX oBox1 OF oNote LABELNOTEBOOK "Folder 1" VERTICAL
                     DEFINE BUTTON PROMPT "Cambiar" OF oBox1  ACTION MsgInfo( oCombo:GetValue() )
                     DEFINE LABEL oSay TEXT aThemes[1] OF oBox1

                  DEFINE BOX oBox2 OF oNote LABELNOTEBOOK "Folder 2" 

   ACTIVATE WINDOW oWnd

RETURN NIL

STATIC FUNCTION APLICA_THEMES( cTheme )
   Local cPathThemes := s_cPathThemes + cTheme  + "/gtk-2.0/gtkrc"
   Local setting
   
 
   CAMBIO_STYLE ()

   gtk_rc_parse( cPathThemes )

   SysRefresh()

   if oWnd != NIL
      oWnd:cTitle("Themes :" + cPathThemes )
   endif

RETURN NIL

function FillThemes()

   local cSubPath, aDirectorys := {}, aFull, cDir
   local aSubDir, aSubCon
   
   s_cPathThemes := gtk_rc_get_theme_dir() + "/"

   aFull := Directory( s_cPathThemes, "D" )
   for each cDir in aFull
      cSubPath = s_cPathThemes + cDir[ 1 ]
      if File( cSubPath + "/gtk-2.0/gtkrc" )
         AAdd( aDirectorys, cDir[ 1 ] )
      endif
   next
   
return aDirectorys
