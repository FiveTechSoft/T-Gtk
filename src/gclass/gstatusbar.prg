/* $Id: gstatusbar.prg,v 1.1 2006-09-07 17:02:45 xthefull Exp $*/
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

CLASS GSTATUSBAR FROM GBOXVH
      DATA nId

      METHOD New( )
      METHOD Push( cText ) INLINE gtk_statusbar_push( ::pWidget, ::nId, cText )
      METHOD Pop( )        INLINE gtk_statusbar_pop( ::pWidget, ::nId )
      METHOD SetText( cText )

ENDCLASS

METHOD New( cText, oParent, lExpand, lFill, nPadding , lContainer, x, y, cId, uGlade,;
            uLabelTab, nWidth, nHeight, lEnd, lSecond, lResize, lShrink,;
            left_ta, right_ta, top_ta, bottom_ta, xOptions_ta, yOptions_ta ) CLASS GSTATUSBAR
       DEFAULT cText := "Status Bar"

       IF cId == NIL
          ::pWidget := gtk_statusbar_new()
       ELSE
          ::pWidget := glade_xml_get_widget( uGlade, cId )
          ::CheckGlade( cId )
       ENDIF

       ::Register()

       ::AddChild( oParent, lExpand, lFill, nPadding, lContainer, x, y, uLabelTab,;
                   lEnd, lSecond, lResize, lShrink , left_ta, right_ta, top_ta, bottom_ta,;
                   xOptions_ta, yOptions_ta )

       ::nId = gtk_statusbar_get_context_id( ::pWidget, cText )
       ::Push( cText )
       ::Show()

RETURN Self

METHOD SetText( cText ) CLASS GSTATUSBAR
       ::Pop()
       ::Push( cText )
RETURN NIL
