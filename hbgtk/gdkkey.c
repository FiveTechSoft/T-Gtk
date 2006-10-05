/* $Id: gdkkey.c,v 1.4 2006-10-05 15:45:19 rosenwla Exp $*/
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
 * Api GDK
 * Key Values — Functions for manipulating keyboard codes
 */

#include <gtk/gtk.h>
#include "hbapi.h"

HB_FUNC( GDK_KEYVAL_FROM_NAME ) // cValue --> nValue
{
hb_retni( (guint) gdk_keyval_from_name( hb_parc( 1 ) ));
}

HB_FUNC( GDK_KEYVAL_NAME ) // nValue --> cValue
{
 hb_retc( (gchar *) gdk_keyval_name( hb_parni( 1 ) ));
}

HB_FUNC( GDK_KEYVAL_TO_UNICODE )
{
  guint32 keyval = gdk_keyval_to_unicode( hb_parni( 1 ) );
  hb_retni( (guint32 )keyval );
}

HB_FUNC( GDK_UNICODE_TO_KEYVAL )
{
  guint wc = gdk_unicode_to_keyval( (guint32) hb_parni( 1 ) );
  hb_retni( (guint) wc );
}

HB_FUNC( G_LOCALE_TO_UTF8 )
{
  
  gchar *msg = g_locale_to_utf8( hb_parc(1), -1, NULL, NULL, NULL);
  hb_retc( msg );
}

HB_FUNC( G_LOCALE_FROM_UTF8 )
{
  
  gchar *msg = g_locale_from_utf8( hb_parc(1), -1, NULL, NULL, NULL);
  hb_retc( msg );
}
