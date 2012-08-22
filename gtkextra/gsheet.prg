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
    (c)2012 Rafael Carmona <thefull@wanadoo.es>
    (c)2012 Riztan Gutierrez <riztan@t-gtk.org>
*/
#include "gtkapi.ch"
#include "hbclass.ch"

#ifdef __XHARBOUR__
#define HB_SYMBOL_UNUSED( symbol )  ( symbol := ( symbol ) )
#endif

CLASS GSHEET FROM GCONTAINER
      DATA bRow_Activated, bColumns_Changed
      DATA bMoveCursor, bCursorChanged
      DATA oModel 
      DATA aCols
      DATA aoMenuPopup  // Arrays de Menus { oMenu_Nivel1, oMenu_Nivel2,...}

      METHOD New( )
/*
      METHOD SetModel( oModel )     
      METHOD GetModel() INLINE gtk_tree_view_get_model( ::pWidget )
      METHOD ClearModel( )           
     
      METHOD SetAutoSize() INLINE gtk_tree_view_columns_autosize( ::pWidget ) 

      METHOD GetChildNum(aIter,path)
      METHOD HasChild(aIter,path)

      METHOD Expand(path,lAll) INLINE ;
                               gtk_tree_view_expand_row(::pWidget,path,lAll) 
      METHOD Collapse(path) INLINE ;
                               gtk_tree_view_collapse_row(::pWidget,path) 

      METHOD GetValue( nColumn, cType, path )
      METHOD SetValue( nColumn, cValue, path, oLbx )
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
      METHOD AppendColumn( oTreeViewColumn ) ;
                                INLINE gtk_tree_view_append_column( ::pWidget, oTreeViewColumn:pWidget )
      METHOD InsertColumn( oTreeViewColumn, nPos ) ;
                                INLINE gtk_tree_view_insert_column( ::pWidget, oTreeViewColumn:pWidget, nPos )
      
      METHOD GetSearchColumn()          INLINE ( gtk_tree_view_get_search_column( ::pWidget ) + COL_INIT )
      METHOD SetSearchColumn( nColumn ) INLINE gtk_tree_view_set_search_column( ::pWidget, nColumn - COL_INIT )

      METHOD OnRow_Activated( oSender, pPath, pTreeViewColumn ) SETGET
      METHOD IsGetSelected( aIter ) 
      METHOD GetPath( aIter ) INLINE gtk_tree_model_get_path( ::GetModel(), aIter )

      METHOD GetPosCol( cTitle )
      METHOD SetPosCol( aIter, nColumn )

      METHOD GetTotalColumns()  INLINE HB_GTK_TREE_VIEW_GET_TOTAL_COLUMNS( ::pWidget )

      METHOD GetPosRow( aIter )
      METHOD SetPosRow( aIter, nCol )

      METHOD GetDepth( path ) 

      METHOD GoUp()   INLINE HB_GTK_TREE_VIEW_UP_ROW( ::pWidget )
      METHOD GoDown() INLINE HB_GTK_TREE_VIEW_DOWN_ROW( ::pWidget )
      
      METHOD GoNext() INLINE HB_GTK_TREE_VIEW_NEXT_ROW( ::pWidget )
      METHOD GoPrev() INLINE HB_GTK_TREE_VIEW_PREV_ROW( ::pWidget )

      METHOD FillArray()
      METHOD aRow( aIter,path )
      METHOD GetIterFirst( aIter ) INLINE gtk_tree_model_get_iter_first( ::GetModel(), aIter )
      METHOD GetIterNext( aIter )  INLINE gtk_tree_model_iter_next( ::GetModel(), aIter )  

      METHOD SetMenuPopup( aoMenuPopup )

      METHOD EnableTreeLines( lEnable ) INLINE gtk_tree_view_set_enable_tree_lines( ::pWidget, lEnable )
      METHOD IsEnableTreeLines()        INLINE gtk_tree_view_get_enable_tree_lines( ::pWidget )

      METHOD SetGridLines( GtkTreeViewGridLines ) ;
                                   INLINE gtk_tree_view_set_grid_lines ( ::pWidget, GtkTreeViewGridLines )
      METHOD GetGridLines( ) inline gtk_tree_view_set_grid_lines ( ::pWidget )

      METHOD DelRow()
      
      METHOD OnColumns_changed ( oSender ) VIRTUAL
      METHOD OnCursorChanged( oSender )  SETGET // cursor-changed
      METHOD OnMoveCursor( oSender, arg1, arg2 ) SETGET
      METHOD OnEvent( oSender, pGdkEvent )
*/
ENDCLASS

METHOD NEW( cTitle, oParent, lExpand, lBrowser,;
            lFill, nPadding , lContainer, x, y, cId, uGlade, nCursor,;
            uLabelTab, nLines, nColumns, oBar, cMsgBar, lEnd, lSecond, lResize, lShrink,;
            left_ta,right_ta,top_ta,bottom_ta, xOptions_ta, yOptions_ta,;
            bOnRow_Activate, bOnMove, bOnChange, n ) CLASS gSheet

   IF hb_ISNIL( nLines )   ; nLines:=10      ; ENDIF
   IF hb_ISNIL( nColumns ) ; nColumns:=10    ; ENDIF
   IF hb_ISNIL( cTitle )   ; cTitle:="Sheet" ; ENDIF

   HB_SYMBOL_UNUSED( nCursor )
   HB_SYMBOL_UNUSED( oBar )
   HB_SYMBOL_UNUSED( cMsgBar )
   
   IF cId == NIL
      if lBrowser
        ::pWidget := gtk_sheet_new_browser(nLines, nColumns, cTitle )
      else                                                    
        ::pWidget := gtk_sheet_new(nLines, nColumns, cTitle )
      endif
   ELSE
      ::pWidget := glade_xml_get_widget( uGlade, cId )
      ::CheckGlade( cId )
   ENDIF
   
   ::Register()
   //::AddChild( oParent, lExpand, lFill, nPadding, lContainer, x, y,;
   //            uLabelTab, lEnd, lSecond, lResize, lShrink,;
   //            left_ta,right_ta,top_ta,bottom_ta, xOptions_ta, yOptions_ta  )
   ::AddContainer( oParent )
   
   //::Connect( "row-activated" ) // Se activa para permitir el coger valores a traves de bRow_Activated
   
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

*/

