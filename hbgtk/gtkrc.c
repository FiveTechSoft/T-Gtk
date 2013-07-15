/* $Id: gtkrc.c,v 1.1 2006-09-08 12:18:45 xthefull Exp $*/
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
/*
 * GtkRc. Manejo de 'recursos' en GTK ----------------------------------------
 */

#include <gtk/gtk.h>
#include "hbapi.h"

#ifdef _GTK2_

HB_FUNC( GTK_RC_GET_THEME_DIR ) // -> path de instalacion de los temas
{
  gchar * path = gtk_rc_get_theme_dir();
  hb_retc( path );
  g_free( path );
}

HB_FUNC( GTK_RC_PARSE )        // filename -> void
{
  gtk_rc_parse( (gchar *) hb_parc( 1 ) );
}

HB_FUNC( GTK_RC_PARSE_STRING ) // string -> void
{
  gtk_rc_parse_string( (gchar *) hb_parc(1) );
}

HB_FUNC( GTK_RC_REPARSE_ALL) // void-->boolean
{
  hb_retl( gtk_rc_reparse_all() );
}

HB_FUNC( GTK_RC_RESET_STYLES ) // pSetting;
{
  GtkSettings * settings = GTK_SETTINGS( hb_parptr( 1 ) );
  gtk_rc_reset_styles(settings);
}

HB_FUNC( GTK_RC_REPARSE_ALL_FOR_SETTINGS ) // void-->boolean
{
  GtkSettings * settings = GTK_SETTINGS( hb_parptr( 1 ) );
  gboolean force_load = ISNIL( 2 ) ? TRUE : hb_parl( 2 );

  hb_retl( gtk_rc_reparse_all_for_settings( settings, force_load ) );
}

#endif
