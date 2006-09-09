/* Centrado y salida controlada del programa 
   Guia b?sica de T-Gtk
   (c)2005 Rafa Carmona*/

#include "gclass.ch"

Function Main()
   Local oWnd

    DEFINE WINDOW oWnd TITLE "Hola Mundo" SIZE 300,300
           DEFINE BUTTON PROMPT "MAX" OF oWnd CONTAINER ;
                  ACTION Otraventana()
           
           Gtk_Window_Set_Position( oWnd:pWidget, GTK_WIN_POS_MOUSE )

    ACTIVATE WINDOW oWnd ;
             VALID( MsgBox( "Quieres salir", GTK_MSGBOX_OK+GTK_MSGBOX_CANCEL, GTK_MSGBOX_INFO ,"Titulo" ) == GTK_MSGBOX_OK )


Return NIL

STATIC FUNCTION OTRAVENTANA()
    Local oWnd
    DEFINE WINDOW oWnd TITLE "Hola Mundo" SIZE 100,100
           Gtk_Window_Set_Position( oWnd:pWidget, GTK_WIN_POS_CENTER_ON_PARENT   )
    
    ACTIVATE WINDOW oWnd 

RETURN NIL
