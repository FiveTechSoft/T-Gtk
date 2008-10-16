/* $Id: t-gtk.h,v 1.4 2008-10-16 14:55:00 riztan Exp $*/

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


GtkWidget * get_win_parent(void);

