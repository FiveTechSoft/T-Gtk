/*
 * $Id: radiobutton.prg,v 1.1 2006-11-02 12:41:40 xthefull Exp $
 * Ejemplo de uso radiobuttons.
 * Porting Harbour to GTK+ power !
 * (C) 2004-05. Rafa Carmona -TheFull-
 * (C) 2004-05. Joaquim Ferrer
*/
#include "gtkapi.ch"

FUNCTION MAIN()
        Local window, box1, box2, button, separator, group

        window = gtk_window_new( GTK_WINDOW_TOPLEVEL )
        gtk_signal_connect( window, "destroy", {| widget | Salir( widget) } )        
        gtk_window_set_title ( window, "radio buttons" )
        gtk_container_set_border_width( window, 10 )

        box1 = gtk_vbox_new (.F., 0)
        gtk_container_add ( window, box1)
        gtk_widget_show(box1)

        box2 = gtk_vbox_new (.F., 10)
        gtk_container_set_border_width( box2, 10 )
        gtk_box_pack_start( box1, box2, .T., .T., 0)
        gtk_widget_show (box2)

        button = gtk_radio_button_new_with_label (NIL, "button1")
        gtk_box_pack_start ( box2, button, .T., .T., 0)
        gtk_widget_show (button)

        group = gtk_radio_button_get_group (button)
        button = gtk_radio_button_new_with_label(group, "button2")
        gtk_toggle_button_set_state ( button, .T.)
        gtk_box_pack_start (box2, button, .T., .T., 0)
        gtk_widget_show (button)

        group = gtk_radio_button_get_group ( button )
        button = gtk_radio_button_new_with_label(group, "button3")
        gtk_box_pack_start (box2, button, .T., .T., 0)
        gtk_widget_show (button)

        separator = gtk_hseparator_new ()
        gtk_box_pack_start ( box1, separator, .F., .T., 0)
        gtk_widget_show (separator)

        box2 = gtk_vbox_new (.F., 10)
        gtk_container_set_border_width( box2, 10 )
        gtk_box_pack_start ( box1, box2, .F., .T., 0)
        gtk_widget_show (box2)

        button = gtk_button_new_with_label ("close")
        gtk_signal_connect( button, "clicked", {|| g_signal_emit_by_name( window, "destroy" ) } )

        gtk_box_pack_start ( box2, button, .T., .T., 0)
        GTK_WIDGET_SET_FLAGS (button, GTK_CAN_DEFAULT )
        gtk_widget_grab_default (button)
        gtk_widget_show (button)
        gtk_widget_show (window)

        gtk_main()

return nil

Function Salir()
	gtk_main_quit()
return .f.
