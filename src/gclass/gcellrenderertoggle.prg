/* $Id: gcellrenderertoggle.prg,v 1.2 2007-02-28 21:38:21 xthefull Exp $*/
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

CLASS gCellRendererToggle FROM gCellRenderer

      METHOD New()
      METHOD OnCell_Toggled( oSender, cPath )
      
ENDCLASS

METHOD New() CLASS gCellRendererToggle
       ::pWidget = gtk_cell_renderer_toggle_new()
       ::cType := "active"
       ::Connect( "destroy" ) 
       ::Connect( "toggled" ) 
RETURN Self

METHOD OnCell_Toggled( oSender, cPath ) CLASS gCellRendererToggle

    local aIter := Array( 4 )
    
    if oSender:bAction != NIL
       Eval( oSender:bAction, oSender, cPath  )
    endif

RETURN .F.
