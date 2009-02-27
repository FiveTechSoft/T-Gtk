/* Primero implementacion de Modelo Vista en POO
  (c)2005 Rafa Carmona

  Ejemplo basado en el de ejemplo de GTK, excepto que activamos para mostrar el numero de BUG.
  
  Nota:
  Este ejemplo muestra como conectamos la señal toggled, tanto a un GtkToggleButton,
  como a un GtkCellRendererToggle, y como esta ya solucionado el tema en los eventos
  de la señal con el mismo nombre , pero el salto a la callback diferente.
 */
 
/* 
 *  Algunos cambios incluidos para mejor manejo de columnas por Riztan Gutierrez
 *
 */

#include "gclass.ch"

#define GtkTreeIter  Array( 4 )

Function Main()

  local hWnd, oScroll, oTreeView, oWnd, x, n, aIter := GtkTreeIter, oLbx
  local oCol,oBox
  local aItems := { { .F., 60482, "Normal",     "scrollable notebooks and hidden tabs" },;
                    { .F., 60620, "Critical",   "gdk_window_clear_area (gdkwindow-win32.c) is not thread-safe" },;
                    { .F., 50214, "Major",      "Xft support does not clean up correctly" },;
                    { .T., 52877, "Major",      "GtkFileSelection needs a refresh method. " },;
                    { .F., 56070, "Normal",     "Can't click button after setting in sensitive" },;
                    { .T., 56355, "Normal",     "GtkLabel - Not all changes propagate correctly" },;
                    { .F., 50055, "Normal",     "Rework width/height computations for TreeView" },;
                    { .F., 58278, "Normal",     "gtk_dialog_set_response_sensitive () doesn't work" },;
                    { .F., 55767, "Normal",     "Getters for all setters" },;
                    { .F., 56925, "Normal",     "Gtkcalender size" },;
                    { .F., 56221, "Normal",     "Selectable label needs right-click copy menu" },;
                    { .T., 50939, "Normal",     "Add shift clicking to GtkTextView" },;
                    { .F., 6112,  "Enhancement","netscape-like collapsable toolbars" },;
                    { .F., 1,     "Normal",     "First bug :=)" } }

    /*Modelo de Datos */
    DEFINE LIST_STORE oLbx TYPES G_TYPE_BOOLEAN, G_TYPE_UINT, G_TYPE_STRING, G_TYPE_STRING

    For x := 1 To Len( aItems )
        APPEND LIST_STORE oLbx ITER aIter
        for n := 1 to Len( aItems[ x ] )
            SET LIST_STORE oLbx ITER aIter POS n VALUE aItems[x,n]
        next
    Next
   
   DEFINE WINDOW oWnd TITLE "GtkListStore demo" SIZE 750,300
     
     oWnd:SetBorder( 8 )

     DEFINE BOX oBox VERTICAL OF oWnd  SPACING 8
       DEFINE LABEL TEXT "This is the bug list (note: not based on real data,"+;
                         " it would be nice to have a nice ODBC interface to bugzilla or so, though)."  OF oBox

       DEFINE SCROLLEDWINDOW oScroll  OF oBox EXPAND FILL ;
              SHADOW GTK_SHADOW_ETCHED_IN 
              
              oScroll:SetPolicy( GTK_POLICY_NEVER, GTK_POLICY_AUTOMATIC )
        
       /* Browse/Tree */
       DEFINE TREEVIEW oTreeView MODEL oLbx OF oScroll CONTAINER
       oTreeView:SetRules( .T. )            
       
       oTreeView:SetSearchColumn( 4 ) /*Determinamos por cual columna vamos a buscar */
       
       // Vamos a coger los valores de las columnas, se pasa path y col desde el evento
       oTreeView:bRow_Activated := { |path,col| Comprueba( oTreeview, path, col ) }
   

       DEFINE TREEVIEWCOLUMN oCol COLUMN 1 TITLE "Fixed?"  WIDTH 50 TYPE "active" OF oTreeView
       /* Indicamos la accion a ejecutar al click de la fila, de la columna Fixed? .*/
       oCol:oRenderer:bAction := {| o, cPath| fixed_toggled( o, cPath, oTreeview, oLbx  ) }

       DEFINE TREEVIEWCOLUMN COLUMN 2 TITLE "Bug Number"  TYPE "text"  SORT  OF oTreeView
       DEFINE TREEVIEWCOLUMN COLUMN 3 TITLE "Severity"    TYPE "text"  SORT  OF oTreeView
       DEFINE TREEVIEWCOLUMN COLUMN 4 TITLE "Description" TYPE "text"  SORT  OF oTreeView
       
   ACTIVATE WINDOW oWnd CENTER

return NIL

/* Ejemplo de como MODIFICAR un dato del modelo vista controlador. */
STATIC FUNCTION fixed_toggled( oCellRendererToggle, cPath, oTreeView, oLbx )
  Local aIter 
  Local path
  Local fixed
  Local nColumn := oCellRendererToggle:nColumn + 1
  
  path := gtk_tree_path_new_from_string( cPath )
  
  /* get toggled iter */
  fixed := oTreeView:GetValue( nColumn, "Boolean", Path, @aIter )

  // do something with the value 
  fixed := !fixed
   
   /* set new value */
  oLbx:Set( aIter, nColumn, fixed )
  
  /* clean up */
  gtk_tree_path_free( path )

Return .f.


// Una manera facil de obtener el valor de las columnas
// Easy get values from columns

Static Function Comprueba( oTreeView, pPath, pTreeViewColumn, oCol  )
    Local nBug, nColumn, cColumn, cTitle, cType

    cTitle  := gtk_tree_view_column_get_title( pTreeViewColumn )
    nColumn := oTreeView:GetPosCol( cTitle )
    cColumn := AllTrim( CStr(nColumn) )
    cType   := oTreeView:GetColumnTypeStr( nColumn )
    
//     u := o:GetValue( nColumn, cType_data, pPath )
//    nBug := oTreeview:GetValue( 2, "Int" , pPath )
    
    Msg2Info( "The Type of Col <b>"+cColumn+"</b> is: <b>"+ cType +"</b>"+CRLF+ ;
              "The Value is <b>"+ oTreeView:GetValue( nColumn, cType, pPath )+"</b>" )

Return nil

/*
Static Function Comprueba( oTreeView, pPath, pTreeViewColumn  )
    Local nBug
    
    // u := o:GetValue( nColumn, cType_data, pPath )
    nBug := oTreeview:GetValue( 2, "Int" , pPath )
    
    Msg2Info( "The number bug is: "+ cValtoChar( nBug ) )

Return nil
*/




Static Function Msg2Info( cText, cTitle )
  Local oBox, oWnd, oBoxH, oImage, oToggle
  DEFAULT cTitle := "Information", cText := "Information"

  DEFINE WINDOW oWnd TITLE cTitle TYPE_HINT GDK_WINDOW_TYPE_HINT_MENU
      oWnd:SetBorder( 5 )
      oWnd:SetSkipTaskBar( .T. ) // No queremos que salga en la barra de tareas

      DEFINE BOX oBox oF oWnd VERTICAL
         
         DEFINE BOX oBoxH OF oBox
           oBoxH:SetBorder( 20 )
           DEFINE IMAGE oImage FROM STOCK GTK_STOCK_DIALOG_INFO ;
                               SIZE_ICON GTK_ICON_SIZE_DIALOG OF oBoxH 
           DEFINE LABEL TEXT cText OF oBoxH MARKUP
         
           DEFINE BUTTON FROM STOCK GTK_STOCK_OK ACTION oWnd:End OF oBox 

            DEFINE TOGGLE oToggle TEXT "_Comnutador" ACTION g_print( "First Example" ) OF oBox 
            
            oToggle:DisConnect( "toggled" )
            oToggle:Connect( "toggled" )

            DEFINE TOGGLE oToggle TEXT "_Comnutador" ACTION g_print( "Two example" ) OF oBox 
            oToggle:DisConnect( "toggled" )
            g_signal_connect( oToggle:pWidget, "toggled", { ||g_print( "Dios, que vueltas!!" ) } )

  ACTIVATE WINDOW oWnd CENTER MODAL 

RETURN NIL

