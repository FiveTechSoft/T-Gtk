/* $Id: gtreeviewcolumn.prg,v 1.6 2015-01-04 12:31:21 riztan Exp $*/
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
      METHOD Register()                 INLINE harb_signal_connect( ::pWidget, "destroy", Self )
      METHOD Renderer( cType )
      METHOD SetResizable( lResize )    INLINE gtk_tree_view_column_set_resizable( ::pWidget, lResize )
      METHOD SetVisible( lSet )         INLINE gtk_tree_view_column_set_visible( ::pWidget, lSet )
      METHOD GetVisible()             
      METHOD Width( nWidth )            INLINE gtk_tree_view_column_set_fixed_width( ::pWidget, nWidth )
      METHOD SetClickable( lClick )     INLINE gtk_tree_view_column_set_clickable( ::pWidget, lClick )
      METHOD SetSort( )                 INLINE gtk_tree_view_column_set_sort_column_id( ::pWidget, ::nColumn )
      METHOD GetSort( )                 INLINE gtk_tree_view_column_get_sort_column_id( ::pWidget ) + 1
      METHOD SetAlign( nAlign )         INLINE g_object_set( ::pWidget, "alignment", nAlign  )
      METHOD SetWidgetHeader( oWidget ) INLINE gtk_tree_view_column_set_widget( ::pWidget, oWidget:pWidget )
      METHOD SetSizing( nMode )         INLINE gtk_tree_view_column_set_sizing( ::pWidget, nMode )
      METHOD GetTitle( )                INLINE gtk_tree_view_column_get_title( ::pWidGet )
      METHOD SetTitle( cTitle )         INLINE gtk_tree_view_column_set_title( ::pWidGet, cTitle )
      METHOD SetFunction( cFunction )   INLINE gtk_tree_view_column_set_cell_data_func(::pWidget,::oRenderer:pWidget, cFunction )
      
      //Signals
      METHOD OnClicked( oSender )
      
      // Signals Hierarchy re-write
      METHOD OnDestroy( oSender )

ENDCLASS

METHOD New( cTitle, cType, nPos, lExpand, oTreeView, nWidth, lSort, uAction, cId, uGlade, cId_Renderer, oComboModel, nTextModelCol ) CLASS gTreeViewColumn
      DEFAULT lExpand := .T.
      
      if cId == NIL
         ::pWidget := gtk_tree_view_column_new()
      else
         ::pWidget :=  GLADE_XML_GET_TREE_VIEW_COLUMN( uGlade, cId )
         ::CheckGlade( cId )
      endif

      if nPos != NIL
         ::nColumn := nPos - COL_INIT   
      endif
       
      if cTitle != NIL
         gtk_tree_view_column_set_title( ::pWidget, cTitle )
      endif
   
      if cType != NIL .and. cId_Renderer = NIL   // Si tenemos el tipo y no es desde glade
         ::uAction = uAction
         if Valtype( cType ) = "O" // Objeto pasado como parametro
            ::oRenderer := cType
            ::cType :=  ::oRenderer:cType
            if ::uAction != NIL                 // Si hay una accion , la activamos
               ::oRenderer:SetEditable( .T. )
               ::oRenderer:bEdited := ::uAction
               ::oRenderer:SetColumn( Self ) 
            endif           
        else
            ::Renderer( cType,,,oComboModel, nTextModelCol )
        endif

        if cId = NIL   // Solo si no es definido en Glade
	   if oTreeView:ClassName() == "GTREEVIEW" 
		gtk_tree_view_column_pack_start( ::pWidget, ::oRenderer:pWidget, lExpand )
		gtk_tree_view_column_add_attribute( ::pWidget, ::oRenderer:pWidget, ::cType, nPos - COL_INIT )
	   else     // Nos permite de esta forma, formar columnas texto + pixbuf, por ejemplo.
		gtk_tree_view_column_pack_start( oTreeView:pWidget, ::oRenderer:pWidget, lExpand )
		gtk_tree_view_column_add_attribute( oTreeView:pWidget, ::oRenderer:pWidget, ::cType, nPos - COL_INIT )
	   endif
        endif  
      endif
      
      if cId_Renderer  != NIL  // RENDERER desde Glade
	::uAction = uAction
        if empty( cType )      // OJO con esto, de momento, esta solo soporta text y pixbufs
           cType := "text"
        endif
        ::Renderer( cType, cId_Renderer, uGlade, oComboModel, nTextModelCol )
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
            if cId = NIL   // Solo si no es definido en Glade
               if nPos = NIL
                  oTreeView:AppendColumn( Self )
               else
                  oTreeView:InsertColumn( Self, ::nColumn )
               endif
               ::Register()                         //Solamente CUANDO sea un TreeView, no forme parte de una columna.
            endif    
            AADD( oTreeView:aCols, {Self, ::nColumn} )  // Para tener el Nro de Columna a la mano...
         endif
         ::oTreeView = oTreeView
      endif

RETURN Self


METHOD GetVisible()
RETURN gtk_tree_view_column_get_visible( ::pWidget )


METHOD Renderer( cType, cId, pGlade, oComboModel, nTextModelCol ) CLASS gTreeViewColumn
   
   cType := UPPER( cType )
   
   DO CASE
      CASE cType = "TEXT"
           ::oRenderer := gCellRendererText():New( cId, pGlade )
           ::cType := "text"
            if ::uAction != NIL
               ::oRenderer:SetEditable( .T. )
               ::oRenderer:bEdited := ::uAction
               ::oRenderer:SetColumn( Self ) 
            endif           

      CASE cType = "PIXBUF"
           ::oRenderer := gCellRendererPixbuf():New( cId, pGlade )
           ::cType := "pixbuf"
      CASE cType = "ACTIVE" .OR. cType = "CHECK"
           ::oRenderer = gCellRendererToggle():New( cId, pGlade )
           ::cType := "active"
            if ::uAction != NIL
               ::oRenderer:bAction := ::uAction
               ::oRenderer:SetColumn( Self ) 
            endif                      
      CASE cType = "PROGRESS"
           ::oRenderer = gCellRendererProgress():New()
           ::cType := "value"
      CASE cType = "COMBO"
           ::oRenderer = gCellRendererCombo():New( oComboModel, nTextModelCol )
           ::cType := "text"
            if ::uAction != NIL
               ::oRenderer:SetEditable( .T. )
               ::oRenderer:bEdited := ::uAction
               ::oRenderer:SetColumn( Self ) 
            endif           

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
