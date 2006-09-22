/* $Id: cvte.c,v 1.2 2006-09-22 19:43:52 xthefull Exp $*/
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
   
    Terminal for T-Gtk
   (C) 2006. Rafa Carmona -TheFull-
*/
#include <vte/vte.h>
#include "hbapi.h"
#include "hbvm.h"
#include "hbapiitm.h"
#include "hbstack.h"

BOOL Array2Color(PHB_ITEM aColor, GdkColor *color );

HB_FUNC( VTE_TERMINAL_NEW )
{
 VteTerminal *term;
 term = VTE_TERMINAL( vte_terminal_new() );
 hb_retnl( ( ULONG ) term );
}


HB_FUNC( HB_VTE_CONSOLE_USER ) 
{ 
 VteTerminal *term = VTE_TERMINAL( hb_parnl( 1 ) );
 hb_retni( vte_terminal_fork_command( term, NULL,NULL,NULL,NULL,FALSE,TRUE, TRUE ) );
}

HB_FUNC( HB_VTE_COMMAND ) 
{ 
 VteTerminal *term = VTE_TERMINAL( hb_parnl( 1 ) );
 const char *command = hb_parc( 2 );
 
 hb_retni( vte_terminal_fork_command( term, command ,NULL,NULL,NULL,FALSE,TRUE, TRUE ) );
}


HB_FUNC( VTE_TERMINAL_SET_SIZE )
{ 
 VteTerminal *term = VTE_TERMINAL( hb_parnl( 1 ) );
 glong columns = hb_parnl( 2 );
 glong rows    = hb_parnl( 3 );
 vte_terminal_set_size( term, columns, rows );
} 

HB_FUNC( VTE_TERMINAL_SET_FONT )
{ 
 VteTerminal *term = VTE_TERMINAL( hb_parnl( 1 ) );
 PangoFontDescription * font = ( PangoFontDescription * ) hb_parnl( 2 );
 vte_terminal_set_font( term, font );
} 

HB_FUNC( VTE_TERMINAL_SET_BACKGROUND_TRANSPARENT ) 
{ 
 VteTerminal *term = VTE_TERMINAL( hb_parnl( 1 ) );
 gboolean btransparent = hb_parl( 2 );
 
 vte_terminal_set_background_transparent( term, btransparent );
} 
 

HB_FUNC( VTE_TERMINAL_SET_COLOR_CURSOR )
{
  VteTerminal *term = VTE_TERMINAL( hb_parnl( 1 ) );
  GdkColor cursor_background;
  PHB_ITEM pColor = hb_param( 2, HB_IT_ARRAY );        // array

   if ( Array2Color( pColor, &cursor_background ) )
    {
     vte_terminal_set_color_cursor( term, &cursor_background );
     }
}


HB_FUNC( VTE_TERMINAL_SET_COLOR_HIGHLIGHT )
{
  VteTerminal *term = VTE_TERMINAL( hb_parnl( 1 ) );
  GdkColor color;
  PHB_ITEM pColor = hb_param( 2, HB_IT_ARRAY );        // array

   if ( Array2Color( pColor, &color ) )
    {
     vte_terminal_set_color_highlight( term, &color );
     }
}

HB_FUNC( VTE_TERMINAL_SET_COLOR_FOREGROUND )
{
  VteTerminal *term = VTE_TERMINAL( hb_parnl( 1 ) );
  GdkColor color;
  PHB_ITEM pColor = hb_param( 2, HB_IT_ARRAY );        // array

   if ( Array2Color( pColor, &color ) )
    {
     vte_terminal_set_color_foreground( term, &color );
     }                      
}

HB_FUNC( VTE_TERMINAL_SET_COLOR_BACKGROUND )
{
  VteTerminal *term = VTE_TERMINAL( hb_parnl( 1 ) );
  GdkColor color;
  PHB_ITEM pColor = hb_param( 2, HB_IT_ARRAY );        // array

   if ( Array2Color( pColor, &color ) )
    {
     vte_terminal_set_color_background( term, &color );
     }
}
