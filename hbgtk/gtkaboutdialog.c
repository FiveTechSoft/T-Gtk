/* $Id: gtkaboutdialog.c,v 1.1 2006-09-22 19:43:53 xthefull Exp $*/
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
    (c)2006 Rafael Carmona <thefull@wanadoo.es>
*/
#include <gtk/gtk.h>
#include "hbapi.h"
#include "hbvm.h"
#include "hbapiitm.h"
#include "hbstack.h"

#if GTK_CHECK_VERSION(2,6,0)

HB_FUNC( GTK_ABOUT_DIALOG_NEW )
{
  GtkWidget * dialog = gtk_about_dialog_new();
  hb_retnl( (glong) dialog );
}

HB_FUNC( GTK_ABOUT_DIALOG_GET_NAME )
{
  GtkAboutDialog  * dialog = GTK_ABOUT_DIALOG( hb_parnl( 1 ) );
  const gchar *szText = gtk_about_dialog_get_name( dialog );
  hb_retc( szText );
}

HB_FUNC( GTK_ABOUT_DIALOG_SET_NAME )
{
  GtkAboutDialog  * dialog = GTK_ABOUT_DIALOG( hb_parnl( 1 ) );
  const gchar *szText = hb_parc( 2 );
  gtk_about_dialog_set_name( dialog, szText );
}

HB_FUNC( GTK_ABOUT_DIALOG_GET_VERSION )
{
  GtkAboutDialog  * dialog = GTK_ABOUT_DIALOG( hb_parnl( 1 ) );
  const gchar *szText = gtk_about_dialog_get_version( dialog );
  hb_retc( szText );
}

HB_FUNC( GTK_ABOUT_DIALOG_SET_VERSION )
{
  GtkAboutDialog  * dialog = GTK_ABOUT_DIALOG( hb_parnl( 1 ) );
  const gchar *szText = hb_parc( 2 );
  gtk_about_dialog_set_version( dialog, szText );
}

HB_FUNC( GTK_SHOW_ABOUT_DIALOG )
{
  GtkWindow  * parent ;
  parent = ISNIL( 1 ) ? NULL : GTK_WINDOW( hb_parnl( 1 ) );
  gtk_show_about_dialog( parent, NULL );
}

#endif
