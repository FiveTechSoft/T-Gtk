/*
 * $Id: trees.prg,v 1.1 2006-11-02 12:41:41 xthefull Exp $
 * Ejemplo de uso trees de la version < 2.4 considerados OBSOLETOS, pero soportados.
 * Porting Harbour to GTK+ power !
 * (C) 2004-05. Rafa Carmona -TheFull-
 * (C) 2004-05. Joaquim Ferrer
*/
#include "gtkapi.ch"

// GtkTreeViewMode;
#define  GTK_TREE_VIEW_LINE 0  /* default view mode */
#define  GTK_TREE_VIEW_ITEM 1


Function Main()

  local ventana, scrolled_win, arbol, subarbol, item, subItem, i, j
  Local itemnames := { "Foo", "Bar", "Baz", "Quux", "Maurice" }

/* Ventana */
   ventana := gtk_window_new( GTK_WINDOW_TOPLEVEL )
   Gtk_Signal_Connect( ventana, "delete-event", {|w|Salida(w)} )  // Cuando se mata la aplicacion

/* Scroll bar */
   scrolled_win = gtk_scrolled_window_new()
  gtk_scrolled_window_set_policy( scrolled_win, GTK_POLICY_AUTOMATIC, GTK_POLICY_AUTOMATIC)
  gtk_widget_set_usize (scrolled_win, 150, 200)
  gtk_container_add( ventana, scrolled_win )
  gtk_widget_show (scrolled_win)

  arbol = gtk_tree_new()

  /* A�adirlo a la ventana con barras de desplazamiento */
  gtk_widget_set_usize (arbol, 150, 200)

  /* Rafa :
   * Parece ser que el widget tree no posee capacidades 'nativas' para el 'scrolling'
   * por lo que hay que usar esto.
   */
  gtk_scrolled_window_add_with_viewport( scrolled_win, arbol )
  // del by Quim -->gtk_container_add( scrolled_win , arbol ) //

  /* Poner el modo de selecci�n */
  *gtk_tree_set_selection_mode( arbol, GTK_SELECTION_MULTIPLE )

  /* mostrar el �rbol */
  gtk_widget_show (arbol)


  for i := 1 TO 5
    /* Crear un elemento del �rbol */
   item = gtk_tree_item_new_with_label (itemnames[i])
    /* A�adirlo al �rbol padre */
    gtk_tree_append( GTK_TREE(arbol), item )
    /* Mostrarlo - esto se puede hacer en cualquier momento */
    gtk_widget_show (item)
    /* Crear el sub�rbol de este elemento */
    subarbol = gtk_tree_new()
    /* Esto no tiene absolutamente ning�n efecto, ya que se ignora
     * completamente en los sub�rboles */
    gtk_tree_set_selection_mode (GTK_TREE(subarbol), GTK_SELECTION_SINGLE)
    /* Esto tampoco hace nada, pero por una raz�n diferente - los
     * valores view_mode y view_line de un �rbol se propagan a los
     * sub�rboles cuando son mapeados. Por tanto, establecer los
     * valores despu�s actualmente tendr�a (alg�n impredecible) efecto
     */
    gtk_tree_set_view_mode (GTK_TREE(subarbol), GTK_TREE_VIEW_ITEM )
    /* Establecer este sub�rbol del elemento - �Recuerde que no puede
     * hacerlo hasta que se haya a�adido a su �rbol padre! */
    gtk_tree_item_set_subtree ( GTK_TREE_ITEM(item), subarbol)

   FOR  j := 1 TO 5

      /* Crea un elemento sub�rbol, m�s o menos lo mismo de antes */
      subitem = gtk_tree_item_new_with_label (itemnames[j] )
      /* A�adirlo a su �rbol padre */
      gtk_tree_append (GTK_TREE(subarbol), subitem)
      /* Mostrarlo */
      gtk_widget_show (subitem)
    NEXT
  NEXT
  /* Mostrar la ventana y entrar en el bucle final */
  gtk_widget_show (ventana)
  gtk_main()

return NIL

//--------------------------------------------------------------------------//
//Salida controlada del programa.
Function Salida( widget )
         gtk_main_quit()
Return .F.  // Salimos y matamos la aplicacion.


