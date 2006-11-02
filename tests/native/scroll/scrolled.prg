/*
 * $Id: scrolled.prg,v 1.1 2006-11-02 12:41:40 xthefull Exp $
 * Scrolled.prg - Test de ejemplo de uso de las scrolled window ------------------
 * (C) 2004-05. Rafa Carmona -TheFull-
 * (C) 2004-05. Joaquim Ferrer
 *
 * Notas by Quim :
 * --------------
 * Dentro del estudio general de las barras de scroll, me ha
 * llevado a este ejemplo, que es prácticamente igual al original
 * en C que se puede encontrar fácilmente en los grupos de desarrollo
 * de Gtk+, lo que demuestra la altisima compatibilidad de codigo
 * de T-Gtk [x]Harbour y Gtk+ en C, salvando unas minimas diferencias
 * en cuanto a sintaxis de lenguaje. Dejo los comentarios -en ingles-
 * originales :-)
 */

#include "gtkapi.ch"

function exit( widget ) ;  gtk_main_quit()  ; return .f. 

function Salimos( widget , event )
    
  if MsgNoYes( UTF_8( "¿ Esta seguro de salir ?" ), "Atencion" )
    return .F.
  endif

return .T.

function main()

  local window, scrolled, table, button
  local buffer, i, j
    
    /* Create a new dialog window for the scrolled window to be
     * packed into.  
     */
    window := gtk_dialog_new()
     
    gtk_signal_connect( window, "delete-event", {|widget,event| Salimos( widget,event ) } )
    gtk_signal_connect( window, "destroy", {| widget | Exit( widget) } )
    
    gtk_window_set_title( window, "GtkScrolledWindow example" )
    
    gtk_container_set_border_width( window, 0 )
    gtk_widget_set_usize( window, 300, 300 )
    
    /* create a new scrolled window. */
    scrolled = gtk_scrolled_window_new(NIL, NIL )
    gtk_container_set_border_width( scrolled, 10 )
        
    /* the policy is one of GTK_POLICY AUTOMATIC, or GTK_POLICY_ALWAYS.
     * GTK_POLICY_AUTOMATIC will automatically decide whether you need
     * scrollbars, whereas GTK_POLICY_ALWAYS will always leave the scrollbars
     * there.  The first one is the horizontal scrollbar, the second, 
     * the vertical. 
     */
    gtk_scrolled_window_set_policy( scrolled,;
                                    GTK_POLICY_AUTOMATIC, GTK_POLICY_ALWAYS )
                                    
    /* The dialog window is created with a vbox packed into it. */								
    gtk_box_pack_start( HB_GTK_GET_DLG_BOX( window ), scrolled, TRUE, TRUE, 0 )
       
    /* create a table of 10 by 10 squares. */
    table = gtk_table_new (10, 10, FALSE)
    
    /* set the spacing to 10 on x and 10 on y */
    gtk_table_set_row_spacings( table, 10 )
    gtk_table_set_col_spacings( table, 10 )
    
    /* pack the table into the scrolled window */
    gtk_scrolled_window_add_with_viewport( scrolled, table )
     
    for i := 0 to 10
        for j := 0 to 10
          buffer := "button ("+ str(i) + "," + str(j) + ")"
          button := gtk_toggle_button_new_with_label( buffer )
          gtk_table_attach_defaults( table, button, i, i+1, j, j+1 )
        next  
    next
    
    /* Add a "close" button to the bottom of the dialog */
    button := gtk_button_new_with_label( "close" )

    gtk_signal_connect( button, "clicked", {|| g_signal_emit_by_name( window, "destroy" ) } )
    gtk_box_pack_start( HB_GTK_GET_DLG_ACTION_AREA( window ), button, TRUE, TRUE, 0 )
    
    gtk_widget_show_all( window )
    gtk_main()

return NIL

//--------------------------------------------------------------------------//
