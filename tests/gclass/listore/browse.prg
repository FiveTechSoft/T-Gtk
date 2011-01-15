* Primero implementacion de Modelo Vista en POO
#include "gclass.ch"

#define GtkTreeIter  Array( 4 )

Function Main()

  local hWnd, oScroll, oTreeView, oWnd, x, n, aIter := GtkTreeIter, oLbx
  local pixbuf, pixbuf2, pixbuf3, pixbuf4, oCol, oBox, oBox2
  local aItems := { { "","uno",    "manual", "aristoteles", 1234.324, .t., 1  },;
                    { "","dos",    "manual", "red",         5678.324, .t., 2  },;
                    { "","tres",   "manual", "onasis",      9012.324, .f., 3  },;
                    { "","cuatro", "manual", "euripides",   3456.324, .t., 4  },;
                    { "","dos",    "manual", "euclicides",  5678.324, .f., 5  },;
                    { "","tres",   "manual", "onasis",      9012.324, .t., 6  },;
                    { "","uno",    "manual", "euclicides",  5678.324, .f., 7  },;
                    { "","tres",   "manual", "onasis",      9012.324, .t., 8  },;
                    { "","cuatro", "manual", "euripides",   3456.124, .t., 9  },;
                    { "","dos",    "Auto  ", "euclicides",  5678.324, .t., 10 },;
                    { "","tres",   "manual", "onasis",      9012.424, .f., 11 },;
                    { "","dos",    "manual", "euclicides",  5678.367, .t., 12 },;
                    { "","tres",   "manual", "onasis",      9012.324, .f., 13 },;
                    { "","cuatro", "manual", "euripides",   3456.324, .f., 14 },;
                    { "","dos",    "manual", "euclicides",  5678.324, .t., 15 },;
                    { "","Penun",   "manual", "onasis",     9012.324, .f., 16 },;
                    { "","ultima", "anual", "euripides",    3456.324, .t., 17 } }

   SET DECIMALS TO 3

   DEFINE WINDOW oWnd TITLE "Model POO" SIZE 600,400
      DEFINE BOX oBox VERTICAL OF oWnd
      
      DEFINE BOX oBox2 OF oBox HOMO
         DEFINE BUTTON TEXT "_APPEND ROW" EXPAND FILL OF oBox2  MNEMONIC;
                ACTION ( APPEND_LIST( oLbx ), oTreeView:SetFocus() )
         
         DEFINE BUTTON TEXT "_INSERT ROW" EXPAND FILL OF oBox2  MNEMONIC;
                ACTION ( INSERT_LIST( oLbx ), oTreeView:SetFocus() )

         DEFINE BUTTON TEXT "_MODIFY ROW" EXPAND FILL OF oBox2  MNEMONIC;
                ACTION ( Actua( oTreeView, oLbx, .F. ), oTreeView:SetFocus() )
        
         DEFINE BUTTON TEXT "_DELETE ROW" EXPAND FILL  OF oBox2 MNEMONIC;
                ACTION ( Actua( oTreeView, oLbx, .T. ), oTreeView:SetFocus() )

      DEFINE SCROLLEDWINDOW oScroll  OF oBox EXPAND FILL //Wnd CONTAINER
       /*Modelo de Datos */
      DEFINE LIST_STORE oLbx TYPES GDK_TYPE_PIXBUF,  G_TYPE_STRING, G_TYPE_STRING,;
                                   G_TYPE_STRING, G_TYPE_DOUBLE, G_TYPE_BOOLEAN, G_TYPE_INT

      pixbuf := gdk_pixbuf_new_from_file( "../../images/glade.png" )
      pixbuf2 := gdk_pixbuf_new_from_file( "../../images/anieyes.gif" )
      pixbuf3 := gdk_pixbuf_new_from_file( "../../images/gnome-logo.png" )
      pixbuf4 := gdk_pixbuf_new_from_file( "../../images/rafa.jpg" )

      For x := 1 To Len( aItems )
          APPEND LIST_STORE oLbx ITER aIter
          for n := 1 to Len( aItems[ x ] )
              DO CASE
                 CASE n == 1
                      if aItems[x,2] == "uno"
                         SET LIST_STORE oLbx ITER aIter POS n VALUE pixbuf
                      elseif aItems[x,2] == "dos"
                         SET LIST_STORE oLbx ITER aIter POS n VALUE pixbuf2
                      elseif aItems[x,2] == "tres"
                         SET LIST_STORE oLbx ITER aIter POS n VALUE pixbuf3
                      endif
                 OTHERWISE
                      SET LIST_STORE oLbx ITER aIter POS n VALUE aItems[x,n]
              END CASE
          next
      Next

     #ifdef __IGUAL__
       INSERT LIST_STORE oLbx ROW 2 ITER aIter
       SET LIST_STORE oLbx ITER aIter POS 1 VALUE pixbuf4 
       SET LIST_STORE oLbx ITER aIter POS 2 VALUE "Fila"  
       SET LIST_STORE oLbx ITER aIter POS 3 VALUE "INSERTADA" 
       SET LIST_STORE oLbx ITER aIter POS 4 VALUE "Manualmente" 
       SET LIST_STORE oLbx ITER aIter POS 5 VALUE 0123.23 
       SET LIST_STORE oLbx ITER aIter POS 6 VALUE .T. 
       SET LIST_STORE oLbx ITER aIter POS 7 VALUE 99
     #else
       INSERT LIST_STORE oLbx ROW 2 VALUES pixbuf4 ,;
                                           "Fila",;  
                                           "INSERTADA",; 
                                           "Manualmente",;
                                           0123.23,; 
                                           .T., 100
     #endif
   
     gdk_pixbuf_unref( pixbuf )
     gdk_pixbuf_unref( pixbuf2 )
     gdk_pixbuf_unref( pixbuf3 )
     gdk_pixbuf_unref( pixbuf4 )

     /* Browse/Tree */
     DEFINE TREEVIEW oTreeView MODEL oLbx OF oScroll CONTAINER
     oTreeView:SetRules( .T. )            
   
     // Vamos a coger los valores de las columnas, se pasa path y col desde el evento
     oTreeView:bRow_Activated := { |path,col| Comprueba( oTreeview, path, col ) }

     DEFINE TREEVIEWCOLUMN COLUMN 1 TITLE "Bitmap"      TYPE "pixbuf" OF oTreeView
     DEFINE TREEVIEWCOLUMN COLUMN 2 TITLE "Paso a Paso" TYPE "text"   OF oTreeView

     /*Columna 'resizable' y 'width' y ademas EDITABLE! */
     DEFINE TREEVIEWCOLUMN oCol COLUMN 3 ;
            TITLE "Esta" ;
            TYPE "text";
            WIDTH 100;
            OF oTreeView ;
            EDITABLE Edita_Celda( oSender, oLbx, uVal, aIter )
            
     oCol:SetResizable( .T. )
     /*
     oCol:oRenderer:SetEditable( .T. )
     oCol:oRenderer:Connect( "edited" )
     oCol:oRenderer:bEdited := {| oSender, path, text| Edita_Celda( oTreeView, oLbx, path, text )}
     */
     
     /* Columna de ancho fijo a 100 pixels, con propiedad 'clickable',y 'ordenable' */
     DEFINE TREEVIEWCOLUMN oCol COLUMN 4 ;
            TITLE "Hazme click y me ordenas" ;
            TYPE "text";
            SORT;
            OF oTreeView;
            EDITABLE Edita_Celda( oSender, oLbx, uVal, aIter )
     oCol:SetResizable( .T. )
//     oCol:SetClickable( .T. ) 
     /* Como podemos hacer que se ponga la columna de busqueda igual a la ordenada*/
  //   oCol:Connect( "clicked" )
  //   oCol:bAction := { |o| oTreeView:SetSearchColumn( o:GetSort() ) }
                  

     /* Columna de ancho fijo a 100 pixels, con propiedad 'clickable' */
     DEFINE TREEVIEWCOLUMN oCol COLUMN 5 ;
            TITLE UTF_8("N�meros Doubles") ;
            TYPE "text";
            SORT;
            OF oTreeView
     /* Como podemos hacer que se ponga la columna de busqueda igual a la ordenada*/
     oCol:Connect( "clicked" )
     oCol:bAction := { |o| oTreeView:SetSearchColumn( o:GetSort() ) }
    
     /* Columna tipo 'checkbox' */
     DEFINE TREEVIEWCOLUMN COLUMN 6 TITLE "Check" TYPE "active" OF oTreeView
     
     DEFINE TREEVIEWCOLUMN COLUMN 7 TITLE "Enteros" TYPE "text" OF oTreeView
   
     oTreeView:SetFocus()

   ACTIVATE WINDOW oWnd CENTER

return NIL

// Una manera facil de obtener el valor de las columnas
// Podemos ver como coger la imagen de la columna 1
//
// Easy get values from columns
// Example get image from column 1

Static Function Comprueba( oTreeView, pPath, pTreeViewColumn  )
    Local oWnd , oImage, width, height, pImage

    pImage := oTreeview:GetValue( 1, "pointer" , pPath )
    
    if pImage != NIL  // Si hay pixbuf
       width  = gdk_pixbuf_get_width ( pImage )
       height = gdk_pixbuf_get_height( pImage )
       DEFINE WINDOW oWnd TITLE "Imagen" SIZE width, height TYPE_HINT GDK_WINDOW_TYPE_HINT_MENU
         oWnd:SetResizable( .F. )

         DEFINE IMAGE oImage OF oWnd CONTAINER
          oImage:SetFromPixbuf( pImage ) // Metemos en la imagen el pixbuf
    
       ACTIVATE WINDOW oWnd MODAL CENTER
    endif

Return nil

/*
 * Como podemos modificar o borrar en la fila actual
 */
Static Function Actua( oTreeView, oLbx, lDelete )
    Local aIter := Array( 4 ), i, path 
    Local pSelection := oTreeView:GetSelection()
    Local pModel :=  oTreeView:GetModel()

    

    IF gtk_tree_selection_get_selected( pSelection, NIL, aIter ) 
       path = gtk_tree_model_get_path( pModel, aiter )
       i := hb_gtk_tree_path_get_indices( path ) + 1 // Obtenemos la fila donde estamos
       if lDelete
          oLbx:Remove( aIter )
       else
         oLbx:Set( aIter, 2, "Modificado" )
         oLbx:Set( aIter, 3, "Si,Modificado" )
       endif
       gtk_tree_path_free( path )
     ENDIF

Return nil

/*
 * Como insertar en una columna determinada
 */
STATIC FUNCTION INSERT_LIST( oLbx )
     Local pixbuf
     pixbuf := gdk_pixbuf_new_from_file( "../../images/rafa2.jpg" )
    
     INSERT LIST_STORE oLbx ROW 2 VALUES pixbuf ,;
                                        "Row",;  
                                        "INSERT",; 
                                        "Run-Time",;
                                        0123.23,; 
                                        .T. 
    gdk_pixbuf_unref( pixbuf )

RETURN NIL
/*
 * Como meter mas valores.
 */
STATIC FUNCTION APPEND_LIST( oLbx )
    Local aIter := Array( 4 )
     Local pixbuf
     pixbuf := gdk_pixbuf_new_from_file( "../../images/flacoygordo.gif" )

     APPEND LIST_STORE oLbx VALUES pixbuf ,;
                                   "Row",;  
                                   "APPEND",; 
                                   "Run-Time",;
                                   999.99,; 
                                   .F. 
    
    gdk_pixbuf_unref( pixbuf )

RETURN NIL

STATIC FUNCTION Edita_Celda( oSender, oLbx, cNewText, aIter )

  oLbx:Set( aIter, oSender:nColumn + 1, cNewText )

RETURN NIL