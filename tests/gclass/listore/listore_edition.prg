/* Primero implementacion de Modelo Vista en POO
  (c)2005 Rafa Carmona

  Ejemplo basado en el de ejemplo de GTK, excepto que activamos para mostrar el numero de BUG.

  Nota:
  Este ejemplo muestra como conectamos la se�al toggled, tanto a un GtkToggleButton,
  como a un GtkCellRendererToggle, y como esta ya solucionado el tema en los eventos
  de la se�al con el mismo nombre , pero el salto a la callback diferente.
 */

/*
 *  Algunos cambios incluidos para mejor manejo de columnas por Riztan Gutierrez
 *
 */

#include "gclass.ch"

#define GtkTreeIter  Array( 4 )

REQUEST HB_Lang_ES

//HB_SetCodePage("ESWIN")

Function Listore_Edition()

  local hWnd, oScroll, oTreeView, oWnd, x, n, aIter := GtkTreeIter, oLbx
  local oCol,oBox, oCol2, oRenderer, olabel
  local oCol3, oCol4, hselection, oCol1
  Local aLista := { "Barcelona", "Bigues i Riells", "Argentina", "Andorra", "Antequera", "Antes paleta, ahora busco caracoles" }


  local aItems := { { "SU PEDIDO Nº",0 ,0.0,0.0 },;
                    { SPACE(10),0 ,0.0,0.0 },;
                    { SPACE(10),0 ,0.0,0.0 },;
                    { SPACE(10),0 ,0.0,0.0 },;
                    { SPACE(10),0 ,0.0,0.0 },;
                    { SPACE(10),0 ,0.0,0.0 },;
                    { SPACE(10),0 ,0.0,0.0 },;
                    { SPACE(10),0 ,0.0,0.0 },;
                    { SPACE(10),0 ,0.0,0.0 },;
                    { SPACE(10),0 ,0.0,0.0 },;
                    { SPACE(10),0 ,0.0,0.0 },;
                    { SPACE(10),0 ,0.0,0.0 },;
                    { SPACE(10),0 ,0.0,0.0 },;
                    { SPACE(10),0 ,0.0,0.0 },;
                    { SPACE(10),0 ,0.0,0.0 },;
                    { SPACE(10),0 ,0.0,0.0 },;
                    { SPACE(10),0 ,0.0,0.0 },;
                    { SPACE(10),0 ,0.0,0.0 },;
                    { SPACE(10),0 ,0.0,0.0 } }


    /*Modelo de Datos */
    DEFINE LIST_STORE oLbx TYPES G_TYPE_STRING, G_TYPE_UINT, G_TYPE_DOUBLE, G_TYPE_DOUBLE
    HB_LangSelect("ES")
    For x := 1 To Len( aItems )
        APPEND LIST_STORE oLbx ITER aIter
        SET values LIST_STORE oLbx ITER aIter VALUES aItems[x]
    Next

   DEFINE WINDOW oWnd TITLE "Demo de edicion de un Treeview" SIZE 750,300

     oWnd:SetBorder( 8 )

     DEFINE BOX oBox VERTICAL OF oWnd  SPACING 8
       DEFINE LABEL oLabel TEXT "T-Gtk Power" OF oBox

       
       DEFINE SCROLLEDWINDOW oScroll  OF oBox EXPAND FILL ;
              SHADOW GTK_SHADOW_ETCHED_IN

              oScroll:SetPolicy( GTK_POLICY_NEVER, GTK_POLICY_AUTOMATIC )

       /* Browse/Tree */
       DEFINE TREEVIEW oTreeView MODEL oLbx OF oScroll CONTAINER
       
       oTreeView:SetRules( .T. )
       oTreeView:SetGridLines( GTK_TREE_VIEW_GRID_LINES_VERTICAL )  // TODO: Falta subir cambios a subversion

       DEFINE TREEVIEWCOLUMN oCol1  COLUMN 1 TITLE "Descripcion" TYPE "text"  WIDTH 350 OF oTreeView ;
               EDITABLE Edita_Celda( oSender, path, uVal, aIter, oLbx ,oTreeView,oCol1) EXPAND 
        
       // Montamos el autocompletado
       oCol1:oRenderer:OnEditing_Started := {|uParam, pCell, pEditable, cPath| text_editing_started( pCell, pEditable, cPath, aLista )  }
   

       
       DEFINE TREEVIEWCOLUMN oCol2 COLUMN 2 TITLE "Cantidad"  TYPE "text"  OF oTreeView;
               EDITABLE Edita_Celda( oSender, path, uVal, aIter, oLbx, oTreeView, oCol2 )
        
       gtk_tree_view_column_set_cell_data_func( oCol2:pWidget, oCol2:oRenderer:pWidget, "_CELLVALUE2_" )


       DEFINE TREEVIEWCOLUMN oCol3 COLUMN 3 TITLE "Precio"  TYPE "text" OF oTreeView;
               EDITABLE Edita_Celda( oSender, path, uVal, aIter, oLbx, oTreeView )

       gtk_tree_view_column_set_cell_data_func( oCol3:pWidget, oCol3:oRenderer:pWidget, "_CELLVALUE3_" )

       DEFINE TREEVIEWCOLUMN oCol4 COLUMN 4 TITLE "Importe" TYPE "text" OF oTreeView;
               EDITABLE Edita_Celda( oSender, path, uVal, aIter, oLbx, oTreeView )
       
       gtk_tree_view_column_set_cell_data_func( oCol4:pWidget, oCol4:oRenderer:pWidget, "_CELLVALUE4_" )

    
   ACTIVATE WINDOW oWnd CENTER

return NIL


STATIC FUNCTION Edita_Celda( oSender, cpath, uVal, aIter, oLbx, oTreeview, oCol )
 Local nColumn := oSender:nColumn + 1
 Local nPrecio , nCantidad, path
 Local nImporte, uValue, n := array( 4 )
 Local oNextCol,pPath


*  if !oTreeView:IsGetSelected( aIter )  // Si no pude seleccionar el camino a traves del Iter, intend
*    path := gtk_tree_path_new_from_string( cPath )
*    gtk_tree_model_get_iter( oTreeView:GetModel(), aIter, path )
*    Msginfo ( valtoprg( oTreeview:GetPath( aIter ) ) + " " + valtoprg( path )  )
* endif

  if oTreeView:IsGetSelected( aIter )  // Si no pude seleccionar el camino a traves del Iter, intend

    do case
         case nColumn = 1
         oLbx:Set( aIter, nColumn, uVal )
      
      case nColumn = 2                 // Cantidad
         nCantidad := val( uVal )
         nPrecio   := oTreeview:GetAutoValue(3) 
         oLbx:Set( aIter, 2, nCantidad )
         oLbx:Set( aIter, 4, nCantidad * nPrecio * 1.0  )

      case nColumn = 3                //Precio
         nPrecio   := val( uVal )
         nCantidad := oTreeview:GetAutoValue(2) 
         nImporte  := oTreeview:GetAutoValue(4) 
         oLbx:Set( aIter, 3, nPrecio * 1.0  )
         if !empty( nPrecio ) // Si hay precio , recalcula Importe, si no, se mantiene
            oLbx:Set( aIter, 4, nCantidad * nPrecio * 1.0 ) 
         endif
      
      case nColumn = 4                //Importe
         nImporte := val( uVal ) * 1.0 
         nPrecio  := 0 * 1.0 
         oLbx:Set( aIter, nColumn, nImporte )
         oLbx:Set( aIter, 3, nPrecio )       

    end case

    /* Pasamos a la siguiente columna y si es el final... bajamos la linea */
    if nColumn >= oTreeView:GetColumns() 
       oTreeView:GoNext()
       nColumn := 0 
    endif
    oTreeView:SetPosCol(aIter,nColumn)

  endif

RETURN NIL


/*
 Como pintar la columna 2
*/
function _CellValue2_( pTree_column, pCellRenderer, pTreeModel, aIter )

  Local pPath 
  Local uValue
  Local nColumn := 2

  pPath := gtk_tree_model_get_path( pTreeModel, aIter )  
  
  if !empty( pPath ) 
     hb_gtk_tree_model_get_int( pTreeModel, aIter, nColumn - 1, @uValue )
     if empty( uValue ) .or. uValue = 0
        g_object_set_string( pCellRenderer, "text", SPACE(5) )
     endif
  endif


return NIL

/*
 Como pintar la columna 3
*/
function _CellValue3_( pTree_column, pCellRenderer, pTreeModel, aIter )

  Local pPath 
  Local uValue
  Local nColumn := 3

  pPath := gtk_tree_model_get_path( pTreeModel, aIter )  
  
  if !empty( pPath ) 
     hb_gtk_tree_model_get_double( pTreeModel, aIter, nColumn - 1, @uValue )
     if empty( uValue ) .or. uValue = 0
        g_object_set_string( pCellRenderer, "text", SPACE(10) )
     else
       g_object_set_string( pCellRenderer, "text", transform( uValue, "999999.99" )  )
     endif
  endif


return NIL

/*
 Como pintar la columna 4
*/
function _CellValue4_( pTree_column, pCellRenderer, pTreeModel, aIter )

  Local pPath 
  Local uValue
  Local nColumn := 4

  pPath := gtk_tree_model_get_path( pTreeModel, aIter )  
  
  if !empty( pPath ) 
     hb_gtk_tree_model_get_double( pTreeModel, aIter, nColumn - 1, @uValue )
     if empty( uValue ) .or. uValue = 0
        g_object_set_string( pCellRenderer, "text", SPACE(10) )
     else
       g_object_set_string( pCellRenderer, "text", transform( uValue, "9999999.99" )  )
     endif
  endif


return NIL

/*function text_editing_started (GtkCellRenderer *cell, GtkCellEditable *editable,  const gchar     *path,  gpointer         data) */

function text_editing_started ( pCell, pEditable, path, aLista )
 Local oEntry

  if GTK_IS_ENTRY ( pEditable)
      oEntry := gEntry():Object_Empty()
      oEntry:pWidget := pEditable
      Create_Completion( aLista, oEntry )
  endif

return nil

/*
 Creamos un autocompletado a traves de un simple array
*/
function Create_Completion( aCompletion, oEntry ) 
    Local oLbx, x, n, oCompletion
    Local nLen := Len( aCompletion )

    /*Modelo de Datos */
    DEFINE LIST_STORE oLbx TYPES G_TYPE_STRING

    For x := 1 To nLen
        INSERT LIST_STORE oLbx ROW x VALUES aCompletion[ x ]
    Next

    oCompletion := gEntryCompletion():New( oEntry, oLbx, 1 )
    gtk_entry_set_completion (oEntry:pWidget, oCompletion:pWidget )

RETURN nil


