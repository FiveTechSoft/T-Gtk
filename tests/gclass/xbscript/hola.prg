// $Id: hola.prg,v 1.3 2010-12-27 04:58:48 riztan Exp $
// GUI T-Gtk para Harbour
// Usando Programacion orientado al objeto de Window y Menus.
// (c)2004 Rafa Carmona
// Mas cosas como un browse-array

#include "gclass.ch"

Static expand,oBar

Function Hola( uPar1 )
  Local label, calendar
  Local cTextLabel, ToolTips,  notebook
  Local vBox2,  vBox_E, cTextExpand, oCheck, oBtn1, oImage
  Local oWindow, oBoxMenu, oBoxV, oBoxV2, oBoxH, oBtn, oFont, oToggle
  Local lEstado := .T., x, y , oLabel, oExpander, oBoxV_E
  Local oEntry, cEntry := SPACE( 10 )
  Local oSpin, nSpin := 10

  DEFAULT uPar1 := ""

  cTextLabel := '<span foreground="blue" size="large"><b>Interpretando un <span foreground="yellow"'+;
                ' size="xx-large" background="black" ><i>SCRIPT!</i></span></b></span>'+;
                HB_OSNEWLINE()+;
                '<span foreground="red" size="23000"><b><i>T-Gtk power!!</i></b> </span>' +;
                HB_OSNEWLINE()+;
                'Parametro pasado al Script: <b>'+uPar1+'</b>.'

  cTextExpand := '<span foreground="yellow" size="large"><b>Esto es <span foreground="cyan"'+;
                ' size="xx-large" ><i>EXPAND</i></span></b>!!!!</span>'

  DEFINE FONT oFont NAME "Tahoma 18"   
  
  DEFINE WINDOW oWindow TITLE "GUI T-Gtk for Harbour from Script!"
// ---  En GNU/Linux no funciona SetMenuPopup
//       oWindow:SetMenuPopup( MenuPopup() )

       DEFINE BOX oBoxMenu VERTICAL OF oWindow
              DEFINE STATUSBAR oBar OF oBoxMenu ;
                     TEXT "Example" ;
                     INSERT_END

       Create_Menus( oBoxMenu ) // ----> Nos vamos a crear MENUS!!

       DEFINE BOX oBoxH OF oBoxMenu EXPAND FILL

           DEFINE BOX oBoxV VERTICAL OF oBoxH CONTAINER

              /* Probando nuevas clausulas HALIGN , JUSTIFY */
               DEFINE LABEL oLabel TEXT cTextLabel MARKUP OF oBoxV EXPAND FILL ;
                      HALIGN 1;
                      JUSTIFY GTK_JUSTIFY_RIGHT

               DEFINE BUTTON oBtn1 ;
                      TEXT "Hola, ponte encima, ERRORSYS" ;
                      ACTION MyClicked( oBtn );
                      OF oBoxV  ;
                      CURSOR GDK_SPIDER ;
                      BAR oBar MSG "Texto del Button 1"
                      /* Asignamos un Tooltip al Boton */
                      DEFINE TOOLTIP ;
                            WIDGET oBtn1 TEXT "Soporte de ToolTips" +CRLF+"Tambien soporta multilinea..." 

               DEFINE TOGGLE oToggle TEXT "_Comnutador" OF oBoxV ;
                      MNEMONIC ;
                      ACTION EstadoCom( o ) ;
                      CURSOR GDK_SPRAYCAN ;
                      BAR oBar MSG "Este es el toggle"

               DEFINE BUTTON oBtn ;
                      TEXT "_Salida rapidita..." ;
                      MNEMONIC ;
                      ACTION Exit( oFont, oWindow );
                      OF oBoxV ;
                      FONT oFont ;
                      CURSOR GDK_SPIDER ;
                      BAR oBar MSG "Salida directa desde aqui" ;
                      STYLE { { "blue", BGCOLOR , STATE_NORMAL },;
                              { "blue" , BGCOLOR , STATE_PRELIGHT } } // cambiamos el estilo del boton
               
               DEFINE ENTRY oEntry;
                      VAR cEntry ;
                      OF oBoxV 

               oEntry:SetMsg( "Entry tiene tambien", oBar )      
               
               DEFINE SPIN oSpin;
                      VAR nSpin ;
                      OF oBoxV 
               
                   DEFINE MESSAGE "Spin tiene tambien" BAR oBar OF oSpin

                DEFINE BOX oBoxV2 VERTICAL OF oBoxH
                      DEFINE IMAGE oImage FILE "../../images/nena.jpg" OF oBoxv2 EXPAND FILL
                      DEFINE EXPANDER oExpander  PROMPT cTextExpand MARKUP OF oBoxV  EXPAND FILL
                             DEFINE TOOLTIP WIDGET oExpander TEXT "Expande y veras mas cosas ;-)" 
               
                      oExpander:SetMsg( "Expander.... tiene tambien", oBar )      

                           DEFINE BOX oBoxV_E OF oExpander VERTICAL CONTAINER
                             DEFINE CHECKBOX oCheck TEXT "CheckBox, sera posible..." VAR lEstado OF oBoxV_E
                                oCheck:SetMsg( "Este es el checkbox del expand", oBar )
                             DEFINE BUTTON TEXT "Texto del Expand" OF oBoxV_E ACTION Nombre_Expand( oExpander )

                             // Browse( oBoxV_E )


	ACTIVATE WINDOW oWindow CENTER

return NIL

STATIC FUNCTION NOMBRE_EXPAND( oExpand )

  MsgInfo( "La etiqueta del Expander es: " + oExpand:GetLabel() )

return nil

//--- Funciones para el calendario ------------//
FUNC CaleSelect( widget )
  MsgInfo( "Double-click Fecha:" , GTK_CALENDAR_GET_DATE( widget ) )
return nil

FUNC CambioMes( widget )
  MsgInfo( "Cambio de mes" )
RETURN NIL

//--- Funciones para el calendario ------------//
Static Function EstadoCom( o )

	MsgInfo( "Pues ahora estoy.." , o:GetActive() )

return nil

Function MYCLICKED( oBtn )
    Local n,a
    n := a + 2 // OCASIONAMOS CAIDA A PROPOSITO , PARA QUE ENTRE ERRORSYS
    MsgBox( "Click en GTK_STOCK_ADD", GTK_MSGBOX_OK, GTK_MSGBOX_INFO )

Return nil


static function MYLEAVE( Self )
   ::SetLabel( "Hola, ponte encima" )
return nil

static function MYENTER( Self )
   ::SetLabel( "Estoy en el botón" )
	MsgInfo( "El Texto es: " + ::GetLabel() )
Return nil


//Salida directa.
Function Exit( oFont, oWnd )
    oFont:End() // Si forzamos a matar la aplicacion , debemos de eleminar nosotros la font
    oWnd:End()
    gtk_main_quit()
Return .F.

/*
 Ejemplo de la construccion de un menu cualquiera
 */
FUNCTION Create_Menus( oBoxMenu )
    Local oMenuBar, oMenu, oMenuitem, oSubMenu, oMenuItem2, Tearoff
    Local oImage, oFont, oMi,oMiMenu

    DEFINE FONT oFont NAME "Arial 12" 

    DEFINE IMAGE oImage FILE "../../images/gnome-logo.png"

    // Defino barra de menus
    DEFINE BARMENU oMenuBar OF oBoxMenu
       MENUBAR oMenu OF oMenuBar
               MENUITEM ROOT oMenuItem TITLE "_Ejemplos" MNEMONIC OF oMenu
               oMenuItem:SetFont( oFont )
              // Tearoff
               MENU TEAROFF OF oMenu

               MENUITEM oMenuItem2 TITLE "Windows"  OF oMenu
               oMenuItem2:SetFont( oFont )

               SUBMENU oSubMenu OF oMenuItem2
                  MENUITEM TITLE "Crear ventana" ACTION CreateWindow() OF oSubMenu
                  MENU SEPARATOR OF oSubMenu // = gtk_separator_menu_item_new()
                  MENUITEM TITLE "MsgBox"        ACTION Paso( "Hola pasado" ) OF oSubMenu

               MENUITEM TITLE "StatusBar"   OF oMenu
               MENU SEPARATOR OF oMenu // = gtk_separator_menu_item_new()
                  MENUITEM TITLE "ProgressBar" OF oMenu
                  MENUITEM CHECK TITLE "C_heck Item" MNEMONIC OF oMenu
                  MENUITEM CHECK TITLE "Check Item as Radio" ASRADIO ACTIVE OF oMenu
                  MENUITEM IMAGE FROM STOCK GTK_STOCK_APPLY OF oMenu
                  MENUITEM IMAGE TITLE "gnome-logo.png" IMAGE oImage OF oMenu

    ACTIVATE MENUBAR oMenu

    MENUBAR oMenu OF oMenuBar
         MENUITEM ROOT oMenuItem TITLE "O_tro" MNEMONIC OF oMenu
         MENUITEM oMenuItem2 TITLE "Un Item"  OF oMenu
         SUBMENU oSubMenu OF oMenuItem2
             MENUITEM oMi TITLE "Item 1.1" OF oSubMenu
             SUBMENU oMiMenu OF oMi
                MENUITEM oMi TITLE "Item 1.1.1" OF oMiMenu
                MENU SEPARATOR OF oSubMenu // = gtk_separator_menu_item_new()
                MENUITEM TITLE "Item 1.2" OF oSubMenu
                MENUITEM TITLE "Item 2" OF oMenu
                MENUITEM TITLE "Item 3" OF oMenu

    ACTIVATE MENUBAR oMenu

    MENUBAR oMenu OF oMenuBar
      MENUITEM IMAGE ROOT FROM STOCK GTK_STOCK_SAVE OF oMenu

    ACTIVATE MENUBAR oMenu

 Return NIL


// Ejemplo de creacion de OTRA ventana y NO-Dependiente de la principal
Static Function CreateWindow(  )
    Local oWindow

    MsgBox( "Creamos una nueva ventana", GTK_MSGBOX_OK, GTK_MSGBOX_INFO )

    DEFINE WINDOW oWindow TITLE "Otra Ventana mas"
    ACTIVATE WINDOW oWindow CENTER

Return nil

Static Function Paso( cCadena )

    MsgBox( "Esto es la opcion DOS "+ cCadena , GTK_MSGBOX_OK, GTK_MSGBOX_QUESTION )

return nil

Function mySele( )

   MsgInfo( "entro de Menu" )

return nil

Function myDeSele()
   MsgInfo( "Salgo del menu" )
return nil



STATIC FUNCTION MenuPopup()
    Local oMenu, oMenuItem, oImage, oSubMenu, oMenuItem2, oMi, oMiMenu

    DEFINE MENU oMenu 
        MENUITEM oMenuItem2 TITLE "Un Item"  OF oMenu
        SUBMENU oSubMenu OF oMenuItem2
            MENUITEM oMi TITLE "Item 1.1" OF oSubMenu
             SUBMENU oMiMenu OF oMi
                MENUITEM oMi TITLE "Item 1.1.1" OF oMiMenu 
                MENU SEPARATOR OF oSubMenu 
                MENUITEM TITLE "Item 1.2" OF oSubMenu
                MENUITEM TITLE "Item 2" OF oMenu
                MENUITEM TITLE "Action" ACTION MsgInfo( "ACTION!!" ) OF oMenu

RETURN oMenu
