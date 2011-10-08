/*
  Mantenimiento de Status
  (c)2001 Rafa Carmona
*/
#include "gclass.ch"
#include "tdolphin.ch"
#include "gmante.ch"

MEMVAR oServer

function Mnt_Status( ) 
  Local oMante 
  // Self, es el propio objeto oMante, que es enviado por la propia clase.
  DEFINE MANTENIMIENTO oMante  ;
      TITLE "Mantenimiento de Status" ;
      QUERY "SELECT id, orden, nombre FROM status order by id" ;
      COLUMN VALUE 1 ;
      DOLPHIN oServer ;
      ROW ACTION  CreateStatus( Self, df_EDIT ) ;
      BUTTON ADD  CreateStatus( Self, df_ADD ) ;
      BUTTON EDIT CreateStatus( Self, df_EDIT ) ;
      BUTTON DEL  CreateStatus( Self, df_DEL ) ;

return nil

//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------
static function CreateStatus( oMante, uMode )
    Local aIter := Array( 4 ), pPath, oLbx, pReference, oError
    Local oDlg, cVar, oBox, oEntry, nId, oData
    Local lOK := .T., lSelect := .F.
    Local cQryAlta := "SELECT id, orden, nombre FROM status LIMIT 1"
    Local cQryEdit := "SELECT id, orden, nombre FROM status where id = "
    Local oBoxV1, oBoxV2, oEntry2, oBox1, oBox2, oEntry1

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
           oData = oServer:Query( cQryAlta )
           oData:GetBlankRow( .F. )
      case uMode = df_EDIT
           nId   := oMante:oTreeView:GetAutoValue( 1 )
           oData := oServer:Query( cQryEdit + CStr( nId ) )
      case uMode = df_DEL
           nId   := oMante:oTreeView:GetAutoValue( 1 )
           oData := oServer:Query( cQryEdit + CStr( nId ) )
           if MsgNoYes( "¿ Realmente quieres borrar el status: " +;
                       CRLF+  alltrim( oData:Nombre ) +"  ? "  , "Atención" )
              try
                if oData:Delete()
                   oMante:oTreeView:oModel:Remove( aIter )
                   gtk_tree_view_set_cursor( oMante:oTreeView:pWidget, pPath, 1, .F. )  // Nos posicionamos donde estabamos
                   gtk_tree_path_free( pPath )
                endif
              catch oError
                    MsgStop( oError:Description, "Alerta" )
              end

           endif
           return nil
   endcase

   // --------  PARTE GUI -----------------------------------------------
   DEFINE DIALOG oDlg TITLE "Status" SIZE 250,100

      DEFINE BOX oBoxV1 VERTICAL OF oDlg

       DEFINE BOX oBox1 OF oBoxV1
          DEFINE LABEL TEXT "Orden"            OF oBox1
          DEFINE SPIN oEntry1  VAR oData:Orden OF oBox1 EXPAND FILL 
//          DEFINE ENTRY oEntry1 VAR oData:Orden OF oBox1 EXPAND FILL 

       DEFINE BOX oBox2 OF oBoxV1
          DEFINE LABEL TEXT "Nombre"            OF oBox2
          DEFINE ENTRY oEntry2 VAR oData:Nombre OF oBox2 EXPAND FILL

   ACTIVATE DIALOG oDlg CENTER RUN ;
            ON CANCEL .T. ;
            ON APPLY  .T.
   // -------- PARTE GUI -----------------------------------------------


   if oDlg:nID = GTK_RESPONSE_APPLY
      if oData:Save()         // Si hemos podido guardar los datos
         if uMode = df_EDIT   // En una modificacion, SOLAMANTE refrescamos la linea
            oMante:oTreeView:oModel:Set( aIter, 2, oData:Orden )
            oMante:oTreeView:oModel:Set( aIter, 3, alltrim( oData:Nombre ) )
         else
            // Atentos, obtemos el ultimo ID y seleccionamos con un select para obtener los valores correctos
            // para poner adecuadamente en el modelo de datos.
            nId   := oServer:GetAutoIncrement( "status" ) - 1
            oData := oServer:Query( "SELECT id, orden, nombre FROM status where id = " + CStr( nId ) )
            // Cuando no hay registro, no tenemos modelo de datos, generamos uno nuevo
            if empty( nId )
               oMante:SetQuery()  // Reconstruye de nuevo los datos del TreeView. ULTIMO RECURSO
            else
               APPEND LIST_STORE oMante:oTreeView:oModel VALUES oData:Id, oData:Orden ,oData:Nombre
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

