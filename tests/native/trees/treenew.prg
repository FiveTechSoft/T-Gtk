/*
 * Ejemplo de uso trees mediante GtkTreeView y GtkTreeStore
 * Porting Harbour to GTK+ power !
 * (C) 2004-05. Rafa Carmona -TheFull-
 * (C) 2004-05. Joaquim Ferrer
 *
 * NOTA by Quim. Me he basado en el ejemplo en C que viene con
 * gtk-demo, salvando las logicas diferencias entre ambos
 * lenguajes ( macros, punteros y estructuras ), para que veais
 * la 'compatibilidad' entre C y [x]Harbour conseguida.
 */

#include "gtkapi.ch"

#define  GtkTreeIter  array( 4 )

function main()

  local window
  local vbox
  local sw
  local treeview
  local model

  /* create window, etc */
  window = gtk_window_new (GTK_WINDOW_TOPLEVEL)
  gtk_signal_connect (window, "delete-event", {|| Exit() } )

  vbox = gtk_vbox_new (.F., 8)
  gtk_container_set_border_width (vbox, 8)
  gtk_container_add (window, vbox)
  gtk_box_pack_start (vbox, ;
		      gtk_label_new ("Planning Calendar"),;
		      .F., .F., 0)

  /* Scroll bar */
  sw = gtk_scrolled_window_new()
  gtk_scrolled_window_set_shadow_type (sw, GTK_SHADOW_ETCHED_IN)
  gtk_scrolled_window_set_policy( sw, GTK_POLICY_AUTOMATIC, ;
                                      GTK_POLICY_AUTOMATIC)
  gtk_box_pack_start (vbox, sw, .T., .T., 0)

  /* create model */
  model = create_model ()

  /* create tree view */
  treeview = gtk_tree_view_new_with_model (model)
  g_object_unref (model)
  gtk_tree_view_set_rules_hint (treeview)

  /* asignando propiedad 'reordenable'
   * con doble-click en cualquier fila, arrastrar
   * y soltar en nueva posicion :-)
   */
  g_object_set (treeview, "reorderable", .T.)

  /* create columns */
  add_columns (treeview)

  /* Activate */
  gtk_container_add (sw, treeview)
  gtk_window_set_title( window, ;
                        "Tree (c)2005 Rafa Carmona & Quim Ferrer team" )
  gtk_window_set_default_size (window, 500, 350)

  gtk_signal_connect (treeview, "realize",{|w| tree_expand_all( w )} )

  gtk_widget_show_all (window)
  gtk_main()

return NIL

//--------------------------------------------------------------------------//

#define NUM_COLUMNS  2
static func create_model ()

  local model
  local aParent, aChild
  local nMonth, nDay
  local nToday  := 0
  local aDays   := { "Lunes", "Martes", "Miercoles", "Jueves", ;
                     "Viernes", "Sabado", "Domingo" }
  local aMonths := { "Ene", "Feb", "Mar", "Abr", "May", "Jun", ;
                     "Jul", "Ago", "Sep", "Oct", "Nov", "Dic" }

  /* create tree store */
  model = gtk_tree_store_newv (NUM_COLUMNS, ;
                               { G_TYPE_STRING, G_TYPE_BOOLEAN })
  aParent := GtkTreeIter
  aChild  := GtkTreeIter

  for nMonth := 1 to len( aMonths )
      gtk_tree_store_append( model, aParent )
      gtk_tree_store_set( model, 0, aParent, aMonths[nMonth] )

      for nDay := 1 to 30
          if nToday == 7
             gtk_tree_store_set( model, 1, aParent, .T. )
             nToday  = 1
          else
             nToday += 1
          endif
          gtk_tree_store_append( model, aChild, aParent )
          gtk_tree_store_set( model, 0, aChild, aDays[nToday] + " " +;
                              str(nDay,2) + " de " + aMonths[nMonth]+;
                              " de 2.005" )
          if aDays[nToday] == "Sabado" .OR. aDays[nToday] == "Domingo"
             gtk_tree_store_set( model, 1, aChild, .T. )
          endif

      next
  next

return (model)

//--------------------------------------------------------------------------//

static func add_columns (treeview)

  local col_offset
  local renderer
  local column
  local model := gtk_tree_view_get_model (treeview)

  /* column with attributes */
  renderer = gtk_cell_renderer_text_new ()
  col_offset = gtk_tree_view_insert_column_with_attributes (treeview,;
							    -1, "Holiday", ;
							    renderer, "text", 0 )

  column = gtk_tree_view_get_column (treeview, col_offset - 1)
  gtk_tree_view_column_set_clickable (column, .T.)

/* Asignando una propiedad directamente al objeto */
  g_object_set (column, "resizable", .T.)

/* Columna tipo 'checkbox' */
   renderer = gtk_cell_renderer_toggle_new()
   column   = gtk_tree_view_column_new_with_attributes( "Check", renderer, { "active", 1 } )
/*
 * Ejemplo de implementación de múltiples propiedades al
 * estilo va_list de C, 'simulando' con un array que toma
 * el par _propiedad-valor_.
 */
   g_object_set_valist (renderer, {"cell-background", "Orange", ;
                                   "cell-background-set", .t. } )

   gtk_tree_view_append_column( treeview, column )

return( 0 )

//--------------------------------------------------------------------------//

/* Señales */

func tree_expand_all( treeview )
  gtk_tree_view_expand_all( treeview )
return( .t. )

func exit( widget ) ;  gtk_main_quit() ; return( .f. )

//--------------------------------------------------------------------------//


