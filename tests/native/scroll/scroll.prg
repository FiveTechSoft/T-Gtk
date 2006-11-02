/*
 * $Id: scroll.prg,v 1.1 2006-11-02 12:41:40 xthefull Exp $
 * Scroll.prg - Test de ejemplo de uso de las barras scroll ------------------
 * (C) 2004-05. Rafa Carmona -TheFull-
 * (C) 2004-05. Joaquim Ferrer
 *
 * Explicación de parámetros:
 * nLower = the minimum value.
 * nUpper = the maximum value.
 * nValue = the current value.
 * nStep_increment = the increment to use to make minor changes to
 *                   the value. In a GtkScrollbar this increment is
 *                   used when the mouse is clicked on the arrows at
 *                   the top and bottom of the scrollbar, to scroll
 *                   by a small amount.
 * nPage_increment = the increment to use to make major changes to the value.
 *                   In a GtkScrollbar this increment is used when the mouse
 *                   is clicked in the trough, to scroll by a large amount.
 * nPage_size      = the page size. In a GtkScrollbar this is the size of
 *                   the area which is currently visible.
 */

#include "gtkapi.ch"

static skip := 1

function gtk_exit() ; gtk_main_quit() ; return .f.

function scrolled( scroll )

 local adjust := gtk_range_get_adjustment (scroll)
 local value  := gtk_adjustment_get_value (adjust)
 local orientation := gtk_range_get_orientation (scroll)
 
  if orientation > 0
     ? "vertical scroll "
  else
     ? "horizontal scroll "
  endif
        
  if value > skip
     ? "go_down "
  else
     ? "go_up "
  endif      
  skip = value

return .t.

function main()

  local hWnd, vAdjust, hAdjust, hScroll, vScroll, table, pImage
  local nLower := 1.0
  local nUpper := 100.0
  local nValue := 1.0
  local nStep_increment := 2.0
  local nPage_increment := 20.0
  local nPage_size      := 0.0
  local nRows := 2, nCols := 3
  local left_col, right_col, top_row, bottom_row 
  
/* Ventana */
   hWnd := gtk_window_new( GTK_WINDOW_TOPLEVEL )
   gtk_window_set_title( hWnd, "Test Gtk+ Scrollbar for Harbour" )
   gtk_window_set_position( hWnd, GTK_WIN_POS_CENTER )
   gtk_signal_connect( hWnd, "destroy", {|| gtk_exit()} )

/* Tabla de 'empaquetamiento' */
   table = gtk_table_new( nRows, nCols, FALSE )
   gtk_container_add( hWnd, table )
   
/* 'Ajustes para scrolls' */
   vAdjust := gtk_adjustment_new( nValue, nLower, nUpper, nStep_increment,;
                                  nPage_increment, nPage_size )
   hAdjust := gtk_adjustment_new( nValue, nLower, nUpper, nStep_increment,;
                                  nPage_increment, nPage_size )
/* Horizontal scroll */
   left_col   := 1
   right_col  := 2
   top_row    := 2
   bottom_row := 3   
   hScroll    := gtk_hscrollbar_new( hAdjust )
   gtk_table_attach( table, hScroll, left_col, right_col, top_row, bottom_row,;
                     nOr( GTK_EXPAND , GTK_FILL ), GTK_FILL, 0, 0 )
   gtk_signal_connect( hScroll, "value-changed",{|w| scrolled(w)} )
   
/* Vertical scroll */  
   left_col   := 2
   right_col  := 3
   top_row    := 1
   bottom_row := 2
   vScroll    := gtk_vscrollbar_new( vAdjust )
   gtk_table_attach( table, vScroll, left_col, right_col, top_row, bottom_row,;
                     GTK_FILL, nOR( GTK_EXPAND, GTK_FILL), 0, 0 )
   gtk_signal_connect( vScroll, "value-changed", {|w| scrolled(w) } )
   
/* Imagen */    
   left_col   := 1
   right_col  := 2
   top_row    := 1
   bottom_row := 2
   pImage     := gtk_image_new_from_file( "../../images/logo.png" )
   gtk_table_attach( table, pimage, left_col, right_col, top_row, bottom_row,;
                     nOr( GTK_EXPAND, GTK_FILL ), GTK_FILL, 0, 0 )
                     
   gtk_widget_show_all( hWnd )
   gtk_main()

return NIL

//--------------------------------------------------------------------------//

