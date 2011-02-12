/* $Id: gcellrenderer.prg,v 1.4 2009-05-24 18:26:37 xthefull Exp $*/
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

CLASS gCellRenderer FROM GOBJECT
      DATA cType  // Tipo de CellRenderer
      DATA nColumn, oColumn
      DATA bOnEditing_Started
      DATA bOnEditing_Canceled

      METHOD New()
      METHOD SetAlign_H( nAlign ) INLINE g_object_set( ::pWidget, "xalign", nAlign  )
      METHOD SetAlign_V( nAlign ) INLINE g_object_set( ::pWidget, "yalign", nAlign  )
      METHOD SetPadX( nAlign )    INLINE g_object_set( ::pWidget, "xpad", nAlign  )
      METHOD SetPadY( nAlign )    INLINE g_object_set( ::pWidget, "ypad", nAlign  )

      METHOD OnDestroy() SETGET
      METHOD OnEditing_started( oSender, pEditable, cPath ) SETGET
      METHOD OnEditing_canceled( oSender ) SETGET
      METHOD SetColumn( oColumn ) INLINE ::oColumn := oColumn, ::nColumn := oColumn:nColumn
      
      
ENDCLASS

METHOD New() CLASS gCellRenderer
RETURN Self

METHOD OnDestroy( uParam ) CLASS gCellRenderer


   if hb_IsBlock( uParam )
      ::bDestroy = uParam
   elseif hb_IsObject( uParam )
      if hb_IsBlock( uParam:bDestroy )
         Eval( uParam:bDestroy, uParam )
      endif
   endif    

RETURN NIL


METHOD OnEditing_started( uParam, pEditable, cPath )  CLASS gCellRenderer

   if hb_IsBlock( uParam )
      ::bOnEditing_Started = uParam
      ::Connect( "editing-started" )
   elseif hb_IsObject( uParam )
      if hb_IsBlock( uParam:bOnEditing_Started )
         Eval( uParam:bOnEditing_Started, uParam, pEditable, cPath  )
      endif
   endif    

RETURN .F.


METHOD OnEditing_Canceled( uParam ) CLASS gCellRenderer

   if hb_IsBlock( uParam )
      ::bOnEditing_Canceled = uParam
      ::Connect( "editing-canceled" )
   elseif hb_IsObject( uParam )
      if hb_IsBlock( uParam:bOnEditing_Canceled )
         Eval( uParam:bOnEditing_Canceled, uParam  )
      endif
   endif   

RETURN NIL

