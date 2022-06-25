/*
 * $Id: progressbar.prg,v 1.1 2006-10-31 11:50:24 xthefull Exp $
 * Ejemplo de uso de progressbar y cambio de estilo.
 * Porting Harbour to GTK+ power !
 * (C) 2004-05. Rafa Carmona -TheFull-
 * (C) 2004-05. Joaquim Ferrer
*/
#include "gtkapi.ch"

/**
GTK+ 2.x                        GTK+ 3
-----------------------------------------------------------------------
GtkProgressBarOrientation 	GtkOrientation                  inverted
-----------------------------------------------------------------------
GTK_PROGRESS_LEFT_TO_RIGHT 	GTK_ORIENTATION_HORIZONTAL 	FALSE
GTK_PROGRESS_RIGHT_TO_LEFT 	GTK_ORIENTATION_HORIZONTAL 	TRUE
GTK_PROGRESS_TOP_TO_BOTTOM 	GTK_ORIENTATION_VERTICAL 	FALSE
GTK_PROGRESS_BOTTOM_TO_TOP 	GTK_ORIENTATION_VERTICAL 	TRUE
*/
Static progress, progress2, progress3, progress4

Function Main( )
    Local window, vbox,status_bar, button
    Local X := 0

    window = gtk_window_new( GTK_WINDOW_TOPLEVEL )
    gtk_widget_set_usize( window, 300, 300 )
    gtk_window_set_title( window, "GTK ProgressBar Example" )
    gtk_signal_connect( window, "destroy",{|| gtk_exit() } )

    vbox = gtk_vbox_new( FALSE, 1)
    gtk_container_add( window, vbox)
    gtk_widget_show(vbox)

    button = gtk_button_new_with_label("Incrementando..")
    gtk_signal_connect( button, "clicked", {||Incre(@x)} )
    gtk_box_pack_start( vbox, button, .T., .T., 2)
    gtk_widget_show(button)

    // Standard
    progress = gtk_progress_bar_new()
    gtk_progress_bar_set_text( progress, "ProgressBar Left To Right..." )
    //Estableciendo estilo para esta progress
    __GSTYLE( "blue"  ,progress, BGCOLOR , STATE_NORMAL)   // Cuando esta normal, fondo azul
    __GSTYLE( "green" ,progress, FGCOLOR , STATE_NORMAL )  // Cuando esta normal, letras verdes
    __GSTYLE( "yellow",progress, BGCOLOR  , STATE_PRELIGHT )
    __GSTYLE( "red"   ,progress, FGCOLOR  , STATE_PRELIGHT )

    gtk_box_pack_start( vbox, progress, .F., .T., 2)
    gtk_widget_show( progress )

    // Dercha a Left
    progress2 = gtk_progress_bar_new()
    gtk_progress_bar_set_text( progress2, "ProgressBar Right To Left..." )
    //Estableciendo estilo para esta progress
    __GSTYLE( "white"  ,progress2, BGCOLOR , STATE_NORMAL)   // Cuando esta normal, fondo azul
    __GSTYLE( "magenta" ,progress2, FGCOLOR , STATE_NORMAL )  // Cuando esta normal, letras verdes
    __GSTYLE( "black",progress2, BGCOLOR  , STATE_PRELIGHT )
    __GSTYLE( "blue"   ,progress2, FGCOLOR  , STATE_PRELIGHT )
    // gtk_progress_bar_set_orientation(progress2, GTK_PROGRESS_RIGHT_TO_LEFT ) --> GTK2
    gtk_orientable_set_orientation(progress2,GTK_ORIENTATION_HORIZONTAL)
    gtk_progress_bar_set_inverted(progress2,.T.)
    gtk_box_pack_start( vbox, progress2, .F., .T., 2)
    gtk_widget_show( progress2 )

    // Abajo a Arriba
    progress3 = gtk_progress_bar_new()
    gtk_progress_bar_set_text( progress3, "ProgressBar Bottom To Top ÑÑÑ..." )
    //Estableciendo estilo para esta progress
    __GSTYLE( "black"  ,progress3, BGCOLOR , STATE_NORMAL)   // Cuando esta normal, fondo azul
    __GSTYLE( "red"    ,progress3, FGCOLOR , STATE_NORMAL )  // Cuando esta normal, letras verdes
    __GSTYLE( "white"  ,progress3, BGCOLOR  , STATE_PRELIGHT )
    __GSTYLE( "orange" ,progress3, FGCOLOR  , STATE_PRELIGHT )
  //  gtk_progress_bar_set_orientation(progress3, GTK_PROGRESS_BOTTOM_TO_TOP)  // GTK2
    gtk_orientable_set_orientation(progress3,GTK_ORIENTATION_VERTICAL)
    gtk_progress_bar_set_inverted(progress3,.T.)
    //-----------------------------------------------------------------------


    gtk_box_pack_start( vbox, progress3, .F., .T., 2)
    gtk_widget_show( progress3 )

    progress4 = gtk_progress_bar_new()
    gtk_progress_bar_set_text( progress4, "ProgressBar Top To Bottom..." )
//    gtk_progress_bar_set_orientation(progress4, GTK_PROGRESS_TOP_TO_BOTTOM )
    gtk_orientable_set_orientation(progress4,GTK_ORIENTATION_VERTICAL)
    gtk_progress_bar_set_inverted(progress4,.F.)
    gtk_box_pack_start( vbox, progress4, .F., .T., 2)
    gtk_widget_show( progress4 )

    button = gtk_button_new_with_label("Decrementando..")
    gtk_signal_connect( button, "clicked", {||Decre(@x)} )
    gtk_box_pack_start( vbox, button, .T., .T., 2)
    gtk_widget_show(button)

    status_bar = gtk_statusbar_new()
    gtk_box_pack_start( vbox, status_bar, .F., .T., 0)
    gtk_widget_show (status_bar)

    gtk_widget_show(window)

    gtk_main ()

return nil

Function incre( X )
    Local nTotal := 10
    if x < nTotal
       X++
       gtk_progress_bar_set_fraction( progress,  X  / nTotal )
       gtk_progress_bar_set_fraction( progress2,  X / nTotal )
       gtk_progress_bar_set_fraction( progress3,  X / nTotal )
       gtk_progress_bar_set_fraction( progress4,  X / nTotal )
    endif
Return NIL

Function decre( X )
    Local nTotal := 10
    if x > 0
       X--
       gtk_progress_bar_set_fraction( progress,  X  / nTotal )
       gtk_progress_bar_set_fraction( progress2,  X / nTotal )
       gtk_progress_bar_set_fraction( progress3,  X / nTotal )
       gtk_progress_bar_set_fraction( progress4,  X / nTotal )
    endif
Return NIL

Function gtk_exit()
    gtk_main_quit()
return .F.

