#include "gtkapi.ch"

procedure Main()
   local window, vbox, label, scrolled, listbox
   local line_label, line_user
   local messages, message, aMessage
   local linebox

   window := gtk_window_new( GTK_WINDOW_TOPLEVEL )
   gtk_window_set_title( window, "Test GtkListBox" )
   gtk_window_set_default_size( window, 400, 500 )
   
   g_signal_connect( window, "destroy", {||gtk_widget_destroy( window )} )

   vbox := gtk_box_new( GTK_ORIENTATION_VERTICAL, 12 )
   gtk_container_add( window, vbox )

   label := gtk_label_new( "Messages from Gtk and friends" )
   gtk_box_pack_start( vbox, label, .f., .f., 0 )
   gtk_widget_show( label )

   scrolled := gtk_scrolled_window_new()
   gtk_scrolled_window_set_policy( scrolled, ;
                                   GTK_POLICY_NEVER, ;
                                   GTK_POLICY_AUTOMATIC )
   gtk_box_pack_start( vbox, scrolled, .t., .t., 0 )

   listbox := gtk_list_box_new()
   gtk_container_add( scrolled, listbox )

   gtk_list_box_set_sort_func( listbox, "ORDENA", listbox, NIL )
   gtk_list_box_set_activate_on_single_click( listbox, .t. )
   //g_signal_connect( listbox, "row_activated", {||MsgInfo("aqui")} )  //REVISAR

   gtk_widget_show_all( vbox )

   messages := hb_aTokens( hb_memoRead("messages.txt"), CHR(10) )
   FOR EACH message IN messages

      if !Empty( message ) 

        aMessage := hb_aTokens( message, "|" )

        linebox := gtk_box_new( GTK_ORIENTATION_HORIZONTAL, 12 )
        line_user := create_line( linebox, aMessage )

        gtk_container_add( listbox, linebox )
        gtk_widget_show( linebox )
      endif
   NEXT

   gtk_widget_show( window )

   gtk_main()

RETURN


procedure create_line( box_line, aMessage )

   local avatar_pixbuf, avatar_img, vbox, hbox, username, nick, message

        avatar_img := gtk_image_new()
        Do Case
        Case aMessage[3] = "GTKtoolkit"
           gtk_image_set_from_icon_name( avatar_img, "gtk3-demo", GTK_ICON_SIZE_DND)
        Case aMessage[3] = "gnome"
           avatar_pixbuf := gdk_pixbuf_new_from_file_at_scale("../../images/gnome-logo.png", 32, 32, .T.)
           gtk_image_set_from_pixbuf( avatar_img, avatar_pixbuf )
           gdk_pixbuf_unref( avatar_pixbuf )
        Other
           avatar_pixbuf := gdk_pixbuf_new_from_file_at_scale("../../images/apple-red.png", 32, 32, .T.)
           gtk_image_set_from_pixbuf( avatar_img, avatar_pixbuf )
           gdk_pixbuf_unref( avatar_pixbuf )
        EndCase

        gtk_container_add( box_line, avatar_img )
        gtk_widget_show( avatar_img )

   vbox := gtk_box_new( GTK_ORIENTATION_VERTICAL, 12 )
   hbox := gtk_box_new( GTK_ORIENTATION_HORIZONTAL, 10 )
   gtk_container_add( box_line, vbox )
   gtk_container_add( vbox, hbox )

   username := gtk_button_new_with_label( aMessage[2] )
   nick     := gtk_label_new()
   gtk_label_set_markup( nick, '<span foreground="blue"><i>'+aMessage[3]+'</i></span>' )

   message := gtk_label_new()
   gtk_label_set_text( message, aMessage[4] )

   gtk_widget_show( message )
   gtk_widget_show( username )
   gtk_widget_show( nick )
   gtk_widget_show( vbox )
   gtk_widget_show( hbox )
   gtk_container_add( hbox, username )
   gtk_container_add( hbox, nick )
   gtk_container_add( vbox, message )

return 


function ordena( row1, row2 )
   local widget1

   widget1 = gtk_bin_get_child( row1 )
   if gtk_widget_get_name( widget1 ) = "GtkLabel"
      //qout( gtk_widget_get_name(row1), gtk_widget_get_name( widget1 ) )
      //qout( gtk_widget_get_name( widget1 ), " | ", gtk_label_get_text( widget1 ) )
   endif
return 0

//eof


