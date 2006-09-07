/* $Id: gtooltip.prg,v 1.1 2006-09-07 17:02:46 xthefull Exp $*/
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

CLASS GTOOLTIP FROM GOBJECT

      METHOD NEW( cText, oWidget )
      METHOD Enable()  INLINE gtk_tooltips_enable( ::pWidget )
      METHOD Disable() INLINE gtk_tooltips_disable( ::pWidget )
      METHOD SetTip( oWidget, cText ) INLINE Gtk_tooltips_set_tip( ::pWidget, oWidget:pWidget, cText )

ENDCLASS

METHOD NEW( cText, oWidget ) CLASS GTOOLTIP
  
    ::pWidget:= Gtk_ToolTips_New()
      
    if oWidget != NIL
       ::SetTip( oWidget, cText )
    endif

RETURN Self

