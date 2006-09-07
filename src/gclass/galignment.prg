/* $Id: galignment.prg,v 1.1 2006-09-07 17:07:55 xthefull Exp $*/
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
/* $Id: galignment.prg,v 1.1 2006-09-07 17:07:55 xthefull Exp $*/
#include "gtkapi.ch"
#include "hbclass.ch"

CLASS GALIGNMENT FROM GBIN

      METHOD New()

ENDCLASS

METHOD New(  xalign, yalign, xscale, yscale , oParent, lExpand,;
            lFill, nPadding , lContainer, x, y, cId, uGlade,;
            uLabelTab, nWidth, nHeight, lEnd, lSecond, lResize, lShrink,;
            left_ta,right_ta,top_ta,bottom_ta, xOptions_ta, yOptions_ta ) CLASS GALIGNMENT

       DEFAULT xalign := 0.5,;
               yalign := 0.5,;
               xscale := 1,;
               yscale := 1

       IF cId == NIL
         ::pWidget := gtk_alignment_new(  xalign, yalign, xscale, yscale )
       ELSE
          ::pWidget := glade_xml_get_widget( uGlade, cId )
          ::CheckGlade( cId )
       ENDIF
       
       ::Register()

       ::AddChild( oParent, lExpand, lFill, nPadding, lContainer, x, y,;
                   uLabelTab, lEnd, lSecond, lResize, lShrink,;
                   left_ta,right_ta,top_ta,bottom_ta, xOptions_ta, yOptions_ta  )

       if nWidth != NIL
          ::Size( nWidth, nHeight )
       endif

       ::Show()

RETURN Self
