/*
 * $Id: cursor.prg,v 1.1 2006-10-31 11:43:58 xthefull Exp $
 * Ejemplo de uso de cursores
 * Porting Harbour to GTK+ power !
 * (C) 2004-05. Rafa Carmona -TheFull-
 * (C) 2004-05. Joaquim Ferrer
*/
#include "gtkapi.ch"

Static aCursor, aButton

function Main()

  local hWnd, hBox
  aButton := array(4)
  aCursor := array(4)

/* Ventana */
   hWnd := gtk_window_new( GTK_WINDOW_TOPLEVEL )
   gtk_signal_connect( hWnd, "destroy", {|| gtk_main_quit(), .F. } )

/* Caja de 'empaquetamiento'*/
   hBox := gtk_hbox_new( .t., 0 )
   gtk_container_add( hWnd, hBox )
   gtk_widget_show( hBox )

/* Botones */
   aButton[1] := gtk_button_new_with_label( "GDK_SPIDER" )
   gtk_signal_connect( aButton[1], "leave", {|w| button_leave(w) } )
   gtk_signal_connect( aButton[1], "enter", {|w| button_enter(w) } )

   aButton[2] := gtk_button_new_with_label( "GDK_UMBRELLA" )
   gtk_signal_connect( aButton[2], "leave", {|w| button_leave(w) } )
   gtk_signal_connect( aButton[2], "enter", {|w| button_enter(w) } )

   aButton[3] := gtk_button_new_with_label( "GDK_QUESTION_ARROW" )
   gtk_signal_connect( aButton[3], "leave", {|w| button_leave(w) } )
   gtk_signal_connect( aButton[3], "enter", {|w| button_enter(w) } )

   aButton[4] := gtk_button_new_with_label( "GDK_BOX_SPIRAL" )
   gtk_signal_connect( aButton[4], "leave", {|w| button_leave(w) } )
   gtk_signal_connect( aButton[4], "enter", {|w| button_enter(w) } )

   gtk_container_add( hBox, aButton[1] )
   gtk_container_add( hBox, aButton[2] )
   gtk_container_add( hBox, aButton[3] )
   gtk_container_add( hBox, aButton[4] )

/* Method Activate */
   gtk_window_set_title( hWnd, "Test Cursor Gtk for Harbour" )
   gtk_window_set_position( hWnd, GTK_WIN_POS_CENTER )
   gtk_window_set_default_size( hWnd, 300, 300 )

   gtk_widget_show_all( hWnd )

   gtk_Main()


return NIL

//--------------------------------------------------------------------------//

FUNCTION button_leave ( widget )

   DO CASE
      CASE aButton[1] == widget
           if( !Empty( aCursor[1] ) )
               gdk_cursor_unref( aCursor[1] )
           endif
           gdk_window_set_cursor( widget , NIL )
           aCursor[1] := NIL

      CASE aButton[2] == widget
           if( !Empty( aCursor[2] ) )
               gdk_cursor_unref( aCursor[2] )
           endif
           gdk_window_set_cursor( widget , NIL )
            aCursor[2] := NIL

      CASE aButton[3] == widget
           if( !Empty( aCursor[3] ) )
               gdk_cursor_unref( aCursor[3] )
           endif
           gdk_window_set_cursor( widget , NIL)
           aCursor[3] := NIL

      CASE aButton[4] == widget
           if( !Empty( aCursor[4] ) )
               gdk_cursor_unref( aCursor[4] )
           endif
           gdk_window_set_cursor( widget , NIL )
           aCursor[4] := NIL
   ENDCASE

Return .T.

FUNCTION button_enter( widget )

   DO CASE
      CASE aButton[1] == widget
           if( !Empty( aCursor[1] ) )
                gdk_cursor_unref( aCursor[1] )
           endif
           aCursor[1] = gdk_cursor_new( GDK_SPIDER )
           gdk_window_set_cursor( widget , aCursor[1] )

      CASE aButton[2] == widget
           if( !Empty( aCursor[2] ) )
                gdk_cursor_unref( aCursor[2] )
           endif
           aCursor[2] = gdk_cursor_new( GDK_UMBRELLA )
           gdk_window_set_cursor( widget , aCursor[2] )

      CASE aButton[3] == widget
           if( !Empty( aCursor[3] ) )
                gdk_cursor_unref( aCursor[3] )
           endif
           aCursor[3] = gdk_cursor_new( GDK_QUESTION_ARROW )
           gdk_window_set_cursor( widget , aCursor[3] )

      CASE aButton[4] == widget
           if( !Empty( aCursor[4] ) )
                gdk_cursor_unref( aCursor[4] )
           endif
           aCursor[4] = gdk_cursor_new( GDK_BOX_SPIRAL )
           gdk_window_set_cursor( widget , aCursor[4] )
   ENDCASE

Return .T.
