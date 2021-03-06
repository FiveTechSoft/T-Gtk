/* $Id: gtkseparator.c,v 1.1 2006-09-08 12:18:45 xthefull Exp $*/
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

#if GTK_MAJOR_VERSION < 3

HB_FUNC( GTK_HSEPARATOR_NEW )
{
  #if GTK_MAJOR_VERSION < 3
      GtkWidget * separator =  gtk_hseparator_new ();
  #else    
      GtkWidget * separator =  gtk_separator_new( GTK_ORIENTATION_HORIZONTAL );
  #endif    
  hb_retptr( ( GtkWidget * ) separator );
}

HB_FUNC( GTK_VSEPARATOR_NEW )
{
  #if GTK_MAJOR_VERSION < 3
      GtkWidget * separator =  gtk_vseparator_new ();
  #else    
      GtkWidget * separator =  gtk_separator_new( GTK_ORIENTATION_VERTICAL );
  #endif    
  hb_retptr( ( GtkWidget * ) separator );
}

#endif
