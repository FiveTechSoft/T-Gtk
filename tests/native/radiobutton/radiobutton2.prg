/*
 * $Id: radiobutton2.prg,v 1.1 2006-11-02 12:41:40 xthefull Exp $
 * Ejemplo de uso radiobuttons.
 * Porting Harbour to GTK+ power !
 * (C) 2004-05. Rafa Carmona -TheFull-
 * (C) 2004-05. Joaquim Ferrer
*/
#include "gtkapi.ch"

Function main( )

   Local window, radio1, radio2, box, entry

   window = gtk_window_new (GTK_WINDOW_TOPLEVEL)
   Gtk_Signal_Connect( window, "delete-event", {|| Salir() } )  // Cuando se mata la aplicacion

//   box = gtk_vbox_new (.T., 2)
   box = gtk_box_new(GTK_ORIENTATION_VERTICAL,2)
   gtk_box_set_homogeneous(box,.T.)

   /* Create a radio button with a GtkEntry widget */
   radio1 = gtk_radio_button_new (NIL)
   entry = gtk_entry_new ()
   gtk_entry_set_text( entry, "Uy!! Entry in RadioButton" )
   gtk_container_add ( radio1, entry )

   /* Create a radio button with a label */
   radio2 = gtk_radio_button_new_with_label_from_widget ( radio1,"I'm the second radio button.")

   /* Pack them into a box, then show all the widgets */
   gtk_box_pack_start (box, radio1, .T., .T., 2)
   gtk_box_pack_start (box, radio2, .T., .T., 2)
   gtk_container_add (window, box)
   gtk_widget_show_all (window)

   gtk_main()

 return nil

Function Salir()
  gtk_main_quit()
return .f.
