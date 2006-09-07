/* $Id: gboxvh.prg,v 1.1 2006-09-07 17:07:55 xthefull Exp $*/
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

CLASS GBOXVH FROM GBOX

      METHOD New(  )

ENDCLASS

METHOD New( lhomogeneous, nSpacing, lMode, oParent, lExpand, lFill, nPadding, lContainer, x, y,uLabelTab,;
           lSecond, lResize, lShrink, left_ta, right_ta, top_ta, bottom_ta, xOptions_ta, yOptions_ta,;
           cId, uGlade ) CLASS GBOXVH

       DEFAULT lMode := .F.,;
               nSpacing := 0,;
               lHomogeneous := .F.

       IF cId == NIL
          IF lMode 
             ::pWidget := gtk_vbox_new ( lhomogeneous, nSpacing )
          ELSE
             ::pWidget := gtk_hbox_new ( lhomogeneous, nSpacing )
          ENDIF
       ELSE
          ::pWidget := glade_xml_get_widget( uGlade, cId )
          ::CheckGlade( cId )
       ENDIF
        
       ::Register()

       IF oParent != NIL
          if oParent:ClassName() = "GWINDOW" .OR. oParent:ClassName() = "GDIALOG" // Si es una window, debe de usar CONTAINER
             lContainer := .T.
          endif
          ::AddChild( oParent, lExpand, lFill, nPadding, lContainer, x, y,;
                      uLabelTab,, lSecond, lResize, lShrink,;
                      left_ta, right_ta, top_ta, bottom_ta , xOptions_ta, yOptions_ta )
       ENDIF

      ::Show()

RETURN Self


