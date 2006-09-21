// !!! ONLY XHARBOUR !!!

// Ejemplo de Client POP3 bajo T-Gtk y xHarbour
// (c)2004 Rafa Carmona

// ATENCION , SOLAMENTE SOPORTA XHARBOUR POR EL USO DE SOCKETS
// Usa las clases que estan en /xharbour/source/tip
// Usuarios de sistemas Win32
// Por favor, linkar librerias( -lwininet -lwsock32 ), soporte para sockets.

// Attentio, only support xHarbour for used the sockets
// Used the class, in /xharbour/source/tip
// Users system Win32
// Please, link librarys ( -lwininet -lwsock32 ), support sockets

#include "gclass.ch"
#include "tip.ch"

Static cUrl := ""
Static oBar, hBuffer

Static oUrl, oClient, nId
Static s_User, s_Pass

Function Main()
         Local oWindow, oToolBar, oToolButton, oBoxV
				 Local oToolBar2, hView, oEntry, oBox,scrolledwindow1

		     nId := 1 // First msg by default

				  DEFINE WINDOW oWindow TITLE "T-GTK Client POP3 Example" SIZE 400,400

                 DEFINE BOX oBoxV VERTICAL OF oWindow

                        DEFINE TOOLBAR oToolBar  OF oBoxV

                        DEFINE TOOLBUTTON oToolButton  ;
                               TEXT "Conectar";
															 ACTION Conectar();
                               STOCK_ID GTK_STOCK_EXECUTE;
                               OF oToolBar

                        DEFINE TOOLBUTTON oToolButton  ;
                               TEXT "Desconectar";
                               STOCK_ID GTK_STOCK_NO ;
                               OF oToolBar ;
                               ACTION ( if( oClient != NIL, (PopStatus(),;
															          oClient:Close(),;
                                        PushStatus( "Close:"+ oClient:cReply ) ), ))


												DEFINE TOOL SEPARATOR OF oToolBar

												DEFINE TOOLBUTTON oToolButton  ;
                     	         FROM STOCK GTK_STOCK_PREFERENCES;
															 ACTION Preferencias( oWIndow );
                               OF oToolBar

                        DEFINE TOOL SEPARATOR EXPAND OF oToolBar

                        DEFINE TOOLBUTTON oToolButton  ;
                               FROM STOCK GTK_STOCK_DIALOG_INFO ;
                               ACTION MsgInfo( "Ejemplo de sockets Multiplataforma"+HB_OSNEWLINE()+;
															                 "Usando GUI T-Gtk for [x]Harbour"+HB_OSNEWLINE()+;
																							 "(c)2004 Rafa Carmona","Informacion" );
                               OF oToolBar

								DEFINE TOOLBAR oToolBar2  OF oBoxV
                       //oToolbar2:Size( 0, 45 )

												DEFINE TOOLBUTTON oToolButton  ;
                               TEXT "Top";
															 ACTION Top_List() ;
                               STOCK_ID GTK_STOCK_YES OF oToolBar2

												DEFINE TOOLBUTTON oToolButton  ;
                               TEXT "List";
															 ACTION List_List( ) ;
                               STOCK_ID GTK_STOCK_INDEX OF oToolBar2

												DEFINE TOOLBUTTON oToolButton  ;
                               TEXT "Stat";
															 ACTION Stat_List( ) ;
                               STOCK_ID GTK_STOCK_CONVERT OF oToolBar2

												DEFINE TOOLBUTTON oToolButton  ;
                               TEXT "Retr";
															 ACTION Retr_List( ) ;
                               STOCK_ID GTK_STOCK_DND OF oToolBar2


                       scrolledwindow1 = gtk_scrolled_window_new()
                       gtk_widget_show (scrolledwindow1)
                       gtk_box_pack_start( oBoxV:pWidget, scrolledwindow1, TRUE, TRUE, 0)

        						   hView   := gtk_text_view_new()
                       hBuffer := gtk_text_view_get_buffer( hView)
                       gtk_text_view_set_left_margin( hView, 10 )
                       gtk_text_view_set_right_margin( hView, 20 )
                       gtk_container_add( scrolledwindow1, hView )
  					           gtk_widget_show( hView )

												DEFINE BOX oBox OF oBoxV
												       DEFINE LABEL TEXT "Parameter:"  OF oBox
												       DEFINE ENTRY oEntry VAR nId     OF oBox

											 DEFINE STATUSBAR oBar  OF oBoxV ;
											        TEXT "View POP3 email in Server. v0.1"

          ACTIVATE WINDOW oWindow MAXIMIZED

					if oClient != NIL
					   oClient:Close()
					endif

Return NIL

Static Function Conectar()
	     Local cInfo := "", cData
       LOCAL bWrite := .F.
			 Local cFile := ""

			if Empty( cUrl )
			   MsgStop( "Define preferencias de conexion","Atencion" )
				 return nil
			endif

		  oUrl := tURL():New( cUrl )

			IF Empty( oUrl )
         MsgInfo(  "Invalid url " + cUrl )
				 return nil
      ENDIF

			oBar:Pop()
			oBar:Push( "Connecting to " + oUrl:cProto + "://" + oUrl:cServer  )

			SysRefresh()

			oClient := tIPClient():New( oUrl )
  		oClient:nConnTimeout := 10000

			oClient:oUrl:cUserid   := s_User
			oClient:oUrl:cPassword := s_Pass


    IF oClient:Open( oUrl )
		   	 oBar:Pop()
         IF Empty( oClient:cReply )
						oBar:Push( "Connection status: <connected>" )
         ELSE
						oBar:Push( "Connection status: " + oClient:cReply  )
         ENDIF

				IF Empty( oClient:cReply )
						oBar:Push( "Done: (no goodbye message)" )
        ELSE
						oBar:Push( "Done: " + oClient:cReply )
        ENDIF

     ELSE
        MsgStop( "Can't open URI " + cUrl,"Attention" )
        IF .not. Empty( oClient:cReply )
           MsgAlert( oClient:cReply, "Alert" )
        ENDIF
				oClient := NIL
     ENDIF

RETURN NIL


Static Function Top_List(  )
       Local cInfo
			 Local nLines
			 LOCAL nLineLength := 80
       LOCAL nCurrentLine, cLinea
			 Local cText := ""

			 if oClient = NIL
			 	  return NIL
			 endif
			 cInfo := oCLient:Top( nId )
       PopStatus()
			 Text_Buffer( cInfo )
			 PushStatus( "Top command nId:"+ Str( nId, 4 ) )

			 SysRefresh()


			 nLines := MLCOUNT( cInfo )

			 if Empty( nLines )
			 	  return nil
			 endif

			 FOR nCurrentLine := 1 TO nLines
		     	cLinea := MEMOLINE( cInfo, nLineLength, nCurrentLine )
			    DO CASE
              CASE  "From" $ cLinea
							     cText += "From:"+ cLinea + HB_OSNEWLINE()
              CASE  "Subject" $ cLinea
							     cText += "Subject:"+ cLinea + HB_OSNEWLINE()
					ENDCASE
			 NEXT

	     if !Empty( cText )
			    MsgInfo( cText, "Informacion:" )
			 endif

return nil

Static Function List_List(  )
			 Local cInfo

			 if oClient = NIL
			 	  return NIL
			 endif
			 cInfo := oCLient:List( )

       PopStatus()
       Text_Buffer( cInfo )
			 PushStatus( "List command..." )

return nil

Static Function Stat_List( )
       Local cInfo

			 if oClient = NIL
			 	  return NIL
			 endif
			 cInfo := oCLient:Stat( )

       PopStatus()
       Text_Buffer( cInfo )
			 PushStatus( "Stat command..." )

return nil

Static Function Retr_List( )
       Local cInfo

			 if oClient = NIL
			 	  return NIL
			 endif
			 cInfo := oClient:Retreive( nId, 1 )

       PopStatus()
       Text_Buffer( cInfo )
			 PushStatus( "Retr command nId:"+ Str( nId,4) )

return nil

Static Function Preferencias( oWindow )
			 Local oDlg, oFixed, oBtn, oBox, oSay
			 Local oEntry1, oentry2, oEntry3

			 static cUser, cPassword, cServer

       if cUser = NIL
			    cUser      := Space( 30 )
			    cPassWord  := SPACE( 15 )
          cServer    := SPACE( 30 )
			 endif

			 // Ejemplo de uso de un dialogo
			 DEFINE DIALOG oDlg TITLE "Preferencias"  //SIZE 300,300

					DEFINE BOX oBox OF oDlg VERTICAL CONTAINER
							DEFINE FIXED oFixed OF oBox

                     DEFINE LABEL oSay TEXT "Username:"     OF oFixed POS 1,20
                     DEFINE LABEL oSay TEXT "Password:"     OF oFixed POS 1,40
                     DEFINE LABEL oSay TEXT "POP3 Server:"  OF oFixed POS 1,60

										 DEFINE ENTRY oEntry1 VAR cUser     OF oFixed POS 100,10
										 DEFINE ENTRY oEntry2 VAR cPassword OF oFixed POS 100,30 PASSWORD
										 DEFINE ENTRY oEntry3 VAR cServer   OF oFixed POS 100,50

			 		//Podemos meter 'MANUALMENTE' cualquier botton sin problemas en el 'area de botones'
          ADD DIALOG oDlg BUTTON "Ver URL" ACTION MsgBox( "pop://"+ Alltrim( cUser )+;
                                                          ":"+ Alltrim( cPassWord ) +"@"+;
                                                           alltrim( cServer), GTK_MSGBOX_OK, GTK_MSGBOX_INFO )

			    gtk_window_set_transient_for( oDlg:pWidget, oWindow:pWidget )

			 ACTIVATE DIALOG oDlg CENTER ;
								ON_OK ( cUrl := "pop://"+ Alltrim( cUser )+":"+ Alltrim( cPassWord ) +"@"+ alltrim( cServer),;
								        s_User := Alltrim( cUser ) , s_Pass := Alltrim( cPassWord ), oDlg:End() ) ;
								ON_CANCEL oDlg:End()


RETURN NIL


Static Func PopStatus()
			 oBar:Pop()
return nil

Static Func PushStatus( cCadena )
			oBar:Push( cCadena )
return nil

Static Function Text_Buffer( cInfo )

       SysRefresh()

       if cInfo != NIL
			    gtk_text_buffer_set_text( hBuffer, cInfo )
			 endif

return nil
