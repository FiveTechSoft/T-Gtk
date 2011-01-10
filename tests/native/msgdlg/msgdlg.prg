/*
 * $Id: msgdlg.prg,v 1.1 2006-10-31 11:50:23 xthefull Exp $
 * Ejemplo de uso de distintos dialogos de mensajes
 * Porting Harbour to GTK+ power !
 * (C) 2004-05. Rafa Carmona -TheFull-
 * (C) 2004-05. Joaquim Ferrer
*/
#include "gtkapi.ch"

REQUEST HB_CODEPAGE_ESISO

function Main()

  local hWnd, hDialog
  local nMessage, nButtons
  local iResponse
  
  HB_SETCODEPAGE( "ESISO" )
  SET_AUTO_UTF8( .T. )

/* Ventana */
  hWnd := gtk_window_new( GTK_WINDOW_TOPLEVEL )
  Gtk_Signal_Connect( hWnd, "destroy", {|| gtk_main_quit() } )  // Cuando se mata la aplicacion

/* Method Activate */
  gtk_window_set_title( hWnd, "Test messages Gtk for Harbour" )
  gtk_widget_show( hWnd )

/* Cuadros de mensaje predefinidos de FiveWin */
  

  MsgInfo(  "Esto es MsgInfo()", "Información!" )
  MsgStop(  "Esto es MsgStop()",  "Aviso !    " )
  MsgAlert( "Esto es MsgAlert()", "Atención ! " )
  MsgNoYes( "Esto es MsgNoYes()", "Cuestión ? " )

/* Cuadros de mensaje directamente de GTK */

  nMessage := 0
  for nButtons := 1 to 6
      hDialog   := gtk_message_dialog_new( "Cuadros de mensaje directamente de GTK", ;
                                           nMessage, nButtons-1 )
      iResponse := gtk_dialog_run( hDialog )
      gtk_widget_destroy( hDialog )
      nMessage += 1
      if nMessage > 3
         nMessage = 0
      endif
  next

  gtk_main()

return NIL
