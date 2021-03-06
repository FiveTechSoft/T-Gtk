/* $Id: gentrycompletion.prg,v 1.1 2006-09-07 17:02:43 xthefull Exp $*/
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

CLASS GENTRYCOMPLETION FROM GOBJECT
      DATA bSelected      
      DATA oEntry
      DATA oModel
      DATA nColumn
      
      METHOD New( oEntry, oModel, nColum )
      METHOD OnMatch_Selected ( oSender, pTreeModel, aIter )  SETGET
      
ENDCLASS

METHOD New( oEntry, oModel, nColumn ) CLASS GENTRYCOMPLETION
   LOCAL pEntry, lEntry:=.f.
   DEFAULT nColumn := 1
   
   if oEntry:IsDerivedFrom( "GCOMBOBOXENTRY" )
      ::oEntry := oEntry:oEntry
      pEntry := oEntry:oEntry:pWidget

   elseif oEntry:IsDerivedFrom( "GENTRY" )
      ::oEntry := oEntry
      pEntry := oEntry:pWidget
      lEntry := .t.
   else
      return nil
   endif

   if empty( oModel ) ; return nil ; endif

   ::pWidget := gtk_entry_completion_new()
   ::oModel  := oModel

   gtk_entry_set_completion( pEntry, ::pWidget )
   ::Connect( "match-selected" )
   ::oEntry:lCompletion := .t.
   gtk_entry_completion_set_text_column( ::pWidget, nColumn -1 )
   gtk_entry_completion_set_model( ::pWidget, oModel:pWidget )
   
   g_object_unref( ::pWidget )
   g_object_unref ( oModel:pWidget )

RETURN Self  



METHOD OnMatch_Selected ( uParam, pTreeModel, aIter )
   Local uResult := .F.
    
   if hb_IsBlock( uParam )
      ::bSelected = uParam
      ::Connect( "match-selected" )
   elseif hb_IsObject( uParam )
      if hb_IsBlock( ::bSelected )
         uResult := Eval( uParam:bSelected, Self, pTreeModel, aIter )
      endif
   endif
RETURN uResult 



