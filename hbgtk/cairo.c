/*
 *  API Cairo for [x]Harbour.
 *  Cairo: A Vector Graphics Library
 * 
 *  This program is free software; you can redistribute it and/or
 *  modify it under the terms of the GNU Library General Public License
 *  as published by the Free Software Foundation; either version 2 of
 *  the License, or (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU Library General Public License for more details.
 *
 *  You should have received a copy of the GNU Library General Public
 *  License along with this program; if not, write to the Free Software
 *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 *
 *  Authors:
 *    Rafa Carmona( thefull@wanadoo.es )
 *
 *  Copyright 2007 Rafa Carmona
 */
#include <hbapi.h>
#include <gtk/gtk.h>

#ifdef _GTK2_

#if GTK_CHECK_VERSION(2,8,0)
HB_FUNC( CAIRO_MOVE_TO ) // ctx, x, y
{
  cairo_t *ctx = ( cairo_t * ) hb_parptr( 1 );
  cairo_move_to( ctx ,
                 hb_parnd( 2 ),
                 hb_parnd( 3 ) );
}

HB_FUNC( CAIRO_RECTANGLE ) // ctx, x, y, width, height
{
  cairo_t *ctx = ( cairo_t * ) hb_parptr( 1 );
  cairo_rectangle( ctx ,
                   hb_parnd( 2 ),
                   hb_parnd( 3 ),
                   hb_parnd( 4 ),
                   hb_parnd( 5 ) );

}

HB_FUNC( CAIRO_SET_SOURCE_RGB ) // ctx, red, greee, blue
{
  cairo_t *ctx = ( cairo_t * ) hb_parptr( 1 );
  cairo_set_source_rgb( ctx ,
                   hb_parnd( 2 ),
                   hb_parnd( 3 ),
                   hb_parnd( 4 ) );

}

HB_FUNC( CAIRO_FILL ) // ctx
{
  cairo_t *ctx = ( cairo_t * ) hb_parptr( 1 );
  cairo_fill( ctx );
}

HB_FUNC( CAIRO_REL_MOVE_TO ) // ctx, x, y
{
  cairo_t *ctx = ( cairo_t * ) hb_parptr( 1 );
  cairo_rel_move_to( ctx ,
                 hb_parnd( 2 ),
                 hb_parnd( 3 ) );
}

HB_FUNC( CAIRO_SET_LINE_WIDTH ) // ctx, width
{
  cairo_t *ctx = ( cairo_t * ) hb_parptr( 1 );
  cairo_set_line_width( ctx , hb_parnd( 2 ) );
}

HB_FUNC( CAIRO_STROKE_PRESERVE ) // ctx
{
  cairo_t *ctx = ( cairo_t * ) hb_parptr( 1 );
  cairo_stroke_preserve( ctx );
}

HB_FUNC( CAIRO_STROKE ) // ctx
{
  cairo_t *ctx = ( cairo_t * ) hb_parptr( 1 );
  cairo_stroke( ctx );
}

HB_FUNC( CAIRO_CLIP ) // ctx
{
  cairo_t *ctx = ( cairo_t * ) hb_parptr( 1 );
  cairo_clip( ctx );
}   

HB_FUNC( CAIRO_PAINT ) // ctx
{
  cairo_t *ctx = ( cairo_t * ) hb_parptr( 1 );
  cairo_paint( ctx );
}         
#endif

#endif

