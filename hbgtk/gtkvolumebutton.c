/* $Id: gtkvolumebutton.c,v 1.1 2008-09-02 21:17:21 riztan Exp $*/
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
    (c)2008 Rafael Carmona <rafa.tgtk at gmail.com>
*/
#include <gtk/gtk.h>
#include "hbapi.h"

if GTK_CHECK_VERSION(2,12,0)

HB_FUNC( GTK_VOLUME_BUTTON_NEW ) // -> widget
{
   GtkWidget * button = gtk_volume_button_new ();
   hb_retnl( (glong) button );
}
#endif
