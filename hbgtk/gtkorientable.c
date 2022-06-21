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
    (c)2022 Rafael Carmona <rafa.thefull@gmail.com>

*/
#include <gtk/gtk.h>
#include "hbapi.h"

HB_FUNC( GTK_ORIENTABLE_SET_ORIENTATION ) 
{    
  GtkWidget * widget = GTK_WIDGET( hb_parptr( 1 ) );
  gtk_orientable_set_orientation (GTK_ORIENTABLE( widget), hb_parni( 2 ) );
}

