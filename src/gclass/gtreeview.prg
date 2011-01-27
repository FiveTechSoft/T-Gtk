/* $Id: gtreeview.prg,v 1.7 2010-05-01 20:51:21 xthefull Exp $*/
/*
    LGPL Licence.
    
    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this software; see the file COPYING.  If not, write to
    the Free Software Foundation, Inc., 59 Temple Place, Suite 330,
    Boston, MA 02111-1307 USA (or visit the web site http://www.gnu.org/).

    LGPL Licence.
    (c)2003 Rafael Carmona <thefull@wanadoo.es>
*/
#include "gtkapi.ch"
#include "hbclass.ch"

CLASS GTREEVIEW FROM GCONTAINER
      DATA bRow_Activated, bColumns_Changed
      DATA bMoveCursor, bCursorChanged
      DATA oModel 
      DATA aCols

      METHOD New( )
      METHOD SetModel( oModel )     
      METHOD GetModel() INLINE gtk_tree_view_get_model( ::pWidget )
      METHOD ClearModel( )           
      
      
      METHOD SetAutoSize() INLINE gtk_tree_view_columns_autosize( ::pWidget ) 

      METHOD GetValue( nColumn, cType, path )
      METHOD GetAutoValue( nColumn, aIter, aIter_Clone )      
      METHOD GetSelection( ) INLINE gtk_tree_view_get_selection( ::pWidget )
      METHOD GetAutoValueIter( nColumn, aIter, aIter_Clone )

      METHOD SetRules( lSetting ) INLINE gtk_tree_view_set_rules_hint( ::pWidget, lSetting )
      METHOD GetColumns() INLINE gtk_tree_model_get_n_columns( ::GetModel() ) 
      METHOD GetColumn( nColumn ) INLINE gtk_tree_view_get_column( ::pWidget, nColumn ) 
      METHOD GetColumnType( nColumn )      INLINE gtk_list_store_get_col_type( ::GetModel(), nColumn )
      METHOD GetColumnTypeStr( nColumn )   
      METHOD RemoveColumn( nColumn ) 
      METHOD RemoveRow( pSelection ) 
      METHOD AppendColumn( oTreeViewColumn ) INLINE gtk_tree_view_append_column( ::pWidget, oTreeViewColumn:pWidget )
      
      METHOD GetSearchColumn()          INLINE ( gtk_tree_view_get_search_column( ::pWidget ) + 1 )
      METHOD SetSearchColumn( nColumn ) INLINE gtk_tree_view_set_search_column( ::pWidget, nColumn - 1 )

      METHOD OnRow_Activated( oSender, pPath, pTreeViewColumn ) SETGET
      METHOD IsGetSelected( aIter ) 
      METHOD GetPath( aIter ) INLINE gtk_tree_model_get_path( ::GetModel(), aIter )
      METHOD GetPosCol( cTitle )
      METHOD GetTotalColumns()  INLINE HB_GTK_TREE_VIEW_GET_TOTAL_COLUMNS( ::pWidget )

      METHOD GetPosRow( aIter )
      METHOD SetPosRow( aIter, nCol )

      METHOD GoUp()   INLINE HB_GTK_TREE_VIEW_UP_ROW( ::pWidget )
      METHOD GoDown() INLINE HB_GTK_TREE_VIEW_DOWN_ROW( ::pWidget )
      
      METHOD GoNext() INLINE HB_GTK_TREE_VIEW_NEXT_ROW( ::pWidget )
      METHOD GoPrev() INLINE HB_GTK_TREE_VIEW_PREV_ROW( ::pWidget )

      METHOD FillArray()
      METHOD aRow( aIter )
      METHOD GetIterFirst( aIter ) INLINE gtk_tree_model_get_iter_first( ::GetModel(), aIter )
      METHOD GetIterNext( aIter )  INLINE gtk_tree_model_iter_next( ::GetModel(), aIter )  
      
      METHOD OnColumns_changed ( oSender ) VIRTUAL
      METHOD OnCursorChanged( oSender )  SETGET // cursor-changed
      METHOD OnMoveCursor( oSender, arg1, arg2 ) SETGET

ENDCLASS

METHOD NEW( oModel, oParent, lExpand,;
            lFill, nPadding , lContainer, x, y, cId, uGlade, nCursor,;
            uLabelTab, nWidth, nHeight, oBar, cMsgBar, lEnd, lSecond, lResize, lShrink,;
            left_ta,right_ta,top_ta,bottom_ta, xOptions_ta, yOptions_ta,;
            bOnRow_Activate, bOnMove, bOnChange, n ) CLASS gTreeView
            
   HB_SYMBOL_UNUSED( nCursor )
   HB_SYMBOL_UNUSED( oBar )
   HB_SYMBOL_UNUSED( cMsgBar )
   
   IF cId == NIL
      if oModel != NIL
        ::pWidget := gtk_tree_view_new_with_model( oModel:pWidget )
      else                                                    
        ::pWidget := gtk_tree_view_new(  )
      endif
   ELSE
      ::pWidget := glade_xml_get_widget( uGlade, cId )
      ::CheckGlade( cId )
      if oModel != NIL
         ::SetModel( oModel )
      endif
   ENDIF
   
   ::oModel = oModel
   ::aCols := {}
   ::Register()
   ::AddChild( oParent, lExpand, lFill, nPadding, lContainer, x, y,;
               uLabelTab, lEnd, lSecond, lResize, lShrink,;
               left_ta,right_ta,top_ta,bottom_ta, xOptions_ta, yOptions_ta  )
   
   if nWidth != NIL
      ::Size( nWidth, nHeight )
   endif
   
   ::Connect( "row-activated" ) // Se activa para permitir el coger valores a traves de bRow_Activated
   
   if bOnRow_Activate != NIL
      ::OnRow_Activated = bOnRow_Activate
   endif
   
   if bOnMove != NIL
      ::OnMoveCursor = bOnMove
   endif
   
   if bOnChange != NIL
      ::OnCursorChanged = bOnChange
   endif

   ::Show()
     
RETURN Self

METHOD SetModel( oModel ) CLASS gTreeView    

    if oModel!= NIL
       gtk_tree_view_set_model( ::pWidget, oModel:pWidget ) 
    else
       gtk_tree_view_set_model( ::pWidget, NIL )  //Quitamos el modelo de datos antiguo
    endif
    
    ::oModel := oModel

RETURN NIL

METHOD ClearModel( ) CLASS gTreeView    
    
    if ::oModel != NIL
       ::oModel:Clear()
    endif

RETURN NIL



METHOD RemoveColumn( nColumn ) CLASS gTreeView
   Local hColumn := ::GetColumn( nColumn-1 )
   gtk_tree_view_remove_column( ::pWidget, hColumn )
RETURN NIL



METHOD RemoveRow( pSelection ) CLASS gTreeView
   local aIter      := Array( 4 )
   local path
   local i
   local model 
   
   DEFAULT pSelection := ::GetSelection()
  
   model = ::GetModel()
   
   if gtk_tree_selection_get_selected( pSelection, NIL, aIter ) 
      path = gtk_tree_model_get_path( model, aiter )
      i    = hb_gtk_tree_path_get_indices( path ) + 1 // Obtenemos la fila donde estamos
      ::oModel:Remove( aIter )
      gtk_tree_path_free( path )
   endif
   
RETURN NIL


METHOD FillArray( ) CLASS gTreeView

   local nColumns := ::GetColumns()
   local aIter    := Array( 4 )
   local n, nRow
   local aData    := {}
   local pModel   := ::GetModel()
   local lRet 
   
   lRet = ::GetIterFirst( aIter )
   nRow = 1
   do while lRet
      AAdd( aData, {} )
      for n = 1 to nColumns
         AAdd( aData[ nRow ], gtk_tree_model_get( pModel, aIter, n ) )
      next
      nRow++
      lRet = ::GetIterNext( aIter )
   enddo
   
return aData

RETURN NIL

METHOD aRow( aItr ) CLASS gTreeView

   local model
   local aIter := Array( 4 ) 
   local nColumns := ::GetColumns()
   local aData := Array( nColumns )
   local n
   
   
   if ::IsGetSelected( aIter ) // Si fue posible seleccionarlo 
      aItr = aIter
      model = ::GetModel()
      for n = 1 to nColumns
         aData[ n ] = gtk_tree_model_get( model, aIter, n )
      next   
   endif
   
return aData   


METHOD GetValue( nColumn, cType, path, aIter_Clone ) CLASS gTreeView
   Local model, aIter := Array( 4 ) 
   Local uValue, nType
   
   DEFAULT nColumn := 1
   
   HB_SYMBOL_UNUSED( cType )
   
   model  = ::GetModel() 
   gtk_tree_model_get_iter( model, aIter, path )
   uValue = gtk_tree_model_get( model, aIter, nColumn )
   aIter_Clone = aIter
   
  /* 
   IF Empty( cType ) // Si no se especifica tipo, averiguamos...
       nType := gtk_tree_model_get_column_type( model, nColumn - 1 )
       DO CASE
          CASE ( nType = G_TYPE_CHAR .OR. nType = G_TYPE_UCHAR .OR. nType = G_TYPE_STRING     )
               cType := "String"
          CASE ( nType = G_TYPE_INT .OR. nType = G_TYPE_UINT .OR. nType = G_TYPE_INT64 .OR.nType = G_TYPE_UINT64 )
               cType := "Int"
          CASE ( nType = G_TYPE_BOOLEAN )
               cType := "Boolean"
          CASE ( nType = G_TYPE_LONG .OR. nType = G_TYPE_ULONG )
               cType := "Long"
          CASE ( nType = G_TYPE_POINTER .OR. nType = GDK_TYPE_PIXBUF )
               cType := "Pointer"               
          CASE ( nType = G_TYPE_DOUBLE .OR. nType = G_TYPE_FLOAT )
               cType := "Double"
       END CASE
   ENDIF

   IF( gtk_tree_model_get_iter( model, aIter, path ) )
      DO CASE
         CASE Lower( cType ) = "string" .OR. Lower( cType ) = "text" 
              hb_gtk_tree_model_get_string( model, aIter, nColumn - 1, @uValue ) 
         CASE Lower( cType ) = "int"
              hb_gtk_tree_model_get_int( model, aIter,  nColumn - 1, @uValue ) 
         CASE Lower( cType ) = "boolean"
              hb_gtk_tree_model_get_boolean( model, aIter,  nColumn - 1, @uValue ) 
         CASE Lower( cType ) = "long"
              hb_gtk_tree_model_get_long( model, aIter, nColumn - 1, @uValue )
         CASE Lower( cType ) = "pointer"
              hb_gtk_tree_model_get_pointer( model, aIter, nColumn - 1, @uValue )                
         CASE Lower( cType ) = "double"
              hb_gtk_tree_model_get_double( model, aIter, nColumn - 1, @uValue ) 
      END CASE
      aIter_Clone := aIter
   ENDIF
*/


RETURN uValue


METHOD GetAutoValue( nColumn, aIter, aIter_Clone ) CLASS gTreeView
   Local model
   Local uValue, nType, path
   
   DEFAULT nColumn := 1,;
           aIter := Array( 4 ) 
   
   model := ::GetModel() 
   
   IF ::IsGetSelected( aIter ) // Si fue posible seleccionarlo 
      Path  := ::GetPath( aIter ) 
   ELSE
      Return NIL
   ENDIF

   nType := gtk_tree_model_get_column_type( model, nColumn - 1 )

   IF( gtk_tree_model_get_iter( model, aIter, path ) )
      DO CASE
         CASE ( nType = G_TYPE_CHAR .OR. nType = G_TYPE_UCHAR .OR. nType = G_TYPE_STRING )
              hb_gtk_tree_model_get_string( model, aIter, nColumn - 1, @uValue ) 
         CASE ( nType = G_TYPE_INT .OR. nType = G_TYPE_UINT .OR. nType = G_TYPE_INT64 .OR.nType = G_TYPE_UINT64 )
              hb_gtk_tree_model_get_int( model, aIter,  nColumn - 1, @uValue ) 
         CASE ( nType = G_TYPE_BOOLEAN )
              hb_gtk_tree_model_get_boolean( model, aIter,  nColumn - 1, @uValue ) 
         CASE ( nType = G_TYPE_LONG .OR. nType = G_TYPE_ULONG )
              hb_gtk_tree_model_get_long( model, aIter, nColumn - 1, @uValue ) 
         CASE ( nType = G_TYPE_DOUBLE .OR. nType = G_TYPE_FLOAT )
              hb_gtk_tree_model_get_double( model, aIter, nColumn - 1, @uValue )
         CASE ( nType = G_TYPE_POINTER .OR. nType = GDK_TYPE_PIXBUF )
              hb_gtk_tree_model_get_pointer( model, aIter, nColumn - 1, @uValue ) 
      END CASE
      aIter_Clone := aIter
   ENDIF
   
   gtk_tree_path_free( Path )

RETURN uValue


METHOD IsGetSelected( aIter ) CLASS gTreeView
RETURN gtk_tree_selection_get_selected( ::GetSelection(), NIL, aIter ) 


METHOD GetPosRow( aIter ) CLASS gTreeView
   Local nPos := 0
   Local pPath 

   IF ::IsGetSelected( aIter )
      pPath := ::GetPath( aIter )
      nPos  := hb_gtk_tree_path_get_indices( pPath ) + 1 // Obtenemos la fila donde estamos
      gtk_tree_path_free( pPath )
   ENDIF

RETURN nPos


METHOD SetPosRow( aIter, nCol ) CLASS gTreeView
   Local nPos := 0
   Local pPath 
   local pColumn
   
   default nCol := 1
   
   if aIter == NIL
      aIter = Array( 4 ) 
      ::IsGetSelected( aIter )
   endif
   
   pColumn = ::GetColumn( nCol )
   pPath   = ::GetPath( aIter )
   gtk_tree_view_set_cursor( ::pWidget, pPath, pColumn, .F. ) 
   
   gtk_tree_path_free( pPath )

RETURN nil



METHOD GetPosCol( cTitle ) CLASS gTreeView
   Local nCol := -1

   AEVAL( ::aCols, {| o | IIF( o[1]:GetTitle() == cTitle, nCol := o[2]+1, NIL)   } )

RETURN nCol


METHOD GetAutoValueIter( nColumn, aIter, aIter_Clone ) CLASS gTreeView
   Local model
   Local uValue, nType, path
   
   DEFAULT nColumn := 1,;
           aIter := Array( 4 ) 
   
   model := ::GetModel() 
   Path  := ::GetPath( aIter ) 

   nType := gtk_tree_model_get_column_type( model, nColumn - 1 )

   IF( gtk_tree_model_get_iter( model, aIter, path ) )
      DO CASE
         CASE ( nType = G_TYPE_CHAR .OR. nType = G_TYPE_UCHAR .OR. nType = G_TYPE_STRING )
              hb_gtk_tree_model_get_string( model, aIter, nColumn - 1, @uValue ) 
         CASE ( nType = G_TYPE_INT .OR. nType = G_TYPE_UINT .OR. nType = G_TYPE_INT64 .OR.nType = G_TYPE_UINT64 )
              hb_gtk_tree_model_get_int( model, aIter,  nColumn - 1, @uValue ) 
         CASE ( nType = G_TYPE_BOOLEAN )
              hb_gtk_tree_model_get_boolean( model, aIter,  nColumn - 1, @uValue ) 
         CASE ( nType = G_TYPE_LONG .OR. nType = G_TYPE_ULONG )
              hb_gtk_tree_model_get_long( model, aIter, nColumn - 1, @uValue ) 
         CASE ( nType = G_TYPE_DOUBLE .OR. nType = G_TYPE_FLOAT )
              hb_gtk_tree_model_get_double( model, aIter, nColumn - 1, @uValue ) 
      END CASE
      aIter_Clone := aIter
   ENDIF
   
   gtk_tree_path_free( Path )

RETURN uValue


METHOD GetColumnTypeStr( nColumn ) CLASS gTreeView
   Local cType := NIL
   Local nType := ::GetColumnType( nColumn - 1 )
   
   DO CASE
      CASE ( nType = G_TYPE_CHAR .OR. nType = G_TYPE_UCHAR .OR. nType = G_TYPE_STRING     )
           cType := "String"
      CASE ( nType = G_TYPE_INT .OR. nType = G_TYPE_UINT .OR. nType = G_TYPE_INT64 .OR.nType = G_TYPE_UINT64 )
           cType := "Int"
      CASE ( nType = G_TYPE_BOOLEAN )
           cType := "Boolean"
      CASE ( nType = G_TYPE_LONG .OR. nType = G_TYPE_ULONG .OR. nType = GDK_TYPE_PIXBUF )
           cType := "Long"
      CASE ( nType = G_TYPE_DOUBLE .OR. nType = G_TYPE_FLOAT )
           cType := "Double"
   END CASE
       
Return cType       


METHOD OnRow_Activated( uParam, pPath, pTreeViewColumn ) CLASS gTreeView
     
   if hb_IsBlock( uParam )
      ::bRow_Activated = uParam
   elseif hb_IsObject( uParam ) 
      if hb_IsBlock( ::bRow_Activated )
         Eval( uParam:bRow_Activated, pPath, pTreeViewColumn )
      endif
   endif    
    
RETURN NIL


METHOD OnMoveCursor( uParam, nStep, nCount ) CLASS gTreeView //move-cursor

   if hb_IsBlock( uParam )
      ::bMoveCursor = uParam
      ::Connect( "move-cursor" )
   elseif hb_IsObject( uParam ) 
      if hb_IsBlock( ::bMoveCursor )
         Eval( uParam:bMoveCursor, nStep, nCount )
      endif
   endif    
  
  
RETURN NIL


METHOD OnCursorChanged( uParam )  CLASS gTreeView // cursor-changed

   local aIter := Array( 4 )
   local pPath

   if hb_IsBlock( uParam )
      ::bCursorChanged = uParam
      ::Connect( "cursor-changed" )
   elseif hb_IsObject( uParam ) 
      if hb_IsBlock( ::bCursorChanged )
         ::IsGetSelected( aIter )
         pPath   = ::GetPath( aIter )
         Eval( uParam:bCursorChanged, aIter, pPath )
         gtk_tree_path_free( pPath )
      endif
   endif    

RETURN NIL


/*
 METHOD OnColumns_Changed( oSender ) CLASS gTreeView
    
    if oSender:bColumns_Changed != NIL
       Eval( oSender:bColumns_Changed , oSender )
    endif

RETURN NIL
*/

