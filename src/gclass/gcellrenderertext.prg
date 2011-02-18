/* $Id: gcellrenderertext.prg,v 1.2 2009-05-15 05:24:50 riztan Exp $*/
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

CLASS gCellRendererText FROM gCellRenderer
      DATA bEdited

      METHOD New()
      METHOD SetEditable( lEdit ) INLINE g_object_set( ::pWidget, "editable", .T. )
      METHOD OnEdited( oSender , cPath, cTextNew ) SETGET

ENDCLASS

METHOD New() CLASS gCellRendererText

    ::pWidget := gtk_cell_renderer_text_new()
    ::cType   := "text"
    ::Connect( "edited" )
    
RETURN Self

METHOD OnEdited( oSender , cPath, cTextNew ) CLASS gCellRendererText
    
   local aIter := Array( 4 )
   local uParam := oSender

   if hb_IsBlock( uParam )
      ::bEdited = uParam
   elseif hb_IsObject( uParam )
      if hb_IsBlock( uParam:bEdited )
         if oSender:oColumn:oTreeView:IsKindOf( "GTREEVIEW" )
            oSender:oColumn:oTreeView:IsGetSelected( aIter )
         endif
         Eval( oSender:bEdited, oSender, cPath, cTextNew, aIter )
       endif
   endif

RETURN NIL
