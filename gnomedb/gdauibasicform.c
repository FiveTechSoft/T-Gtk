/* $Id: gdauibasicform.c,v 1 2012-07-31 06:25:22 riztan Exp $*/
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


HB_FUNC( GDAUI_BASIC_FORM_NEW ) 
{
   GtkWidget * form;
   GdaSet * data_set = hb_parptr( 1 );

   form = gdaui_basic_form_new( data_set );
   hb_retptr( form );
}


HB_FUNC( GDAUI_BASIC_FORM_NEW_IN_DIALOG ) 
{
   GtkWidget * widget;
   GdaSet * data_set  = hb_parptr( 1 );
   GtkWindow * parent = hb_parptr( 2 );
   const gchar * title  = hb_parc( 3 );
   const gchar * header = hb_parc( 4 );

   widget = gdaui_basic_form_new_in_dialog( data_set, parent, title, header );
   hb_retptr( widget );
}


HB_FUNC( GDAUI_BASIC_FORM_GET_DATA_SET ) 
{
   GdauiBasicForm * form = hb_parptr( 1 );
   GdaSet * data_set  = hb_parptr( 1 );

   data_set = gdaui_basic_form_get_data_set( form );
   hb_retptr( data_set );
}


HB_FUNC( GDAUI_BASIC_FORM_IS_VALID ) 
{
   GdauiBasicForm * form = hb_parptr( 1 );

   hb_retl( gdaui_basic_form_is_valid( form ) );
}


HB_FUNC( GDAUI_BASIC_FORM_HAS_CHANGED ) 
{
   GdauiBasicForm * form = hb_parptr( 1 );

   hb_retl( gdaui_basic_form_is_valid( form ) );
}


HB_FUNC( GDAUI_BASIC_FORM_RESET ) 
{
   GdauiBasicForm * form = hb_parptr( 1 );
   gdaui_basic_form_reset( form );
}


#endif

//eof
