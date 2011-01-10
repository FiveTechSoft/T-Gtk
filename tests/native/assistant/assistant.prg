/*
 * $Id: assistant.prg,v 1.1 2007-03-02 08:21:32 xthefull Exp $
 * Ejemplo de GtkAssistant.
 * Porting Harbour to GTK+ power !
 * (C) 2007. Rafa Carmona -TheFull-
*/

//recordad que por compatibilidad con harbour
//no podeis usar TRUE/FALSE

#include "gtkapi.ch"



function main()
    local assistant

    assistant = gtk_assistant_new()
    gtk_window_set_default_size( assistant, -1, 300)
    
    create_page1( assistant )
    create_page2( assistant )
    create_page3( assistant )

    g_signal_connect( assistant, "cancel", { | as | gtk_widget_destroy( as ), gtk_main_quit() } )
    g_signal_connect( assistant, "close",  { | as | gtk_widget_destroy( as ), gtk_main_quit() } )
    g_signal_connect( assistant, "prepare",{| assistant,page| on_assistant_prepare( assistant, page ) } )
    g_signal_connect( assistant, "apply",  {|| on_assistant_apply( ) } )
    
    gtk_widget_show( assistant )

    gtk_Main()

return NIL

Static Function create_page1( assistant )
  Local box, label, entry, pixbuf

  box = gtk_hbox_new (.F., 12)
  
  gtk_container_set_border_width( box, 12)

  label = gtk_label_new( "You must fill out this entry to continue:" )
  gtk_box_pack_start( box, label, .F., .F., 0)

  entry = gtk_entry_new ()
  gtk_box_pack_start( box, entry, .T., .T., 0)
  g_signal_connect( entry , "changed", {|p| on_entry_changed( p, assistant ) } )

  gtk_widget_show_all (box)
  gtk_assistant_append_page( GTK_ASSISTANT( assistant ), box)
  gtk_assistant_set_page_title( GTK_ASSISTANT( assistant ), box, "Page 1")
  gtk_assistant_set_page_type( GTK_ASSISTANT( assistant ), box, GTK_ASSISTANT_PAGE_INTRO )

  pixbuf = gtk_widget_render_icon(assistant, GTK_STOCK_DIALOG_INFO, GTK_ICON_SIZE_DIALOG, NIL )
  gtk_assistant_set_page_header_image( GTK_ASSISTANT( assistant ), box, pixbuf)
  g_object_unref( pixbuf )
 
 return nil

static function create_page2( assistant)
 Local box, checkbutton, pixbuf

  box = gtk_vbox_new (12, .F.)
  gtk_container_set_border_width( box, 12)


  checkbutton = gtk_check_button_new_with_label( "This is optional data, you may continue "+;
                         "even if you do not check this")
  gtk_box_pack_start( box, checkbutton, .F., .F., 0)

  gtk_widget_show_all(box)
  gtk_assistant_append_page( assistant, box)
  gtk_assistant_set_page_complete( assistant, box, .T.)
  gtk_assistant_set_page_title( assistant, box, "Page 2")

  pixbuf = gtk_widget_render_icon (assistant, GTK_STOCK_DIALOG_INFO, GTK_ICON_SIZE_DIALOG, NIL)
  gtk_assistant_set_page_header_image (GTK_ASSISTANT (assistant), box, pixbuf)
  g_object_unref (pixbuf)

return nil

Static Function create_page3( assistant )
  Local label, pixbuf

  label = gtk_label_new ("This is a confirmation page, press 'Apply' to apply changes")

  gtk_widget_show (label)
  gtk_assistant_append_page (GTK_ASSISTANT (assistant), label)
  // Es muy importante definir en la ultima pagina el tipo de finalizacion, de lo contrario
  // se caera el programa, ver más info en la ayuda de la funcion _set_page_type.
  gtk_assistant_set_page_type (GTK_ASSISTANT (assistant), label, GTK_ASSISTANT_PAGE_CONFIRM)
  gtk_assistant_set_page_complete (GTK_ASSISTANT (assistant), label, .T.)
  gtk_assistant_set_page_title (GTK_ASSISTANT (assistant), label, "Confirmation")

  pixbuf = gtk_widget_render_icon (assistant, GTK_STOCK_DIALOG_INFO, GTK_ICON_SIZE_DIALOG, NIL)
  gtk_assistant_set_page_header_image (GTK_ASSISTANT (assistant), label, pixbuf)
  g_object_unref (pixbuf)

return nil

static function on_assistant_apply( )

 /* Apply here changes, this is a fictional example, so we just do nothing here */
 MsgInfo( "yes...Apply changes a your computer...", "Attention" )

return nil

static function on_entry_changed( GtkWidget , assistant )
   Local current_page, page_number, text

  page_number = gtk_assistant_get_current_page (assistant)
  current_page = gtk_assistant_get_nth_page (assistant, page_number)
  text = gtk_entry_get_text( GtkWidget )

  if ! Empty( text  )
    gtk_assistant_set_page_complete( assistant, current_page, .T. )
  else
    gtk_assistant_set_page_complete( assistant, current_page, .F. )
  endif

return nil

static function on_assistant_prepare( widget, page )
  Local current_page, n_pages, title

  current_page = gtk_assistant_get_current_page (GTK_ASSISTANT (widget))
  n_pages = gtk_assistant_get_n_pages( GTK_ASSISTANT( widget ) )

  title = "Sample assistant ("+ str( current_page + 1,1 ) + " of "+  Str( n_pages, 1) + " )"
  gtk_window_set_title( GTK_WINDOW (widget), title )
  
return nil
