/*
 * Ejemplo de uso de 'reglas'
 * Porting Harbour to GTK+ power !
 * (C) 2004-05. Rafa Carmona -TheFull-
 * (C) 2004-05. Joaquim Ferrer
*/

#include "gtkapi.ch"

#define XSIZE       600
#define YSIZE       400
#define X_PADDING    10   // Margen 'x' del control a la ventana
#define Y_PADDING     2   // Margen 'y' del control a la ventana


function gtk_exit() ; gtk_main_quit() ; return .f.

function main( )

 local window, vbox, hbox, hruler, vruler, table
 local aRange, pImage, pImage2
 
 /* crear una nueva ventana */
    window = gtk_window_new( GTK_WINDOW_TOPLEVEL )
    gtk_widget_set_size_request( window, XSIZE, YSIZE )
    gtk_window_set_title( window, "GTK ruler controls example" )
    gtk_signal_connect( window, "delete-event", {|| gtk_exit() } )

 /* crear una tabla donde pondremos las reglas */
    table = gtk_table_new( 2, 2, 0 )
    gtk_container_add( window, table )

 /* horizontal ruler */   
    hruler = gtk_hruler_new()
    gtk_ruler_set_metric( hruler, GTK_PIXELS )
    gtk_ruler_set_range( hruler, 0, 10, 0, 20 )
    gtk_table_attach ( table, hruler, 1, 2, 0, 1,;
                      nOr( GTK_EXPAND , GTK_FILL ) ,;
                      GTK_FILL, 0, 0 )

 /* vertical ruler */
    vruler = gtk_vruler_new()
    gtk_ruler_set_metric( vruler, GTK_PIXELS )
    gtk_ruler_set_range( vruler, 0, 10, 0, 20 )
    gtk_table_attach( table , vruler, 0, 1, 1, 2,;
                     GTK_FILL,;
                     nOR( GTK_EXPAND, GTK_FILL), 0, 0)

 /* Dibujo */    
    pImage := gtk_image_new_from_file( "../../images/glade.png" )
    gtk_table_attach ( table, pimage, 0, 1, 0, 1,;
                       GTK_FILL ,;
                       GTK_FILL ,;
                       0,0 )
 
/* Dibujo */    
    pImage2 := gtk_image_new_from_file( "../../images/glogo.png" )
    gtk_table_attach ( table, pimage2, 1, 2, 1, 2,;
                       nOr( GTK_FILL,GTK_SHRINK ) ,;
                       nOr( GTK_FILL,GTK_SHRINK )  , 0,0 )

    aRange := gtk_ruler_get_range( vruler )
    ? "vertical", aRange[1], aRange[2], aRange[3], aRange[4]
    
    aRange := gtk_ruler_get_range( hruler )
    ? "horizontal", aRange[1], aRange[2], aRange[3], aRange[4]
    
    gtk_widget_show_all( window )
    gtk_main ()

return nil


