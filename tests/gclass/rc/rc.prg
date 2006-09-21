#include "gclass.ch"

STATIC  s_cPathThemes, oWnd 

FUNCTION Main()
   Local aThemes := {}, aDirectorys, oBox, oNote, oBox1,oBox2, oSay
   Local nSiguiente := 1, oCombo, cValueCombo
  
   s_cPathThemes := gtk_rc_get_theme_dir()

   aDirectorys := Directory( s_cPathThemes + "/*." , "D" )
   aEval( aDirectorys, {|aFile,x| if( x > 2,  AADD( aThemes, aFile[1] ), )  } )
   
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
   Local cPathThemes := s_cPathThemes + "/" + cTheme  + "/gtk-2.0/gtkrc"
   Local setting
   
   // gtk_rc_parse( cPathThemes )
   CAMBIO_STYLE ()

   *setting := gtk_settings_get_default()
   *gtk_rc_reset_styles( setting )
   SysRefresh()

   if oWnd != NIL
      oWnd:cTitle("Themes :" + cPathThemes )
   endif

RETURN NIL
