/*
  Support for WebKit from T-Gtk
  (c)2010 Rafa Carmona
*/
#include "gtkapi.ch"
#define GtkWidget 

Function Main()
    Local main_window, scrolled_window, web_view, vbox, status_bar,context_id
    
    /* Create the widgets */
    GtkWidget main_window := gtk_window_new (GTK_WINDOW_TOPLEVEL)
    Gtk_Signal_Connect( main_window, "delete-event", {|| gtk_main_quit(), .f. } )  // Cuando se mata la aplicacion

    vbox = gtk_vbox_new( FALSE, 1)
    gtk_container_add( main_window, vbox)


    GtkWidget scrolled_window := gtk_scrolled_window_new (NIL, NIL)
    GtkWidget web_view = webkit_web_view_new ()

    /* Place the WebKitWebView in the GtkScrolledWindow */
    gtk_container_add (GTK_CONTAINER (scrolled_window), web_view)
    gtk_container_add (GTK_CONTAINER (vbox), scrolled_window)

    /* Open a webpage */
    webkit_web_view_open (WEBKIT_WEB_VIEW (web_view), "http://www.gnome.org")

    status_bar = gtk_statusbar_new()
    gtk_box_pack_start( vbox, status_bar, FALSE, TRUE, 0)

    context_id = gtk_statusbar_get_context_id( status_bar, "Statusbar example")
    gtk_statusbar_push( status_bar, context_id, "WebKit example running with T-Gtk (c)2010 Rafa Carmona") 

/* Show the result */
    gtk_window_set_default_size (GTK_WINDOW (main_window), 800, 600)
    gtk_widget_show_all (main_window)
    gtk_main()

return 0
