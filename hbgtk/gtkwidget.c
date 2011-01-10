/* $Id: gtkwidget.c,v 1.3 2010-05-26 10:15:03 xthefull Exp $*/
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
    (c)2003 Rafael Carmona <thefull@wanadoo.es>
    (c)2003 Joaquim Ferrer <quim_ferrer@yahoo.es>
*/
#include <gtk/gtk.h>
#include "hbapi.h"
#include "t-gtk.h"

PHB_ITEM Color2Array( GdkColor *color );
BOOL Array2Color(PHB_ITEM aColor, GdkColor *color );

#define FGCOLOR 1
#define BGCOLOR 2
#define BASECOLOR 3
#define TEXTCOLOR 4

HB_FUNC( GTK_WIDGET_SHOW )
{
  gtk_widget_show( ( GtkWidget * ) hb_parptr( 1 ) );
}

HB_FUNC( GTK_WIDGET_SHOW_ALL )
{
  gtk_widget_show_all( GTK_WIDGET( hb_parptr( 1 ) ) );
}

HB_FUNC( GTK_WIDGET_HIDE)
{
  gtk_widget_hide( ( GtkWidget * ) hb_parptr( 1 ) );
}

HB_FUNC( GTK_WIDGET_DESTROY )
{
  gtk_widget_destroy( GTK_WIDGET( hb_parptr( 1 )  ) );
}

HB_FUNC( GTK_WIDGET_SET_FLAGS )
{
  GtkWidget * widget = GTK_WIDGET( hb_parptr( 1 ) );
  GTK_WIDGET_SET_FLAGS( widget , hb_parni( 2 )  );
}

HB_FUNC( GTK_WIDGET_GRAB_DEFAULT )
{
  GtkWidget * widget = GTK_WIDGET( hb_parptr( 1 ) );
  gtk_widget_grab_default( widget );
}

HB_FUNC( GTK_WIDGET_SET_USIZE )
{
   GtkWidget * hWnd = ( GtkWidget * ) hb_parptr( 1 );
   gtk_widget_set_usize ( hWnd, hb_parni( 2 ), hb_parni( 3 ) );
}

HB_FUNC( GTK_WIDGET_QUEUE_DRAW )
{
   GtkWidget * widget = GTK_WIDGET( hb_parptr( 1 ));
   gtk_widget_queue_draw (  widget );
}

HB_FUNC( GTK_WIDGET_GRAB_FOCUS )
{
   gtk_widget_grab_focus( ( GTK_WIDGET( hb_parptr( 1 ) ) ) );
}

HB_FUNC( GTK_WIDGET_SET_UPOSITION )
{
   gtk_widget_set_uposition( GTK_WIDGET( hb_parptr( 1 ) ),
                             hb_parnl( 3 ), hb_parnl( 2 ) );
}

HB_FUNC( GTK_WIDGET_SET_SENSITIVE ) // widget, boolean -> void
{
   gtk_widget_set_sensitive( GTK_WIDGET( hb_parptr( 1 ) ),
                             (gboolean) hb_parl( 2 ) );
}

HB_FUNC( GTK_WIDGET_MODIFY_FONT ) // widget, Font
{
   gtk_widget_modify_font( GTK_WIDGET( hb_parptr( 1 ) ),
                          ( PangoFontDescription * ) hb_parptr( 2 ) );
}

// state = GTK_STATE_NORMAL, GTK_STATE_ACTIVE, GTK_STATE_PRELIGHT,
//         GTK_STATE_SELECTED, GTK_STATE_INSENSITIVE

HB_FUNC( GTK_WIDGET_MODIFY_TEXT ) // widget, state, namecolor -> void
{
  GtkWidget * widget = GTK_WIDGET( hb_parptr( 1 ) );
  gint state = (gint) hb_parni( 2 );
  gchar * name = (gchar *) hb_parc( 3 );
  GdkColor color;
  gdk_color_parse( name, &color );
  gtk_widget_modify_text( widget, state, &color );
}

HB_FUNC( GTK_WIDGET_MODIFY_BG ) // widget, state, namecolor -> void
{
  GtkWidget * widget = GTK_WIDGET( hb_parptr( 1 ) );
  gint state = (gint) hb_parni( 2 );
  PHB_ITEM pColor;
  GdkColor color;

  if( ISARRAY( 3 ) )
    {
      pColor = hb_param( 3, HB_IT_ARRAY );

      if( Array2Color( pColor, &color ) )
        {
          gtk_widget_modify_bg( widget, state, &color );
          hb_storni( (guint32) (color.pixel),3, 1);
          hb_storni( (guint16) (color.red)  ,3, 2);
          hb_storni( (guint16) (color.green),3, 3);
          hb_storni( (guint16) (color.blue) ,3, 4);
        }
     }
   else
      g_warning ("GTK_WIDGET_MODIFY_BG : Se esperaba un array");
}

HB_FUNC( HB_GTK_WIDGET_MODIFY_BG ) // widget, state, namecolor -> void
{
  GtkWidget * widget = GTK_WIDGET( hb_parptr( 1 ) );
  gint state = (gint) hb_parni( 2 );
  gchar * name = (gchar *) hb_parc( 3 );
  GdkColor color;
  gdk_color_parse( name, &color );
  gtk_widget_modify_bg( widget, state, &color );
}

HB_FUNC( GTK_WIDGET_MODIFY_FG ) // widget, state, namecolor -> void
{
  GtkWidget * widget = GTK_WIDGET( hb_parptr( 1 ) );
  gint state = (gint) hb_parni( 2 );
  gchar * name = (gchar *) hb_parc( 3 );
  GdkColor color;
  gdk_color_parse( name, &color );
  gtk_widget_modify_fg( widget, state, &color );
}

HB_FUNC( GTK_WIDGET_MODIFY_BASE ) // widget, state, namecolor -> void
{
  GtkWidget * widget = GTK_WIDGET( hb_parptr( 1 ) );
  gint state = (gint) hb_parni( 2 );
  gchar * name = (gchar *) hb_parc( 3 );
  GdkColor color;
  gdk_color_parse( name, &color );
  gtk_widget_modify_base( widget, state, &color );
}

HB_FUNC( GTK_BIN_GET_CHILD ) // devuelve widget hijo
{
   GtkWidget * widget = GTK_WIDGET( hb_parptr( 1 ) );
   GtkWidget * child =  gtk_bin_get_child( GTK_BIN( widget ) );
   hb_retptr( (GtkWidget * ) child );
}

HB_FUNC( GTK_WIDGET_HIDE_ON_DELETE )
{
   GtkWidget * widget = GTK_WIDGET( hb_parptr( 1 ) );
   hb_parl( gtk_widget_hide_on_delete( widget ) );
}

HB_FUNC( GTK_WIDGET_SET_SIZE_REQUEST ) // pWidget, width, height
{
   GtkWidget * widget = GTK_WIDGET( hb_parptr( 1 ) );
   gtk_widget_set_size_request( widget, hb_parni( 2 ), hb_parni( 3 ) );
}

HB_FUNC( GTK_WIDGET_GET_COLORMAP )
{
   GtkWidget * widget = GTK_WIDGET( hb_parptr( 1 ) );
   GdkColormap * colormap = gtk_widget_get_colormap( widget );
   hb_retptr( (GdkColormap *) colormap );
}

HB_FUNC( GTK_WIDGET_CHILD_FOCUS )
{
   GtkWidget * widget = GTK_WIDGET( hb_parptr( 1 ) );
   hb_retl( gtk_widget_child_focus( widget,  hb_parni( 2 ) ) );
}

HB_FUNC( GTK_WIDGET_ACTIVATE )
{
   GtkWidget * widget = GTK_WIDGET( hb_parptr( 1 ) );
   hb_retl( gtk_widget_activate( widget ) );
}

HB_FUNC( GTK_WIDGET_GET_TOPLEVEL )
{
   GtkWidget * widget = GTK_WIDGET( hb_parptr( 1 ) );
   hb_retptr( (GtkWidget *) gtk_widget_get_toplevel( widget ) );
}

HB_FUNC( GTK_WIDGET_CREATE_PANGO_CONTEXT )
{
  GtkWidget * widget = GTK_WIDGET( hb_parptr( 1 ) );
  PangoContext * pango = gtk_widget_create_pango_context( widget );
  hb_retptr( (PangoContext *) pango );
}

HB_FUNC( GTK_WIDGET_CREATE_PANGO_LAYOUT )
{
    GtkWidget * widget = GTK_WIDGET( hb_parptr( 1 ) );
    PangoLayout * pango ;
    pango = gtk_widget_create_pango_layout( widget,
                                            hb_parc( 2 ) );
    hb_retptr( (PangoLayout * ) pango );
}

HB_FUNC( GTK_WIDGET_GET_SCREEN )
{
   GtkWidget * widget = GTK_WIDGET( hb_parptr( 1 ) );
   GdkScreen * screen = gtk_widget_get_screen( widget );
   hb_retptr( (GdkScreen *) screen );
}


HB_FUNC( SYSREFRESH )
{
 while (g_main_iteration(FALSE));
}

HB_FUNC( DESPLAZA_LEFT )
{
	hb_retni( hb_parni( 1 ) << hb_parni( 2 ) );
}

HB_FUNC( DESPLAZA_RIGHT )
{
	hb_retni( hb_parni( 1 ) >> hb_parni( 2 ) );
}

HB_FUNC( NOR )
{
   glong lRet = 0;
   gint i = 0;

   while( i < hb_pcount() )
      lRet |= ( glong ) hb_parnl( ++i );

   hb_retnl( lRet );
}


// Funcion generica que cambia el color de un widget
/*
  STATE_NORMAL        # El estado durante la operacin normal
  STATE_ACTIVE        # El control est�activado, como cuando se pulsa un botn
  STATE_PRELIGHT      # El puntero del ratn est�sobre el control
  STATE_SELECTED      # El control est�seleccionado
  STATE_INSENSITIVE   # El control est�desactivado
*/

HB_FUNC( __GSTYLE )
{
   GtkWidget * widget = GTK_WIDGET( hb_parptr( 2 ) );

    gtk_widget_ensure_style( widget );  // Aseguramos que el Widget tengo el estilo
    GtkStyle* newstyle;              // Estilo a crear
    GdkColor color;
    int component = hb_parni( 3 );   // sobre que actuar
    int iState = hb_parni( 4 );      // Estado

    gdk_color_parse( hb_parc(1), &color);

    newstyle = gtk_style_copy( gtk_widget_get_style( widget ) );  // Copiamos el actual


     if (component & FGCOLOR)
         newstyle->fg[iState] = color;
     if (component &  BGCOLOR)
         newstyle->bg[iState] = color;
     if (component & BASECOLOR)
         newstyle->base[iState] = color;
     if (component &  TEXTCOLOR)
         newstyle->text[iState] = color;

    gtk_widget_set_style( widget, newstyle );  // Y se lo aplicamos

}

HB_FUNC( GTK_WIDGET_SET_EVENTS )
{
   GtkWidget * widget = GTK_WIDGET( hb_parptr( 1 ) );
   gint events = hb_parni( 2 );
   gtk_widget_set_events( widget, events );
}

HB_FUNC( GTK_WIDGET_ADD_EVENTS ) // pWidget, GdkEventMask
{
   GtkWidget *widget = GTK_WIDGET( hb_parptr( 1 ) );
   gint events = hb_parni( 2 );
 
   gtk_widget_add_events( widget, events );
}

HB_FUNC( GTK_WIDGET_GET_SIZE_REQUEST ) // widget, @width, @height
{
   GtkWidget * widget = GTK_WIDGET( hb_parptr( 1 ) );
   gint width, height;
   gtk_widget_get_size_request( widget, &width, &height);
   hb_storni( ( gint ) width, 2 );
   hb_storni( ( gint ) height, 3 );
}    

HB_FUNC( GTK_WIDGET_ADD_ACCELERATOR )// widget, accel_signal, accel_group, accel_key [, mode, accel_flags ]
{
   GtkWidget *widget = GTK_WIDGET( hb_parptr( 1 ) );
   const gchar * accel_signal = hb_parc( 2 );
   GtkAccelGroup * accel_group = GTK_ACCEL_GROUP( hb_parptr( 3 ) );
   guint accel_key = hb_parni( 4 );
   GdkModifierType mode = ISNIL( 5 ) ? 0 : hb_parni( 5 );
   //GdkModifierType mode = GDK_SHIFT_MASK; 
   GtkAccelFlags accel_flags = ISNIL( 6 ) ? GTK_ACCEL_VISIBLE : hb_parni( 6 );
   gtk_widget_add_accelerator( widget, accel_signal, accel_group, accel_key, mode, accel_flags ); 
}

HB_FUNC( GTK_WIDGET_RENDER_ICON )
{
   GtkWidget *widget = GTK_WIDGET( hb_parptr( 1 ) );
   const gchar *stock_id = hb_parc( 2 );
   GtkIconSize size = hb_parni( 3 );
   const gchar * detail = hb_parc( 4 );
   GdkPixbuf * pixbuf = gtk_widget_render_icon( widget, stock_id, size, detail );
   hb_retptr( ( GdkPixbuf * ) pixbuf );
}
