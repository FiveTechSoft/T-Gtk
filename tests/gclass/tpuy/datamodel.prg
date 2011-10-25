/* $Id: main.prg,v 1.0 2008/10/23 14:44:02 riztan Exp $ */

/*
﻿  Copyright © 2009  Rafa Carmona
﻿  Copyright © 2009  Riztan Gutierrez

   Este programa es software libre: usted puede redistribuirlo y/o modificarlo
   conforme a los términos de la Licencia Pública General de GNU publicada por
   la Fundación para el Software Libre, ya sea la versión 3 de esta Licencia o
   (a su elección) cualquier versión posterior.

   Este programa se distribuye con el deseo de que le resulte útil, pero
   SIN GARANTÍAS DE NINGÚN TIPO; ni siquiera con las garantías implícitas de
   COMERCIABILIDAD o APTITUD PARA UN PROPÓSITO DETERMINADO. Para más información,
   consulte la Licencia Pública General de GNU.

   http://www.gnu.org/licenses/
*/

/** \file datamodel.prg.
 *  \brief Programa de funciones para tpuy (derivado de listore en t-gtk)  
 *  \author Riztan Gutierrez. riztan (at) gmail (dot) com
 *  \date 2009
 *  \remark ...
*/

/*
 *  El uso efectivo del listore, debe ser al estilo GDA.  
 *  creamos un objeto data_model  y a ese objeto se le puede aplicar
 *  el listore.
*/

/* Se incorpora utilizacion de una tabla con informacion de campos.
 * Si se incluye un query y una conexion en los parámetros al crear un
 * un modelo de datos.
 */

//#include "tepuy.ch"
#include "proandsys.ch"
#include "xhb.ch"
//#include "common.ch"
#include "gclass.ch"
#include "hbclass.ch"
#include "pc-soft.ch"

//#define GTK_STOCK_EDIT      "gtk-edit"

memvar oTpuy

#define GtkTreeIter  Array( 4 )

/*
CLASS GLISTSTORE FROM GOBJECT
      DATA aTypes

      METHOD New( aTypes )
      METHOD NewAuto( aTypes )
      METHOD Append( aValues )
      METHOD Insert( nRow, aValues )
      METHOD Set( aIter, nCol, uValue )
      METHOD Clear() INLINE gtk_list_store_clear( ::pWidget )
      METHOD Remove( aIter ) INLINE gtk_list_store_remove( ::pWidget, aIter )

ENDCLASS
*/
/*
#xcommand DEFINE TPY_DATA_MODEL [ <oModel> ];
               [ MIME <cMime> ] ;
               [ <lNoShowLines: NOSHOWLINES> ] ;
               [ <lReadOnly: READONLY> ] ;
               [ OF <oParent> ] ;
               [ VAR <uVar> ];
               [ <lExpand: EXPAND> ] ;
               [ <lFill: FILL> ] ;
               [ PADDING <nPadding> ];
               [ <lContainer: CONTAINER> ] ;
               [ POS <x>,<y>  ];
               [ ID <cId> ;
               [ RESOURCE <uGlade> ] ];
               [ SIZE <nWidth>, <nHeight> ] ;
               [ LABELNOTEBOOK <uLabelBook> ];
               [ <lEnd: INSERT_END> ] ;
               [ <lSecond: SECOND_PANED > ] ;
               [ <lResize: RESIZE > ] ;
               [ <lShrink: SHRINK > ] ;
               [ TABLEATTACH <left_ta>,<right_ta>,<top_ta>,<bottom_ta>[,<xOptions_ta>, <yOptions_ta> ] ] ;
       => ;
 [ <oMemo> := ] gSourceView():New( <cMime>, <.lNoShowLines.> , bSetGet( <uVar> ), <.lReadOnly.>, [<oParent>],;
                <.lExpand.>, <.lFill.>, <nPadding>,;
                <.lContainer.>,<x>, <y>, <cId>, <uGlade>, <uLabelBook>, <nWidth>, <nHeight>,<.lEnd.>,;
                <.lSecond.>, <.lResize.>, <.lShrink.>, <left_ta>,<right_ta>,<top_ta>,<bottom_ta>,;
                <xOptions_ta>, <yOptions_ta> )
*/                


CLASS TPY_DATA_MODEL FROM TPUBLIC

      DATA oTreeView
      DATA oLbx
      DATA aIter
      DATA oConn
      DATA oQuery
      DATA lQuery            INIT .F.
      DATA lListore          INIT .F.
      DATA cPreQryUpdate     INIT ""
      DATA aPreQryInsert     INIT {}
      DATA aItems            INIT {}
      DATA aStruct           INIT {}
      DATA aDMStru           INIT {}
      DATA aActions          INIT {}
      DATA aTypes
      DATA hModel
      
      DATA aValiders
      
      DATA aMsgScroll   INIT { SCROLL_AUTOMATIC, SCROLL_ALWAYS, SCROLL_NEVER }
      DATA nScrollH     INIT 1
      DATA nScrollV     INIT 1

      METHOD New( oConn, xQuery, aStruct, aItems, aActions, aValiders )
      METHOD Listore( oBox, oListBox )
      METHOD ListoreWnd( )
      METHOD Run( col, cArray, ... )
//      METHOD Edit()
//      METHOD NewAuto( aTypes )
//      METHOD Append( aValues )
//      METHOD Insert( nRow, aValues )
      METHOD Set( aItems, xCol, uValue, aError )
      METHOD GetTables( aItems, cSchema )
      METHOD Insert( aItems )
//      METHOD Clear() INLINE gtk_list_store_clear( ::pWidget )
//      METHOD Remove( aIter ) INLINE gtk_list_store_remove( ::pWidget, aIter )
      METHOD SetFromDBF( uValue )
      METHOD GetPosRow()
      METHOD GetCol( cCol )
      METHOD ColSet( cField, nPos, uValue )
      METHOD ColDisable(cField)
ENDCLASS



METHOD New( oConn, xQuery, aStruct, aItems, aActions, aValiders ) CLASS TPY_DATA_MODEL

//      ::hModel := hModel
//      ::pWidget  := gtk_list_store_newv( Len( ::aTypes ) ,::aTypes  )

   Local cBaseFields, nFields, nLenStru
   Local y, nColumn, cWhere, cQuery //, oConsul,aDMStru
   Local aField

   Default aItems   := {}
   Default aStruct  := {}
   Default aActions := {}
   Default aValiders:= {}

   ::aStruct  := aStruct
   ::aItems   := aItems
   ::aActions := aActions
   ::aValiders:= aValiders
//    ::aIter    := GtkTreeIter

   ::hVars := Hash()

   If HB_ISNIL( oConn ) .AND. HB_ISOBJECT( oTpuy:oConn )
//? "Estableciendo conexion por defecto..."
// Deberia registrar en un log en este momento...
      oConn := oTpuy:oConn
   Endif

   If HB_ISOBJECT( xQuery )
      ::oConn  := oConn
      ::oQuery := xQuery
      ::lQuery := .T.
      //::aDMStru:= AClone(::aStruct)   (no es necesaria esta linea por ahora)
      ::aItems := xQuery:aData
      ::aStruct:= xQuery:aStruct

   ElseIf  HB_ISOBJECT( oConn ) .AND. ValType(xQuery)=="C"
      ::oConn  := oConn
      ::oQuery := oConn:Query(xQuery)
      ::lQuery := .T.
      ::aItems := ::oQuery:aData
      ::aStruct:= ::oQuery:aStruct

   EndIf
    
   ::aIter := ARRAY( LEN(::aItems) )

   If ::lQuery .AND. HB_ISOBJECT(::oQuery)

      If ::oConn:ViewExists( "v_base_fields"  )
         cBaseFields := ::oConn:Schema+".v_base_fields"
      Else
         cBaseFields := oTpuy:cMainSchema+"base_fields"
      EndIf

      nLenStru  := Len(::aStruct)
      nFields := ::oConn:Query("select * from "+cBaseFields+" limit 1" ):nFields

      ::aDMStru := ARRAY( nLenStru, nFields+Len(::aStruct[1]) )
      
      If nLenStru==Len(::oQuery:aStruct)
      
         //Generando nombre de campos a partir
         //de la tabla que tiene tal información

         y := 1
         For nColumn := 1 To nLenStru

            cWhere := "where flds_name = "+DataToSQL(::aStruct[nColumn,1])+;
                      " and (information_schema.tables.table_schema = "+;
                      DataToSQL(::oConn:Schema)+" or "+;
                      " information_schema.tables.table_schema = 'tepuy') and "+;
                      cBaseFields+".flds_table_name=information_schema.tables.table_name "+;
                      "limit 1"

            cQuery := "select * from "+cBaseFields+", "+;
                      "information_schema.tables "+cWhere

            //oConsul:= ::oConn:Query( cQuery )

#define FLD_DESCRIP    ::oForm:aFields[y,1 ]
#define FLD_NAME       ::oForm:aFields[y,2 ]
#define FLD_EDITABLE   ::oForm:aFields[y,3 ]
#define FLD_VIEWABLE   ::oForm:aFields[y,4 ]
#define FLD_NAVIGABLE  ::oForm:aFields[y,5 ]
#define FLD_PICTURE    ::oForm:aFields[y,6 ]
#define FLD_DEFAULT    ::oForm:aFields[y,7 ]
#define FLD_REFERENCE  ::oForm:aFields[y,8 ]
#define FLD_REFTABLE   ::oForm:aFields[y,9 ]
#define FLD_REFSCRIPT  ::oForm:aFields[y,12]
#define FLD_BOXNAME    ::oForm:aFields[y,13]

            cQuery := "select flds_description, flds_name, flds_editable, "
            cQuery +=        "flds_viewable, flds_navigable, flds_picture, "
            cQuery +=        "flds_default, "
            cQuery +=        "flds_reference, flds_ref_table_name, flds_ref_field_link, "
            cQuery +=        "flds_ref_field_descriptor, flds_ref_scriptname, "
            cQuery +=        "flds_box_parent_name "
            cQuery += "from "+cBaseFields+",information_schema.tables "
            cQuery += cWhere

            FOR EACH aField IN ::oConn:Query(cQuery):aData
               AEVAL(aField, {|item,n| ::aDMStru[nColumn,n] := item } )               
            NEXT

         Next nColumn

      EndIf

   Else

      nLenStru  := Len(::aStruct)
      //nFields := ::oConn:Query("select * from "+cBaseFields+" limit 1" ):nFields
      ::aDMStru := ARRAY( nLenStru, Len(::aStruct[1]) )

   EndIf

RETURN Self


METHOD SetFromDBF( uValue ) CLASS TPY_DATA_MODEL

   Local cType := ValType( uValue )
   Local lError := .F., lFile := .F.
   Local nCount, aField, nField, aStruct, aItems
   
   IF cType ="N" .AND. (uValue)->(USED())
//      View( "Intentando abrir "+ CStr(uValue) )
      DBSELECTAREA(uValue)
   
   ELSEIF( cType = "C" )
   
      IF SELECT(uValue)>0
//         View( "Area "+CStr(SELECT(uValue)) )
         SELECT SELECT(uValue)
      ELSE
         IF FILE( uValue )
//            View( "Es un Archivo "+uValue )
            lFile := .T.
            USE &uValue
         ELSE
            lError := .T.
         ENDIF
      ENDIF
   ELSE
      lError := .T.
   ENDIF
   
   IF lError
      MsgStop("ERROR")
      Return NIL
   ENDIF


   aStruct := DbStruct()

   aItems := ARRAY( RECCOUNT(), LEN(aStruct) )

   GO TOP
   nCount := 1
   WHILE !EOF()

      FOR EACH aField IN aStruct
          nField := HB_EnumIndex()
          aItems[nCount, nField] := FieldGet( nField )
      NEXT
      nCount++

      SKIP

   ENDDO

   IF lFile
      USE
   ENDIF
   ::aStruct := aStruct
   ::aItems  := aItems

Return Self



METHOD GetPosRow() CLASS TPY_DATA_MODEL
   IF !Empty(::aItems)
      Return ::oTreeView:GetPosRow( ::aIter )
   ENDIF
RETURN 0



METHOD GetCol( cCol ) CLASS TPY_DATA_MODEL
   Local uRes, cRow, nPosCol
   Local pPath, aIter := GtkTreeIter

   cRow     := ALLTRIM( CSTR(::GetPosRow()-1) )
   pPath := gtk_tree_path_new_from_string( cRow )

   nPosCol := ::oTreeView:GetPosCol( cCol )
   uRes := AllTrim( CSTR(::oTreeView:GetValue( nPosCol, "", pPath, @aIter )) )
Return uRes



METHOD ColSet(cField,nPos,uValue)  CLASS TPY_DATA_MODEL

   Local aField
   
   Default uValue:=""  
   
   IF ValType( nPos )="N" .AND. nPos>0

      FOR EACH aField IN ::aDMStru

         IF aField[1] = cField .OR.;
            aField[2] = cField
            aField[nPos] := uValue
            Return .T.
         ENDIF

      NEXT
   
   ENDIF

Return .F.



METHOD ColDisable(cField)  CLASS TPY_DATA_MODEL

   Local aField

   FOR EACH aField IN ::aDMStru

      IF aField[1] = cField .OR.;
         aField[2] = cField
         aField[3] := .f.
         aField[4] := .f.
         aField[5] := .f.
         Return .T.
      ENDIF

   NEXT
   
Return .F.



METHOD Listore( oBox, oListBox ) CLASS TPY_DATA_MODEL

  Local oScroll, n
  Local oCol, aTypes, aStruct, aItems, oTemp
  Local cType //, nMin, nWidth
  Local nLenStru
  Local cValTmp,nColumn

  If HB_ISNIL( oBox )
     Return NIL
  EndIf
                    
//   If Empty(::aItems) .OR. Empty(::aStruct)
   If Empty(::aStruct)
   
      MsgStop("Arreglo de Estructura o Items, está vacio.", "PROBLEMAS!!")
      Return Self
   Else
      aItems    := ::aItems
      aStruct   := ::aStruct
      nLenStru  := Len(aStruct)
   EndIf

   aTypes  := ARRAY( LEN( aStruct ) )
   
   If HB_ISARRAY( aStruct[1] )
      Aeval( aStruct , { | row, n | aTypes[n] := StruToGType(row) }  )
   EndIf

   /*Modelo de Datos */
   //DEFINE TREE_STORE ::oLbx ARRAY aTypes
   DEFINE LIST_STORE ::oLbx TYPES aTypes

   For nColumn := 1 To Len( aItems )
       APPEND LIST_STORE ::oLbx ITER ::aIter

       for n := 1 to Len( aItems[ nColumn ] )
          If aStruct[n,2] == "D"
             //-- Transformamos a Formato definido en tepuy.ch
             If HB_ISDATE(aItems[nColumn,n])
                cValTmp := DTOC(aItems[nColumn,n])
             Else
                cValTmp := TPY_DATEFORMAT   
                cValTmp := strtran( cValTmp, 'dd', substr(CStr(aItems[nColumn,n]), 9, 2) )
                cValTmp := strtran( cValTmp, 'mm', substr(CStr(aItems[nColumn,n]), 6, 2) )
                cValTmp := strtran( cValTmp, 'yyyy', left(CStr(aItems[nColumn,n]), 4) )
             EndIf
          Else
             cValTmp := aItems[nColumn,n]

             If LEN( ::aDMStru[n] ) < 6
                //cValTmp := TRANSFORM(  )
                If aStruct[n,2]== "C" 
                   cValTmp := aItems[nColumn,n]
                ElseIf aStruct[n,2] == "N"
                   cValTmp := CStr(aItems[nColumn,n])
                ElseIf aStruct[n,2] == "L"
                   //cValTmp := IIF(aItems[nColumn,n],"true","false")
                   cValTmp := aItems[nColumn,n]
                EndIf
//? aStruct[n,2],"  ",cValTmp 
             Else
                If !HB_ISNIL(::aDMStru[n,6])

                   If LEN(::aDMStru[n,6])==1
                      If aStruct[n,2]== "C" .OR. aStruct[n,2]=="N"

                        cValTmp := TRANSFORM( aItems[nColumn,n],;
                                   Repl(::aDMStru[n,6], aStruct[n,3]) )
                      EndIf
 
                   Else
                      cValTmp := TRANSFORM( Val(aItems[nColumn,n]), ::aDMStru[n,6] )
                   EndIf
                
                EndIf

             EndIf

          EndIf
          SET LIST_STORE ::oLbx ITER ::aIter POS n VALUE cValTmp
          //SET VALUES LIST_STORE ::oLbx ITER ::aIter VALUES aItems[nColumn]
       next
   Next
   
   DEFINE SCROLLEDWINDOW oScroll  OF oBox EXPAND FILL ;
          SHADOW GTK_SHADOW_ETCHED_IN
              
   /* Scroll automatico vertical y horizontal */
   oScroll:SetPolicy( GTK_POLICY_AUTOMATIC, GTK_POLICY_AUTOMATIC )
        
   /* Browse/Tree */
   DEFINE TREEVIEW ::oTreeView MODEL ::oLbx OF oScroll CONTAINER
   ::oTreeView:SetRules( .T. )            
      
   //::oTreeView:SetSearchColumn( 4 ) /* Determinamos por cual columna vamos a buscar */
   oCol := ARRAY(nLenStru)

   // Vamos a coger los valores de las columnas, se pasa path y col desde el evento
   //     ::oTreeView:bRow_Activated := { |path,col| Comprueba( ::oTreeview, path, col ) }


   For nColumn=1 to nLenStru
   
     if LEN( ::aDMStru[nColumn] ) < 6
         If aStruct[nColumn,2] == "L"
            cType := "active"
         Else
            cType := "text"       
         EndIf

         oTemp := oCol[nColumn]
//? aStruct[nColumn,1]
         DEFINE TREEVIEWCOLUMN oTemp COLUMN nColumn TITLE aStruct[nColumn,1] ;
                TYPE cType SORT OF ::oTreeView
         if aStruct[nColumn,2] == "L"
               /* Indicamos la accion a ejecutar al click de la fila.*/
               oTemp:oRenderer:bAction := {| o, cPath| fixed_toggled( o, cPath, ::oTreeview, ::oLbx ) }
         endif

         oTemp:SetResizable( .T. )

         ::oTreeView:bRow_Activated := oListBox:bEdit
         oCol[nColumn] := oTemp

     else
      IF !HB_ISNIL(::aDMStru[nColumn,5])
         If aStruct[nColumn,2] == "L"
            cType := "active"
/*
            If !Empty(::aDMStru[nColumn,1])
               nMin := LEN( Alltrim(::aDMStru[nColumn,1]) )
            Else
               nMin := LEN( Alltrim(aStruct[nColumn,1]) )
            EndIf
*/
            //nWidth := IIF( (nMin * 10) <= 50 , 50 , nMin * 10 )            
         Else
            cType := "text"       
/*
            If !Empty(::aDMStru[nColumn,1])
               //view(::aDMStru[nColumn])
               //view(aStruct[nColumn])
               nWidth := Max( aStruct[nColumn,3]/1.5 , Len(::aDMStru[nColumn,1]) )
               nWidth := IIF( nWidth*7.5 <= 80 , 80 , nWidth*7.5 )
            Else
               nWidth := IIF( ( Len(aStruct[nColumn,1]) * 10) <= 80 , ;
                                     80 , Len(aStruct[nColumn,1]) * 10 )
            EndIf
*/
         EndIf
          
         oTemp := oCol[nColumn]
         If !Empty(::aDMStru[nColumn,1])
            DEFINE TREEVIEWCOLUMN oTemp COLUMN nColumn TITLE ::aDMStru[nColumn,1] ;
                   TYPE cType SORT OF ::oTreeView
         Else
            DEFINE TREEVIEWCOLUMN oTemp COLUMN nColumn TITLE aStruct[nColumn,1] ;
                   TYPE cType SORT OF ::oTreeView
         EndIf
         oTemp:SetResizable( .T. )
//       oTemp:SetClickable( .T. )

         //-- si no es navegable.. no debe aparecer.
         If !::aDMStru[nColumn,5]
            oTemp:SetVisible( .f. )
         EndIf

         /* Como podemos hacer que se ponga la columna de busqueda igual a la ordenada*/
         oTemp:Connect( "clicked" )
         oTemp:bAction := { |o| ::oTreeView:SetSearchColumn( o:GetSort() ) }


         DO CASE
            CASE aStruct[nColumn,2] == "L"
               /* Indicamos la accion a ejecutar al click de la fila.*/
//               oTemp:oRenderer:bAction := {| o, cPath| fixed_toggled( o, cPath, ::oTreeview, ::oLbx ) }
//               oTemp:oRenderer:bValid  := {| o, cPath| ::Run( o:nColumn+1 , "valid", cPath )}
                
            CASE aStruct[nColumn,2] == "C"
/* -- por ahora no.         
               oTemp:oRenderer:SetEditable(.T.)
*/
               // Conecta señal que indica que se va a disparar ANTES de editar.
/* -- por ahora no.            
               oTemp:oRenderer:Connect( "editing-started" )  
               oTemp:oRenderer:bOnEditing_Started := {|o| ::Run( o:nColumn+1 ) }
                
               oTemp:oRenderer:bValid  := {| o, cPath, cTextNew| ;
                                             ::Run( o:nColumn+1 , "valid", cPath, cTextNew )}

               oTemp:oRenderer:bEdited := {| o, cPath, cTextNew| ;
                                             change_text( o, cPath, ::oTreeview, ::oLbx, cTextNew )}
*/                                          
//                                             change_text( o, cPath, ::oTreeview, ::oLbx, cTextNew )}

//         oTemp:oRenderer:Connect( "editing-canceled" )  // Conecta señal que indica que se a cancelado con ESC   
//         oTemp:oRenderer:bOnEditing_Canceled := {|| MsgInfo("SE CANCELA!") }

            OTHER
              //::oTreeView:bRow_Activated := { |path,col| Comprueba( ::oTreeview, path, col ) }
         END CASE

//         ::oTreeView:bRow_Activated := { |path,col| Comprueba( ::oTreeview, path, col ) }

         //-- Hacemos que doble clic active el bloque de codigo para el boton "editar".
         ::oTreeView:bRow_Activated := oListBox:bEdit
   
         oCol[nColumn] := oTemp

      ENDIF       
     endif
   Next nColumn

//   ::aDMStru := aDMStru
   ::oTreeView:SetAutoSize()

   //::oTreeView:SetFocus()
   
   ::lListore := .t.

Return Self




METHOD ListoreWnd() CLASS TPY_DATA_MODEL
Return Self



METHOD Run( col, cArray , ... )
   Local uValue, aArray, lRet
   
   Default col := 0
   Default cArray := "ACTION"
   
//   Default uParam1:=NIL, uParam2:=NIL, uParam3:=NIL, uParam4:=NIL, uParam5:=NIL
   
   
   cArray := Alltrim(UPPER(cArray))

   Do Case

      Case cArray = "EDITED"
           aArray := ::aEdited
           
      Case cArray = "VALID"
           aArray := ::aValiders
           
      Case cArray = "ACTION"
           aArray := ::aActions
           
   End Case
   
   If !col > 0 .OR. Empty(aArray) .OR. col > Len(aArray)
      Return .F.
   EndIf
   
   uValue := aArray[col]
   
   If HB_ISBLOCK(uValue)
      lRet := Eval(uValue, ... )
   Else
      lRet := oTpuy:RunText( uValue )
   EndIf

   If ValType(lRet) != "L"
      //MsgStop("El proceso o codebloc debe retornar valor logico", "problemas")
      lRet := .F.
   EndIf

RETURN lRet


/*
 *  Actualizacion del Modelo y Base de Datos si hay una conexion y query.
 *
 *  aItems:  
 *    1. Nombre del Campo
 *    2. Valor Actual
 *    3. Valor Anterior
 *    4. Tipo de DATO (C,N,L,D,etc)
 */
METHOD SET( aItems, xCol, uValue, aError ) CLASS TPY_DATA_MODEL
   Local n, oExecute, cQuery,cQuery2:=""
   Local nCol
   Local xValue
   Local nCont := 1
   Local lChanged := .F.
   Local aTables

   DEFAULT xCol   := 1
//   DEFAULT uValue := "No Value"
   DEFAULT aError := ARRAY(1)

   //-- Primero, si tenemos conexion a BD... intentamos actualizar.
   If ::lQuery .AND. !Empty(aItems)
   
      aTables:= ::GetTables(aItems)
      
      If Len(aTables[1]) = 1
      
         //Hora de hacer UPDATE!!
         cQuery := "UPDATE "+Alltrim(::oConn:Schema)+"."
         cQuery += Alltrim(aTables[1,1])+" SET "

//View( aItems )
         For n=1 to Len( aItems[2] )

//            aItems[1,n] := CStr(aItems[1,n])
//            aItems[2,n] := CStr(aItems[2,n])
            aItems[3,n] := CStr(aItems[3,n])

            If !( CSTR(aItems[2,n]) == CSTR(aItems[3,n]) )
//View( { aItems[2,n], aItems[3,n] } )
//View( { valtype(aItems[2,n]), valtype(aItems[3,n]) } )
               lChanged := .T.
            EndIf
            If aItems[2,n] != NIL
               If nCont > 1
                  cQuery  += ", "
                  IF !(aItems[3,n]=='NIL' .OR.;
                       aItems[3,n]=='NULL'); cQuery2 += " AND " ; ENDIF
               EndIf
               nCont++
//View( {aItems[4,n], aItems[2,n], valtype(aItems[2,n])  } )
If !HB_ISNIL(aItems[4,n])

               xValue := IIF( aItems[4,n]!="C" ,;
                              Str2Val( aItems[2,n], aItems[4,n] ),;
                              AllTrim(aItems[2,n]) )
ELSE
xValue := ""
ENDIF
//View( {aItems[2,n],"valtype ="+valtype(aItems[2,n])} )
//View( {aItems[4,n],"valtype ="+valtype(aItems[4,n])} )
//View( {xValue,valtype(xValue)} )
//View( {aItems[1,n],DataToSql( xValue ) } )
               cQuery  += aItems[1,n]+" = "+DataToSql( xValue )+" "
//View( cQuery )               
//view("pasó")
               IF !(aItems[3,n]=='NIL' .OR. aItems[3,n]=='NULL')
                  xValue := IIF( aItems[4,n]!="C" ,;
                                 Str2Val( aItems[3,n], aItems[4,n] ),;
                                 AllTrim(aItems[3,n]) )
//View("otro aqui")                                 
                  cQuery2 += aItems[1,n]+" = "+DataToSql( xValue )+" "
               ENDIF
            ENDIF               

         Next n
         
         If !Empty(::cPreQryUpdate)
         
            cQuery2 += ::cPreQryUpdate
         
         EndIf
         
         If !lChanged
            Return .F.
         EndIf
         
         cQuery += " WHERE "
         cQuery += cQuery2

//View(cQuery)

         oExecute := ::oConn:Execute( cQuery )

         IF oExecute:lError
            MsgStop( oExecute:cError, " DataBase " + MSG_ALERTA )
            View(cQuery)
            Return .F.
         EndIf
         
         If oExecute:Rows = 0
            MsgInfo( "0 lineas actualizadas en Base de Datos...",;
                     "DataBase. Atención. " )
            view(cQuery)
            Return .F.
         EndIf


         // -- Actualizamos el Modelo.                  
         For n=1 to Len( aItems[2] )
            IF aItems[4,n]=="L" .AND. ValType(aItems[2,n])=="C"
               ::Set( , aItems[5,n], Str2Bool(aItems[2,n]) )
            ELSE
               ::Set( , aItems[5,n], aItems[2,n] )
            ENDIF
         Next n
      
      Else
         MsgStop("Por ahora sin Soporte para varias tablas...","RIGC")
         View(aTables[1])
         View({"Longitud de aTables ",Len(aTables[1]) })
         Return .F.
      EndIf

   EndIf
   

   If Empty( aItems )
   
      If ValType(xCol)="N"
         nCol := xCol
      ElseIf ValType(xCol)="C"
         nCol := ::oTreeView:GetPosCol( xCol )
         If nCol < 0
            MsgStop("Columna no reconocida", "atencion")
            Return .F.
         EndIf
      Else
         Return NIL      
      Endif

      SET LIST_STORE ::oLbx ITER ::aIter POS nCol VALUE uValue

  EndIf

Return .T.



METHOD GetTables( aItems , cSchema) CLASS TPY_DATA_MODEL

   Local n,lPrimero:=.t.
   Local oQuery,cQuery
   Local aData :={}
   Local cTemp, cTable, aTables:={}
   
   Default cSchema := ::oConn:Schema
   
   //-- Primero, si tenemos conexion a BD...
   If ::lQuery
   
      cQuery := "SELECT table_name,column_name "
      cQuery += " FROM information_schema.columns "
      cQuery += " WHERE is_updatable = 'YES' and table_schema = "
      cQuery += DataToSql(cSchema)
      
      For n=1 to Len( aItems[1] )
         If !Empty( aItems[1,n] )
            If lPrimero ; cQuery += " and ( "  ; Else ; cQuery += " or "; EndIf
            lPrimero := .f.
            cQuery +=       " column_name = " + DataToSql(lower(aItems[1,n]))
         EndIf      
      Next n
      
      cQuery += " )  "
      cQuery += " GROUP BY table_name,column_name "
      oQuery := ::oConn:Query( cQuery )
      
      If !oQuery:lError
         
         // --  Colocamos solo los nombres de las tablas en aTables
         FOR EACH cTemp IN oQuery:aData
            IF cTemp[1] != cTable
               AADD( aTables , cTemp[1])
               cTable:=cTemp[1]
            ENDIF
         NEXT

         aData := oQuery:aData
      EndIf
  
   EndIf

Return {aTables,aData}



METHOD Insert( aItems ) CLASS TPY_DATA_MODEL

   Local n, oExecute, cQuery,cQuery2:=""
   Local aTables, lPrimero:=.t.
   
   //-- Primero, si tenemos conexion a BD... intentamos insertar.
   If ::lQuery
   
      aTables:= ::GetTables(aItems)
      
      If Len(aTables[1]) = 1
      
         //Hora de hacer INSERT!!
         cQuery := "INSERT INTO "+Alltrim(CStr(::oConn:Schema))+"."
         cQuery += Alltrim(aTables[1,1])+"("
         For n=1 to Len( aItems[2] )
            If !HB_ISNIL(aItems[1,n])
               If !lPrimero
                  cQuery  += ", "
                  cQuery2 += ", "
               EndIf
//               View( {aItems[1,n],aItems[2,n],aItems[3,n],aItems[4,n]})
               cQuery += aItems[1,n]
               cQuery2 += DataToSql( Alltrim( aItems[2,n]) )
               lPrimero := .f.
            EndIf
         Next n

         If !Empty(::aPreQryInsert)
            cQuery  += ", "+::aPreQryInsert[1]
            cQuery2 += ", "+::aPreQryInsert[2]
            //view("aqui")
         EndIf

         cQuery += ") VALUES ("+cQuery2+");"

         oExecute := ::oConn:Execute( cQuery )
//View(cQuery)
         IF oExecute:lError
            MsgStop( oExecute:cError, " DataBase " + MSG_ALERTA )
            Return .F.
         EndIf
      
      Else
         MsgStop("Por ahora sin Soporte para varias tablas...","RIGC")
         View( aTables[1] )
         Return .F.
      EndIf
  
   EndIf

   APPEND LIST_STORE ::oLbx ITER ::aIter
   for n := 1 to Len( aItems[2] )
       SET LIST_STORE ::oLbx ITER ::aIter POS n VALUE aItems[2,n]
   next

Return .T.




/* Ejemplo de como MODIFICAR un dato del modelo vista controlador. */
STATIC FUNCTION fixed_toggled( oCellRendererToggle, cPath, oTreeView, oLbx )
  Local aIter
  Local path
  Local fixed
  Local nColumn := oCellRendererToggle:nColumn + 1
  
  path := gtk_tree_path_new_from_string( cPath )
 
  /* get toggled iter */
  fixed := oTreeView:GetValue( nColumn, "Boolean", Path, @aIter )

  // do something with the value
  //fixed := !fixed

  // aqui ejecutamos la validación.
  if HB_ISBLOCK(oCellRendererToggle:bValid)
    If !Eval(oCellRendererToggle:bValid, oCellRendererToggle, !fixed )
       MsgInfo( "funcion fixed_toggled en listore.prg", "No Pasa" )
       return .F.
    EndIf
  endif
   
  /* set new value */
? oLbx:ClassName()
  If UPPER(oLbx:ClassName())=="GLISTSTORE"
     oTreeView:SetValue(nColumn, !fixed ,path,oLbx)

  ElseIf UPPER(oLbx:ClassName())=="GTREESTORE"
     oLbx:Set( aIter, nColumn, !fixed )

  EndIf


  /* clean up */
  gtk_tree_path_free( path )

Return .f.


/* Ejemplo de como MODIFICAR un dato del modelo vista controlador. */
/*
STATIC FUNCTION change_text( oCellRendererText, cPath, oTreeView, oLbx, cTextNew )
  Local aIter
  Local path
  Local fixed
  Local nColumn := oCellRendererText:nColumn + 1
  
  //View({"El Path", cPath})
  //MsgInfo( ValToPrg(oCellRendererText:bValid) )
  //Eval( oCellRendererText:bValid, "A", "B", "C" )


  // Aqui ejecutamos la validación...   
  If !Eval(oCellRendererText:bValid, oCellRendererText, cTextNew )
     MsgInfo( "funcion change_text en listore.prg", "No Pasa" )
     return .F.
  EndIf
    
  path := gtk_tree_path_new_from_string( cPath )
  
  //fixed := oTreeView:GetValue( nColumn, "text", Path, @aIter )

  // do something with the value
  fixed := cTextNew
   
  oLbx:Set( aIter, nColumn, fixed )
  
  gtk_tree_path_free( path )

Return .T.
*/

// Una manera facil de obtener el valor de las columnas
// Easy get values from columns
/*
Static Function Comprueba( oTreeView, pPath, pTreeViewColumn, oCol, uExec  )
    Local nBug, nColumn, cTitle, cType

//    View( {CStr(oTreeView), CSTR(pPath), CSTR(pTreeViewColumn), CSTR(oCol)} )    
//       oTreeView:bRow_Activated := { |o,path,col| Comprueba( oTreeview, path, col, o ) }

   
    // u := o:GetValue( nColumn, cType_data, pPath )
    nBug := oTreeview:GetValue( 2, "Int" , pPath )
    
//    Msg2Info( "The number bug is: "+ cStr( nBug ) )

//    View( { {"Total Columnas", oTreeView:GetTotalColumns() } } )
//    View( oTreeView  )
//    View( oTreeViewColumn:GetTitle() )
//   gtk_tree_view_column_get_title( pTreeViewColumn )
     cTitle  := gtk_tree_view_column_get_title( pTreeViewColumn )
     nColumn := oTreeView:GetPosCol( cTitle )
     cType   := oTreeView:GetColumnTypeStr( nColumn )

View( {cTitle, nColumn, cType} )

     If !Empty( uExec )
        oTpuy:RunText( uExec )
     EndIf
     

Return nil
*/

/*
Static Function Msg2Info( cText, cTitle )
  Local oBox, oWnd, oBoxH, oImage, oToggle
  DEFAULT cTitle := "Information", cText := "Information"

  DEFINE WINDOW oWnd TITLE cTitle TYPE_HINT GDK_WINDOW_TYPE_HINT_MENU ;
         OF oTpuy:oWnd

      oWnd:SetBorder( 5 )
      oWnd:SetSkipTaskBar( .T. ) // No queremos que salga en la barra de tareas

      DEFINE BOX oBox oF oWnd VERTICAL
         
         DEFINE BOX oBoxH OF oBox
           oBoxH:SetBorder( 20 )
           DEFINE IMAGE oImage FROM STOCK GTK_STOCK_DIALOG_INFO ;
                               SIZE_ICON GTK_ICON_SIZE_DIALOG OF oBoxH
           DEFINE LABEL TEXT cText OF oBoxH
         
           DEFINE BUTTON FROM STOCK GTK_STOCK_OK ACTION oWnd:End OF oBox

            DEFINE TOGGLE oToggle TEXT "_Comnutador" ACTION g_print( "First Example" ) OF oBox
            
            oToggle:DisConnect( "toggled" )
            oToggle:Connect( "toggled" )

            DEFINE TOGGLE oToggle TEXT "_Comnutador" ACTION g_print( "Two example" ) OF oBox
            oToggle:DisConnect( "toggled" )
            g_signal_connect( oToggle:pWidget, "toggled", { ||g_print( "Dios, que vueltas!!" ) } )

  ACTIVATE WINDOW oWnd CENTER MODAL

RETURN NIL
*/


/** \brief Determina el tipo de dato GType para cada campo de una estructura
 *         de datos.
 *         Retorna un valor entero correspondiente al G_TYPE determinado o
 *         0 si ocurre un error o no esta definido.
 */
Function  StruToGType( aRow )
   Local nResp:=0, cDataType

   If Empty(aRow)
      Return nResp
   EndIf

   If Len(aRow) < 4
      MsgStop( "Estructura Inválida",  "TPY_listore. Error"  )
      Return nResp
   EndIf

   cDataType := AllTrim(  aRow[2] )

   Do Case

      case (cDataType="C" .OR. cDataType="M")
         nResp := G_TYPE_STRING

      case cDataType="L"
         nResp := G_TYPE_BOOLEAN

      case cDataType="D"
         nResp := G_TYPE_STRING

      // --- Esto no esta funcionando bien. Hay que revisar.
      case cDataType="N"
         if aRow[3]<4
             nResp := G_TYPE_STRING //G_TYPE_INT
         else
             nResp := G_TYPE_STRING //G_TYPE_LONG
         endif

   End Case

Return nResp



FUNCTION Str2Bool(cVal)
   Local lRes:=.F.
   
   IF UPPER(cVal)=="T" .OR. UPPER(cVal)=="Y"
      lRes := .T.
   ENDIF
   
RETURN lRes


/** Funcion que retorna .T. si el valor es vacio o Nulo  (esto debemos hacerlo en la clase TPostgres)
 *
 */
STATIC FUNCTION FEMPTY( cValue )
RETURN  Empty( cValue ) .OR. UPPER(AllTrim( cValue ))="NIL"



/** Funcion que retorna arreglo correspondiente
 *  a valores del clasificador dado.
 */
FUNCTION ClsfTOArray( cClassifier, cSchema, oConn )
   Local aResult
   Local oQuery, cQuery
   
   Default oConn   := TPY_CONN
   Default cSchema := oConn:Schema
   
   cQuery := " SELECT base_classifier_data.clsdata_value, "
   cQuery += "base_classifier_data.clsdata_description, "
   cQuery += "base_classifier_data.clsdata_value_type "
   cQuery += " FROM "+cSchema+".base_classifier "
   cQuery += " JOIN "+cSchema+".base_classifier_data ON "
   cQuery += "base_classifier.class_id = base_classifier_data.clsdata_class_id "
   cQuery += " WHERE base_classifier.class_name='"+cClassifier+"' "
   
//   View( cQuery )
   
   oQuery := oConn:Query(cQuery)
   
   aResult := oQuery:aData
   
   oQuery := NIL
   
RETURN aResult



/** Funcion que retorna valor correspondiente en arreglo de datos
 *  para usar en combobox
 */
FUNCTION DataFromClsf( cData, cClassifier, cSchema, oConn )
   Local cRes := ""
   Local oQuery, cQuery
   
   If HB_ISNIL( cData )
      Return ""
   EndIf
   
   Default oConn   := TPY_CONN
   Default cSchema := oConn:Schema

   cQuery := " SELECT base_classifier_data.clsdata_description "
   cQuery += " FROM "+cSchema+".base_classifier "
   cQuery += " JOIN "+cSchema+".base_classifier_data ON "
   cQuery += "base_classifier.class_id = base_classifier_data.clsdata_class_id "
   cQuery += " WHERE base_classifier.class_name='"+cClassifier+"' and "
   cQuery +=        "base_classifier_data.clsdata_value = "+DataToSQL(cData)

   oQuery := oConn:Query(cQuery)
   
   If !Empty( oQuery:aData )
      cRes   := oQuery:aData[1,1]
   EndIf
   
   oQuery := NIL
   
RETURN cRes


    
/** Funcion que retorna valor correspondiente en arreglo de datos
 *  desde el combobox
 */
FUNCTION DataFromCombo( cData, cClassifier, cSchema, oConn )
   Local cRes := ""
   Local oQuery, cQuery
   
   If HB_ISNIL( cData )
      Return ""
   EndIf
   
   Default oConn   := TPY_CONN
   Default cSchema := oConn:Schema

   cQuery := " SELECT base_classifier_data.clsdata_value "
   cQuery += " FROM "+cSchema+".base_classifier "
   cQuery += " JOIN "+cSchema+".base_classifier_data ON "
   cQuery += "base_classifier.class_id = base_classifier_data.clsdata_class_id "
   cQuery += " WHERE base_classifier.class_name='"+cClassifier+"' and "
   cQuery +=        "base_classifier_data.clsdata_description = "+DataToSQL(cData)

   oQuery := oConn:Query(cQuery)
   
   If !Empty( oQuery:aData )
      cRes   := oQuery:aData[1,1]
   EndIf
   
   oQuery := NIL
   
RETURN cRes
    




//////////////////////////
//////////////////////////
//   OTRA CLASE HIJA    //
//////////////////////////
//////////////////////////

#define ABMFLD_DESCRIP    ::aFields[y, 1]
#define ABMFLD_NAME       ::aFields[y, 2]
#define ABMFLD_EDITABLE   ::aFields[y, 3]
#define ABMFLD_VIEWABLE   ::aFields[y, 4]
#define ABMFLD_NAVIGABLE  ::aFields[y, 5]
#define ABMFLD_PICTURE    ::aFields[y, 6]
#define ABMFLD_DEFAULT    ::aFields[y, 7]
#define ABMFLD_REFERENCE  ::aFields[y, 8]
#define ABMFLD_REFTABLE   ::aFields[y, 9]
#define ABMFLD_REFFIELD   ::aFields[y,10]
#define ABMFLD_REFDESCRI  ::aFields[y,11]
#define ABMFLD_REFSCRIPT  ::aFields[y,12]
#define ABMFLD_BOXNAME    ::aFields[y,13]

#define ABM_ISEDITABLE     (ABMFLD_EDITABLE )
#define ABM_ISVIEWABLE     (ABMFLD_VIEWABLE )
#define ABM_ISREFERENCE    (ABMFLD_REFERENCE)
#define ABM_ISCOMBOBOX     (UPPER(ABMFLD_REFDESCRI)=="COMBOBOX")


CLASS TPY_ABM FROM TPUBLIC

   DATA oForm
   DATA oWnd
   DATA oModel
   DATA oGet
   DATA oBox, oBox1, oBox2, oBox3, oBox4
   DATA oTable, oScroll
   DATA oBtn

/* Probando */
   DATA oVar   
   DATA oField
//

   DATA cId
   DATA uGlade
   DATA cGlade

   DATA aFields
//   DATA aVars
   DATA aReg
   DATA aGet
   DATA nLenGet
   DATA nAlto
   DATA nAncho
   DATA lImage
   DATA lFix
   DATA lAcepta
   DATA lEnable
   DATA lBoton
   DATA lWnd
   DATA nRow

   DATA bAction
   DATA bInit

   DATA bSave

   METHOD New( oParent, oModel, cTitle, oIcon, nRow, nWidth, nHeight, cId, uGlade, cBox )
   METHOD End( )
   METHOD Active( bAction, bInit )
   METHOD ACantGet()
   METHOD UpdateBuffer()
   METHOD Enable()  INLINE (aEval( ::aGet, { |o| o:Enable() } ),;
                            aEval( ::oBtn, { |o| o:Enable() } ), ::lEnable := .t.)
   METHOD Disable() INLINE (aEval( ::aGet, { |o| o:Disable() } ),;
                            aEval( ::oBtn, { |o| o:Disable() } ) , ::lEnable := .f.)
   METHOD Refresh() INLINE aEval( ::aGet, { |o| o:Refresh() } )
   METHOD nLen(n)   INLINE ::nLenGet := n

   METHOD Save()
   METHOD Get(cField)  
   METHOD GetValue(cField)  
   METHOD GetTitle(cField)
   METHOD PosField(cField)
   METHOD Set(nColumn,uField,cValue)
   METHOD SetAction(uField,cAction)    INLINE  ::Set(12,uField,cAction)
   METHOD SetRefTable(uField,cTable)   INLINE  ::Set( 9,uField,cTable)
   METHOD SetRefDescri(uField,cField)  INLINE  ::Set(11,uField,cField)
   METHOD SetRefField(uField,cField)   INLINE  ::Set(10,uField,cField)
   METHOD SetEditable(uField,lVal)     INLINE  ::Set( 3,uField,lVal)
   METHOD SetViewable(uField,lVal)     INLINE  ::Set( 4,uField,lVal)
   METHOD SetNavigable(uField,lVal)    INLINE  ::Set( 5,uField,lVal)

ENDCLASS


METHOD New( oParent, oModel, cTitle, oIcon, nRow, nWidth, nHeight,;
            cId, uGlade, cBox )  CLASS TPY_ABM  

   Local aField, y:=0, nPos
   Local nPosition
   Local pPath, aIter := GtkTreeIter
   Local cRow
   Local cGlade
   Local cTemp
   Local aCombo := {}
   Local aComboValues

   ::oModel  := oModel
   ::oGet    := TPublic():New()
   ::oVar    := TPublic():New()
   ::oField  := TPublic():New()

   ::cId     := cId
   ::uGlade  := uGlade

   ::oBtn    := {,}
   ::aFields := {}
   ::aReg    := {}
   ::nAlto   := 0
   ::nAncho  := 0
   ::lFix    := .t.
   ::lAcepta := .f.
   ::lEnable := .t.
   ::lImage  := .t.
   ::lBoton  := .t.
   ::lWnd    := .t.
   ::nRow    := nRow

   ::bSave   := {|| .T. }
   
   DEFAULT  nWidth := 0 , nHeight := 0
   DEFAULT  cBox := "vbox2"

   cRow     := ALLTRIM( CSTR(::oModel:GetPosRow()-1) )

   pPath := gtk_tree_path_new_from_string( cRow )

   If !ISNIL(::uGlade)
      IF ValType( ::uGlade )="C"
         SET RESOURCES cGlade FROM FILE oTpuy:cResources+Alltrim(::uGlade)
         ::cGlade := cGlade
      ELSE
         ::cGlade := ::uGlade
      ENDIF
   EndIf


   if oParent == Nil
      if nWidth == 0 .Or. nHeight == 0
         DEFINE WINDOW ::oWnd TITLE cTitle OF oTpuy:oWnd;
                       ID ::cId RESOURCE ::cGlade
         ::lFix := .t.
      else
         DEFINE WINDOW ::oWnd  TITLE cTitle ;
                       SIZE nWidth, nHeight ;
                       ID ::cId RESOURCE ::cGlade
/*
                       view("bien")
                       ACTIVATE WINDOW ::oWnd
                       return self
                       */
         ::lFix := .f.
      end

      If ISOBJECT(oIcon)
         gtk_window_set_icon(::oWnd:pWidget, oIcon)
      EndIf
      
      If !ISNIL(::uGlade)
         DEFINE BOX ::oBox ID cBox RESOURCE ::cGlade
      Else
         DEFINE BOX ::oBox OF ::oWnd SPACING 8
      EndIF

///      DEFINE BOX ::oBox OF ::oWnd SPACING 8

   else
     ::oBox := oParent
     ::lWnd := .f.
   end


//   ::oGet := ::oEdit:oGet

   If !ISNIL(oParent)
      ::lBoton:=.F.
   EndIf

   FOR EACH aField IN ::oModel:aDMStru

      IF !(HB_ISNIL(aField[3]).OR. HB_ISNIL(aField[4]))
         AADD( ::aFields, aField )
         //nColumn++
         y++
         
         IF ABM_ISEDITABLE .OR. ABM_ISVIEWABLE

            nPosition := ASCAN( ::oModel:aStruct,{ |a| a[1]==ABMFLD_NAME } )
//View( {y,nPosition} )

            If ::oModel:aStruct[nPosition,2]="C" .AND. FEmpty( Alltrim(ABMFLD_DEFAULT) )

               HSet( ::oVar:hVars, ABMFLD_NAME, Space( ::oModel:aStruct[nPosition,3] ) )
         
            ElseIf  ::oModel:aStruct[nPosition,2]="N" .AND. FEmpty( Alltrim(ABMFLD_DEFAULT) )

               If ("." IN ABMFLD_PICTURE)
                  HSet( ::oVar:hVars, ABMFLD_NAME, 0 )
               Else
                  HSet( ::oVar:hVars, ABMFLD_NAME, Space( ::oModel:aStruct[nPosition,3] ) )
               EndIf

            ElseIf  ::oModel:aStruct[nPosition,2]="N" .AND. !FEmpty( Alltrim(ABMFLD_DEFAULT) )

               HSet( ::oVar:hVars, ABMFLD_NAME, ABMFLD_DEFAULT )

            Else

               HSet( ::oVar:hVars, ABMFLD_NAME, Space(1) )

            EndIf


            //-- Repetimos el PICTURE si se especifica un solo valor.
            IF ::oModel:aStruct[nPosition,2]="C" .AND. LEN( AllTrim(ABMFLD_PICTURE) )=1
               IF !Empty(::oModel:aItems)
                  ABMFLD_PICTURE := Repli( AllTrim(ABMFLD_PICTURE), ::oModel:aStruct[nPosition,3] )
               ELSE
                  // -- Esto es un parche! hay problemas cuando el query no tiene nada.
                  //    el tamaño del campo viene incorrecto.
                  ABMFLD_PICTURE := Repli( AllTrim(ABMFLD_PICTURE), 100 )
//   View( ::oModel:aStruct[nPosition] )
//   View( ::aFields[y] )
               ENDIF
            ENDIF
            
            //---  Seteamos el valor maximo para el ancho. Valor para calculo de tamaño de la ventana.
            If LEN( ABMFLD_PICTURE ) > ::nAncho
               ::nAncho := LEN( ABMFLD_PICTURE )
            EndIf

            // Si estamos editando.. colocamos el valor desde el modelo
            If ::nRow>0

               cTemp := AllTrim( CSTR(::oModel:oTreeView:GetValue( y, "", pPath, @aIter )) )         
               //View({ABMFLD_NAME,cTemp})
               HSet( ::oVar:hVars, ABMFLD_NAME, cTemp )
            
            EndIf
         
         
            //-- No se puede mandar ::oVar:Get(ABMFLD_NAME) en el comando.. da error. RIGC
            cTemp := ::oVar:Get(ABMFLD_NAME)
         
            If ABM_ISREFERENCE

               If ABM_ISCOMBOBOX
            
                  // -- traemos los valores para el combo
                  aCombo := {}
                  aComboValues := ClsfTOArray(ABMFLD_REFFIELD,ABMFLD_REFTABLE)
                  AEVAL( aComboValues, {|lin| AADD(aCombo, lin[2]) } )
                  
                  EDIT ADD Alltrim(ABMFLD_DESCRIP)+": " COMBOBOX ABMFLD_DEFAULT ;
                       NAME ABMFLD_NAME ITEMS aComboValues OF Self
                       
               Else
            
                  EDIT ADD CONTAINER nPos OF Self
               
                       Aadd(Self:aReg[nPos,2],{ "Ref", AllTrim(ABMFLD_DESCRIP)+": ", ;
                       ctemp,,,ABMFLD_NAME,.t. })

                           
//View( { Alltrim(ABMFLD_DESCRIP), ABMFLD_NAME } )
//view(::aReg[nPos])
//view(::aReg[nPos,2,1])
//Aadd(Self:aReg,{ "Ref",{ AllTrim(ABMFLD_DESCRIP)+": ", cTemp }, cTemp,,,::aFields[y, 2] } )

               EndIf

            Else

               Do Case
                  Case Empty(ABMFLD_PICTURE) .OR. ABMFLD_PICTURE=="NIL"
                     EDIT ADD Alltrim(ABMFLD_DESCRIP)+": " NAME ABMFLD_NAME ;
                              GET cTemp OF Self

                  Case Alltrim(Upper(ABMFLD_PICTURE))="BOOLEAN" .OR. ;
                       ::oModel:aStruct[y,7]="boolean"
                     EDIT ADD Alltrim(ABMFLD_DESCRIP)+": " ;
                              NAME ABMFLD_NAME ;
                              CHECKBOX cTemp OF Self

                  Other
                     EDIT ADD Alltrim(ABMFLD_DESCRIP)+": "  NAME ABMFLD_NAME ;
                              GET cTemp PICTURE ABMFLD_PICTURE OF Self
               EndCase
            EndIf
         
         ELSE
            //--- colocamos elemento vacio en aReg para evitar descuadre entre
            //--- aReg y aFields.
            Aadd(Self:aReg,{ "empty",{} })
         ENDIF
      ENDIF
   NEXT
   
   ::nAncho := ::nAncho * 16  // Aproximado necesario para mostrar bien el ancho pantalla
   If ::nAncho > 600
      ::nAncho := 600
   EndIf
   //View(::nAncho)

Return Self



METHOD Get(cField) CLASS TPY_ABM
   Local uRes
   
   IF ::oGet:IsDef( cField )
      uRes := ::oGet:Get(cField)
   ENDIF

Return uRes



METHOD GetValue(cField) CLASS TPY_ABM

   Local cValue, nPosCol

   IF ::oGet:IsDef(cField)
   
      cValue := ::oGet:Get(cField):GetValue()

   ELSEIF ::oVar:IsDef(cField)
   
      cValue := ::oVar:Get(cField)

   ELSE
   
      nPosCol := ASCAN( ::oModel:aStruct, {|a| a[1]=cField } )
   
      If nPosCol>0
         cValue := ::oModel:aItems[::nRow,nPosCol]

      Else
//         View("No está")
      EndIf
      
   ENDIF
   
//   View(ValType(cValue) )

Return cValue



METHOD GetTitle(cField) CLASS TPY_ABM

   Local nPosFld
   
   nPosFld := ::PosField(cField)
   
   IF !HB_ISNIL(nPosFld)
      Return ::aFields[nPosFld,1]
   ENDIF
   
Return NIL



METHOD Set(nColumn,uField, cValue) CLASS TPY_ABM
   
   Local nPos
   
   IF ValType(uField)="N"
      nPos := uField
      IF uField > 0
         ::oForm:aFields[nPos,nColumn] := cValue
         Return .T.
      ENDIF

   ELSEIF ValType(uField)="C"
   
      Return ::oModel:ColSet( uField, nColumn, cValue )
   
   ENDIF

Return .F.



METHOD End( ) CLASS TPY_ABM

   if ::bAction != Nil
     eval(::bAction)
   end
   if ::oWnd != Nil
     ::oWnd:End()
   end

RETURN nil


#define  ABM_WIDGET            ::aGet[x2]

#define  ABM_WGTYPE            ::aReg[x,1]
#define  ABM_WG_LABEL          ::aReg[x,2,1]
#define  ABM_WG_BCODE          ::aReg[x,2,2]
#define  ABM_WG_LEN            ::aReg[x,2,3]
#define  ABM_WG_PICT           ::aReg[x,2,4]
#define  ABM_WG_VALID          ::aReg[x,2,5]
#define  ABM_WG_FIELDNAME      ::aReg[x,2,6]

METHOD ACTIVE( bAction, bInit ) CLASS TPY_ABM

   Local x, i, oBox, y
   Local x2 := 1, oImage
   Local lContainer
   Local cTemp
   Local aCombo, aComboValues
   
   Local oBoxes  := TPublic():New()
   //Local oTables := TPublic():New()
   Local oTmp

//   Default oBoxes := TPublic():New()
   
   ::aGet := Array(::aCantGet())
   ::bAction := bAction
   ::bInit   := bInit
   
   lContainer := .f.

   
   If ::lImage
     //if ::oWnd == Nil
     //  DEFINE SEPARATOR OF ::oBox VERTICAL PADDING 15 //EXPAND FILL
     //end
     ::oBox:SetBorder( 5 )
     DEFINE IMAGE oImage FILE oTpuy:cImages+"logo3.png" OF ::oBox
     DEFINE SEPARATOR OF ::oBox VERTICAL PADDING 15 //EXPAND FILL
   EndIf


   For y=1 to Len(::aReg)

      if !oBoxes:IsDef(ABMFLD_BOXNAME)
         
         //oTmp := oBoxes:Get(ABMFLD_BOXNAME)
         //oBoxes:oBoxes := TPublic():New()
         HSet( oBoxes:hVars, ABMFLD_BOXNAME, TPublic():New() )
         oTmp := oBoxes:Get(ABMFLD_BOXNAME)
                  
         if ::cGlade != NIL
            DEFINE BOX oTmp:oBox1 OF ::oBox ID ABMFLD_BOXNAME RESOURCE ::cGlade
         else
            DEFINE BOX oTmp:oBox1 OF ::oBox VERTICAL EXPAND FILL
         end

         If !::lFix

            DEFINE BOX oTmp:oBox2 OF oTmp:oBox1 EXPAND FILL

            DEFINE SCROLLEDWINDOW oTmp:oScroll OF oTmp:oBox2 EXPAND FILL ;
                   SHADOW GTK_SHADOW_ETCHED_IN

            oTmp:oScroll:SetPolicy( GTK_POLICY_AUTOMATIC, GTK_POLICY_AUTOMATIC )
            gtk_box_pack_start( oTmp:oBox2:pWidget, oTmp:oScroll:pWidget, TRUE, TRUE, 0 )

            DEFINE BOX oTmp:oBox4 OF oTmp:oScroll EXPAND FILL
            DEFINE TABLE oTmp:oTable ROWS Len(::aReg) COLS 2 OF oTmp:oBox4
         //gtk_table_set_row_spacings( oTmp:oTable:pWidget, 10 )
           gtk_table_set_col_spacings( oTmp:oBox4:pWidget, 5 )
           gtk_table_set_row_spacings( oTmp:oBox4:pWidget, 5 )
           gtk_scrolled_window_add_with_viewport( oTmp:oScroll:pWidget,;
                                                  oTmp:oBox4:pWidget )

         Else

            DEFINE TABLE oTmp:oTable ROWS Len(::aReg) COLS 2 OF oTmp:oBox1
         EndIf

         //gtk_table_set_homogeneous( oTmp:oTable:pWidget, .t. )
         
      End
      
      oTmp:oBox1:SetBorder( 5 )
      
//      HSet( oBoxes:hVars, ABMFLD_BOXNAME, oTmp )
         

   Next y
   
//   View( ValToPrg(oBoxes:hVars) )

//   DEFINE BOX ::oBox1 OF ::oBox VERTICAL EXPAND FILL //SPACING 8
   //::oBox1 := oTmp
//   ::oBox1:SetBorder( 5 )

     // Vamos a usar una tabla
/*
   If !::lFix

     DEFINE BOX ::oBox2 OF ::oBox1 EXPAND FILL

     DEFINE SCROLLEDWINDOW ::oScroll OF ::oBox2 EXPAND FILL ;
            SHADOW GTK_SHADOW_ETCHED_IN

     ::oScroll:SetPolicy( GTK_POLICY_AUTOMATIC, GTK_POLICY_AUTOMATIC )
     gtk_box_pack_start( ::oBox2:pWidget, ::oScroll:pWidget, TRUE, TRUE, 0 )

     DEFINE BOX ::oBox4 OF ::oScroll EXPAND FILL
     DEFINE TABLE ::oTable ROWS Len(::aReg) COLS 2 OF ::oBox4
     //gtk_table_set_row_spacings( ::oTable:pWidget, 10 )
     gtk_table_set_col_spacings( ::oBox4:pWidget, 5 )
     gtk_table_set_row_spacings( ::oBox4:pWidget, 5 )
     gtk_scrolled_window_add_with_viewport( ::oScroll:pWidget, ::oBox4:pWidget )

   Else

      DEFINE TABLE ::oTable ROWS Len(::aReg) COLS 2 OF ::oBox1
   EndIf
*/
//View( ValToPrg(::aReg) )   

   For x=1 to Len(::aReg)

//view(::aFields[x,13])

      oTmp := oBoxes:Get(::aFields[x,13])
      
      If ABM_WGTYPE != "empty"

         If ABM_WGTYPE != "ContainerGet" .AND. ABM_WG_LABEL != Nil
            //.AND. !(::aFields[x,6]=="D")
            DEFINE LABEL PROMPT ABM_WG_LABEL OF oTmp:oTable TABLEATTACH 0,1,x-1,x //HALIGN LEFT
         EndIf

         If ABM_WGTYPE == "Get"

            //View( ::aReg[x,2] )
            If ::aFields[x,6]=="D"
               DEFINE TPYSELECTORDATE ABM_WIDGET OF oTmp:oTable ;
                      VALUE ::aReg[x,2,3] ;
                      NAME "";
                      FROM STOCK "gtk-index";
                      TABLEATTACH 1,2,x-1,x
                      
//                      ABM_WIDGET:SetParent(::oWnd)

               ABM_WIDGET:SetAction(::oWnd)
               
//               ABM_WIDGET:oImg:SetSize(16)

            ElseIf ::oModel:aStruct[x,2] == "N" .AND. ;
                   LEFT( ABM_WG_PICT,2 ) == "@E"
                   
               If HB_ISBLOCK(ABM_WG_VALID)
               
                  ABM_WG_VALID := {|o| o:SetText( TRANSFORM(o:GetText(),ABM_WG_PICT ) ) ,;
                                      Eval(ABM_WG_VALID)  }
               Else
//                  ABM_WG_VALID := {|o| o:SetText( TRANSFORM(VAL(o:GetText()), o:cPicture ) ), .t. }
//                  ABM_WG_VALID := {|o| View( TRANSFORM(VAL(o:GetText()), o:cPicture ) ) , .t. }
               
               EndIf

               ABM_WIDGET := GEntry():New(ABM_WG_BCODE,ABM_WG_PICT,ABM_WG_VALID,;
                                          ,,oTmp:oTable,.t.,.t.,,;
                                          .F.,,,,,,.F.,.F.,.F.,.F.,.F.,1,2,x-1,x,,)

               ABM_WIDGET:Justify(GTK_JUSTIFY_RIGHT)
               ABM_WIDGET:SetMaxLength(15)
               
               ABM_WIDGET:SetText(ABM_WG_LEN)
               
            Else
            
//view( { ABM_WG_BCODE,ABM_WG_LEN,ABM_WG_PICT,ABM_WG_VALID,,,oTmp:oTable } )
/*
               cTemp := ABM_WG_LEN
               If ::oModel:aStruct[x,2] == "N"
                  cTemp := VAL( ABM_WG_LEN )
               EndIF
*/
               ABM_WIDGET := PC_Get():New(ABM_WG_BCODE,ABM_WG_LEN,ABM_WG_PICT,,;
                                          ABM_WG_VALID,,,oTmp:oTable,;
                                          .t.,.t.,,.F.,,,,,, .F.,.F.,.F.,.F.,;
                                          .F.,1,2,x-1,x,,)

            EndIf
                                       
            IF !::aFields[x,3]            
               ABM_WIDGET:Disable()
            ENDIF
            gtk_entry_set_width_chars( ABM_WIDGET:pWidget, -1 )
         
         ElseIf ABM_WGTYPE == "Entry"

            ABM_WIDGET := GEntry():New(ABM_WG_BCODE,ABM_WG_LEN,ABM_WG_PICT,;
                                       ABM_WG_VALID,,oTmp:oTable,.t.,.t.,,;
                                       .F.,,,,,,.F.,.F.,.F.,.F.,.F.,1,2,x-1,x,,)
            gtk_entry_set_width_chars( ABM_WIDGET:pWidget, -1 )

         ElseIf ABM_WGTYPE == "Combo"
         
            aCombo := {}
            aComboValues := ABM_WG_LEN
            AEVAL( aComboValues, {|lin| AADD(aCombo, lin[2]) } )
         
            ABM_WIDGET := GComboBox():New(ABM_WG_BCODE,aCombo,ABM_WG_PICT,;
                                          ,,oTmp:oTable,.T.,.T.,,;
                                          .F.,,,,,,,,.F.,.F.,.F.,.F.,1,2,x-1,x,,)

            // -- Valor del la variable correspondiente   ::oVar:Get(::aFields[x,2])
            // -- Esquema donde buscar                    ::aFields[x,10]
            // -- Clasificador                            ::aFields[x,09]
            cTemp := NIL
            ASCAN( aComboValues , {|a|  ;
                   IF(a[2]=::oVar:Get(::aFields[x,2]),;
                            cTemp:=a[2],)} )
                   
            IF HB_ISNIL(cTemp)
               cTemp := DataFromClsf( ::oVar:Get(::aFields[x,2]),;
                                      ::aFields[x,10], ::aFields[x,09] )    
            ENDIF
            
            ABM_WIDGET:SelectItem(cTemp)
            
            cTemp := NIL

            IF !::aFields[x,3]            
               ABM_WIDGET:Disable()
            ENDIF

         ElseIf ABM_WGTYPE == "Button"
            ABM_WIDGET := GButton():New(ABM_WG_BCODE,ABM_WG_LEN,ABM_WG_PICT,;
                                       ,.F.,,oTmp:oTable,.T.,.T.,,.F.,,,,,,;
                                       ,,,,,.F.,.F.,.F.,.F.,1,2,x-1,x,,,,)


         ElseIf ABM_WGTYPE == "Toggle"
            ABM_WIDGET := GToggleButton():New( ::aReg[x,2,i,3],{|| View("Action") };
                                          ,,,.T.,oBox,.F.,.F.,,.F.,,;
                                          ,,,124,,,,,,.F.,.F.,.F.,.F.,,,,,, )
          
         ElseIf ABM_WGTYPE == "CheckBox"

           cTemp := ::oVar:Get(::aFields[x,2])
           cTemp := CStrToVal( cTemp, "L" )
           
           DEFINE CHECKBOX ABM_WIDGET VAR cTemp;
                  OF oTmp:oTable ;
                  TABLEATTACH 1,2,x-1,x
                  
                  //VALID ABM_WG_BCODE
/*
           ABM_WIDGET := GCheckBox():New( ,.t., ;
                         ABM_WG_BCODE ,,.F., oTmp:oTable, .F., .F.,, .F.,,,,,,,;
                         .F., .F., .F., .F.,1,2,x-1,x,, )
*/                         
           ABM_WIDGET:SetState(cTemp)

           IF !::aFields[x,3]            
              ABM_WIDGET:Disable()
           ENDIF

         //-- En caso de ser contenedor.    
         ElseIf ABM_WGTYPE == "ContainerGet"
            lContainer := .t.
            If ::aReg[x,2,1,2] != Nil
               DEFINE LABEL PROMPT ::aReg[x,2,1,2] OF oTmp:oTable;
                      TABLEATTACH 0,1,x-1,x //HALIGN LEFT
            EndIf
            DEFINE BOX oBox OF oTmp:oTable TABLEATTACH 1,2,x-1,x
            For i=1 to Len(::aReg[x,2])
               If i > 1
                  If ::aReg[x,2,i,2] != Nil
                     DEFINE LABEL PROMPT utf_8(::aReg[x,2,i,2]) OF oBox
                  EndIf
               EndIf
               If ::aReg[x,2,i,1] == "Get"
               
                  ABM_WIDGET := PC_Get():New(::aReg[x,2,i,2],::aReg[x,2,i,3],;
                                             ::aReg[x,2,i,4],,::aReg[x,2,i,5],,,oBox,;
                                             .t.,.t.,,.F.,,,,,, .F.,.F.,.F.,.F.,;
                                             .F.,1,2,x-1,x,,)

                  gtk_entry_set_width_chars( ABM_WIDGET:pWidget, 1 )

               ElseIf ::aReg[x,2,i,1] == "Ref"

                  cTemp := '{|| ::SetValue('+::aFields[x,12]+'),view(::aReg[x,2,i])}'
//                  View( ::aReg[x,2,i] )
                  ABM_WIDGET := tpydmselector():FromModel( ::oModel:oConn, ::oModel, oBox,;
                                                           ::aFields[x],@::aReg[x,2,i],;
                                                           ::nRow)

                  HSet( ::oGet:hVars, ::aReg[x,2,i,6], ABM_WIDGET )

//                       ABM_WIDGET:SetValue("1234")
//                       View( ABM_WIDGET:GetText() )
                       
               ElseIf ::aReg[x,2,i,1] == "Label"
                  DEFINE LABEL ABM_WIDGET PROMPT "<b>"+::aReg[x,2,i,3]+"</b>" MARKUP OF oBox
               //-- aqui voy...  debemos colocar el dato al que corresponde la referencia...
               //   ejemplo la descripcion. (RIGC)
            
            
               ElseIf ::aReg[x,2,i,1] == "Entry"
                  ABM_WIDGET := GEntry():New(::aReg[x,2,i,3],::aReg[x,2,i,4],;
                                       ::aReg[x,2,i,5],::aReg[x,2,i,6],,oBox,;
                                       .T.,.T.,,.F.,,,,,,.F.,.F.,.F.,.F.,.F.,1,2,x-1,x,,)
                  gtk_entry_set_width_chars( ABM_WIDGET:pWidget, -1 )


               ElseIf ::aReg[x,2,i,1] == "Combo"
                  ABM_WIDGET := GComboBox():New(::aReg[x,2,i,3],::aReg[x,2,i,4],;
                                       ::aReg[x,2,i,5],,,oBox,.T.,.T.,,.F.,,;
                                       ,,,,,,.F.,.F.,.F.,.F.,1,2,x-1,x,,)
               ElseIf ::aReg[x,2,i,1] == "Button"
                  ABM_WIDGET := GButton():New(::aReg[x,2,i,3],::aReg[x,2,i,4],;
                                       ::aReg[x,2,i,5] ,,.F.,,oBox,.F.,.F.,,.F.,;
                                       ,,,,,,,,,,.F.,.F.,.F.,.F.,,,,,,,,)
               ElseIf ::aReg[x,2,i,1] == "Toggle"
                  ABM_WIDGET := GToggleButton():New( ::aReg[x,2,i,3],;
                                       {|| View("Action") },,,.T.,oBox,.F.,.F.,,;
                                       .F.,,,,,124,,,,,,.F.,.F.,.F.,.F.,,,,,, )
               ElseIf ::aReg[x,2,i,1] == "Radio"
                  ABM_WIDGET := GButton():New(::aReg[x,2,i,3],::aReg[x,2,i,4],;
                                       ::aReg[x,2,i,5] ,,.F.,,oBox,.F.,;
                                       .F.,,.F.,,,,,,,,,,,.F.,.F.,.F.,.F.,,,,,,,,)
                
               EndIf
               If !::aReg[x,2,i,7]    //!::lEnable
                  ABM_WIDGET:Disable()
               EndIf
               x2++
            Next i
            x2--
         EndIf
      
         If HB_ISOBJECT(ABM_WIDGET)
            If !lContainer
               HSet( ::oGet:hVars, ABM_WG_FIELDNAME, ABM_WIDGET )
            EndIf
            lContainer := .f.
         Else
            MsgAlert("Problemas... no hay objeto Get")
         EndIf
      
         If !::lEnable
           ABM_WIDGET:Disable()
         EndIf
         x2++
      Endif
   next x

   If ::bInit != Nil
     Eval(::bInit, Self)
   EndIf


   If ::lBoton
   
   //View( oTmp:oBox1 )
     DEFINE BOX oTmp:oBox3 OF oTmp:oBox1 HOMO SPACING 8
     
     oTmp:oBox3:SetBorder( 5 )
     
     If ::oWnd != Nil

       DEFINE BUTTON ::oBtn[2] PROMPT "Grabar" ACTION ( ::lAcepta := .t., ::Save() ) ;
          OF oTmp:oBox3 EXPAND FILL
          
       DEFINE BUTTON ::oBtn[1] PROMPT "Salir"  ACTION ::End( ) OF oTmp:oBox3 EXPAND FILL

       ::oWnd:SetResizable( .f. )

     Else

        DEFINE BUTTON ::oBtn[2] PROMPT "Grabar" ;
          ACTION ( ::lAcepta := .t., ::Save() ) ;
          OF oTmp:oBox3 EXPAND FILL
        DEFINE BUTTON ::oBtn[1] PROMPT "Salir"  ;
          ACTION ( ::End( ) ) ;
          OF oTmp:oBox3 EXPAND FILL
        //::Disable()
     EndIf
   EndIf

   If ::lWnd
      If ISNIL(::uGlade)
         ACTIVATE WINDOW ::oWnd CENTER
      EndIf
   EndIf

Return Self


/*
 *  Metodo SAVE()  
 */
METHOD Save() CLASS TPY_ABM
   Local y
   Local lRet
   Local aItems := ARRAY( 5, Len(::aFields) )
   Local aField
   Local lFin, nFind

   lRet := Eval( ::bSave,Self )

   If !HB_ISLogical( lRet )
      MsgAlert( MSG_RETURN_NO_LOGIC, MSG_ALERTA )
      lRet := .F.
   Else
   
      If !lRet
         Return lRet
      EndIf

      //-- Mandamos a Actualizar el Modelo
      For y=1 to Len( ::aFields )

         If ABM_ISEDITABLE

            aItems[1,y] := ABMFLD_NAME
            aItems[2,y] := ::oGet:Get(ABMFLD_NAME):GetValue()
            aItems[3,y] := ::oVar:Get(ABMFLD_NAME)
            aItems[5,y] := ABMFLD_DESCRIP

            IF ::oGet:Get(ABMFLD_NAME):ClassName()=="GCOMBOBOX"

              nFind := ASCAN( ::aReg[y,2,3], ;
                               {|a| a[2]=::oGet:Get(ABMFLD_NAME):GetValue() })
              If nFind>0
              
                 aItems[2,y] := ::aReg[y,2,3,nFind,1]
                 
              EndIf
                                              
            ENDIF

            FOR EACH aField IN ::oModel:aStruct
                IF aField[1] = aItems[1,y]
                   aItems[4,y] := aField[2]
                ENDIF
            NEXT

            If ::nRow > 0 .AND. !::oModel:lQuery
               ::oModel:Set( , ABMFLD_DESCRIP, ::oGet:Get(ABMFLD_NAME):GetValue() )
            EndIf
         EndIf
         
//View({ aItems[1,y],aItems[2,y],aItems[3,y],aItems[4,y],aItems[5,y] })
//view(::aFields[y])
      Next y

      
      If ::nRow=0
         lFin := ::oModel:Insert( aItems )
      Else
         lFin := ::oModel:Set( aItems )
      EndIf
   
      //-- Ahora le decimos al modelo commit!
   
      IF lFin ; ::End() ; ENDIF
      
      If ::oModel:lQuery .AND. Empty(::oModel:aItems)
         ::oModel:oQuery:Refresh()
         ::oModel:aItems := ::oModel:oQuery:aData
      EndIf
      
   EndIf

Return lRet



METHOD aCantGet(  ) CLASS TPY_ABM
   Local x, i
   Local x2 := 0

     // Vamos a usar una tabla ;-)
     for x=1 to Len(::aReg)

      if ::aReg[x,1] == "Get"
      elseif ::aReg[x,1] == "Combo"
      elseif ::aReg[x,1] == "Button"
      elseif ::aReg[x,1] == "ContainerGet"
//View(::aReg[x,2])
        for i=1 to Len(::aReg[x,2])
//        view(::aReg[x,2,])
          if ::aReg[x,2,i,1] == "Get"
          elseif ::aReg[x,2,i,1] == "Combo"
          elseif ::aReg[x,2,i,1] == "Button"
          endif
            x2++
        next
        x2--
      end
      x2++
     next

RETURN x2



METHOD UpdateBuffer( ) CLASS TPY_ABM
   Local x, ctext

   for x=1 to Len(::aGet)
     if ::aGet[x]:Classname() == "GGET"
       ::aGet[x]:Refresh( )
     elseif ::aGet[x]:Classname() == "PC_GET"
       ::aGet[x]:Refresh( )
     elseif ::aGet[x]:Classname() == "GCOMBOBOX"
       ctext := eval(::aGet[x]:bSetGet)
       if !Empty(ctext)
         ::aGet[x]:SelectItem( ctext )
       else
         ::aGet[x]:SetActive( 1 )
       end
     else
       //::aGet[x]:SelectItem( eval(::aGet[x]:bSetGet) )
     end
   next

RETURN nil



METHOD PosField( cField ) CLASS TPY_ABM

   Local n:=0
   Local aReg:={}

   FOR EACH aReg IN ::aReg

      n++

      If UPPER( aReg[1] ) = "COMBO" .OR. ;
         UPPER( aReg[1] ) = "GET"

         If aReg[2,6] = cField   

           Return n
      
         EndIf
      EndIf
   
   NEXT

Return NIL







/*
 *  Clase para Manejo de Lista de Datos
 */

CLASS TPY_LISTBOX // FROM TPUBLIC // FROM TPY_DATA_MODEL

   DATA oWnd
   DATA oBox
   DATA oModel
   DATA oBarButton
   DATA oBtn
   DATA oBtns
   DATA lFix
   DATA lBar
   DATA lBotons

   DATA cId
   DATA uGlade
   DATA cGlade

   DATA bAction
   DATA bInit

   DATA bNew
   DATA bEdit
   DATA bDel
   DATA bPrint
   DATA bQuit

   METHOD New(oParent, oModel, cTitle, oIcon, nWidth, nHeight, cId, uGlade)
   METHOD Active( bAction, bInit )
   METHOD Release()  INLINE  IF(  !ISNIL( ::oWnd ), ::oWnd:End(), NIL )
   METHOD End()      INLINE  ::oWnd:End()

ENDCLASS


METHOD New( oParent, oModel, cTitle, oIcon, nWidth, nHeight, cId, uGlade ) CLASS TPY_LISTBOX

   Local cGlade

   ::oModel  := oModel
   ::oBtns   := TPUBLIC():New()
   ::cId     := cId
   ::uGlade  := uGlade
   ::lFix    := .t.
   ::lBotons := .t.
   ::lBar    := .t.
   ::bNew    := {|| MsgInfo("Accion del Boton 'Nuevo'" ) }  //{|| .T. }
   ::bEdit   := {|| MsgInfo("Accion del Boton 'Edit'"  ) }  //{|| .T. }
   ::bDel    := {|| MsgInfo("Accion del Boton 'Delete'") }  //{|| .T. }
   ::bPrint  := {|| MsgInfo("Accion del Boton 'Print'" ) }  //{|| .T. }
   ::bQuit   := {|| ::Release(), .t.  }  //{|| .T. }

   DEFAULT  nWidth := 0 , nHeight := 0

   If !ISNIL(::uGlade)
      If ValType( ::uGlade ) = "C"
         SET RESOURCES cGlade FROM FILE oTpuy:cResources+Alltrim(::uGlade)
         ::cGlade := cGlade
      Else
         ::cGlade := ::uGlade
      EndIf
   EndIf

   if oParent == Nil
      if nWidth == 0 .OR. nHeight == 0
         DEFINE WINDOW ::oWnd TITLE cTitle ;
                       ID ::cId RESOURCE cGlade
         ::lFix := .t.
      else
         DEFINE WINDOW ::oWnd SIZE nWidth, nHeight TITLE cTitle ;
                       ID ::cId RESOURCE cGlade
         ::lFix := .f.
      end

      If ISOBJECT(oIcon)
         gtk_window_set_icon(::oWnd:pWidget, oIcon)
      EndIf

      If !ISNIL(::uGlade)
         DEFINE BOX ::oBox ID "data" RESOURCE cGlade
      Else
         DEFINE BOX ::oBox VERTICAL OF ::oWnd SPACING 8
      EndIF
   else
     ::oBox := oParent
   end

   IF ::lBar

      If !ISNIL(cGlade)
         DEFINE TOOLBAR ::oBarButton OF ::oBox  ;
                     ID "barbutton" RESOURCE cGlade
      Else
         DEFINE TOOLBAR ::oBarButton OF ::oBox STYLE GTK_TOOLBAR_BOTH
      Endif

      If ::lBotons //.AND. !Empty(::oBtns:hVars)

         //HSet( ::oBtns:hVars, "oTBtnNew"  , NIL )
         //HSet( ::oBtns:hVars, "oTBtnEdit" , NIL )
         //HSet( ::oBtns:hVars, "oTBtnDel"  , NIL )
         //HSet( ::oBtns:hVars, "oTBtnPrint", NIL )
         //HSet( ::oBtns:hVars, "oTBtnQuit" , NIL )

         ::oBtns:oTBtnNew   := NIL 
         ::oBtns:oTBtnEdit  := NIL 
         ::oBtns:oTBtnDel   := NIL 
         ::oBtns:oTBtnPrint := NIL 
         ::oBtns:oTBtnQuit  := NIL 

         IF ISNIL(::uGlade)

            /* Boton NEW */
            DEFINE PCTOOLBUTTON ::oBtns:oTBtnNew   ;
                TEXT "Nuevo"              ;
                STOCK_ID GTK_STOCK_ADD    ;
                ACTION EVAL( ::bNew )     ;
                TOOLTIP "Añadir nuevo elemento en la lista...";
                OF ::oBarButton

            /* Boton EDIT */
            DEFINE PCTOOLBUTTON ::oBtns:oTBtnEdit      ;
                TEXT "Editar"              ;
                STOCK_ID GTK_STOCK_EDIT    ;    // "gtk-edit" No entiendo por que no acepta
                ACTION EVAL( ::bEdit )     ;
                TOOLTIP "Editar elemento en la lista...";
                OF ::oBarButton

            /* Boton DELETE */
            DEFINE PCTOOLBUTTON ::oBtns:oTBtnDel      ;
                TEXT "Borrar"              ;
                STOCK_ID GTK_STOCK_DELETE  ;
                ACTION EVAL( ::bDel )      ;
                TOOLTIP "Elimina el elemento Seleccionado en la lista...";
                OF ::oBarButton

            /* Boton PRINT */
            DEFINE PCTOOLBUTTON ::oBtns:oTBtnPrint      ;
                TEXT "Imprimir"              ;
                STOCK_ID GTK_STOCK_PRINT  ;
                ACTION EVAL( ::bPrint )      ;
                TOOLTIP "Imprimir...";
                OF ::oBarButton

         ELSE
            /* Boton NEW */
            DEFINE PCTOOLBUTTON ::oBtns:oTBtnNew      ;
                ACTION EVAL(  ::bNew )    ;
                ID "tbnew" RESOURCE cGlade

            /* Boton EDIT */
            DEFINE PCTOOLBUTTON ::oBtns:oTBtnEdit      ;
                ACTION EVAL(  ::bEdit )    ;
                ID "tbedit" RESOURCE cGlade

            /* Boton DELETE */
            DEFINE PCTOOLBUTTON ::oBtns:oTBtnDel      ;
                ACTION EVAL(  ::bDel )    ;
                ID "tbdel" RESOURCE cGlade

            /* Boton PRINT */
            DEFINE PCTOOLBUTTON ::oBtns:oTBtnPrint      ;
                ACTION EVAL(  ::bPrint )    ;
                ID "tbprint" RESOURCE ::cGlade

         ENDIF


      ENDIF

   EndIf


RETURN Self



// --------------------------------------------------------------------------------------- //

METHOD Active( bAction, bInit ) CLASS TPY_LISTBOX

   //Local x, i, oBox, cGlade

   ::bAction := bAction
   ::bInit   := bInit

   ::oModel:Listore( ::oBox, Self )

   IF ::lBar

      If ::lBotons

         IF ISNIL(::uGlade)

            /* Separador */
            DEFINE TOOL SEPARATOR ::oBtns:oSeparator1  ;
                   OF ::oBarButton  

            /* Boton QUIT */
            DEFINE PCTOOLBUTTON ::oBtns:oTBtnQuit      ;
                TEXT "Salir"              ;
                STOCK_ID GTK_STOCK_QUIT   ;
                ACTION EVAL( ::bQuit )    ;
                TOOLTIP "Salir...";
                OF Self

         ELSE

            /* Boton QUIT */
            DEFINE PCTOOLBUTTON ::oBtns:oTBtnQuit      ;
                ACTION EVAL( ::bQuit )    ;
                ID "tbquit" RESOURCE ::cGlade
         ENDIF

      EndIf

   Else
      ::oBarButton:Hide()
   EndIf

   If !ISNIL( ::oWnd )

      IF ISNIL(::uGlade)
         ACTIVATE WINDOW ::oWnd
      ENDIF

//   Else
//      MsgAlert("No hay Ventana Definida... ","Error")
   EndIf



RETURN Self

//---
//---  FUNCIONES PARA REVISAR Y REUBICAR
//---

FUNCTION QUERY2ARRAYCOMBO(cQuery,oConn)

   Local oQuery,aRes
   
   DEFAULT oConn := TPY_CONN
   
   IF Empty(cQuery) .OR. ValType(cQuery)<>"C"
      RETURN aRes
   ENDIF
   
   oQuery := oConn:Query(cQuery)
   
   If !Empty( oQuery:aData )
      aRes := {}
      AEVAL( oQuery:aData, { |a| AADD(aRes, {a[1],a[1]}) } )
      //aRes   := oQuery:aData
   EndIf

   oQuery := NIL
      
RETURN aRes



FUNCTION SetPicture( aCol )
  Local nPos, nAt
  Local cPicture,cPicMask
  Local cPicFunc   := ""

  cPicture   := Upper(aCol[6])

  nPos := AT("@", cPicture )
  if nPos > 0

    if nPos > 1
      cPicture := SubStr( cPicture, nPos )
    endif

    nAt := At( " ", cPicture )

    if nAt == 0
      cPicFunc := cPicture
      cPicMask := ""
    else
      cPicFunc := SubStr( cPicture, 1, nAt - 1 )
      cPicMask := SubStr( cPicture, nAt + 1 )
    endif
  else
    cPicFunc := ""
    cPicMask := cPicture
  endif


RETURN nil


//EOF
