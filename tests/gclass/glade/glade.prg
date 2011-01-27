/*
 * $Id: glade.prg,v 1.1 2006-09-21 09:55:52 xthefull Exp $
 * Ejemplo de Glade a traves de gClass
 * Uso de glade en Gtk+ Win32 para Harbour + con T-Gtk
 * Ejemplo de Toolbars
 * Porting Harbour to GTK+ power !
 * (C) 2004-05. Rafa Carmona -TheFull-
*/

// Please, install you Gtk+ under win from :
// http://gladewin32.sourceforge.net/index.php

#include "gclass.ch"

#define GtkTreeIter  Array( 4 )

Function main( )
    Local cResource, window, oWnd, oBtn, oCalendar, cPepe := "ESTO es geneial"
    Local oCombo, cCombo := "FIJO"
    local oCombo2, cVar2 := "1-Value", aItems := { "1-Value","2-Dos","3-Well..." }
    local oFixed  , oLbx, oBox, oEntry 
    Local aCombos2 := { "Fijate, desde harbour", "1","2", "3","4" }
    Local aCombos := { {"Fijate, desde harbour","FIJO" },;
                       { "1","UNO"},;
                       { "2" ,"DOS"},;
                       { "3", "TRES"},;
                       { "4", "CUATRO" } }
    local pixbuf
    
    
    SET DATE TO ITALIAN

    pixbuf := gdk_pixbuf_new_from_file( "../../images/gnome-logo.png" )

		SET RESOURCES cResource FROM FILE "example.glade"

      DEFINE WINDOW oWnd ID "window1" RESOURCE cResource
             DEFINE BOX oBox ID "vbox1" RESOURCE cResource 
             DEFINE BUTTON TEXT "AQUI" OF oBox

             DEFINE BUTTON oBtn ID "button1" RESOURCE cResource ;
                    ACTION Paso( "T-Gtk" )
             
             DEFINE BUTTON oBtn ID "button3" RESOURCE cResource ;
                    ACTION MsgInfo( cValtoChar( cCombo ), "Value Combo" )

            DEFINE ENTRY oEntry VAR cPepe ID "entry1" RESOURCE cResource;
                   LEFT BUTTON pixbuf;  
                   RIGHT BUTTON GTK_STOCK_EDIT;
                   ACTION ( If( nPos == 0, MsgInfo( "Botton Izquierdo Presionado" ),  MsgInfo( "Botton Derecho Presionado" ) ) )
                    
 
            DEFINE TOGGLE oBtn ID "togglebutton1" RESOURCE cResource ;
                   ACTION Estado( o )

            DEFINE TOOLBUTTON oBtn ID "toolbutton1" RESOURCE cResource ;
                   ACTION MsgBox( "Help for you, :-)" + cPepe , GTK_MSGBOX_CANCEL, GTK_MSGBOX_INFO  )

            DEFINE TOOLTOGGLE oBtn ID "toggletoolbutton1" RESOURCE cResource ;
                   ACTION (  Estado( o ) )

            DEFINE CALENDAR oCalendar ID "calendar1" RESOURCE cResource ;
                   DATE date() ;
                   MARKDAY ;
                   ON_DCLICK MsgBox( "Fecha seleccionada:"+DTOC( o:GetDate()), GTK_MSGBOX_OK, GTK_MSGBOX_INFO )

            DEFINE FIXED oFixed ID "fixed1" RESOURCE cResource
            
            DEFINE COMBOBOX CLIPPER oCombo VAR cCombo ITEMS aCombos ID "combobox" RESOURCE cResource
                 
            DEFINE COMBOBOX ENTRY oCombo2 VAR cVar2 ;
                    ITEMS aCombos2  ;
                    ID "comboboxentry1" RESOURCE cResource
                    //POS 100, 200 OF oFixed

     ACTIVATE WINDOW oWnd

Return NIL

Static Function Paso( cCadena )

    MsgBox( "[x]Harbour with " + cCadena + HB_OSNEWLINE() +"(c)2004 Rafa Carmona" , GTK_MSGBOX_OK, GTK_MSGBOX_INFO  )

return nil

STATIC FUNC ESTADO( oBtn )

    MsgBox( "Estado del toggle : "+ if( oBtn:GetActive(),"Activo","Desactivado") , GTK_MSGBOX_OK, GTK_MSGBOX_INFO )

return nil


