/* $Id: $*/
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
    (c)2011 Rafael Carmona <rafa.thefull@gmail.com>
*/
#include "gtkapi.ch"
#include "hbclass.ch"

CLASS GSPINNER FROM GDRAWINGAREA

      METHOD New(  )
      METHOD Start() INLINE gtk_spinner_start ( ::pWidget )
      METHOD Stop()  INLINE gtk_spinner_stop ( ::pWidget)

ENDCLASS

METHOD New( lStart, oParent, lExpand, lFill, nPadding, lContainer, x, y,  cId, uGlade ,;
            nWidth, nHeight, lEnd, lSecond, lResize, lShrink,;
            left_ta, right_ta, top_ta, bottom_ta, xOptions_ta, yOptions_ta ) CLASS GSPINNER

          DEFAULT lStart := .F.

          IF cId == NIL
             ::pWidget = gtk_spinner_new(  )
          ELSE
             ::pWidget := glade_xml_get_widget( uGlade, cId )
             ::CheckGlade( cId )
          ENDIF

          ::Register()

          ::AddChild( oParent, lExpand, lFill, nPadding, lContainer, x, y , , , lSecond,;
                      lResize, lShrink, left_ta, right_ta, top_ta, bottom_ta, xOptions_ta, yOptions_ta )

          if nWidth != NIL
             ::Size( nWidth, nHeight )
          endif

          if lStart
             ::Start()
          endif

          ::Show()

RETURN Self

