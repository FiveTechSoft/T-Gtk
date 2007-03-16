/*
 * Example GtkStatusIcon
 * (c)2007 Rafa Carmona
 */

#include "gclass.ch"

#define TEST_STATUS_INFO 0
#define TEST_STATUS_QUESTION 1

static status := TEST_STATUS_INFO

function main()
  local menu
  local window, icon, oTimer

  icon := gtk_status_icon_new()
  update_icon(icon)
  g_signal_connect( icon, "popup-menu",{|w, button, activate_time | popup_menu( w, button, activate_time ) } )
  g_signal_connect( icon, "activate",  {|w| icon_activated(w) } )
  
  DEFINE TIMER oTimer ACTION timeout_handler( icon ) INTERVAL 2000
  ACTIVATE TIMER oTimer

  gtk_main()


return 0

function icon_activated( icon )
   static dialog

   if dialog = NIL 
       dialog := ;
       gtk_dialog_new_with_buttons( "Title StatusIcon", NIL, GTK_DIALOG_MODAL,;
                                    GTK_STOCK_OK, GTK_RESPONSE_ACCEPT,;
                                    GTK_STOCK_CANCEL, GTK_RESPONSE_CANCEL )

       gtk_window_set_position (dialog, GTK_WIN_POS_CENTER)
       g_signal_connect(dialog, "response",     {|w|gtk_widget_hide(w)} )
       g_signal_connect(dialog, "delete-event", {|w|gtk_widget_hide_on_delete( w ) } )
       g_signal_connect(dialog, "destroy", {|| dialog := NIL } )

       gtk_widget_show( dialog )
   endif
   
   gtk_window_present( GTK_WINDOW( dialog ) )

return nil
    
function update_icon( status_icon )
  Local icon_name, tooltip

  if (status == TEST_STATUS_INFO)
      icon_name := GTK_STOCK_DIALOG_INFO
      tooltip   := "Some Infromation ..."
  else
      icon_name = GTK_STOCK_DIALOG_QUESTION
      tooltip = "Some Question ..."
  endif

  gtk_status_icon_set_from_icon_name (status_icon, icon_name)
  gtk_status_icon_set_tooltip( status_icon, tooltip ) 

return nil

Function popup_menu ( icon, button, activate_time )
  Local menu, menuitem

  menu = gtk_menu_new ()

  menuitem = gtk_check_menu_item_new_with_label ("Blink")
  gtk_check_menu_item_set_active( GTK_CHECK_MENU_ITEM (menuitem), gtk_status_icon_get_blinking (icon) )
  g_signal_connect( menuitem, "activate", {|widget| check_activated( widget, icon ) } )

  gtk_menu_shell_append( GTK_MENU_SHELL( menu ), menuitem)

  gtk_widget_show (menuitem)

  menuitem = gtk_menu_item_new_with_label ("Quit")
  g_signal_connect(menuitem, "activate", {||do_quit( icon ) } )

  gtk_menu_shell_append( GTK_MENU_SHELL( menu ), menuitem )

  gtk_widget_show (menuitem)

  gtk_menu_popup ( GTK_MENU( menu ),;
                   NIL, NIL, NIL, NIL,; 
                   button, activate_time);

return nil

function do_quit( icon )
  gtk_status_icon_set_visible( icon, .F.)
  g_object_unref (icon)
  gtk_main_quit()
return nil

function check_activated( item, icon )
  gtk_status_icon_set_blinking (icon, gtk_check_menu_item_get_active (item ) )
return nil
    

function timeout_handler( icon )

  if (status == TEST_STATUS_INFO)
    status := TEST_STATUS_QUESTION
  else
    status := TEST_STATUS_INFO
  endif
    
   update_icon (icon)

return .T.



