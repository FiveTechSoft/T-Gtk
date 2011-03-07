/*
  Ejemplo simple de manero de clase TDoplphin de Daniel.
  (c)2011 Rafa Carmona

  Mejoras:
    + Mostrar las BD de Mysql que tengamos y seleccionar la que hemos escogido. 
    + Generar un historico de uso.

  TODO:
  + Permitir generar dinamicamente más de una vista de consulta
  + Guardar el historico de uso y su posterior carga.

*/
#include "gclass.ch"
#include "tdolphin.ch"

static s_cServer
static s_cUser  
static s_cPass  
static s_nPort := 3306
static s_cDBName
static s_nFlags    
static s_load_structure := .F.

function main()
    Local oServer, oWnd, cGlade, oTreeView, oCol, oCol2, oTool
    Local oBar, oTreeView_Consulta, oTextView, cSql := ""
    Local oTree_History, oColHis, oColHis2, oLbxHis, aParent
    Local ptoday   := gdk_pixbuf_new_from_file( "../../images/today.png" )
    Local pexecute := gdk_pixbuf_new_from_file( "../../images/execute.png" )
    Local oAccel, oBtnF2

    oServer := Autentificacion()

    if oServer != NIL    
 
       SET RESOURCES cGlade FROM FILE "dolphin.glade" ROOT "consultas" 
          
       DEFINE WINDOW oWnd ID "consultas" RESOURCE cGlade 
       
         DEFINE STATUSBAR oBar TEXT "Database en uso:"+oServer:cDBName ID "statusbar" RESOURCE cGlade

              DEFINE TREEVIEW oTreeView_Consulta ID "treeview_consulta" RESOURCE cGlade EXPAND FILL
              oTreeView_Consulta:SetRules( .T. )
             
              DEFINE TEXTVIEW oTextView VAR cSql ID "textview_ordenes" RESOURCE cGlade 
              
              /* Tree de History -----------------------------------------------------------------------------*/              
              DEFINE TREE_STORE oLbxHis TYPES GDK_TYPE_PIXBUF, G_TYPE_STRING
                 APPEND TREE_STORE oLbxHis ITER aParent VALUES ptoday,"Today"

              DEFINE TREEVIEW oTree_History MODEL oLbxHis ID "tree_history" RESOURCE cGlade EXPAND FILL;
                     ON ROW ACTIVATED ActivaHis( path, TreeViewColumn, oTextView, oServer, oTree_History , oTool )

                      DEFINE TREEVIEWCOLUMN oColHis COLUMN 1 TYPE "pixbuf" OF oTree_History
                      oColHis:oRenderer:Set_Valist( {"xalign", 0.0 } )

                      DEFINE TREEVIEWCOLUMN oColHis2 COLUMN 2 TYPE "text" OF oColHis SORT
                      oColHis2:oRenderer:SetAlign_H( GTK_LEFT )
              /*----------------- -----------------------------------------------------------------------------*/              

              // Cada vez que ejecutamos una sentencia, esta es guardada en el modelo de datos del historico
              DEFINE TOOLBUTTON oTool ID "tool_refresh" RESOURCE cGlade  ;
                     ACTION ( QUERY_VIEW( oTreeView_Consulta, oTextView:GetText(), oServer ),;
                              oLbxHis:AppendChild( { pExecute, oTextView:GetText() } , aParent ))


              /*----------------- -----------------------------------------------------------------------------*/              
              DEFINE TREEVIEW oTreeView MODEL ShowDatabases( oServer ) ID "treeview_tables" RESOURCE cGlade ;
                     ON ROW ACTIVATED Activa( path, TreeViewColumn, oTextView, oServer, oBar,  oTreeView ) 

                      DEFINE MENU MenuPopup( oServer, oTreeView ), MenuPopup2( oServer, oTreeView ) OF TREEVIEW oTreeView

                      //oTreeView:SetMenuPopup( { MenuPopup( oTreeView ), MenuPopup2( oTreeView ) } )

                      DEFINE TREEVIEWCOLUMN oCol  COLUMN 1 TITLE "BD"  TYPE "pixbuf" OF oTreeView 
                      oCol:oRenderer:Set_Valist( {"xalign", 0.0 } )

                      DEFINE TREEVIEWCOLUMN oCol2 COLUMN 2 TITLE "BD"  TYPE "text" OF oCol SORT
                      oCol2:oRenderer:SetAlign_H( GTK_LEFT )
              /*----------------- -----------------------------------------------------------------------------*/              

             // Vamos a definir teclas de aceleracion
             DEFINE ACCEL_GROUP oAccel OF oWnd
                    ADD ACCELGROUP oAccel OF otool SIGNAL "clicked"  KEY "F5"

       
       ACTIVATE WINDOW oWnd INITIATE CENTER
       
       gdk_pixbuf_unref( pToday )
       gdk_pixbuf_unref( pExecute )

    endif
           
return nil

STATIC FUNCTION MenuPopup( oServer, oTreeView )
    Local oMenu

    DEFINE MENU oMenu 
        MENUITEM TITLE "Valor DB y Field" ACTION MsgInfo( oTreeView:GetAutoValue( 2 ) ) OF oMenu

RETURN oMenu

STATIC FUNCTION MenuPopup2( oServer, oTreeView )
    Local oMenu
  
    DEFINE MENU oMenu 
        MENUITEM TITLE "Muestra Estructura" ACTION loadStructure( oServer, oTreeView  ) OF oMenu

RETURN oMenu


/*
 Averigua en que nivel estamos y permite seleccionar la DB de trabajo, o insertar la SELECT automaticamente.
 TODO: Mejoras. Creo que debe de existir alguna función que nos devuelve el contenido del padre
       sin tener que desplazarnos por la vista.
*/
static function Activa( Path, TreeViewColumn , oTextView, oServer, oBar, oTreeView )
  Local aIter := array( 4 ) , aChild, oLbx, cField, cSelect_DB
  Local cSql := "SELECT * FROM ", cSelect_Table
  Local nNivel := oTreeView:GetDepth( path )
  Local pPath := Path, oError
  Local pBd_Field, pPathPadre

try
  do case
     case nNivel = 1  // Nivel de BD
          oServer:SelectDB( oTreeView:GetAutoValue( 2 ) )
          oBar:SetText( "Database en uso: " + oServer:cDBName )
     case nNivel = 2  // Nivel de Table
          // Comprobamos que la BD donde estamos en igual a la que seleccionamos
          cSelect_Table := oTreeView:GetAutoValue( 2 ) 
          oTreeView:GoUp()        // Vamos al nivel de la BD
          cSelect_DB    := oTreeView:GetAutoValue( 2 )

          if cSelect_DB = oServer:cDBName
             gtk_tree_view_set_cursor( oTreeview:pWidget, pPath, 1, .F. )  // Nos posicionamos donde estabamos
             oTextView:SetText( cSql + cSelect_Table + " LIMIT 0,1000")
          else
             cSql += oTreeView:GetAutoValue( 2 ) + "."
             gtk_tree_view_set_cursor( oTreeview:pWidget, pPath, 1, .F. )  // Nos posicionamos donde estabamos
             oTextView:SetText( cSql + cSelect_Table + " LIMIT 0,1000" )
          endif
         gtk_tree_view_set_cursor( oTreeview:pWidget, Path, 1, .F. )  // Nos posicionamos donde estabamos

          if oTreeview:IsGetSelected( aIter )  // Obtenemos el Iter de donde estamos
             oLbx  := oTreeView:oModel
             if !gtk_tree_model_iter_has_child( oTreeview:GetModel(), aiter ) // ¿ Tienes hijos ?
                pBd_Field  := gdk_pixbuf_new_from_file( "../../images/field.png" )
                cSelect_DB := oServer:cDBName                                 // Guarda en la BD que estamos
                oTreeView:GoUp()                                              // Vamos al nivel de la BD
                oServer:SelectDB( oTreeView:GetAutoValue( 2 ) )               // Selecciona DB 
                gtk_tree_view_set_cursor( oTreeview:pWidget, pPath, 1, .F. )  // Nos posicionamos donde estabamos
                for each cField in oServer:TableStructure( cSelect_Table )    // Coloca la estructura en el modelo de datos
                    APPEND TREE_STORE oLbx PARENT aIter  ITER aChild  VALUES pBd_Field, cField[1]
                next
                oServer:SelectDB( cSelect_DB )                                 // Selecciona DB que teniamos
                gdk_pixbuf_unref( pBd_Field )
             endif
          endif

     case nNivel = 3  // Nivel de Field
          oTextView:Insert( " " + oTreeView:GetAutoValue( 2 ) + "," )  // Insertamos el nombre del campo

  endcase 
catch oError
 ? oError:Description
end

return nil

/*
 Permite cargar la estructura de datos en el treeview
*/
static function loadStructure( oServer, oTreeView  )
  Local aIter := Array ( 4 ), aChild, oLbx, pPath, cSelect_Table
  Local pBd_Field ,cField, cSelect_DB, oError, cSelect_DB_Padre, pPathPadre

try
  if oTreeview:IsGetSelected( aIter )  // Obtenemos el Iter de donde estamos
     cSelect_Table := oTreeView:GetAutoValue( 2 ) // Valor de la tabla
     pPath      := oTreeview:GetPath( aIter ) 
     pPathPadre := oTreeview:GetPath( aIter ) 
     gtk_tree_path_up( pPathPadre )         // Obtenemos la ruta hacia el padre
     GTK_TREE_SELECTION_SELECT_PATH ( oTreeView:GetSelection( ), pPathPadre ) // Seleccionamos el padre
     cSelect_DB_Padre := oTreeView:GetAutoValue( 2 )

     gtk_tree_view_set_cursor( oTreeview:pWidget, pPath, 1, .F. )  // Nos posicionamos donde estabamos
     oLbx  := oTreeView:oModel
     if !gtk_tree_model_iter_has_child( oTreeview:GetModel(), aiter ) // ¿ Tienes hijos ?
        pBd_Field  := gdk_pixbuf_new_from_file( "../../images/field.png" )
        cSelect_DB := oServer:cDBName                                 // Guarda en la BD que estamos
        oServer:SelectDB( cSelect_DB_Padre  )                         // Selecciona DB del Padre
        for each cField in oServer:TableStructure( cSelect_Table )    // Coloca la estructura en el modelo de datos
            APPEND TREE_STORE oLbx PARENT aIter  ITER aChild  VALUES pBd_Field, cField[1]
        next
        oServer:SelectDB( cSelect_DB )                                 // Selecciona DB que teniamos */
        gdk_pixbuf_unref( pBd_Field )
     endif
  endif

catch oError
 ? oError:Description
end

return nil


/*
  Coloca sentencia del historico y lo ejecuta
*/
static function ActivaHis( Path, TreeViewColumn , oTextView, oServer, oTreeView, oTool )
  Local aIter := array( 4 ) 
  Local cSql
  Local nNivel := oTreeView:GetDepth( path ) 

  if nNivel = 2                                           // Nivel de Sentencia SQL
     oTextView:SetText( oTreeView:GetAutoValue( 2 )  )
     oTool:Emit_Signal( "clicked" )                       // Ejecuta la sentencia
  endif 

return nil


/*
 Carga el modelo de datos de las BD.
*/
static function ShowDatabases( oServer )
     Local oLbx , oQry, cDb, aParent, aChild, cTable, aSubChild, cField
     Local pBd_pixbuf := gdk_pixbuf_new_from_file( "../../images/bd.png" )
     Local pBd_Table  := gdk_pixbuf_new_from_file( "../../images/table.png" )
     Local pBd_Field  := gdk_pixbuf_new_from_file( "../../images/field.png" )

     /*Modelo de Datos */
     DEFINE TREE_STORE oLbx TYPES GDK_TYPE_PIXBUF, G_TYPE_STRING

     for each cDb in oServer:ListDBs()
          APPEND TREE_STORE oLbx ITER aParent VALUES pBd_pixbuf, cDb
          oServer:SelectDB( cDb ) 
          for each cTable in oServer:ListTables( "" )
              APPEND TREE_STORE oLbx PARENT aParent ;
                    ITER aChild ;
                    VALUES pBd_Table,cTable
              if s_load_structure .and. ( s_cServer = "localhost" .or. s_cServer = "127.0.0.1" )  // Si estamos en local, podemos cargarlo
                  for each cField in oServer:TableStructure( cTable )
                      APPEND TREE_STORE oLbx PARENT aChild ITER aSubChild  VALUES pBd_Field, cField[1]
                  next
              endif
          next
     next
     
     gdk_pixbuf_unref( pBd_pixbuf )
     gdk_pixbuf_unref( pBd_Table )
     gdk_pixbuf_unref( pBd_Field )

return oLbx



/* Conexion MySql */
function Autentificacion()
    Local oWnd, cGlade, oBtn, oBox, oLabelInf, oServer, oCheck
    
    // Carga posible configuracion del ini
    Load_Conf_Ini()
    
    SET RESOURCES cGlade FROM FILE "dolphin.glade" ROOT "autentificacion" 
    
    if ( s_cServer = "localhost" .or. s_cServer = "127.0.0.1" )
       s_load_Structure := .T.
    endif


    DEFINE WINDOW oWnd ID "autentificacion" RESOURCE cGlade 
            DEFINE ENTRY VAR s_cUser      ID "entry_user"     RESOURCE cGlade
            DEFINE ENTRY VAR s_cPass      ID "entry_pass" RESOURCE cGlade
            DEFINE ENTRY VAR s_cServer    ID "entry_server"   RESOURCE cGlade
            DEFINE SPIN  VAR s_nPort      ID "spin_port"     RESOURCE cGlade
            DEFINE ENTRY VAR s_cDBName    ID "entry_bd"       RESOURCE cGlade
            DEFINE LABEL oLabelInf        ID "information"    RESOURCE cGlade             
            DEFINE CHECKBOX oCheck VAR s_load_Structure ID "check_carga" RESOURCE cGlade 

            DEFINE BUTTON oBtn ID "btn_access" RESOURCE cGlade; 
                          ACTION ( oBtn:Disable(),;
                                   IF( !empty( oServer := Connect_Db( oLabelInf )),( oWnd:End() ), ),;
                                   oBtn:Enable() ) 

            DEFINE BUTTON ID "btn_cancel" RESOURCE cGlade; 
                          ACTION ( oWnd:End() )
            
            
    ACTIVATE WINDOW oWnd 


RETURN oServer

static function Load_Conf_Ini( n )
   LOCAL hIni      
   LOCAL c   

   c = "mysql"
   
   if n != NIL 
      c = "mysql" + AllTrim( Str( n ) )
   endif

   // TODO: Tiene que existir el INI
   hIni      := HB_ReadIni( "connect.ini" )
   s_cServer := hIni[ c ]["host"]
   s_cUser   := hIni[ c ]["user"]
   s_cPass   := hIni[ c ]["psw"]
   s_nPort   := val(hIni[ c ]["port"])
   s_cDBName := hIni[ c ]["dbname"]
   s_nFlags  := val(hIni[ c ]["flags"])

return nil

function Connect_Db( oLabel )
   LOCAL oServer, oErr
      
   oServer   := NIL
   oLabel:SetText( "Estableciendo conexión a :" + s_cServer )
 
   TRY
      CONNECT oServer HOST s_cServer ;
                      USER s_cUser ;
                      PASSWORD s_cPass ;
                      PORT s_nPort ;
                      FLAGS s_nFlags;
                      DATABASE s_cDBName
                                
   CATCH oErr 
         oLabel:SetText( oErr:Description )
         return nil 
   END
   
RETURN oServer


**************************************************************************
**************************************************************************
STATIC FUNCTION QUERY_VIEW( oTreeView, cQuery, oServer )
  Local n , oLbx, x , y , oCol , aIter := Array( 4 ), j , nLen
  Local nOld_Fields := oTreeView:GetTotalColumns() // Informa del numero de columnas
  Local oQry, aRes, nFld, Atmp, oError


  if empty( oServer:cDBName ) .or. empty( cQuery )
     return .f.
  endif

  // TODO: Nota, ¿ Es posible interrumpir una Query ?
  // La idea no es para nada descabellada, de está manera , quizas conectando alguna callback 
  // donde saltar, podemos establecer si queremos cancelar o no.
  // No sé si existe algo a nivel de C, si existe, deberíamos poderlo tener a nivel de Harbour.
  
// Creamos el objeto Query
  try
    oQry := TDolphinQry():New( cQuery, oServer )
  catch oError
    MsgStop( oError:Description, "Alerta" )
    return .f.
  end
  if nOld_Fields != 0  // Si hay columnas, las matamos
     for j :=  nOld_Fields TO 1 STEP -1
         oTreeView:RemoveColumn( j )
     next
     oTreeView:oModel:Clear()   // Quitamos MODELO DE DATOS antiguo.
     oTreeView:SetModel( NIL )  // Se lo quitamos a la vista
  endif
  
  if ( nLen := oQry:RecCount() ) < 1 // Comprobamos que hay registros
     return .F.
  endif
  
  nFld := oQry:FCount() // Total de campos
  
  // Debido a una compatibilidad antigua, es necesario esto.
  // para un modelo de datos automatico. Lo se, tengo que reescribirlo...
  aRes := { } ;  Atmp := {}
  For n := 1 to nFld
      AADD( aRes, oQry:FieldGet( n ) )
  Next
  AADD( aTmp, aRes )

  // Modelo de Datos AUTOMATICO.
  DEFINE LIST_STORE oLbx AUTO aTmp
  
  WHILE !oQry:Eof()
      APPEND LIST_STORE oLbx ITER aIter 
      for n := 1 to nFld
          SET LIST_STORE oLbx ITER aIter POS n VALUE oQry:FieldGet( n )
      next
      oQry:Skip()
  END WHILE
  
  oTreeView:SetModel( oLbx ) // Asignamos nuevo modelo de datos a la vista
  
  FOR n := 1 TO nFld 
      // De momento quito soporte de check por el tema de TinyInt.
      if oQry:FieldType( n ) == "L"  // Si el tipo es LOGICO, ponemos la columna como CHECK 
         DEFINE TREEVIEWCOLUMN oCol COLUMN n TITLE alltrim( oQry:FieldName( n ) )  TYPE "active" OF oTreeView
      else
         // Para que se los numericos se pongan a la derecha, tienes que poner la clausula EXPAND 
         DEFINE TREEVIEWCOLUMN oCol COLUMN n TITLE alltrim( oQry:FieldName( n ) ) TYPE "text" OF oTreeView EXPAND SORT
         if oQry:FieldType( n ) == "N"  //Si el tipo es NUMERICO, lo centramos a la derecha 
            oCol:SetAlign( GTK_RIGHT )             // Alineacion del header 
            oCol:oRenderer:SetAlign_H( GTK_RIGHT ) // Alineacion del contenido Horizontal.
         endif
         // Ejemplo de como podemos hacer que al pulsar la columna sea la de busquedas.
         oCol:Connect( "clicked" )
         oCol:bAction := { |o| oTreeView:SetSearchColumn( o:GetSort() ) }
      endif
      oCol:SetResizable( .T. ) //TODOS van a ser resimensionables
  NEXT

  // Liberamos el objeto Query
  oQry:End()

return nil

FUNCTION Loading_Datas( )
  Local oBox,oSpinner
  static oWnd

  if empty( oWnd )

          DEFINE WINDOW oWnd SIZE 100, 100

             DEFINE BOX oBox VERTICAL OF oWnd
                 DEFINE LABEL TEXT "Loading...." EXPAND FILL OF oBOX
                 DEFINE SPINNER oSpinner START   EXPAND FILL OF oBOX

             SysRefresh()

          ACTIVATE WINDOW oWnd CENTER MODAL
  else
     oWnd:End()
     oWnd := NIL
  endif
RETURN NIL


