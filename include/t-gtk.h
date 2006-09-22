/* $Id: t-gtk.h,v 1.1 2006-09-22 09:09:04 rosenwla Exp $*/

/*
 * t-gtk.h Fichero de definiciones de T-Gtk -------------------------------------
 * Porting Harbour to GTK+ power !
 * (C) 2004. Rafa Carmona -TheFull-
 * (C) 2004. Joaquim Ferrer
 */

typedef struct {
  const gchar *name;
  const gchar *method;
  GCallback   callback;
} TGtkActionParce;

typedef struct {
  const gchar *gtkname;
  const gchar *tgtkname;
} TGtkPreDfnParce;
