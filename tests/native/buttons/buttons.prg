/*
 * $Id: buttons.prg,v 1.2 2006-11-16 10:07:21 xthefull Exp $
 * Ejemplo de uso de buttons y su conexion a codeblocks.
 * Porting Harbour to GTK+ power !
 * (C) 2004-05. Rafa Carmona -TheFull-
 * (C) 2004-05. Joaquim Ferrer
 *
 */

#include "gtkapi.ch"
#define CRLF Hb_OsnewLine()

function exit( widget ) ;  gtk_main_quit()  ; return .f. 

function Salimos( widget , event )
    
  if MsgNoYes( UTF_8( "¿ Esta seguro de salir ?" ), "Atencion" )
    return .F.
  endif

return .T.
function main()

 local window, vbox
 local button1, button2, button3 , button4, image4, label4, box4
 local bBlock2, bBlock3
 local cVar := "hello !!"
 local accel, nId_Signal
 Local spinner
 
  window = gtk_window_new( GTK_WINDOW_TOPLEVEL )
  
  gtk_signal_connect( window, "delete-event", {|widget,event| Salimos( widget,event ) } )
  gtk_signal_connect( window, "destroy", {| widget | Exit( widget) } )
  
//  gtk_signal_connect( window, "add", {| container,widget | g_print( "Add Container..."+ str( widget ) +CRLF ) } )

  gtk_window_set_title ( window, "Test buttons & codeblocks" )
  gtk_container_set_border_width( window, 10 )
  
  vbox = gtk_vbox_new (.F., 0)
  gtk_container_add ( window, vbox )
  gtk_widget_show( vbox )
  
  button1 := gtk_button_new_with_label( "Ejecuta codeblock local. Press F3" )
  // Pasando codeblock directamente 

  gtk_signal_connect( button1, "CLICKED", { |widget| gtk_spinner_stop (spinner),paso( cVar, "ja", window, widget ) } )

  gtk_box_pack_start( vbox, button1, .F.,.T.,0 )
  gtk_widget_show( button1 )
  
  spinner := gtk_spinner_new ()
  gtk_spinner_start ( spinner )
  gtk_widget_show( spinner )
  gtk_box_pack_start( vbox, spinner, .F.,.T.,0 )
  

  // Vamos a poner un accelerador por codigo
  // Si presionamos F3 , se ejecutara la accion del boton.
  accel := gtk_accel_group_new() // Creamos el grupo de aceleradores
  gtk_window_add_accel_group( window, accel ) // Se lo asignamos a la ventana
  gtk_widget_add_accelerator( button1,;       // Por ultimo, hacemos la magia.
                              "clicked",;
                              accel,;
                              gdk_keyval_from_name( "F3" ) )

 
  button2 := gtk_button_new_with_label( "Codeblock a funcion estatica" )
  // Pasando codeblock referenciado en variable local 
  bBlock2 := {|w| my_static_fun( w, "Hello", nId_Signal ), .F. }
  nId_Signal := gtk_signal_connect( button2, "clicked", @bBlock2 )
  gtk_signal_connect( button2, "destroy", {|w|g_print("destruyendo.."+cvaltochar(w)+hb_osnewline() )} )
  gtk_box_pack_start( vbox, button2, .F.,.T.,0 )
  gtk_widget_show( button2 )
  g_print("Creacion de button2.."+cvaltochar(button2)+hb_osnewline()  )


  button3 := gtk_button_new_with_label( "Salir - Codeblock a funcion publica GTK+" )
  bBlock3 := {| | gtk_widget_destroy( window ) } //{|| g_signal_emit_by_name( window, "destroy" ) }
  gtk_signal_connect( button3, "clicked", bBlock3 ) 
  //gtk_signal_connect( button3, "clicked", {||exit()} ) 
  gtk_box_pack_start( vbox, button3, .F.,.T.,0 )
  gtk_widget_show( button3 )
  
  button4 := gtk_button_new( )
  box4 = gtk_hbox_new (.F., 0)
  gtk_container_add( button4, box4 )
  gtk_container_set_border_width( box4, 2)
  image4 = gtk_image_new_from_stock("gtk-index", GTK_ICON_SIZE_DIALOG)
  label4 = gtk_label_new ("Neu-Installation")
  gtk_box_pack_start (gtk_box (box4), image4, .T., .F., 3)
  gtk_box_pack_start (gtk_box (box4), label4, .T., .F., 3)
  gtk_signal_connect( button4, "clicked", { || MsgInfo("HOLA") })

  gtk_box_pack_start( vbox, button4, .F.,.T.,0 )

  gtk_widget_show_all (window)
  gtk_main()
  g_object_unref( accel )
return nil

/* Podemos ver como desconectamos la señal clicked del button, y
   volvemos a conectar la señal a otro codeblock. */
static func my_static_fun( widget, cVar, nId_Signal ) 
  cVar += "pepinillo :-)"
  msgalert( cVar ) 
  MsgStop( "Now, DISCONNECT THIS ACTION", "ATENTION" )
  hb_g_signal_handler_disconnect( widget , nId_signal, "clicked" );
  
  gtk_signal_connect( widget, "clicked", {||msginfo("Ahora estamos en otro." )} )

return( NIL )

static func paso( cVar, uVar, uwindow, widget )
  ? "ooooh", cVar, uVar, uwindow, widget 
return nil


