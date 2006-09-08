/* $Id: gtkcheckbox.c,v 1.1 2006-09-08 12:18:45 xthefull Exp $*/
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
#include <gtk/gtk.h>
#include "hbapi.h"


HB_FUNC( GTK_CHECK_BUTTON_NEW )
{
   GtkWidget * checkbox = gtk_check_button_new();
   hb_retnl( ( glong ) checkbox );
}

HB_FUNC( GTK_CHECK_BUTTON_NEW_WITH_LABEL )
{
   GtkWidget * checkbox = gtk_check_button_new_with_label( hb_parc( 1 ) );
   hb_retnl( ( glong ) checkbox );
}

HB_FUNC( GTK_CHECK_BUTTON_NEW_WITH_MNEMONIC )
{
   GtkWidget * checkbox = gtk_check_button_new_with_mnemonic( hb_parc( 1 ) );
   hb_retnl( ( glong ) checkbox );
}


