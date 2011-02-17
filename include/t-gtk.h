/* $Id: t-gtk.h,v 1.6 2010-06-04 09:56:04 xthefull Exp $*/

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
char * GetGErrorMsg( int iCode );

#ifdef __COMPATIBLE_HARBOUR__
   #define hb_storni   hb_storvni
   #define hb_stornl   hb_storvnl
   #define hb_storl    hb_storvl
   #define hb_storc    hb_storvc
   #define hb_parni    hb_parvni
   #define hb_parnl    hb_parvnl
   #define hb_storptr  hb_storvptr
   #define hb_parc     hb_parvc
   #define hb_parclen  hb_parvclen
   #define hb_stornd   hb_storvnd
#endif


void Safe_GFree( gchar * );
#define SAFE_RELEASE(x) Safe_GFree( x );

gchar * str2utf8( gchar * szString );
gchar * utf82str( gchar * szString );

#ifndef HB_SYMBOL_UNUSED
   #define HB_SYMBOL_UNUSED( symbol )  ( symbol := ( symbol ) )
#endif
