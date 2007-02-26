/*
 Gtk Print 
 Requiered GTK 2.10
 */
 
#include "gclass.ch"

/* In points */
#define HEADER_HEIGHT (10*72/25.4)
#define HEADER_GAP (3*72/25.4)

Function Main( )
     Local op := gtk_print_operation_new()
     Local cError 
     
     g_signal_connect ( op, "begin-print", { |op,context| begin_print( op,context ) } )
     g_signal_connect ( op, "end-print",   { |op,context| g_print( "Finally print" )} )
     g_signal_connect ( op, "draw-page",   { |op,context,n_page| draw_page( op,context,n_page ) } )
     g_signal_connect ( op, "request-page-setup",   { |op,context,n_page,setup| request_page( op,context,n_page,setup ) } )
     
     #ifdef __PDF__   // Por ejemplo, exportamos a PDF
         gtk_print_operation_set_export_filename( op, "file.pdf" )
         gtk_print_operation_run( op, GTK_PRINT_OPERATION_ACTION_EXPORT, NIL, @cError)
     #else
         gtk_print_operation_run( op, GTK_PRINT_OPERATION_ACTION_PRINT_DIALOG, NIL, @cError)
     #endif

     g_object_unref( op )

     if !Empty( cError )
        MsgInfo( cError )
     endif

return nil

static function begin_print( op, context )
 
 gtk_print_operation_set_n_pages( op, 3 ) //Three pages for print
 gtk_print_operation_set_unit( op, GTK_UNIT_MM)

return nil

static function draw_page( op, context, n_page )
  Local cr, layout, width, desc, layout_height, text_height, pagesetup
  
  cr := gtk_print_context_get_cairo_context( context )
  width := gtk_print_context_get_width( context )
  
  if n_Page != 1

      cairo_rectangle(cr, 0, 0, width, HEADER_HEIGHT)
      cairo_set_source_rgb(cr, 0.8, 0.8, 0.8 )
      cairo_fill( cr )
   
      layout := gtk_print_context_create_pango_layout (context)
  
      desc := pango_font_description_from_string ("sans 14")
      pango_layout_set_font_description(layout, desc)
      pango_font_description_free(desc)
  
      pango_layout_set_text( layout, "Page: " +str( ++n_Page, 1 ), -1 )
      pango_layout_set_width( layout, width )
      pango_layout_set_alignment( layout, PANGO_ALIGN_CENTER )
                  
      pango_layout_get_size( layout, , @layout_height )
      text_height := layout_height / PANGO_SCALE
  
      cairo_move_to(cr, width / 2,  (HEADER_HEIGHT - text_height) / 2 )
      pango_cairo_show_layout(cr, layout )
      g_object_unref( layout ) 
  
      cairo_set_source_rgb(cr, 1.0, 0.5, 0.5 )
      layout = gtk_print_context_create_pango_layout (context)
  
      desc = pango_font_description_from_string( "sans 12")
      pango_layout_set_font_description (layout, desc)
      pango_font_description_free (desc)
  
      pango_layout_set_alignment (layout, PANGO_ALIGN_RIGHT)
      pango_layout_set_text( layout, "This T-Gtk Print", -1 )
      cairo_move_to( cr, 0, HEADER_HEIGHT + HEADER_GAP)
      pango_cairo_show_layout (cr, layout)
  
      cairo_set_source_rgb(cr, 0.0, 0.5, 0.5 )
      pango_layout_set_text( layout, "This easy implementation native", -1 )
      cairo_rel_move_to (cr, 0, 124.0  )
      pango_cairo_show_layout (cr, layout)

      g_object_unref( layout ) 
  elseif n_Page = 1 

      /* Draw a red rectangle, as wide as the paper (inside the margins) */
      cairo_set_source_rgb (cr, 1.0, 0, 0)
      cairo_rectangle (cr, 0, 0, gtk_print_context_get_width (context), 50)
      cairo_fill (cr)
      
      layout = gtk_print_context_create_pango_layout (context)
      pango_layout_set_text (layout, "Hello World! Printing is easy", -1)
      desc = pango_font_description_from_string ("sans 28")
      pango_layout_set_font_description (layout, desc)
      pango_font_description_free (desc)

      cairo_move_to (cr, 40, 50)
      pango_cairo_layout_path (cr, layout)

      /* Font Outline */
      cairo_set_source_rgb( cr, 0.0, 1.0, 0.0 )
      cairo_set_line_width( cr, 5 )
      cairo_stroke_preserve( cr )

      /* Font Fill */
      cairo_set_source_rgb(cr, 0.5, 0.0, 1.0)
      cairo_fill( cr )
      g_object_unref (layout)
  
      layout = gtk_print_context_create_pango_layout (context)
      cairo_set_source_rgb(cr, 1.0, 0.0, 1.0)
      cairo_move_to( cr, 40, 180)
      pango_layout_set_text( layout, "Hello World! Printing is easy", -1)
      pango_cairo_show_layout (cr, layout)

      g_object_unref (layout)

      /* Draw some lines 
      cairo_move_to (cr, 20, 10);
      cairo_line_to (cr, 40, 20);
      cairo_arc (cr, 60, 60, 20, 0, M_PI);
      cairo_line_to (cr, 80, 20);
  
      cairo_set_source_rgb (cr, 0, 0, 0);
      cairo_set_line_width (cr, 5);
      cairo_set_line_cap (cr, CAIRO_LINE_CAP_ROUND);
      cairo_set_line_join (cr, CAIRO_LINE_JOIN_ROUND);
  
      cairo_stroke (cr);
      */
  endif

return nil

// The signal "request-page-setup"
// Emitted once for every page that is printed, to give the application a chance to modify the page setup. 
// Any changes done to setup will be in force only for printing this page. 
static function request_page( op, context, n_page, setup )
  Local size_paper
  
  do case
     case n_Page == 1 /* Make the second page landscape mode a5 */
         size_paper := gtk_paper_size_new ("iso_a5")
         gtk_page_setup_set_orientation(setup, GTK_PAGE_ORIENTATION_LANDSCAPE)
         gtk_page_setup_set_paper_size(setup, size_paper)
         gtk_paper_size_free( size_paper )
     case n_Page == 2 /* Make the three page landscape */
         gtk_page_setup_set_orientation(setup, GTK_PAGE_ORIENTATION_LANDSCAPE)
  endcase
        
RETURN NIL
