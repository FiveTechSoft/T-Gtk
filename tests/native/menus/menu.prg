/*
 * TestMenu. Ejemplo de creacion de un menu al estilo Win32 ------------------
 * Porting Harbour to GTK+ power !
 * (C) 2004. Rafa Carmona -TheFull-
 * (C) 2004. Joaquim Ferrer
 *
 * -> Usando STOCK_ICONS
 */

#include "gtkapi.ch"

function main()

  local window
  local boxmenu
  local hBox

  window := gtk_window_new( GTK_WINDOW_TOPLEVEL )
  gtk_window_set_title( window, "Creando menus al estilo Win32 en GTK+" )
  gtk_window_set_default_size( window, 500, 350 )
  gtk_signal_connect( window, "delete-event", {|w|ValidExit(w)}  )
  gtk_signal_connect( window, "destroy", {||exit()} )

  boxmenu := gtk_vbox_new (FALSE, 0)
  gtk_container_add( window, boxmenu )
  gtk_widget_show( boxmenu )

  BuildMenu( boxmenu )

  hBox   := gtk_hbox_new( .F.,0 )
  gtk_widget_show( hBox )
  gtk_container_add( boxmenu, hBox)

  gtk_widget_show( window )

  gtk_main()

return NIL

//--------------------------------------------------------------------------//

function BuildMenu( boxmenu )

 local menubar, menu, topitem, item

  menubar = gtk_menu_bar_new ()
  gtk_box_pack_start ( boxmenu, menubar, FALSE, TRUE, 0)
  gtk_widget_show (menubar)

  topitem = gtk_menu_item_new_with_label("File")
  gtk_widget_show (topitem)
  gtk_container_add (menubar, topitem)

  menu = gtk_menu_new ()
  gtk_menu_item_set_submenu (topitem, menu)

  item = gtk_image_menu_item_new_from_stock ("gtk-new" )
  gtk_signal_connect( item, "activate", {||Show()} )
  gtk_widget_show( item )
  gtk_container_add( menu, item )

  item = gtk_image_menu_item_new_from_stock ("gtk-open")
  gtk_signal_connect( item, "activate", {||Show()} )
  gtk_widget_show( item )
  gtk_container_add( menu, item )

  item = gtk_image_menu_item_new_from_stock ("gtk-save")
  gtk_signal_connect( item, "activate", {||Show()} )
  gtk_widget_show( item )
  gtk_container_add( menu, item )

  item = gtk_image_menu_item_new_from_stock ("gtk-save-as")
  gtk_signal_connect( item, "activate", {||Show()} )
  gtk_widget_show( item )
  gtk_container_add( menu, item )

  item = gtk_separator_menu_item_new ()
  gtk_widget_show( item )
  gtk_container_add( menu, item )

/*
 * Rafa:
 * Glade implementa esta funcion cuando hay un separador, pero veo que
 * de momento no hace nada. De todas formas, la dejo 'wrappeada' en libhbgtk
 */
  gtk_widget_set_sensitive( item, FALSE )

  item = gtk_image_menu_item_new_from_stock ("gtk-quit")
/* Conectando se¤al */
  gtk_signal_connect( item, "activate", {||Exit()} )
  gtk_widget_show( item )
  gtk_container_add( menu, item )

  topitem = gtk_menu_item_new_with_label("Edit")
  gtk_widget_show (topitem)
  gtk_container_add (menubar, topitem)

  menu = gtk_menu_new ()
  gtk_menu_item_set_submenu (topitem, menu)

  item = gtk_image_menu_item_new_from_stock ("gtk-cut")
  gtk_signal_connect( item, "activate", {||Show()} )
  gtk_widget_show( item )
  gtk_container_add( menu, item )

  item = gtk_image_menu_item_new_from_stock ("gtk-copy")
  gtk_widget_show( item )
  gtk_container_add( menu, item )

  item = gtk_image_menu_item_new_from_stock ("gtk-paste")
  gtk_widget_show( item )
  gtk_container_add( menu, item )

  item = gtk_image_menu_item_new_from_stock ("gtk-delete")
  gtk_widget_show( item )
  gtk_container_add( menu, item )

  topitem = gtk_menu_item_new_with_mnemonic("_View")
  gtk_widget_show (topitem)
  gtk_container_add (menubar, topitem)

  topitem = gtk_menu_item_new_with_label("Help")
  gtk_widget_show (topitem)
  gtk_container_add (menubar, topitem)

  menu = gtk_menu_new ()
  gtk_menu_item_set_submenu (topitem, menu)
  item = gtk_image_menu_item_new_with_label ("About...")
  gtk_widget_show( item )
  gtk_container_add( menu, item )

  menu = gtk_menu_new ()
  gtk_menu_item_set_submenu (item, menu)
  item = gtk_image_menu_item_new_with_label ("New item child")
  gtk_widget_show( item )
  gtk_container_add( menu, item )

return NIL

//--------------------------------------------------------------------------//
function MenuAction( widget )
  MsgBox( "Esto es la opcion DOS", GTK_MSGBOX_OK, GTK_MSGBOX_QUESTION )
return NIL

//--------------------------------------------------------------------------//
// Salida directa.
//--------------------------------------------------------------------------//
function Exit( widget )
    gtk_main_quit()
return .F.

//--------------------------------------------------------------------------//
// Salida 'validada'
//--------------------------------------------------------------------------//
function ValidExit( widget )
   if ( MsgBox( "Quieres salir", GTK_MSGBOX_OK+GTK_MSGBOX_CANCEL,;
                GTK_MSGBOX_INFO ) == GTK_MSGBOX_OK )
      Return .F.  // Salimos y matamos la aplicacion.
    endif
return .T.

//--------------------------------------------------------------------------//

Func show()

   Msginfo( "Action", "Info" )

return .t.

//--------------------------------------------------------------------------//

/* fin del ejemplo ---------------------------------------------------------*/



