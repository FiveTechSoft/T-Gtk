/*
 Ejemplo de gKey desde Federico de Maussion 
*/
#include "gclass.ch"

function main()
  Local oWnd,oLabel
  Local oBox, oBox1
  Local oBook
  Local aFields, oKeyS

  DEFINE WINDOW oWnd TITLE "Tree of T-Gtk" SIZE 600,300

    DEFINE BOX oBox VERTICAL OF oWnd
    DEFINE LABEL oTitu PROMPT "Prueba de la clase PCKEY" OF oBox

    DEFINE NOTEBOOK oBook OF oBox EXPAND FILL

      DEFINE BOX oBox1 VERTICAL EXPAND FILL
        DEFINE LABEL oTitu PROMPT "Linea Simple"
        oBook:Append( oBox1, oTitu )
        /*Modelo de Datos */
        DEFINE LIST_STORE oLbx TYPES G_TYPE_STRING, G_TYPE_STRING, G_TYPE_STRING, G_TYPE_STRING, G_TYPE_STRING, G_TYPE_STRING
        DEFINE SCROLLEDWINDOW oScroll  OF oBox1 EXPAND FILL ;
              SHADOW GTK_SHADOW_ETCHED_IN

              oScroll:SetPolicy( GTK_POLICY_AUTOMATIC, GTK_POLICY_AUTOMATIC )

        /* Browse/Tree */
        DEFINE TREEVIEW oTreeView MODEL oLbx OF oScroll CONTAINER
        oTreeView:SetRules( .T. )
        aTit := { "Código", "Empresa", "CUIT", "Direccion", "Cód. Muni.", "Cód. Rent."}
        // Vamos a coger los valores de las columnas, se pasa path y col desde el evento
        oTreeView:bRow_Activated := { |path,col| MsgInfo( "As presionado Enter" ) }

        For x=1 to Len(aTit)
          DEFINE TREEVIEWCOLUMN oCol COLUMN x TITLE Utf_8(aTit[x])  TYPE "text" OF oTreeView EXPAND SORT
            oCol:Connect( "clicked" )
            oCol:bAction := { |o| oTreeView:SetSearchColumn( o:GetSort() ) }
            oCol:SetResizable( .T. ) //TODOS van a ser resimensionables
        Next

        for x=1 to 10
          oLbx:Append( { alltrim(Str(x)), ;
                         "Prueba           ",;
                         "22-22222222-2",;
                         "Estados Unidos 3030",;
                         "2222-3333333",;
                         "2222-3333333" } )
        Next

        DEFINE KEY oKey OF oTreeView

        KEY  GDK_F1  ACTION MsgInfo( "As presionado F1" ) OF oKey
        KEY  GDK_F2  ACTION MsgInfo( "As presionado F2" ) OF oKey
        KEY  GDK_F7  ACTION MsgInfo( "As presionado F7" ) OF oKey
        KEY  GDK_Delete  ACTION MsgInfo( "As presionado Delete" ) OF oKey

        DISPLAY KEY oKey F1 " Ayuda " ;
                         F2 " Alta " ;
                         F7 " Buscar " ;
                         OF oBox1

        oTreeView:SetFocus()

//--------------------------------------
      DEFINE BOX oBox1 VERTICAL EXPAND FILL
        DEFINE LABEL oTitu PROMPT "Linea Doble"
        oBook:Append( oBox1, oTitu )
        /*Modelo de Datos */
        DEFINE LIST_STORE oLbx TYPES G_TYPE_STRING, G_TYPE_STRING, G_TYPE_STRING, G_TYPE_STRING, G_TYPE_STRING, G_TYPE_STRING
        DEFINE SCROLLEDWINDOW oScroll  OF oBox1 EXPAND FILL ;
              SHADOW GTK_SHADOW_ETCHED_IN

              oScroll:SetPolicy( GTK_POLICY_AUTOMATIC, GTK_POLICY_AUTOMATIC )

        /* Browse/Tree */
        DEFINE TREEVIEW oTreeView MODEL oLbx OF oScroll CONTAINER
        oTreeView:SetRules( .T. )
        aTit := { "Código", "Empresa", "CUIT", "Direccion", "Cód. Muni.", "Cód. Rent."}
        // Vamos a coger los valores de las columnas, se pasa path y col desde el evento
        oTreeView:bRow_Activated := { |path,col| MsgInfo( "As presionado Enter en el tree 2" ) }

        For x=1 to Len(aTit)
          DEFINE TREEVIEWCOLUMN oCol COLUMN x TITLE Utf_8(aTit[x])  TYPE "text" OF oTreeView EXPAND SORT
            oCol:Connect( "clicked" )
            oCol:bAction := { |o| oTreeView:SetSearchColumn( o:GetSort() ) }
            oCol:SetResizable( .T. ) //TODOS van a ser resimensionables
        Next

        for x=1 to 10
          oLbx:Append( { alltrim(Str(x)), ;
                         "Prueba 2          ",;
                         "22-22222222-2",;
                         "Estados Unidos 3030",;
                         "2222-3333333",;
                         "2222-3333333" } )
        Next

        DEFINE KEY oKey OF oTreeView

        KEY  GDK_F1  ACTION MsgInfo( "As presionado F1 en el tree 2" ) OF oKey
        KEY  GDK_F3  ACTION MsgInfo( "As presionado F3 en el tree 2" ) OF oKey
        KEY  GDK_F7  ACTION MsgInfo( "As presionado F7 en el tree 2" ) OF oKey
        KEY  GDK_Delete  ACTION MsgInfo( "As presionado Delete en el tree 2" ) OF oKey

        DISPLAY KEY oKey F1 " Ayuda " ;
                         F3 " Alta " ;
                         F7 " Buscar " ;
                         DOBLELINE OF oBox1

        oTreeView:SetFocus()

   ACTIVATE WINDOW oWnd CENTER


return nil

