/*
 * $Id: configure.prg,v 1.1 2006-09-08 12:18:59 xthefull Exp $
 * (C) 2004-05. Rafa Carmona -TheFull-
*/

#include "gclass.ch"
#include "fileio.ch"
#include "error.ch"

#define NTRIM(n)    ( LTrim( Str( n ) ) )

STATIC cCompiler_Bin, cCompiler_Inc, cCompiler_Lib, cCompiler, cSystem, lPrint, cTgtk_Lib , cTgtk_Inc
STATIC oFile, cPath_pkg, lPrint_Win

Function Main()
   Local oWindow, oBtn, oBox, oBtn2, cFile, oPaned, oBox2, oRadio1 , oRadio2
   Local oBoxPrn, oBar, oRadio_1, oRadio_2, oBtn_Exe, oBtn_Exit, oBox_oBtn
   Local oBtn_Bin, oBtn_Inc ,oBtn_Lib, oTable, oTable2, oToggle,oBtn_Lib_Tgtk, oBtn_Inc_tgtk
   Local oBtn_Pkg, oToggleW

   DEFINE WINDOW oWindow TITLE "Configure T-GTK" SIZE 600,400
   
     DEFINE BOX oBoxPrn VERTICAL OF oWindow

       DEFINE STATUSBAR oBar TEXT "(c)2005 Rafa Carmona. System Detected:"+OS() OF oBoxPrn INSERT_END

       DEFINE PANED oPaned OF oBoxPrn EXPAND FILL
       gtk_container_set_border_width( oPaned:pWidget, 15 )
       
         DEFINE BOX oBox VERTICAL OF oPaned
            DEFINE LABEL TEXT "<b>Select a Compiler</b>" MARKUP OF oBox
            DEFINE RADIO oRadio1 TEXT "Harbour" OF oBox
            DEFINE RADIO oRadio2 GROUP oRadio1 TEXT "xHarbour" OF oBox
            DEFINE LABEL TEXT "<b>Select Compiler's directories</b>" MARKUP OF oBox

            DEFINE TABLE oTable OF oBox ROWS 3 COLS 2
            gtk_container_set_border_width( oTable:pWidget, 10 )
            
              DEFINE LABEL TEXT "Path Binary  " MARKUP ;
                   TABLEATTACH 0, 1, 0, 1 , nOR( GTK_EXPAND, GTK_FILL), GTK_FILL ;
                   HALIGN 2;
                   OF oTable

              DEFINE FILECHOOSERBUTTON oBtn_Bin ;
                   TEXT "Select Binary of Compiler" ;
                   MODE GTK_FILE_CHOOSER_ACTION_SELECT_FOLDER ;
                   TABLEATTACH 1,2,0,1, nOR( GTK_EXPAND, GTK_FILL), GTK_FILL ;
                   OF oTable

                   IF ( !Empty( cCompiler_Bin := GetEnv("HB_BIN_INSTALL") ) )
                     oBtn_Bin:SetFolder( cCompiler_Bin )
                   ENDIF

               DEFINE LABEL TEXT "Path Include  " MARKUP ;
                   TABLEATTACH 0,1,1,2,nOR( GTK_EXPAND, GTK_FILL), GTK_FILL ;
                   HALIGN 2;
                   OF oTable

               DEFINE FILECHOOSERBUTTON oBtn_Inc ;
                     TEXT "Select Include of Compiler" ;
                     MODE GTK_FILE_CHOOSER_ACTION_SELECT_FOLDER ;
                     TABLEATTACH 1,2,1,2, nOR( GTK_EXPAND, GTK_FILL), GTK_FILL ;
                     OF oTable

                     IF ( !Empty( cCompiler_Inc := GetEnv("HB_INC_INSTALL") ) )
                        oBtn_Inc:SetFolder( cCompiler_Inc )
                     ENDIF

               DEFINE LABEL TEXT "Path Libray  " MARKUP ;
                    TABLEATTACH 0,1,2,3, nOR( GTK_EXPAND, GTK_FILL), GTK_FILL ;
                    HALIGN 2;
                    OF oTable

               DEFINE FILECHOOSERBUTTON oBtn_Lib ;
                     TEXT "Select Library of Compiler" ;
                     MODE GTK_FILE_CHOOSER_ACTION_SELECT_FOLDER ;
                     TABLEATTACH 1,2,2,3 , nOR( GTK_EXPAND, GTK_FILL), GTK_FILL ;
                     OF oTable

                  IF ( !Empty( cCompiler_Lib := GetEnv("HB_LIB_INSTALL") ) )
                     oBtn_Lib:SetFolder( cCompiler_Lib )
                  ENDIF
            /* Seleccionamos compilador por defecto segun algun HB_*/
            IF "XHARBOUR" $ UPPER( cCompiler_bin )
               oRadio2:SetState( TRUE )
            ENDIF

            DEFINE BOX oBox2 VERTICAL OF oPaned SECOND_PANED
               DEFINE LABEL TEXT "<b>Select an Operating System</b>" MARKUP OF oBox2
               DEFINE RADIO oRadio_1 TEXT "GNU/Linux" ;
                      OF oBox2

               DEFINE RADIO oRadio_2 GROUP oRadio_1 ;
                       TEXT "M.Windows" OF oBox2

               DEFINE LABEL TEXT "<b>Directories for T-GTK and PKG-CONFIG tool by GTK+</b>" MARKUP OF oBox2
               DEFINE TABLE oTable2 OF oBox2 ROWS 3 COLS 2
                 
                  DEFINE LABEL TEXT "Path T-GTK Libs  " MARKUP ;
                        TABLEATTACH 0, 1, 0, 1 , nOR( GTK_EXPAND, GTK_FILL), GTK_FILL ;
                        HALIGN 2;
                        OF oTable2

                  DEFINE FILECHOOSERBUTTON oBtn_Lib_Tgtk ;
                        TEXT "Select Library of T-GTK" ;
                        MODE GTK_FILE_CHOOSER_ACTION_SELECT_FOLDER ;
                        TABLEATTACH 1,2,0,1 , nOR( GTK_EXPAND, GTK_FILL), GTK_FILL ;
                        OF oTable2

                   DEFINE LABEL TEXT "Path T-GTK Include  " MARKUP ;
                        TABLEATTACH 0,1,1,2, nOR( GTK_EXPAND, GTK_FILL), GTK_FILL ;
                        HALIGN 2;
                        OF oTable2

                   DEFINE FILECHOOSERBUTTON oBtn_Inc_Tgtk ;
                         TEXT "Select Include of T-GTK" ;
                         MODE GTK_FILE_CHOOSER_ACTION_SELECT_FOLDER ;
                         TABLEATTACH 1,2,1,2,nOR( GTK_EXPAND, GTK_FILL), GTK_FILL ;
                         OF oTable2
                  
                   DEFINE LABEL TEXT "Path files Pkg-Config tool " MARKUP ;
                          TABLEATTACH 0,1,2,3, nOR( GTK_EXPAND, GTK_FILL), GTK_FILL ;
                          HALIGN 2;
                          OF oTable2

                   DEFINE FILECHOOSERBUTTON oBtn_Pkg ;
                          TEXT "Select files of PkgConfig" ;
                          MODE GTK_FILE_CHOOSER_ACTION_SELECT_FOLDER ;
                          TABLEATTACH 1,2,2,3 , nOR( GTK_EXPAND, GTK_FILL), GTK_FILL ;
                          OF oTable2

                DEFINE LABEL TEXT "<b>PRINTER under GNU/LINUX</b>" MARKUP OF oBox2 HALIGN LEFT
                DEFINE TOGGLE oToggle TEXT "Support Gnome-Print" OF oBOX2
                
                DEFINE LABEL TEXT "<b>PRINTER under WINDOWS</b>" MARKUP OF oBox2 HALIGN LEFT
                DEFINE TOGGLE oToggleW TEXT "Support Gnome-Print" OF oBOX2

             DEFINE BOX oBox_oBtn OF oBoxPrn HOMO
                DEFINE BUTTON oBtn_Exe ;
                       FROM STOCK GTK_STOCK_EXECUTE ;
                       ACTION ( cSystem   := IIF(  oRadio_1:GetActive(), "GNU/Linux", "Windows"),;
                                cCompiler := IIF(  oRadio1:GetActive(),  "HARBOUR", "XHARBOUR" ),;
                                lPrint := oToggle:GetActive(),;
                                lPrint_Win := oToggleW:GetActive(),;
                                cCompiler_Bin := oBtn_Bin:GetFolder(),;
                                cCompiler_Inc := oBtn_Inc:GetFolder(),;
                                cCompiler_Lib := oBtn_Lib:GetFolder(),;
                                cTgtk_Lib := oBtn_Lib_Tgtk:GetFolder(),;
                                cTgtk_Inc := oBtn_Inc_Tgtk:GetFolder(),;
                                cPath_Pkg := oBtn_Pkg:GetFolder(),;
                                CreateRules( ) ) OF oBox_oBtn EXPAND FILL

                DEFINE BUTTON oBtn_Exit;
                       FROM STOCK GTK_STOCK_QUIT ;
                       MNEMONIC ;
                       ACTION oWindow:End() OF oBox_oBtn ;
                       EXPAND FILL

            /* Si el sistema es windows, determinado posible ruta hacia pkhg-config*/ 
            if "WIN" $ UPPER( OS() )
                oRadio_2:SetState( TRUE )
               // TODO: SET "PKG_CONFIG_PATH" tenerlo en cuenta, de momento nada
                cPath_pkg := GetEnv( "GTK_BASEPATH" ) 
                if Empty ( cPath_Pkg )
                  cPath_pkg := "c:/gtk/lib/pkgconfig"
                else
                  cPath_pkg += "/lib/pkgconfig"
                endif
            else
                cPath_pkg := "/usr/lib/pkgconfig"
            endif
            
            oBtn_Pkg:SetFolder( cPath_Pkg )
          
           /* Damos tiempo para que se monten correctamente los filechooser en su sitio. */           
           SysRefresh() 

   ACTIVATE WINDOW oWindow CENTER

Return NIL

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
      oFile:WriteLn("# (c)2004-05 Rafa Carmona.")
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

