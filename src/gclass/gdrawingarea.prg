/* $Id: gdrawingarea.prg,v 1.1 2006-09-07 17:02:43 xthefull Exp $*/
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

CLASS GDRAWINGAREA FROM GWIDGET
    DATA bRealize, bExpose , bConfigure

    METHOD New()
    METHOD OnExpose_Event( oSender, pGdkEventExpose ) 
    METHOD OnConfigure_Event( oSender, pGdkEventConfigure ) 
    METHOD OnRealize( oSender ) 

ENDCLASS

METHOD New( bExpose, bConfigure, bRealize, oParent, lExpand, lFill, nPadding,;
            lContainer, x, y,  cId, uGlade ,;
            nWidth, nHeight, lEnd, lSecond, lResize, lShrink,;
            left_ta, right_ta, top_ta, bottom_ta, xOptions_ta, yOptions_ta) CLASS GDRAWINGAREA
       
       IF cId == NIL
         ::pWidget = gtk_drawing_area_new()
       ELSE
          ::pWidget := glade_xml_get_widget( uGlade, cId )
          ::CheckGlade( cId )
       ENDIF

       ::Register()

       ::AddChild( oParent, lExpand, lFill, nPadding, lContainer, x, y, NIL ,;
                   lEnd, lSecond, lResize, lShrink, left_ta, right_ta, top_ta, bottom_ta,;
                   xOptions_ta, yOptions_ta )

       if nWidth != NIL
          ::Size( nWidth, nHeight )
       endif
       
       ::bExpose    := bExpose    
       ::bConfigure := bConfigure 
       ::bRealize   := bRealize   

       if bRealize  != NIL
          ::Connect( "realize" )
       endif

       if bExpose != NIL
          ::Connect( "expose-event" )
       endif

       if bConfigure != NIL
          ::Connect( "configure-event" )
       endif

       ::Show()

RETURN Self

METHOD OnExpose_Event( oSender, pGdkEventExpose ) CLASS GDRAWINGAREA
  
   if ::bExpose != NIL
      return Eval( ::bExpose , oSender, pGdkEventExpose )
   endif

RETURN .F.      

METHOD OnConfigure_Event( oSender, pGdkEventConfigure ) CLASS GDRAWINGAREA
  
   if ::bConfigure != NIL
      return Eval( ::bConfigure , oSender, pGdkEventConfigure )
   endif

RETURN .F.      

METHOD OnRealize( oSender ) CLASS GDRAWINGAREA
  
   if ::bRealize != NIL
      return Eval( ::bRealize , oSender )
   endif

RETURN .F.      
