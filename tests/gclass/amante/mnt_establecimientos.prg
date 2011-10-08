/*
  Mantenimiento de hoteles
  (c)2001 Rafa Carmona

*/
#include "gclass.ch"
#include "tdolphin.ch"
#include "gmante.ch"

MEMVAR oServer

function Mnt_Establecimientos( nColumnValue ) 
  Local oMante

  // Self, es el propio objeto oMante, que es enviado por la propia clase.
  // En este ejemplo, podemos observar como tenemos 3 campos en la Query: id, nombre, cadena
  // VIEW COLUMNS 2, 3; Solo muestra el nombre y la cadena
  // COLUMN VALUE 1, y retornará el ID , si es nuestra intención retornar algo.

  DEFAULT nColumnValue := 1 ;

  DEFINE MANTENIMIENTO oMante  ;
      TITLE "Mantenimiento de Establecimientos" ;
      QUERY "SELECT h.id AS id, h.nombre AS Establecimiento ,c.nombre AS cadena, c.id AS id_cadena FROM establecimientos h LEFT JOIN cadena c ON h.id_cadena = c.id order by h.nombre" ;
      COLUMN VALUE nColumnValue ;
      VIEW COLUMNS 2,3;
      DOLPHIN oServer ;
      ROW ACTION  CreateEstablecimiento( Self, df_EDIT ) ;
      BUTTON ADD  CreateEstablecimiento( Self, df_ADD ) ;
      BUTTON EDIT CreateEstablecimiento( Self, df_EDIT ) ;
      BUTTON DEL  CreateEstablecimiento( Self, df_DEL ) ;

return CStr( oMante:cValue )

//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------
static function CreateEstablecimiento( oMante, uMode )
    Local aIter := Array( 4 ), pPath, oLbx, pReference
    Local oDlg, cVar, oBox, oEntry, nId, oData, oCombo, oBoxV
    Local lOK := .T., lSelect := .F.
    Local cEstablecimiento := "" , cCadena := ""
    Local cQryEdit := "SELECT h.id AS id, h.nombre AS Establecimiento ,c.nombre AS cadena, c.id AS id_cadena FROM establecimientos h LEFT JOIN cadena c ON h.id_cadena = c.id where h.id = "


    if uMode != df_ADD .and. ( lSelect := oMante:oTreeView:IsGetSelected( aIter ) ) // Si fue posible seleccionarlo
       lOk := .T.
    else
       lOk := .F.
    endif

    if !lOk .and. uMode != df_ADD
       return nil
    endif

    if lSelect
       pPath := oMante:oTreeView:GetPath( aIter )                      // Obtengo el camino donde estoy
       pReference := gtk_tree_row_reference_new( oMante:oTreeView:GetModel(), pPath )
    endif

    do case
       case uMode = df_ADD
            cEstablecimiento := ""
            nId    := 0
       case uMode = df_EDIT
            nId     := oMante:GetValue( 1 )
            oData   := oServer:Query( cQryEdit + CStr( nId ) )
            cEstablecimiento  := oData:Establecimiento
            cCadena := alltrim( oData:Cadena )
       case uMode = df_DEL
            nId              := oMante:oTreeView:GetAutoValue( 1 )
            cEstablecimiento := oMante:oTreeView:GetAutoValue( 2 ) 
            if MsgNoYes( "¿ Realmente quieres borrar el Establecimiento: " +;
                          CRLF+  alltrim( cEstablecimiento ) +"  ? "  , "Atención" )
               if DeleteQry( "DELETE FROM establecimientos WHERE id =" + ClipValue2SQL( nId ) )
                  oMante:oTreeView:oModel:Remove( aIter )
                  gtk_tree_view_set_cursor( oMante:oTreeView:pWidget, pPath, 1, .F. )  // Nos posicionamos donde estabamos
                  gtk_tree_path_free( pPath )
               endif
            endif
            return nil
    endcase
  
   // --------  PARTE GUI -----------------------------------------------
   DEFINE DIALOG oDlg TITLE "Establecimientos" SIZE 550,100
      
       DEFINE BOX oBoxV OF oDlg  VERTICAL
       DEFINE BOX oBox OF oBoxV EXPAND

          DEFINE LABEL TEXT "Establecimiento"         OF oBox 
          DEFINE ENTRY oEntry VAR cEstablecimiento    OF oBox EXPAND FILL ;
                 VALID Mira()

          DEFINE LABEL TEXT "Cadena"        OF oBox 
          DEFINE COMBOBOX ENTRY oCombo  ;
                 VAR cCadena ;
                 ITEMS FillSimpleArray("SELECT nombre FROM cadena", "nombre") ;
                 OF oBox  EXPAND FILL
    
   ACTIVATE DIALOG oDlg CENTER RUN ;
            ON CANCEL .T. ;
            ON APPLY  .T.
   // -------- PARTE GUI -----------------------------------------------

    
   if oDlg:nID = GTK_RESPONSE_APPLY
      if Save( uMode, nId, cEstablecimiento, cCadena )         // Si hemos podido guardar los datos
         if uMode = df_EDIT                          // En una modificacion, SOLAMANTE refrescamos la linea
            oMante:oTreeView:oModel:Set( aIter, 2, alltrim( cEstablecimiento) )
            oMante:oTreeView:oModel:Set( aIter, 3, alltrim( cCadena ) )
         else
            // Atentos, obtemos el ultimo ID y seleccionamos con un select para obtener los valores correctos
            // para poner adecuadamente en el modelo de datos.
            nId   := oServer:GetAutoIncrement( "establecimientos" ) - 1
            oData := oServer:Query( cQryEdit + CStr( nId ) )
            // Nota: Según MySQL, es más rápido traerlos todos que uno en concreto.
            if empty( nId )
               oMante:SetQuery()  // Reconstruye de nuevo los datos del TreeView. ULTIMO RECURSO
            else
               APPEND LIST_STORE oMante:oTreeView:oModel VALUES oData:Id, alltrim( oData:Establecimiento ), alltrim( oData:Cadena ), oData:Id_Cadena
            endif
         endif
      endif
   endif

   if lSelect
      if uMode = df_EDIT   // Obtenemos el path nuevo según la nueva referencia de la fila
         gtk_tree_path_free( pPath )
         pPath := gtk_tree_row_reference_get_path( pReference ) 
      endif
      gtk_tree_view_set_cursor( oMante:oTreeView:pWidget, pPath, 1, .F. )  // Nos posicionamos donde estabamos
      gtk_tree_row_reference_free( pReference )
      gtk_tree_path_free( pPath )
   endif

return nil

// ------------------------------------------------------------------------
/*INSERT o UPDATE */
// ------------------------------------------------------------------------
static function Save( uMode, nId, cEstablecimiento, cCadena )
    Local cQry 
    Local lResult := .F.
    Local aValue := FillSimpleArray( "SELECT id FROM cadena where nombre="+ClipValue2SQL( cCadena ) , "id" ) 

    // Si no existe cadena, la creamos en este mismo momento
    if empty( aValue )
       cQry := "INSERT INTO cadena( nombre ) VALUES( " + ClipValue2SQL( cCadena ) + ")"
       if oServer:Execute( cQry )
          aValue := { oServer:GetAutoIncrement( "cadena" ) -1 }
       else
          MsgStop( "No se pudo crear cadena nueva", "Atención" )
       endif
    endif               

    do case
       case uMode = df_ADD
            if !empty( aValue )
               cQry := "INSERT INTO establecimientos( nombre, id_cadena ) VALUES( " + ClipValue2SQL( cEstablecimiento ) + ","+ClipValue2SQL( aValue[1] ) + ")"
               lResult := oServer:Execute( cQry )
            endif
       case uMode = df_EDIT
            if !empty( aValue )
               cQry := "UPDATE establecimientos SET "
               cQry += "nombre="    + ClipValue2SQL( cEstablecimiento ) + ","
               cQry += "id_cadena=" + ClipValue2SQL( aValue[1] ) + " WHERE id=" + ClipValue2SQL( nId )
               lResult := oServer:Execute( cQry )
            endif

    end case 

return lResult

static function Mira()
static n := 0
n++

g_print( CStr( n ) + CRLF)

return .t.

