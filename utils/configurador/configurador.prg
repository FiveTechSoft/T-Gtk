/*
 * $Id: configurador.prg,v 1.1 2010-06-04 11:55:50 xthefull Exp $
 * Alpha Configurador.
 * Porting Harbour to GTK+ power !
 * (C) 2009-2010. Rafa Carmona -TheFull-
*/
#include "gclass.ch"
#define NTRIM(n)    ( LTrim( Str( n ) ) )
#define MSGINFO      Msg_Info
#define MsgAlert     Msg_Alert

static oAssistant
static s_cPath_pkg := ""          // Path hacia pkg-config
static s_Continue_library := .f.  // Si estan disponibles las librerias obligatorias, continuaremos.
static aLibrerias
static s_aLibs_Harbour := {}          // Librerias de Harbour
static s_oBtn_Inc_Tgtk, s_oBtn_Lib_Tgtk
static s_Compiler := "xHarbour"

Function Main()
     Local oPage1, oPage2, oPage3, oPage13, oBtn

     Local o

     DEFINE ASSISTANT oAssistant ;
            ON CANCEL oAssistant:End() ;
            ON CLOSE  oAssistant:End() ;
            ON APPLY  ( oAssistant:bEnd := NIL,;          // Aqui no nos interesa que pregunte si queremos salir
                        MsgInfo( "Realized changes in your computer" ) ) ;
            SIZE 800,600
            
            // Please, view put simple button 
            DEFINE BUTTON oBtn FROM STOCK GTK_STOCK_HELP;
                  ACTION MsgInfo( "Help me, please , for page:"+ str( oAssistant:GetCurrentPage(),2 ) )
            oAssistant:AddWidget( oBtn )

            // Inicio
            oPage1 := Create_Page1( )
            // Licencia LGPL
            oPage2 := Create_Page2( )
            // Seleccion de compilador y librerias
            oPage3 := Create_Page3( )

            //Confirmación
            oPage13 := Create_Page4( )

            APPEND ASSISTANT oAssistant ;
                   WIDGET oPage1 ;
                   COMPLETE ;
                   TYPE GTK_ASSISTANT_PAGE_INTRO  ;
                   TITLE "Bienvenido a T-Gtk for [x]Harbour" ;
                   IMAGE HEADER "./images/tgtk-logo.png" ;
                   IMAGE SIDE   "./images/rafa2.jpg"

            APPEND ASSISTANT oAssistant ;
                   WIDGET oPage2 ;
                   TITLE "License LGPL" ;
                   IMAGE HEADER"./images/gnu-keys.png"

            APPEND ASSISTANT oAssistant ;
                   WIDGET oPage3 ;
                   TITLE "Configuración base" ;
                   IMAGE HEADER "./images/tgtk-logo.png" 

           APPEND ASSISTANT oAssistant ;
                   WIDGET oPage13 ;
                   TITLE "Confirmación.";
                   TYPE GTK_ASSISTANT_PAGE_CONFIRM ;
                   IMAGE HEADER "./images/tgtk-logo.png" ;
                   COMPLETE

           if s_Continue_library // Si vamos a dejar continuar
              oAssistant:SetComplete( oPage3, .T. )
           endif

     ACTIVATE ASSISTANT oAssistant ;
              CENTER MAXIMIZED;
              VALID ( MsgBox( " Do you cancel assistant ?", GTK_MSGBOX_OK+GTK_MSGBOX_CANCEL,GTK_MSGBOX_INFO ) == GTK_MSGBOX_OK )
                                    
Return NIL

STATIC FUNCTION Create_Page4( )
  Local oBox, oScroll, oTextView, cValue := ""
  
  DEFINE BOX oBox VERTICAL 
       
       DEFINE BUTTON OF oBox PROMPT "Muestra Preview";
              ACTION Crear_Preview( oTextView )
              
       DEFINE BUTTON OF oBox PROMPT "Ejecutar" FROM STOCK GTK_STOCK_EXECUTE;
              ACTION msgInfo( "Algo haremos" )

       DEFINE SCROLLEDWINDOW oScroll OF oBox CONTAINER
         DEFINE TEXTVIEW oTextView VAR cValue OF oScroll CONTAINER READONLY
      

  oBox:SetBorder( 10 )
       
RETURN oBox

STATIC FUNCTION Create_Page2( )
  Local oBox, oScroll, oTextView, oCheck
  Local cText := "",  nWhere := 1
  Local oRadio1, oRadio2, oBox2, oImage
  Local cTextExpand := '<span foreground="blue" size="large"><b>Are you ready ? Please, select option: </b></span>'
  Local oFile := gTextFile():New( "license.txt", "R" )
  Local aStart := Array( 14 )

  DEFINE BOX oBox VERTICAL
      DEFINE SCROLLEDWINDOW oScroll OF oBox CONTAINER
         DEFINE TEXTVIEW oTextView VAR cText OF oScroll CONTAINER READONLY
         
         DEFINE IMAGE oImage FILE "./images/gnu-keys.png" LOAD
     
         // Eh!, you localicate you position with GetIterAtOffset
         oTextView:oBuffer:GetIterAtOffSet( aStart, -1 ) 
         
         oTextView:CreateTag( "center", { "justification", GTK_JUSTIFY_CENTER } )
         oTextView:Insert_Tag( " ", "center", aStart )
         oTextView:Insert_Pixbuf( aStart, oImage )
         oTextView:Insert( CRLF )
         
         oTextView:oBuffer:GetIterAtOffSet( aStart, -1 ) 
         oFile:Goto( 1 )
         while !oFile:lEoF 
               oTextView:Insert_Tag( oFile:Read(), "center", aStart )
               oFile:Goto( ++nWhere )
         end while
    
         oFile:Close()

         DEFINE LABEL TEXT cTextExpand MARKUP OF oBox 

         DEFINE BOX oBox2 OF oBox HOMO
            
            DEFINE RADIO oRadio1 MNEMONIC TEXT "_No, I don't agree." OF oBox2 ;
                   ACTION If( oRadio1:GetActive(), oAssistant:SetComplete( oBox, .F. ) , )

            DEFINE RADIO oRadio2 GROUP oRadio1 MNEMONIC;
                   TEXT "Yes, I _Agree." OF oBox2;
                   ACTION If( oRadio2:GetActive(), oAssistant:SetComplete( oBox, .T. ) , )


RETURN oBox

STATIC FUNCTION Create_Page1( )
  Local oBox
  
  DEFINE BOX oBox VERTICAL  
       DEFINE LABEL TEXT "<b>GMOORK</b> era mi perro, un Alaska Malamute." + CRLF+;
                         "Es el símbolo de T-Gtk." MARKUP OF oBox
       DEFINE IMAGE FILE "./images/gmoork.png" OF oBox EXPAND FILL
RETURN oBox

// Seleccionamos sistema operativo
STATIC FUNCTION Create_Page3( )
 Local oBoxV, oRadio1, oRadio2, oGet, oLabel
 Local oBox, oBox2, oFrame, oBoxRadio, oFrame2, oLabel2
 Local oFrame_p, oLabel_p, oBox_p, n , oCol
 Local aItems, oLbx, oTreeView, oScroll, oBtn
 Local aIter := {}, x, oScroll_Lib, oLbx_Lib, oTreeView_Lib
 Local ltrue := .f.
 Local nPos, oCol1, cTmp, cId, cDes
 Local oLabel3, oTable2, oFrame3, oBoxTable, oTable3
 Local oBtn_Lib_Har, oBtn_Inc_Har, oBtn_Bin_Har
 Local oTreeview_Harbour, oLbx_Harbour, oScroll_Lib_harbour
 Local o, oCol2, oBoxCom, oRadioC1, oRadioC2
 Local uPixbuf:= gdk_pixbuf_new_from_file( "./images/drive-harddisk.png" )

 // Cargamos librerias de Harbour a traves de un xml
 WITH OBJECT o := gConfigHarbour():Create()
      :New()
 END
 s_aLibs_Harbour := o:GetLibs()

 WITH OBJECT o := gConfigGTK():Create()
      :New()
 END
 aLibrerias := o:GetLibs()

 // Si estan las obligatorias, nos dejará continuar.
 s_Continue_library := aLibrerias[1,1] .and. aLibrerias[2,1]

 DEFINE BOX oBoxV EXPAND FILL HOMO
  DEFINE BOX oBox VERTICAL EXPAND FILL OF oBoxV
     // ---------------    Sistema Operativo -------------------------
     DEFINE LABEL oLabel TEXT '<span foreground="orange" background="black" size="large"><b>Select an Operating System</b></span>' MARKUP
     DEFINE FRAME oFrame OF oBox ;
            SHADOW GTK_SHADOW_ETCHED_IN ;
            LABEL oLabel 

         DEFINE BOX oBoxRadio VERTICAL OF oFrame CONTAINER

              DEFINE RADIO oRadio1 TEXT "GNU/Linux" ;
                     OF oBoxRadio;
                     ACTION ( Select_System( oRadio2 ), oGet:SetText( s_cPath_Pkg ) )

              DEFINE RADIO oRadio2 GROUP oRadio1 ;
                     TEXT "Microsoft Windows" OF oBoxRadio ;
                     ACTION ( Select_System( oRadio2), oGet:SetText( s_cPath_Pkg ) )
 
              Select_System( oRadio2 )

      // ---------------  PKG-CONFIG -------------------------
     aItems  := RUN3ME( "pkg-config --list-all" )
     DEFINE LABEL oLabel_p TEXT '<span foreground="orange" background="black" size="large"><b>PKG-CONFIG</b></span>' MARKUP
     DEFINE FRAME oFrame_p OF oBox EXPAND FILL ;
            SHADOW GTK_SHADOW_ETCHED_IN ;
            LABEL oLabel_p 

       DEFINE BOX oBox_p VERTICAL OF oFrame_p CONTAINER
          DEFINE GET oGet VAR s_cPath_Pkg OF oBox_p

         /* Modelo de Datos de las librerias que necesitamos y las que son obligatorias */
          DEFINE LIST_STORE oLbx_Lib TYPES G_TYPE_BOOLEAN, G_TYPE_STRING, G_TYPE_STRING, GDK_TYPE_PIXBUF
          For x := 1 To Len( aLibrerias )
              APPEND LIST_STORE oLbx_Lib ITER aIter
              for n := 1 to Len( aLibrerias[ x ] )
                  if n != 4
                     SET LIST_STORE oLbx_Lib ITER aIter POS n VALUE aLibrerias[x,n]
                  else
                     if aLibrerias[x,n]  //Esta la libreria en el sistema.
                        SET LIST_STORE oLbx_Lib ITER aIter POS n VALUE uPixbuf
                     else
                        SET LIST_STORE oLbx_Lib ITER aIter POS n VALUE 0
                     endif
                  endif
              next
          Next
          DEFINE SCROLLEDWINDOW oScroll_Lib  OF oBox_p EXPAND FILL SHADOW GTK_SHADOW_ETCHED_IN
          /* Browse/Tree */
          DEFINE TREEVIEW oTreeView_Lib MODEL oLbx_Lib OF oScroll_Lib CONTAINER
          oTreeView_Lib:bRow_Activated := { |path,col| InstalarPaquete( oTreeview_Lib, path, col ) }

          DEFINE TREEVIEWCOLUMN oCol COLUMN 1 TITLE "¿Instalada?"  TYPE "active" OF oTreeView_Lib
          DEFINE TREEVIEWCOLUMN COLUMN 4 TYPE "pixbuf" OF oCol EXPAND

          DEFINE TREEVIEWCOLUMN COLUMN 2 TITLE "Libreria"    TYPE "text"  OF oTreeView_Lib
          DEFINE TREEVIEWCOLUMN COLUMN 3 TITLE "Tipo"        TYPE "text"  OF oTreeView_Lib

           DEFINE LABEL TEXT 'Librerias instaladas.' OF oBox_p
           /*Modelo de Datos de las librerias del sistema */
          aIter := {}
          DEFINE LIST_STORE oLbx TYPES G_TYPE_STRING, G_TYPE_STRING
          For x := 1 To Len( aItems )
             APPEND LIST_STORE oLbx ITER aIter
             // Vamos a separar nombre y descripcion, quitando salto de linea
             cTmp := strtran( aItems[x], hb_osnewline(), "" )
             nPos := AT( " ", cTmp )
             cId  := alltrim( substr( cTmp, 1, nPos -1 ) )
             cDes := alltrim( substr( cTmp, nPos ) )

             SET LIST_STORE oLbx ITER aIter POS 1 VALUE cId
             SET LIST_STORE oLbx ITER aIter POS 2 VALUE cDes
          Next
             
          DEFINE SCROLLEDWINDOW oScroll  OF oBox_p EXPAND FILL  SHADOW GTK_SHADOW_ETCHED_IN
              
          oScroll:SetPolicy( GTK_POLICY_AUTOMATIC, GTK_POLICY_AUTOMATIC)
        
          /* Browse/Tree */
          DEFINE TREEVIEW oTreeView MODEL oLbx OF oScroll CONTAINER
          oTreeView:SetRules( .T. )
          DEFINE TREEVIEWCOLUMN COLUMN 1 TITLE "Id"            TYPE "text" SORT WIDTH 150 EXPAND OF oTreeView
          DEFINE TREEVIEWCOLUMN COLUMN 2 TITLE "Description"   TYPE "text" EXPAND OF oTreeView

 DEFINE BOX oBox2 VERTICAL EXPAND FILL OF oBoxV
     // ---------------   T-GTK -------------------------
     DEFINE LABEL oLabel2 TEXT '<span foreground="orange" size="large"><b>T-GTK</b></span>' MARKUP
     DEFINE FRAME oFrame2 OF oBox2 ;
            SHADOW GTK_SHADOW_ETCHED_IN ;
            LABEL oLabel2 

              DEFINE TABLE oTable2 OF oFrame2 ROWS 2 COLS 2
                 
                  DEFINE LABEL TEXT "<i>Path T-GTK Libs</i>" MARKUP ;
                        TABLEATTACH 0, 1, 0, 1 , nOR( GTK_EXPAND, GTK_FILL), GTK_FILL ;
                        HALIGN 0.5;
                        VALIGN 2;
                        OF oTable2

                  DEFINE FILECHOOSERBUTTON s_oBtn_Lib_Tgtk ;
                        TEXT "Select Library of T-GTK" ;
                        PATH_INIT "../../../lib" ;
                        MODE GTK_FILE_CHOOSER_ACTION_SELECT_FOLDER ;
                        TABLEATTACH 1,2,0,1 , nOR( GTK_EXPAND, GTK_FILL), GTK_FILL ;
                        OF oTable2

                   DEFINE LABEL TEXT "<i>Path T-GTK Include</i>" MARKUP ;
                        TABLEATTACH 0,1,1,2, nOR( GTK_EXPAND, GTK_FILL), GTK_FILL ;
                        HALIGN 0.5;
                        VALIGN 2;
                        OF oTable2

                   DEFINE FILECHOOSERBUTTON s_oBtn_Inc_Tgtk ;
                         TEXT "Select Include of T-GTK" ;
                         PATH_INIT "../../../include" ;
                         MODE GTK_FILE_CHOOSER_ACTION_SELECT_FOLDER ;
                         TABLEATTACH 1,2,1,2,nOR( GTK_EXPAND, GTK_FILL), GTK_FILL ;
                         OF oTable2
                     
     // ---------------Compiler-------------------------
     DEFINE LABEL oLabel TEXT '<span foreground="orange" size="large"><b>Select xBase Compiler</b></span>' MARKUP
     DEFINE FRAME oFrame OF oBox2 ;
            SHADOW GTK_SHADOW_ETCHED_IN ;
            LABEL oLabel 

         DEFINE BOX oBoxCom VERTICAL OF oFrame CONTAINER
              
              DEFINE RADIO oRadioC1 TEXT "xHarbour" ;
                     OF oBoxCom ;
                     ACTION s_Compiler := "XHARBOUR"

              DEFINE RADIO oRadioC2 GROUP oRadioC1   TEXT "Harbour"; 
                    OF oBoxCom ;
                    ACTION s_Compiler := "HARBOUR"


     DEFINE LABEL oLabel3 TEXT '<span foreground="orange" size="large"><b>Select Path and Libs</b></span>' MARKUP
     DEFINE FRAME oFrame3 OF oBox2 ;
            SHADOW GTK_SHADOW_ETCHED_IN ;
            LABEL oLabel3 EXPAND FILL

      DEFINE BOX oBoxTable OF oFrame3 CONTAINER
              

            DEFINE TABLE oTable3 OF oBoxTable ROWS 3 COLS 2 
                 
                  DEFINE LABEL TEXT "<i>Path Harbour Libs</i>" MARKUP ;
                        TABLEATTACH 0, 1, 0, 1 , nOR( GTK_EXPAND, GTK_FILL), GTK_FILL ;
                        HALIGN 0.5;
                        VALIGN 2;
                        OF oTable3

                  DEFINE FILECHOOSERBUTTON oBtn_Lib_Har ;
                        TEXT "Select Library of Harbour" ;
                        PATH_INIT GETENV("HB_LIB_INSTALL") ;
                        MODE GTK_FILE_CHOOSER_ACTION_SELECT_FOLDER ;
                        TABLEATTACH 1,2,0,1 , nOR( GTK_EXPAND, GTK_FILL), GTK_FILL ;
                        OF oTable3

                   DEFINE LABEL TEXT "<i>Path Harbour Include</i>" MARKUP ;
                        TABLEATTACH 0,1,1,2, nOR( GTK_EXPAND, GTK_FILL), GTK_FILL ;
                        HALIGN 0.5;
                        VALIGN 2;
                        OF oTable3

                   DEFINE FILECHOOSERBUTTON oBtn_Inc_Har ;
                         TEXT "Select Include of Harbour" ;
                         PATH_INIT GETENV("HB_INC_INSTALL") ;
                         MODE GTK_FILE_CHOOSER_ACTION_SELECT_FOLDER ;
                         TABLEATTACH 1,2,1,2,nOR( GTK_EXPAND, GTK_FILL), GTK_FILL ;
                         OF oTable3

                  DEFINE LABEL TEXT "<i>Path Harbour bin</i> " MARKUP ;
                          TABLEATTACH 0,1,2,3, nOR( GTK_EXPAND, GTK_FILL), GTK_FILL ;
                          HALIGN 0.5;
                          VALIGN 2;
                          OF oTable3

                   DEFINE FILECHOOSERBUTTON oBtn_Bin_Har ;
                          TEXT "Select Bin of Harbour" ;
                          PATH_INIT GETENV("HB_BIN_INSTALL") ;
                          MODE GTK_FILE_CHOOSER_ACTION_SELECT_FOLDER ;
                          TABLEATTACH 1,2,2,3 , nOR( GTK_EXPAND, GTK_FILL), GTK_FILL ;
                          OF oTable3

         /* Modelo de Datos de las librerias que necesitamos y las que son obligatorias */
          aIter := {}
          DEFINE LIST_STORE oLbx_Harbour TYPES G_TYPE_BOOLEAN, G_TYPE_STRING
          For x := 1 To Len( s_aLibs_Harbour )
              APPEND LIST_STORE oLbx_Harbour ITER aIter
             for n := 1 to Len( s_aLibs_Harbour[ x ] )
                  SET LIST_STORE oLbx_Harbour ITER aIter POS n VALUE s_aLibs_Harbour[x,n]
              next
          Next
          DEFINE SCROLLEDWINDOW oScroll_Lib_Harbour OF oBoxTable EXPAND FILL SHADOW GTK_SHADOW_ETCHED_IN
          /* Browse/Tree */
          DEFINE TREEVIEW oTreeView_Harbour MODEL oLbx_Harbour OF oScroll_Lib_Harbour CONTAINER
          oTreeView_Harbour:SetRules( .T. )

          DEFINE TREEVIEWCOLUMN oCol1 COLUMN 1 TITLE "Select"   TYPE "active" OF oTreeView_Harbour
          oCol1:oRenderer:bAction := {| o, cPath| select_lib( o, cPath, oTreeview_Harbour, oLbx_Harbour  ) }

          DEFINE TREEVIEWCOLUMN oCol2 COLUMN 2 TITLE "Libreria" TYPE "text"   OF oTreeView_Harbour
          oCol2:oRenderer:Set_Valist( { "cell-background", "Orange", ;
                                       "cell-background-set", .t. } )

         
 oBoxV:SetBorder( 2 )
 gdk_pixbuf_unref( uPixbuf )

return oBoxV

/* Ejemplo de como MODIFICAR un dato del modelo vista controlador.
   Vamos a autoalimentar el array para tenerlo listo al momento. */
static function select_lib( oCellRendererToggle, cPath, oTreeView, oLbx)
  Local aIter := Array( 4 )
  Local path, nFila
  Local fixed
  Local nColumn := 1 

  //nColumn := oCellRendererToggle:nColumn + 1  // Bug

  path := gtk_tree_path_new_from_string( cPath )
 /* get toggled iter */
  fixed := oTreeView:GetValue( nColumn, "Boolean", Path, @aIter )

  // do something with the value 
  fixed := !fixed
   
   /* set new value */
  oLbx:Set( aIter, nColumn, fixed )

  nFila := hb_gtk_tree_path_get_indices( path ) + 1 // Obtenemos la fila donde estamos

  /* clean up */
  gtk_tree_path_free( path )

  s_aLibs_Harbour[ nFila,1 ] := fixed   // Modificamos directamente el array de las librerias

Return .f.

/* TODO:
   Nos permite instalar el paquete necesario desde el instalador.
   Para ello deberíamos especificar el nombre del paquete en el XML.
   El principal problema es que cada distro puede estar ubicado en paquetes distintos.
   Además, en Windows... pues ni lo intentamos...
   */
Static Function InstalarPaquete( oTreeView, pPath, pTreeViewColumn  )
    Local oWnd , oImage, width, height, pImage
    
    //pImage := oTreeview:GetValue( 4, "Long" , pPath )
    pImage := oTreeview:GetAutoValue( 4 )

    if pImage = 0  // Si no esta en el sistema
       MsgInfo( "¿ Instalar el paquete " + oTreeview:GetAutoValue( 2 ) + " ?" )
    endif

Return nil

// Selecciona el sistema operativo
static function Select_System( oRadio2 )

        /* Si el sistema es windows, determinado posible ruta hacia pkhg-config*/
     if "WIN" $ UPPER( OS() ) 
        oRadio2:SetState( TRUE )
     endif

    if empty(  ( s_cPath_pkg := GetEnv( "PKG_CONFIG_PATH" ) ) )
       s_cPath_pkg := GetEnv( "GTK_BASEPATH" )
       if Empty ( s_cPath_Pkg )
          if "WIN" $ UPPER( OS() )
             s_cPath_pkg := "c:/gtk/lib/pkgconfig"
          else
             s_cPath_pkg := "/usr/lib/pkgconfig"  // Para sistemas GNU/Linux
          endif
       endif
    endif

    s_cPath_pkg += space( 100 )

return nil

/**
  Muestra 'como' debe ser el Rules.make
*/
FUNCTION Crear_Preview( oTextView )
      oTextView:SetText("")
      oTextView:Insert( replicate("PREVIEW ", 10 )+CRLF )
      oTextView:Insert("##################################################" +CRLF )
      oTextView:Insert("# System Configure of T-Gtk."+CRLF )
      oTextView:Insert("##################################################"+CRLF )
      
RETURN nil

// TODO. Falta ADAPTACION TOTAL del antiguo configurar, al nuevo.
// Especificar como statics , las variables del compilar, rutas, etc..

STATIC FUNCTION CreateRules()
      Local cRules
      Local oFile_Skele
      Local lError := .F.
      Local bErrorHandler,  bLastHandler, oError, cError

      /*Comprobamos existencia de Rules.make */
      IF File( "../../Rules.make")
         if MsgBox( UTF_8( "Fichero ../../Rules.make, existe ."+ HB_OSNEWLINE()+;
                    "Y se va a proceder a sustituirlo"+ HB_OSNEWLINE()+;
                    "¿ Quiere continuar ?") , GTK_MSGBOX_OK+GTK_MSGBOX_CANCEL,GTK_MSGBOX_INFO ) == GTK_MSGBOX_CANCEL
            MsgAlert( "Se ha cancelado la configuracion de T-Gtk","Alerta" )
            return nil
         endif
      ENDIF

      oFile_Skele := gTextFile():New( "./config.tgtk", "R" )

      if oFile_Skele:nError < 0
         MsgStop( "Error al intentar leer el fichero config.tgtk","Cancelado")
         return nil
      endif

      oFile := gTextFile():New( "../../Rules.make", "W" )
      if oFile:nError < 0
         oFile_Skele:Close()
         MsgStop( "Error al intentar crear fichero","Cancelado")
         return nil
      endif

      oFile:WriteLn("##################################################")
      oFile:WriteLn("# System Configure of T-Gtk.")
      oFile:WriteLn("# Version para el S.O "+ cSystem + " y para "+ cCompiler )
      oFile:WriteLn("# (c)2004-10 Rafa Carmona.")
      oFile:WriteLn("# "  )
      oFile:WriteLn("# Create: " + DtoC( Date() )+ " # " + Time()  )
      oFile:WriteLn("##################################################")
      oFile:WriteLn( " "  )
      oFile:WriteLn("# Para tener soporte de impresion en GNU/Linux a traves de gnome.")
      oFile:WriteLn("# tenemos que tener instalado el paquete libgnomeprintui22-devel,")
      oFile:WriteLn("# si queremos realizar la aplicacion con soporte de impresion." )
      oFile:WriteLn("# Aqui , especificaremos los cFlags de compilacion necesarios para C")
      if lPrint
         oFile:WriteLn( "SUPPORT_PRINT_LINUX=yes" )
      else
          oFile:WriteLn( "SUPPORT_PRINT_LINUX=no" )
      endif
      oFile:WriteLn( " "  )

      oFile:WriteLn("# 20-12-2005 by Joaquim Ferrer <quim_ferrer@yahoo.es>")
      oFile:WriteLn("# Soporte de Impresion para Win32")
      oFile:WriteLn("# Es necesario tener instalado el pack de soporte para impresion")
      oFile:WriteLn("# de gnome, portado a Win32, gtk-win32-gnomeprint-2-2 instalado")
      oFile:WriteLn("# en el path de Gtk+, si no es asi, SUPPORT_PRINT_WIN32=no -->")

      if lPrint_Win
         oFile:WriteLn( "SUPPORT_PRINT_WIN32=yes" )
      else
          oFile:WriteLn( "SUPPORT_PRINT_WIN32=no" )
      endif

      oFile:WriteLn( " "  )
      oFile:WriteLn("#Especifica aqui, si lo necesitas por no tenerlo en el entorno, SET,")
      oFile:WriteLn("#las rutas del compilador de Harbour.")
      oFile:WriteLn("#Bajo Windows especificar mingw32, bajo linux especificar gcc.")
      oFile:WriteLn( iif( cSystem = "Windows" ,"HB_COMPILER = mingw32","HB_COMPILER = gcc" ))
      oFile:WriteLn( " "  )

      oFile:WriteLn("#Especificamos compilador xBase a usar, si harbour o xHarbour")
      oFile:WriteLn( "XBASE_COMPILER = " + cCompiler )
      oFile:WriteLn( " "  )

      oFile:WriteLn("#Rutas hacia el compilador xBase" )
      oFile:WriteLn("HB_BIN_INSTALL = " +  cCompiler_Bin )
      oFile:WriteLn("HB_INC_INSTALL = " +  cCompiler_Inc )
      oFile:WriteLn("HB_LIB_INSTALL = " +  cCompiler_Lib )
      oFile:WriteLn( " "  )

      oFile:WriteLn("#Rutas de librerias y de includes de TGTK.")
      oFile:WriteLn("LIBDIR_TGTK=" +  cTgtk_Lib )
      oFile:WriteLn("INCLUDE_TGTK_PRG=" + cTgtk_Inc )
      oFile:WriteLn( " "  )

      oFile:WriteLn( oFile_Skele:GetText() ) /* Copiamos el esqueleto al fichero Rules.make */

      oFile_Skele:Close()
      oFile:Close( )

    bErrorHandler := { |oError|  MyErrorHandler( oError ) }
    bLastHandler := ERRORBLOCK( bErrorHandler )        // Save current handler
    BEGIN SEQUENCE
      // Copiamos el Makefile segun el sistema y librerias
      if cSystem = "Windows"
         COPY FILE "Make.win" TO "../../Makefile"
         COPY FILE "win_libhbgtk.a" TO ( cTgtk_Lib +"/libhbgtk.a" ) // Libreria C
         if cCompiler = "HARBOUR"
            COPY FILE "win_libgclass.a" TO ( cTgtk_Lib +"/libgclass.a" )   // Libreria para Harbour
         else
            COPY FILE "win_libgclass_x.a" TO ( cTgtk_Lib +"/libgclass.a" ) // Libreria  para xHarbour
         endif
      else
         COPY FILE "Make.gnu" TO "../../Makefile"
         COPY FILE "gnu_libhbgtk.a" TO ( cTgtk_Lib +"/libhbgtk.a" ) // Libreria C
         if cCompiler = "HARBOUR"
            COPY FILE "gnu_libgclass.a" TO ( cTgtk_Lib +"/libgclass.a" )   // Libreria para Harbour
         else
            COPY FILE "gnu_libgclass_x.a" TO ( cTgtk_Lib +"/libgclass.a" ) // Libreria  para xHarbour
         endif
      endif

      if !file( cPath_pkg +"/gtk+-2.0.pc" ) /*Intento localizar librerias gtk */
          MsgStop( "No localizo ruta "+ cPath_pkg +" hacia pkgconfig.", "Error" )
          lError := .T.
          BREAK //return nil
       else
         if cSystem = "Windows"
            COPY FILE "tgtk_win.pc" TO ( cPath_pkg +"/tgtk.pc" )
         else
            COPY FILE "tgtk_gnu.pc" TO ( cPath_pkg +"/tgtk.pc" )
         endif
       endif
      RECOVER USING oError
             cError :=  CRLF + "Descripcion: "+ oError:description  +CRLF+;
                        "Fichero    : "+ oError:Filename     +CRLF+;
                        "Codigo Gen.: "+ alltrim(Str(oError:GenCode ))+CRLF+;
                        "SubSistema : "+ UPPER( oError:SubSystem )    +CRLF+;
                        "Codigo Sub.: "+ alltrim(STR(oError:SubCode)) +CRLF+;
                        "Operacion  : "+ oError:Operation +;
                         if( !empty( oError:OsCode ) ,( CRLF + "DOS Error: " + NTRIM( oError:osCode) + CRLF ), CRLF )
             lError := .T.
             MsgStop( cError, "Error" )
       END SEQUENCE

       ERRORBLOCK( bLastHandler )      // Restore handler

      if !lError
          MsgInfo( "Se ha terminado de configurar el sistema.", "Felicidades!!" )
      else
          MsgAlert( "Hubo una incidencia...","Alerta" )
      endif

Return nil

STATIC FUNCTION MyErrorHandler( oError )
      if ( oError:genCode == EG_ZERODIV )  // by default, division by zero yields zero
      return 0
   end
   BREAK oError      // Return error object to RECOVER
RETURN NIL



#pragma BEGINDUMP
/*
 * $Id: configurador.prg,v 1.1 2010-06-04 11:55:50 xthefull Exp $
 */
/*
    LGPL Licence.
    
    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this software; see the file COPYING.  If not, write to
    the Free Software Foundation, Inc., 59 Temple Place, Suite 330,
    Boston, MA 02111-1307 USA (or visit the web site http://www.gnu.org/).

    LGPL Licence.
    (c)2009 Riztan Gutierrez <riztan at gmail.com>
    (c)2009 Alvaro Florez <aflorezd at gmail.com>
*/

#define _CLIPDEFS_H

#include <stdio.h>   /* Standard input/output definitions */
#include <unistd.h>  /* UNIX standard function definitions */
#include <fcntl.h>   /* File control definitions */

#include <stdlib.h>
#include <limits.h>

#include "hbapi.h"
#include "hbapiitm.h"


#define SIZE PIPE_BUF

HB_FUNC( RUN2ME )
{
   FILE *file;
   char *command = hb_parc( 1 );
   char buffer[SIZE];

   PHB_ITEM aTemp = hb_itemNew( NULL );
   PHB_ITEM aNew  = hb_itemArrayNew( 0 );
   PHB_ITEM temp  = hb_itemNew( NULL );


   file = popen( command, "r" );

   while( !feof(file) )
   {

      if ( fgets( buffer , 1090 , file ) )
      {

         hb_arrayNew( aTemp, 1 );
         hb_itemPutC( temp, buffer );
         hb_arraySetForward( aTemp, 1, temp );

         hb_arrayAddForward(aNew, aTemp);

        // printf( "%s", buffer ) ;
      }

   }

   hb_itemReturnForward( aNew );

   hb_itemRelease( temp );
   hb_itemRelease( aTemp );
   hb_itemRelease( aNew );

   pclose( file );

}

HB_FUNC( RUN3ME )
{
   FILE *file;
   char *command = hb_parc( 1 );
   char buffer[SIZE];

   PHB_ITEM aRes = hb_itemArrayNew( 0 );
   PHB_ITEM temp = hb_itemNew( NULL );

   
   file = popen( command, "r" );
   
   while( !feof(file) )
   {
   
      if ( fgets( buffer , 1090 , file ) ) 
      {
      
         hb_itemPutC( temp, buffer );
         hb_arrayAdd( aRes, temp  );

         //printf( "%s", buffer ) ;
      } 
   
   }

   hb_itemReturnForward( aRes );
    
   hb_itemRelease( temp );
   hb_itemRelease( aRes );

   pclose( file );

}

#pragma ENDDUMP
