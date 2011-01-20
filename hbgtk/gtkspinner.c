/* $Id: gtkspinner.c,v 1.1 2011-02-01 12:18:45 xthefull Exp $*/
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
    (c)2003-11 Rafael Carmona <thefull@wanadoo.es>
*/

#include <gtk/gtk.h>
#include "hbapi.h"
#include <t-gtk.h>

#if GTK_CHECK_VERSION(2,20,0)

HB_FUNC( GTK_SPINNER_NEW ) // -> widget
{
   GtkWidget * spinner = gtk_spinner_new( );
   hb_retptr( ( GtkWidget * ) spinner );

}

HB_FUNC( GTK_SPINNER_START ) 
{
  GtkWidget * spinner = GTK_WIDGET( hb_parptr( 1 ) );
  gtk_spinner_start( GTK_SPINNER( spinner) );
}

HB_FUNC( GTK_SPINNER_STOP ) 
{
  GtkWidget * spinner = GTK_WIDGET( hb_parptr( 1 ) );
  gtk_spinner_stop( GTK_SPINNER( spinner) );
}

#endif
