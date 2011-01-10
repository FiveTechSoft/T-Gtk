/* $Id: gtkexpander.c,v 1.1 2006-09-08 12:18:45 xthefull Exp $*/
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
#include <hbapi.h>
#include <gtk/gtk.h>
#include <t-gtk.h>

#if GTK_CHECK_VERSION(2,4,0)

/* Nota:
 * Es indistinto usar GTK_EXPANDER( hb_parnl(1) ) , o
 *                   ( GtkExpander * ) hb_parnl( 1 )
 */

HB_FUNC( GTK_EXPANDER_NEW )//-->widget
{
    gchar *msg = str2utf8( ( gchar * ) hb_parc( 1 ) );
    GtkWidget * expander = gtk_expander_new( msg );
    SAFE_RELEASE( msg );
    hb_retptr( ( GtkWidget * ) expander );
}

HB_FUNC( GTK_EXPANDER_NEW_WITH_MNEMONIC ) //-->widget
{
    gchar *msg = str2utf8( ( gchar * ) hb_parc( 1 ) );
    GtkWidget * expander = gtk_expander_new_with_mnemonic( msg );
    SAFE_RELEASE( msg );
    hb_retptr( ( GtkWidget * ) expander );
}

HB_FUNC( GTK_EXPANDER_SET_EXPANDED ) // widget, bExpand
{
   GtkExpander * expander = ( GtkExpander * ) hb_parptr( 1 );
   gtk_expander_set_expanded( expander , hb_parl( 2 ) );
}

HB_FUNC( GTK_EXPANDER_GET_EXPANDED ) // widget , -->bExpand
{
   GtkExpander * expander = ( GtkExpander * ) hb_parptr( 1 );
   hb_retl( gtk_expander_get_expanded ( expander ) );
}

HB_FUNC( GTK_EXPANDER_SET_SPACING )
{
   GtkExpander * expander = ( GtkExpander * ) hb_parptr( 1 );
   gtk_expander_set_spacing( expander, hb_parni( 2 ) );
}

HB_FUNC( GTK_EXPANDER_GET_SPACING ) // widget --> iSpacing
{
   GtkExpander * expander = ( GtkExpander * ) hb_parptr( 1 );
   hb_retni( gtk_expander_get_spacing( expander ) );
}

HB_FUNC( GTK_EXPANDER_SET_LABEL ) // widget, cText
{
   GtkExpander * expander = ( GtkExpander * ) hb_parptr( 1 );
   gchar *msg = str2utf8( ( gchar * ) hb_parc( 2 ) );   
   gtk_expander_set_label( expander, msg );
   SAFE_RELEASE( msg );
}

HB_FUNC( GTK_EXPANDER_GET_LABEL ) // widget --> cText
{
   GtkExpander * expander = GTK_EXPANDER( hb_parptr( 1 ) );
   hb_retc( ( gchar* ) gtk_expander_get_label( expander ) );
}

HB_FUNC( GTK_EXPANDER_SET_USE_UNDERLINE ) // widget, bUser_underline
{
  GtkExpander * expander = ( GtkExpander * ) hb_parptr( 1 );
  gtk_expander_set_use_underline( expander, hb_parl( 2 ) );
}

HB_FUNC( GTK_EXPANDER_GET_USE_UNDERLINE ) //widget--> bUnderLine
{
  GtkExpander * expander = ( GtkExpander * ) hb_parptr( 1 );
  hb_retl(  gtk_expander_get_use_underline( expander ) );
}

HB_FUNC( GTK_EXPANDER_SET_USE_MARKUP ) // widget, bUse_markup
{
  GtkExpander * expander = ( GtkExpander * ) hb_parptr( 1 );
  gtk_expander_set_use_markup( expander, hb_parl( 2 ) );
}

HB_FUNC( GTK_EXPANDER_GET_USE_MARKUP ) // widget -->bUse_markup
{
  GtkExpander * expander = ( GtkExpander * ) hb_parptr( 1 );
  hb_retl( gtk_expander_get_use_markup( expander ) );
}
#endif
