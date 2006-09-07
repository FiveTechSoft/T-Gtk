/* $Id: gfixed.prg,v 1.1 2006-09-07 17:02:44 xthefull Exp $*/
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

CLASS GFIXED FROM GCONTAINER

      METHOD New( oParent, cId, uGlade )
      METHOD Put( oChild, x,y )   INLINE gtk_fixed_put( ::pWidget, oChild:pWidget, x, y )
      METHOD Move( oChild, x, y ) INLINE gtk_fixed_move( ::pWidget, oChild:pWidget, x, y )

ENDCLASS

METHOD New( oParent, cId, uGlade, lSecond, lResize, lShrink,nWidth, nHeight,;
            left_ta,right_ta,top_ta,bottom_ta, xOptions_ta, yOptions_ta ) CLASS GFIXED

       IF cId == NIL
          ::pWidget := gtk_fixed_new()
          if nWidth != NIL
             ::size( nWidth, nHeight )
          endif
       ELSE
          ::pWidget := glade_xml_get_widget( uGlade, cId )
          ::CheckGlade( cId )
       ENDIF

       ::Register()

       IF oParent != NIL
          IF oParent:ClassName() = "GPANED"  // Si es un panel, lo metemos
             oParent:AddPaned( Self, lSecond, lResize, lShrink )
          ELSEIF oParent:ClassName() = "GTABLE"
             if xOptions_ta = NIL
                oParent:AddTable( Self, left_ta,right_ta,top_ta,bottom_ta )
             else
                oParent:AddTable_Ex( Self, left_ta,right_ta,top_ta,bottom_ta, xOptions_ta, yOptions_ta )
             endif
          ELSE
             ::AddContainer( oParent )
          ENDIF
       ENDIF

       ::Show()

RETURN Self
