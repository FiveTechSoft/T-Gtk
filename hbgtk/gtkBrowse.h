/* $Id: gtkBrowse.h,v 1.1 2006-09-08 12:18:45 xthefull Exp $*/
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
    GtkBrowse.h - Widget browse para GTK+ GIMP Toolkit
    (c)2003 Joaquim Ferrer <quim_ferrer@yahoo.es>
*/
#ifndef __GTKBROWSE_H__
#define __GTKBROWSE_H__

#ifdef __cplusplus
  extern "C" {
#endif

#include <gtk/gtk.h>
#include "hbapi.h"

enum
{
  COL_TYPE_TEXT,
  COL_TYPE_CHECK,
  COL_TYPE_SHADOW,
  COL_TYPE_BOX,  
  COL_TYPE_RADIO,
  COL_TYPE_BITMAP
};

enum
{
  LINE_NONE,
  LINE_SOLID,
  LINE_DOTTED	
};	

#define GTK_BROWSE(obj)	         GTK_CHECK_CAST(obj, gtk_browse_get_type (), GtkBrowse)
#define GTK_BROWSE_CLASS(klass)  GTK_CHECK_CLASS_CAST(klass, gtk_browse_get_type (), GtkBrowseClass)
#define GTK_IS_BROWSE(obj)	 GTK_CHECK_TYPE(obj, gtk_browse_get_type ())

typedef struct _GtkBrowse	GtkBrowse;
typedef struct _GtkBrowseClass	GtkBrowseClass;

struct _GtkBrowse
{
  GtkWidget widget;
  PangoLayout *layout;
  GdkWindow *bin_window;
  GdkImage *screen;
  GdkCursor *resize_cursor;
  HB_ITEM item;
  GtkAdjustment *hadjustment;
  GtkAdjustment *vadjustment;
  gint ncols_visible;
};

struct _GtkBrowseClass
{
  GtkWidgetClass parent_class;
  void ( * set_scroll_adjustments ) ( GtkBrowse     * browse,
		 		      GtkAdjustment * hadjustment,
				      GtkAdjustment * vadjustment );
};

GtkType		gtk_browse_get_type  (void);
GtkWidget*	gtk_browse_new	     (PHB_ITEM pSelf);

#ifdef __cplusplus
  }
#endif

#endif /* __GTKBROWSE_H__ */
