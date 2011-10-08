/*
  Ejemplo y clase Mantenimiento para un desarrollo r�pido.
  Estado actual : Alpha Prototipo
  (c)2011 Rafa Carmona

*/
#include "gclass.ch"
#include "tdolphin.ch"

#ifdef __HARBOUR__
//   #include "hbcompat.ch"
#endif

static s_cServer
static s_cUser
static s_cPass
static s_nPort := 3306
static s_cDBName
static s_nFlags


MEMVAR oServer


function main()
    Local oWnd, oTreeView,  cGlade, oBtn
    Local cSql := [ select i.id as ticket, h.nombre as Establecimiento, i.asunto, fecha , p.nombre as prioridad,  s.nombre as estado,   u.nombre as "usuario asignado" from incidencias i  ]+;
                  [ left join usuarios u on i.id_user_asignado = u.id ]+;
                  [ left join establecimientos h on i.id_establecimiento = h.id          ]+;
                  [ left join status s  on i.id_status = s.id         ]+;
                  [ left join prioridad p on i.id_prioridad = p.id    ]+;
                  [ order by p.orden ] 

    PUBLIC oServer

    oServer := Autentificacion()

    if oServer != NIL
       SET RESOURCES cGlade FROM FILE "dolphin.glade" ROOT "wnd_incidencias"

       DEFINE WINDOW oWnd ID "wnd_incidencias" RESOURCE cGlade
           
           DEFINE BUTTON oBtn ID "refresh_incidencia" RESOURCE cGlade ACTION SetQuery( oTreeView, cSql )
           DEFINE BUTTON oBtn ID "add_incidencia"     RESOURCE cGlade ACTION Add_Incidencia( oTreeView )


            DEFINE TOOLMENU  ACTION Mnt_Establecimientos() ;
                             MENU  Build_Menu_Mnt()  ID "toolbtn_menu" RESOURCE cGlade

            DEFINE TOOLMENU  ACTION MsgInfo("Normal") ;
                             MENU  BUILD_MENU_Status()  ID "toolbtn_status" RESOURCE cGlade
                


           DEFINE TREEVIEW oTreeView ID "tree_incidencias" RESOURCE cGlade  
           oTreeView:SetRules( .T. )
           SetQuery( oTreeView, cSql ) 

       ACTIVATE WINDOW oWnd INITIATE

     // Forma partiendo de una ventana
    /*   DEFINE WINDOW oWnd TITLE "T-HELPDESK" SIZE 800,600

             oMante := GMante():New( oWnd, oServer )
             oMante:BtnAction( "add",  {|| MsginFo( "Add" ) } )
             oMante:BtnAction( "edit", {|| MsginFo( "Ediccion" ) } )
             oMante:BtnAction( "del",  {|| MsginFo( "Borrar" ) } )
             oMante:SetQuery( "SELECT * from categorias" )
             // Vamos a coger los valores de las columnas, se pasa path y col desde el evento
             // oMante:oTreeView:bRow_Activated := { |path,col| Comprueba( oMante, path, col) }
             oMante:SetRowActivated( { |path,col| Comprueba( oMante, path, col) } )

       ACTIVATE WINDOW oWnd INITIATE CENTER
      */

    endif

return nil


Function SetQuery( oTreeView, cQuery ) 
  Local n , oLbx, x , y , oCol , aIter := Array( 4 ), j , nLen
  Local nOld_Fields := oTreeView:GetTotalColumns() // Informa del numero de columnas
  Local oQry, aRes, nFld, Atmp, oError, cValue


  if empty( oServer:cDBName ) .or. empty( cQuery )
     return .f.
  endif

TRY
    oQry := TDolphinQry():New( cQuery, oServer )
CATCH oError
    MsgStop( oError:Description, "Alerta" )
    return .f.
END

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

  oTreeView:SetModel( oLbx ) // Asignamos nuevo modelo de datos a la vista
  View_Incidencia( oTreeView, oQry )

  // Liberamos el objeto Query
  oQry:End()

RETURN NIL



//-----------------------------------------------------------------------------
// Conexion MySql a traves de Dolphin de Daniel
//-----------------------------------------------------------------------------
function Autentificacion()
    Local oWnd, cGlade, oBtn, oBox, oLabelInf, oServer, oCheck

    // Carga posible configuracion del ini
    Load_Conf_Ini()

    SET RESOURCES cGlade FROM FILE "dolphin.glade" ROOT "autentificacion"


    DEFINE WINDOW oWnd ID "autentificacion" RESOURCE cGlade
            DEFINE ENTRY VAR s_cUser      ID "entry_user"     RESOURCE cGlade
            DEFINE ENTRY VAR s_cPass      ID "entry_pass"     RESOURCE cGlade
            DEFINE ENTRY VAR s_cServer    ID "entry_server"   RESOURCE cGlade
            DEFINE SPIN  VAR s_nPort      ID "spin_port"      RESOURCE cGlade
            DEFINE ENTRY VAR s_cDBName    ID "entry_bd"       RESOURCE cGlade
            DEFINE LABEL oLabelInf        ID "information"    RESOURCE cGlade

            DEFINE BUTTON oBtn ID "btn_access" RESOURCE cGlade;
                          ACTION ( oBtn:Disable(),;
                                   IF( !empty( oServer := Connect_Db( oLabelInf )),( oWnd:End() ), ),;
                                   oBtn:Enable() )

            DEFINE BUTTON ID "btn_cancel" RESOURCE cGlade;
                          ACTION ( oWnd:End() )


    ACTIVATE WINDOW oWnd


RETURN oServer

//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------
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

//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------
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

STATIC FUNCTION BUILD_MENU_MNT()
 Local oMenu
  
  DEFINE MENU oMenu
     MENUITEM TITLE "Cadena"         ACTION Mnt_Cadena()        OF oMenu
     MENUITEM TITLE "Establecimientos" ACTION Mnt_Establecimientos() OF oMenu
     MENUITEM TITLE "Categorias"     ACTION Mnt_Categoria()     OF oMenu
     MENUITEM TITLE "Departamentos"  ACTION Mnt_Departamentos() OF oMenu
     MENUITEM TITLE "Status"         ACTION Mnt_Status()        OF oMenu
     MENUITEM TITLE "Tipos conexión" ACTION Mnt_TiposConexion() OF oMenu
     MENUITEM TITLE "Usuarios"       ACTION Mnt_Usuarios()      OF oMenu
//     MENU SEPARATOR  OF oMenu
     MENU SEPARATOR  OF oMenu
     MENUITEM IMAGE FROM STOCK GTK_STOCK_HOME ACTION MsgStop( "Image...oh" ) OF oMenu

RETURN oMenu

/* 
TODO:// Falta seleccionarlos dinamicamente desde la BD
Montamos Estados en el menu */
STATIC FUNCTION BUILD_MENU_Status()
 Local oMenu
  
  DEFINE MENU oMenu
     MENUITEM TITLE "NORMAL"         ACTION Msginfo("Normal")  OF oMenu
     MENUITEM TITLE "BAJA"           ACTION Msginfo("Baja")    OF oMenu
     MENUITEM TITLE "ALTA"           ACTION Msginfo("Alta")    OF oMenu
     MENUITEM TITLE "URGENTE"        ACTION Msginfo("Urgente") OF oMenu

RETURN oMenu


**************************************************************************
**************************************************************************
// Vamos a montar las columnas de la vista principal... personalizadas
// Podriamos poner un FOR...NEXT, pero estamos 'jugando'....
STATIC FUNCTION View_Incidencia( oTreeView, oQry )
     Local oCol, oImage, oLabel, oBox

     // Primera columna...Codigo... -----------------------------
     DEFINE TREEVIEWCOLUMN oCol COLUMN 1 TYPE "text" OF oTreeView EXPAND SORT
     oCol:oRenderer:Set_Valist( { "cell-background", "Yellow", ;
                                  "cell-background-set", .t. } )
     oCol:SetAlign( GTK_RIGHT )             // Alineacion del header 
     oCol:oRenderer:SetAlign_H( GTK_RIGHT ) // Alineacion del contenido Horizontal.
     oCol:Connect( "clicked" )
     oCol:bAction := { |o| oTreeView:SetSearchColumn( o:GetSort() ) }

     DEFINE BOX oBox 
           DEFINE IMAGE FILE "./images/codigo.png" OF oBox
           DEFINE LABEL TEXT "<b>NºTicket</b>" MARKUP OF oBox 

     oCol:SetWidgetHeader( oBox )

     // 2 columna. Establecimiento----------------------------------
     DEFINE TREEVIEWCOLUMN oCol COLUMN 2 TYPE "text" WIDTH 200 OF oTreeView  EXPAND SORT
     oCol:Connect( "clicked" )
     oCol:bAction := { |o| oTreeView:SetSearchColumn( o:GetSort() ) }
     oCol:SetResizable( .T. ) 
     oCol:SetAlign( GTK_CENTERED )   // Alineacion del header 
     
     DEFINE BOX oBox 
           DEFINE IMAGE FILE "./images/establecimiento.png" OF oBox 
           DEFINE LABEL TEXT "<b>Establecimiento</b>" MARKUP OF oBox 
     
     oCol:SetWidgetHeader( oBox )

     // 3 columna. Asunto----------------------------------
     DEFINE TREEVIEWCOLUMN oCol COLUMN 3 TYPE "text" WIDTH 400 OF oTreeView  EXPAND SORT
     oCol:Connect( "clicked" )
     oCol:bAction := { |o| oTreeView:SetSearchColumn( o:GetSort() ) }
     oCol:SetResizable( .T. ) 
     oCol:SetAlign( GTK_CENTERED )   // Alineacion del header 
     
     DEFINE BOX oBox //VERTICAL HOMO
           DEFINE IMAGE FILE "./images/info.png" OF oBox 
           DEFINE LABEL oLabel PROMPT '<span foreground="orange" ><b>Incidencia</b> </span>' MARKUP OF oBox
     
     oCol:SetWidgetHeader( oBox )
     
     // Segundo columna. Fecha ------------------------------------
     DEFINE TREEVIEWCOLUMN oCol COLUMN 4 TYPE "text" OF oTreeView EXPAND SORT
     oCol:Connect( "clicked" )
     oCol:bAction := { |o| oTreeView:SetSearchColumn( o:GetSort() ) }
     oCol:SetAlign( GTK_LEFT )             // Alineacion del header 
     oCol:oRenderer:SetAlign_H( GTK_LEFT ) // Alineacion del contenido Horizontal.
     
     DEFINE BOX oBox 
           DEFINE IMAGE FILE "./images/fecha.png" OF oBox
           DEFINE LABEL oLabel TEXT "<b>Fecha Apertura</b>" MARKUP OF oBox
     oCol:SetWidgetHeader( oBox )

     // Columna. Prioridad ------------------------------------
     DEFINE TREEVIEWCOLUMN oCol COLUMN 5 TYPE "text" OF oTreeView EXPAND SORT
     oCol:Connect( "clicked" )
     oCol:bAction := { |o| oTreeView:SetSearchColumn( o:GetSort() ) }
     oCol:SetAlign( GTK_CENTERED )             // Alineacion del header 
     oCol:oRenderer:SetAlign_H( GTK_LEFT ) // Alineacion del contenido Horizontal.
     
     DEFINE BOX oBox 
//           DEFINE IMAGE FILE "./images/fecha.png" OF oBox
           DEFINE LABEL oLabel TEXT "<b>Prioridad</b>" MARKUP OF oBox
     oCol:SetWidgetHeader( oBox )

     // Columna. Estado ------------------------------------
     DEFINE TREEVIEWCOLUMN oCol COLUMN 6 TYPE "text" OF oTreeView EXPAND SORT
     oCol:Connect( "clicked" )
     oCol:bAction := { |o| oTreeView:SetSearchColumn( o:GetSort() ) }
     oCol:SetAlign( GTK_CENTERED)             // Alineacion del header 
     oCol:oRenderer:SetAlign_H( GTK_LEFT ) // Alineacion del contenido Horizontal.
     
     DEFINE BOX oBox 
//           DEFINE IMAGE FILE "./images/fecha.png" OF oBox
           DEFINE LABEL oLabel TEXT "<b>Estado</b>" MARKUP OF oBox
     oCol:SetWidgetHeader( oBox )
    
     // Columna. Usuario Asignado ------------------------------------
     DEFINE TREEVIEWCOLUMN oCol COLUMN 7 TYPE "text" OF oTreeView EXPAND SORT
     oCol:Connect( "clicked" )
     oCol:bAction := { |o| oTreeView:SetSearchColumn( o:GetSort() ) }
     oCol:SetAlign( GTK_CENTERED )             // Alineacion del header 
     oCol:oRenderer:SetAlign_H( GTK_LEFT) // Alineacion del contenido Horizontal.
     
     DEFINE BOX oBox 
           DEFINE IMAGE FILE "./images/user.png" OF oBox
           DEFINE LABEL oLabel TEXT "<b>Usuario asignado</b>" MARKUP OF oBox
     oCol:SetWidgetHeader( oBox )

RETURN NIL


