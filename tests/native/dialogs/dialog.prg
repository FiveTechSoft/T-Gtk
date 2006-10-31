/*
 * $Id: dialog.prg,v 1.1 2006-10-31 11:43:58 xthefull Exp $
 * Ejemplo de uso de dialogos nativos
 * Porting Harbour to GTK+ power !
 * (C) 2004-05. Rafa Carmona -TheFull-
 * (C) 2004-05. Joaquim Ferrer
*/
#include "gtkapi.ch"

function main()

  local aDlg := array( 2 )

/* Dialogo creado "paso a paso" */
   aDlg[ 1 ] := gtk_dialog_new()
   gtk_signal_connect( aDlg[ 1 ], "destroy", {|| gtk_main_quit() } )

   gtk_dialog_add_button( aDlg[ 1 ], "texto del boton", GTK_RESPONSE_YES )
   gtk_dialog_add_button( aDlg[ 1 ], " boton"         , GTK_RESPONSE_NO)
//    gtk_window_set_modal( aDlg[ 1 ], .t. )
   gtk_dialog_set_has_separator( aDlg[ 1 ], .f. )
   gtk_dialog_run( aDlg[ 1 ] )

/* Dialogo creado "de una vez" */
   aDlg[ 2 ] = ;
   gtk_dialog_new_with_buttons( "title", NIL, GTK_DIALOG_MODAL,;
                                GTK_STOCK_OK, GTK_RESPONSE_ACCEPT,;
                                GTK_STOCK_CANCEL, GTK_RESPONSE_CANCEL )

   gtk_widget_show( aDlg[ 2 ] )

   gtk_Main()

return NIL



