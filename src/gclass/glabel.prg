/* $Id: glabel.prg,v 1.3 2010-12-24 22:43:15 dgarciagil Exp $*/
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

CLASS GLabel FROM GMISC

      METHOD New( cText, lMarkup, oParent )
      METHOD SetMarkup( cText ) INLINE gtk_label_set_markup ( ::pWidget, cText )
      METHOD SetText( cText )   INLINE gtk_label_set_text( ::pWidget, cText )
      METHOD GetText()          INLINE gtk_label_get_text( ::pWidget )
      METHOD SetWrap( lMode)    INLINE gtk_label_set_line_wrap( ::pWidget, lMode )
      METHOD SetJustify( nJustify ) INLINE gtk_label_set_justify( ::pWidget, nJustify )
      METHOD ActivateCursor()   VIRTUAL
      
      METHOD SetValue( uValue ) INLINE ::SetText( uValue )
      METHOD GetValue( )        INLINE ::GetText()

ENDCLASS                                

// Dado de que existe varias maneras de empotrar un widget en su contenedor,
// a traves de gtk_container_add( oParent:pWidget, ::pWidget )  o a traves de
// Gtk_box_pack_start( oParent:pWidget, ::pWidget, lExpand, lFill, nPadding )
// lo ideal seria que cada Preprocesado de Widget incluyera la clausula
// CONTAINER para hacer uso de _add_, o en si no hacer uso de _box_pack_start
METHOD New( cText, lMarkup, oParent, oFont, lExpand, lFill, nPadding ,;
           lContainer, x, y , cId, uGlade, uLabelTab, lEnd, lSecond, lResize, lShrink,;
           left_ta,right_ta,top_ta,bottom_ta, xOptions_ta, yOptions_ta,;
           nHor , nVer, nJustify, lMnemonic ) CLASS GLabel

       DEFAULT nHor := 0 , nVer := 0, lMnemonic := .F.

       IF cId == NIL
          if ! lMnemonic
             ::pWidget := gtk_label_new( cText )
          else 
             ::pWidget := gtk_label_new_with_mnemonic( cText )
          endif
       ELSE
          ::pWidget := glade_xml_get_widget( uGlade, cId )
          ::CheckGlade( cId )
       ENDIF

       ::Register()

       if !Empty( cText ) .AND. !lMarkup .AND. cId != NIL
          if lMnemonic
             gtk_label_set_text_with_mnemonic( ::pWidget, cText )
          else 
             ::SetText( cText )
          endif
       endif
       
       if nJustify != NIL
         ::SetJustify( nJustify )
       endif

       if ( nHor != 0 .OR. nVer != 0 ) 
          ::SetAlignment( nHor, nVer )
       endif

       IF lMarkup
          ::SetMarkup( cText )
       ENDIF

       ::AddChild( oParent, lExpand, lFill, nPadding, lContainer, x, y, uLabelTab,;
                   lEnd , lSecond, lResize, lShrink, left_ta, right_ta, top_ta, bottom_ta ,;
                   xOptions_ta, yOptions_ta )

       IF oFont != NIL
          ::SetFont( oFont )
       ENDIF

       ::Show()

RETURN Self
