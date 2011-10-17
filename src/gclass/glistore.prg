/* $Id: glistore.prg,v 1.1 2006-09-07 17:02:44 xthefull Exp $*/
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
 
CLASS GLISTSTORE FROM GOBJECT
      DATA aTypes

      METHOD New( aTypes )
      METHOD NewAuto( aTypes )
      METHOD Append( aValues )
      METHOD Insert( nRow, aValues )
      METHOD Set( aIter, nCol, uValue )
      METHOD SetValues( aIter, aValues )
      METHOD Clear() INLINE gtk_list_store_clear( ::pWidget )
      METHOD Remove( aIter ) INLINE gtk_list_store_remove( ::pWidget, aIter ) 
      METHOD Create() 

ENDCLASS

METHOD New( aTypes ) CLASS gListStore

      aTypes = CheckArray( aTypes )

      ::aTypes := aTypes
      ::pWidget  := gtk_list_store_newv( Len( ::aTypes ) ,::aTypes  )

RETURN Self

METHOD NewAuto( aItems ) CLASS gListStore

      ::aTypes := aItems
      ::pWidget  := hb_gtk_list_store_new( aItems )

RETURN Self

METHOD Create( pModel )  CLASS gListStore
      ::pWidget := pModel
RETURN  Self


/*El iter tenemos que devolverlo, opcional, si despues queremos emplearlo con el
 comando SET */
METHOD Append( aValues ) CLASS gListStore
       Local aIter := GtkTreeIter
       Local nLen , n

       gtk_list_store_append( ::pWidget, aIter )
       if aValues != NIL
          nLen := Len( aValues )
          for n := 1 to nLen
              gtk_list_store_set( ::pWidget, n-1, aIter, aValues[ n ] )
          next
       endif

RETURN aIter

METHOD Set( aIter, nCol, uValue ) CLASS gListStore

       gtk_list_store_set( ::pWidget, nCol-1, aIter, uValue )

RETURN NIL

METHOD SetValues( aIter, aValues ) CLASS gListStore

   local nCols
   local n

   aValues = CheckArray( aValues )
   nCols   = Min( gtk_tree_model_get_n_columns( ::pWidget ), Len( aValues ) )
   
   for n = 1 to nCols
      ::Set( aIter, n, aValues[ n ] )
   next

RETURN NIL

/*El iter tenemos que devolverlo, opcional, si despues queremos emplearlo con el
 comando SET */
METHOD Insert( nRow, aValues ) CLASS gListStore
       Local aIter := GtkTreeIter
       Local nLen , n
       
       gtk_list_store_insert( ::pWidget, aIter, nRow - 1)
       
       if aValues != NIL
          nLen := Len( aValues )
          for n := 1 to nLen
              gtk_list_store_set( ::pWidget, n-1, aIter, aValues[ n ] )
          next
       endif

RETURN aIter
