/*
 * $Id: list.prg,v 1.1 2006-10-31 11:50:23 xthefull Exp $
 * Ejemplo de soporte parcial clist, version < 2.4, OBSOLETO pero soportado.
 * Porting Harbour to GTK+ power !
 * (C) 2004-05. Rafa Carmona -TheFull-
 * (C) 2004-05. Joaquim Ferrer
*/
#include "gtkapi.ch"

Function Main()

  local hWnd, hScroll, hTree, hColumn

/* Ventana */
  hWnd := gtk_window_new( GTK_WINDOW_TOPLEVEL )
  Gtk_Signal_Connect( hWnd, "destroy", {||gtk_main_quit() } )  // Cuando se mata la aplicacion

/* Scroll bar */
  hScroll = gtk_scrolled_window_new()
  gtk_widget_show ( hScroll )
  gtk_container_add( hWnd, hScroll )

  hTree = gtk_clist_new_with_titles()
  gtk_widget_show( hTree )
  gtk_clist_append( hTree )
  gtk_container_add( hScroll, hTree )

/* Method Activate */
  gtk_window_set_title( hWnd, "Test Gtk for Harbour" )
  gtk_window_set_position( hWnd, GTK_WIN_POS_CENTER )
  gtk_window_set_default_size( hWnd, 280, 250 )
  gtk_widget_show( hWnd )

  gtk_Main()

return NIL
//--------------------------------------------------------------------------//
//-!!!! OBSOLETA PARA LA 2.4 !!!!!!!!!!!!!!!!!!!!!!!------------------------//
//--------------------------------------------------------------------------//

#pragma BEGINDUMP

 #include <gtk/gtk.h>
 #include <windows.h>
 #include "hbapi.h"
 #include "hbvm.h"

HB_FUNC( GTK_CLIST_NEW_WITH_TITLES )
{
  gchar *szTitles[] = { "uno", "dos", "tres" };
  GtkWidget * clist = gtk_clist_new_with_titles( 3, szTitles );
  hb_retnl( (ULONG) clist );
}

HB_FUNC( GTK_CLIST_APPEND )
{
  gchar *szData[] = { "uno", "dos", "tres" };
  gtk_clist_append( GTK_CLIST (( GtkWidget * ) hb_parnl( 1 )), szData );
}

#pragma ENDDUMP
