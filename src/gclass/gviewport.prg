/* $Id: gviewport.prg,v 1.1 2006-09-07 16:28:06 xthefull Exp $*/
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

CLASS GVIEWPORT FROM GBIN

      METHOD New( )
      METHOD SetShadow( nType ) INLINE gtk_viewport_set_shadow_type( ::pWidget, nType )

ENDCLASS

METHOD New( oAdjH, oAdjV, oParent, lExpand,lFill, nPadding,;
            lContainer,x,y,cId,uGlade, uLabelTab, nWidth,nHeight, lEnd, lSecond, lResize, lShrink,;
            left_ta, right_ta, top_ta, bottom_ta, xOptions_ta, yOptions_ta, nShadow ) CLASS GVIEWPORT
       Local pAdjustV, pAdjustH

       IF cId == NIL
          if !Empty( oAdjH )
             pAdjustH := oAdjH:pWidget
          endif
          if !Empty( oAdjV )
             pAdjustV := oAdjV:pWidget
          endif
          ::pWidget = gtk_viewport_new( pAdjustH, pAdjustV )
       ELSE
          ::pWidget := glade_xml_get_widget( uGlade, cId )
          ::CheckGlade( cId )
       ENDIF

       ::Register()

       ::AddChild( oParent, lExpand, lFill, nPadding, lContainer, x, y, uLabelTab,;
                   lEnd, lSecond, lResize, lShrink, left_ta, right_ta, top_ta, bottom_ta,;
                   xOptions_ta, yOptions_ta )

       if nShadow != NIL
          ::SetShadow( nShadow )
       endif

       if nWidth != NIL
          ::Size( nWidth, nHeight )
       endif

       ::Show()

RETURN Self
