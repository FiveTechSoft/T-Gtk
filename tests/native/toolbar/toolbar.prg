/*
 * $Id: toolbar.prg,v 1.1 2006-11-02 12:41:41 xthefull Exp $
 * Ejemplo de toolbars , menus y status bar.
 * Porting Harbour to GTK+ power !
 * (C) 2004-05. Rafa Carmona -TheFull-
 * (C) 2004-05. Joaquim Ferrer
*/

#include "gclass.ch"

static status_bar
static context_id

Function Main( )
    Local window, vbox, toolbar, toolbutton, ToolTips, Group,;
      BoxMenu, oWindow, radio, radiop,separator, image, hbox, menutool

    /* crear una nueva ventana */
    window = gtk_window_new( GTK_WINDOW_TOPLEVEL )
    gtk_widget_set_usize( window, 300, 400 )
    gtk_window_set_title( window, "T-GTK Toolbar Example" )

    gtk_signal_connect( window, "delete-event", {||gtk_exit()} )

    boxmenu := gtk_vbox_new (FALSE, 0)
    gtk_container_add( window, boxmenu )
    gtk_widget_show( boxmenu )

    Create_Menus( boxmenu ) // ----> Nos vamos a crear MENUS!!

    hBox   := gtk_hbox_new( .F.,0 )
    Gtk_Widget_Show( hBox )
    gtk_container_add( boxmenu, hBox)

    vbox = gtk_vbox_new( FALSE, 0)
    gtk_container_add( hBox, vbox)
    gtk_widget_show(vbox)

		// toolbars
    toolbar := gtk_toolbar_new()
    gtk_widget_show(toolbar)
    gtk_box_pack_start( vbox, toolbar, FALSE, FALSE, 2)

    separator = gtk_separator_tool_item_new()
    gtk_toolbar_insert ( toolbar, separator, -1 )
    gtk_widget_show(separator)

    toolbutton := gtk_tool_button_new_from_stock( GTK_STOCK_OK )
    gtk_tool_item_set_expand ( toolbutton , FALSE )
    gtk_toolbar_insert ( toolbar, toolbutton, -1 )
    gtk_widget_show(toolbutton)


    toolbutton := gtk_tool_button_new_from_stock( GTK_STOCK_OPEN )
    gtk_tool_item_set_expand ( toolbutton , TRUE )
    gtk_widget_show(toolbutton)
    gtk_toolbar_insert ( toolbar, toolbutton, 0 )

    separator = gtk_separator_tool_item_new()
    gtk_toolbar_insert ( toolbar, separator, -1 )
    gtk_widget_show(separator)
    
    // Un togglebutton en la barra de herramientas
    toolbutton := gtk_toggle_tool_button_new_from_stock( GTK_STOCK_NEW )
    gtk_toggle_tool_button_set_active( toolbutton, .T. )
    // Atentos, esto lo pone PRE ;-)
    gtk_toolbar_insert ( toolbar, toolbutton, 0 )
    gtk_signal_connect( toolbutton, "toggled" , {|w|Estado(w)} )
    gtk_widget_show(toolbutton)

    ToolTips := Gtk_ToolTips_New()
    gtk_tool_item_set_tooltip( toolbutton, tooltips, "Hola. ToolTips Activados" )

    //Ejemplo de colocacion de Texto y Stock_ID
    toolbutton := gtk_tool_button_new()
    GTK_TOOL_BUTTON_SET_LABEL( toolbutton, "TEXTO PUESTO" )
    gtk_toolbar_insert ( toolbar, toolbutton, -1 )
    gtk_tool_button_set_stock_id( toolbutton, GTK_STOCK_STOP )
    gtk_widget_show(toolbutton)

    separator = gtk_separator_tool_item_new()
    gtk_toolbar_insert ( toolbar, separator, 0)
    gtk_widget_show(separator)

    radio := gtk_radio_tool_button_new_from_stock( group, GTK_STOCK_GOTO_LAST)
    gtk_toolbar_insert ( toolbar, radio, 0 )
    gtk_widget_show(radio)

    group := gtk_radio_tool_button_get_group( radio )
    radio := gtk_radio_tool_button_new_from_stock(group, GTK_STOCK_GOTO_FIRST)
    gtk_toolbar_insert ( toolbar, radio, 0 )
    gtk_widget_show(radio)


    radiop := gtk_radio_tool_button_new_with_stock_from_widget( radio, GTK_STOCK_HARDDISK )
    gtk_toolbar_insert ( toolbar, radiop, 0 )
    gtk_widget_show(radiop)
   
    menutool = gtk_menu_tool_button_new_from_stock( GTK_STOCK_OPEN )
    gtk_toolbar_insert ( toolbar, menutool, 0 )
    gtk_menu_tool_button_set_menu( menutool, MiMenuToolBar() )
    gtk_widget_show( menutool )

    image = gtk_image_new()
    gtk_image_set_from_file( image,"../../images/logo.png" )
    Gtk_box_pack_start( vbox, image , TRUE, TRUE,0 )
    gtk_widget_show (image)

    status_bar = gtk_statusbar_new()
    gtk_box_pack_end( vbox, status_bar, FALSE, FALSE, 0)
    gtk_widget_show (status_bar)

    context_id = gtk_statusbar_get_context_id( status_bar, "Statusbar example")
    gtk_statusbar_push( status_bar, context_id, "Status Example" )

    gtk_widget_show(window)
    gtk_main ()

return nil

Function gtk_exit() ;  gtk_main_quit() ; return .F.

Function Estado( pWidget )

	? "Estado: "+ if( GTK_TOGGLE_TOOL_BUTTON_GET_ACTIVE( pWidget ),"Activo", "No Activo" )

Return .t.

/*
 Ejemplo de la construccion de un menu cualquiera
 */
FUNCTION Create_Menus( boxmenu )
    Local menubar, menu, root_menu, menuitem,;
          menuitem2, submenu, submenuitem, menuitemcheck, separator,;
          image,menuitemimage, menuitemstock, menuradio1,menuradio2,menuradio3, group

    // Poniendo Menus ..........................
    // Barra de para contener a los menus
    image = gtk_image_new()
    gtk_image_set_from_file( image,"../../images/gnome-logo.png" )

    menubar := gtk_menu_bar_new()
    gtk_box_pack_start ( boxmenu, menubar, FALSE, TRUE, 0)
    gtk_widget_show( menubar )

    /* Creamos un menu */
    menu := gtk_menu_new() // No es necesario mostrar por ser un contenedor
    /* Crea items para ese menu */
    menuitem := gtk_menu_item_new_with_label( "Crear VENTANA" )   // Item del menu
 
    menuitem2 := gtk_menu_item_new_with_label( "Dos" )  // Item del menu
    gtk_signal_connect( menuitem2, "activate", {|w| Menuitem2(w)} ) // Salta a la opcion 2

    menuitemcheck := gtk_check_menu_item_new_with_label( "Esto es check" )
    gtk_check_menu_item_set_draw_as_radio( menuitemcheck, TRUE )
    gtk_signal_connect( menuitemcheck, "toggled", {|w|Menutoggle(w)} )

    separator = gtk_separator_menu_item_new()

    menuitemimage := gtk_image_menu_item_new_with_label( "Con imagen ;-)" )
    gtk_image_menu_item_set_image( menuitemimage, image )

    menuitemstock := gtk_image_menu_item_new_from_stock( GTK_STOCK_APPLY )

    // ejemplo de menuradios.
    menuradio1 = gtk_radio_menu_item_new_with_label( NIL ,"Radio1" )
    group = gtk_radio_menu_item_get_group( menuradio1 )
    menuradio2 = gtk_radio_menu_item_new_with_label( group , "Radio2" )
    group = gtk_radio_menu_item_get_group( menuradio2 )
    menuradio3 = gtk_radio_menu_item_new_with_label( group , "Radio3" )

    gtk_menu_append( menu, menuradio1 )                  // Añado Items al menu
    gtk_menu_append( menu, menuradio2 )                  // Añado Items al menu
    gtk_menu_append( menu, menuradio3 )                  // Añado Items al menu
    gtk_widget_show( menuradio1 )
    gtk_widget_show( menuradio2 )
    gtk_widget_show( menuradio3 )

    gtk_menu_append( menu, menuitemimage )                  // Añado Items al menu
    gtk_menu_append( menu, menuitem )                   // Añado Items al menu
    gtk_menu_append( menu, menuitem2 )                  // Añado Items al menu
    gtk_menu_append( menu, separator )                  // Añado Items al menu
    gtk_menu_append( menu, menuitemcheck )                  // Añado Items al menu
    gtk_menu_append( menu, menuitemstock )                  // Añado Items al menu

    gtk_widget_show( menuitem  )                        // HAY que mostrarlos, ojo
    gtk_widget_show( menuitem2 )
    gtk_widget_show( separator )
    gtk_widget_show( menuitemcheck )
    gtk_widget_show( menuitemimage )
    gtk_widget_show( menuitemstock )

    submenu := gtk_menu_new() // No es necesario mostrar por ser un contenedor
    submenuitem := gtk_menu_item_new_with_label( "Uno de UNO" )   // Item del menu
    gtk_menu_append( submenu, submenuitem )                       // Añado Items al menu
    gtk_widget_show( submenuitem  )                               // HAY que mostrarlos, ojo
    gtk_menu_item_set_submenu( menuitem, submenu )                // asociar a menuitem el submenu
    gtk_signal_connect( submenuitem , "activate", {|w|Menuitem(w)} )    // Salta a la opcion 1.1

    /* Crea el item "Ejemplo" */
    root_menu = gtk_menu_item_new_with_label("Ejemplo")
    /* Asociar el menú con el item "Ejemplo" root_menu  */
    gtk_menu_item_set_submenu( root_menu, menu )
    gtk_widget_show(root_menu)
    /* Por último, se añade el menú a la barra de menús */
    gtk_menu_shell_append( menubar, root_menu )

    // Fin de Menus ..............................

 Return NIL


// Ejemplo de creacion de OTRA ventana y NO-Dependiente de la principal
Function menuitem( widget )
Local Window
    MsgBox( "Creamos una nueva ventana", GTK_MSGBOX_OK, GTK_MSGBOX_INFO )

    Window := Gtk_Window_New( GTK_WINDOW_TOPLEVEL )
    Gtk_window_set_position( Window, GTK_WIN_POS_CENTER )
    Gtk_Signal_Connect( Window, "delete-event", {||gtk_exit()} )
    Gtk_Widget_Show( Window )
    gtk_main()                // Otro bucle de mensajes.

Return nil

Function menuitem2( widget )

    MsgBox( "Esto es la opcion DOS", GTK_MSGBOX_OK, GTK_MSGBOX_QUESTION )

return nil

Function MenuToggle( widget )

    MsgBox( "Cambiado el estado del menu check "+HB_OSNEWLINE()+;
            " Ahora esta : " + if( GTK_CHECK_MENU_ITEM_GET_ACTIVE( widget ),"Activo","Desactivado" ),;
             GTK_MSGBOX_OK, GTK_MSGBOX_QUESTION )
return nil

Function MiMenuToolBar()
    Local menu, menuitem, menuitem2, menuitemcheck, separator

    menu := gtk_menu_new() // No es necesario mostrar por ser un contenedor
    /* Crea items para ese menu */
    menuitem := gtk_menu_item_new_with_label( "Crear VENTANA" )   // Item del menu
    gtk_signal_connect( menuitem, "activate", {|w|Menuitem(w)} )

    menuitem2 := gtk_menu_item_new_with_label( "Dos" )  // Item del menu
    gtk_signal_connect( menuitem2, "activate", {|w|Menuitem2(w)} ) // Salta a la opcion 2

    separator = gtk_separator_menu_item_new()
     
    menuitemcheck := gtk_check_menu_item_new_with_label( "Esto es check" )
    gtk_check_menu_item_set_draw_as_radio( menuitemcheck, TRUE )
    gtk_signal_connect( menuitemcheck, "toggled", {|w| Menutoggle(w)} )

    separator = gtk_separator_menu_item_new()
    gtk_menu_append( menu, menuitem )                   // Añado Items al menu
    gtk_menu_append( menu, menuitem2 )                  // Añado Items al menu
    gtk_menu_append( menu, separator )                  // Añado Items al menu
    gtk_menu_append( menu, menuitemcheck )                  // Añado Items al menu

    gtk_widget_show( menuitem  )                        // HAY que mostrarlos, ojo
    gtk_widget_show( menuitem2 )
    gtk_widget_show( separator )
    gtk_widget_show( menuitemcheck )

Return menu
