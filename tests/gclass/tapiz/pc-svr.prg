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
    (c)2007 Federico de Maussion <fj_demaussion@yahoo.com.ar>
*/

#include "hbclass.ch"
#include "gclass.ch"
#include "dbstruct.ch"
#include "pc-soft.ch"


#define GTK_WRAP_WORD       2
#define GTK_TEXT_DIR_RTL    2

#define PANGO_STYLE_ITALIC  2
//#define PANGO_SCALE         1024

Static oApp

// Para no cargar el ejecutable con las RDD
ANNOUNCE RDDSYS

REQUEST HB_LANG_ES
REQUEST HB_CODEPAGE_UTF8 

// --------------------------------------------------------------------------------------- //
//EXTERNAL ORDKEYCOUNT, ORDKEYNO
//REQUEST DBFCDX
// --------------------------------------------------------------------------------------- //
FUNCTION Main()
//   RddSetDefault( "DBFCDX" )
   HB_CDPSELECT("UTF8")

   oApp := TApp():New()
   oApp:Activar()

RETURN .T.

//------------------------------------------------- //
FUNCTION GetAplic()

RETURN  oApp 

// --------------------------------------------------------------------------------------- //
CLASS TApp
   DATA oWin
   DATA oBoxMenu, oBox, oBox1
   DATA oToolBar
   DATA oFont
   DATA oStatus
   DATA oProtec
   DATA oIni
   DATA oImage, oBook
   DATA oDraw, aDraw, aReport

   DATA oBmp
   DATA cPass
   DATA oFondo
   DATA oLogo
   DATA oTmr
   DATA oIcon

   DATA oRegistro
   DATA cNombre
   DATA cDireccion
   DATA cTelefono
   DATA cGiro

   DATA cEmpresa
   DATA cAutor
   DATA cMail
   DATA cSistema
   DATA cBuild
   DATA cVer

   DATA oServer
   DATA cServer
   DATA nPort
   DATA cUser
   DATA cPass
   DATA cDataBase
   DATA cTabla
   DATA cTemes
   DATA nPagina
   DATA cPDF, cParamPDF
   DATA oFondo

   METHOD New() CONSTRUCTOR
   METHOD Menu( oBoxMenu )
   METHOD ToolBar(  )
   METHOD Init()
   METHOD Activar()
   METHOD Logo()
   METHOD Cerrar()
   METHOD Debug()
   METHOD About()
   METHOD Themes()
   METHOD Servidor( ) 
END CLASS

METHOD New() CLASS TApp
   LOCAL oPanel, oTool, oImg1, oTitu

   ::oIni     := PC_Ini():New("./pcsvr.cfg")
   ::cSistema := "PC - SVR"
   ::cVer     := "0.1.2a"
   ::cBuild   := "Build 111010"
   ::cEmpresa := "PC - Soft"
   ::cAutor   := "Federico de Maussion"
   //::cAutor  := "PC-Soft (c) 1991 - 2009"
   ::cMail    := "fj_demaussion@yahoo.com.ar"
   ::oImage := {,}

   ::cDataBase := "startsvr"

   DEFINE FONT ::oFont NAME "Tahoma 12"

//   ::oIcon := gdk_pixbuf_new_from_file( "./pcsoft.ico" )
   ::oIcon := "pcsoft.ico"

   ::Init()


   DEFINE WINDOW ::oWin    ;
      SIZE 600,400 ;
      TITLE ::cSistema + "  -  " + ::cVer

   gtk_window_set_icon(::oWin:pWidget, ::oIcon)
   ::oWin:SetBorder( 3 )

   DEFINE BOX ::oBoxMenu VERTICAL OF ::oWin

   ::Menu(  )

   DEFINE BOX ::oBox VERTICAL OF ::oBoxMenu EXPAND FILL

   DEFINE TOOLBAR ::oToolBar OF ::oBox STYLE GTK_TOOLBAR_ICONS

   ::ToolBar(  )

   DEFINE NOTEBOOK ::oBook OF ::oBox EXPAND FILL
   ::oBook:ShowTabs( .f. )
   ::oBook:ShowBorder( .f. )

   DEFINE BOX ::oBox1 VERTICAL EXPAND FILL

   DEFINE LABEL oTitu PROMPT "Inicio"
   ::oBook:Append( ::oBox1, oTitu )
   
   ::oFondo := PCTapiz():New( ::oBox1 )
   ::oFondo:Imagen( ::oIni:Get( "EMPRESA", "LOGO", "pixmaps/logo.png" ), pcEstirado, pcEstirado )
   ::oFondo:Imagen( "pixmaps/logo2a.png", pcAbajo, pcCentrado )
   
   ::oFondo:Imagen( "pixmaps/logo2a.png", pcAbajo, pcizquierda )
   ::oFondo:Imagen( "pixmaps/logo2a.png", pcAbajo, pcderecha )
   ::oFondo:Imagen( "pixmaps/logo2a.png", pcCentrado, pcizquierda )
   ::oFondo:Imagen( "pixmaps/logo2a.png", pcCentrado, pcCentrado )
   ::oFondo:Imagen( "pixmaps/logo2a.png", pcCentrado, pcderecha )
   ::oFondo:Imagen( "pixmaps/logo2a.png", pcArriba, pcizquierda )
   ::oFondo:Imagen( "pixmaps/logo2a.png", pcArriba, pcCentrado )
   ::oFondo:Imagen( "pixmaps/logo2a.png", pcArriba, pcderecha )
   ::oFondo:Active( )

/*
  ::oImage[1] := gdk_pixbuf_new_from_file( ::oIni:Get( "EMPRESA", "LOGO", "pixmaps/logo.png" ) )
  ::oImage[2] := gdk_pixbuf_new_from_file( "pixmaps/logo2a.png" )

   DEFINE DRAWINGAREA ::oDraw ;
          EXPOSE EVENT    Dibuja( oSender,pEvent, Self );
          CONFIGURE EVENT Configure_event( oSender,pEvent, Self );
          OF ::oBox1 EXPAND FILL //CONTAINER
*/
RETURN Self

// ------------------------------------------------------------------------ //

METHOD ToolBar(  ) CLASS TApp
   Local oToolButton[17], oImage

   DEFINE PCTOOLBUTTON ;
          TEXT UTF_8( "Empresas" );
          IMAGE "pixmaps/empresa.png";
          /*ACTION CrgEmpre():New()*/ ;
          TOOLTIP "Empresas...";
          OF ::oToolBar


   DEFINE PCTOOLBUTTON   ;
          TEXT UTF_8( "Cliente" );
          IMAGE "pixmaps/cliente.png" ;
          /*ACTION CrgEmpleado():New()*/ ;
          TOOLTIP "Empleados..." ;
          OF ::oToolBar

   DEFINE PCTOOLBUTTON  ;
          TEXT UTF_8( "Liquidación" );
          IMAGE "pixmaps/venta.png";
          TOOLTIP "Liq. de Haberes...";
          /*ACTION GenLiqui():New()*/ ;
          OF ::oToolBar

   DEFINE TOOL SEPARATOR OF ::oToolBar

   DEFINE PCTOOLBUTTON oToolButton[6]  ;
          TEXT UTF_8( "Estilo" );
          IMAGE "pixmaps/style1.png";
          TOOLTIP "Estilo...";
          ACTION ::Themes( ) ;
          OF ::oToolBar

   DEFINE PCTOOLBUTTON oToolButton[7]  ;
          TEXT UTF_8( "Sobre el Autor" );
          IMAGE "pixmaps/info.png";
          TOOLTIP "Sobre del Autor...";
          ACTION ::About() ;
          OF ::oToolBar

   DEFINE TOOL SEPARATOR EXPAND OF ::oToolBar

   DEFINE PCTOOLBUTTON oToolButton[8]  ;
          TEXT UTF_8( "Salir" );
          IMAGE "pixmaps/salir.png";
          TOOLTIP "Salir...";
          ACTION ::oWin:End();
          OF ::oToolBar
/*
   DEFINE PCTOOLBUTTON   ;
          TEXT UTF_8( "Fact. Compras" );
          IMAGE "pixmaps/compra.png";
          TOOLTIP "Fact. Compras...";
          ACTION VerError() ;
          OF ::oToolBar
*/

RETURN Self

// ------------------------------------------------------------------------ //

METHOD Menu(  ) CLASS TApp
    Local oMenuBar, oMenu, oMenuitem, oSubMenu, oMenuItem2, Tearoff
    Local oFont, oMi,oMiMenu,A

   // DEFINE FONT oFont NAME "Arial 12"

    // Defino barra de menus
    DEFINE BARMENU oMenuBar OF ::oBoxMenu
    MENUBAR oMenu OF oMenuBar
      MENUITEM ROOT oMenuItem TITLE "_Daily" MNEMONIC OF oMenu
        MENUITEM oMenuItem2 TITLE "Work Screen" OF oMenu
          SUBMENU oSubMenu OF oMenuItem2
            MENUITEM TITLE "To Post A Payment" /*ACTION CrgEmDor():New()*/ OF oSubMenu
            MENUITEM TITLE "Get Existing Estimate" /*ACTION CrgTipoDoc():New()*/ OF oSubMenu
            MENUITEM TITLE "Make New Repair Order" /*ACTION CrgTipoDoc():New()*/ OF oSubMenu
            MENUITEM TITLE "Active Repair Order" /*ACTION CrgTipoDoc():New()*/ OF oSubMenu
            MENUITEM TITLE "Parts Repair Orders" /*ACTION CrgTipoDoc():New()*/ OF oSubMenu
            MENUITEM TITLE "Recover Repair Order" /*ACTION CrgTipoDoc():New()*/ OF oSubMenu
            MENUITEM TITLE "Blank Repair Order" /*ACTION CrgTipoDoc():New()*/ OF oSubMenu

        MENUITEM TITLE "Closeout" /*ACTION CrgTipoDoc():New()*/ OF oMenu
        MENUITEM TITLE Utf_8("Today's Sales") /*ACTION CrgContrato():New()*/ OF oMenu
        MENUITEM TITLE "Special Accnts" /*ACTION CrgEstadoCivil():New()*/ OF oMenu
        MENUITEM TITLE Utf_8("Write Envelope") /*ACTION CrgRevista():New()*/ OF oMenu
        MENUITEM TITLE Utf_8("Quick Editor") /*ACTION CrgCondicion():New()*/ OF oMenu
        MENU SEPARATOR OF oMenu
        MENUITEM TITLE "Quit" ACTION ::oWin:End() OF oMenu

    ACTIVATE MENUBAR oMenu

    MENUBAR oMenu OF oMenuBar
      MENUITEM ROOT oMenuItem TITLE "_Management" MNEMONIC OF oMenu
        MENUITEM TITLE "Customize" /*ACTION CrgEmpre():New()*/ OF oMenu
        MENUITEM TITLE Utf_8("Add/Edit Password") /*ACTION CrgEmAct():New()*/ OF oMenu
        MENUITEM oMenuItem2 TITLE "Maintenance" OF oMenu
          SUBMENU oSubMenu OF oMenuItem2
            MENUITEM TITLE "Clean/Pack Files" /*ACTION CrgTipoDoc():New()*/ OF oSubMenu
            MENUITEM TITLE "Purge History " /*ACTION CrgTipoDoc():New()*/ OF oSubMenu
            MENUITEM TITLE "System Environment" /*ACTION CrgTipoDoc():New()*/ OF oSubMenu
            MENUITEM TITLE "File Editor" /*ACTION CrgTipoDoc():New()*/ OF oSubMenu
            MENUITEM TITLE "Convert Delimited" /*ACTION CrgTipoDoc():New()*/ OF oSubMenu
            

        MENUITEM TITLE "Add/Edit Employees" /*ACTION CrgCCosto():New()*/ OF oMenu
        MENUITEM TITLE Utf_8("Scheduling") /*ACTION CrgConcepto():New()*/ OF oMenu
        MENUITEM TITLE Utf_8("Add/Edit Job Codes") /*ACTION CrgCargo():New()*/ OF oMenu
        MENUITEM TITLE Utf_8("Add/Edit Locator Codes") /*ACTION CrgLiqEstandar():New()*/ OF oMenu
        MENUITEM TITLE Utf_8("Add/Edit Vendors") /*ACTION CrgLiqEstandar():New()*/ OF oMenu
        MENUITEM TITLE Utf_8("Vendors List") /*ACTION CrgLiqEstandar():New()*/ OF oMenu
        MENUITEM TITLE Utf_8("Track Play") /*ACTION CrgLiqEstandar():New()*/ OF oMenu

    ACTIVATE MENUBAR oMenu

    MENUBAR oMenu OF oMenuBar
      MENUITEM ROOT oMenuItem TITLE "_Inventary" MNEMONIC OF oMenu
        MENUITEM TITLE Utf_8("Receive Products") /*ACTION CrgLiqEstandar():New()*/ OF oMenu
        MENUITEM TITLE Utf_8("Add/Edit Inventary") /*ACTION CrgLiqEstandar():New()*/ OF oMenu
        MENUITEM TITLE Utf_8("Price History") /*ACTION CrgLiqEstandar():New()*/ OF oMenu
        MENUITEM TITLE Utf_8("View Prices") /*ACTION CrgLiqEstandar():New()*/ OF oMenu
        MENUITEM oMenuItem2 TITLE Utf_8("Inventary List") OF oMenu
          SUBMENU oSubMenu OF oMenuItem2
            MENUITEM TITLE "Order Parts" /*ACTION CrgTipoDoc():New()*/ OF oSubMenu
            MENUITEM TITLE "Edit Orders" /*ACTION CrgTipoDoc():New()*/ OF oSubMenu
            MENUITEM TITLE "Receive Orders " /*ACTION CrgTipoDoc():New()*/ OF oSubMenu
            MENUITEM TITLE "Purchase History" /*ACTION CrgTipoDoc():New()*/ OF oSubMenu
            
        MENUITEM oMenuItem2 TITLE Utf_8("Charged Purchases") OF oMenu
          SUBMENU oSubMenu OF oMenuItem2
            MENUITEM TITLE "Enter Charge Purchases" /*ACTION CrgTipoDoc():New()*/ OF oSubMenu
            MENUITEM TITLE "Print Charge Purchases" /*ACTION CrgTipoDoc():New()*/ OF oSubMenu
            MENUITEM TITLE "Delete Charge Purchases" /*ACTION CrgTipoDoc():New()*/ OF oSubMenu
            
        MENUITEM TITLE Utf_8("Motor Databases") /*ACTION CrgLiqEstandar():New()*/ OF oMenu
        MENUITEM oMenuItem2 TITLE Utf_8("Utilities") OF oMenu
          SUBMENU oSubMenu OF oMenuItem2
            MENUITEM TITLE "PBR Brake Pads" /*ACTION CrgTipoDoc():New()*/ OF oSubMenu
            MENUITEM TITLE "Filters Lookup" /*ACTION CrgTipoDoc():New()*/ OF oSubMenu
            MENUITEM TITLE "dbase utility" /*ACTION CrgTipoDoc():New()*/ OF oSubMenu

    ACTIVATE MENUBAR oMenu

    MENUBAR oMenu OF oMenuBar
      MENUITEM ROOT oMenuItem TITLE Utf_8("_Reports") MNEMONIC OF oMenu
        MENUITEM TITLE Utf_8("Invoice Search") /*ACTION GenLiqui():New()*/ OF oMenu
        MENUITEM oMenuItem2 TITLE "Sales Report"  OF oMenu
          SUBMENU oSubMenu OF oMenuItem2
            MENUITEM TITLE "Sales Summary" /*ACTION CrgTipoDoc():New()*/ OF oSubMenu
            MENUITEM TITLE "Sales By Technician" /*ACTION CrgTipoDoc():New()*/ OF oSubMenu
            MENUITEM TITLE "Sales By Unit" /*ACTION CrgTipoDoc():New()*/ OF oSubMenu
            MENUITEM TITLE "General Auto" /*ACTION CrgTipoDoc():New()*/ OF oSubMenu

        MENUITEM TITLE "Customer List"            /*ACTION GenResumen():New( )*/     OF oMenu
        MENUITEM TITLE "Work to do List"            /*ACTION ResuLiq():New( )*/     OF oMenu
        MENUITEM TITLE "Job Code List"            /*ACTION ReImpRecibo():New( )*/     OF oMenu
        MENUITEM TITLE "Report Writer"     /*ACTION tCierre():New( )*/     OF oMenu
        MENUITEM TITLE "Service Due"     /*ACTION tCierre():New( )*/     OF oMenu
        MENUITEM TITLE "Query"     /*ACTION tCierre():New( )*/     OF oMenu

    ACTIVATE MENUBAR oMenu

    MENUBAR oMenu OF oMenuBar
      MENUITEM ROOT oMenuItem TITLE Utf_8("_Customers") MNEMONIC OF oMenu
        MENUITEM TITLE "Customer Info"        /*ACTION lAltaBaja( ):New( .f. )*/  OF oMenu
        MENUITEM TITLE "Add Customer"        /*ACTION lAltaBaja( ):New( .t. )*/  OF oMenu
        MENUITEM TITLE "Transfer Car"  /*ACTION lEmpComp( ):New( )*/       OF oMenu
        MENUITEM TITLE "Delete Cust."  /*ACTION lEmpComp( ):New( )*/       OF oMenu
        MENUITEM TITLE "Balance Due"  /*ACTION lEmpComp( ):New( )*/       OF oMenu
        MENUITEM TITLE "Postcards"  /*ACTION lEmpComp( ):New( )*/       OF oMenu

    ACTIVATE MENUBAR oMenu

    MENUBAR oMenu OF oMenuBar
      MENUITEM ROOT oMenuItem TITLE "_Help" MNEMONIC OF oMenu
        MENUITEM TITLE "Manual"  ACTION MyPrint( "Ayuda/Manual.pdf",  ) OF oMenu
        MENUITEM TITLE "Version"  ACTION MyInfo( Utf_8( CRLF + CRLF +"Información General de la Applicación" + CRLF +;
                                                 "-------------------------------------" + CRLF +;
                                                 "   Sistema           : " + ::cSistema + "   " + CRLF +;
                                                 "   Versión           : " + ::cVer + "   " + CRLF + CRLF +;
                                                 "   Sistema Operativo : " + Os() + CRLF +;
                                                 "   Estación          : " + NETNAME() + "   " + CRLF + CRLF +;
                                                 "   Compilador Versión: " + version() + CRLF +;
                                                 "   Compilador Build  : " + hb_builddate() + CRLF +;
                                                 "   Cmpilador C/C++   : " + hb_compiler() + CRLF +;
                                                 "   Librería Gtk Ver. : " + MyGtk_Version() + CRLF + CRLF +;
                                                 "   Multi Threading   : " + If( Hb_MultiThread(),"Sí","No" )  + CRLF +;
                                                 "   VM Optimización   : " + Alltrim( str( Hb_VmMode() ) ) + CRLF + CRLF ;
                                                 ) ) OF oMenu
        MENUITEM TITLE "Acerca de ..."  ACTION ::About() OF oMenu

    ACTIVATE MENUBAR oMenu

Return NIL

// ------------------------------------------------------------------------ //

METHOD Logo()
   //MsgAbout( ::cTitulo, ::cNombre )
RETURN NIL

// ------------------------------------------------------------------------ //
METHOD Init()

   CLOS ALL
   SET DELE ON
   SET WRAP ON
   SET SCOR OFF
   SET BELL OFF
   SET SOFT ON
   SET EXCL OFF
   SET DECI TO 2
   SET DATE FORMAT TO "dd/mm/yyyy"
   SET CENTURY ON
   SET EPOCH TO ( YEAR( DATE() ) - 50 )
   SET Delete On

   HB_LANGSELECT("ES")

  DEFAULT ::cPass   := Space(30)

  ::cUser   := ::oIni:Get( "CONECCION", "USUARIO", "root" )
  ::cServer := ::oIni:Get( "CONECCION", "SERVER",  "localhost")
  ::nPort   := ::oIni:Get( "CONECCION", "PUERTO", 3306 )

  ::nPagina   := ::oIni:Get( "LIBRO", "PAGINA", 3306 )

  ::cTemes  := ::oIni:Get( "TEMES", "TEMA", "Ghrome" )
  ::cPDF  := ::oIni:Get( "UTILIDADES", "LECPDF", "evince" )
  ::cParamPDF  := ::oIni:Get( "UTILIDADES", "COMPAG", "" )

RETURN NIL

// ------------------------------------------------------------------------ //

METHOD Activar() CLASS TApp
  LOCAL dDia1 := DATE()
  LOCAL dDia2 := DATE()
  LOCAL cRegistro := " U l t i m a t e  E u r o  R e p a i r s ", oKey

  DEFAULT ::cPass   := Space(30)

  ::cUser   := ::oIni:Get( "CONECCION", "USUARIO", "root" )
  ::cServer := ::oIni:Get( "CONECCION", "SERVER",  "localhost")
  ::nPort   := ::oIni:Get( "CONECCION", "PUERTO", 3306 )

  ::nPagina   := ::oIni:Get( "LIBRO", "PAGINA", 3306 )

  ::cTemes  := ::oIni:Get( "TEMES", "TEMA", "Ghrome" )
  ::cPDF  := ::oIni:Get( "UTILIDADES", "LECPDF", "evince" )
  ::cParamPDF  := ::oIni:Get( "UTILIDADES", "COMPAG", "" )

//  If ::Servidor()
//    ConfigDB( )

    if !Empty(::cTemes)
      Aplica_themes( ::cTemes )
    end
    cRegistro := "© 2007, PC-Soft -   " + cRegistro

    DEFINE STATUSBAR ::oStatus TEXT UTF_8(cRegistro) INSERT_END OF ::oBoxMenu

    ACTIVATE WINDOW ::oWin CENTER  VALID ::Cerrar()


    ::cServer := Alltrim(::cServer)
    ::cPass   := Alltrim(::cPass)
    ::cUser   := Alltrim(::cUser)

    ::oIni:Set( "CONECCION", "USUARIO", ::cUser )
    ::oIni:Set( "CONECCION", "SERVER", ::cServer )
    ::oIni:Set( "CONECCION", "PUERTO", ::nPort  )

    ::oIni:Set( "TEMES", "TEMA", ::cTemes )

    ::oIni:Set( "LIBRO", "PAGINA", ::nPagina  )
    ::oIni:Set( "UTILIDADES", "LECPDF", ::cPDF )
    ::oIni:Set( "UTILIDADES", "COMPAG", ::cParamPDF )
//  End

RETURN NIL

// ------------------------------------------------------------------------ //

METHOD Cerrar() CLASS TApp
  Local nP := ::oBook:GetCurrentPage( )

  ::oIni:Set( "TEMES", "TEMA", ::cTemes )
  ::oIni:Save()

  ::oBook:Next()
  if ::oBook:GetCurrentPage <= 1

    Return .t.
  End
  ::oBook:SetCurrentPage( nP )

RETURN MsgNoYes( utf_8("Desea Salir de la Aplicación"), "Cerrar" )

// ------------------------------------------------------------------------ //

METHOD Servidor(  ) CLASS TApp
   LOCAL cResource, lAcceso := .F.
   LOCAL oWnd, oBtnAcep, oBtnCanc
   LOCAL oLabel, oGet := {,,,}
   Local hBox, vBox, vBox1, hBox1, oImage
   Local oBtn, oTable,oExpander

   DEFINE WINDOW oWnd TITLE Utf_8("Autentificación")

   gtk_window_set_icon(oWnd:pWidget, ::oIcon)
   oWnd:SetBorder( 8 )

   DEFINE BOX hBox  OF oWnd HOMO EXPAND //FILL
     DEFINE BOX vBox VERTICAL OF hBox //EXPAND FILL

       DEFINE IMAGE oImage FILE "pixmaps/gnome-lockscreen.png" OF vBox EXPAND FILL
       DEFINE EXPANDER oExpander  PROMPT "<b>Preferencias</b>" MARKUP  OF vBox  EXPAND FILL
          DEFINE TABLE oTable ROWS 2 COLS 2 OF oExpander
             DEFINE LABEL PROMPT "Servidor" of oTable TABLEATTACH 0,1,0,1 
             DEFINE LABEL PROMPT "Puerto" of oTable TABLEATTACH 0,1,1,2 
             DEFINE ENTRY oGet[3] VAR ::cServer  of oTable TABLEATTACH 1,2,0,1
             DEFINE ENTRY oGet[4] VAR ::nPort  of oTable TABLEATTACH 1,2,1,2

     DEFINE BOX vBox1 VERTICAL OF hBox EXPAND FILL

       DEFINE LABEL PROMPT "<b>Usuario</b>" MARKUP OF vBox1 EXPAND FILL
       DEFINE ENTRY oGet[1] VAR ::cUser  OF vBox1 EXPAND FILL
       DEFINE LABEL PROMPT Utf_8("<b>Contraseña</b>") MARKUP OF vBox1 EXPAND FILL
       DEFINE ENTRY oGet[2] VAR ::cPass PASSWORD OF vBox1 EXPAND FILL

       DEFINE BOX hBox1 OF vBox1 HOMO EXPAND FILL
            DEFINE BUTTON oBtn OF hBox1 EXPAND FILL ;
                  ACTION ( IF( Check( Self ),( lAcceso := .T., oWnd:End() ), ) )
                DEFINE IMAGE oImage FILE "pixmaps/gtk-apply.png" OF oBtn CONTAINER EXPAND FILL

            DEFINE BUTTON oBtn OF hBox1 EXPAND FILL ACTION ( lAcceso := .F., oWnd:End() )
                DEFINE IMAGE oImage FILE "pixmaps/gtk-cancel.png" OF oBtn CONTAINER EXPAND FILL


      oGet[1]:SetText(::cUser)
//      oGet[2]:SetText(::cPass)
      oGet[3]:SetText(::cServer)
      oGet[4]:SetText(::nPort)
   oWnd:SetResizable( .f. )

    ACTIVATE WINDOW oWnd CENTER

   ::cServer := Alltrim(::cServer)
   ::cPass   := Alltrim(::cPass)
   ::cUser   := Alltrim(::cUser)

RETURN lAcceso

//-------------------------------------------------

FUNCTION Check( Self )
Local lDev := .f.
  lDev := .t.

RETURN lDev

// ---------------------------------------------------------------------

METHOD About() CLASS TApp
   Local oWnd, oImage, oText, oButon
   Local oBoxV, oBoxH, oBox2, oBook, oTitu, oScroll
   Local oTextView, oTextView1, oTextView2
   Local cText, cText2, oFont
   Local nWhere := 1
   Local aStart := Array( 14 )

   DEFINE FONT oFont NAME "Arial italic 10"

   cText := CRLF + CRLF + ;
            ::cSistema + ",   Sistema Integral" + CRLF + ;
            "Versión "+::cVer+CRLF + CRLF + ;
            "(c) 1991 - 2007 PC-Soft Soluciones Informáticas  "+ CRLF + ;
            ""+::cAutor+CRLF + CRLF + ;
            "Teléfono: +54 ( 03521 ) - 421325     " + CRLF + ;
            "          +54 9 ( 03521 ) 15 - 470965" + CRLF + CRLF + ;
            "Deán Funes - Córdoba - Argentina" + CRLF + CRLF + CRLF + ;
            ::cMail + CRLF + CRLF

   DEFINE WINDOW oWnd TITLE "Acerca de.."  SIZE 600,300

   gtk_window_set_transient_for( oWnd:pWidget, ::oWin:pWidget )  
   gtk_window_set_icon(oWnd:pWidget, ::oIcon)
   oWnd:SetBorder( 5 )

     DEFINE BOX oBoxH OF oWnd EXPAND FILL
       DEFINE IMAGE oImage FILE "pixmaps/logo.gif" OF oBoxH

      DEFINE BOX oBox2 VERTICAL OF oBoxH EXPAND FILL
      DEFINE NOTEBOOK oBook OF oBox2 EXPAND FILL
      DEFINE BOX oBoxV VERTICAL EXPAND FILL
      DEFINE LABEL oTitu PROMPT "Autor"
      oBook:Append( oBoxV, oTitu )
//      oBook:ShowBorder( .f. )
        DEFINE SCROLLEDWINDOW oScroll OF oBoxV CONTAINER
          oScroll:SetPolicy( GTK_POLICY_AUTOMATIC, GTK_POLICY_AUTOMATIC )
          DEFINE TEXTVIEW oTextView2 VAR cText2 READONLY OF oScroll CONTAINER

    oTextView2:oBuffer:GetIterAtOffSet( aStart, -1 )
    oTextView2:CreateTag( "heading", {  "style", PANGO_STYLE_ITALIC, ;
                                        "justification", GTK_JUSTIFY_CENTER } )

   oTextView2:Insert_Tag( Utf_8( cText ) , "heading", aStart  )
//           DEFINE LABEL PROMPT Utf_8(cText) MARKUP OF oBoxV FONT oFont EXPAND FILL
//           DEFINE LABEL  PROMPT ::cMail of oBoxV EXPAND

      DEFINE BOX oBoxV VERTICAL EXPAND FILL
      DEFINE LABEL oTitu PROMPT "Licencia"
      oBook:Append( oBoxV, oTitu )

        DEFINE SCROLLEDWINDOW oScroll OF oBoxV CONTAINER
          oScroll:SetPolicy( GTK_POLICY_AUTOMATIC, GTK_POLICY_AUTOMATIC )
          DEFINE TEXTVIEW oTextView1 VAR cText READONLY OF oScroll CONTAINER


   oTextView1:Insert( "     "+ CRLF )
   oTextView1:Insert( "     "+ CRLF )
   oTextView1:Insert( "      Copyright (C) 2007, Federico de Maussion"+ CRLF )
   oTextView1:Insert( "     "+ CRLF )
   oTextView1:Insert( "      LGPL Licence."+ CRLF )
   oTextView1:Insert( "     "+ CRLF )
   oTextView1:Insert( "      This program is free software; you can redistribute it and/or modify"+ CRLF )
   oTextView1:Insert( "      it under the terms of the GNU General Public License as published by"+ CRLF )
   oTextView1:Insert( "      the Free Software Foundation; either version 2 of the License, or"+ CRLF )
   oTextView1:Insert( "      (at your option) any later version."+ CRLF )
   oTextView1:Insert( "     "+ CRLF )
   oTextView1:Insert( "      This program is distributed in the hope that it will be useful,"+ CRLF )
   oTextView1:Insert( "      but WITHOUT ANY WARRANTY; without even the implied warranty of"+ CRLF )
   oTextView1:Insert( "      MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the"+ CRLF )
   oTextView1:Insert( "      GNU General Public License for more details."+ CRLF )
   oTextView1:Insert( "     "+ CRLF )
   oTextView1:Insert( "      You should have received a copy of the GNU General Public License"+ CRLF )
   oTextView1:Insert( "      along with this software; see the file COPYING.  If not, write to"+ CRLF )
   oTextView1:Insert( "      the Free Software Foundation, Inc., 59 Temple Place, Suite 330,"+ CRLF )
   oTextView1:Insert( "      Boston, MA 02111-1307 USA"+ CRLF )
   oTextView1:Insert( "      (or visit the web site http://www.gnu.org/)."+ CRLF )
   oTextView1:Insert( "     "+ CRLF)
   oTextView1:Insert( "     "+ CRLF )


      DEFINE BOX oBoxV VERTICAL EXPAND FILL
      DEFINE LABEL oTitu PROMPT "Licencia Traducida"
      oBook:Append( oBoxV, oTitu )

        DEFINE SCROLLEDWINDOW oScroll OF oBoxV CONTAINER
          oScroll:SetPolicy( GTK_POLICY_AUTOMATIC, GTK_POLICY_AUTOMATIC )
          DEFINE TEXTVIEW oTextView VAR cText READONLY OF oScroll CONTAINER



   oTextView:Insert( "     "+ CRLF )
   oTextView:Insert( "     "+ CRLF )
   oTextView:Insert( "      Copyright (C) 2007, Federico de Maussion"+ CRLF )
   oTextView:Insert( "     "+ CRLF )
   oTextView:Insert( "      Licencia LGPL."+ CRLF )
   oTextView:Insert( "     "+ CRLF )
   oTextView:Insert(Utf_8("     Este programa está distribuido bajo los términos de GPL v2."+ CRLF ))
   oTextView:Insert( "     "+ CRLF )
   oTextView:Insert( "      Este programa es Software Libre; usted puede redistribuirlo"+ CRLF )
   oTextView:Insert(Utf_8('      y/o modificarlo bajo los términos de la GNU General Public'+ CRLF ))
   oTextView:Insert( '      License, como lo publica la Free Software Foundation en'+ CRLF )
   oTextView:Insert(Utf_8('      su versión 2 de la Licencia'+ CRLF) )
   oTextView:Insert( "     "+ CRLF )
   oTextView:Insert(Utf_8("      Este programa es distribuido con la esperanza de que le será"+ CRLF ))

   oTextView:Insert(Utf_8("      útil, pero SIN NINGUNA GARANTIA; incluso sin la garantía"+ CRLF ))
   oTextView:Insert(Utf_8("      implícita por el MERCADEO o EJERCICIO DE ALGUN PROPOSITO en"+ CRLF ))
   oTextView:Insert(Utf_8('      particular. Vea la GNU General Public License para más'+ CRLF ))
   oTextView:Insert( "      detalles."+ CRLF )
   oTextView:Insert( "     "+ CRLF )
   oTextView:Insert( '      Usted debe haber recibido una copia de la GNU General Public'+ CRLF )
   oTextView:Insert( '      License junto con este programa, si no, escriba a la '+ CRLF )
   oTextView:Insert( '      Free Software Foundation, Inc., 59 Temple Place - Suite 330,'+ CRLF )
   oTextView:Insert( "      Boston, MA  02111-1307, USA."+ CRLF )
   oTextView:Insert( "      (o visite el sitio web http://www.gnu.org/)."+ CRLF )
   oTextView:Insert( "     "+ CRLF )
   oTextView:Insert( "     "+ CRLF )

   oWnd:SetResizable( .f. )

   ACTIVATE WINDOW oWnd CENTER

   cText:=""
     

RETURN NIL

// ---------------------------------------------------------------------

METHOD Debug() CLASS TApp
   //MsgDebug( "Debug  - "+::cTitulo )
   //MsgDebug(  )
RETURN NIL

// ---------------------------------------------------------------------

METHOD Themes() CLASS TApp

   Local aThemes := {}, aDire, cpath, oBox
   Local nSiguiente := 1, oCombo, cValueCombo, oWnd

  cpath := "themes"+if( "Linux" $ OS(), "/", "\")
  aDire  := Directory( cpath , "D" )
  Aeval( aDire, { |a| if(a[5] == "D", AADD( aThemes, a[1] ), ) } )

  if ! ( "Linux" $ OS() ) .and. Len( aThemes ) > 1
    aDel( aThemes, 1 )
    aDel( aThemes, 1 )
    asize( aThemes, Len( aThemes ) - 2 )
  end

  aSort(aThemes,,, { |x,y| upper(x) < upper(y) } )

   DEFINE WINDOW oWnd TITLE "Theme:" + ::cTemes // SIZE 300,100

   gtk_window_set_transient_for( oWnd:pWidget, ::oWin:pWidget )  
   gtk_window_set_icon(oWnd:pWidget, ::oIcon)
   
      DEFINE BOX oBox OF oWnd VERTICAL
         cValueCombo := ::cTemes
         DEFINE COMBOBOX oCombo VAR cValueCombo ITEMS aThemes  OF oBox
         DEFINE BUTTON PROMPT "Aceptar" OF oBox  ;
            ACTION ( ::cTemes := cValueCombo,;
                     MyInfo( "Cuando reinicie el sistema"+CRLF+"se aplicara el Theme" ),;
                     oWnd:End())
//            ACTION ( ::cTemes := oCombo:GetValue(),;

   ACTIVATE WINDOW oWnd CENTER

RETURN NIL

//-------------------------------------------------

STATIC FUNCTION APLICA_THEMES( cTheme )
   Local cPathThemes := "themes/" + cTheme  + "/gtk-2.0/gtkrc"
   Local setting

    gtk_rc_parse( cPathThemes )

   setting := gtk_settings_get_default()
   gtk_rc_reset_styles( setting )

RETURN NIL

//----------------------------------------------------------------------------//

