/* $Id: gtktooltips.c,v 1.1 2006-09-08 12:18:45 xthefull Exp $*/
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
#include <hbapi.h>
#include <gtk/gtk.h>
#include <t-gtk.h>

#if GTK_MAJOR_VERSION < 3

HB_FUNC( GTK_TOOLTIPS_NEW ) //->widget
{
   GtkTooltips * hWnd = gtk_tooltips_new( );

   hb_retptr( ( GtkTooltips * ) hWnd );
}

HB_FUNC( GTK_TOOLTIPS_SET_TIP ) // tooltips, widgetchild, cText
{
   GtkTooltips * tooltips = GTK_TOOLTIPS( hb_parptr( 1 ) );
   GtkWidget * widgetchild = GTK_WIDGET( hb_parptr( 2 ) );
   gchar *msg = str2utf8( ( gchar * ) hb_parc( 3 ) );

   gtk_tooltips_set_tip ( tooltips, widgetchild, msg, NULL );
   
   SAFE_RELEASE( msg );
   
}

HB_FUNC( GTK_TOOLTIPS_ENABLE ) //tooltips
{
   GtkTooltips * tooltips = GTK_TOOLTIPS( hb_parptr( 1 ) );
   gtk_tooltips_enable( tooltips  );

 }

HB_FUNC( GTK_TOOLTIPS_DISABLE ) //tooltips
{
   GtkTooltips * tooltips = GTK_TOOLTIPS( hb_parptr( 1 ) );
   gtk_tooltips_disable(  tooltips  );
}

HB_FUNC( GTK_TOOLTIPS_SET_DELAY ) //tooltips, delay(default 1000ms)
{
   GtkTooltips * tooltips = GTK_TOOLTIPS( hb_parptr( 1 ) );
   gtk_tooltips_set_delay(  tooltips , hb_parni( 2 ) );
}

#endif
