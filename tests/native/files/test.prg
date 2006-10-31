/*
 * Ejemplo de dialogo de seleccion de ficheros
 * Porting Harbour to GTK+ power !
 * (C) 2004-05. Rafa Carmona -TheFull-
 * (C) 2004-05. Joaquim Ferrer
*/

#include "gtkapi.ch"

static hDlg := 0
function Exit() ; gtk_main_quit() ; return( .f. )

function main()

  local hWnd, hBtn

/* Ventana */
  hWnd := gtk_window_new( GTK_WINDOW_TOPLEVEL )
  gtk_signal_connect( hWnd, "destroy", {|| gtk_main_quit() } )
  gtk_window_set_title( hWnd, "Test File Select dialog Gtk for Harbour" )
  gtk_window_set_default_size (hWnd, 200, 200)

  hBtn := gtk_button_new_with_mnemonic( "Seleccionar ficheros" )
  gtk_widget_show( hBtn )
  gtk_container_add( hWnd, hBtn )
  gtk_signal_connect( hBtn, "clicked", {|w| SetFiles(w)} )

/* Method Activate */
  gtk_widget_show_all( hWnd )
  gtk_main()

return NIL

//--------------------------------------------------------------------------//

function SetFiles()

  hDlg := gtk_file_selection_new( "Directorio" )

  gtk_file_selection_hide_fileop_buttons( hDlg )
  gtk_file_selection_set_select_multiple( hDlg, TRUE )

  hb_gtk_file_selection_connect_ok_button( hDlg, "when_ok_button_called" )

  gtk_widget_show( hDlg )

return( .t. )

//--------------------------------------------------------------------------//

function when_ok_button_called()

  local cFile := gtk_file_selection_get_filename( hDlg )
  local cMultiple := "", X

  msginfo( cFile, "Devuelve una sola seleccion" )
  cFile := gtk_file_selection_get_selections( hDlg )

  if Valtype( cFile ) == "A"
     for X := 1 TO Len( cFile )
         cMultiple += cFile[x] + Hb_OsNewline()
     next
     msginfo( cMultiple, "Devuelve multiple seleccion -array-" )
  endif

return( .t. )

//--------------------------------------------------------------------------//
