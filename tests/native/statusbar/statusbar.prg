/*
 * $Id: statusbar.prg,v 1.1 2006-11-02 12:41:40 xthefull Exp $
 * Ejemplo de uso de una status bar
 * Porting Harbour to GTK+ power !
 * (C) 2004-05. Rafa Carmona -TheFull-
 * (C) 2004-05. Joaquim Ferrer
*/
#include "gtkapi.ch"


static status_bar
static context_id

Function Main( )
    Local window, vbox, button, combobox1,list
    Local cPantalla

    /* crear una nueva ventana */
    window = gtk_window_new( GTK_WINDOW_TOPLEVEL )
    gtk_widget_set_usize( window, 200, 100 )
    gtk_window_set_title( window, "GTK Statusbar Example" )
    gtk_signal_connect( window, "delete-event", {||gtk_exit() })

    vbox = gtk_vbox_new( .F., 1)
    gtk_container_add( window, vbox)
    gtk_widget_show(vbox)

    button = gtk_button_new_with_label("push item")
    gtk_signal_connect( button, "clicked", {|w|push_item(w)} )
    gtk_box_pack_start( vbox, button, .T., .T., 2)
    gtk_widget_show(button)

    button = gtk_button_new_with_label("pop last item")
    gtk_signal_connect( button, "clicked", {|w|pop_item(w)} )
    gtk_box_pack_start( vbox, button, .T., .T., 2)
    gtk_widget_show(button)


    status_bar = gtk_statusbar_new()
    gtk_box_pack_start( vbox, status_bar, .F., .T., 0)
    gtk_widget_show (status_bar)

    context_id = gtk_statusbar_get_context_id( status_bar, "Statusbar example")

    /* siempre mostramos la ventana en el último paso para que todo se
     * dibuje en la pantalla de un golpe. */

    gtk_widget_show(window)

    gtk_main ()

return nil


function push_item ( pWidget )
    local  buff := "Item "
    static count := 1

    buff += str( Count++, 2 )
    gtk_statusbar_push( status_bar, context_id, buff )

return NIL

function pop_item( pWidget )

    gtk_statusbar_pop( status_bar, context_id )

return NIL

Function gtk_exit()
         gtk_main_quit()
return .F.
