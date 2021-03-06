#/* $Id: gtktreesortable.c,v 1.1 2007-05-09 09:42:04 xthefull Exp $*/
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
   (c)2007 Federico de Maussion
*/
#include <gtk/gtk.h>
#include "hbapi.h"

/* Note from Rafa Carmona
   Well, in C, is 0 or 1, in Harbour, .F. = GTK_SORT_ASCENDING , .T. = GTK_SORT_DESCENDING */
HB_FUNC( GTK_TREE_SORTABLE_GET_SORT_COLUMN_ID )
{
  GtkTreeModel * model = GTK_TREE_MODEL( hb_parptr( 1 ) );
  gint sort_id;
  GtkSortType sort_type;

  hb_retl( gtk_tree_sortable_get_sort_column_id( GTK_TREE_SORTABLE(model), &sort_id, &sort_type ) );

  hb_storni( sort_id,  2 );
  hb_storl( sort_type, 3 );  
}
