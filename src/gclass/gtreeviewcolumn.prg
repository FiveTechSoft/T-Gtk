/* $Id: gtreeviewcolumn.prg,v 1.6 2010-02-09 04:22:04 riztan Exp $*/
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

CLASS gTreeViewColumn FROM GOBJECT

      DATA nColumn
      DATA cType
      DATA oRenderer
      DATA oTreeView
      DATA uAction


      METHOD New(  )  CONSTRUCTOR
      METHOD Register()               INLINE harb_signal_connect( ::pWidget, "destroy", Self )
      METHOD Renderer( cType )
      METHOD SetResizable( lResize )  INLINE gtk_tree_view_column_set_resizable( ::pWidget, lResize )
      METHOD SetVisible( lSet )       INLINE gtk_tree_view_column_set_visible( ::pWidget, lSet )
      METHOD GetVisible()             
      METHOD Width( nWidth )          INLINE gtk_tree_view_column_set_fixed_width( ::pWidget, nWidth )
      METHOD SetClickable( lClick )   INLINE gtk_tree_view_column_set_clickable( ::pWidget, lClick )
      METHOD SetSort( )               INLINE gtk_tree_view_column_set_sort_column_id( ::pWidget, ::nColumn )
      METHOD GetSort( )               INLINE gtk_tree_view_column_get_sort_column_id( ::pWidget ) + 1
      METHOD SetAlign( nAlign )       INLINE g_object_set( ::pWidget, "alignment", nAlign  )
      METHOD SetWidgetHeader( oWidget ) INLINE gtk_tree_view_column_set_widget( ::pWidget, oWidget:pWidget )
      METHOD SetSizing( nMode )       INLINE gtk_tree_view_column_set_sizing( ::pWidget, nMode )
      METHOD GetTitle( )              INLINE gtk_tree_view_column_get_title( ::pWidGet )
      
      //Signals
      METHOD OnClicked( oSender )
      
      // Signals Hierarchy re-write
      METHOD OnDestroy( oSender )

ENDCLASS

METHOD New( cTitle, cType, nPos, lExpand, oTreeView, nWidth, lSort, uAction, cId, uGlade ) CLASS gTreeViewColumn
      DEFAULT lExpand := .T.
      
      if cId == NIL
         ::pWidget := gtk_tree_view_column_new()
      else
         ::pWidget :=  GLADE_XML_GET_TREE_VIEW_COLUMN( uGlade, cId )
         ::CheckGlade( cId )
      endif

      if nPos != NIL
         ::nColumn := nPos - 1   
      endif
       
      if cTitle != NIL
         gtk_tree_view_column_set_title( ::pWidget, cTitle )
      endif
   
      if cType != NIL   // Si tenemos el tipo 
         ::uAction = uAction
         if Valtype( cType ) = "O" // Objeto pasado como parametro
            ::oRenderer := cType
            ::cType :=  ::oRenderer:cType
         else
            ::Renderer( cType )
         endif
         
         if oTreeView:ClassName() == "GTREEVIEW" 
            gtk_tree_view_column_pack_start( ::pWidget, ::oRenderer:pWidget, lExpand )
            gtk_tree_view_column_add_attribute( ::pWidget, ::oRenderer:pWidget, ::cType, nPos-1 )
         else     // Nos permite de esta forma, formar columnas texto + pixbuf, por ejemplo.
            gtk_tree_view_column_pack_start( oTreeView:pWidget, ::oRenderer:pWidget, lExpand )
            gtk_tree_view_column_add_attribute( oTreeView:pWidget, ::oRenderer:pWidget, ::cType, nPos-1 )
         endif
         
      endif
      
      if lSort .AND. ::nColumn != NIL
         ::SetSort()
      endif

      if nWidth != NIL
         ::SetSizing( GTK_TREE_VIEW_COLUMN_FIXED )
         ::Width( nWidth )
      endif

      if oTreeView != NIL 
         if oTreeView:ClassName() == "GTREEVIEW" //Solamente, cuando es un TreeView, no una columna
            oTreeView:AppendColumn( Self )
            ::Register()                         //Solamente CUANDO sea un TreeView, no forme parte de una columna.
            AADD( oTreeView:aCols, {Self, ::nColumn} )  // Para tener el Nro de Columna a la mano...
         endif
         ::oTreeView = oTreeView
      endif

RETURN Self


METHOD GetVisible()
RETURN gtk_tree_view_column_get_visible( ::pWidget )


METHOD Renderer( cType ) CLASS gTreeViewColumn
   
   cType := UPPER( cType )
   
   DO CASE
      CASE cType = "TEXT"
           ::oRenderer := gCellRendererText():New()
           ::cType := "text"
            if ::uAction != NIL
               ::oRenderer:SetEditable( .T. )
               ::oRenderer:bEdited := ::uAction
               ::oRenderer:SetColumn( Self ) 
            endif           
      CASE cType = "PIXBUF"
           ::oRenderer := gCellRendererPixbuf():New()
           ::cType := "pixbuf"
      CASE cType = "ACTIVE" .OR. cType = "CHECK"
           ::oRenderer = gCellRendererToggle():New()
           ::cType := "active"
            if ::uAction != NIL
               ::oRenderer:bAction := ::uAction
               ::oRenderer:SetColumn( Self ) 
            endif                      
      CASE cType = "PROGRESS"
           ::oRenderer = gCellRendererProgress():New()
           ::cType := "value"
      CASE cType = "COMBO"
           ::oRenderer = gCellRendererCombo():New()
           ::cType := "text"
   END CASE
   
   ::oRenderer:nColumn := ::nColumn
   
RETURN NIL

******************************************************************************
METHOD OnDestroy( oSender ) CLASS gTreeViewColumn
    Local nWidget

    if oSender:bDestroy != NIL
       Eval( oSender:bDestroy, oSender )
    endif

RETURN NIL

******************************************************************************
METHOD OnClicked( oSender ) CLASS gTreeViewColumn
    if oSender:bAction != NIL
       Eval( oSender:bAction, oSender )
    endif
RETURN .F.
