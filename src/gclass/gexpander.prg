/* $Id: gexpander.prg,v 1.1 2006-09-07 17:02:44 xthefull Exp $*/
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

CLASS GEXPANDER FROM GBIN

      METHOD New( )
      METHOD SetMarkup( lUse )    INLINE gtk_expander_set_use_markup( ::pWidget, lUse )
      METHOD SetUnderline( lUse ) INLINE gtk_expander_set_use_underline( ::pWidget, lUse )
      METHOD SetExpanded( lOpen ) INLINE gtk_expander_set_expanded( ::pWidget, lOpen )
      METHOD GetExpanded()        INLINE gtk_expander_get_expanded( ::pWidget )
      METHOD SetSpacing( nSpace ) INLINE gtk_expander_set_spacing( ::pWidget, nSpace )
      METHOD GetSpacing()         INLINE gtk_expander_get_spacing( ::pWidget )
      METHOD SetLabel( cLabel )   INLINE gtk_expander_set_label( ::pWidget, cLabel )
      METHOD GetLabel(  )         INLINE gtk_expander_get_label( ::pWidget )
      METHOD GetUnderline( )      INLINE gtk_expander_get_use_underline( ::pWidget )
      METHOD GetMarkup( )         INLINE gtk_expander_get_use_markup( ::pWidget )

ENDCLASS

METHOD New( cText, bAction, lOpen, lMarkup, lMnemonic, oParent, lExpand, lFill, nPadding ,;
           lContainer, x, y , cId, uGlade, uLabelTab, nWidth, nHeight, lEnd, lSecond,;
           lResize, lShrink, left_ta, right_ta, top_ta, bottom_ta, xOptions_ta, yOptions_ta  ) CLASS GExpander

       DEFAULT cText := "Expander Widget"

       IF cId == NIL
          if lMnemonic
             ::pWidget := gtk_expander_new_with_mnemonic( cText )
          else
             ::pWidget := gtk_expander_new( cText )
          endif
       ELSE
          ::pWidget := glade_xml_get_widget( uGlade, cId )
          ::CheckGlade( cId )
       ENDIF

       ::Register()

       IF lMarkup
          ::SetMarkup( lMarkup )
       ENDIF

       IF lOpen
          ::SetExpanded( lOpen )
       ENDIF

       ::AddChild( oParent, lExpand, lFill, nPadding, lContainer, x, y, uLabelTab,;
                   lEnd , lSecond, lResize, lShrink, left_ta, right_ta, top_ta, bottom_ta,;
                   xOptions_ta, yOptions_ta  )

       if nWidth != NIL
          ::Size( nWidth, nHeight )
       endif

       IF bAction != NIL // Si desplegamos, realizamos una accion
          ::bAction := bAction
          ::Connect( "activate" )
       ENDIF

       ::Show()

RETURN Self
