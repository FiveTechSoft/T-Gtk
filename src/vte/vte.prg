/* $Id: vte.prg,v 1.2 2006-09-22 19:43:52 xthefull Exp $*/
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
   
    Terminal for T-Gtk
   (C) 2006. Rafa Carmona -TheFull-
*/
#include "hbclass.ch"

CLASS GTERMINAL FROM GWIDGET
    METHOD New()
    METHOD Console() INLINE HB_VTE_CONSOLE_USER( ::pWidget )
    METHOD Transparent( lMode ) INLINE vte_terminal_set_background_transparent( ::pWidget, lMode )
    METHOD Command( cCommand ) INLINE HB_VTE_COMMAND( ::pWidget, cCommand )
    METHOD SetSize( Cols, Rows )
    METHOD SetFont( oFont ) INLINE vte_terminal_set_font( ::pWidget, oFont:pFont )
    
ENDCLASS

METHOD New( cCommand, oFont, oParent, lExpand, lFill, nPadding, lContainer, x, y,;
              uLabelTab, lEnd, lSecond, lResize, lShrink,;
              left_ta,right_ta,top_ta,bottom_ta, xOptions_ta, yOptions_ta ) CLASS GTERMINAL
   
  ::pWidget := vte_terminal_new()
  
  ::AddChild( oParent, lExpand, lFill, nPadding, lContainer, x, y,;
              uLabelTab, lEnd, lSecond, lResize, lShrink,;
              left_ta,right_ta,top_ta,bottom_ta, xOptions_ta, yOptions_ta  )

  ::Show()
  
  if cCommand != NIL 
     ::Command( cCommand )
  endif
  
  if oFont != NIL
    ::SetFont( oFont )
  endif
    
RETURN Self

METHOD SetSize( cols, rows ) CLASS GTERMINAL
   vte_terminal_set_size( ::pWidget, cols, rows )
RETURN NIL
        
