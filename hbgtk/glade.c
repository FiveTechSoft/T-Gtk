/* $Id: glade.c,v 1.1 2006-09-08 12:18:45 xthefull Exp $*/
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
 * Glade. Support Glade----------------------------------------------------
 */

#include <gtk/gtk.h>
#include <glade/glade.h>
#include "hbapi.h"

HB_FUNC( GLADE_XML_NEW ) //fname,root,domain
{
  GladeXML *xml;
  xml = glade_xml_new( hb_parc( 1 ), ISNIL( 2 ) ? NULL : hb_parc( 2 ), ISNIL( 3 ) ? NULL : hb_parc( 3 ) );
  hb_retnl( (glong) xml );
}

HB_FUNC( GLADE_XML_GET_WIDGET )
{
  GtkWidget * widget;
  widget = glade_xml_get_widget( (GladeXML *) hb_parnl( 1 ), (gchar *) hb_parc( 2 ) );
  hb_retnl( (glong) widget );
}

HB_FUNC( GLADE_GET_WIDGET_NAME )
{
  GtkWidget * widget = GTK_WIDGET( hb_parnl( 1 ) );
  const gchar * name = glade_get_widget_name (widget);
  hb_retc( (gchar *) name );
}