/* $Id: gtkbox.c,v 1.3 2010-12-24 01:06:17 dgarciagil Exp $*/
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


HB_FUNC( GTK_VBOX_NEW ) // bHomogeneus, iSpacing
{
   #if GTK_MAJOR_VERSION < 3
      GtkWidget * VBox = gtk_vbox_new( hb_parl( 1 ), hb_parni( 2 ) );
   #else
      gboolean homogeneous = hb_parl( 1 );
      GtkWidget * VBox = gtk_box_new( GTK_ORIENTATION_VERTICAL, hb_parni( 2 ) );
      gtk_box_set_homogeneous( ( GtkBox * ) VBox, homogeneous  );
   #endif
   g_message("gtk_vbox_new is deprecated!");
   hb_retptr( ( GtkWidget * ) VBox );
}

HB_FUNC( GTK_HBOX_NEW ) // bHomogeneus, iSpacing
{
   #if GTK_MAJOR_VERSION < 3
   GtkWidget * HBox = gtk_hbox_new( hb_parl( 1 ), hb_parni( 2 ) );
   #else
      gboolean homogeneous = hb_parl( 1 );
      GtkWidget * HBox = gtk_box_new( GTK_ORIENTATION_HORIZONTAL, hb_parni( 2 ) );
      gtk_box_set_homogeneous( ( GtkBox * ) HBox, homogeneous  );
   #endif
   g_message("gtk_hbox_new is deprecated!");
   hb_retptr( ( GtkWidget * ) HBox );
}

HB_FUNC( GTK_BOX_NEW )
{
   GtkWidget * Box = gtk_box_new( hb_parni( 1 ), hb_parni( 2 ) );
   hb_retptr( (GtkWidget * ) Box ) ;
}

HB_FUNC( GTK_BOX_PACK_START ) // box, child, lExpand, lFill, ipadding
{

  gtk_box_pack_start( GTK_BOX( GTK_WIDGET( hb_parptr( 1 ) ) ),
                      GTK_WIDGET( hb_parptr( 2 ) ),
                      hb_parl( 3 ), hb_parl( 4 ), hb_parl( 5 ) );
}

HB_FUNC( GTK_BOX_PACK_END ) // box, child, lExpand, lFill, ipadding
{

  gtk_box_pack_end( GTK_BOX( GTK_WIDGET( hb_parptr( 1 ) ) ),
                      GTK_WIDGET( hb_parptr( 2 ) ),
                      hb_parl( 3 ), hb_parl( 4 ), hb_parl( 5 ) );
}

//eof
