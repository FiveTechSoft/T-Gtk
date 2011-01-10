/* $Id: gimage.prg,v 1.3 2010-12-23 13:21:00 dgarciagil Exp $*/
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

CLASS GIMAGE FROM GMISC
      METHOD New( )
      METHOD SetFile( cFileImage ) INLINE gtk_image_set_from_file( ::pWidget, cFileImage )
      METHOD SetFromPixbuf( pPixbuf ) INLINE gtk_image_set_from_pixbuf( ::pWidget, pPixbuf )
      METHOD GetPixBuf( ) INLINE gtk_image_get_pixbuf( ::pWidget )
      METHOD GetPixMap( ) INLINE gtk_image_get_pixmap( ::pWidget )
      #if GTK_CHECK_VERSION( 2,10,0 )
      METHOD Clear( )     INLINE gtk_image_clear( ::pWidget )
      #else
      METHOD Clear( )     VIRTUAL
      #endif
      
ENDCLASS

METHOD New( cImage , oParent, lExpand, lFill, nPadding , lContainer, x, y, cId, uGlade ,;
            uLabelTab, nWidth, nHeight, lEnd, lSecond, lResize, lShrink,;
            left_ta, right_ta, top_ta, bottom_ta, xOptions_ta, yOptions_ta, nHor, nVer,;
            cFromStock, nIcon_Size, lLoad ) CLASS GIMAGE
       
       DEFAULT nIcon_Size := GTK_ICON_SIZE_INVALID, lLoad := .F., nHor := 0 , nVer := 0

       IF cId == NIL
          IF cFromStock != NIL
             ::pWidget := gtk_image_new_from_stock( cFromStock, nIcon_Size )
          ELSE
            ::pWidget := gtk_image_new()
          ENDIF
       ELSE
          ::pWidget := glade_xml_get_widget( uGlade, cId )
          ::CheckGlade( cId )
       ENDIF

       if cImage != NIL
         ::SetFile( cImage )
       endif
       
       If lLoad // Si simplemente queremos cargarla en memoria.
          RETURN Self
       Endif

       ::Register()
       
       if nHor != 0 .OR. nVer != 0
          ::SetAlignment( nHor, nVer )
       endif

       ::AddChild( oParent, lExpand, lFill, nPadding, lContainer, x, y ,;
                   uLabelTab  ,lEnd, lSecond, lResize, lShrink,;
                   left_ta, right_ta, top_ta, bottom_ta, xOptions_ta, yOptions_ta )

       if nWidth != NIL
          ::Size( nWidth, nHeight )
       endif

       ::Show()

RETURN Self
