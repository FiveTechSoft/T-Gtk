/*
 * $Id: test.prg,v 1.1 2006-10-31 11:43:58 xthefull Exp $
 * Experimentando con gObject :-)
 * Porting Harbour to GTK+ power !
 * (C) 2004-05. Rafa Carmona -TheFull-
 * (C) 2004-05. Joaquim Ferrer
 *
 * Notas by Quim:
 * Normalmente en la documentacion de GTK nos encotraremos con las
 * siguientes caracterisiticas:
 *
 Implemented Interfaces
 GtkLabel implements AtkImplementorIface.

 Properties

  "attributes"           PangoAttrList         : Read / Write
  "cursor-position"      gint                  : Read
  "ellipsize"            PangoEllipsizeMode    : Read / Write
  "justify"              GtkJustification      : Read / Write
  "label"                gchararray            : Read / Write
  "max-width-chars"      gint                  : Read / Write
  "mnemonic-keyval"      guint                 : Read
  "mnemonic-widget"      GtkWidget             : Read / Write
  "pattern"              gchararray            : Write
  "selectable"           gboolean              : Read / Write
  "selection-bound"      gint                  : Read
  "single-line-mode"     gboolean              : Read / Write
  "use-markup"           gboolean              : Read / Write
  "use-underline"        gboolean              : Read / Write
  "width-chars"          gint                  : Read / Write
  "wrap"                 gboolean              : Read / Write

 * Estas propiedades se asignan via funciones a la propia clase, p.e.
 * la propiedad "selectable" se maneja con gtk_label_set_selectable() o
 * gtk_label_get_selectable()
 * Una posibilidad muy interesante -y potente- es la de acceder directamente
 * al objeto pasando la propiedad a asignar/modificar. Esto lo conseguimos
 * con g_object_set( objeto, propiedad, valor ) o mediante un array de multiples
 * propiedades con g_object_setvalist( objeto, { propiedad, valor, ...} )
 * Otra ventaja indudable es la de no tener que recordar la sintaxis exacta
 * de la funcion que modifica/asigna un valor, siendo a traves de estas dos
 * funciones de g_object, una interfaz comun a todos los widgets.
 */

#include "gtkapi.ch"
static label 

function SetMarkup( check )
  g_object_set( label, "use-markup", ;
                !gtk_toggle_button_get_active( check ) )
return( .t. )

function main()
  
  local window, vbox, check, cTextLabel
  
   cTextLabel := '<span foreground="blue" size="large"><b>Esto es <span foreground="yellow" '+;
                 'size="xx-large" background="black" ><i>fabuloso</i></span></b>!!!!</span>'+;
                 HB_OSNEWLINE()+;
                 '<span foreground="red" size="23000"><b><i>T-Gtk power!!</i></b> </span>' +;
                 HB_OSNEWLINE()+;
                 'Usando un lenguaje de <b>marcas</b> para mostrar textos'
  
   window = gtk_window_new( GTK_WINDOW_TOPLEVEL )
   gtk_signal_connect( window, "destroy", {|| gtk_main_quit() } ) 
   gtk_window_set_title( window, "Test gObject. GtkLabel properties" )

   vbox = gtk_vbox_new (FALSE, 8)
   gtk_container_set_border_width (vbox, 8)
   gtk_container_add (window, vbox)
  
   label := gtk_label_new( "GtkLabel" )
   gtk_label_set_markup( label, cTextLabel )
   gtk_box_pack_start (vbox, label, FALSE, FALSE, 0)
  
   g_object_set( label, "selectable", TRUE )
   
   check := gtk_check_button_new_with_label( "Don't Markup" )
   gtk_box_pack_start( vbox, check, FALSE, TRUE, 0 )
   gtk_widget_show( check )
      
   gtk_signal_connect( check, "toggled", {|w| SetMarkup(w) } )
   
   gtk_widget_show_all (window)
   gtk_main()

return nil


