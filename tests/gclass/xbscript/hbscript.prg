/*
 * $Id: hbscript.prg,v 1.1 2010-12-27 04:16:28 riztan Exp $
 * GUI T-Gtk para Harbour
 * Uso de scripts.
 * (c)2010 Riztan Gutierrez
 * Demo en script
 */

#include "gclass.ch"
//#include "tgtkext.ch"

FUNCTION MAIN( cFile, ... )


REQUEST MSG_INFO
REQUEST GTREEVIEW
REQUEST GSTATUSBAR
REQUEST GTOOLTIP
REQUEST GTOGGLEBUTTON
REQUEST GENTRY
REQUEST GSPINBUTTON
REQUEST GCHECKBOX
REQUEST GTK_CALENDAR_GET_DATE
REQUEST MSG_INFO
REQUEST MSGBOX
REQUEST GMENUBAR
REQUEST GMENU
REQUEST GMENUITEM
REQUEST GMENUTEAROFF
REQUEST GMENUSEPARATOR
REQUEST GMENUITEMCHECK
REQUEST GMENUITEMIMAGE
REQUEST XHB_LIB

RUNXBS( "hola.prg","1" ) 

return nil

