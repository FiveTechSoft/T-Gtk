/* $Id: gframe.prg,v 1.1 2006-09-07 17:02:44 xthefull Exp $*/
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

CLASS GFRAME FROM GBIN

      METHOD New(  )
      METHOD SetText( cText ) INLINE gtk_frame_set_label( ::pWidget, cText )
      METHOD SetLabel( oLabel ) INLINE  gtk_frame_set_label_widget( ::pWidget , oLabel:pWidget )
      METHOD GetLabel() INLINE gtk_frame_get_label( ::pWidget )
      METHOD SetShadow( nShadowType ) INLINE  gtk_frame_set_shadow_type( ::pWidget, nShadowType )
      METHOD SetLabelAlign( x, y ) INLINE  gtk_frame_set_label_align( ::pWidget , x, y )

ENDCLASS

METHOD New( cText, nShadow, nHor, nVer, oParent, lExpand, lFill, nPadding, lContainer, x, y,;
            cId, uGlade, uLabelTab, nWidth, nHeight, lSecond, lResize, lShrink,;
            left_ta,right_ta,top_ta,bottom_ta, xOptions_ta, yOptions_ta  ) CLASS GFRAME
          DEFAULT cText := ""

          IF cId == NIL
             if Valtype( cText ) = "C" // Si es un texto
                ::pWidget = gtk_frame_new( cText )
             elseif Valtype( cText ) = "O" /* Es un objeto label */
                ::pWidget = gtk_frame_new()
                ::SetLabel( cText )
             endif
          ELSE
             ::pWidget := glade_xml_get_widget( uGlade, cId )
             ::CheckGlade( cId )
          ENDIF

          ::Register()

          if !Empty( cText ) .AND. cId != NIL
             if Valtype( cText ) = "C" // Si es un texto
                ::pWidget = gtk_frame_new( cText )
             elseif Valtype( cText ) = "O" /* Es un objeto label */
                ::pWidget = gtk_frame_new()
                ::SetLabel( cText )
             endif
          endif

          ::AddChild( oParent, lExpand, lFill, nPadding, lContainer, x, y,;
                      uLabelTab, , lSecond, lResize, lShrink, left_ta,right_ta,top_ta,bottom_ta,;
                      xOptions_ta, yOptions_ta  )

          if nShadow != 0
            ::SetShadow( nShadow )
          endif

          if nWidth != NIL
             ::Size( nWidth, nHeight )
          endif

          IF nHor != NIL /* Definimos alinacion del texto.*/
             ::SetLabelAlign( nHor, nVer )
          ENDIF

          ::Show()

RETURN Self

