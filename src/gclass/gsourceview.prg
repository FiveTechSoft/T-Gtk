/* $Id: gsourceview.prg,v 1.2 2008-12-25 19:23:52 xthefull Exp $*/
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
    (c)2008 Riztan Gutierrez <riztan at gmail.com>

*/
#include "gtkapi.ch"
#include "hbclass.ch"

CLASS GSOURCEVIEW FROM GTEXTVIEW
      DATA bSetGet
      DATA oBuffer
      DATA cMime           INIT "text/x-prg"
      DATA lNoShowLines    INIT .F.

      METHOD New(cMime, lNoShowLines, bSetGet, lReadOnly, oParent, lExpand, lFill, nPadding ,;
            lContainer, x, y, cId, uGlade,;
            uLabelTab, nWidth, nHeight, lEnd, lSecond, lResize, lShrink,;
            left_ta, right_ta, top_ta, bottom_ta, xOptions_ta, yOptions_ta )

ENDCLASS

METHOD New( cMime, lNoShowLines, bSetGet, lReadOnly, oParent, lExpand, lFill, nPadding ,;
            lContainer, x, y, cId, uGlade,;
            uLabelTab, nWidth, nHeight, lEnd, lSecond, lResize, lShrink,;
            left_ta, right_ta, top_ta, bottom_ta, xOptions_ta, yOptions_ta ) CLASS GSOURCEVIEW

       Local cText := ""

       Default cMime := "text/x-prg"

       ::bSetGet := bSetGet
       cText :=  Eval( ::bSetGet )

       IF cId == NIL
          ::pWidget := HB_GTK_SOURCE_CREATE_NEW( cMime )
       ELSE
          ::pWidget := glade_xml_get_widget( uGlade, cId )
          ::CheckGlade( cId )
       ENDIF

       IF !lNoShowLines
          gtk_source_view_set_show_line_numbers( ::pWidget, !lNoShowLines )
       ENDIF

       ::Register()
       ::oBuffer := gTextBuffer():New( ::pWidget )

       if ::bSetGet != NIL
          ::SetText( cText )
       endif
       
       if lReadOnly// READONLY
          ::SetEditable( .F. )
       endif   

       ::AddChild( oParent, lExpand, lFill, nPadding, lContainer, x, y, uLabelTab,;
                   lEnd, lSecond, lResize, lShrink , left_ta, right_ta, top_ta, bottom_ta,;
                   xOptions_ta, yOptions_ta )

       ::Connect( "focus-out-event")
       
       ::Show()

RETURN Self


