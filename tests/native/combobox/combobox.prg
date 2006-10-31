/*
 * $Id: combobox.prg,v 1.1 2006-10-31 11:28:15 xthefull Exp $
 * Ejemplo de uso de combobox
 * Porting Harbour to GTK+ power !
 * (C) 2004-05. Rafa Carmona -TheFull-
 * (C) 2004-05. Joaquim Ferrer
*/
#include "gtkapi.ch"


static status_bar
static context_id

Function Main( )
    Local window, vbox, button, combobox1

    /* crear una nueva ventana */
    window = gtk_window_new( GTK_WINDOW_TOPLEVEL )
    gtk_widget_set_usize( window, 200, 100 )
    gtk_window_set_title( window, "T-GTK Combobox Example" )
    gtk_signal_connect( window, "destroy", {|| gtk_main_quit(), .F. } )

    vbox = gtk_vbox_new( FALSE, 1)
    gtk_container_add( window, vbox)
    gtk_widget_show(vbox)

    COMBOBOX1 = gtk_combo_entry_new_text()
    gtk_widget_show (combobox1)
    gtk_box_pack_start (GTK_BOX (vbox), combobox1, FALSE, TRUE, 0)
    gtk_combo_box_append_text ( combobox1, "Uno")
    gtk_combo_box_append_text ( combobox1, "Dos")
    gtk_combo_box_append_text ( combobox1, "Tres")

    gtk_combo_box_insert_text ( combobox1,1, "Insertado despues del uno")

    gtk_signal_connect( combobox1, "changed", {|w|cambio(w) } )
    gtk_combo_box_set_active( combobox1, 0 ) // Selecciona el primero

    COMBOBOX1 = gtk_combo_box_new_text()
    gtk_widget_show (combobox1)
    gtk_box_pack_start (GTK_BOX (vbox), combobox1, FALSE, TRUE, 0)
    gtk_combo_box_append_text ( combobox1, "2Uno")
    gtk_combo_box_append_text ( combobox1, "2Dos")
    gtk_combo_box_append_text ( combobox1, "2Tres")
    gtk_signal_connect( combobox1, "changed", {|w| cambio(w)} )


    gtk_widget_show(window)

    gtk_main ()

return nil

// Cuando el resultado devuelve -1 , es que se esta introduciendo texto
// que no esta en el comobobox
Function Cambio( pWidget )

	? " Cambiando :" + str( gtk_combo_box_get_active( pWidget ) )

return .t.

/* Fin del ejemplo */
