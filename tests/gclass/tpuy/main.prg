/* $Id: main.prg,v 1.0 2008/10/23 14:44:02 riztan Exp $*/
/*
	Copyright © 2008  Riztan Gutierrez <riztang@gmail.com>

   Este programa es software libre: usted puede redistribuirlo y/o modificarlo 
   conforme a los términos de la Licencia Pública General de GNU publicada por
   la Fundación para el Software Libre, ya sea la versión 3 de esta Licencia o 
   (a su elección) cualquier versión posterior.

   Este programa se distribuye con el deseo de que le resulte útil, pero 
   SIN GARANTÍAS DE NINGÚN TIPO; ni siquiera con las garantías implícitas de
   COMERCIABILIDAD o APTITUD PARA UN PROPÓSITO DETERMINADO. Para más información, 
   consulte la Licencia Pública General de GNU.

   http://www.gnu.org/licenses/
*/

/** \file main.prg.
 *  \brief Programa Inicial  
 *  \author Riztan Gutierrez. riztan@gmail.com
 *  \date 2008
 *  \remark Donde comienza la historia...
*/

/** \mainpage Archivo Principal (index.html)
 *
 * \section intro_sec Introduccion
 *
 * Esta es la introducción.
 *
 * \section install_sec Instalacion
 *
 * \subsection step1 Paso 1: Inicializando Variables
 *
 * etc...
 */

#include "proandsys.ch"
#include "gclass.ch"
#include "tgtkext.ch"
#include "tpy_extern.ch"
//#include "libgdaext.ch"
#include "tip.ch"

// #include "hbstruct.ch"
// #include "hblang.ch"


// GLOBAL oTpuy  /** \var GLOBAL oTpuy. Objeto Principal oTpuy. */

memvar oTpuy

// memvar oMsgRun_oLabel, oMsgRun_oImage

REQUEST HB_LANG_ES
//REQUEST FIS_StrXOR
//REQUEST FIS_ErrStr
//REQUEST FIS_SendCmd
//REQUEST HexToStr
//REQUEST StrToHex
//REQUEST StruToGType
//REQUEST Run2Me
//REQUEST CSV2Array
//REQUEST ValidMail
//REQUEST TPYENTRY
REQUEST DISPBOX
REQUEST __BOX
REQUEST __BOXD
REQUEST __BOXS
REQUEST DEVOUTPICT

REQUEST TDolphinSrv
REQUEST hb_Crypt
REQUEST hb_DeCrypt

REQUEST hb_DATETIME
REQUEST hb_HOUR
REQUEST hb_MINUTE
REQUEST hb_TTON
REQUEST hb_NTOT
REQUEST hb_TTOS
REQUEST hb_STOT
REQUEST hb_TTOC
REQUEST hb_CTOT
REQUEST hb_TSTOSTR
REQUEST hb_STRTOTS

REQUEST GTREESTORE
REQUEST GFIXED

REQUEST Directory

#ifdef __PLATFORM__WINDOWS
   REQUEST HB_GT_WVT_DEFAULT

   REQUEST WIN_OLECREATEOBJECT
   REQUEST WIN_OLEERRORTEXT

   #define THREAD_GT "WVT"

#else
   REQUEST HB_GT_STD_DEFAULT
   #define THREAD_GT "XWC"

#endif


//NETIO
REQUEST NETIO_CONNECT
REQUEST NETIO_FUNCEXEC
REQUEST NETIO_PROCEXISTS
REQUEST NETIO_DISCONNECT

/** \brief Inicio. Donde comienza todo.
 */
Function Main( uPar1, uPar2, uPar3, uPar4)
//Function Main(  )

   Local cVersion:="0.1 (Alfa)"
   Local cSystem_Name:=TPUY_NAME+" v"+cVersion

   Local nValor := ROUND(SECONDS()+50,0)

   Default uPar1 := "", uPar2 := "", uPar3 := "", uPar4 := ""

//   pGt := hb_gtCreate("WVT")
//? VALTYPE(pGt)
//   hb_gtSelect(pGt)

   // Public oMsgRun_oLabel, oMsgRun_oImage
   Public oApp,oTpuy

   CLOS ALL
   SET DELE ON
   SET WRAP ON
   SET SCOR OFF
   SET BELL OFF
   SET SOFT ON
   SET EXCL OFF
   SET DECI TO 2
   SET DATE FORMAT TO TPY_DATEFORMAT
   SET CENTURY ON
   SET EPOCH TO ( YEAR( DATE() ) - 50 )
   SET Delete On

#ifdef __HARBOUR__
   SET( _SET_HBOUTLOG, "error_.log" ) 
#endif

   HB_LANGSELECT("ES")

//   SET CENTURY ON
//   SET DATE ITALIAN
//   SET EXACT ON   // No se porque... pero esto falla con los script.
//   SET DECIMALS TO 2
   SET CONFIRM ON

   oTpuy := Tapp():New()

   oTpuy:cVersion    :=cVersion
   oTpuy:cSystem_Name:=cSystem_Name
   oTpuy:lSalir := .F.
//   oTpuy:l_gnome_db_init := .F.

   /*
     Definicion de Timer General
     Desconozco por los momentos el porque si activo una ventana antes que el
     timer... Este luego no funciona.
   */
   DEFINE TIMER oTpuy:oTimer;
          INTERVAL 100;
   	    ACTION nValor := TestTimer(nValor);

   ACTIVATE TIMER oTpuy:oTimer

/*
 * Lo primero es intentar conectar a la base de datos para tomar 
 * las configuraciones iniciales 
 * 
*/

   oTpuy:aTabs_Main := { TP_TABLE_MAIN, TP_TABLE_ENTITY }
   oTpuy:cMainSchema:= Alltrim(TPUY_SCHEMA)+"."
   oTpuy:cImages    := "./images/"
   oTpuy:cResources := "./resources/"
   oTpuy:cTablas    := "./tables/"
   oTpuy:cIncludes  := "./include/"
   oTpuy:cXBScripts := "./xbscripts/"
   oTpuy:cSQLScr    := "./sql/"
   oTpuy:cDocs      := "./doc/"
   oTpuy:cTempDir   := GetEnv("HOMEPATH")+"/.tpuy_tmp/"

   oTpuy:cTemps     := oTpuy:cTempDir
   If !File(oTpuy:cTempDir)
      DirMake(oTpuy:cTempDir)
   Endif


   oTpuy:cResource  := ""
   oTpuy:cIconMain  := oTpuy:cImages+"logo_proandsys_64x64.png"
   oTpuy:cRsrcMain  := oTpuy:cResources+"proandsys.glade"

   oTpuy:cPassword  := "Sarisariñama"
   
   //-- Modo Debug
   oTpuy:lDebug     := .T.  // Activa o Desactiva en View()

   RUNXBS( "init.conf" )

//netio_main()
//return

   IF !Empty( uPar1 )
      IF ("SAVE" IN UPPER( uPar2 ) )
         SaveScript(uPar1, MEMOREAD(uPar1) ,;
                           IIF( UPPER(uPar2)="SAVEEXEC",.T.,.F. ) )
         oTpuy:Release()
         CLEAR SCREEN
         Quit
      ENDIF
      oTpuy:RunXBS(uPar1,uPar2,uPar3,uPar4)
      oTpuy:Release()
      Quit

   ENDIF
   
   oTpuy:aConnection:= {}
   oTpuy:oConnections:= TPublic():New()

   // No se porque, pero si se define el recurso antes de 
   // activar el timer, el timer no funciona
   // SET RESOURCES oTpuy:cResource FROM FILE oTpuy:cRsrcMain 


//   MemoToXML() // Guardamos los valores de conexion.
   IF !( oTpuy:RunXBS('begin') )
      Salir( .T. )
   EndIf

Return NIL



/** \brief Realiza la Salida del Sistema
 */
Function Salida( lForce )

   DEFAULT lForce := .F.

   oTpuy:Exit( lForce )
   
Return .F.



/** \brief Realiza la Salida del Sistema
 */
Function Salir( lForce )

   Default lForce := .F.
   
   If Salida( lForce )

//      TRY
//         PQClose(oTpuy:conn)
//      CATCH
//      END

      IF oTpuy:oWnd != NIL
         oTpuy:oWnd:End()
      ENDIF
      oTpuy:End()
      gtk_main_quit()
      Quit
      Return .F.

   EndIf

Return .T.



/** \brief Test para Timer. (Funcion Provisional)
 */
Function TestTimer(nValor)

   DEFAULT nValor := 0

   If HB_ISNIL(oTpuy:oWnd)
      Return ROUND(SECONDS()+10,0)
   EndIf

   If nValor <= ROUND(SECONDS(),0) .AND. !Empty( oTpuy:oWnd )

// --- Esto es una prueba del Timer.
//      MsgRun("MessageRun ", {||MsgInfo("pausa")} )
      oTpuy:oWnd:SetTitle( "Ejecutado Timer... "+CStr(Time()) )
    

      nValor := ROUND(SECONDS()+10,0)

   Endif

Return nValor


Function SaveScript( cFile, cText, lExec, p1,p2,p3,p4,p5,p6,p7,p8,p9,p10 )

   Local lRet
#ifndef __HARBOUR__
   Local oInterpreter, cFilePPO
   Local oFile, oRun, lRet

   Default cText := '' , lExec := .F.

   If RIGHT( lower(cFile) , 4 ) = '.xbs'

      cFilePPO := Left( cFile , LEN(cFile) - 4 ) + ".ppo"

      If File( cFilePPO  )

         If FErase( cFilePPO ) <> 0
            MsgStop( MSG_FILE_NO_DELETE , MSG_TITLE_ERROR )
            Return .F.
         EndIf

      EndIf

      oInterpreter := TInterpreter():New(cFile)

      oInterpreter:SetScript( cText, 1 , cFile )
      If !lExec
         oInterpreter:lExec:=.F.
      EndIf
      lRet := oInterpreter:Run( { p1,p2,p3,p4,p5,p6,p7,p8,p9,p10 } )

      cText := ''

      AEVAL( oInterpreter:acPPed , {|a|                                  ;
                                     IIf( a <> NIL .AND. Left(a,1)<>"#", ;
                                         cText += a + CRLF , NIL )       ;
                                   } )

      //Escribiendo el pre-procesado
      
      oFile := gTextFile():New( cFilePPO, "W" )

      oFile:WriteLn( cText )

      oFile:Close()

      MsgInfo( "Generado "+ALLTRIM( cFilePPO ) ) 
   Else

      MsgStop( MSG_FILE_NO_ADEQUATE , MSG_FILE_NO_SAVE)

   EndIf
#endif
Return lRet


//EOF


