/* Ejemplo de Combobox con un modelo de datos TreeStore y ComboboxEntry.
   (c)2006 Rafa Carmona
   TODO: Se esta trabajando en ello.
  */

#include "gclass.ch"

#define GtkTreeIter  Array( 4 )

Function Main()

  local oWnd, oLbx, oBox, cVar , oCombo, oCombo3, cVar3
  local oCombo2, cVar2 := "ARA", aItems := { "1-Value","2-Dos","3-Well..." }
  Local oComboChange, cVarChange, oCompletion

  DEFINE WINDOW oWnd TITLE "T-Gtk Combobox TreeStore power!!"
     
   DEFINE BOX oBox VERTICAL SPACING 8 OF oWnd


     DEFINE LABEL PROMPT "Ups! Combobox with Data Model"  OF oBox EXPAND FILL   
     
     
     oLbx := Create_Model()
     
     DEFINE COMBOBOX oCombo VAR cVar ;
            MODEL oLbx ;
            OF oBox  ;
            ON CHANGE ( CambioArray( oComboChange ) )
                     
     DEFINE COMBOBOX ENTRY oCombo2  ;
                 VAR cVar2 ;
                 MODEL oLbx ;
                 OF oBox
                 // ITEMS aItems OF oBox
     
     DEFINE COMBOBOX ENTRY oCombo3  ;
                 VAR cVar3 ;
                 ITEMS aItems OF oBox
     oCompletion := oCombo3:oEntry:Create_Completion( aItems )
     oCompletion:bSelected := {|| MsgInfo( oCombo3:GetValue() ) }
     
     
     
     DEFINE BUTTON oCombo TEXT "VALUE VARIABLE COMBOBOX" ;
            ACTION MsgInfo( "Model: "+ cVar + CRLF +;
                            "Combo_entry:" + cVar2 + CRLF +;
                            "Combo 3 := "  + cVar3  ) OF oBox
     
     DEFINE COMBOBOX oComboChange VAR cVarChange ;
            ITEMS {""} ;
            OF oBox 

     
   ACTIVATE WINDOW oWnd CENTER
 
RETURN NIL         

STATIC FUNCTION Create_Model()
  local oLbx
  local aParent , aChild , aIter
  local x,j, y
  Local aProvincias := { { "Barcelona", "Girona", "Lleida", "Tarragona" },;
                         { "Castellon","Valencia", "Alicante" },;
                         { "Madrid" },;
                         { "A coru�a", "Lugo", "Orense", "Pontevedra" } }
  Local aComunidad := { "Catalu�a", "Valencia", "Madrid", "Galicia" }
  Local aPueblos := { "Bigues i Riells", "Sta.Perpetua de la moguda", "Sant Feliu de Codines" }

  DEFINE TREE_STORE oLbx TYPES G_TYPE_STRING
 
  For x := 1 To Len( aComunidad )
       APPEND TREE_STORE oLbx ITER aParent VALUES UTF_8( aComunidad[x] )
       For j := 1 To Len( aProvincias[x] )
          APPEND TREE_STORE oLbx PARENT aParent ;
                 ITER aChild ;
                 VALUES UTF_8( aProvincias[x,j] )
         
          if x = 1 .and. j = 1 // Solamente para Barcelona
             For y := 1 To Len( aPueblos )
                  APPEND TREE_STORE oLbx PARENT aChild ;
                         ITER aIter ;
                         VALUES UTF_8( aPueblos[y] )
             Next
          Endif   
       Next
  Next

 Return oLbx

 STATIC FUNCTION CAMBIOARRAY( oCombo )
     Local aArray1 := { "1","2","3" }
     Local aArray2 := { "4","5","6" }
     Local aArray3 := { "1","2","3", "4","5","6" }

     STATIC nCount := 0

     oCombo:RemoveAll()
     
     nCount++
     if nCount > 3
        nCount := 1
     endif
   
     if nCount = 1
        oCombo:SetItems( aArray1 )
     endif
     
     if nCount = 2
        oCombo:SetItems( aArray2 )
     endif
     
     if nCount = 3
        oCombo:SetItems( aArray3 )
     endif

RETURN NIL



