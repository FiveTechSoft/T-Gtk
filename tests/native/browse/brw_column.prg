 * $Id: brw_column.prg,v 1.1 2006-10-04 08:36:29 xthefull Exp $
 * Example T-Gtk 

#include "gtkapi.ch"

#define GtkTreeIter  Array( 4 )

Function Main()

  local hWnd, hScroll, hTree, hRenderer, hColumn, hlist, x,n, aIter := GtkTreeIter
  local aItems := { { "","uno",    "manual", "aristoteles", 1234.324, .t. },;
                    { "","dos",    "manual", "red",         5678.324, .t. },;
                    { "","tres",   "manual", "onasis",      9012.324, .f. },;
                    { "","cuatro", "manual", "euripides",   3456.324, .t. },;
                    { "","dos",    "manual", "euclicides",  5678.324, .f. },;
                    { "","tres",   "manual", "onasis",      9012.324, .t. },;
                    { "","uno",    "manual", "euclicides",  5678.324, .f. },;
                    { "","tres",   "manual", "onasis",      9012.324, .t. },;
                    { "","cuatro", "manual", "euripides",   3456.324, .t. },;
                    { "","dos",    "Auto  ", "euclicides",  5678.324, .t. },;
                    { "","tres",   "manual", "onasis",      9012.324, .f. },;
                    { "","dos",    "manual", "euclicides",  5678.324, .t. },;
                    { "","tres",   "manual", "onasis",      9012.324, .f. },;
                    { "","cuatro", "manual", "euripides",   3456.324, .f. },;
                    { "","dos",    "manual", "euclicides",  5678.324, .t. },;
                    { "","Penun",   "manual", "onasis",      9012.324, .f. },;
                    { "","ultima", "anual", "euripides",   3456.324, .t. } }

    local pixbuf, pixbuf2, pixbuf3, pixbuf4

/* Ventana */
   hWnd := gtk_window_new( GTK_WINDOW_TOPLEVEL )
   Gtk_Signal_Connect( hWnd, "delete-event", {|| Salida() } )  // Cuando se mata la aplicacion

/* Scroll bar */
   hScroll = gtk_scrolled_window_new()
   gtk_widget_show ( hScroll )
   gtk_container_add( hWnd, hScroll )

/* Modelo de datos */
   // hlist  = hb_gtk_list_store_new( aItems )
    hlist  = gtk_list_store_newv( 6, { GDK_TYPE_PIXBUF,  G_TYPE_STRING, G_TYPE_STRING,;
                                       G_TYPE_STRING, G_TYPE_DOUBLE, G_TYPE_BOOLEAN }  )

   pixbuf := gdk_pixbuf_new_from_file( "../../images/glade.png" )
   pixbuf2 := gdk_pixbuf_new_from_file( "../../images/Anieyes.gif" )
   pixbuf3 := gdk_pixbuf_new_from_file( "../../images/gnome-logo.png" )
   pixbuf4 := gdk_pixbuf_new_from_file( "../../images/rafa2.jpg" )

   For x := 1 To Len( aItems )
        gtk_list_store_append( hList, aIter )
        for n := 1 to Len( aItems[ x ] )
            DO CASE
               CASE n == 1
                    if aItems[x,2] == "uno"
                       gtk_list_store_set( hList, n-1, aIter, pixbuf )
                    elseif aItems[x,2] == "dos"
                       gtk_list_store_set( hList, n-1, aIter, pixbuf2 )
                    elseif aItems[x,2] == "tres"
                       gtk_list_store_set( hList, n-1, aIter, pixbuf3 )
                    endif
              OTHERWISE
                    gtk_list_store_set( hList, n-1, aIter, aItems[x,n]  )
            END CASE
        next
   Next

/* Probando gtk_list_store_insert() Una fila introducida manualmente  */
   gtk_list_store_insert( hList, aIter, 1 )
   gtk_list_store_set( hList, 0, aIter, pixbuf4 )
   gtk_list_store_set( hList, 1, aIter, "Fila"  )
   gtk_list_store_set( hList, 2, aIter, "INSERTADA" )
   gtk_list_store_set( hList, 3, aIter, "Manualmente" )
   gtk_list_store_set( hList, 4, aIter, 0123.23 )
   gtk_list_store_set( hList, 5, aIter, .T. )

/* comprobamos si es correcto un Iter */
   // gtk_list_store_iter_is_valid( hList, aIter )

   gdk_pixbuf_unref( pixbuf )
   gdk_pixbuf_unref( pixbuf2 )
   gdk_pixbuf_unref( pixbuf3 )
   gdk_pixbuf_unref( pixbuf4 )

/* Browse/Tree */
   hTree = gtk_tree_view_new_with_model( hlist )
   gtk_tree_view_set_rules_hint( hTree, .t. )
   gtk_container_add( hScroll, hTree )

/* Columna simple de texto creada con gtk_tree_view_column_new_with_attributes  */
   hRenderer = gtk_cell_renderer_pixbuf_new() // gtk_cell_renderer_text_new()
   hColumn = gtk_tree_view_column_new_with_attributes( "Bitmap + Texto ", hRenderer, {  "pixbuf", 0  }  )
   gtk_tree_view_column_set_resizable( hColumn, .t. )

/* Y observa , que simple, es meter el texto en la misma columna que el pixbuf */
   hRenderer = gtk_cell_renderer_text_new()
   gtk_tree_view_column_pack_start( hColumn, hRenderer, .t. )
   gtk_tree_view_column_add_attribute( hColumn, hRenderer, "text", 1 )
   gtk_tree_view_append_column( hTree, hColumn )
   
/*
 * Notese que para crear un columna con _column_new() se han necesitado 6
 * llamadas a funciones mientras que con _column_new_with_attributes() slo 3
 */

/* Columna 'resizable', cambiando titulo y 'ordenable' */
   /* CAMBIADO PARA SER IGUAL AL API*/
   //hColumn = gtk_tree_view_column_new_with_attributes(2, "Esta", "text", hRenderer )
   hColumn = gtk_tree_view_column_new_with_attributes( "Esta", hRenderer , { "text", 2 }  )

   gtk_tree_view_column_set_sizing( hColumn, GTK_TREE_VIEW_COLUMN_FIXED )
   gtk_tree_view_column_set_fixed_width( hColumn, 100 )
   gtk_tree_view_column_set_clickable( hColumn, .t. )
   gtk_tree_view_append_column( hTree, hColumn )

/* Columna de ancho fijo a 100 pixels, con propiedad 'clickable' */
   //hColumn = gtk_tree_view_column_new_with_attributes(3, "Juan", "text", hRenderer )
   hColumn = gtk_tree_view_column_new_with_attributes( "Juan", hRenderer, { "text", 3  }  )
   gtk_tree_view_column_set_resizable( hColumn, .t. )
   gtk_tree_view_column_set_title( hColumn, "Hazme click y me ordenas" )
   gtk_tree_view_column_set_sort_column_id( hColumn, 3 )
   gtk_tree_view_append_column( hTree, hColumn )

/* Columna de ancho fijo a 100 pixels, con propiedad 'clickable' */
   //hColumn = gtk_tree_view_column_new_with_attributes(4, "Numero", "text", hRenderer )
   hColumn = gtk_tree_view_column_new_with_attributes( "Nuemero", hRenderer, {  "text", 4  }  )
   gtk_tree_view_column_set_sort_column_id( hColumn, 4 )
   gtk_tree_view_append_column( hTree, hColumn )

/* Columna tipo 'checkbox' */
   hRenderer = gtk_cell_renderer_toggle_new()
//   hColumn = gtk_tree_view_column_new_with_attributes(5, "Check", "active", hRenderer )
   hColumn = gtk_tree_view_column_new_with_attributes( "Check", hRenderer, {  "active", 5  }  )
   gtk_tree_view_append_column( hTree, hColumn )

/* Method Activate */
   gtk_window_set_title( hWnd, "Columns Bitmaps + Text from T-Gtk for [x]Harbour (c)2005 Rafa Carmona" )
   gtk_window_set_position( hWnd, GTK_WIN_POS_CENTER )
   gtk_window_set_default_size( hWnd, 600, 400 )
   gtk_widget_show_all( hWnd )

   gtk_Main()

return NIL

//--------------------------------------------------------------------------//
//Salida controlada del programa.
Function Salida( widget )
				 gtk_main_quit()
Return .F.  // Salimos y matamos la aplicacion.
