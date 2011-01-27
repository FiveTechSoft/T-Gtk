/* $Id: gtreestore.prg,v 1.1 2006-09-07 16:28:06 xthefull Exp $*/
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

#define GtkTreeIter  Array( 4 )

CLASS GTREESTORE FROM GOBJECT
      DATA aTypes

      METHOD New( aTypes )
      METHOD NewAuto( aItems )
      METHOD Append( aValues )
      METHOD AppendChild( aValues , aParent )
      METHOD Insert( nRow, aValues , aParent )
      METHOD Set( aIter, nCol, uValue )
      METHOD SetValues( aIter, aValues )
      METHOD Clear() INLINE gtk_tree_store_clear( ::pWidget )
      METHOD Remove( aIter ) INLINE gtk_tree_store_remove( ::pWidget, aIter ) 


ENDCLASS

METHOD New( aTypes ) CLASS gTreeStore

      ::aTypes := aTypes
      ::pWidget  := gtk_tree_store_newv( Len( ::aTypes ) ,::aTypes  )

RETURN Self

METHOD NewAuto( aItems ) CLASS gTreeStore
      
      ::pWidget  := hb_gtk_tree_store_new( aItems )

RETURN Self

/*El iter tenemos que devolverlo, opcional, si despues queremos emplearlo con el
 comando SET */
METHOD Append( aValues ) CLASS gTreeStore
       Local aParent := GtkTreeIter
       Local nLen , n

       gtk_tree_store_append( ::pWidget, aParent )
       if aValues != NIL
          nLen := Len( aValues )
          for n := 1 to nLen
              gtk_tree_store_set( ::pWidget, n-1, aParent, aValues[ n ] )
          next
       endif

RETURN aParent

METHOD AppendChild( aValues, aParent ) CLASS gTreeStore
       Local aChild := GtkTreeIter
       Local nLen , n

       gtk_tree_store_append( ::pWidget, aChild, aParent )
       if aValues != NIL
          nLen := Len( aValues )
          for n := 1 to nLen
              gtk_tree_store_set( ::pWidget, n-1, aChild, aValues[ n ] )
          next
       endif

RETURN aChild

METHOD SetValues( aIter, aValues ) CLASS gTreeStore

   local nCols
   local n

   aValues = CheckArray( aValues )
   nCols   = Min( gtk_tree_model_get_n_columns( ::pWidget ), Len( aValues ) )
   
   for n = 1 to nCols
      ::Set( aIter, n, aValues[ n ] )
   next

RETURN NIL

METHOD Set( aIter, nCol, uValue ) CLASS gTreeStore

       gtk_tree_store_set( ::pWidget, nCol-1, aIter, uValue )

RETURN NIL

METHOD Insert( nRow, aValues, aParent ) CLASS gTreeStore
       Local aIter := GtkTreeIter
       Local nLen , n
       
       gtk_tree_store_insert( ::pWidget, aIter, aParent, nRow - 1)
       
       if aValues != NIL
          nLen := Len( aValues )
          for n := 1 to nLen
              gtk_tree_store_set( ::pWidget, n-1, aIter, aValues[ n ] )
          next
       endif

RETURN aIter

