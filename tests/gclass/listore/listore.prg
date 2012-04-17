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

Function Listore()

  local hWnd, oScroll, oTreeView, oWnd, x, n, aIter := GtkTreeIter, oLbx
  local oCol,oBox, oCol2, oRenderer, oLabelBug
  local oTreeview2, oScroll2, oLbx2

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
    HB_LangSelect("ES")
    For x := 1 To Len( aItems )
        APPEND LIST_STORE oLbx ITER aIter
        SET values LIST_STORE oLbx ITER aIter VALUES aItems[x]
    Next

   DEFINE WINDOW oWnd TITLE "GtkListStore demo" SIZE 750,300

     oWnd:SetBorder( 8 )

     DEFINE BOX oBox VERTICAL OF oWnd  SPACING 8
       DEFINE LABEL oLabelBug TEXT "This cLabelBug" OF oBox

       DEFINE LABEL TEXT "This is the bug list (note: not based on real data,"+;
                         " it would be nice to have a nice ODBC interface to bugzilla or so, though)."  OF oBox

       DEFINE SCROLLEDWINDOW oScroll  OF oBox EXPAND FILL ;
              SHADOW GTK_SHADOW_ETCHED_IN

              oScroll:SetPolicy( GTK_POLICY_NEVER, GTK_POLICY_AUTOMATIC )

       /* Browse/Tree */
       DEFINE TREEVIEW oTreeView MODEL oLbx OF oScroll CONTAINER

       //Activamos el efecto pijama. 
       //OJO. Solo si en el fichero gtkrc esta el valor: GtkTreeView::allow-rules = 1
       oTreeView:SetRules( .T. ) 

       //Activamos lineas del grid
       //oTreeView:EnableTreeLines( .T. )
       oTreeView:SetGridLines( GTK_TREE_VIEW_GRID_LINES_BOTH )

       oTreeView:SetSearchColumn( 4 ) /*Determinamos por cual columna vamos a buscar */

       // Vamos a coger los valores de las columnas, se pasa path y col desde el evento
       oTreeView:bRow_Activated := { |path,col| Comprueba( oTreeview, path, col, oLbx ) }

       // Vamos a controlar cada cambio del cursor

       oTreeView:Connect( "cursor-changed" )
       oTreeView:bCursorChanged := {|| oLabelBug:SetText( oTreeView:GetAutoValue( 4 ) ),;
                                       PonModelo( oTreeView2, oLabelBug:GetText() ) }


       DEFINE TREEVIEWCOLUMN oCol COLUMN 1 TITLE "Fixed?"  WIDTH 50 TYPE "active" OF oTreeView
       /* Indicamos la accion a ejecutar al click de la fila, de la columna Fixed? .*/
       oCol:oRenderer:bAction := {| o, cPath| fixed_toggled( o, cPath, oTreeview, oLbx  ) }

       /*Ejemplo de como usar la señal editing-started, la cual se dispara ANTES de editar el texto */
       DEFINE TREEVIEWCOLUMN oCol2 COLUMN 2 TITLE "Bug Number"  TYPE "text"  SORT  OF oTreeView
       oRenderer :=  oCol2:oRenderer           // Contiene el objeto de la clase GtkCellRendererText
       oRenderer:SetEditable( .t. )            // Va ser editable-
       oCol2:SetFunction("ChangeProperty")

       /*
       // Forma Manual
       oRenderer:Connect( "editing-started" )  // Conecta señal que indica que se va a disparar ANTES de editar.
       oRenderer:Connect( "editing-canceled" )  // Conecta señal que indica que se a cancelado con ESC       
       oRenderer:bOnEditing_Started := {|| MsgInfo("editing-started") }
       oRenderer:bOnEditing_Canceled := {|| MsgInfo("SE CANCELA!") }
       */
       
       //Forma Automatica
       //Los metodos callback son tipo SETGET, que asignaran el codeblock y conectaran la señal automaticamnete
       oRenderer:OnEditing_Started := {|| MsgInfo("editing-started") }
       oRenderer:OnEditing_Canceled := {|| MsgInfo("SE CANCELA!") }

       DEFINE TREEVIEWCOLUMN COLUMN 3 TITLE "Severity"    TYPE "text"  SORT  OF oTreeView
       DEFINE TREEVIEWCOLUMN COLUMN 4 TITLE "Description" TYPE "text"  SORT  OF oTreeView

      // Segundo Treeview va a mostrar un array 'dinamico'

        DEFINE SCROLLEDWINDOW oScroll2  OF oBox EXPAND ;
              SHADOW GTK_SHADOW_ETCHED_IN

              oScroll2:SetPolicy( GTK_POLICY_NEVER, GTK_POLICY_AUTOMATIC )

         DEFINE LIST_STORE oLbx2 TYPES G_TYPE_STRING
         DEFINE TREEVIEW oTreeView2 MODEL oLbx2 OF oScroll2 CONTAINER
         oTreeView2:SetRules( .T. )
         DEFINE TREEVIEWCOLUMN oCol COLUMN 1 TITLE "Columna"  WIDTH 50 TYPE "text" OF oTreeView2

     
   ACTIVATE WINDOW oWnd CENTER

return NIL

Function PonModelo( oTreeView, cValor )
   Local oLbx , aIter := GtkTreeIter, n,x

   DEFAULT cValor := ""

//   oTreeView:Clear()
   oTreeView:SetModel( )
   DEFINE LIST_STORE oLbx TYPES G_TYPE_STRING

   APPEND LIST_STORE oLbx ITER aIter
   SET LIST_STORE oLbx ITER aIter POS 1 VALUE cValor

   oTreeView:SetModel( oLbx )


return nil

// Funcion evaluada por cada celda
PROCEDURE ChangeProperty(pCol,pRenderer,pModel,aIter,user_data)

   // Estamos evaluando el valor de la columna 1
   if gtk_tree_model_get( @pModel, @aIter, 1, -1 ) 
      g_object_set_property(pRenderer, "background", "Blue")  
   else
      g_object_set_property(pRenderer, "foreground-set", .F.)  
      g_object_set_property(pRenderer, "background", "Red")  
    //g_object_set(renderer, "foreground-set", FALSE, NULL); /* print this normal */
     
   endif
RETURN 


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
  //fixed := !fixed
  // set new value //
  //oLbx:Set( aIter, nColumn, fixed )

  oTreeView:SetValue(nColumn, !fixed ,path,oLbx)

  /* clean up */
  gtk_tree_path_free( path )

Return .f.


static function CStr( uValue )
return cValtoChar( uValue )

// Una manera facil de obtener el valor de las columnas
// Easy get values from columns

Static Function Comprueba( oTreeView, pPath, pTreeViewColumn, oLbx  )
    Local nBug, nColumn, cColumn, cTitle, cType
    Local oModel

    cTitle  := gtk_tree_view_column_get_title( pTreeViewColumn )
    nColumn := oTreeView:GetPosCol( cTitle )
    cColumn := AllTrim( CStr(nColumn) )
    cType   := oTreeView:GetColumnTypeStr( nColumn )

//     u := oTreeView:GetValue( nColumn, "text", pPath )
//    nBug := oTreeview:GetValue( 2, "Int" , pPath )

    //oTreeView:SetValue(nColumn, "Cambiado!!",pPath,oLbx)

    Msg2Info( "The Type of Col <b>"+cColumn+"</b> is: <b>"+ cType +"</b>"+CRLF+ ;
              "The Value is <b>"+ CStr(oTreeView:GetValue( nColumn, cType, pPath ))+"</b>" )

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
            oToggle:Connect( "toggled22" )

            DEFINE TOGGLE oToggle TEXT "_Comnutador" ACTION g_print( "Two example" ) OF oBox 
            oToggle:DisConnect( "toggled" )
            g_signal_connect( oToggle:pWidget, "toggled", { ||g_print( "Dios, que vueltas!!" ) } )

  ACTIVATE WINDOW oWnd CENTER MODAL 

RETURN NIL

