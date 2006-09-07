/* $Id: gpaned.prg,v 1.1 2006-09-07 17:02:45 xthefull Exp $*/
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

CLASS GPANED FROM GCONTAINER

      METHOD New(  )
      METHOD AddPaned( oChild, lSecond, oParent, lResize, lShrink  )
      METHOD SetPosition( nPos ) INLINE gtk_paned_set_position( ::pWidget, nPos )
      
      // Signals
      METHOD OnAcceptPosition( oSender ) INLINE .F.
      METHOD OnCancelPosition( oSender ) INLINE .F.
      METHOD OnCycleChildFocus( oSender, lArg1 )     INLINE .F.
      METHOD OnCycleHandleFocus( oSender, lArg1 )    INLINE .F.
      METHOD OnMoveHandle( oSender, nGtkScrollType ) INLINE .F.
      METHOD OnToggleHandleFocus( oSender ) INLINE .F.

ENDCLASS

METHOD New( lVertical, oParent, lExpand, lFill, nPadding, lContainer, x, y, cId, uGlade,;
            uLabelTab, nWidth, nHeight, lEnd, lSecond, lResize, lShrink,;
            left_ta, right_ta, top_ta, bottom_ta, xOptions_ta, yOptions_ta, nPos   ) CLASS GPANED

    IF cId == NIL
       IF lVertical
          ::pWidget := gtk_vpaned_new( )
       ELSE
          ::pWidget := gtk_hpaned_new( )
       ENDIF
    ELSE
       ::pWidget := glade_xml_get_widget( uGlade, cId )
       ::CheckGlade( cId )
    ENDIF

    ::Register()

    IF oParent != NIL
       if oParent:ClassName() = "GWINDOW" .OR.;
          oParent:ClassName() = "GDIALOG"  // Si es una window, debe de usar CONTAINER
          lContainer := .T.
       endif
      ::AddChild( oParent, lExpand, lFill, nPadding, lContainer, x, y, uLabelTab, lEnd,;
                  lSecond, lResize, lShrink, left_ta, right_ta, top_ta, bottom_ta ,;
                  xOptions_ta, yOptions_ta)
   ENDIF

    IF nPos != NIL
       ::SetPosition( nPos )
    ENDIF
   
   ::Show()

RETURN Self

METHOD AddPaned( oChild, lSecond, oParent, lResize, lShrink  ) CLASS GPANED

    if !lSecond
       gtk_paned_pack1( ::pWidget, oChild:pWidget, lResize, lShrink )
    else
       gtk_paned_pack2( ::pWidget, oChild:pWidget, lResize, lShrink  )
    endif

RETURN NIL
