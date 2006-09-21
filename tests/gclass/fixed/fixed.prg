/*
 * $Id: fixed.prg,v 1.1 2006-09-21 09:46:26 xthefull Exp $
 * Ejemplo de Fixed a traves de POO, Progressbar, radios, frame, calendar...
 * Al principio era muy simple, ahora parace ser que se complico ;-)
 * Porting Harbour to GTK+ power !
 * (C) 2004-05. Rafa Carmona -TheFull-
*/

#include "gclass.ch"

Function Main()
         Local oWindow, oFixed, oBtn1, oBtn2, oBtn3, oLabel,;
               oFont, oBtn, oImage, oToggle, oNote, oBox, ofont2, oLabelFic
         Local cVar := 0
         Local cVar2 := Space(10)
         Local cVar3 := UTF_8("Desde posici�n fija ESPA�A y BAR�A...")
         Local Arrow
         Local cVarCombo := "Hola"
         Local aItems := { "uno","dos","tres","Hola" }
         Local nValue := 50
         Local nValue2 := 50
         Local oRadio1, oRadio2, oProgra, oFrame, oEntry, oScale
         Local oSpin, nNumero := 8, nScale_Var := 35, nScale_Var2 := 5
         Local lCheck := .T., oCalendar, oArrow, oProgra2, oCombo, oEntry2

         SET DATE ITALIAN

         DEFINE FONT oFont NAME "Tahoma 18"
         DEFINE FONT oFont2 NAME "Tahoma bold 12"

         DEFINE WINDOW oWindow TITLE "T-GTK Fixed Example POO"

                DEFINE FIXED oFixed OF oWindow

                DEFINE ENTRY oEntry2 VAR cVar3 OF oFixed POS 200,30 ;
                        VALID Devuelve_Valor() 
                  //oEntry2:bValid := {|o| if( cVar3 = "PEPE", .T.,.F.) }

                DEFINE LABEL TEXT "Esto es un label en Fixed" OF oFixed

                DEFINE PROGRESSBAR oProgra ;
                       VAR nValue ;
                       TOTAL 100;
                       TEXT "Progress Bar my style." ;
                       OF oFixed POS 300,100
                       
                       oProgra:Style( "blue" , BGCOLOR , STATE_NORMAL)   // Cuando esta normal, fondo azul
                       oProgra:Style( "green" , FGCOLOR , STATE_NORMAL )  // Cuando esta normal, letras verdes
                       oProgra:Style( "yellow", BGCOLOR  , STATE_PRELIGHT )
                       oProgra:Style( "red"   , FGCOLOR  , STATE_PRELIGHT )

                DEFINE PROGRESSBAR oProgra2 ;
                       VAR nValue2 ;
                       TOTAL 100;
                       TEXT "Progress Bar Native" ;
                       OF oFixed POS 300,150

                DEFINE RADIO oRadio1 TEXT "Radio 1" OF oFixed ;
                       POS 400,1

                DEFINE RADIO oRadio2 GROUP oRadio1 MNEMONIC;
                       TEXT "_Rafa 2" of ofixed pos 400,20 FONT oFont ;
                       CURSOR GDK_SPIDER ACTIVED

                DEFINE TOGGLE oToggle TEXT "My Togglebutton" OF oFixed POS 1,130 ;
                       CURSOR GDK_MAN SIZE 150,25

                DEFINE LABEL oLabel TEXT "OJO :-)";
                       POS  300,200 OF oFixed ;
                       FONT oFont

                DEFINE COMBOBOX oCombo VAR cVarCombo ;
                       ITEMS aItems ;
                       OF oFixed ;
                       POS 200,100 ;
                       FONT oFont2

                DEFINE BUTTON oBtn1 TEXT "1 boton" ;
                       ACTION ( oProgra:Inc(), oProgra2:Inc(10) )  ;
                       OF oFixed POS 50,50 ;
                       CURSOR GDK_X_CURSOR

                DEFINE BUTTON oBtn2 TEXT "2 boton" ;
                       ACTION ( oProgra:Dec( ) , oProgra2:Dec(10) );
                       OF oFixed ;
                       POS 100,100

                DEFINE BUTTON oBtn3 TEXT "Valor SCALE " ;
                       ACTION ( MsgInfo( cVar3 ,"ENTRY"  ),MsgInfo( cValtoChar( nNumero ) ,"SPIN"  ),;
                             MsgInfo( cValtoChar( nScale_Var2 ),"SCALE"), oSpin:bWhen := {|| .T. } );
                       OF oFixed ;
                       POS 150,150

                DEFINE CHECKBOX oBtn VAR lCheck TEXT "Check por ahi" ;
                       OF oFixed POS 30,30

                //DEFINE ENTRY VAR cVar3 OF oFixed POS 200,30

                DEFINE NOTEBOOK oNote  OF oFixed POS 5,200

                DEFINE FRAME oFrame TEXT "Una Aleta"  ;
                       SHADOW GTK_SHADOW_OUT ;
                       LABELNOTEBOOK "Texto 1" ;
                       OF oNote ;
                       SIZE 150,150

                       DEFINE BOX oBox OF oFrame CONTAINER HOMO VERTICAL

                         DEFINE BUTTON oBtn TEXT "Selec Font" ;
                                OF oBox ACTION Busca_Font()

                         DEFINE BUTTON oBtn TEXT "Fichero" ;
                                OF oBox ACTION oLabelFic:SetText( Busca_File( oLabelFic ) )

                         DEFINE LABEL oLabelFic TEXT "Nombre del Fichero" OF oBox

                         DEFINE CHECKBOX oBtn VAR lCheck TEXT "Uy! Que check" ;
                                OF oBox EXPAND


                          DEFINE SPIN oSpin VAR nNumero ;
                                 DECIMALS 2;
                                 OF oBox CONTAINER

                                 oSpin:bWhen := {|| .F. }

                         DEFINE CHECKBOX oBtn VAR lCheck TEXT "2 check" ;
                                OF oBox CONTAINER
					 
                           DEFINE LABEL oLabel TEXT "<b>Tab2 Expand</b>" MARKUP
                           DEFINE BOX oBox OF oNote HOMO ;
                                  LABELNOTEBOOK oLabel ;

*                                  DEFINE Label oLabel ;
*                                         TEXT "Esto es en NOTEBOOK, LABEL!!"  ;
*                                         OF oBox
                                   DEFINE ENTRY oEntry VAR cVar OF oBox FONT oFont2 ;
                                          PICTURE "999.999"

                           DEFINE ARROW oArrow ;
                                  ORIENTATION GTK_ARROW_RIGHT ;
                                  SHADOW GTK_SHADOW_NONE ;
                                  SIZE 200,200 ;
                                  OF oBox

                           DEFINE BOX oBox VERTICAL OF oNote  ;
                                  LABELNOTEBOOK "Este" ;

                                  DEFINE ENTRY VAR cVar2 PICTURE "@!" ;
                                         OF oBox LABELNOTEBOOK  "AlA"

                             DEFINE SCALE oScale VAR nScale_Var OF oBox
                             DEFINE SCALE oScale VAR nScale_Var2 ;
                                    MIN 1 ;
                                    MAX 30;
                                    STEP 0.1;
                                    DECIMALS 1;
                                    OF oBox VERTICAL CONTAINER
                               // Cambiamos de posicion la etiqueta ;-)
                               oScale:SetPos( GTK_POS_LEFT )

                           DEFINE CALENDAR oCalendar ;
                                   DATE CTOD("01/10/2001");
                                   MARKDAY ;
                                   ON_DCLICK MsgBox( "Fecha seleccionada:"+DTOC( o:GetDate()), GTK_MSGBOX_OK, GTK_MSGBOX_INFO ) ;
                                   OF oNote LABELNOTEBOOK "Calendario"
                                   *STYLE nOr( GTK_CALENDAR_NO_MONTH_CHANGE,;
*                                              GTK_CALENDAR_SHOW_WEEK_NUMBERS,;
                                    *          GTK_CALENDAR_SHOW_HEADING ) ;

         ACTIVATE WINDOW oWindow

RETURN NIL

STATIC FUNCTION MoveBtn( oBtn, oFixed )
       Static x := 50 , y:= 50

       x = (x+30)%300
       y = (y+50)%300

       oFixed:Move( oBtn, x, y )

return nil

Static Func Busca_File( oLabel )
       Local cFile := ChooseFile( "Este titulo ", oLabel:GetText() )

Return cFile

Static Func Busca_Font( )
       Local cFont:= ChooseFont( "Este titulo sera el de la font ", "arial 24",;
                                 "Text from T-Gtk ;-)" )
       MsgInfo( cFont,"Font seleccionada..")

Return nil

Static Func Devuelve_Valor()
   Local oDlg 

   DEFINE DIALOG oDlg TITLE "Que valor queremos devolver" SIZE 200,200
   ACTIVATE DIALOG oDlg RUN CENTER ;
            ON_YES .T. ;
            ON_NO .T.

   Do case 
      Case oDlg:nId == GTK_RESPONSE_YES        
           Return .T.
      Case oDlg:nID == GTK_RESPONSE_NO     
           Return .F.
   End Case

Return .F.
