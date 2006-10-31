/*
 * $Id: glade.prg,v 1.1 2006-10-31 11:43:58 xthefull Exp $
 * Ejemplo de uso de control de widgets a traves de glade
 * Porting Harbour to GTK+ power !
 * (C) 2004-05. Rafa Carmona -TheFull-
 * (C) 2004-05. Joaquim Ferrer
*/

#include "gtkapi.ch"

func gtk_exit( widget ) ; gtk_main_quit() ; return( .f. )

function main( )
  local xml, window
  local item_new

/* Cargando interface */
   xml = glade_xml_new( "example.glade" )
   
/* Recuperando widget ventana a partir de su identificador */   
   window = glade_xml_get_widget( xml, "window1" )

/* Conectando salida controlada */
   gtk_signal_connect( window, "delete-event", {|w| Salida(w) } )  

/* Recuperando widget menu_item a partir de su identificador */   
   item_new = glade_xml_get_widget( xml, "new1" )

/* Conectando al menu_item una accion */  
   gtk_signal_connect( item_new, "activate", {|w| show_action(w)} )

/* start the event loop */
   gtk_main()

return 0

function Salida( widget )

   if ( MsgBox( "Quieres salir", GTK_MSGBOX_OK+GTK_MSGBOX_CANCEL,;
                GTK_MSGBOX_INFO ) == GTK_MSGBOX_OK )
      gtk_main_quit()
      return .f.  // Salimos y matamos la aplicacion.
   endif

return .t.

function show_action(widget)
 
 local name := "El identificador en archivo XML de este widget es : "
  name += glade_get_widget_name(widget) 
  msginfo( name )

return .t.
