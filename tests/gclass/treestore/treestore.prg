/* Ejemplo de TreeStore  */

#include "gclass.ch"

#define GtkTreeIter  Array( 4 )

Function Main()

  local hWnd, oScroll, oTreeView, oWnd, oLbx, oBox, oCol, oCol2, oCol4, oBoxH
  
  DEFINE WINDOW oWnd TITLE "T-Gtk TreeStore power!!" SIZE 600,400
   DEFINE BOX oBox VERTICAL  SPACING 8 OF oWnd
     DEFINE LABEL PROMPT "Planning Calendar"  OF oBox    
     
     DEFINE BOX oBoxH SPACING 8 OF oBox HOMO
            DEFINE BUTTON PROMPT "UP"    ACTION oTreeView:GoUp() OF oBoxH   EXPAND FILL 
            DEFINE BUTTON PROMPT "DOWN"  ACTION oTreeView:GoDown() OF oBoxH EXPAND FILL
            DEFINE BUTTON PROMPT "NEXT"  ACTION oTreeView:GoNext() OF oBoxH   EXPAND FILL 
            DEFINE BUTTON PROMPT "PREV"  ACTION oTreeView:GoPrev() OF oBoxH EXPAND FILL
     
     DEFINE SCROLLEDWINDOW oScroll OF oBox EXPAND FILL
      oScroll:SetShadow( GTK_SHADOW_ETCHED_IN )
      oScroll:SetPolicy( GTK_POLICY_AUTOMATIC, GTK_POLICY_AUTOMATIC)
     
     /*Modelo de Datos */
     oLbx := Create_Model()
     
     DEFINE TREEVIEW oTreeView MODEL oLbx OF oScroll CONTAINER
     oTreeView:SetRules( .T. )            
     
     
     DEFINE TREEVIEWCOLUMN oCol COLUMN 1 TITLE "Holiday" TYPE "text" OF oTreeView
     oCol:SetResizable( .T. )
     // Esta columna, formar� parte de "Holiday"
     DEFINE TREEVIEWCOLUMN oCol COLUMN 4  TYPE "progress" OF oCol EXPAND

     DEFINE TREEVIEWCOLUMN oCol COLUMN 2 TITLE "Check + FIESTA!!" TYPE "active" OF oTreeView 
     oCol:oRenderer:Set_Valist( { "cell-background", "Yellow", ;
                                  "cell-background-set", .t. } )
      
     // Fijaos, como podemos FORMAR en una misma columna , un grafico , por ejemplo.
     // Ademas, alineamos el pixbuf a la derecha, xAlign, y mantememos el mismo color de fondo
     DEFINE TREEVIEWCOLUMN oCol2 COLUMN 3 TYPE "pixbuf" OF oCol EXPAND
     oCol2:oRenderer:Set_Valist( { "cell-background", "Yellow", ;
                                   "cell-background-set", .t.,;
                                   "xalign", 0.0 } )
     oTreeView:SetFocus()

   ACTIVATE WINDOW oWnd CENTER
  
RETURN NIL         

STATIC FUNCTION Create_Model()
  local oLbx
  local aParent, aChild , aIter
  local nMonth, nDay, pixbuf
  local nToday  := 0
  local aDays   := { "Lunes", "Martes", "Miercoles", "Jueves", ;
                     "Viernes", "Sabado", "Domingo" }
  local aMonths := { "Ene", "Feb", "Mar", "Abr", "May", "Jun", ;
                     "Jul", "Ago", "Sep", "Oct", "Nov", "Dic" }

  DEFINE TREE_STORE oLbx TYPES G_TYPE_STRING, G_TYPE_BOOLEAN, GDK_TYPE_PIXBUF , G_TYPE_INT

  pixbuf := gdk_pixbuf_new_from_file( "../../images/gnome-gsame.png" )

  for nMonth := 1 to len( aMonths )
      
      APPEND TREE_STORE oLbx ITER aParent VALUES aMonths[nMonth]
      SET TREE_STORE oLbx ITER aParent POS 4 VALUE 50
      
      for nDay := 1 to 30
          if nToday == 7
             SET TREE_STORE oLbx ITER aParent POS 2 VALUE .T.
             nToday  = 1
          else
             nToday += 1
          endif
           SET TREE_STORE oLbx ITER aParent POS 2 VALUE .T.
      
           APPEND TREE_STORE oLbx PARENT aParent ;
                  ITER aChild ;
                  VALUES aDays[nToday] + " " +;
                         str(nDay,2) + " de " + aMonths[nMonth] + " de 2.005"
          if aDays[nToday] == "Sabado" .OR. aDays[nToday] == "Domingo"
             SET TREE_STORE oLbx ITER aChild POS 2 VALUE .T.
             SET TREE_STORE oLbx ITER aChild POS 3 VALUE pixbuf
             SET TREE_STORE oLbx ITER aChild POS 4 VALUE 100
          else
             SET TREE_STORE oLbx ITER aChild POS 4 VALUE nDay
          endif
      next
  next
  
  gdk_pixbuf_unref( pixbuf )
   
  /* Ejemplo de INSERTAR un padre y un par de hijos en la primera posicion */
  INSERT TREE_STORE oLbx ROW 1 ITER aParent           // Padre
  
  SET TREE_STORE oLbx ITER aParent POS 1 VALUE "Hola" // Valor Padre
  
  SET TREE_STORE oLbx ITER aParent POS 4 VALUE 75     // Valor de Progress
  
      INSERT TREE_STORE oLbx ROW 1 ;
             ITER aChild PARENT aParent ;
             VALUES "Hijo",.T.,pixbuf,100 // Hijo con valores directamente

          INSERT TREE_STORE oLbx ROW 1 ;
                 ITER aIter PARENT aChild ;
                 VALUES "SubHijo",.F.,,50 // Hijo con valores directamente

 Return oLbx
