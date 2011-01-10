/* $Id: gtkbrowse.c,v 1.3 2010-12-24 01:06:17 dgarciagil Exp $*/
/*
    LGPL Licence.
    
    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this software; see the file COPYING.  If not, write to
    the Free Software Foundation, Inc., 59 Temple Place, Suite 330,
    Boston, MA 02111-1307 USA (or visit the web site http://www.gnu.org/).

    LGPL Licence.
     GtkBrowse.c - Widget browse para GTK+ GIMP Toolkit
    (c)2003 Joaquim Ferrer <quim_ferrer@yahoo.es>
*/
#ifdef HAVE_CONFIG_H
  #include <config.h>
#endif

#include <gtk/gtk.h>
/**
 * Para la definicion de _gtk_marshal_VOID__OBJECT_OBJECT
 **/
#include "gtkmarshalers.h"
#include "gtkmarshalers.c"

#include "gtkbrowse.h"
#include "hbapi.h"
#include "hbvm.h"
#include "hbapiitm.h"
#include "t-gtk.h"

// Atencion esto esta para mantener compatibilidad con xHarbour anteriores
// Deberá desaparecer , pero lo necesito ahora
#ifdef __OLDHARBOUR__
  HB_EXPORT PHB_SYMB hb_dynsymSymbol( PHB_DYNS pDynSym );
#endif

static void	gtk_browse_class_init      (GtkBrowseClass *klass);
static void	gtk_browse_init            (GtkBrowse *browse);
static void     gtk_browse_realize         (GtkWidget *widget);
static gboolean gtk_browse_draw            (GtkWidget *widget, GdkEventExpose *event);

static gboolean gtk_browse_motion_event    (GtkWidget *widget, GdkEventMotion *event);
static gboolean gtk_browse_keypress        (GtkWidget *widget, GdkEventKey *event);
static gboolean gtk_browse_click           (GtkWidget *widget, GdkEventButton *event);
static gboolean gtk_browse_unclick         (GtkWidget *widget, GdkEventButton *event);
static gboolean gtk_browse_col_resized     (GtkWidget *widget, gdouble size);
static gboolean gtk_browse_focus_in        (GtkWidget *widget, GdkEventFocus *event);
static gboolean gtk_browse_focus_out       (GtkWidget *widget, GdkEventFocus *event);
static void     gtk_browse_set_adjustments (GtkBrowse *browse, GtkAdjustment *hadj, GtkAdjustment *vadj);
static void     gtk_browse_destroy         (GtkObject *object);

gint     column_event    = 0;
static gint ROW_HEIGHT   = 20;
static gdouble column_at = 0;

#define PADDING  1

GtkType 
gtk_browse_get_type( void )
{
 static GtkType gtk_browse_type = 0;

  if( !gtk_browse_type )
    {
      static const GtkTypeInfo browse_info =
      {
	 "GtkBrowse",
	 sizeof( GtkBrowse ),
	 sizeof( GtkBrowseClass ),
	 ( GtkClassInitFunc ) gtk_browse_class_init,
	 ( GtkObjectInitFunc ) gtk_browse_init,
	 /* reserved_1 */ NULL,
	 /* reserved_1 */ NULL,
	 ( GtkClassInitFunc ) NULL
      };
      /* Register static class browse */
      gtk_browse_type = gtk_type_unique ( gtk_widget_get_type (), &browse_info );
    }
  return gtk_browse_type;
}

static void 
gtk_browse_class_init( GtkBrowseClass *klass )
{
  GtkObjectClass *object_class;
  GtkWidgetClass *widget_class;
 
  object_class = (GtkObjectClass*) klass;
  widget_class = (GtkWidgetClass*) klass;

  object_class->destroy = gtk_browse_destroy;

  widget_class->realize              = gtk_browse_realize;      // crea la ventana
  widget_class->expose_event         = gtk_browse_draw;         // pinta el contenido
  widget_class->key_press_event      = gtk_browse_keypress;     // evento pulsacion tecla
  widget_class->button_press_event   = gtk_browse_click;        // presionando boton ratón
  widget_class->button_release_event = gtk_browse_unclick;      // soltando    boton ratón
  widget_class->focus_in_event       = gtk_browse_focus_in;     // evento cuando tenga foco
  widget_class->focus_out_event      = gtk_browse_focus_out;    // evento cuando pierda foco
  widget_class->motion_notify_event  = gtk_browse_motion_event; // seguimiento del raton

  klass->set_scroll_adjustments    = gtk_browse_set_adjustments;

  widget_class->set_scroll_adjustments_signal =
    g_signal_new ("set_scroll_adjustments",
		  G_OBJECT_CLASS_TYPE (G_OBJECT_CLASS(klass)),
		  G_SIGNAL_RUN_LAST | G_SIGNAL_ACTION,
		  G_STRUCT_OFFSET (GtkBrowseClass, set_scroll_adjustments),
		  NULL, NULL,
		  _gtk_marshal_VOID__OBJECT_OBJECT,
		  G_TYPE_NONE, 2,
		  GTK_TYPE_ADJUSTMENT,
		  GTK_TYPE_ADJUSTMENT); 
}

static void 
gtk_browse_init( GtkBrowse *browse )
{
 /* Valores 'iniciables' solo una vez */  
  browse->resize_cursor = gdk_cursor_new (GDK_SB_H_DOUBLE_ARROW);
  browse->layout        = gtk_widget_create_pango_layout( GTK_WIDGET( browse ), "" );
}

GtkWidget*
gtk_browse_new( PHB_ITEM pSelf )
{
  GtkWidget *browse;
  browse = GTK_WIDGET( gtk_type_new ( gtk_browse_get_type()));
  
  if( pSelf )
    hb_itemCopy( &GTK_BROWSE(browse)->item, pSelf );
 
#ifdef __BROWSE_DEMO__
  void msgbox( gint msgtype, gchar *message, gchar *title );
  msgbox( GTK_MESSAGE_INFO, "This is a GtkBrowse widget demo          \
                            See license doc for more details", 
                            "T-Gtk browse power Team !" );
#endif
    
  /* Importante darle el foco */
  GTK_WIDGET_SET_FLAGS( browse, GTK_CAN_FOCUS );

  return browse;
}

static void 
gtk_browse_realize( GtkWidget *widget )
{
  GtkBrowse *browse;
  GdkWindowAttr attributes;
  gint attributes_mask;
 // GtkStyle *style = NULL;

   g_return_if_fail( widget != NULL );
   g_return_if_fail( GTK_IS_BROWSE( widget ) );

  GTK_WIDGET_SET_FLAGS( widget, GTK_REALIZED );
  browse = GTK_BROWSE( widget );

  attributes.x           = widget->allocation.x;
  attributes.y           = widget->allocation.y;
  attributes.width       = widget->allocation.width;
  attributes.height      = widget->allocation.height;
  attributes.wclass      = GDK_INPUT_OUTPUT;
  attributes.window_type = GDK_WINDOW_CHILD;

  attributes.event_mask  = GDK_EXPOSURE_MASK |
                           GDK_SCROLL_MASK |
                           GDK_BUTTON_PRESS_MASK |
                           GDK_BUTTON_RELEASE_MASK |
                           GDK_KEY_PRESS_MASK |
                           GDK_POINTER_MOTION_MASK |
                           gtk_widget_get_events (widget);
 
  attributes.visual      = gtk_widget_get_visual (widget);
  attributes.colormap    = gtk_widget_get_colormap (widget);

  attributes_mask = GDK_WA_X | GDK_WA_Y | GDK_WA_VISUAL | GDK_WA_COLORMAP;
    
  widget->window  = gdk_window_new (widget->parent->window, &attributes, attributes_mask);

  widget->style   = gtk_style_attach (widget->style, widget->window);
/*
  style = gtk_rc_get_style_by_paths(gtk_widget_get_settings(widget), NULL,"GtkButton", GTK_TYPE_BUTTON);
  style = gtk_style_attach(style, widget->window);
*/

  gdk_window_set_user_data( widget->window, widget );
  gdk_window_set_background( widget->window, &widget->style->base[GTK_STATE_NORMAL] );
        
 /** Estilo que se utilizará para pintar las lineas separadoras de las columnas dimensionables
  *  gdk_gc_set_line_attributes (GdkGC *gc, gint line_width, GdkLineStyle line_style,
  *                              GdkCapStyle cap_style, GdkJoinStyle join_style)
  **/                            
  gdk_gc_set_line_attributes( widget->style->bg_gc[ GTK_STATE_SELECTED ], 2, GDK_LINE_ON_OFF_DASH, 0, 0 );
}

static void 
gtk_browse_set_adjustments (GtkBrowse *browse, GtkAdjustment *hadj, GtkAdjustment *vadj)
{
  /* Aunque esta funcion no hace nada, es llamada por scrolled bar si hace de
     contenedor del browse. Si las scrolled bar se controlaran desde C y no desde
     [x]Harbour, aqui se definirian los ajustes de las scroll.
     Asi evito que salgan 'warnings'
  */
}

static void
gtk_browse_destroy( GtkObject *object )
{
 
 if( &GTK_BROWSE(object)->item )
     hb_itemClear( &GTK_BROWSE(object)->item );

 }	

/*****************************************************************************************
 * Internas
 ****************************************************************************************/

void
gtk_browse_draw_text( GdkGC *gc, GtkWidget *widget, GdkRectangle *rect, const gchar *text, const gchar *color )
{
   GdkColor mapcolor;
   gdk_color_parse (color, &mapcolor);
   gdk_gc_set_rgb_fg_color (gc, &mapcolor);  
   
   pango_layout_set_text( GTK_BROWSE (widget)->layout, text, -1 );
   
   gdk_draw_layout( widget->window, gc,
                    rect->x +PADDING, rect->y +PADDING, GTK_BROWSE( widget )->layout );
}

void
gtk_browse_draw_lines( GtkWidget *widget, GdkGC *gc, GdkRectangle *rect, gint yColPix )
{
   // linea separador vertical
   gdk_draw_line( widget->window, gc, rect->x -3, rect->y, rect->x -3, rect->y +ROW_HEIGHT -PADDING );

   // linea separador horizontal. ROW_HEIGHT tendra que ser la altura del header, que es donde empieza a pintar 
   gdk_draw_line( widget->window, gc, rect->x -3, yColPix +ROW_HEIGHT -PADDING, 
                  widget->allocation.width, yColPix +ROW_HEIGHT -PADDING );
}

void
gtk_browse_draw_rectangle( GdkGC *gc, GtkWidget *widget, GdkRectangle *rect, gchar *color )
{
    GdkColor mapcolor;
    gdk_color_parse (color, &mapcolor);
    gdk_gc_set_rgb_fg_color (gc, &mapcolor);

    gdk_draw_rectangle (widget->window, gc, TRUE, rect->x -3, rect->y, 
                        widget->allocation.width, rect->height);
}   

void
gtk_browse_draw_pixbuf (GtkWidget *widget, const gchar *filename, gint y, gint x)
{
   GError    *error  = NULL;
   GdkPixbuf *pixbuf = gdk_pixbuf_new_from_file ( filename, &error );
   gdk_draw_pixbuf (widget->window,
         	    widget->style->black_gc,
		    pixbuf,
		    0,
		    0,
		    y,
		    x,
		    gdk_pixbuf_get_width (pixbuf),
		    gdk_pixbuf_get_height (pixbuf),
		    GDK_RGB_DITHER_NORMAL,
		    0, 0);
		    
   g_object_unref (pixbuf);	
   pixbuf = NULL;	    
}

void
gtk_browse_draw_pixbuf_p (GtkWidget *widget, GdkPixbuf * pixbuf, gint y, gint x)
{
   gdk_draw_pixbuf (widget->window,
            widget->style->black_gc,
            pixbuf,
            0,
            0,
            y,
            x,
            gdk_pixbuf_get_width (pixbuf),
            gdk_pixbuf_get_height (pixbuf),
            GDK_RGB_DITHER_NORMAL,
            0, 0);
}

/*****************************************************************************************
 * Pasarela de eventos -callback- a [x]Harbour
 ****************************************************************************************/

gboolean
gtk_browse_draw( GtkWidget *widget, GdkEventExpose *event )
{
  PHB_ITEM pObj    = &GTK_BROWSE(widget)->item;
  PHB_DYNS pMethod = hb_dynsymFindName( "PAINT" );

  if( pObj && pMethod )
    {
     hb_vmPushSymbol( hb_dynsymSymbol( pMethod ) );     // Coloca simbolo en la pila
     hb_vmPush( pObj );                       // Coloca objeto en pila.
     hb_vmPushLong( GPOINTER_TO_UINT( event ) );
     hb_vmPushLong( GPOINTER_TO_UINT( widget->allocation.width ) ); 
     hb_vmSend( 2 );                          // LLamada por Send 
    }
    
  return FALSE;
}

gboolean 
gtk_browse_motion_event( GtkWidget *widget, GdkEventMotion *event )
{
  GtkBrowse *browse = GTK_BROWSE (widget);
  GdkModifierType state;
  gint  i, nCols;
  gint  column_pos, column_prev;
  gchar column_id[5];
  
  nCols = browse->ncols_visible -1;
 /**
  * Para averiguar el siguiente evento a motion_event, en este
  * caso, un button_press_mask
  **/
  gdk_window_get_pointer( event->window, NULL, NULL, &state );

  for( i = 0; nCols > i; i++ )
  {
    sprintf( column_id, "%d", i );
    column_pos = GPOINTER_TO_INT (g_object_get_data( G_OBJECT (widget->window), column_id ) );

    if ( state & GDK_BUTTON1_MASK && column_event) {
    	
       sprintf( column_id, "%d", column_event -2 );
       column_prev = GPOINTER_TO_INT (g_object_get_data( G_OBJECT (widget->window), column_id ) );
       
       /* TODO: 25 es el ancho minimo de la columna
        * Tener en cuenta cuando el browse tenga arrow
        */
       if ( event->x > (column_prev +25) ){
          gtk_browse_col_resized( widget, event->x - column_at );
  
          if ( browse->screen )
             gdk_draw_image( widget->window, 
                             widget->style->bg_gc[ GTK_STATE_NORMAL ], 
                             browse->screen, 
                             0, 0, 0, 0, widget->allocation.width, widget->allocation.height);

          gdk_draw_line( widget->window, widget->style->bg_gc[ GTK_STATE_SELECTED ], 
                         event->x -1, 1, event->x-1, widget->allocation.height -1);
       }
       column_at = event->x;
       return FALSE;
    }             

    if ( column_pos -2 < event->x && column_pos +2 > event->x ){
       if ( !column_event )
          gdk_window_set_cursor (widget->window, browse->resize_cursor);
       column_event = i +1;
       break;
    }
    else {
      if ( column_event ) { 
        if ( state & GDK_BUTTON1_MASK ) 
           break;
        else {   
           gdk_window_set_cursor (widget->window, NULL);
           column_event = 0;
        }
      }
    }
  }
  return FALSE;
}	

gboolean
gtk_browse_keypress( GtkWidget *widget, GdkEventKey *event )
{
  PHB_ITEM pObj    = &GTK_BROWSE(widget)->item;
  PHB_DYNS pMethod = hb_dynsymFindName( "KEYEVENT" );

  if( pObj && pMethod )
    {
     hb_vmPushSymbol( hb_dynsymSymbol( pMethod ) );     // Coloca simbolo en la pila
     hb_vmPush( pObj );                       // Coloca objeto en pila.
     hb_vmPushLong( event->keyval );
     hb_vmSend( 1 );                          // LLamada por Send 
     return( hb_parl( -1 ) );                 /* Deberemos detener la propagacion del evento*/
    }
  return FALSE; 
}

gboolean
gtk_browse_click( GtkWidget *widget, GdkEventButton *event )
{
  GtkBrowse *browse = GTK_BROWSE (widget);
 
  if ( column_event ){
     browse->screen = gdk_drawable_get_image (widget->window, 0, 0, 
                           widget->allocation.width, widget->allocation.height);
     gdk_draw_line( widget->window, widget->style->bg_gc[ GTK_STATE_SELECTED ], 
                    event->x -1, 1, event->x -1, widget->allocation.height -1);       
     column_at = event->x;
     return FALSE;
  }   

  PHB_ITEM pObj    = &browse->item;
  PHB_DYNS pMethod = hb_dynsymFindName( "CLICKEVENT" );
  
  if( pObj && pMethod ){
     hb_vmPushSymbol( hb_dynsymSymbol( pMethod ) );     // Coloca simbolo en la pila
     hb_vmPush( pObj );                             
     hb_vmPushLong( GPOINTER_TO_UINT( event->y ) ); //--> row es Y
     hb_vmPushLong( GPOINTER_TO_UINT( event->x ) ); //--> col es X 
     hb_vmPushLong( GPOINTER_TO_UINT( widget->allocation.width  ) );
     hb_vmPushLong( GPOINTER_TO_UINT( widget->allocation.height ) );
     hb_vmSend( 4 );                                
  }
  return FALSE;
}

gboolean 
gtk_browse_unclick( GtkWidget *widget, GdkEventButton *event )
{
  gtk_browse_col_resized( widget, event->x - column_at );
  gtk_widget_queue_draw( widget );
  return FALSE;
}

gboolean 
gtk_browse_col_resized( GtkWidget *widget, gdouble size )
{

  if ( size ){
     PHB_ITEM pObj     = &GTK_BROWSE(widget)->item;
     PHB_DYNS pMethod  = hb_dynsymFindName( "COLRESIZEVENT" );
     if( pObj && pMethod ){
        hb_vmPushSymbol( hb_dynsymSymbol( pMethod ) );     // Coloca simbolo en la pila
        hb_vmPush( pObj );                       
        hb_vmPushLong( column_event );
        hb_vmPushLong( size );
        hb_vmSend( 2 );                          
     }
  }   
  return FALSE;
}

gboolean
gtk_browse_focus_in( GtkWidget *widget, GdkEventFocus *event )
{
  PHB_ITEM pObj    = &GTK_BROWSE(widget)->item;
  PHB_DYNS pMethod = hb_dynsymFindName( "GOTFOCUS" );

  if( pObj && pMethod )
    {
     hb_vmPushSymbol( hb_dynsymSymbol( pMethod ) );     // Coloca simbolo en la pila
     hb_vmPush( pObj );                             // Coloca objeto en pila.
     hb_vmSend( 0 );                                // LLamada por Send 
    }
  return FALSE;
}

gboolean
gtk_browse_focus_out( GtkWidget *widget, GdkEventFocus *event )
{
   PHB_ITEM pObj    = &GTK_BROWSE(widget)->item;
   PHB_DYNS pMethod = hb_dynsymFindName( "LOSTFOCUS" );

  if( pObj && pMethod )
    {
     hb_vmPushSymbol( hb_dynsymSymbol( pMethod ) );     // Coloca simbolo en la pila
     hb_vmPush( pObj );                             // Coloca objeto en pila.
     hb_vmSend( 0 );                                // LLamada por Send 
    }
  return FALSE;
}

gboolean
gtk_browse_scroll_event( GtkWidget *scroll, GtkWidget *widget )
{
  PHB_ITEM pObj      = &GTK_BROWSE(widget)->item;
  PHB_DYNS pMethod   = hb_dynsymFindName( "SCROLLEVENT" );
  GtkAdjustment *adj = gtk_range_get_adjustment( GTK_RANGE(scroll) );
  gdouble value      = gtk_adjustment_get_value( GTK_ADJUSTMENT(adj) );
  
  if( pObj && pMethod )
    {
     hb_vmPushSymbol( hb_dynsymSymbol( pMethod ) );     // Coloca simbolo en la pila
     hb_vmPush( pObj );                       // Coloca objeto en pila.
     hb_vmPushLong( GPOINTER_TO_UINT( GTK_RANGE (scroll)->orientation ) ); 
     hb_vmPushLong( GPOINTER_TO_UINT( value ) ); 
     hb_vmSend( 2 );                          // LLamada por Send 
    }
  return FALSE;
}

/*****************************************************************************************
 * Api a [x]Harbour. 
 ****************************************************************************************/

HB_FUNC( GTK_BROWSE_NEW )
{
   PHB_ITEM pSelf = hb_param( 1, HB_IT_OBJECT );
   GtkWidget *browse = gtk_browse_new( pSelf );
   hb_retptr( ( GtkWidget * ) browse );
}

HB_FUNC( GTK_BROWSE_DRAWHEADERS ) // ( widget, pEvent, aHeaders, aColSizes, aBmpFiles, nColPos, lArrow )
{
   GtkWidget *widget     = ( GtkWidget * ) hb_parptr( 1 );
   GdkEventExpose *event = ( GdkEventExpose * ) hb_parptr( 2 );
   PHB_ITEM pBmpFiles    = hb_param( 5, HB_IT_ARRAY );
   gint i, iRight;
   gint iCols   = hb_parinfa( 3, 0 );
   gint iColPos = hb_parnl( 6 ) -1;
   gint iLeft   = hb_parl( 7 ) ? 20 : 0;  
   gchar column_id[5];   
   
   for( i = iColPos; i < iCols; i++ )
   {
     if( iLeft < widget->allocation.width )
      {
         iRight = hb_parnl( 4, i + 1 );

         if( iLeft + iRight > widget->allocation.width )
            iRight = widget->allocation.width - iLeft;

         if( i + 1 == iCols )
            iRight = widget->allocation.width - iLeft;
            
         // Caja tipo 'boton' para headers 
         /*TODO: 
           Existe un bug en Harbour 64 , falla el paso del parámetro widget->style 
         */
         #ifndef __HARBOUR64__
         if ( hb_parl( 7 ) )

            gtk_paint_box( widget->style, widget->window,
	      	        GTK_STATE_NORMAL, GTK_SHADOW_OUT,
		        &event->area, widget, "button",
		        ( i == iColPos ) ? iLeft -20 : iLeft, 0, 
		        ( i == iColPos ) ? iRight+20 : iRight, ROW_HEIGHT +1 );
         else   
            gtk_paint_box( widget->style, widget->window,
	      	        GTK_STATE_NORMAL, GTK_SHADOW_OUT,
		        &event->area, widget, "button",
		        iLeft, 0, iRight, ROW_HEIGHT +1 );
         #endif

         // Pintando bitmaps en headers si es != NIL 
         if ( hb_arrayGetType( pBmpFiles, i + 1 ) != HB_IT_NIL ) {
            gtk_browse_draw_pixbuf (widget, ( gchar * )hb_parc( 5, i + 1 ), iLeft+3, 3);
            iRight = 26; // 20 ancho bitmap + 6
            }
         else   
            iRight = 6;
	 
	 pango_layout_set_text( GTK_BROWSE( widget )->layout, hb_parc( 3, i + 1 ), -1 );

        /**
         * Si no cambio colores ni fuentes, puedo utilizar el graphic context (gc) 
         * del widget (widget->style->text_gc), si no, hay que crear uno nuevo !!!
         **/
         gdk_draw_layout( widget->window, widget->style->text_gc[GTK_STATE_NORMAL],
	                  iLeft + iRight, 2, GTK_BROWSE( widget )->layout );

         iLeft += hb_parnl( 4, i + 1 ) -1;

        /**
         * Guardo posicion de columna, posteriormente se recupera en motion_notify_event
         **/
         sprintf( column_id, "%d", i );
         g_object_set_data( G_OBJECT (widget->window), column_id, GINT_TO_POINTER (iLeft) );
      }
   }
   
   GTK_BROWSE (widget)->ncols_visible = i;
}

HB_FUNC( GTK_BROWSE_DRAWCELL ) // ( widget, nRow, nCol, cText, nWidth, lSelected, 
                               //   lArrow, nColType, cfgColor, cbgColor, nLineStyle )
{
   GdkGC *gc, *newgc;
/**
 * Es importante llamar a todas las funciones de 'dibujo' pasando un graphic context independiente
 * y no utilizar los gc definidos por defecto en el widget (text_gc, base_gc, etc), sobretodo
 * si se va a realizar cambios en fuentes o colores, ya que puede afectar a los *gc de otros
 * widget, almenos en la practica es lo que he constatado.
 **/
   GtkWidget *widget = ( GtkWidget * ) hb_parptr( 1 );
   gint yPixCol      = hb_parnl( 2 ) * ROW_HEIGHT;
   GdkRectangle rect = { hb_parnl( 3 ), yPixCol,
                         hb_parnl( 5 ), ROW_HEIGHT  };
  
   PHB_ITEM pValue = hb_param( 4, HB_IT_ANY );
   
   if ( hb_parl( 7 ) )
      rect.x += 20;
      
   if( ( rect.x + rect.width ) >= widget->allocation.width )
      rect.width = widget->allocation.width - rect.x;
   else   
      rect.width += rect.x;
      
   if( ( rect.y + rect.height ) >= widget->allocation.height )
      return;   

   // Contexto de dispositivo
   gc = gdk_gc_new (widget->window);
   
   // 'Pintado' de la area de fondo de la fila, dependiendo de si es la seleccionada y si tiene foco
   // Se podria personalizar a nivel de clase [x]Harbour para que 'blue/gray' fueran parametros
   if( gtk_widget_is_focus(widget) )
      gtk_browse_draw_rectangle (gc, widget, &rect, hb_parl( 6 ) ? "blue" : ( gchar *)hb_parc( 10 )); 
   else
      gtk_browse_draw_rectangle (gc, widget, &rect, hb_parl( 6 ) ? "gray" : ( gchar *)hb_parc( 10 )); 
   
   // Pinta una pequeña 'punta de flecha', al estilo de los grid de M$Access, antes de la primera columna 
   if ( hb_parl( 7 ) && hb_parnl( 3 ) == 1 ) {
      rect.x -= 20;
      gtk_paint_box (widget->style, widget->window, GTK_STATE_NORMAL, GTK_SHADOW_OUT, 
                     &rect, widget, "box", rect.x, rect.y, 18, ROW_HEIGHT);
      if (hb_parl( 6 ))
         gtk_paint_arrow (widget->style, widget->window, GTK_STATE_NORMAL, GTK_SHADOW_IN, &rect, widget, 
                          "arrow", GTK_ARROW_RIGHT, 0, rect.x, rect.y, 18, ROW_HEIGHT);
      rect.x += 20;
   }                 
 
/************
 * Pintado de lineas. Se pueden cambiar atributos PERO es necesario un nuevo graphic context
 * si no se cambian se utiliza el del widget (widget->style->dark_gc) con el estilo dark.
 * Si no se utiliza un nuevo gc, TODOS los widget adquieren los nuevos atributos.
 * Explicacion de la funcion :
 * gdk_gc_set_line_attributes (GdkGC *gc, gint line_width, GdkLineStyle line_style, 
 *                             GdkCapStyle cap_style, GdkJoinStyle join_style);
 * gc         : a GdkGC.  
 * line_width : the width of lines.  
 * line_style : the dash-style for lines.  
 * cap_style  : the manner in which the ends of lines are drawn.  
 * join_style : the in which lines are joined together.  
 ************/   
   switch( hb_parni(11) )
     {
       case LINE_NONE:
            break;
            // No se pintan lineas

       case LINE_SOLID:
            gtk_browse_draw_lines( widget, widget->style->dark_gc[ GTK_STATE_NORMAL ], &rect, yPixCol );
            break;
       
       case LINE_DOTTED:
            newgc = gdk_gc_new (widget->window);
            gdk_gc_set_line_attributes( newgc, 0, GDK_LINE_ON_OFF_DASH, GDK_CAP_ROUND, GDK_JOIN_ROUND );
            gtk_browse_draw_lines( widget, newgc, &rect, yPixCol );
            g_object_unref(newgc);
            break;
     } 
  

   switch( hb_parni(8) )
     {
       case COL_TYPE_TEXT:
            gtk_browse_draw_text (gc, widget, &rect, hb_parc( 4 ), 
                                  hb_parl( 6 ) ? "white" : hb_parc( 9 ));
            break;

       case COL_TYPE_CHECK:
            gtk_paint_check (widget->style, widget->window, 
                             GTK_STATE_NORMAL,
                             hb_parl( 4 ) ? GTK_SHADOW_IN : GTK_SHADOW_OUT, 
                             &rect, widget, "check", rect.x, rect.y, 20, 20);
            break;
       
       case COL_TYPE_SHADOW:
            gtk_paint_shadow (widget->style, widget->window, GTK_STATE_NORMAL, GTK_SHADOW_IN,
		              NULL, widget, "entry", rect.x, rect.y, rect.width, rect.height);
            break;

       case COL_TYPE_BOX:  // efecto 3D
            rect.x -= 2;
            gtk_paint_box (widget->style, widget->window, 
                           GTK_STATE_NORMAL,
                           GTK_SHADOW_OUT, 
                           &rect, widget, "box", rect.x, rect.y, rect.width, rect.height);
            rect.x += 2;
            gtk_browse_draw_text (gc, widget, &rect, hb_parc( 4 ), hb_parl( 6 ) ? "red" : "blue");
            break;

       case COL_TYPE_RADIO:
            gtk_paint_option (widget->style, widget->window, 
                             GTK_STATE_NORMAL,
                             hb_parl( 4 ) ? GTK_SHADOW_IN : GTK_SHADOW_OUT, 
                             &rect, widget, "radiobutton", rect.x, rect.y, 20, 20);
            break;
     
       case COL_TYPE_BITMAP:
            if( HB_IS_STRING( pValue ) ) {
               gtk_browse_draw_pixbuf(widget, hb_parc( 4 ), rect.x, rect.y);
            } else if( HB_IS_INTEGER( pValue ) || HB_IS_LONG( pValue ) ) {
               gtk_browse_draw_pixbuf_p (widget, GDK_PIXBUF( hb_parnl( 4 ) ), rect.x, rect.y);
            }
            break;
     }
  g_object_unref (gc);
}

HB_FUNC( GTK_BROWSE_ROW_COUNT ) // ( widget )
{
   hb_retnl( ( ( GtkWidget * ) hb_parptr( 1 ) )->allocation.height / ROW_HEIGHT );
}

HB_FUNC( GTK_BROWSE_ROW_HEIGHT ) // ( row height ) SetGet !
{
   if ( hb_parni( 1 ) )
      ROW_HEIGHT = hb_parni( 1 );
   else
      hb_retni ( (gint) ROW_HEIGHT );    
}

HB_FUNC( GTK_BROWSE_SET_FONT ) // ( widget, font description )
{
   GtkWidget *widget = ( GtkWidget * ) hb_parptr( 1 );
   PangoFontDescription *font_desc = pango_font_description_from_string (hb_parc( 2 ));

   gtk_widget_modify_font (widget, font_desc);
   pango_font_description_free (font_desc);
}

HB_FUNC( GTK_BROWSE_GET_FONT_SIZE ) // ( widget )
{
   GtkWidget *widget = ( GtkWidget * ) hb_parptr( 1 );
   GtkRcStyle *rc_style;

   rc_style = gtk_widget_get_modifier_style (widget);  
   hb_retni (pango_font_description_get_size (rc_style->font_desc) /1024);
}

HB_FUNC( GTK_BROWSE_SCROLLDOWN )
{
   GtkWidget * hWnd = ( GtkWidget * ) hb_parptr( 1 );
   gdk_draw_pixmap( hWnd->window, hWnd->style->fg_gc[ GTK_STATE_NORMAL ],
                    hWnd->window, 0, ROW_HEIGHT + ROW_HEIGHT, 0, ROW_HEIGHT, 
                    hWnd->allocation.width, hWnd->allocation.height );
}

HB_FUNC( GTK_BROWSE_SCROLLUP )
{
   GtkWidget * hWnd = ( GtkWidget * ) hb_parptr( 1 );
   gint nLines = hb_parni( 2 );
// ROW_HEIGHT + ROW_HEIGHT ( uno de los sera HEADER_HEIGHT, de momento valen igual)
   gdk_draw_pixmap( hWnd->window, hWnd->style->fg_gc[ GTK_STATE_NORMAL ],
                    hWnd->window, 0, ROW_HEIGHT, 0, ROW_HEIGHT + ROW_HEIGHT,
		    hWnd->allocation.width, nLines * ROW_HEIGHT - (ROW_HEIGHT + ROW_HEIGHT) );
}

HB_FUNC( GTK_BROWSE_SCROLL_CONNECT )  // browse, scrolled
{
   GtkWidget *widget = GTK_WIDGET( hb_parptr( 1 ) );
   GtkScrolledWindow *scrolled = GTK_SCROLLED_WINDOW( hb_parptr( 2 ) );

   g_signal_connect( G_OBJECT( scrolled->vscrollbar ), "value-changed",
                     G_CALLBACK( gtk_browse_scroll_event ), widget );
                     
   g_signal_connect( G_OBJECT( scrolled->hscrollbar ), "value-changed",
                     G_CALLBACK( gtk_browse_scroll_event ), widget );
 
// gtk_browse_scroll_event llama a la clase browse, metodo Scrolled() pasandole orientacion y value
} 
