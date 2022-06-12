/* $Id: gtkapplication.c,v 1.8 2022-06-11 23:51:37 riztan Exp $*/
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
    (c)2022 Riztan Gutierrez <riztan at gmail dot com>
*/
#include <gtk/gtk.h>
#include "hbapi.h"
#include "t-gtk.h"

#if GTK_MAJOR_VERSION > 2

HB_FUNC( GTK_APPLICATION_NEW )
{
  const gchar* app_id = hb_parc( 1 );
  GApplicationFlags flags = hb_parni( 2 );
  GtkWidget * app = gtk_application_new ( app_id, flags ) ;

  hb_retptr( (GtkApplication * ) app );
}

#endif
//eol
