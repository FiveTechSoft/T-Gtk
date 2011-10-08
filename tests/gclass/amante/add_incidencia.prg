/* Insertar incidencia
(c)2011 Rafa Carmona
*/
#include "gclass.ch"

/*
 Add incidencia
  
  TODO: Bug T-Gtk, si tenemos un VALID en un ENTRY, si movemos la ventana, este se evalua.

*/
function Add_Incidencia( oTreeView )
       Local oWnd, cGlade, oLbx, oCombo, oEntry, oEntryCad
       Local cEstablecimiento := "", cCadena := ""	
       Local aItems, aItemsCadena
       Local pixbuf := gdk_pixbuf_new_from_file( "../../images/gnome-logo.png" )

       
       // Rellenamos en base a la cadena
       aItemsCadena := FillSimpleArray( "select nombre from cadena", "nombre" )
       aItems       := FillSimpleArray( "select nombre from establecimientos", "nombre" )
       
       SET RESOURCES cGlade FROM FILE "dolphin.glade" ROOT "wnd_add_incidencia"
       DEFINE WINDOW oWnd ID "wnd_add_incidencia" RESOURCE cGlade
            
            DEFINE ENTRY oEntryCad VAR cCadena ;
                   COMPLETION aItemsCadena ;
                   RIGHT BUTTON GTK_STOCK_EDIT;
                   ACTION ( If( nPos == 0, NIL, ( oEntryCad:SetText( Mnt_Cadena( 2 ) ) ) ) ) ;
                   ID "incidencia_entry_add_cadena" RESOURCE cGlade  


            DEFINE ENTRY oEntry VAR cEstablecimiento ;
                   COMPLETION aItems ;
                   RIGHT BUTTON GTK_STOCK_EDIT;
                   ACTION ( If( nPos == 0, NIL, ( oEntry:SetText( Mnt_Establecimientos( 2 ) ), rellena( oEntry ) ) ) ) ;
                   ID "incidencia_entry_add" RESOURCE cGlade 
                   

       ACTIVATE WINDOW oWnd CENTER

 
return nil


STATIC FUNCTION rellena( oEntry )
 Local aItems
 
 aItems := FillSimpleArray( "select nombre from establecimientos", "nombre" )
 oEntry:Create_Completion( aItems )
 
return  nil

STATIC FUNCTION rellena_cadenas( oEntry )
 Local aItems := FillSimpleArray( "select nombre from cadena", "nombre" )
 oEntry:Create_Completion( aItems )
return nil
