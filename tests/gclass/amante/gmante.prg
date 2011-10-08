#include "gclass.ch"
#include "hbclass.ch"
#include "tdolphin.ch"

#ifdef __HARBOUR__
//   #include "hbcompat.ch"
#endif

//-----------------------------------------------------------------------------
/*
  CLASE GENERICA DE MANTENIMIENTO
  (c) 2011 Rafa Carmona
 */
//-----------------------------------------------------------------------------
CLASS gMante
      DATA oBoxV                   // BOX Vertical
      DATA oToolBar                // Toolbar
      DATA oBtnAdd , oBtnEdit , oBtnDel, oBtnRefresh, oBtnGet
      DATA oTreeView
      DATA oDolphin, cQuery
      DATA oWnd
      DATA oBar
      DATA cValue   INIT ""
      DATA oUser                   // TODO: Clase Usuario para permitir activar/desactivar distintas opciones.
      DATA bActivated
      DATA bFalseActivated
      DATA nGetColumnValue INIT 1  // Obtener el valor por defecto de la columna 1
      DATA oAccel
      DATA oTreeView
      DATA oScroll
      DATA aViewColumns            // Columnas a mostrar del modelo de datos en la vista. NIL = ALL

      METHOD New( oWnd, oServer )
      METHOD NewWindow( cTitle, cQuery, oServer )
      METHOD AddBtn( cType )
      METHOD BtnAction( cType, bAction )
      METHOD SetQuery( cQuery )
      METHOD GetValue( nColumn )  // Devuelve el valor de una columna
      METHOD SetRowActivated( bActivated )
      /* Methods usados para retonar al codeblock pasado, el primer parametro es Self */
      METHOD Comprueba( path, col )
      METHOD Add( bAdd )
      METHOD Del( bDel )
      METHOD Edit( bEdit)

ENDCLASS


/*
  oWnd : Objeto Ventana donde incrustar los controles
  oDolphin : Clase para acceso a MySql de Daniel
  cQuery : Opcional , si queremos establecer una query
  lAdd   : .T. Show toolbutton Add
  lEdit  : .T. Show toolbutton Edit
  lDel   : .T. Show toolbutton Del
  nGetColumnValue : Valor de la columna que queremos obtener
*/

//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------
METHOD New( oWnd, oDolphin, cQuery, lAdd, lEdit, lDel, nGetColumnValue, aViewColumns ) CLASS GMANTE
    Local oToolMenu

    DEFAULT nGetColumnValue := 1

    ::oWnd     := oWnd
    ::oDolphin := oDolphin
    ::cQuery   := cQuery
    ::nGetColumnValue := nGetColumnValue
    ::aViewColumns := aViewColumns

    DEFAULT lAdd := .T., lEdit := .T., lDel := .T.

    DEFINE BOX ::oBoxV VERTICAL OF ::oWnd
      DEFINE TOOLBAR ::oToolbar STYLE GTK_TOOLBAR_BOTH  OF ::oBoxV

        if lAdd ; ::AddBtn( "add" )  ; endif
        if lEdit; ::AddBtn( "edit" ) ; endif
        if lDel;  ::AddBtn( "del" )  ; endif

        DEFINE TOOLBUTTON ::oBtnGet      TEXT "Get"      STOCK_ID GTK_STOCK_JUMP_TO ACTION ( ::GetValue( nGetColumnValue ), ::oWnd:End() )    OF ::oToolBar
        DEFINE TOOLBUTTON ::oBtnRefresh  TEXT "Refresh"  STOCK_ID GTK_STOCK_REFRESH ACTION ( ::SetQuery( ::cQuery ), ::oTreeView:SetFocus() ) OF ::oToolBar

        DEFINE SCROLLEDWINDOW ::oScroll  OF ::oBoxV EXPAND FILL
        ::oScroll:SetPolicy( GTK_POLICY_NEVER, GTK_POLICY_AUTOMATIC )

           DEFINE TREEVIEW ::oTreeView  OF ::oScroll  CONTAINER
           ::oTreeView:SetRules( .T. )

       DEFINE STATUSBAR ::oBar TEXT "(c)2011 Rafa Carmona" OF ::oBoxV

RETURN Self

//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------
METHOD NewWindow( cTitle, cQuery, oServer , bRowActivated, bAdd, bEdit, bDel, nGetColumnValue, aViewColumns, nWidth, nHeigth ) CLASS GMANTE
       Local lAdd := !empty( bAdd ), lEdit := !empty( bEdit ), lDel := !empty( bDel )

       DEFAULT cTitle := "T-HELPDESK", ::bFalseActivated := bRowActivated
       DEFAULT nHeigth := 500, nWidth := 400

       DEFINE WINDOW ::oWnd TITLE cTitle SIZE nWidth,nHeigth

             ::New( ::oWnd, oServer, cQuery, lAdd, lEdit, lDel, nGetColumnValue, aViewColumns )

             if lAdd
                ::BtnAction( "add",  {|| ::Add( bAdd ) } )
             endif
             if lEdit
                ::BtnAction( "edit", {|| ::Edit( bEdit ) } )
             endif
             if lDel
                ::BtnAction( "del",  {|| ::Del( bDel ) } )
             endif

             ::SetQuery( cQuery )

             if !empty( ::bFalseActivated )  // Si queremos llamar
                ::SetRowActivated( { |path,col| ::Comprueba( path, col) } )
             endif

             // Vamos a definir teclas de aceleracion
             DEFINE ACCEL_GROUP ::oAccel OF ::oWnd
                    ADD ACCELGROUP ::oAccel OF ::oBtnAdd     SIGNAL "clicked"  KEY GDK_INSERT
                    ADD ACCELGROUP ::oAccel OF ::oBtnDel     SIGNAL "clicked"  KEY GDK_Delete
                    ADD ACCELGROUP ::oAccel OF ::oBtnRefresh SIGNAL "clicked"  KEY "F5"
                    ADD ACCELGROUP ::oAccel OF ::oBtnGet     SIGNAL "clicked"  KEY "F2"

             ::oTreeView:SetFocus()
        
       ::oWnd:lUseEsc := .T. // Permitimos salir de la ventana con ESC

       ACTIVATE WINDOW ::oWnd CENTER MODAL INITIATE

RETURN Self

//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------
METHOD Add( bAdd ) CLASS GMANTE
    Eval( bAdd, Self )
RETURN Nil

METHOD Del( bDel ) CLASS GMANTE
    Eval( bDel, Self )
RETURN Nil

METHOD Edit( bEdit) CLASS GMANTE
    Eval( bEdit, Self )
RETURN Nil


//-----------------------------------------------------------------------------
// Add buton a la toolbar
//-----------------------------------------------------------------------------
METHOD AddBtn( cType ) CLASS GMANTE

   do case
      case cType = "add"
           DEFINE TOOLBUTTON ::oBtnAdd  TEXT "Add"  STOCK_ID GTK_STOCK_ADD    ACTION NIL OF ::oToolBar
      case cType = "edit"
           DEFINE TOOLBUTTON ::oBtnEdit TEXT "Edit" STOCK_ID GTK_STOCK_EDIT   ACTION NIL OF ::oToolBar
      case cType = "del"
           DEFINE TOOLBUTTON ::oBtnDel  TEXT "Del"  STOCK_ID GTK_STOCK_DELETE ACTION NIL OF ::oToolBar

   end case

RETURN NIL

//-----------------------------------------------------------------------------
// Asigna codeblock al toolbutton.
//-----------------------------------------------------------------------------

METHOD BtnAction( cType, bAction ) CLASS GMANTE

   do case
      case cType = "add"
           ::oBtnAdd:bAction := bAction
      case cType = "edit"
           ::oBtnEdit:bAction := bAction
      case cType = "del"
           ::oBtnDel:bAction := bAction
   end case

RETURN NIL

//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------
METHOD SetQuery( cQuery ) CLASS GMANTE
  Local n , oLbx, x , y , oCol , aIter := Array( 4 ), j , nLen
  Local nOld_Fields := ::oTreeView:GetTotalColumns() // Informa del numero de columnas
  Local oQry, aRes, nFld, Atmp, oError, cValue

  if !empty( cQuery )
     ::cQuery := cQuery
  endif


  if empty( ::oDolphin:cDBName ) .or. empty( ::cQuery )
     return .f.
  endif

TRY
    oQry := TDolphinQry():New( ::cQuery, ::oDolphin )
CATCH oError
    MsgStop( oError:Description, "Alerta" )
    return .f.
END

  if nOld_Fields != 0  // Si hay columnas, las matamos
     for j :=  nOld_Fields TO 1 STEP -1
         ::oTreeView:RemoveColumn( j )
     next
     ::oTreeView:oModel:Clear()   // Quitamos MODELO DE DATOS antiguo.
     ::oTreeView:SetModel( NIL )  // Se lo quitamos a la vista
  endif

  if ( nLen := oQry:RecCount() ) < 1 // Comprobamos que hay registros
     return .F.
  endif


  nFld := oQry:FCount() // Total de campos
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
          cValue := oQry:FieldGet( n ) 
          if Valtype( cValue ) = "C"
             cValue := Alltrim( cValue )
          endif
          SET LIST_STORE oLbx ITER aIter POS n VALUE cValue
      next
      oQry:Skip()
  END WHILE

  ::oTreeView:SetModel( oLbx ) // Asignamos nuevo modelo de datos a la vista

  FOR n := 1 TO nFld
    // Si no hay columnas o si esta definida la columna, la mostramos
    if empty( ::aViewColumns ) .OR. ( ASCAN( ::aViewColumns, n ) > 0 )
      if oQry:FieldType( n ) == "L"  // Si el tipo es LOGICO, ponemos la columna como CHECK
         DEFINE TREEVIEWCOLUMN oCol COLUMN n TITLE alltrim( oQry:FieldName( n ) )  TYPE "active" OF ::oTreeView
      else
         // Para que se los numericos se pongan a la derecha, tienes que poner la clausula EXPAND
         DEFINE TREEVIEWCOLUMN oCol COLUMN n TITLE alltrim( oQry:FieldName( n ) ) TYPE "text" OF ::oTreeView EXPAND SORT
         if oQry:FieldType( n ) == "N"  //Si el tipo es NUMERICO, lo centramos a la derecha
            oCol:SetAlign( GTK_RIGHT )             // Alineacion del header
            oCol:oRenderer:SetAlign_H( GTK_RIGHT ) // Alineacion del contenido Horizontal.
         endif
         // Ejemplo de como podemos hacer que al pulsar la columna sea la de busquedas.
         oCol:Connect( "clicked" )
         oCol:bAction := { |o| ::oTreeView:SetSearchColumn( o:GetSort() ) }
      endif
      oCol:SetResizable( .T. ) //TODOS van a ser resimensionables
    endif
  NEXT

  // Liberamos el objeto Query
  oQry:End()

RETURN NIL

//-----------------------------------------------------------------------------
/* Devuelve el valor de una columna */
//-----------------------------------------------------------------------------
METHOD GetValue( nColumn ) CLASS GMANTE

    DEFAULT nColumn := 1
    ::cValue  := ::oTreeView:GetAutoValue( nColumn )

RETURN ::cValue

//-----------------------------------------------------------------------------
/* Codeblock a evaluar cuando se pulse en la fila*/
//-----------------------------------------------------------------------------
METHOD SetRowActivated( bActivated )  CLASS GMANTE
   ::bActivated := bActivated
   ::oTreeView:bRow_Activated := ::bActivated
RETURN NIL

//-----------------------------------------------------------------------------
// El rowactived salta a este method y de ahi , evaluamos el codeblock pasado en NewWindow
//-----------------------------------------------------------------------------
METHOD Comprueba( path, col ) CLASS GMANTE
  Eval( ::bFalseActivated , Self, path, col )
RETURN NIL
