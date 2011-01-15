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

      METHOD OnDestroy()
      METHOD OnEditing_started( oSender, pEditable, cPath )
      METHOD OnEditing_canceled( oSender )
      METHOD SetColumn( oColumn ) INLINE ::oColumn := oColumn, ::nColumn := oColumn:nColumn
      
      
ENDCLASS

METHOD New() CLASS gCellRenderer
RETURN Self

METHOD OnDestroy( oSender ) CLASS gCellRenderer

    if oSender:bDestroy != NIL
       Eval( oSender:bDestroy, oSender )
    endif

RETURN NIL

METHOD OnEditing_started( oSender, pEditable, cPath ) CLASS gCellRenderer

    if oSender:bOnEditing_Started != NIL
       Eval( oSender:bOnEditing_Started, oSender, pEditable, cPath )
    endif

RETURN NIL

METHOD OnEditing_Canceled( oSender ) CLASS gCellRenderer

    if oSender:bOnEditing_Canceled != NIL
       Eval( oSender:bOnEditing_Canceled, oSender )
    endif

RETURN NIL

