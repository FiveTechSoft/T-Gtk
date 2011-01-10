 * $Id: browsdbf.prg,v 1.1 2006-10-04 08:36:29 xthefull Exp $
 * Example T-Gtk 

#include "gtkapi.ch"

#define DBF_FIELD  1

function main()

  local hWnd, hScroll, hList, hTree, hRenderer, hColumn, hItem, hSelection
  local aFields := {}
  local aStruct := {}
  local n, nLen, aIter := Array( 4 )
  Local aTemp := { }

   USE browse.dbf NEW
   aStruct := dbstruct()
   aeval( aStruct, {|a| aadd( aFields, a[DBF_FIELD] ) } )
   nLen := len( aFields )

// Ventana 
   hWnd := gtk_window_new( GTK_WINDOW_TOPLEVEL )
   Gtk_Signal_Connect( hWnd, "delete-event", {|| Salida() } )  // Cuando se mata la aplicacion

// Scroll bar 
   hScroll = gtk_scrolled_window_new()
   gtk_widget_show ( hScroll )
   gtk_container_add( hWnd, hScroll )

// Modelo de datos 
   hList = gtk_list_store_newv( 12 ,{ G_TYPE_STRING, G_TYPE_STRING,;
                                      G_TYPE_STRING, G_TYPE_STRING,;
                                      G_TYPE_STRING, G_TYPE_STRING,;
                                      G_TYPE_STRING, G_TYPE_BOOLEAN,;
                                      G_TYPE_INT, G_TYPE_LONG,G_TYPE_STRING,;
                                      G_TYPE_LONG } )

// Browse/Tree 
   hTree      := gtk_tree_view_new_with_model( hList )
   Gtk_signal_connect( hTree, "row-activated", {|Treeview, Path, Col| mira_valor( Treeview, Path, Col ) } )

   hSelection := gtk_tree_view_get_selection( hTree )
   gtk_tree_selection_set_mode( hSelection, GTK_SELECTION_BROWSE )
   gtk_container_add( hScroll, hTree )

   do while !eof()
      gtk_list_store_append( hList, aIter )
      for n := 1 to nLen
          gtk_list_store_set( hList, n-1, aIter, fieldget( n ) )
      next
      // Introducimos el RECNO del registos
      gtk_list_store_set( hList, nLen , aIter, Recno() )
      dbskip()
   enddo

// Method AddColumns 
   for n:= 1 to nLen
       hRenderer = gtk_cell_renderer_text_new()
       hColumn = gtk_tree_view_column_new_with_attributes( aFields[n], hRenderer, {  "text", n-1  }  )
       gtk_tree_view_append_column( hTree, hColumn )
   next

// Method Activate 
   gtk_window_set_title( hWnd, "Test Browse DBF Gtk for Harbour" )
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

/* Esta funcion nos permite preguntar por el valor de la columna actual */
Function Mira_Valor( Treeview, Path, Col )
  Local model, aIter := Array( 4 ) 
  Local name, street, nEdad, nSalario, nRecno
  
  model = gtk_tree_view_get_model( Treeview )
  
  // gtk_tree_model_get_iter( model, aIter, path ) /* ITER lo trata C, de momento */ 
  IF( gtk_tree_model_get_iter( model, aIter, path ) )
       hb_gtk_tree_model_get_string( model, aIter, 0, @name ) 
       hb_gtk_tree_model_get_string( model, aIter, 2, @street ) 
       hb_gtk_tree_model_get_int( model, aIter, 8, @nEdad ) 
       hb_gtk_tree_model_get_long( model, aIter, 9, @nSalario) 
       hb_gtk_tree_model_get_long( model, aIter, 11, @nRecno) 
       MsgInfo( "Nombres:"+ name + HB_OSNEWLINE() + street + HB_OSNEWLINE()+ ;
                "Edad:"+ cValtoChar ( nEdad ) + " Salario:" + cValtoChar( nSalario ) + HB_OSNEWLINE(),;
                "Informacion registro:" + cValtoChar( nRecno ) )
  ENDIF

Return nil

