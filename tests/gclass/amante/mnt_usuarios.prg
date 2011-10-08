/*  
  Mantenimiento de Usuarios
  (c)2011 Rafa Carmona
  TODO: ALL

*/
#include "gclass.ch"
#include "tdolphin.ch"
#include "gmante.ch"

MEMVAR oServer

function Mnt_Usuarios( ) 
  Local oMante

  // Self, es el propio objeto oMante, que es enviado por la propia clase.
  DEFINE MANTENIMIENTO oMante  ;
      TITLE "Mantenimiento de Usuarios" ;
      QUERY "SELECT id, nombre, email, telefono, asignar_tareas FROM usuarios;";
      COLUMN VALUE 1 ;
      VIEW COLUMNS 2,3,4,5;
      DOLPHIN oServer ;
      ROW ACTION  CreateUsuario( Self, df_EDIT ) ;
      BUTTON ADD  CreateUsuario( Self, df_ADD ) ;
      BUTTON EDIT CreateUsuario( Self, df_EDIT ) ;
      BUTTON DEL  CreateUsuario( Self, df_DEL ) ;
      SIZE 800,500

return nil

//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------
static function CreateUsuario( oMante, uMode )
    Local aIter := Array( 4 ), pPath, oLbx, pReference
    Local oDlg, cVar, oBox, oEntry, nId, oData, oCombo, oBoxV
    Local lOK := .T., lSelect := .F.
    Local cNombre := "" , cCadena := ""
    Local cQryEdit := "SELECT id, nombre, email, telefono, asignar_tareas FROM usuarios WHERE id = "

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
            cNombre := ""
            nId    := 0
       case uMode = df_EDIT
            nId     := oMante:GetValue( 1 )
            oData   := oServer:Query( cQryEdit + CStr( nId ) )
            cNombre  := oData:Nombre
            //cCadena := alltrim( oData:Cadena )
       case uMode = df_DEL
            nId     := oMante:oTreeView:GetAutoValue( 1 )
            cNombre := oMante:oTreeView:GetAutoValue( 2 ) 
            if MsgNoYes( "¿ Realmente quieres borrar el usuario: " +;
                          CRLF+  alltrim( cNombre ) +"  ? "  , "Atención" )
               if DeleteQry( "DELETE FROM usuaruis WHERE id =" + ClipValue2SQL( nId ) )
                  oMante:oTreeView:oModel:Remove( aIter )
                  gtk_tree_view_set_cursor( oMante:oTreeView:pWidget, pPath, 1, .F. )  // Nos posicionamos donde estabamos
                  gtk_tree_path_free( pPath )
               endif
            endif
            return nil
    endcase
  
   // --------  PARTE GUI -----------------------------------------------
   DEFINE DIALOG oDlg TITLE "Usuarios" SIZE 550,100
      
       DEFINE BOX oBoxV OF oDlg  VERTICAL
       DEFINE BOX oBox OF oBoxV EXPAND

          DEFINE LABEL TEXT "Nombre"         OF oBox 
          DEFINE ENTRY oEntry VAR cNombre    OF oBox EXPAND FILL

          /*DEFINE LABEL TEXT "Cadena"        OF oBox 
          DEFINE COMBOBOX ENTRY oCombo  ;
                 VAR cCadena ;
                 ITEMS FillSimpleArray("SELECT nombre FROM cadena", "nombre") ;
                 OF oBox  EXPAND FILL
    */
   ACTIVATE DIALOG oDlg CENTER RUN ;
            ON CANCEL .T. ;
            ON APPLY  .T.
   // -------- PARTE GUI -----------------------------------------------

    
   if oDlg:nID = GTK_RESPONSE_APPLY
      if Save( uMode, nId, cNombre )         // TODO: Falta pasar datos, Si hemos podido guardar los datos
         if uMode = df_EDIT                  // En una modificacion, SOLAMANTE refrescamos la linea
            oMante:oTreeView:oModel:Set( aIter, 2, alltrim( cNombre) )
            //oMante:oTreeView:oModel:Set( aIter, 3, alltrim( cCadena ) )
         else
            // Atentos, obtemos el ultimo ID y seleccionamos con un select para obtener los valores correctos
            // para poner adecuadamente en el modelo de datos.
            nId   := oServer:GetAutoIncrement( "usuarios" ) - 1
            oData := oServer:Query( cQryEdit + CStr( nId ) )
            if empty( nId )
               oMante:SetQuery()  // Reconstruye de nuevo los datos del TreeView. ULTIMO RECURSO
            else
               //TODO : Falta completar
               APPEND LIST_STORE oMante:oTreeView:oModel VALUES oData:Id, alltrim( oData:Nombre ), alltrim( oData:email ), alltrim( oData:telefono ), odata:asignar_tareas
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
static function Save( uMode, nId, cNombre )
    Local cQry 
    Local lResult := .F.
    

    do case
       case uMode = df_ADD
               cQry := "INSERT INTO usuarios( nombre, email, telefono, asignar_tareas, ver_tareas, add_tareas, password ) VALUES( " + ;
                        ClipValue2SQL( cNombre ) + ","+ClipValue2SQL( "email@tem.es" ) + ",123" + ",1" + ",1" + ",1" + ",1212" + ")"
                MsgInfo( cQry )
               lResult := oServer:Execute( cQry )
       case uMode = df_EDIT
               cQry := "UPDATE usuarios SET "
               cQry += "nombre="    + ClipValue2SQL( cNombre ) + ","
               cQry += "id_cadena=" + ClipValue2SQL( "" ) + " WHERE id=" + ClipValue2SQL( nId )
               lResult := oServer:Execute( cQry )

    end case 

return lResult
