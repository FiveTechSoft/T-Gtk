/*
 * $Id: brweditable.prg,v 1.1 2006-10-04 08:36:29 xthefull Exp $
 * Example T-Gtk 
  Una colaboracion desde Carlos Mora.
 */
//#include "gtkapi.ch"
#include "gclass.ch"

#define DBF_FIELD  1

Static hTree

REQUEST HB_CODEPAGE_ESISO

function Main( )
   local oWnd
   local oBox
   local aArray := {}
   local n, j
   local oMenu, oItem, oMainMenu, oBoxV
  
   HB_CDPSELECT( "ESISO" )
   
   define window oWnd title "DBF Browse test" size 640, 480

   define box oBoxV vertical of oWnd   
   
   define barmenu oMainMenu of oBoxV
   
   menubar oMenu of oMainMenu
   
      menuitem root oItem title "Browse" of oMenu

      menuitem oItem title "Dbf" ;
               action ppp( oWnd );
               of oMenu 
   oMenu:Activate()
   
   activate window oWnd center
   

RETURN NIL

function ppp()

  local hWnd, hScroll, hList, hRenderer, hColumn, hItem, hSelection
  local aFields := {}
  local aStruct := {}
  local n, nLen

	Set Excl Off
   USE ../../CUSTOMER.DBF NEW SHARED 
   aStruct := dbstruct()
   aeval( aStruct, {|a| aadd( aFields, a[DBF_FIELD] ) } )
   nLen := len( aFields )

/* Ventana */
   hWnd := gtk_window_new( GTK_WINDOW_TOPLEVEL )

/* Scroll bar */
   hScroll = gtk_scrolled_window_new()
   gtk_widget_show ( hScroll )
   gtk_container_add( hWnd, hScroll )

/* Modelo de datos */
	hList := ListStore4Dbf()

/* Browse/Tree */
   hTree      := gtk_tree_view_new_with_model( hList )

   hSelection := gtk_tree_view_get_selection( hTree )
   gtk_tree_selection_set_mode( hSelection, GTK_SELECTION_BROWSE ) // siempre hay una fila seleccionada

   gtk_container_add( hScroll, hTree )

   gtk_signal_connect( hTree, "cursor-changed", {|pTree| Status( pTree ) } )
   gtk_signal_connect( hTree, "key-press-event", {|pTree, pEventKey| keypress( pTree, pEventKey ) } )

/* Method AddColumns */
   for n:= 1 to nLen
       hRenderer = gtk_cell_renderer_text_new()
       gtk_signal_connect( hRenderer, "edited", {|hRenderer, cPath, cNewText| EDITACELDA( hRenderer, cPath, cNewText) } )  // Nueva señal soportada, "edited"
      /* Esto es lo mismo que lo de arriba, desactiva para comprobar que funciona */
      // gtk_cell_renderer_connect_edited( hRenderer, "EDITACELDA" )
      g_object_set_data( hRenderer, "column", n-1 )
      hColumn   = gtk_tree_view_column_new_with_attributes( aFields[n], hRenderer, { "text", 0 } )
      g_object_set_bool( hRenderer, "editable", .T. )
      gtk_tree_view_append_column( hTree, hColumn )
      gtk_tree_view_column_set_cell_data_func( hColumn, hRenderer, "CELLVALUE" )
   next

/* Method Activate */
   gtk_window_set_title( hWnd, "Test Browse DBF Gtk for Harbour" )
   gtk_window_set_position( hWnd, GTK_WIN_POS_CENTER )
   gtk_window_set_default_size( hWnd, 600, 400 )
   gtk_signal_connect ( hWnd, "destroy", {|| Salir() } )
   gtk_widget_show_all( hWnd )

  // gtk_Main()

return NIL

//--------------------------------------------------------------------------//

function EditaCelda( hRenderer, cPath, cNewText )
  Local hList, hIter, nColumn, uCurrent, uType, nField, nRecNo

  hList := gtk_tree_view_get_model( hTree )

  hIter := gtk_tree_model_get_iter_from_path( hList, cPath )
   nColumn:= g_object_get_data( hRenderer, "column" )

	// obviamente...
	nField := nColumn + 1

	If Recno() != ( nRecNo := gtk_tree_model_get_long( hList, hIter ) )
		dBGoto( nRecNo )
	EndIf

	uCurrent:= FieldGet( nField )
	uType := ValType( uCurrent )

	RLock()
	Do Case
	Case uType == 'C'
		FieldPut( nField, cNewText )
	Case uType == 'N'
		FieldPut( nField, Val( cNewText ) )
	Case uType == 'D'
		FieldPut( nField, CtoD( cNewText ) )
	Case uType == 'L'
		FieldPut( nField, Upper( Left( cNewText, 1 ) ) $ 'YTS' )
	EndCase
	dBUnLock()


Return TRUE

function CellValue( hTree, hRenderer, hList, hIter )
/*
GtkTreeViewColumn *tree_column, GtkCellRenderer *cell, GtkTreeModel *tree_model,
                                             GtkTreeIter *iter, gpointer data
*/
Local nField, nRecNo, nColumn, uValue
  If Recno() != ( nRecNo := gtk_tree_model_get_long( hList, hIter ) )
     dBGoto( nRecNo )
  endIf

  nColumn:= g_object_get_data( hRenderer, "column" )
  nField := nColumn + 1

  // ? nRecNo, RecNo(), nColumn, nField, '*' + Transform( FieldGet( nColumn+1), NIL ) +'*'
  
  uValue =  Utf82Str( Transform( FieldGet( nColumn + 1 ), NIL ) )
  // uValue:=
  g_object_set_string( hRenderer, "text", uValue )  

return NIL


//--------------------------------------------------------------------------//

function Status( hTree )
  local hSelection, hColumn, hMode

  hSelection := gtk_tree_view_get_selection( hTree )
  hColumn    := gtk_tree_view_get_column( hTree, 1 )
  hMode      := gtk_tree_selection_get_mode( hSelection )
  gtk_tree_view_column_set_title( hColumn, str( hMode, 4 ) )

return .t.

//--------------------------------------------------------------------------//
/* Probando que venga correctamente GdkEventKey*/
function keypress( pTree, pEventKey )
  Local nKey  :=  HB_GET_GDKEVENTKEY_KEYVAL( pEventKey ) 
  Local nType   // aGdkEventKey[ 1 ]
/*
    do case
     case nKey == GDK_UP // VK_UP
           ? "fecha arriba"
     case nKey == GDK_DOWN // VK_DOWN
          ? "fecha abajo"
     case nKey == GDK_LEFT // VK_LEFT
         ? "fecha izquierda"
     case nKey == GDK_RIGHT // VK_RIGHT
           ? "fecha derecha"
  endcase
*/
return FALSE

//--------------------------------------------------------------------------//

Function Salir()
   ( Alias() )->( dbclosearea() )
//         gtk_main_quit()
return .F.

//--------------------------------------------------------------------------//

Function ListStore4Dbf( cArea )
  Local hList, i, n
  Local aIter := Array( 4 ) // GtkTreeIter lo vamos a gestionar como un simple array ;-)

  hList := gtk_list_store_newv( 1, { G_TYPE_LONG } )
  // hList = gtk_list_store_new() // Solo los RecNo's como long

  // ? GTK_LIST_STORE_GET_COL_TYPE( hList, 0 ), gtk_type_long()
	n:= LastRec() // OrdKeyCount()

  for i:= 1 To n
     gtk_list_store_append( hList, aIter )
     hb_gtk_list_store_set_long(  hList, 0, aIter, i ) // Metemos LONG directamente
  next

Return hList
