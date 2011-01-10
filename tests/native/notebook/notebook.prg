/*
 * $Id: notebook.prg,v 1.1 2006-10-31 11:50:23 xthefull Exp $
 * Ejemplo de uso de Notebook con Tablas
 * Porting Harbour to GTK+ power !
 * (C) 2004-05. Rafa Carmona -TheFull-
 * (C) 2004-05. Joaquim Ferrer
*/
#include "gtkapi.ch"


REQUEST HB_CODEPAGE_ESISO

Function Main()
     Local Window, button,  table,  oFont, label,frame, i
     Local notebook

     HB_CDPSELECT( "ESISO" )
     Set_Auto_Utf8( .T. )

     window = gtk_window_new()
     
     gtk_window_set_title ( window, "Notebook")
     gtk_signal_connect (window, "delete-event",{|| gtk_main_quit(), .F. } )
     gtk_signal_connect( window, "destroy", {| widget | gtk_main_quit(), .F. } )
     
     Gtk_container_set_border_width( window, 10 )

     oFont := GFont():New( "Tahoma bold 14" )

     table = gtk_table_new(2,6, .T. )
     gtk_container_add(window, table)
     /* Crea un nuevo libro de notas, indicando la posición de los indicadores */
     
     notebook = gtk_notebook_new ()
     __GSTYLE( "blue",notebook, FGCOLOR, STATE_NORMAL ) // Color
     __GSTYLE( "white",notebook, BGCOLOR, STATE_NORMAL ) // Color
     __GSTYLE( "orange",notebook,BGCOLOR, STATE_ACTIVE ) // Color

     gtk_notebook_set_tab_pos (notebook, GTK_POS_TOP )
     gtk_table_attach_defaults(table, notebook, 0,6,0,1)
     gtk_widget_show( notebook)

      /* le añadimos un montón de páginas al libro de notas  */
      
      FOR I := 1 TO 4

        frame = gtk_frame_new( Str( I,1 ) )
                  __GSTYLE( "red",frame,BASECOLOR, STATE_NORMAL ) // Color
        Gtk_Frame_Set_Shadow_Type( frame, GTK_SHADOW_OUT )
                    gtk_container_set_border_width(frame, 10)
        gtk_widget_set_usize(frame, 100, 75)
        gtk_widget_show(frame)

        label = gtk_label_new( "Append Frame "+Str( I,1 ) )
        gtk_widget_modify_font( label, oFont:pFont )
                    gtk_container_add(frame, label)
        gtk_widget_show(label)
        label = gtk_label_new( Str( I ) )
        gtk_widget_modify_font( label, oFont:pFont )
        gtk_notebook_append_page( notebook, frame, label)
        __GSTYLE( "green", label, FGCOLOR, STATE_NORMAL ) // Color

      NEXT

      /* Y finalmente preañadimos páginas en el libro de notas */
      FOR I := 1 TO 4
         frame = gtk_frame_new( "Prepend Frame " + Str( I , 1 ) )
         gtk_container_set_border_width(frame, 10)
         gtk_widget_set_usize(frame, 100, 75)
                     __GSTYLE( "magenta",frame,BGCOLOR, STATE_NORMAL ) // Color
         gtk_widget_show(frame)

         label = gtk_label_new( "Page "+ Str( I, 1 ) )
         gtk_container_add( frame , label )
         gtk_widget_show (label)

         label = gtk_label_new( "Page "+ Str( I, 1 ) )
         gtk_notebook_prepend_page(notebook, frame, label )
     NEXT

     /* Con esta función, se mostrará una página específica "page 4" */
     gtk_notebook_set_current_page( notebook, 4)

     /* Crea los botones */
    button = gtk_button_new_with_label ("close")
    gtk_signal_connect( button, "clicked", {|| g_signal_emit_by_name( window, "destroy" ) } )
    gtk_table_attach_defaults( table, button, 0, 1, 1, 2)
    gtk_widget_show (button)
*
    button = gtk_button_new_with_label ("next page")
    gtk_signal_connect( button, "clicked", {||next_page( notebook ) } )
    gtk_table_attach_defaults(table, button, 1, 2, 1, 2)
    gtk_widget_show (button)

    button = gtk_button_new_with_label ("prev page")
    gtk_signal_connect( button, "clicked",{|| prev_page( notebook ) } )
    gtk_table_attach_defaults( table, button, 2, 3, 1, 2)
    gtk_widget_show (button)

    button = gtk_button_new_with_label ("tab position")
    gtk_signal_connect( button, "clicked", {|| rotate_book( notebook ) } )
    gtk_table_attach_defaults( table, button, 3, 4, 1, 2)
    gtk_widget_show (button)

    button = gtk_button_new_with_label("tabs/border on/off")
    gtk_signal_connect( button, "clicked", {|| tabsborder_book( notebook )} )
    gtk_table_attach_defaults(table, button, 4, 5, 1, 2)
    gtk_widget_show (button)

    button = gtk_button_new_with_label("remove page")
    gtk_signal_connect( button, "clicked", {|| remove_book( notebook ) } )
    gtk_table_attach_defaults( table, button, 5, 6, 1, 2)
    gtk_widget_show( button )

    gtk_widget_show(table)
    gtk_widget_show (window)

    gtk_main ()
    oFont:End()

return NIL

Function Next_Page( notebook )
  gtk_notebook_next_page( notebook )
return nil

Function Prev_Page( notebook )
  gtk_notebook_prev_page( notebook )
return nil

Function rotate_book( notebook )
   gtk_notebook_set_tab_pos(notebook, ( gtk_notebook_get_tab_pos(notebook) % 4 ))
return nil

Function tabsborder_book( notebook )
    static lShow := .F.

    gtk_notebook_set_show_tabs(notebook, lShow )
    gtk_notebook_set_show_border(notebook, lShow )

    if !lShow
       lShow := .T.
    else
       lShow := .F.
    endif

return NIL

/* Borra una página del notebook */
Function remove_book( notebook )
    Local page := gtk_notebook_get_current_page( notebook )
    gtk_notebook_remove_page (notebook, page )
    /* Con la siguiente función se vuelve a dibujar el notebook
     * para que no se vea la página que ha sido borrada. */
    gtk_widget_queue_draw( notebook )

return nil











