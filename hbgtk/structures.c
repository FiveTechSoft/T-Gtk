/* $Id: structures.c,v 1.1 2006-09-08 12:18:45 xthefull Exp $*/
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

/*
 * FUNCIONES GENERICAS QUE NOS DEVUELVE VALORES DE LOS MIEMBROS
 * DE LA ESTRUCTURA WIDGET
 */
HB_FUNC( HB_GET_WIDGET_WINDOW )
{
   GtkWidget * widget = GTK_WIDGET( hb_parptr( 1 ) );
   hb_retptr( (GdkWindow *) widget->window );
}

HB_FUNC( HB_GET_WIDGET_STYLE_BLACK_GC )
{
   GtkWidget * widget = GTK_WIDGET( hb_parptr( 1 ) );
   hb_retptr( (GdkGC *) widget->style->black_gc ); // GdkGC *black_gc
}

HB_FUNC( HB_GET_WIDGET_ALLOCATION_WIDTH )
{
   GtkWidget * widget = GTK_WIDGET( hb_parptr( 1 ) );
   hb_retni(  widget->allocation.width );
}

HB_FUNC( HB_GET_WIDGET_ALLOCATION_HEIGHT )
{
   GtkWidget * widget = GTK_WIDGET( hb_parptr( 1 ) );
   hb_retni(  widget->allocation.height );
}
   
HB_FUNC( HB_GET_EVENTEXPOSE_AREA_Y )
{
   GdkEventExpose * event = ( GdkEventExpose *) hb_parptr( 1 ) ;
   hb_retni(  event->area.y );
}

HB_FUNC( HB_GET_EVENTEXPOSE_AREA_X )
{
   GdkEventExpose * event = ( GdkEventExpose *) hb_parptr( 1 ) ;
   hb_retni(  event->area.x );
}

HB_FUNC( HB_GET_EVENTEXPOSE_AREA_WIDTH )
{
   GdkEventExpose * event = ( GdkEventExpose *) hb_parptr( 1 ) ;
   hb_retni(  event->area.width );
}

HB_FUNC( HB_GET_EVENTEXPOSE_AREA_HEIGHT )
{
   GdkEventExpose * event = ( GdkEventExpose *) hb_parptr( 1 ) ;
   hb_retni(  event->area.height);
}

HB_FUNC( HB_GET_GDKEVENT_TYPE )
{
  GdkEvent * event = ( GdkEvent * ) hb_parptr( 1 ) ;
  hb_retni( (gint) event->type );
}

HB_FUNC( HB_GET_GDKEVENT_BUTTON_BUTTON )
{
  GdkEvent * event = ( GdkEvent * ) hb_parptr( 1 ) ;
  hb_retni( (gint) event->button.button );
}

HB_FUNC( HB_GET_GDKEVENT_BUTTON_TIME )
{
  GdkEvent * event = ( GdkEvent * ) hb_parptr( 1 ) ;
  hb_retni( (gint) event->button.time );
}


/*
 *  Miembros de la structura GDKEVENTKEY 
 */
HB_FUNC( HB_GET_GDKEVENTKEY_TYPE )
{
  GdkEventKey * event = ( GdkEventKey * ) hb_parptr( 1 ) ;
  hb_retni( (gint) event->type);
}

HB_FUNC( HB_GET_GDKEVENTKEY_WINDOW )
{
  GdkEventKey * event = ( GdkEventKey * ) hb_parptr( 1 ) ;
  hb_retptr( (GdkWindow *) event->window );
}

HB_FUNC( HB_GET_GDKEVENTKEY_SEND_EVENT )
{
  GdkEventKey * event = ( GdkEventKey * ) hb_parptr( 1 ) ;
  hb_retni( (gint) event->send_event);
}

HB_FUNC( HB_GET_GDKEVENTKEY_TIME )
{
  GdkEventKey * event = ( GdkEventKey * ) hb_parptr( 1 ) ;
  hb_retni( (gint) event->time );
}

HB_FUNC( HB_GET_GDKEVENTKEY_STATE )
{
  GdkEventKey * event = ( GdkEventKey * ) hb_parptr( 1 ) ;
  hb_retni( (gint) event->state );
}

HB_FUNC( HB_GET_GDKEVENTKEY_KEYVAL )
{
  GdkEventKey * event = ( GdkEventKey * ) hb_parptr( 1 ) ;
  hb_retni( (gint) event->keyval );
}

HB_FUNC( HB_GET_GDKEVENTKEY_LENGTH )
{
  GdkEventKey * event = ( GdkEventKey * ) hb_parptr( 1 ) ;
  hb_retni( (gint) event->length );
}

HB_FUNC( HB_GET_GDKEVENTKEY_STRING )
{
  GdkEventKey * event = ( GdkEventKey * ) hb_parptr( 1 ) ;
  hb_retc( (gchar*) event->string );
}

HB_FUNC( HB_GET_GDKEVENTKEY_HARDWARE_KEYCODE )
{
  GdkEventKey * event = ( GdkEventKey * ) hb_parptr( 1 ) ;
  hb_retni( (gint) event->hardware_keycode );
}

HB_FUNC( HB_GET_GDKEVENTKEY_GROUP )
{
  GdkEventKey * event = ( GdkEventKey * ) hb_parptr( 1 ) ;
  hb_retni( (gint) event->group );
}

HB_FUNC( HB_GET_GDKEVENTBUTTON_X )
{
  GdkEvent * event = ( GdkEvent * ) hb_parptr( 1 ) ;
  hb_retni( (gint)((GdkEventButton*)event)->x );
}

HB_FUNC( HB_GET_GDKEVENTBUTTON_Y )
{
  GdkEvent * event = ( GdkEvent * ) hb_parptr( 1 ) ;
  hb_retni( (gint)((GdkEventButton*)event)->y );
}


