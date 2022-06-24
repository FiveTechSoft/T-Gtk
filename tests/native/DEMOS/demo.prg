// VBox, labels y buttons
// 2.Rev. Soporte de ToolTips , togglebutton
// 3.Rev Soporte calendario, hBox y notebook
// 4.Rev Soporte de Expander.
// 5.Rev Soporte de Menus.
// 6.Rev Creamos otra ventana NO-DEPENDIENTE de la principal. Ver Function menuitem()

// GUI T-Gtk para Harbour
// (c)2004 Rafa Carmona

#include "gtkapi.ch"

Static expand

REQUEST HB_CODEPAGE_ESISO

Function Main( )
  Local Button, Window
  Local vBox, label, calendar
  Local cTextLabel, ToolTips, hBox, notebook
  Local vBox2,  vBox_E, cTextExpand, boxmenu, hFont


  HB_CDPSELECT( "ESISO" )
  
  cTextLabel := '<span foreground="blue" size="large"><b>Esto es <span foreground="yellow"'+;
                ' size="xx-large" background="black" ><i>fabuloso</i></span></b>!!!!</span>'+;
                HB_OSNEWLINE()+;
                '<span foreground="red" size="23000"><b><i>T-Gtk power!!</i></b> </span>' +;
                HB_OSNEWLINE()+;
                'Usando un lenguaje de <b>marcas</b> para mostrar textos'

 cTextExpand := '<span foreground="yellow" size="large"><b>Esto es <span foreground="cyan"'+;
                ' size="xx-large" ><i>EXPAND</i></span></b>!!!!</span>'

  Window := Gtk_Window_New( GTK_WINDOW_TOPLEVEL )

  Gtk_window_set_title( Window, "GUI T-Gtk for Harbour by Rafa Carmona" )
  Gtk_window_set_position( Window, GTK_WIN_POS_CENTER )
  Gtk_Signal_Connect( Window, "destroy", {|| Exit() } )  // Cuando se mata la aplicacion
  Gtk_Signal_Connect( Window, "delete-event", {|w| Salida(w) } )  // Cuando se mata la aplicacion

  boxmenu := gtk_vbox_new (.F., 0)
  gtk_container_add( window, boxmenu )
  gtk_widget_show( boxmenu )

  Create_Menus( boxmenu ) // ----> Nos vamos a crear MENUS!!

  hBox   := gtk_hbox_new( .F.,0 )
  Gtk_Widget_Show( hBox )
  gtk_container_add( boxmenu, hBox)

  vBox   := gtk_vbox_new( .F.,0 )
  Gtk_Widget_Show( vBox )
  gtk_container_add( hBox, vBox)

  vBox2   := gtk_vbox_new( .F.,0 )
  Gtk_Widget_Show( vBox2 )
  gtk_container_add( hBox, vBox2)

  calendar   := gtk_calendar_new(  )
  gtk_calendar_select_month( calendar , 3, 1973 )
  gtk_calendar_select_day( calendar, 6 )
  gtk_calendar_mark_day( calendar, 10 ) //marcado
  gtk_calendar_mark_day( calendar, 11 ) //marcado
  gtk_calendar_mark_day( calendar, 12 ) //marcado
  gtk_calendar_set_display_options( calendar, GTK_CALENDAR_NO_MONTH_CHANGE )
  gtk_calendar_set_display_options( calendar, GTK_CALENDAR_SHOW_WEEK_NUMBERS )
  gtk_calendar_set_display_options( calendar, GTK_CALENDAR_SHOW_HEADING )
/*
  gtk_calendar_display_options( calendar, nOr( GTK_CALENDAR_NO_MONTH_CHANGE,;
                                               GTK_CALENDAR_SHOW_WEEK_NUMBERS,;
                                               GTK_CALENDAR_SHOW_HEADING ))
*/

  Gtk_Widget_Show( calendar )
  // Probando las seÃ±ales del calendario
  Gtk_Signal_Connect( calendar, "day-selected-double-click", {|w| CaleSelect(w)} )
  Gtk_Signal_Connect( calendar, "prev-month", {|w|CambioMes(w) } )
  Gtk_Signal_Connect( calendar, "next-month", {|w|CambioMes(w) } )
  gtk_container_add( vBox2, calendar)

  label := gtk_label_new( "GtkLabel" )
  gtk_label_set_markup ( label, cTextLabel )

  Gtk_box_pack_start( vbox, label, .T., .T., 0 )
  Gtk_Widget_Show( label )

  button := Gtk_button_new_with_label( "Hola, ponte en encima" )

  Gtk_Signal_Connect( button, "clicked", {|w|MyClicked(w)} )  // Cuando pulse + suelte el boton
  Gtk_Signal_Connect( button, "leave"  , {|w|MyLeave(w)}   )  // Cuando salga del boton
  Gtk_Signal_Connect( button, "enter"  , {|w|MyEnter(w)}   )  // Cuando entre en el boton

  Gtk_box_pack_start( vbox, button, .F.,.T.,0 )
  gtk_widget_show( button )

/*
  ToolTips := Gtk_ToolTips_New()
  Gtk_tooltips_set_tip( tooltips, button,;
                        "Soporte de ToolTips"+;
                         Hb_OsNewLine()+;
                         "También soporta multilinea..." )
  gtk_tooltips_set_delay( tooltips, 1000 )
*/

  button := Gtk_toggle_button_new_with_label( "Conmutador" )
  gtk_widget_show( button )
  Gtk_box_pack_start( vbox, button, .F.,.T.,0 )
//  Gtk_Signal_Connect( button, "toggled", {|w| EstadoCom( w )} )

  button := Gtk_button_new_with_mnemonic( "_Salida rápida..." )
  gtk_widget_show( button )
  Gtk_box_pack_start( vbox, button, .F.,.T.,0 )
  Gtk_Signal_Connect( button, "clicked", {|| g_signal_emit_by_name( window, "destroy" ) } )

  // Jugando con las expansiones, metemos una caja, y ahi metemos mas controles
  // encima , usamos lenguaje de marcas ;-)
  expand = gtk_expander_new( cTextExpand )
  Gtk_box_pack_start( vbox, expand, .F.,.F.,0 )
  gtk_widget_show( expand )
  gtk_expander_set_use_markup( expand, .T. )

  vBox_E  := gtk_vbox_new( .F.,0 )
  Gtk_Widget_Show( vBox_E )
  gtk_container_add( expand, vBox_E)

  button := gtk_check_button_new_with_label( "CheckBox,será posible.." )
  Gtk_box_pack_start( vbox_E, button, .F.,.T.,0 )
  gtk_widget_show( button )
  Gtk_Signal_Connect( button, "toggled", {|w|EstadoCom(w)} )

  button := Gtk_button_new_with_label( "Texto del Expand" )
  gtk_widget_show( button )
  Gtk_box_pack_start( vbox_E, button, .F.,.T.,0 )
  Gtk_Signal_Connect( button, "clicked", {|w| nombre_expand(w)} )


  Gtk_Widget_Show( Window )

  Gtk_Main()


return NIL

FUNC NOMBRE_EXPAND( widget )

  ? "La etiqueta del Expander es: " + gtk_expander_get_label( expand )

return nil

//--- Funciones para el calendario ------------//
FUNC CaleSelect( widget )
  ? "Double-click Fecha:" , GTK_CALENDAR_GET_DATE( widget )
return nil

FUNC CambioMes( widget )
  ? "Cambio de mes"
RETURN NIL
//--- Funciones para el calendario ------------//

Func EstadoCom( widget )
  ? "Pues ahora estoy.." , gtk_toggle_button_get_active( widget )
return nil

Function MYCLICKED( widget )
 gtk_button_set_label( widget, "CLICK_CLICK" )
return nil

Function MYLEAVE( widget )
  gtk_button_set_label( widget, "Hola, ponte en encima" )
  ?. "El texto es: "+ str2utf8( GTK_BUTTON_GET_LABEL( widget ) )
return nil

Function MYENTER( widget )
 gtk_button_set_label( widget, "Estoy en el botón" )
 ?. "El texto es: " + str2utf8( GTK_BUTTON_GET_LABEL( widget ) )
return nil


//Salida controlada del programa.
Function Salida( widget )

   if ( MsgBox( "Quieres salir", GTK_MSGBOX_OK+GTK_MSGBOX_CANCEL,;
                GTK_MSGBOX_INFO ) == GTK_MSGBOX_OK )
      Return .F.  // Salimos y matamos la aplicacion.
    endif

return .T.

//Salida directa.
Function Exit( widget )

    gtk_main_quit()

return .T.

/*
 Ejemplo de la construccion de un menu cualquiera
 */
FUNCTION Create_Menus( boxmenu )
         Local menubar, menu, root_menu, menuitem,;
               menuitem2, submenu, submenuitem, menuitemcheck, separator,;
               image,menuitemimage

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
         gtk_signal_connect( menuitemcheck, "toggled", {|w| Menutoggle(w)} )

         separator = gtk_separator_menu_item_new()

         menuitemimage := gtk_image_menu_item_new_with_label( "Con imagen ;-)" )
         gtk_image_menu_item_set_image( menuitemimage, image )

         gtk_menu_append( menu, menuitemimage )                  // Añado Items al menu
         gtk_menu_append( menu, menuitem )                   // Añado Items al menu
         gtk_menu_append( menu, menuitem2 )                  // Añado Items al menu
         gtk_menu_append( menu, separator )                  // Añado Items al menu
         gtk_menu_append( menu, menuitemcheck )                  // Añado Items al menu

         gtk_widget_show( menuitem  )                        // HAY que mostrarlos, ojo
         gtk_widget_show( menuitem2 )
         gtk_widget_show( separator )
         gtk_widget_show( menuitemcheck )
         gtk_widget_show( menuitemimage )

         submenu := gtk_menu_new() // No es necesario mostrar por ser un contenedor
          submenuitem := gtk_menu_item_new_with_label( "Uno de UNO" )   // Item del menu
          gtk_menu_append( submenu, submenuitem )                       // Añado Items al menu
          gtk_widget_show( submenuitem  )                               // HAY que mostrarlos, ojo
          gtk_menu_item_set_submenu( menuitem, submenu )                // asociar a menuitem el submenu
          gtk_signal_connect( submenuitem , "activate", {|w| Menuitem( w )} )    // Salta a la opcion 1.1

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
       Gtk_Signal_Connect( Window, "destroy", {|w| Exit( w )} )
       Gtk_Signal_Connect( Window, "delete-event", {|w| Salida( w ) } )
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



