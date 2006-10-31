/*
 * $Id: fixed.prg,v 1.1 2006-10-31 11:43:58 xthefull Exp $
 * Ejemplo de uso de fixed y colocacion de botones
 * Porting Harbour to GTK+ power !
 * (C) 2004-05. Rafa Carmona -TheFull-
 * (C) 2004-05. Joaquim Ferrer
*/

#include "gtkapi.ch"

/* Voy a ser un poco torpe y utilizar algunas variables
 * globales para almacenar la posición del widget que
 * hay dentro del contenedor */
static x :=50
static y :=50

Static fixed

Function Main()
     local ventana, boton
     Local i

     /* Crear una nueva ventana */
     ventana = gtk_window_new (GTK_WINDOW_TOPLEVEL)
     gtk_window_set_title( ventana, "Fixed Container")

     /* Aquí conectamos el evento "destroy" al manejador de la señal */
     gtk_signal_connect ( ventana, "destroy", {||gtk_main_quit()} )

     /* Establecemos el ancho del borde la ventana */
     gtk_container_set_border_width ( ventana, 10)

     /* Creamos un contenedor fijo */
     fixed = gtk_fixed_new()
     gtk_container_add( ventana, fixed)
     gtk_widget_show(fixed)

     FOR i := 1 TO 3
        /* Crea un nuevo botón con la etiqueta "Press me" */
         boton := Gtk_button_new_with_label( "Press me "+ str( i ) )

        /* Cuando el botón reciba la señal "pulsado", llamará a la función
         * move_button() pasándole el contenedor fijo como argumento. */
        gtk_signal_connect ( boton, "clicked", {|w| move_button(w) } )

        /* Esto mete el botón dentro de la ventana del window contenedor
         * fijo. */
        gtk_fixed_put ( fixed, boton, i*50, i*50)

       /* El paso final es mostrar el widget recien creado */
        gtk_widget_show (boton)
             NEXT
     /* Mostrar la ventana */
     gtk_widget_show (ventana)

     /* Entrar en el bucle principal */
    gtk_main ()

Return nil

/* Esta función de llamada mueve el botón a una nueva
 * posición dentro del contenedor fijo. */
function move_button( pwidget )

         x = (x+30)%300
         y = (y+50)%300
         gtk_fixed_move( fixed, pwidget, x, y )

Return nil
