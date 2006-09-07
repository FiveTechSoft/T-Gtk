/* $Id: giconview.prg,v 1.1 2006-09-07 17:02:44 xthefull Exp $*/
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

CLASS GICONVIEW FROM GCONTAINER
      DATA bItem_Activated
      DATA oModel 

      METHOD New( )
      METHOD SetModel( oModel )     
      METHOD GetModel() INLINE gtk_icon_view_get_model( ::pWidget )
      METHOD ClearModel()

      METHOD SetTexColumn( nColumn )    INLINE gtk_icon_view_set_text_column( ::pWidget, nColumn - 1 )
      METHOD SetPixBufColumn( nColumn ) INLINE gtk_icon_view_set_pixbuf_column( ::pWidget, nColumn - 1 )
      METHOD SetItemWidth( nWidth )     INLINE gtk_icon_view_set_item_width( ::pWidget, nWidth )
      METHOD SetColumns( nColumns )     INLINE gtk_icon_view_set_columns( ::pWidget, nColumns )
      METHOD SetOrientation( nOrient)   INLINE gtk_icon_view_set_orientation( ::pWidget, nOrient )
      METHOD GetValue( nColumn, cType, path, aIter_Clone )
      METHOD GetPath( aIter ) INLINE gtk_tree_model_get_path( ::GetModel(), aIter )
      
      METHOD GetCursor( path, cell )
      METHOD IsGetSelected( aIter ) 

      METHOD OnItem_Activated( oSender, pGtkTreePath ) 

ENDCLASS

METHOD NEW( oModel, oParent, lExpand,;
            lFill, nPadding , lContainer, x, y, cId, uGlade, nCursor,;
            uLabelTab, nWidth, nHeight, oBar, cMsgBar, lEnd, lSecond, lResize, lShrink,;
            left_ta,right_ta,top_ta,bottom_ta, xOptions_ta, yOptions_ta ) CLASS gIconView
   
   IF cId == NIL
      if oModel != NIL
        ::pWidget := gtk_icon_view_new_with_model( oModel:pWidget )
      else                                                    
        ::pWidget := gtk_icon_view_new(  )
      endif
   ELSE
      ::pWidget := glade_xml_get_widget( uGlade, cId )
      ::CheckGlade( cId )
      if oModel != NIL
         ::SetModel( oModel )
      endif
   ENDIF
   
   ::Register()
   ::AddChild( oParent, lExpand, lFill, nPadding, lContainer, x, y,;
               uLabelTab, lEnd, lSecond, lResize, lShrink,;
               left_ta,right_ta,top_ta,bottom_ta, xOptions_ta, yOptions_ta  )
   
   if nWidth != NIL
      ::Size( nWidth, nHeight )
   endif
   
   ::Connect( "item-activated" ) // Se activa para permitir el coger valores a traves de bRow_Activated

   ::Show()
     
RETURN Self

METHOD SetModel( oModel ) CLASS gIconView    

    if oModel!= NIL
       gtk_icon_view_set_model( ::pWidget, oModel:pWidget ) 
    else
       gtk_icon_view_set_model( ::pWidget, NIL )  //Quitamos el modelo de datos antiguo
    endif  
    
    ::oModel := oModel

RETURN NIL

METHOD ClearModel( ) CLASS gIconView
    
    if ::oModel != NIL
       ::oModel:Clear()
    endif

RETURN NIL

METHOD OnItem_Activated( oSender, pGtkTreePath ) CLASS gIconView
    
    if oSender:bItem_Activated != NIL
       Eval( oSender:bItem_Activated, oSender, pGtkTreePath )
    endif

RETURN NIL

METHOD GetValue( nColumn, cType, path, aIter_Clone ) CLASS gIconView
   Local model, aIter := Array( 4 ) 
   Local uValue, nType
   
   DEFAULT nColumn := 1,;
           cType := ""

   model := ::GetModel() 
   
   IF Empty( cType ) // Si no se especifica tipo, averiguamos...
       nType := gtk_tree_model_get_column_type( model, nColumn - 1 )
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
   ENDIF

   IF( gtk_tree_model_get_iter( model, aIter, path ) )
      DO CASE
         CASE cType = "String" .OR. cType = "Text" 
              hb_gtk_tree_model_get_string( model, aIter, nColumn - 1, @uValue ) 
         CASE cType = "Int"
              hb_gtk_tree_model_get_int( model, aIter,  nColumn - 1, @uValue ) 
         CASE cType = "Boolean"
              hb_gtk_tree_model_get_boolean( model, aIter,  nColumn - 1, @uValue ) 
         CASE cType = "Long"
              hb_gtk_tree_model_get_long( model, aIter, nColumn - 1, @uValue ) 
         CASE cType = "Double"
              hb_gtk_tree_model_get_double( model, aIter, nColumn - 1, @uValue ) 
      END CASE
      aIter_Clone := aIter
   ENDIF

RETURN uValue


METHOD GetCursor( uPath, uCell ) CLASS gIConView
    Local path , cell
    Local lRet
    
    lRet := GTK_ICON_VIEW_GET_CURSOR( ::pWidget, @Path, @Cell )
    uPath := path
    uCell := cell
    
RETURN lRet

METHOD IsGetSelected( aIter ) CLASS gIconView
    Local lRet := .F.
    Local path , cell
    
    if ( lRet := ::GetCursor( @Path, @Cell ) )
       GTK_TREE_MODEL_GET_ITER( ::GetModel(), aIter, Path )
       gtk_tree_path_free( Path )
    endif

RETURN lRet 
