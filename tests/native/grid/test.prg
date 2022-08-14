#include "gtkapi.ch"

Function main()

   local application, status

   /// ***
   application = gtk_application_new( "this.is.my-grid-test.app", G_APPLICATION_FLAGS_NONE )

   /// ***
   g_signal_connect( application, "activate", {||activate_clbk( application ) } )

   /// ***
   status = g_application_run( application, .F. )

   /// ***
   g_object_unref ( application )

return status



Procedure Activate_clbk( application )

   local window, grid, button_1, button_2, button_3, button_4

   /// ***
   window := gtk_application_window_new( application )
   gtk_window_set_default_size( window, 400, 400 )

   /// ***
   grid := gtk_grid_new()

   /// ***
   button_1 := gtk_button_new_with_label( "one" )
   button_2 := gtk_button_new_with_label( "Two" )
   button_3 := gtk_button_new_with_label( "Three" )
   button_4 := gtk_button_new_with_label( "Four" )

   /// ***
   gtk_grid_attach ( grid, button_1, 0, 0, 1, 1 )

   /// ***
   gtk_grid_attach_next_to( grid, button_2, button_1, GTK_POS_BOTTOM, 1, 1 )

   gtk_grid_attach ( grid, button_3, 1, 1, 1, 1 )
   gtk_grid_attach ( grid, button_4, 2, 2, 1, 1 )

   /// ***
   //gtk_grid_remove_column( grid, 1 )

   /// ***
   gtk_container_add( window, grid )
   gtk_widget_show( grid )

   gtk_widget_show_all( window )

   /// ***
   gtk_window_present( window )

return

//eof