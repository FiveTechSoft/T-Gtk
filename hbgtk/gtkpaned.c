/* $Id: gtkpaned.c,v 1.1 2006-09-08 12:18:45 xthefull Exp $*/
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

#ifdef _GTK2_

HB_FUNC( GTK_HPANED_NEW ) //-->Widget
{
   GtkWidget * hpaned = gtk_hpaned_new();
   hb_retptr( ( GtkWidget * ) hpaned );
}

HB_FUNC( GTK_VPANED_NEW ) //-->Widget
{
   GtkWidget * vpaned = gtk_vpaned_new();
   hb_retptr( ( GtkWidget * ) vpaned );
}

//This is equivalent to gtk_paned_pack1 (paned, child, TRUE, TRUE);
//Esto es equivalente a gtk_paned_pack1 (paned, child, TRUE, TRUE);
HB_FUNC( GTK_PANED_ADD1 ) // paned, child
{
  GtkWidget * paned = GTK_WIDGET( hb_parptr( 1 ) );
  GtkWidget * child = GTK_WIDGET( hb_parptr( 2 ) );
  gtk_paned_add1( GTK_PANED( paned ), child ) ;
}

HB_FUNC( GTK_PANED_ADD2 ) // paned, child
{
  GtkWidget * paned = GTK_WIDGET( hb_parptr( 1 ) );
  GtkWidget * child = GTK_WIDGET( hb_parptr( 2 ) );
  gtk_paned_add2( GTK_PANED( paned ), child ) ;
}

HB_FUNC( GTK_PANED_PACK1 ) // paned, child, lResize, lshrink
{
  GtkWidget * paned = GTK_WIDGET( hb_parptr( 1 ) );
  GtkWidget * child = GTK_WIDGET( hb_parptr( 2 ) );
  gtk_paned_pack1( GTK_PANED( paned ), child , hb_parl( 3 ), hb_parl( 4 ) ) ;
}

HB_FUNC( GTK_PANED_PACK2 ) // paned, child, lResize, lshrink
{
  GtkWidget * paned = GTK_WIDGET( hb_parptr( 1 ) );
  GtkWidget * child = GTK_WIDGET( hb_parptr( 2 ) );
  gtk_paned_pack2( GTK_PANED( paned ), child , hb_parl( 3 ), hb_parl( 4 ) ) ;
}

HB_FUNC( GTK_PANED_SET_POSITION ) // paned, iPosition
{
  GtkWidget * paned = GTK_WIDGET( hb_parptr( 1 ) );
  gtk_paned_set_position( GTK_PANED( paned ), hb_parni( 2 ) );
}

HB_FUNC( GTK_PANED_GET_POSITION ) // paned --> iPosition
{
   GtkWidget * paned = GTK_WIDGET( hb_parptr( 1 ) );
   hb_parni( (gint) gtk_paned_get_position( GTK_PANED( paned ) ) );
}
/*TODO:
  gtk_paned_get_child1 ()
  gtk_paned_get_child2 ()
*/

#endif
