#include "gclass.ch"

Function Main()
         Local oDlg

        DEFINE DIALOG oDlg TITLE "Hola Mundo, salida condicionada" SIZE 300,200
        ACTIVATE DIALOG oDlg CENTER;
                 VALID( MsgBox( "Quieres salir", GTK_MSGBOX_OK+GTK_MSGBOX_CANCEL,GTK_MSGBOX_INFO ) == GTK_MSGBOX_OK )

Return NIL
