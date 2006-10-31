// GUI T-Gtk para Harbour
// Ejemplo de FileChooserButton GTk 2.6
// (c)2004 Rafa Carmona

#include "gtkapi.ch"

Function Main()
  Local Button, Window

  Window := Gtk_Window_New()

  Gtk_window_set_title( Window, "GUI GTK+ for Harbour by Rafa Carmona" )
  Gtk_window_set_position( Window, GTK_WIN_POS_CENTER )
  Gtk_Signal_Connect( Window, "destroy", {|| gtk_main_quit() , .F. } ) 

  // Vamos a seleccinar un directorio.
  button := gtk_file_chooser_button_new( "", GTK_FILE_CHOOSER_ACTION_SELECT_FOLDER  )
  gtk_container_add( window, button )
  
  // Por defecto vamos a ponernos en C:/ o /home , segun el sistema.
  if "WIN" $ UPPER( OS() )
     gtk_file_chooser_set_current_folder( button, "C:\" ) 
  elseif "Linux" $ UPPER( OS() )
     gtk_file_chooser_set_current_folder( button, "/home" ) 
  endif

  MsgInfo( "Estamos en :"+ gtk_file_chooser_get_current_folder( button ), "path..." )

  Gtk_Widget_Show( button )
  Gtk_Widget_Show( Window )

  Gtk_Main()

return NIL
