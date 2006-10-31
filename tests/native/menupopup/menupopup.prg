/*
 * TestMenu POPUP. Ejemplo de implementacion de MENUS POPUP
 * Porting Harbour to GTK+ power !
 * (C) 2004. Rafa Carmona -TheFull-
 * (C) 2004. Joaquim Ferrer
 *
 * -> Usando STOCK_ICONS
 */

#include "gtkapi.ch"

function main()
  local menu
  local window

  window := gtk_window_new( GTK_WINDOW_TOPLEVEL )
  gtk_window_set_title( window, "Pulsa boton derecho, tienes un menu-popup!!" )
  gtk_window_set_default_size( window, 500, 350 )
  
  gtk_signal_connect( window, "delete-event", {|w| ValidExit(w) } )

  menu := BuildMenu()
  /* connect our handler which will popup the menu */
  gtk_signal_connect( window, "event", {|w,e| my_popup_handler(w,e,menu ) } )
  
  /*Tenemos que poner que vamos a tratar el raton, de lo contrario sera ignorado
    No veas lo que me costo percatarme de ello , por dios..... */
  gtk_widget_set_events( window, GDK_BUTTON_PRESS_MASK  )

  gtk_widget_show( window )

  gtk_main()


return NIL

FUNCTION my_popup_handler( widget, event, menu )
   Local nEvent_Type, nEvent_Button_Button, nEvent_Button_Time
   
   nEvent_Type          := HB_GET_GDKEVENT_TYPE( event ) 
   nEvent_Button_Button := HB_GET_GDKEVENT_BUTTON_BUTTON( event )
   nEvent_Button_Time   := HB_GET_GDKEVENT_BUTTON_TIME( event )


    if ( nEvent_Type == GDK_BUTTON_PRESS )        // Event_Type
       if ( nEvent_Button_Button == 3)                    // Event->Button.Button
          gtk_menu_popup( menu, NIL, NIL, NIL, NIL, nEvent_Button_Button, nEvent_Button_Time ) // event->button.time
          return .t.
       endif
    endif
    
Return .F.

//--------------------------------------------------------------------------//

function BuildMenu(  )

 local menu, item

  menu = gtk_menu_new ()

  item = gtk_image_menu_item_new_from_stock ("gtk-new" )
  gtk_signal_connect( item, "activate", {|w| Show(w)} )
  gtk_widget_show( item )
  gtk_container_add( menu, item )
  
  item = gtk_image_menu_item_new_from_stock ("gtk-open")
  gtk_signal_connect( item, "activate", {|w| Show(w)} )
  gtk_widget_show( item )
  gtk_container_add( menu, item )

  item = gtk_image_menu_item_new_from_stock ("gtk-save")
  gtk_signal_connect( item, "activate", {|w| Show(w)} )
  gtk_widget_show( item )
  gtk_container_add( menu, item )

  item = gtk_separator_menu_item_new ()
  gtk_widget_show( item )
  gtk_container_add( menu, item )
  
  item = gtk_image_menu_item_new_from_stock ("gtk-save-as")
  gtk_signal_connect( item, "activate", {|w| Menu_Save(w)} )
  gtk_widget_show( item )
   
   gtk_container_add( menu, item )
   


return menu

//--------------------------------------------------------------------------//
function Menu_Save( widget )
  MsgBox( "Salvamos", GTK_MSGBOX_OK, GTK_MSGBOX_QUESTION )
return NIL

//--------------------------------------------------------------------------//
// Salida 'validada'
//--------------------------------------------------------------------------//
function ValidExit( widget )
   if ( MsgBox( "Quieres salir", GTK_MSGBOX_OK+GTK_MSGBOX_CANCEL,;
                GTK_MSGBOX_INFO ) == GTK_MSGBOX_OK )
     gtk_main_quit()
      Return .F.  // Salimos y matamos la aplicacion.
    endif
return .T.

//--------------------------------------------------------------------------//

Func show()

   Msginfo( "Action", "Info" )

return .t.

