/*
 * $Id: textedit.prg,v 1.1 2006-11-02 12:41:41 xthefull Exp $
 * Ejemplo de uso de text_view, base para futuros MEMOS
 * Porting Harbour to GTK+ power !
 * (C) 2004-05. Rafa Carmona -TheFull-
 * (C) 2004-05. Joaquim Ferrer
*/
#include "gtkapi.ch"

function main()

  local hDlg, hView, hBuffer, hBox, hFont, hTag
  Local aStart := Array( 14 ), aEnd := Array( 14 )
  local cTitle := "Test TextView GTK+ for Harbour"

/* Dialogo */
   hDlg    := ;
   gtk_dialog_new_with_buttons( cTitle, NIL, GTK_DIALOG_MODAL,;
                                GTK_STOCK_OK, GTK_RESPONSE_ACCEPT,;
                                GTK_STOCK_CANCEL, GTK_RESPONSE_CANCEL )

   Gtk_Signal_Connect( hDlg, "delete-event", {|w|Salida(w)} )  // Cuando se mata la aplicacion

/* Text View */
   hView   := gtk_text_view_new()
   hBuffer := gtk_text_view_get_buffer( hView)

/* A¤adiendo texto y fuente */
   gtk_text_buffer_set_text( hBuffer, cTitle + chr(13) + ;
                                      "Hello, this is some text" )
   hFont := pango_font_description_from_string ("Serif 15")
   gtk_widget_modify_font( hView, hFont )
   pango_font_description_free( hFont )

/* Cambiando el color del texto */
   gtk_widget_modify_text( hView, STATE_NORMAL, "green" )

/* Margen derecho e izquierdo */
   gtk_text_view_set_left_margin( hView, 20 )
   gtk_text_view_set_right_margin( hView, 20 )

/* Creando un 'tag' dentro del texto, con otro color */
   hTag := gtk_text_buffer_create_tag( hBuffer, "blue_foreground",;
                                       "foreground", "blue" )

/* Aplicando en la posicion caracter 5 al 13 */
   gtk_text_buffer_get_iter_at_offset( hbuffer, aStart, 5 )
   gtk_text_buffer_get_iter_at_offset( hbuffer, aEnd, 13 )
   gtk_text_buffer_apply_tag( hBuffer, hTag, aStart, aEnd )

/* Obteniendo el contenedor vbox del dialogo a traves de las funciones
   extendidasde Harbour a GTK+ hbGtkExtend */
   hBox := hb_gtk_get_dlg_box( hDlg )

/* A¤adiendo hView al contenedor vbox del dialogo */
   gtk_container_add( hBox, hView )
   gtk_widget_show_all( hDlg )

   gtk_main()

return NIL

/* fin del ejemplo ---------------------------------------------------------*/
//--------------------------------------------------------------------------//
//Salida controlada del programa.
Function Salida( widget )
         gtk_main_quit()
Return .F.  // Salimos y matamos la aplicacion.

