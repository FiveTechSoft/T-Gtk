/* $Id: pango.c,v 1.4 2010-05-26 10:15:03 xthefull Exp $*/
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
#include "hbapiitm.h"
#include "t-gtk.h"


PHB_ITEM PangoMatrix2Array( PangoMatrix * matrix );
BOOL Array2PangoMatrix(PHB_ITEM aMatrix, PangoMatrix * matrix  );
PHB_ITEM Color2Array( GdkColor *color );
BOOL Array2Color(PHB_ITEM aColor, GdkColor *color );

HB_FUNC( GTK_FONT_SELECTION_NEW )
{
   GtkWidget * font = gtk_font_selection_new();
   hb_retnl( (glong) font );
}

HB_FUNC( GTK_FONT_SELECTION_SET_FONT_NAME )
{
   GtkWidget * font = GTK_WIDGET( hb_parnl( 1 ) );
   gtk_font_selection_set_font_name( GTK_FONT_SELECTION( font ), hb_parc( 2 ) );
}

HB_FUNC( GTK_FONT_SELECTION_GET_FONT )
{
   GtkWidget * font = GTK_WIDGET( hb_parnl( 1 ) );
   hb_retc( (gchar*) gtk_font_selection_get_font( GTK_FONT_SELECTION( font ) ) );
}


#if GTK_CHECK_VERSION(2,6,0)
/* Soporte para fonts se realiza a traves de Pango */
HB_FUNC( PANGO_FONT_DESCRIPTION_FROM_STRING ) //cString_font
{
   PangoFontDescription * Font = pango_font_description_from_string( hb_parc( 1 ) );
   hb_retnl( ( glong ) Font );
}

HB_FUNC( PANGO_FONT_DESCRIPTION_FREE ) // *Font
{
   pango_font_description_free( ( PangoFontDescription * ) hb_parnl( 1 ) );
}

HB_FUNC( PANGO_FONT_DESCRIPTION_SET_SIZE ) 
{
   PangoFontDescription * Font = pango_font_description_from_string( hb_parc( 1 ) );
   gint size = hb_parni( 2 );
   pango_font_description_set_size( Font, size );
}
#endif
/* API Layout Objects â€” Highlevel layout driver objects */
HB_FUNC( PANGO_LAYOUT_NEW )
{
  PangoContext * context = (PangoContext *)hb_parnl( 1 );
  PangoLayout * pango = pango_layout_new( context );
  hb_retnl( (glong) pango );
}

HB_FUNC( PANGO_LAYOUT_CONTEXT_CHANGED )
{
  PangoLayout * layout = PANGO_LAYOUT( hb_parnl( 1 ) ) ;
  pango_layout_context_changed (layout);
}

#if GTK_CHECK_VERSION(2,6,0)
HB_FUNC( PANGO_RENDERER_DRAW_LAYOUT )
{
  PangoRenderer * renderer = PANGO_RENDERER( hb_parnl( 1 ) );
  PangoLayout * layout = PANGO_LAYOUT( hb_parnl( 2 ) ) ;
  pango_renderer_draw_layout( renderer, layout, hb_parni( 3 ), hb_parni( 4 ) );
}
#endif
HB_FUNC( PANGO_LAYOUT_GET_SIZE )
{
  PangoLayout * layout = PANGO_LAYOUT( hb_parnl( 1 ) ) ;
  gint width  = hb_parni( 2 );
  gint height = hb_parni( 3 );
  pango_layout_get_size(layout, &width, &height);
  hb_storni( (gint) width,  2 );
  hb_storni( (gint) height, 3 );
}

HB_FUNC( PANGO_LAYOUT_SET_TEXT )
{
  PangoLayout * layout = PANGO_LAYOUT( hb_parnl( 1 ) ) ;
  gchar * text = hb_parc( 2 );
  gint length = ISNIL(3) ? -1 : hb_parni( 3 );
  pango_layout_set_text( layout, text, length );
}

HB_FUNC( PANGO_LAYOUT_SET_FONT_DESCRIPTION )
{
  PangoLayout * layout = PANGO_LAYOUT( hb_parnl( 1 ) ) ;
  PangoFontDescription *desc = (PangoFontDescription *)hb_parnl( 2 );
  pango_layout_set_font_description( layout, desc );
}

HB_FUNC( PANGO_LAYOUT_SET_MARKUP )
{
 PangoLayout * layout = PANGO_LAYOUT( hb_parnl( 1 ) ) ;
 gint length = ISNIL(3) ? -1 : hb_parni( 3 );
 pango_layout_set_markup( layout, hb_parc( 2 ), length );
}

HB_FUNC( PANGO_LAYOUT_SET_WIDTH )
{
 PangoLayout * layout = PANGO_LAYOUT( hb_parnl( 1 ) ) ;
 gint width = hb_parni( 2 );
 pango_layout_set_width( layout, width );
}

HB_FUNC( PANGO_LAYOUT_SET_ALIGNMENT )
{
 PangoLayout * layout = PANGO_LAYOUT( hb_parnl( 1 ) ) ;
 PangoAlignment alignment = hb_parni( 2 );
 pango_layout_set_alignment( layout, alignment );
}

#if GTK_CHECK_VERSION(2,8,0)

/*
 * Cairo Rendering — Rendering with the Cairo backend
 */
HB_FUNC( PANGO_CAIRO_SHOW_LAYOUT ) // ctx, layout
{
 cairo_t *ctx = ( cairo_t * ) hb_parnl( 1 );
 PangoLayout * layout = PANGO_LAYOUT( hb_parnl( 2 ) ) ;
 pango_cairo_show_layout( ctx, layout );
}

HB_FUNC( PANGO_CAIRO_LAYOUT_PATH ) // ctx, layout
{
 cairo_t *ctx = ( cairo_t * ) hb_parnl( 1 );
 PangoLayout * layout = PANGO_LAYOUT( hb_parnl( 2 ) ) ;
 pango_cairo_layout_path( ctx, layout );
}
#endif

#if GTK_CHECK_VERSION(2,6,0)

/*Pango Interaction
  Pango Interaction  Using Pango in GDK
 */
HB_FUNC( GDK_PANGO_RENDERER_GET_DEFAULT )
{
    GdkScreen *screen  = GDK_SCREEN( hb_parnl( 1 ) );
    PangoRenderer * pango = gdk_pango_renderer_get_default( screen );
    hb_retnl( (glong) pango );
}

HB_FUNC( GDK_PANGO_RENDERER_SET_DRAWABLE )
{
  GdkPangoRenderer * renderer = GDK_PANGO_RENDERER( hb_parnl( 1 ) );
  GdkDrawable * drawable =  ISNIL(2) ? NULL : GDK_DRAWABLE( hb_parnl( 2 ) );
  gdk_pango_renderer_set_drawable(renderer, drawable );
}

HB_FUNC( GDK_PANGO_RENDERER_SET_GC )
{
  GdkPangoRenderer * renderer = GDK_PANGO_RENDERER( hb_parnl( 1 ) );
  GdkGC * gc = ISNIL(2) ? NULL : GDK_GC( hb_parnl( 2 ) );
  gdk_pango_renderer_set_gc( renderer, gc );
}

HB_FUNC( GDK_PANGO_RENDERER_SET_OVERRIDE_COLOR )
{
  GdkPangoRenderer * renderer = GDK_PANGO_RENDERER( hb_parnl( 1 ) );
  GdkColor color;
  PHB_ITEM pColor = hb_param( 2, HB_IT_ARRAY );        // array

  if( ISNIL( 2 ) )
  {
    gdk_pango_renderer_set_override_color( renderer, PANGO_RENDER_PART_FOREGROUND, NULL );
  }
  else
  {
    if ( Array2Color( pColor, &color ) )
       {
       gdk_pango_renderer_set_override_color( renderer, PANGO_RENDER_PART_FOREGROUND, &color );
       hb_storni( (guint32) (color.pixel),2, 1);
       hb_storni( (guint16) (color.red)  ,2, 2);
       hb_storni( (guint16) (color.green),2, 3);
       hb_storni( (guint16) (color.blue) ,2, 4);
       }
     else{
        g_print("Falla gdk_pango_renderer_set_override_color\n");
     }
    }
}
#endif

HB_FUNC( PANGO_CONTEXT_SET_MATRIX )
{
  PangoContext * context = (PangoContext *) hb_parnl( 1 );
  PHB_ITEM pMatrix = hb_param( 2, HB_IT_ARRAY );  // array
  PangoMatrix matrix;

  if ( Array2PangoMatrix( pMatrix, &matrix ) )
      {
        pango_context_set_matrix( context, &matrix);
        hb_stornd( (double)( matrix.xx ),2, 1);
        hb_stornd( (double)( matrix.xy ),2, 2);
        hb_stornd( (double)( matrix.yx ),2, 3);
        hb_stornd( (double)( matrix.yy ),2, 4);
        hb_stornd( (double)( matrix.x0 ),2, 5);
        hb_stornd( (double)( matrix.y0 ),2, 6);
      }
   else
     {
      g_print("Falla pango_context_set_matrix\n");
     }

}

HB_FUNC( PANGO_MATRIX_TRANSLATE )
{
  PHB_ITEM pMatrix = hb_param( 1, HB_IT_ARRAY );  // array
  PangoMatrix matrix;

  if ( Array2PangoMatrix( pMatrix, &matrix ) )
      {
        pango_matrix_translate( &matrix,  hb_parnd( 2 ), hb_parnd( 3 ) );
        hb_stornd( (double) ( matrix.xx ),1, 1);
        hb_stornd( (double) ( matrix.xy ),1, 2);
        hb_stornd( (double) ( matrix.yx ),1, 3);
        hb_stornd( (double) ( matrix.yy ),1, 4);
        hb_stornd( (double) ( matrix.x0 ),1, 5);
        hb_stornd( (double) ( matrix.y0 ),1, 6);
      }
   else
      {
        g_print("Falla pango_matrix_translate\n");
      }

}

HB_FUNC( PANGO_MATRIX_SCALE )
{
  PHB_ITEM pMatrix = hb_param( 1, HB_IT_ARRAY );  // array
  PangoMatrix matrix;

  if ( Array2PangoMatrix( pMatrix, &matrix ) )
      {
        pango_matrix_scale( &matrix,  hb_parnd( 2 ), hb_parnd( 3 ) );
        hb_stornd( (double) ( matrix.xx ),1, 1);
        hb_stornd( (double) ( matrix.xy ),1, 2);
        hb_stornd( (double) ( matrix.yx ),1, 3);
        hb_stornd( (double) ( matrix.yy ),1, 4);
        hb_stornd( (double) ( matrix.x0 ),1, 5);
        hb_stornd( (double) ( matrix.y0 ),1, 6);
      }
   else
      {
        g_print("Falla pango_matrix_scale\n");
      }

}

HB_FUNC( PANGO_MATRIX_ROTATE )
{
  PHB_ITEM pMatrix = hb_param( 1, HB_IT_ARRAY );  // array
  PangoMatrix matrix;
  double angle = hb_parnd( 2 );

  if ( Array2PangoMatrix( pMatrix, &matrix ) )
      {
        pango_matrix_rotate( &matrix,  angle );
        hb_stornd( (double) ( matrix.xx ),1, 1);
        hb_stornd( (double) ( matrix.xy ),1, 2);
        hb_stornd( (double) ( matrix.yx ),1, 3);
        hb_stornd( (double) ( matrix.yy ),1, 4);
        hb_stornd( (double) ( matrix.x0 ),1, 5);
        hb_stornd( (double) ( matrix.y0 ),1, 6);
      }
   else
   {
     g_print("Falla pango_matrix_rotate\n");
   }
}


/*
 * Convierte una estructura item en un array de Harbour
typedef struct {
  double xx;
  double xy;
  double yx;
  double yy;
  double x0;
  double y0;
} PangoMatrix;
 * #define PANGO_MATRIX_INIT { 1., 0., 0., 1., 0., 0. }
*/

PHB_ITEM PangoMatrix2Array( PangoMatrix * matrix )
{
   PHB_ITEM aMatrix = hb_itemArrayNew(6);
   PHB_ITEM element = hb_itemNew( NULL );
   hb_arraySet( aMatrix, 1, hb_itemPutND( element, matrix->xx ) );
   hb_arraySet( aMatrix, 2, hb_itemPutND( element, matrix->xy ) );
   hb_arraySet( aMatrix, 3, hb_itemPutND( element, matrix->yx ) );
   hb_arraySet( aMatrix, 4, hb_itemPutND( element, matrix->yy ) );
   hb_arraySet( aMatrix, 5, hb_itemPutND( element, matrix->x0 ) );
   hb_arraySet( aMatrix, 6, hb_itemPutND( element, matrix->y0 ) );
   hb_itemRelease(element);
   return aMatrix;
}

/*
 * Convierte un array en un PangoMatrix
 * Comprueba si el dato pasado es correcto y su numero de elementos
 */
BOOL Array2PangoMatrix(PHB_ITEM aMatrix, PangoMatrix * matrix  )
{
   if (HB_IS_ARRAY( aMatrix ) && hb_arrayLen( aMatrix ) == 6) {
       matrix->xx = (double) hb_arrayGetND( aMatrix, 1 );
       matrix->xy = (double) hb_arrayGetND( aMatrix, 2 );
       matrix->yx = (double) hb_arrayGetND( aMatrix, 3 );
       matrix->yy = (double) hb_arrayGetND( aMatrix, 4 );
       matrix->x0 = (double) hb_arrayGetND( aMatrix, 5 );
       matrix->y0 = (double) hb_arrayGetND( aMatrix, 6 );
      return TRUE ;
   }
   return FALSE;
}
