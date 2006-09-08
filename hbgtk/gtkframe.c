/* $Id: gtkframe.c,v 1.1 2006-09-08 12:18:45 xthefull Exp $*/
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

HB_FUNC( GTK_FRAME_NEW )
{
  GtkWidget * frame = gtk_frame_new( hb_parc( 1 ) );
  hb_retnl( (ULONG) frame);
}

HB_FUNC( GTK_FRAME_SET_LABEL ) // frame, cText
{
   GtkWidget * frame = ( GtkWidget * ) hb_parnl( 1 );
   gchar *text = hb_parc( 2 );
   gtk_frame_set_label( GTK_FRAME( frame ), text  );
}

HB_FUNC( GTK_FRAME_SET_LABEL_WIDGET ) //frame, widget_label
{
   GtkWidget * frame = ( GtkWidget * ) hb_parnl( 1 );
   GtkWidget * label = ( GtkWidget * ) hb_parnl( 2 );

   gtk_frame_set_label_widget( GTK_FRAME( frame ), label );
}

HB_FUNC( GTK_FRAME_GET_LABEL ) // frame->cText
{
   GtkWidget * frame = ( GtkWidget * ) hb_parnl( 1 );
   hb_retc( ( char * ) gtk_frame_get_label( GTK_FRAME( frame ) ) );
}

HB_FUNC( GTK_FRAME_SET_LABEL_ALIGN ) // frame, nPosX, nPosY
{
   GtkWidget * frame = ( GtkWidget * ) hb_parnl( 1 );

   gtk_frame_set_label_align( GTK_FRAME( frame ) ,
                             ( gfloat ) hb_parnd( 2 ),
                             ( gfloat ) hb_parnd( 3 ) );
}

HB_FUNC( GTK_FRAME_SET_SHADOW_TYPE ) // frame, nType
{
   GtkWidget * frame = ( GtkWidget * ) hb_parnl( 1 );
   GtkShadowType type = hb_parni( 2 );

   gtk_frame_set_shadow_type( GTK_FRAME( frame ), type );
}

