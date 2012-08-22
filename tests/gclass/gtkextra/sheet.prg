/* Primero implementacion de Modelo Vista en POO
  (c)2012 Rafa Carmona
 *
 *  Algunos cambios incluidos para mejor manejo de columnas por Riztan Gutierrez
 * 
 *  Edición siempre activa por Rafa
 */

#include "gclass.ch"
#include "gclass_extra.ch"

Function Main()

  local hWnd, oScroll, oWnd, oLabel
  local oBox 
  
  //local sheet
  local oSheet

   DEFINE WINDOW oWnd TITLE "GtkSheet Demo (GtkExtra)" SIZE 750,300

     oWnd:SetBorder( 8 )

     DEFINE BOX oBox VERTICAL OF oWnd  SPACING 8
       DEFINE LABEL oLabel TEXT "T-Gtk Power!" OF oBox

       
       DEFINE SCROLLEDWINDOW oScroll  OF oBox EXPAND FILL ;
              SHADOW GTK_SHADOW_ETCHED_IN

              oScroll:SetPolicy( GTK_POLICY_AUTOMATIC, GTK_POLICY_AUTOMATIC )

       DEFINE SHEET oSheet OF oScroll ;
              TITLE "sheet" ;
              SIZE 10,10
           

   ACTIVATE WINDOW oWnd CENTER

return NIL


//eof

