/* $Id: t-gtk.h,v 1.2 2006-10-03 10:34:42 xthefull Exp $*/

/*
 * t-gtk.h Fichero de definiciones de T-Gtk -------------------------------------
 * Porting Harbour to GTK+ power !
 * (C) 2004. Rafa Carmona -TheFull-
 * (C) 2004. Joaquim Ferrer
 */

typedef struct {
  gchar *name;
  gchar *method;
  GCallback   callback;
} TGtkActionParce;

typedef struct {
  gchar *gtkname;
  gchar *tgtkname;
} TGtkPreDfnParce;
