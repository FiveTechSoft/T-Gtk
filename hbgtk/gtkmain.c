/* $Id: gtkmain.c,v 1.2 2007-03-14 21:34:13 xthefull Exp $*/
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
 * GtkMain. Control de 'entrada y salida' a GTK+ -----------------------------
 */

#include <gtk/gtk.h>
#include "hbapi.h"

HB_FUNC( GTK_MAIN )
{
  gtk_main();
#ifdef _GTK_THREAD_
  gdk_threads_leave();
#endif
}

HB_FUNC( GTK_MAIN_QUIT )
{
  gtk_main_quit();
}

HB_FUNC( G_PRINT )
{
    const gchar *format = hb_parc( 1 );
    g_print( format, NULL );
    hb_retc( hb_parc(1) );
}

#if GTK_MAJOR_VERSION < 3
#if GTK_MINOR_VERSION < 37
   HB_FUNC( G_TYPE_INIT )
   {
     g_type_init();
   }
#endif
#endif

HB_FUNC( GTK_CHECK_VERSION )
{
hb_retl( GTK_CHECK_VERSION( hb_parni(1),hb_parni(2),hb_parni(3) ) );
}
