/* $Id: gdauiproviderselector.c,v 1 2012-07-31 05:32:23 riztan Exp $*/
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
    (c)2012 Riztan Gutierrez <riztan at t-gtk.org>
*/
#include <hbapi.h>

#ifdef _GDA_
#include <gtk/gtk.h>
#include <libgda/libgda.h>
#include <libgda-ui/libgda-ui.h>


HB_FUNC( GDAUI_PROVIDER_SELECTOR_NEW ) 
{
   GtkWidget * selector;
   selector = gdaui_provider_selector_new();
   hb_retptr( selector );
}


HB_FUNC( GDAUI_PROVIDER_SELECTOR_GET_PROVIDER_OBJ ) 
{
   GdauiProviderSelector * selector = hb_parptr( 1 ); 

   hb_retptr( gdaui_provider_selector_get_provider_obj( selector ) );
}


HB_FUNC( GDAUI_PROVIDER_SELECTOR_GET_PROVIDER ) 
{
   GdauiProviderSelector * selector = hb_parptr( 1 ); 

   const gchar * provider = gdaui_provider_selector_get_provider( selector );
   hb_retc( provider );
}


HB_FUNC( GDAUI_PROVIDER_SELECTOR_SET_PROVIDER ) 
{
   GdauiProviderSelector * selector = hb_parptr( 1 ); 
   const gchar * provider = hb_parc( 1 ); 

   hb_parl( gdaui_provider_selector_set_provider( selector, provider ) );
}

#endif

//eof
