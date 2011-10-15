/*
 *  TPublic().
 *  Clase para el reemplazo de Variables Publicas
 *  Esta basada en la clase original TPublic de
 *  Daniel Andrade Version 2.1
 *
 *  Rosario - Santa Fe - Argentina
 *  andrade_2knews@hotmail.com
 *  http://www.dbwide.com.ar
 *
 *  con Aportes de:
 *     [ER] Eduardo Rizzolo
 *     [WA] Wilson Alves - wolverine@sercomtel.com.br	18/05/2002
 *     [RG] Riztan Gutierrez - riztan@gmail.com 28/10/2008
 *
 *  Sustituido uso de Arreglos por Hashes  [RG]
 *
 *  DATAS
 *	hVars		   - Hash de variables
 *	cName		   - Nombre ultima variable accedida
 *	nPos		   - Valor ultimo variable accedida
 *	lAutomatic	- Asignación automatica, por defecto TRUE	[WA]
 * lSensitive  - Sensibilidad a Mayusculas, por defecto FALSE [RG]
 *
 *  METODOS
 *	New()		- Contructor
 *	Add()		- Agrega/define nueva variable
 *	Del()		- Borra variable
 *	Get()		- Accede a una veriable directamente
 *	Set()		- Define nuevo valor directamente
 *	GetPos()	- Obtener la posición en el Hash
 *	Release()	- Inicializa el Hash
 *	IsDef()		- Chequea si una variable fue definida
 *	Clone()		- Clona el Hash
 *	nCount()	- Devuelve cantidad de variables definidas
 *
 *  NOTA
 *	Para acceder al valor de una variable, se puede hacer de 2 formas,
 *	una directa usando oPub:Get("Codigo") o por Prueba/Error oPub:Codigo,
 *	este último es mas simple de usar pero más lento.
 *
 *	Para definir un nuevo valor a una variable tambien puede ser por 2 formas,
 *	directamente por oPub:Set("Codigo", "ABC" ), o por Prueba/Error
 *	oPub:Codigo := "ABC".
 *
 *	Las variables definidas NO son case sensitive.
 *
 *  ULTIMAS
 *	Se guarda el Nombre y Posición de la última variable accedida para incrementar
 *	la velocidad. (Implementado por Eduardo Rizzolo)
 *
 *  EJEMPLO
 *	FUNCTION Test()
 *	local oP := TPublic():New(), aSave, nPos
 *
 *	oP:Add("Codigo")     // Defino variable sin valor inicial
 *	oP:Add("Precio", 1.15)     // Defino variable con valor inicial
 *	oP:Add("Cantidad", 10 )
 *	oP:Add("TOTAL" )
 *
 *	// Acceso a variables por prueba/error
 *	oP:Total := oP:Precio * oP:Cantidad
 *
 *	// Definicion y Acceso a variables directamente
 *	oP:Set("Total", oP:Get("precio") * oP:Get("CANTIDAD") )
 *
 *	oP:Del("Total")         // Borro una variable
 *	? oP:IsDef("TOTAL")     // Verifico si existe una variable
 *
 *	nPos := oP:GetPos("Total") // Obtengo la posición en el array
 *
 *	oP:Release()         // Borro TODAS las variables
 *
 *	oP:End()       // Termino
 *
 *	RETURN NIL
 *
 *  EXEMPLO (Asignación Automática)
 *
 *	FUNCTION MAIN()
 *	LOCAL oP:=TPublic():New(.T.)
 *
 *	op:nome		:= "Wilson Alves"
 *	op:Endereco	:= "Rua dos Cravos,75"
 *	op:Cidade	:= "Londrina-PR"
 *	op:Celular	:= "9112-5495"
 *	op:Empresa	:= "WCW Software"
 *
 *	? op:Nome,op:Endereco,op:Cidade,op:celular,op:empresa
 *
 *	op:End()
 *	RETURN NIL
 *
 */

#include "gclass.ch"
#include "hbclass.ch"
#include "proandsys.ch"

// GLOBAL EXTERNAL oTpuy
memvar oTpuy

/*
 * TPublic()
 */
/**\file tpublic.prg
 * \class TPublic. Clase TPublic
 *
 *  Clase para el reemplazo de Variables Publicas
 *  Esta basada en la clase original TPublic de
 *  Daniel Andrade Version 2.1
 *  
 *  \see Add().
 */
CLASS TPublic2

   VISIBLE:

   DATA  lAutoAdd    AS LOGICAL	 INIT .T.		
   DATA  lSensitive  AS LOGICAL	 INIT .F.		

   DATA  hVars

   DATA  nPos        AS NUMERIC    INIT 0   // READONLY // [ER]
   DATA  cName       AS CHARACTER  INIT ""  // READONLY // [ER]

   METHOD New( lAutoAdd, lSensitive )          /**New(). */
   METHOD End()            INLINE ::Release()  /**End(). */ 

   METHOD Add( cName, xValue )                 /**Add(). */
   METHOD Del( cName )             
   METHOD Get( cName ) 
   METHOD Set( cName, xValue )

   METHOD GetPos( cName )
   METHOD GetVar( nPos )

   METHOD IsDef( cName )   INLINE HHasKey( ::hVars, cName )

   METHOD Clone()          INLINE HClone( ::hVars )
   METHOD nCount()         INLINE Len( ::hVars )

   METHOD GetArray()           

   METHOD Release()        INLINE ::hVars := Hash()


   ERROR HANDLER OnError( cMsg, nError )

ENDCLASS


/*
 *  TPublic:New()
 */
/** Metodo Constructor.
 *  Permite generar la instancia de un objeto TPublic,
 *  Se puede inicializar con los parametros lAutomatic y lSensitive, 
 *  para definir si permite la creacion de variables y si admite 
 *  sensibilidad a las mayusculas respectivamente.
*/
METHOD New( lAutomatic, lSensitive ) CLASS TPublic2

   ::hVars := Hash()

   DEFAULT lAutomatic:=.T., lSensitive:=.F.

   HSetAutoAdd( ::hVars, lAutomatic )

   HSetCaseMatch( ::hVars, lSensitive )

   ::cName:=""
   ::lAutoAdd  :=lAutomatic
   ::lSensitive:=lSensitive

RETURN Self

/** 
 *  TPublic:Add()
 */
/** Metodo Add.
 *  Permite adicionar una variable al objeto TPublic,
 *  \param cName.
 *  \param xValue.
 *  \return Self.
*/
METHOD Add( cName, xValue ) CLASS TPublic2

   If HGetAutoAdd( ::hVars ) .AND. !::IsDef( cName )
      HSet( ::hVars, cName, xValue )
   EndIf

RETURN Self

/**
 *  TPublic:Del()
 */
METHOD Del( cName ) CLASS TPublic2

   If ::IsDef( cName )
      HDel( ::hVars , cName )
   EndIf

RETURN Self

/**
 *  TPublic:Get()
 */
METHOD Get( cName ) CLASS TPublic2

   Local xRet:=NIL

   If ::IsDef( cName )
      xRet := HGet( ::hVars , cName )
   Endif

RETURN xRet

/**
 *  TPublic:Set()
 */
METHOD Set( cName, xValue ) CLASS TPublic2

   If ::IsDef( cName )
      HSet( ::hVars , cName , xValue )
   Endif

RETURN Self

/**
 *  TPublic:GetPos() 
 */
METHOD GetPos( cName ) CLASS TPublic2
   Local nRet:=0

   If ::IsDef( ::hVars )
      nRet := HGetPos( ::hVars, cName )
   Endif

RETURN nRet


/**
 *  TPublic:GetVar()                         
 */
METHOD GetVar( nPos ) CLASS TPublic2

   Local nRet:=0

   If !( nPos > Len(::hVars) )
      nRet := HGetValueAt( ::hVars, nPos )
   Endif
   
RETURN nRet


/**
 *  TPublic:GetArray()
 */
METHOD GetArray() CLASS TPublic2

   Local nCont:= 1, nHash:= Len(::hVars)
   Local aRet:=ARRAY( nHash , 2 )
   Local aKeys:={}, aValues:={}

   aKeys  := HGetKeys( ::hVars )
   aValues:= HGetValues( ::hVars )

   While nCont <= nHash

      aRet[ nCont , 1 ]:= aKeys[ nCont ]
      aRet[ nCont , 2 ]:= aValues[ nCont ]
      nCont++

   EndDo

RETURN aRet


/**
 *  OnError()
 */
METHOD OnError( uValue ) CLASS TPUBLIC2

  Local cMsg   := UPPE(ALLTRIM(__GetMessage()))
  Local cMsg2  := Subs(cMsg,2)

  If SubStr( cMsg, 1, 1 ) == "_" // Asignar Valor
     If !::IsDef( cMsg2 )
        ::Add( cMsg2 , uValue )
     Else
        ::Set(cMsg2, uValue )
     EndIf
  Else
     If ::IsDef( cMsg )
        Return ::Get( cMsg ) 
     EndIf
  EndIf


RETURN uValue






/* Se debe construir clase para edicion de scripts, ya que de otra forma es 
 * complicado manejar cosas como por ejemplo... el nuevo nombre del archivo
 * al hacer un guardar como.
 */

CLASS TApp FROM TPublic

/*
   DATA cAutor 
   DATA cMail
   DATA cSistema
   DATA cBuild
   DATA cVer
*/
   METHOD About()
   METHOD RunXBS( cFile, p1,p2,p3,p4,p5,p6,p7,p8,p9,p10 )  
   METHOD RunText( cText )  
   METHOD OpenXBS( cFile, p1,p2,p3,p4,p5,p6,p7,p8,p9,p10 )  
   METHOD SaveScript( cFile )  
   METHOD SaveScriptAs( cFile )  
   METHOD Exit( lForce )

ENDCLASS


/** About()   
 *  
 */
METHOD About() CLASS TApp
   Local oAbout

   SET RESOURCES ::cResource FROM FILE ::cRsrcMain 
   DEFINE ABOUT oAbout ID "acercade" RESOURCE ::cResource

RETURN NIL




/** RunXBS()
 *
 */
METHOD RunXBS( cFile, p1, p2, p3, p4, p5, p6, p7, p8, p9, p10 ) CLASS TApp
   Local result
   Local oInterpreter, oFile, cScript := cFile
   Local cFilePPO, cFileXBS
   Local cSchema, lCONN := .F.
/*
   IF !Empty(oTpuy:aConnection)   
      IF HB_ISOBJECT(TPY_CONN)
         lCONN := .T.
         cSchema := TPY_CONN:Schema
      ENDIF
   ENDIF
*/
   DEFAULT cFile := 'test'

   IF !( "/" $ cFile )
      cFile := ::Get("cXBScripts")+cFile
   ELSE

      IF (".xbs" $ cFile)
         cFile := STRTRAN( cFile, ".xbs", "" )
      ELSE
         MsgStop( "Archivo No Válido" )
         Return .F.
      ENDIF
   ENDIF

#ifdef __HARBOUR__
   result := RUNXBS( cFile+".xbs", p1,p2,p3,p4,p5,p6,p7,p8,p9,p10 )
#else

   oInterpreter := TInterpreter():New(cScript)

   cFilePPO := cFile+'.ppo'
   cFileXBS := cFile+'.xbs'

   If File( cFilePPO+'~' )
      FERASE( cFilePPO+'~')
   EndIf


   If File( cFilePPO ) .AND. !Empty( MemoRead(cFilePPO) )

//      oFile :=  gTextFile():New( cFilePPO , "R" )
//      oInterpreter:SetScript( oFile:GetText(), 1 , cScript )
//      result := oInterpreter:Run( { p1,p2,p3,p4,p5,p6,p7,p8,p9,p10 } )
      result := oInterpreter:RunFile( cFilePPO, { p1,p2,p3,p4,p5,p6,p7,p8,p9,p10 } )

   Else
      result :=  oInterpreter:RunFile( cFileXBS , ;
                 { p1,p2,p3,p4,p5,p6,p7,p8,p9,p10 },'.ppo',.F.,'oInterpreter')
   EndIf

#endif
/*
   If lCONN .AND. cSchema!=TPY_CONN:Schema
      TPY_CONN:SetSchema(cSchema)
   EndIf
*/
Return result


/** OpenXBS()
 *
 */
METHOD OpenXBS( cFile, p1, p2, p3, p4, p5, p6, p7, p8, p9, p10 ) CLASS TApp

   Local oWnd, oBox, oScroll, oSourceView, cText:=""
   Local cResource
   Local oBtn_Ejecutar, oBtn_Guardar, oBtn_Guardar_Como, oBtn_Prefe, oBtn_Salir

   cText := MemoRead(cFile)
// MsgInfo( cText)

   If File( cFile ) .AND. !Empty( cText )
      SET RESOURCES cResource FROM FILE oTpuy:cResources+"xbscript.glade"

      DEFINE WINDOW oWnd TITLE cFile+" - "+oTpuy:cSystem_Name ;
             ID "window1" RESOURCE cResource  SIZE 800,500
          
             DEFINE BUTTON oBtn_Ejecutar ID "toolbutton_ejecutar" RESOURCE cResource;
                    ACTION ::RunText( oSourceView:GetText() )
          
             DEFINE BUTTON oBtn_Ejecutar ID "toolbutton_guardar" RESOURCE cResource; 
                    ACTION ::SaveScript( cFile, oSourceView:GetText() )
          
             DEFINE BUTTON oBtn_Ejecutar ID "toolbutton_guardar_como" RESOURCE cResource; 
                    ACTION (::SaveScriptAs( oSourceView:GetText() , oWnd) , View(oWnd))
//                    ACTION MsgInfo( "En desarrollo..." )
          
             DEFINE BUTTON oBtn_Ejecutar ID "toolbutton_preferencias" RESOURCE cResource; 
                    ACTION MsgInfo( "En desarollo...", oTpuy:cSystem_Name )
          
             DEFINE BUTTON oBtn_Ejecutar ID "toolbutton_salir" RESOURCE cResource; 
                    ACTION oWnd:End() 
          
             DEFINE BOX oBox OF oWnd VERTICAL
          
             DEFINE SCROLLEDWINDOW oScroll OF oBox CONTAINER ;
                    ID "scrolledwindow1" RESOURCE cResource
          
             DEFINE SOURCEVIEW oSourceView VAR cText OF oScroll CONTAINER;
                    MIME "text/x-prg"
          
      ACTIVATE WINDOW oWnd CENTER ;
         VALID MsgNoYes(MSG_EXIT_WANT, MSG_TITLE_PLEASE_CONFIRM ) 

   EndIf

Return NIL


/** RunText()
 *
 */
METHOD RunText( cText ) CLASS TApp

   Local result:=''
   Local oInterpreter, cScript := "TEMP"

   DEFAULT cText := ''

#ifdef __HARBOUR__
   MsgRun( MESSAGE_PROCESSING , {|| RunXBS( cText ) } )
#else
   oInterpreter := TInterpreter():New(cScript)
   
   MsgRun( MESSAGE_PROCESSING , {||oInterpreter:SetScript( cText, 1 , cScript )} )
  
   oInterpreter:Run()
#endif

Return result


/** SaveScript()
 *
 *
 */
METHOD SaveScript( cFile, cText, lRefresh , oWnd ) CLASS TApp

   Local oInterpreter, cFilePPO
   Local oFile
   
   Default cText := '' , lRefresh := .F., oWnd := NIL
  
//   --- Posibilidad de incluir la extension de forma automática.. en revision.
//   IIF( !( "." $ cFile ) , cFile := Alltrim(cFile)+".xbs" , NIL )

   If File(cFile)
      If !( MsgNoYes( cFile , MSG_QT_REWRITE_FILE ) )
         Return .F.
      EndIf
   EndIf
   
   If RIGHT( lower(cFile) , 4 ) = '.xbs'

#ifdef __HARBOUR__
      
      oFile := gTextFile():New( cFile, "W" )
      
      oFile:WriteLn( cText )

      oFile:Close()

#else 
      cFilePPO := Left( cFile , LEN(cFile) - 4 ) + ".ppo"
   
      If File( cFilePPO )
      
         If FErase( cFilePPO ) <> 0
            MsgStop( MSG_FILE_NO_DELETE , MSG_TITLE_ERROR )
            Return .F.
         EndIf

      EndIf
      
      oInterpreter := TInterpreter():New(cFile)

      MsgRun( MESSAGE_PROCESSING , {||oInterpreter:SetScript( cText, 1 , cFile )} )

      oInterpreter:lExec:=.F.
      oInterpreter:Run()
      
      oFile := gTextFile():New( cFile, "W" )
      
      oFile:WriteLn( cText )

      oFile:Close()
      
      cText := ''
      
      AEVAL( oInterpreter:acPPed , {|a|                                  ;
                                     IIf( a <> NIL .AND. Left(a,1)<>"#", ;
                                         cText += a + CRLF , NIL )       ;
                                   } )
                                   
      //Escribiendo el pre-procesado
      
      oFile := gTextFile():New( cFilePPO, "W" )
      
      oFile:WriteLn( cText )
      
      oFile:Close()
      
#endif     
      If lRefresh
         //MsgInfo("Refrescando Información.")
         If HB_IsObject( oWnd ) 
            oWnd:SetTitle( cFile+" - "+oTpuy:cSystem_Name )
         EndIf
//         View(oWnd)
      EndIf
   Else
    
      MsgStop( MSG_FILE_NO_ADEQUATE , MSG_FILE_NO_SAVE)

   EndIf

Return cFile


/** SaveScriptAs()
 *
 *
 */
METHOD SaveScriptAs( cText , oWnd )  CLASS TApp

//    FileChooser(GTK_FILE_CHOOSER_ACTION_SAVE)
   Local oFileChooser, cFile, cDialog
   
//   Default nMode := GTK_FILE_CHOOSER_ACTION_OPEN

   SET RESOURCES oTpuy:cResource FROM FILE oTpuy:cRsrcMain 

//   MsgInfo( CStr(OSDRIVE() + "/" +CurDir()+"/xbscripts/") )

//   If nMode = GTK_FILE_CHOOSER_ACTION_OPEN
//      cDialog := "filechooserdialog0"
//   Else
      cDialog := "filechooserdialog1"
//   EndIf
      DEFINE FILECHOOSERBUTTON oFileChooser ID cDialog ;
          RESOURCE oTpuy:cResource;
          PATH_INIT OSDRIVE() + "/" +CurDir()+"/xbscripts/*.xbs"
          
//          oFileChooser:SetIconName("gtk_preferences")

          DEFINE BUTTON ID "button_guardar" RESOURCE oTpuy:cResource  ;
                   ACTION ( cFile := ( oFileChooser:GetFileName() ) ,  ;
                            oFileChooser:End() ,                       ;
                            ::SaveScript(cFile, cText , .T. , oWnd ) )

          DEFINE BUTTON ID "button_cancelar1" RESOURCE oTpuy:cResource;
                 ACTION oFileChooser:End()

    SysRefresh()
   
RETURN NIL


METHOD Exit( lForce ) CLASS TApp

   Default lForce := .F.
   
   If MsgNoYes("Realmente desea Salir de <b>"+;
                oTpuy:cSystem_Name+"</b>",oTpuy:cSystem_Name)


      TRY
         //PQClose(oTpuy:conn)
      CATCH
      END

      oTpuy:End()
      gtk_main_quit()
      Quit
      Return .F.

   ELSE
      Return .F.
   EndIf
   
Return .T.

//EOF

/** Nuevo TPublic
 *
*/
CLASS TPublic

   VISIBLE:

   DATA  lAutoAdd    AS LOGICAL	 INIT .T.		
   DATA  lSensitive  AS LOGICAL	 INIT .F.		

//   DATA  hVars

//   DATA  nPos        AS NUMERIC    INIT 0   // READONLY // [ER]
//   DATA  cName       AS CHARACTER  INIT ""  // READONLY // [ER]

   METHOD New( lAutoAdd, lSensitive )          /**New(). */
   METHOD End()            INLINE ::Release()  /**End(). */ 

   METHOD Add( cName, xValue )                 /**Add(). */
   METHOD Del( cName )             
   METHOD Get( cName ) 
   METHOD Set( cName, xValue )

   METHOD AddMethod( cMethod )
   METHOD DelMethod( cMethod )

   METHOD IsDef( cName )   INLINE __objHasData( Self, cName )

   METHOD SendMsg()

//   METHOD GetPos( cName )
//   METHOD GetVar( nPos )

//   METHOD Clone()          INLINE HClone( ::hVars )
//   METHOD nCount()         INLINE Len( ::hVars )

//   METHOD GetArray()           

   METHOD Release()        INLINE Self := NIL

   ERROR HANDLER OnError( cMsg, nError )

ENDCLASS


//------------------------------------------------//
METHOD New( lAutomatic ) CLASS TPublic
   DEFAULT lAutomatic:=.T.

   ::lAutoAdd  :=lAutomatic
RETURN Self


//------------------------------------------------//
METHOD Add( cName, xValue ) CLASS TPublic

   if !::lAutoAdd ; return .f. ; endif

   if !::IsDef(cName)
      __objAddData( Self, cName )

      if !HB_ISNIL(xValue)
          return ::Set(cName, xValue)
      endif 

   endif

RETURN .F.


//------------------------------------------------//
METHOD Del( cName ) CLASS TPublic
   if !::IsDef(cName)
      __objDelMethod( Self, cName )
      return .t.
   endif
Return .f.


//------------------------------------------------//
METHOD Get( cName ) CLASS TPublic
   //local aData, nPos
   if ::IsDef(cName)
      return ::SendMsg( "_"+cName )
   endif
/*
   if __objHasData( Self, cName )
      aData := __objGetValueList(Self)
      nPos  := ASCAN(aData,{|a| a[HB_OO_DATA_SYMBOL]=UPPER(cName) }) 
      return aData[nPos,HB_OO_DATA_VALUE]
   endif
*/
Return nil


//------------------------------------------------//
METHOD Set( cName, xValue ) CLASS TPublic
   local uRet
   
   if __objHasData( Self, cName)

   #ifndef __XHARBOUR__
      if xValue == nil
         uRet = __ObjSendMsg( Self, cName )
      else
         __objSendMsg( Self, "___"+cName, __objSendMsg(Self,cName) )
         uRet = __ObjSendMsg( Self, "_"+cName, xValue )
      endif
   #else   
      if xValue == nil
         uRet = hb_execFromArray( @Self, cName )
      else
         hb_execFromArray( @Self, "___"+cName, ;
                           { hb_execFromArray( @Self,cName) } )
         uRet = hb_execFromArray( @Self, cName, { xValue } )
      endif
   #endif    

   endif

return nil


//------------------------------------------------//
METHOD AddMethod( cMethod, pFunc ) CLASS TPublic
 
   if ! __objHasMethod( Self, cMethod )  
      __objAddMethod( Self, cMethod, pFunc )    
   endif

return nil


//------------------------------------------------//
METHOD DelMethod( cMethod ) CLASS TPublic
 
   if ! __objHasMethod( Self, cMethod )  
      __objDelMethod( Self, cMethod )    
   endif

return nil


//------------------------------------------------//

#ifndef __XHARBOUR__
METHOD SendMsg( cMsg, ...  ) CLASS TPublic
   if "(" $ cMsg
      cMsg = StrTran( cMsg, "()", "" )
   endif
return __ObjSendMsg( Self, cMsg, ... )
#else   
METHOD SendMsg( ... ) CLASS TPublic
   local aParams := hb_aParams()
      
   if "(" $ aParams[ 1 ]
      aParams[ 1 ] = StrTran( aParams[ 1 ], "()", "" )
   endif
 
   ASize( aParams, Len( aParams ) + 1 )
   AIns( aParams, 1 )
   aParams[ 1 ] = Self
   
   return hb_execFromArray( aParams )   
#endif 


//------------------------------------------------//
METHOD ONERROR( uParam1 ) CLASS TPublic
   local cCol    := __GetMessage()

   if Left( cCol, 1 ) == "_"
      cCol = Right( cCol, Len( cCol ) - 1 )
   endif
   
   if !::IsDef(cCol)
      ::Add( cCol )
   endif
   
RETURN ::Set(cCol,uParam1)

//EOF
