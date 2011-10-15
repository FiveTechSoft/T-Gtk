/* $Id: tools01.prg,v 1.0 2008/10/23 14:44:02 riztan Exp $*/
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

#include "gclass.ch"
#include "proandsys.ch"

/** \file tools01.prg.
 *  \brief Detalle del contenido de \c "tools01.prg" 
 *  \author Riztan Gutierrez. riztan@gmail.com
 *  \date 2008
 *  \remark Comentarios sobre "tools01.prg"
*/

/*
  Ejemplo de Uso de MsgRun()
   oRun:=MsgRunStart(MESSAGE_CONNECTING)

         MsgInfo("Alo?")

         oMsgRun_oLabel:SetMarkup(Space(5)+"<b>sii</b>iiiiiiii")
         oMsgRun_oImage:SetFile("../../images/flacoygordo.gif")

         MsgYesNO("fino?")

   MsgRunStop(oRun)

*/

// GLOBAL EXTERNAL oTpuy /** \var GLOBAL oTpuy. Objeto Principal oTpuy. */
memvar oTpuy

memvar oMsgRun_oLabel /** \var oMsgRun_oLabel */
memvar oMsgRun_oImage /** \var oMsgRun_oImage */


/** \brief Presenta Mensaje mientras se ejecuta el bloque de codigo.
 *  \par cMensaje, variable tipo caracter.
 *  \par bAction, variable tipo Bloque de Codigo.
 *  \par cImagen,   Imagen a Mostrar.
 *  \par nWidth,    Ancho en pixel del dialogo.
 *  \par nHeight,   Altura en pixel del dialogo.
 *  \par MSGRUN_TYPE, tipo de MSGRUN_TYPE (mensaje a desplegar).
 *  \pre previos...
 *  \ret Verdadero
 */
FUNCTION MsgRun(cMensaje,bAction)

   Local oRun 

   oRun := MsgRunStart(cMensaje,bAction)
   oRun:End()   

Return .T.


/** 
 *  \brief Presenta Mensaje mientras se ejecuta el bloque de codigo.
 *  \par cMensaje, variable tipo caracter.
 *  \par bAction, variable tipo Bloque de Codigo.
 *  \par cImagen
 *  \par nWidth
 *  \par nHeight
 *  \par MSGRUN_TYPE
 */
Function MsgRunStart(cMensaje,bAction,cImagen,nWidth,nHeight/*,MSGRUN_TYPE*/)

   Local oMsgRun, pixbuf, oDraw

   Public oMsgRun_oLabel, oMsgRun_oImage

   Default cMensaje:="", bAction:={|| .T. }, nWidth:=300, nHeight:=100

   Default cImagen:=oTpuy:cImages+"loading_16.gif"
   
   IIF(ValType(cMensaje)!="C", cMensaje:=CStr(cMensaje), NIL)

   IF ValType(bAction)!="B"
      MsgAlert("La Acción no es un bloque de código","MsgRun")
   ENDIF
   
   pixbuf := gdk_pixbuf_new_from_file( oTpuy:cImages+"tepuyes.png" )


   oMsgRun := GDialog():New(,nWidth,nHeight,,,,, )
//   oBox    := GBoxVH():New( .F.,, .F., oMsgRun, .F., .F.,, .T.,,,, .F., .F., .F.,,,,,,,, )

      DEFINE DRAWINGAREA oDraw ;
             EXPOSE EVENT  MsgRunDraw( oSender, pEvent, pixbuf, cMensaje );
             OF oMsgRun CONTAINER

/*
   oMsgRun_oImage :=GImage():New(cImagen,oBox,.F.,.F.,,.F.;
                 ,,,,,,,, .F., .F., .F., .F.,,,,,,,,,,, .F. )

   oMsgRun_oLabel :=GLabel():New(Space(5)+cMensaje,;
                         .T.,oBox,,.F.,.F.,,.F.,,,,,,.F.,.F.,.F.,.F.,,,,,,,,, 0 )
*/
//   oMsgRun:SetSkipTaskBar( .T. )
   oMsgRun:SetDecorated(.F.)
//   oMsgRun:Separator(.F.)

   oMsgRun:Activate(,,,,,, ,, .T., .F. , .F., .F., .F. )

   oMsgRun:Refresh()
   SysRefresh()
   SecondsSleep(.1)
   Eval(bAction)
   
Return oMsgRun




/** 
 *  \brief Muestra Imagen y Mensaje en Ventana MsgRun.
 *  \par oSender
 *  \par event
 *  \par pixbuf
 *  \par cMsg
 */
STATIC FUNCTION MsgRunDraw( oSender, event,  pixbuf, cMsg )
 Local gc
 Local pango
 Local color := { 0, 0XF, 25500, 34534 }
 Local widget

 Local cTextMark := '<span foreground="blue" size="large"><b>Esto es <span foreground="yellow"'+;
                ' size="xx-large" background="black" ><i>fabuloso</i></span></b>!!!!</span>'+;
                HB_OSNEWLINE()+;
                '<span foreground="red" size="23000"><b><i>T-Gtk power!!</i></b> </span>' +;
                HB_OSNEWLINE()+;
                'Usando un lenguaje de <b>marcas</b> para mostrar textos'

  widget := oSender:pWidget

  gc = gdk_gc_new( widget  )   // cambio propiedades del contexto gráfico gc

  gdk_draw_pixbuf( widget, gc, pixbuf, 0, 0, 0, 0 )

  If !Empty( cMsg )
  
     cMsg := '<span  size="11000"><b><i>'+cMsg
     cMsg += '</i></b> </span>'
     
     pango :=  gtk_widget_create_pango_layout( widget )
     pango_layout_set_markup( pango, cMsg )
     gdk_draw_layout( widget, gc, 10, 15, pango )
     
  EndIf
  
  g_object_unref( gc )


Return .T.




/*
  Para Detener MsgRun
*/
/** \brief Detiene el "msgrun".
 *  \par oMsgRun.  Indica el objeto msgrun que será destruido.
 */
Function MsgRunStop(oMsgRun)
Return IIF( oMsgRun!=NIL , oMsgRun:End(), NIL)




/*
  Grabar archivo .ini
*/
/** \brief Lectura de Archivo .ini
 */
Function LoadIni()

   Local hFile 

   If !File( oTpuy:cMainIni )
      Return .F.
   EndIf

   hFile:= HB_ReadIni( oTpuy:cMainIni )


Return .T.


/*
  Cargar archivo .ini
*/
/** \brief Almacenar archivo .ini
 */
Function SaveIni()
  /*Local cFile*/
Return .T.


/** \brief Verifica
 */
FUNCTION Connect()

   MsgInfo("Funcion Connect()")

RETURN .F.


/** \brief Visualiza el contenido de un tipo de dato.
 *   Detecta el tipo de dato del parámetro y determina la forma 
 *   de desplegar el contenido del mismo.
 *  \par uValue Tipo de Dato a Examinar.
 */
Function View( uValue  )

   Local oWnd,oBox
   Local cVal:="",nCols,nLins,i,j,lConvertir
   Local aData,cCadena,aConverted
   Local oScroll,oLbx,oTreeView, aIter
   
   IF !oTpuy:lDebug
      Return NIL
   EndIf

   DEFAULT uValue := ""

   If ValType( uValue )="A" 

      If Empty(uValue)
         MsgStop( CStr(uValue), "Arreglo Vacio."  )
         Return NIL
      EndIf

      aConverted := uValue

      lConvertir := IIF( ValType(uValue[1])!="A", .T. , .F. )

      nLins := Len( uValue )

      IF lConvertir
         nCols := 2
      ELSE
         nCols := LEN(uValue[1])+1
      ENDIF
      
      aData := ARRAY( nLins, nCols )
      aIter := ARRAY(nCols)

      For i = 1 to nLins
         aData[i,1]   := Alltrim(STRZERO(i,2))
         If lConvertir
            aData[i,2] := CStr( uValue[i] )
         Else
            For j = 1 to nCols-1
               aData[i,j+1] := uValue[i,j] 
            Next j 
         EndIf
      Next i

      DEFINE WINDOW oWnd TITLE "xView( "+CStr(uValue)+" )" SIZE 500,300

         DEFINE BOX oBox SPACING 2 OF oWnd

         /* Scroll bar */
         DEFINE SCROLLEDWINDOW oScroll OF oBox EXPAND FILL // CONTAINER

         /* Modelo de datos */
         DEFINE LIST_STORE oLbx AUTO aData
            
            For i := 1 To Len( aData )
               APPEND LIST_STORE oLbx ITER aIter
               for j := 1 to Len( aData[ i ] )
                  SET LIST_STORE oLbx ITER aIter POS j VALUE aData[i,j]
               next
            Next
            
         /* Browse/Tree */
         DEFINE TREEVIEW oTreeView MODEL oLbx OF oScroll CONTAINER
         oTreeView:SetRules( .T. )            


         For i=0 to nCols-1
            /* Columna simple de texto creada con gtk_tree_view_column_new_with_attributes  */
            cCadena := IIF( i=0, "Lin\Col", STRZERO(i,2) )
            DEFINE TREEVIEWCOLUMN COLUMN i+1 TITLE cCadena TYPE "text" ;
                   WIDTH 70 OF oTreeView
   
         Next i

      ACTIVATE WINDOW oWnd

   ElseIf ValType( uValue )="O" 
   
      aData   := uValue:ClassSel()
     
      /*
      AEVAL(  aData , { | a, n| IIF( Left( a,1)="_" ,  ;
              AADD(aConverted, {a , CStr( uValue:a )  } ) , ;
              NIL  )  } )
      */
      
      View( uValue:ClassSel() )

   Else
      // Se debe desarrollar una accion por tipo de dato pasado. Riztan
      MsgInfo( CStr( uValue ) )
   EndIf

Return NIL

/** \brief Equivalente a DefError de T-Gtk para Tepuy.
 *  \par oError
 */
/*
#include "common.ch"
#include "error.ch"

FUNCTION TPDefError( oError )
   LOCAL cMessage
   LOCAL cDOSError

   LOCAL aOptions
   LOCAL nChoice

   LOCAL n
   LOCAL nArea
   Local lReturn := .F.

   Local cText := "", oWnd, oScrool,hView, hBuffer, oBox, oBtn, oBoxH, expand, oFont, oExpand, oMemo
   Local cTextExpand := '<span foreground="orange" background="black" size="large"><b>'+MESSAGE_PULSE+' <span foreground="red"'+;
                        ' size="large" ><i>'+MESSAGE_DETAILS+'</i></span></b>!</span>'
   Local aStyle := { { "red" ,    BGCOLOR , STATE_NORMAL },;
                     { "yellow" , BGCOLOR , STATE_PRELIGHT },; 
                     { "white"  , FGCOLOR , STATE_NORMAL } }
   Local aStyleChild := { { "white", FGCOLOR , STATE_NORMAL },;
                          { "red",   FGCOLOR , STATE_PRELIGHT }}


   // By default, division by zero results in zero
   IF oError:genCode == EG_ZERODIV
      RETURN 0
   ENDIF

   // Set NetErr() of there was a database open error
   IF oError:genCode == EG_OPEN .AND. ;
      oError:osCode == 32 .AND. ;
      oError:canDefault
      NetErr( .T. )
      RETURN .F.
   ENDIF

   // Set NetErr() if there was a lock error on dbAppend()
   IF oError:genCode == EG_APPENDLOCK .AND. ;
      oError:canDefault
      NetErr( .T. )
      RETURN .F.
   ENDIF

   cMessage := ErrorMessage( oError )

   IF ! Empty( oError:osCode )
      cDOSError := "(DOS Error " + LTrim( Str( oError:osCode ) ) + ")"
   ENDIF

   IF ! Empty( oError:osCode )
      cMessage += " " + cDOSError
   ENDIF

   IF ! Empty( oError:subsystem )
      cMessage += " " + oError:subsystem + "/" + Ltrim(Str(oError:subCode))
   END

   IF ! Empty(oError:description)
      cMessage += "  " + oError:description
   END

   IF ! Empty(oError:operation)
      cMessage += ": " + oError:operation
   END

   IF ! Empty(oError:filename)
      cMessage += ": " + oError:filename
   END

*   MsgStop( cMessage, "Error" )

   cText += MSG_APPLICATION + CRLF
   cText += Replicate("=", Len(MSG_APPLICATION) ) + CRLF
   cText += "   "+MSG_PATH_NAME+": " + HB_ArgV( 0 ) + " (32 bits)" + HB_OsNewLine()


   cText += "   "+MSG_ERROR_AT+": " + ;
                DToC( Date() ) + ", " + Time() + CRLF

   // Error object analysis
   cMessage   = ErrorMessage( oError ) + CRLF
   cText += "   " + MSG_ERROR_DESCRIPTION + ":" + cMessage

   if ValType( oError:Args ) == "A"
      cText += "   "+MSG_ARGS+":" + CRLF
      for n = 1 to Len( oError:Args )
         cText += "     [" + Str( n, 4 ) + "] = " + ;
	                ValType( oError:Args[ n ] ) + "   " + ;
	                cValToChar( oError:Args[ n ] ) + CRLF
      next
   endif

   cText += CRLF + MSG_STACK_CALLS + CRLF
   cText += Replicate( "=", Len( MSG_STACK_CALLS ) ) + CRLF

   n := 2

   WHILE ! Empty( ProcName( n ) )
			cText += MSG_CALLED_FROM + ProcFile( n ) + "->" + ProcName(n) + "(" + AllTrim( Str( ProcLine( n ) ) ) + ")" + CRLF
			g_print( MSG_CALLED_FROM + ProcFile( n ) + "->" + ProcName(n) + "(" + AllTrim( Str( ProcLine( n ) ) ) + ")" + CRLF )
      n++
   ENDDO

    DEFINE WINDOW oWnd TITLE "Errorsys Tepuy/T-Gtk MultiSystem"
           oWnd:lInitiate := .F. //Fuerzo a entrar en otro bucles de procesos.

           DEFINE BOX oBox VERTICAL OF oWnd CONTAINER
                      cMessage := '<span foreground="blue"><i>'+;
                                  MSG_ERROR_DESCRIPTION + ":"+"</i>"+CRLF+;
                                  '<span foreground="black"><b>'+cMessage +'</b></span></span>'

                      DEFINE LABEL TEXT cMessage MARKUP OF oBox

                      DEFINE EXPANDER oExpand ;
                                      TEXT cTextExpand MARKUP ;
                                      EXPAND FILL OF oBox ;
                                      ACTION oWnd:Center( GTK_WIN_POS_CENTER_ALWAYS )

                      DEFINE SCROLLEDWINDOW oScrool ;
                             SIZE 400,400 OF oExpand CONTAINER

                      DEFINE MEMO oMemo VAR cText OF oScrool CONTAINER
                          oMemo:SetLeft( 10 ) 
                          oMemo:SetRight( 20 )
               
               DEFINE BOX oBoxH  OF oBox

               DEFINE BUTTON oBtn TEXT "_QUIT" MNEMONIC OF oBoxH EXPAND FILL ;
                            ACTION __Salir( oWnd ) 


               if oError:canRetry
                  DEFINE BUTTON oBtn TEXT "_Entry" MNEMONIC OF oBoxH EXPAND FILL;
                         ACTION ( lReturn := .T.,oWnd:End() )
               endif

               if oError:CanDefault
                  DEFINE BUTTON oBtn TEXT "_Default" MNEMONIC OF oBoxH EXPAND FILL ;
                         ACTION ( lReturn := .F., oWnd:End() )
               endif

               DEFINE FONT oFont NAME "Sans italic bold 13" 
               
               DEFINE BUTTON oBtn TEXT "_Save error.log" MNEMONIC;
                                 ACTION Memowrit( "error.log", cText ) ;
                                 FONT oFont ;
                                 STYLE aStyle ;
                                 STYLE_CHILD aStyleChild ;
                                 OF oBoxH

    ACTIVATE WINDOW oWnd CENTER MODAL


RETURN lReturn
*/
// SALIR DEL PROGRAMA Eliminando todo residuo memorial ;-)
// Salimos 'limpiamente' de la memoria del ordenador
/** \brief Realiza la Salida desde el programa de control de errores TPDefError()
 *
 */ 
Static Function __Salir( oWnd )
       Local nLen := Len( oWnd:aWindows ) - 1
       Local X

       if nLen > 0
          FOR X := nLen To 1
             oWnd:aWindows[x]:bEnd := NIL
             oWnd:aWindows[x]:End()
          NEXT
       endif
       oWnd:End()
       gtk_main_quit()
       QUIT

Return .F.



/** \brief Lee archivo tipo CSV y crea arreglo con los datos.
 *  \par cFile Ruta y Nombre del Archivo
 *  \par cDelimiter  Cadena con el delimitador
 *  \par lRemcomillar  Valor logico que indica si debe remover las comillas
 *  \ret Arreglo con el contenido del CSV.
 */ 
FUNCTION CSV2ARRAY(cFile,cDelimiter,lRemComillas)

   Local aItems := {}
   Local aLines  := {}
   Local cText, nItems
   Local myDelimiter := "|"

   Default cFile := ""
   Default cDelimiter := ","
   Default lRemComillas   := .T.

   cDelimiter := '"'+cDelimiter+'"'

   IF Empty(cFile) .OR. !File(cFile)
      Return {}   
   ENDIF

   cText := MEMOREAD(cFile)

   cText := STRTRAN( cText, cDelimiter,'"'+myDelimiter+'"' )   //--  Coloco mi delimitador "|"

   IF lRemComillas
      cText := STRTRAN( cText,'"',"" )   // ---  Eliminamos las comillas
   ENDIF

   aLines := HB_aTokens( cText,CRLF )

   IF Empty(aLines)
      Return {}
   ENDIF

   nItems := NumToken( aLines[1], myDelimiter )
   
   aItems := ARRAY(LEN(aLines),nItems)

   AEVAL(aLines, { |Lin,n| aItems[n]:= HB_aTokens( Lin, myDelimiter ) } )

Return aItems



/** \brief Valida la cadena de un Correo Electronico (Sintaxis).
 *  \par cMail  cadena de texto (mail). 
 *              La variable es modificada internamente  por lo que si se pasa
 *              el puntero, se obtiene su modificación.
 *  \ret Valor logico si la sintaxis evaluada es correcta
 *
 */ 
Function ValidMail( cMail )

   Local cRes
   Local cIni
   Local cFin
   Local cTest
   Local lTest := .F.
   Local cToken :="@"
   Local nTokens
   
   cRes := LOWER(cMail)
   cRes := ALLTRIM(cRes)
   
   //---- Lo Primero.. caracteres aceptables
   IF LEN(cRes) != LEN( ANSITOHTML(cRes) )
       RETURN .F.
   ENDIF

   //---- Verificamos que exista solo un "@"
   IF NumToken(cRes,cToken) !=2
       RETURN .F.
   ENDIF

   //---  dividir en antes y despues de "@"
   cIni := Token( cRes, cToken, 1 )
   cFin := Token( cRes, cToken, 2 )

   //---  Estudiamos el primer token...
   IF LEN(cIni)<3
      Return .F.
   ENDIF


   //---  Estudiamos el segundo token...

   /* 
      Debe contener al menos un punto. Por lo que nuevamente contamos 
      los tokens  
    */
   cToken  := "."
   nTokens := NumToken(cFin,cToken)
   
   IF nTokens<2 .OR. nTokens>3
      Return .F.
   ENDIF

   //--- si tenemos 3 tokens, el ultimo debe tener longitud 2
   IF nTokens=3 .AND. Len(Token(cFin,cToken,3))>2
      Return .F.
   ENDIF

   //--- si tenemos 3 tokens, verificamos el contenido 2do
   IF nTokens=3 
      cTest := Token(cFin,cToken,2)
      IF Len(cTest)<=4 
         IF "com"$cTest ; lTest:=.T. ; ENDIF
         IF "net"$cTest ; lTest:=.T. ; ENDIF
         IF "edu"$cTest ; lTest:=.T. ; ENDIF
         IF "org"$cTest ; lTest:=.T. ; ENDIF
         IF "gov"$cTest ; lTest:=.T. ; ENDIF
         IF "gob"$cTest ; lTest:=.T. ; ENDIF
         IF "mil"$cTest ; lTest:=.T. ; ENDIF
         IF "info"$cTest ; lTest:=.T. ; ENDIF
         IF !lTest 
            Return .F.
         ENDIF
      ENDIF
   ENDIF
   
   cMail := cRes

Return .T.
      

/** \brief Convierte un valor de texto al tipo especificado.
 *  \par cVal     Cadena de texto a convertir. 
 *  \par cValTYpe Caracter que indica el tipo de dato a devolver.
 *  \ret El valor convertido a lo solicitado.
 *                
 */
Function Str2Val(cVal, cValType )

   Local xRes
   
   IF HB_ISNIL(cVal)
      cVal := 'NIL'
   ENDIF

   IF Empty(cValType)
      Return cVal
   ENDIF
   
   cValType := AllTrim(cValType)
   
   
   DO CASE
      CASE cValType="N"
         xRes := Val( cVal )
      CASE cValType="L"
         cVal := CSTR(cVal)
         xRes := IIF( ("T" IN upper(cVal)) .OR. ("TRUE" IN upper(cVal)), .T.,.F.)
      OTHER
         xRes = cVal
   ENDCASE

Return xRes



//EOF
