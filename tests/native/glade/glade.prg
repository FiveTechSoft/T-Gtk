/*
 * $Id: glade.prg,v 1.1 2006-10-31 11:43:58 xthefull Exp $
 * Ejemplo de uso de control de widgets a traves de glade
 * Porting Harbour to GTK+ power !
 * (C) 2004-05. Rafa Carmona -TheFull-
 * (C) 2004-05. Joaquim Ferrer
*/

#include "gtkapi.ch"

//func gtk_exit( widget ) ; gtk_main_quit() ; return( .f. )

procedure  main( )
   local builder, window
   local button, item_new, my_user_data


   /* Cargando interface */
   //builder = glade_xml_new("gtk3.ui") //gtk_builder_new()
   builder = gtk_builder_new( "gtk3.ui" )

   // Load the XML from a file.
   //gtk_builder_add_from_file( builder, "gtk3.ui", NIL )

   // Get the object called 'main_window' from the file and show it.
   window = gtk_builder_get_object( builder, "main_window" )
   gtk_widget_show( window )

   my_user_data = 0xDEADBEEF
   gtk_builder_connect_signals(builder, @my_user_data)


   // Conectando salida controlada 
   gtk_signal_connect( window, "delete-event", {|w| Salida(w) } )  

   // Recuperando widget button a partir de su identificador "button1" 
   button = gtk_builder_get_object( builder, "button1" )

   // Conectando al menu_item una accion   
   gtk_signal_connect( button, "clicked", {|w| show_action(w)} )

   // Main loop.
   gtk_main()

return


function Salida( widget )
   if ( MsgBox( "¿Quieres salir?", GTK_MSGBOX_OK+GTK_MSGBOX_CANCEL,;
                GTK_MSGBOX_INFO ) == GTK_MSGBOX_OK )
      gtk_main_quit()
      return .f.  // Salimos y matamos la aplicacion.
   endif
return .t.


function show_action( widget )
   local name := "El identificador en archivo XML de este widget es : "
   name += gtk_widget_get_name(widget) 
   msginfo( name )
return .t.


//eof
