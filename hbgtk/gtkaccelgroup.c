/* $Id: gtkaccelgroup.c,v 1.1 2006-09-08 12:18:45 xthefull Exp $*/
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
/*
 * GtkAccelGroup. ----------------------------------------------------------------
 */
#include <gtk/gtk.h>
#include "hbapi.h"

HB_FUNC( GTK_ACCEL_GROUP_NEW )
{
  GtkAccelGroup *accel = gtk_accel_group_new();
  hb_retptr( (GtkAccelGroup *) accel );
}

HB_FUNC( GTK_ACCEL_GROUPS_ACTIVATE )
{
  GObject *widget = G_OBJECT( hb_parptr( 1 ) );
  guint accel_key = hb_parni( 2 );
  GdkModifierType mode = hb_parni( 3 );
  hb_retl( gtk_accel_groups_activate( widget, accel_key, mode ) );
}

HB_FUNC( GTK_ACCEL_GROUP_LOCK )
{
   GtkAccelGroup * accel_group = GTK_ACCEL_GROUP( hb_parptr( 1 ) );
  gtk_accel_group_lock( accel_group );
}

HB_FUNC( GTK_ACCEL_GROUP_UNLOCK )
{
  GtkAccelGroup * accel_group = GTK_ACCEL_GROUP( hb_parptr( 1 ) );
  gtk_accel_group_unlock( accel_group );
}

