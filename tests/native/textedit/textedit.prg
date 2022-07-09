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
  local provider, context, aIter := ARRAY(14), cText
  Local aStart := Array( 14 ), aEnd := Array( 14 )
  local cTitle := "Test TextView GTK+ for Harbour"

/* Dialogo */
   hDlg    := ;
   gtk_dialog_new_with_buttons( cTitle, NIL, GTK_DIALOG_MODAL,;
                                GTK_STOCK_OK, GTK_RESPONSE_ACCEPT,;
                                GTK_STOCK_CANCEL, GTK_RESPONSE_CANCEL )

   Gtk_Signal_Connect( hDlg, "delete-event", {|w|Salida(w)} )  // Cuando se mata la aplicacion

/* Text View */
   //hView   := gtk_text_view_new()
   //hBuffer := gtk_text_view_get_buffer( hView)
   hBuffer := gtk_text_buffer_new()

/* A¤adiendo texto y fuente */
   gtk_text_buffer_set_text( hBuffer, cTitle + chr(13) + ;
                                      "Hello, this is t-gtk " )

   cText := "(GTK for Harbour!)"
   gtk_text_buffer_get_iter_at_offset( hBuffer, aStart, len(cTitle)+22 )
   gtk_text_buffer_insert( hBuffer, aStart, cText, -1 )

/* Cambiar la fuente y el color predeterminados en todo el widget */ 
   provider := gtk_css_provider_new()

   gtk_css_provider_load_from_data( provider, ;
                                    "textview{ "+;
                                    "  font: 18 serif; "+;
                                    "  color: green;    "+;
                                    "}", -1 )

   hView := gtk_text_view_new_with_buffer( hBuffer )
   g_object_unref( hBuffer )

   context := gtk_widget_get_style_context( hView )

   gtk_style_context_add_provider( context, provider, GTK_STYLE_PROVIDER_PRIORITY_APPLICATION )

/* Margen derecho e izquierdo */
   gtk_text_view_set_left_margin( hView, 40 )
   gtk_text_view_set_right_margin( hView, 40 )

/* Creando un 'tag' dentro del texto, con otro color */
   hTag := gtk_text_buffer_create_tag( hBuffer, "letras_azules",;
                                       "foreground", "blue", ;
                                       "background", "yellow" )

   tgtk_text_tag_set_property( hTag, "font", "Seans Italic 24" )

/* Aplicando en la posicion caracter 5 al 13 */
   gtk_text_buffer_get_iter_at_offset( hbuffer, aStart, 5 )
   gtk_text_buffer_get_iter_at_offset( hbuffer, aEnd, 13 )
   gtk_text_buffer_apply_tag( hBuffer, hTag, aStart, aEnd )

   gtk_text_buffer_get_iter_at_offset( hBuffer, aStart, 0 )  // posicionamos al inicio (0)
   gtk_text_buffer_insert_with_tags_by_name( hbuffer, aStart, ;
                                            " -- Text added later --"+hb_eol(), -1,;
                                            "letras_azules" );

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

//eof
