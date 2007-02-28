/* $Id: t-gtk.h,v 1.3 2007-02-28 21:38:21 xthefull Exp $*/

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
  const gchar *gtkclassname;
} TGtkActionParce;

typedef struct {
  gchar *signalname;
} TGtkPreDfnParce;
