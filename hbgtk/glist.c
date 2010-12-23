/* $Id: glist.c,v 1.2 2010-12-23 16:44:22 xthefull Exp $*/
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

/* Funciones de G_Lib para T-Gtk */

#include <glib.h>
#include <glib-object.h>
#include "hbapi.h"

HB_FUNC( G_LIST_APPEND )
{
	GList *list = (GList *) hb_parnl( 1 );
	list = g_list_append (list, ( gpointer )hb_parc( 2 ) );
    hb_retnl( ( glong) list );
}

HB_FUNC( G_LIST_FREE )
{
  GList *list = (GList *) hb_parnl( 1 );
  g_list_free( list );
}

HB_FUNC( G_LIST_FIRST )
{
  GList *list = (GList *) hb_parnl( 1 );
  hb_retnl( (glong) g_list_first( list ) );
}

HB_FUNC( G_LIST_LAST )
{
  GList *list = (GList *) hb_parnl( 1 );
  hb_retnl( (glong) g_list_last( list ) );
}

HB_FUNC( G_LIST_PREVIOUS )
{
  GList *list = (GList *) hb_parnl( 1 );
  hb_retnl( (glong) g_list_previous( list ) );
}

HB_FUNC( G_LIST_NEXT )
{
  GList *list = (GList *) hb_parnl( 1 );
  hb_retnl( (glong) g_list_next( list ) );
}


HB_FUNC( G_TYPE_MAKE_FUNDAMENTAL )
{
 gint type = G_TYPE_MAKE_FUNDAMENTAL( hb_parni( 1 ) );
 hb_retni( type );
}
