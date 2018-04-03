/* $Id: gnotebook.prg,v 1.1 2006-09-07 17:02:45 xthefull Exp $*/
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

CLASS GNOTEBOOK FROM GCONTAINER
      DATA nPageCurrent INIT 0
      DATA aFold        INIT {}

      METHOD New()
      METHOD Next() INLINE gtk_notebook_next_page( ::pWidget )
      METHOD Prev() INLINE gtk_notebook_prev_page( ::pWidget )
      METHOD SetPosition( nPosition ) INLINE gtk_notebook_set_tab_pos( ::pWidget, nPosition )
      METHOD GetPosition( )           INLINE gtk_notebook_get_tab_pos( ::pWidget )
      METHOD ShowTabs( lShow )   INLINE gtk_notebook_set_show_tabs( ::pWidget , lShow )
      METHOD ShowBorder( lShow ) INLINE gtk_notebook_set_show_border( ::pWidget , lShow )
      METHOD RemovePage( nPage )
      METHOD SetCurrentPage( nPage ) INLINE ( gtk_notebook_set_current_page( ::pWidget, nPage -1 ), ::GetCurrentPage() )
      METHOD SetScroll( lScroll )    INLINE gtk_notebook_set_scrollable( ::pWidget, lScroll )
      METHOD SetPopup( lPopup )
      METHOD GetCurrentPage() INLINE ::nPageCurrent := gtk_notebook_get_current_page( ::pWidget ) + 1
      METHOD Append( oContainer, oLabelTab ) INLINE AADD( ::aFold, STR(Seconds())), gtk_notebook_append_page( ::pWidget, oContainer:pWidget, oLabelTab:pWidget )
      METHOD OnSwitch_page( oSender, pPage, nPage )

      METHOD nId()            
      METHOD SetId(xId)       
      METHOD LastId()         INLINE ::SetCurrentPage( Len(::aFold) )

ENDCLASS

METHOD New( nPosition,  bChange , oParent, lExpand, lFill, nPadding, lContainer, x, y,  cId, uGlade ,;
            nWidth, nHeight, lEnd, lSecond, lResize, lShrink,;
            left_ta, right_ta, top_ta, bottom_ta, xOptions_ta, yOptions_ta) CLASS GNOTEBOOK

       IF cId == NIL
         ::pWidget = gtk_notebook_new ()
       ELSE
          ::pWidget := glade_xml_get_widget( uGlade, cId )
          ::CheckGlade( cId )
       ENDIF

       ::Register()

       ::AddChild( oParent, lExpand, lFill, nPadding, lContainer, x, y, NIL ,;
                   lEnd, lSecond, lResize, lShrink, left_ta, right_ta, top_ta, bottom_ta,;
                   xOptions_ta, yOptions_ta )

       if nPosition != NIL
         ::SetPosition( nPosition )
       endif

       if nWidth != NIL
          ::Size( nWidth, nHeight )
       endif

       ::bChange := bChange

       if !Empty( bChange )
          ::Connect( "switch-page" )
       endif

       ::Show()

RETURN Self

METHOD RemovePage( nPage ) CLASS GNOTEBOOK
       DEFAULT nPage := gtk_notebook_get_current_page( ::pWidget ) + 1
       ADEL(::aFold, nPage)
       ASIZE(::aFold, Len(::aFold)-1)
       gtk_notebook_remove_page( ::pWidget, nPage - 1 )
       /* Con la siguiente funcin se vuelve a dibujar el notebook
         * para que no se vea la p�ina que ha sido borrada. */
       gtk_widget_queue_draw( ::pWidget )
RETURN NIL

METHOD SetPopup( lPopup ) CLASS GNOTEBOOK

   if lPopup
      gtk_notebook_popup_enable( ::pWidget )
   else
      gtk_notebook_popup_disable( ::pWidget )
   endif

RETURN NIL

// Nota:
// Se actualiza nPageCurrent, por si casualidad se produce una llamada desde
// el bChange a GetCurrentPage(), y como todavia estamos en la actual,
// se actualiza a una pagina 'incorrecta'.
// La solucion es bien sencilla, actualizamos primero y despues del Eval y punto.
METHOD OnSwitch_page( oSender, pPage, nPage ) CLASS GNOTEBOOK

    oSender:GetCurrentPage()
    /* De esta manera, evitamos que se evalua al crearse > 0 */
    if oSender:nPageCurrent > 0
       oSender:nPageCurrent := nPage + 1
       if !Empty( oSender:bChange )
           Eval( oSender:bChange , oSender )
           oSender:nPageCurrent := nPage + 1
       endif
    endif

RETURN NIL



METHOD nId()       CLASS GNOTEBOOK
   Local x := Len( ::aFold )
   ::SetId( x )
RETURN ::aFold[x]



METHOD SetId(xId)  CLASS GNOTEBOOK
  Local nPos 

  if xId=NIL ; return .f. ; endif

  nPos := aScan( ::aFold, xId )

  if nPos >=0
    ::SetCurrentPage( nPos )
    return .t.
  endif

RETURN .f.

