/**
 * Example DrawingArea under Objects
 **/
 
#include "gclass.ch"

STATIC nSum := 0

function main()

  Local oWnd, oBox, oEventBox, oLabel, oFont
  Local pixbuf, pixbuf2, pixbuf3, oDraw

  pixbuf  := gdk_pixbuf_new_from_file( "../../images/glade.png" )
  pixbuf2 := gdk_pixbuf_new_from_file( "../../images/rafa.jpg" )
  pixbuf3 := gdk_pixbuf_scale_simple( pixbuf2, 200,200 )
  
  DEFINE WINDOW oWnd TITLE "Drawing Example" SIZE 300,300
  
      DEFINE DRAWINGAREA oDraw ;
             EXPOSE EVENT    Dibuja( oSender, pEvent, pixbuf, pixbuf2, pixbuf3 );
             CONFIGURE EVENT Configure_event( oWnd );
             OF oWnd CONTAINER

  ACTIVATE WINDOW oWnd CENTER  
  
  // Debemos de referenciar pixbufs de la memoria
  gdk_pixbuf_unref( pixbuf )
  gdk_pixbuf_unref( pixbuf2 )
  gdk_pixbuf_unref( pixbuf3 )
   

RETURN NIL

// Informamos del cambio de la ventana
STATIC FUNCTION Configure_event( oWnd  )
  STATIC nVeces := 0
  
  oWnd:SetTitle( "Change window "+ cValToChar( ++nVeces ) )

RETURN .T.


FUNCTION DIBUJA( oSender, event,  pixbuf, pixbuf2, pixbuf3 )
 Local gc
 Local colormap, pango
 Local color := { 0, 0XF, 25500, 34534 }
 Local widget

 Local cTextMark := '<span foreground="blue" size="large"><b>Esto es <span foreground="yellow"'+;
                ' size="xx-large" background="black" ><i>fabuloso</i></span></b>!!!!</span>'+;
                HB_OSNEWLINE()+;
                '<span foreground="red" size="23000"><b><i>T-Gtk power!!</i></b> </span>' +;
                HB_OSNEWLINE()+;
                'Usando un lenguaje de <b>marcas</b> para mostrar textos'

  widget := oSender:pWidget

  gc = gdk_gc_new( widget  )   // cambio propiedades del contexto gr�fico gc

  // Un bitmap por aqui en la posicion 80,80
  gdk_draw_pixbuf( widget, gc, pixbuf3, 0, 0, 80, 80 )
  
  // Un bitmap por aqui en la posicion 70,70
  gdk_draw_pixbuf( widget, gc, pixbuf, 0, 0, 70, 70 )


  /* Haciendo un poco de trastadas ;-) , fijate como es la imagen original,
     y comparalo con lo que estas viendo */
  gdk_draw_pixbuf( widget, gc, pixbuf2, 100, 100, 170, 170, 100,100 )


  pango :=  gtk_widget_create_pango_layout( widget )
  pango_layout_set_markup( pango, cTextMark )
  gdk_draw_layout( widget, gc, 10, 200, pango )

  g_object_unref( gc )


Return .T.


