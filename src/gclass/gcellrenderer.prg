/* $Id: gcellrenderer.prg,v 1.3 2009-02-26 22:50:19 riztan Exp $*/
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
      DATA nColumn  
      METHOD New()
      METHOD SetAlign_H( nAlign ) INLINE g_object_set( ::pWidget, "xalign", nAlign  )
      METHOD SetAlign_V( nAlign ) INLINE g_object_set( ::pWidget, "yalign", nAlign  )
      METHOD SetPadX( nAlign )    INLINE g_object_set( ::pWidget, "xpad", nAlign  )
      METHOD SetPadY( nAlign )    INLINE g_object_set( ::pWidget, "ypad", nAlign  )

      METHOD OnDestroy()
ENDCLASS

METHOD New() CLASS gCellRenderer
RETURN Self

METHOD OnDestroy( oSender ) CLASS gCellRenderer

    if oSender:bDestroy != NIL
       Eval( oSender:bDestroy, oSender )
    endif

RETURN NIL
