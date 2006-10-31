#include "gtkapi.ch"

#define GtkTreeIter  Array( 4 )

Function Main()

  local hWnd, hScroll, hTree, hlist, x, n, aIter := GtkTreeIter
  local aItems := Directory( "../../images/*.png" )
  local pixbuf

/* Ventana */
   hWnd := gtk_window_new( GTK_WINDOW_TOPLEVEL )
   Gtk_Signal_Connect( hWnd, "destroy", {||gtk_main_quit() } )  // Cuando se mata la aplicacion

/* Scroll bar */
   hScroll = gtk_scrolled_window_new()
   gtk_widget_show ( hScroll )
   gtk_container_add( hWnd, hScroll )

/* Modelo de datos */
    hlist  = gtk_list_store_newv( 2, { G_TYPE_STRING, GDK_TYPE_PIXBUF } )

   For x := 1 To Len( aItems )
        gtk_list_store_append( hList, aIter )
        gtk_list_store_set( hList, 0, aIter, aItems[x,1]  )
        pixbuf := gdk_pixbuf_new_from_file( "../../images/"+aItems[ x,1 ] )
        gtk_list_store_set( hList, 1, aIter, pixbuf )
        gdk_pixbuf_unref( pixbuf )
   Next


/* Browse/Tree */
   hTree = gtk_icon_view_new_with_model( hlist )
   // Determinamos que tipo de columnas son:
   gtk_icon_view_set_text_column(hTree, 0)
   gtk_icon_view_set_pixbuf_column( hTree, 1)
   gtk_container_add( hScroll, hTree )


/* Method Activate */
   gtk_window_set_title( hWnd, "GtkIconView. T-Gtk for [x]Harbour (c)03-2006 Rafa Carmona" )
   gtk_window_set_position( hWnd, GTK_WIN_POS_CENTER )
   gtk_window_set_default_size( hWnd, 600, 400 )
   gtk_widget_show_all( hWnd )

   gtk_Main()

return NIL
