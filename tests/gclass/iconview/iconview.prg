#include "gclass.ch"


#define GtkTreeIter  Array( 4 )

Function Main()
  Local oWnd, oScroll, oIconView, oModel

 /* Ventana */
  DEFINE WINDOW oWnd TITLE "GtkIconView. T-Gtk for [x]Harbour (c)03-2006 Rafa Carmona" SIZE 500,500
    
     DEFINE SCROLLEDWINDOW oScroll OF oWnd CONTAINER

     oModel := Create_Model()
     DEFINE ICONVIEW oIconView MODEL oModel OF oScroll CONTAINER

     oIconView:SetTexColumn( 1 )
     oIconView:SetPixBufColumn( 2 )
     oIconView:SetColumns( 5 )
     oIconView:bItem_Activated := {|oSender,pPath| Comprueba( oSender, pPath )  }

  ACTIVATE WINDOW oWnd CENTER


return NIL

FUNCTION Create_Model()
  local aIter := GtkTreeIter
  local oLbx, x, oImage,pixbuf
  Local aFiles := {}
  local aPngs := Directory( "../../images/*.png" )
  local aJpgs := Directory( "../../images/*.jpg" )
  
  Aeval( aPngs ,{ | a| AADD( aFiles, a[1] ) } )
  Aeval( aJpgs ,{ | a| AADD( aFiles, a[1] ) } )

   DEFINE LIST_STORE oLbx TYPES G_TYPE_STRING, GDK_TYPE_PIXBUF 
    For x := 1 To Len( aFiles )
        APPEND LIST_STORE oLbx ITER aIter
        SET LIST_STORE oLbx ITER aIter POS 1 VALUE aFiles[x]
        
        DEFINE IMAGE oImage FILE "../../images/"+aFiles[ x ] LOAD
        pixbuf := gdk_pixbuf_scale_simple( oImage:GetPixBuf(), 100,100 )
        SET LIST_STORE oLbx ITER aIter POS 2 VALUE pixbuf
        gdk_pixbuf_unref( pixbuf )
    Next

 RETURN oLbx

// Una manera facil de obtener el valor de las columnas
// Podemos ver como coger la imagen de la columna 1
// Easy get values from columns
// Example get image from column 1

Static Function Comprueba( oIconView, pPath  )
    Local oWnd , oImage, cText
    
    // u := o:GetValue( nColumn, cType_data, pPath )
    cText  := oIconView:GetValue( 1,, pPath )
    
    DEFINE WINDOW oWnd TITLE cText TYPE_HINT GDK_WINDOW_TYPE_HINT_MENU
         DEFINE IMAGE oImage FILE "../../images/"+cText OF oWnd CONTAINER
    
    ACTIVATE WINDOW oWnd MODAL CENTER

Return nil
