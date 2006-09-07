/* $Id: gcombobox_clip.prg,v 1.1 2006-09-07 17:07:55 xthefull Exp $*/
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
    Protipico de Clase GComboBox_Clip by Rafa Carmona From job and 
    desenvoluped from user Rosen
    Thank you Rosen!!

    Note:
    Now is work with array's like as
    for Item array:
    {"x", "y", "z"} return selected item when is variable is a char, or
    when is variable is number return slected item in number like "x" -> 1

    {{"x", "x1"},{"y", "y1"},{"z", "z1"}} return second item in The array
    like as visable "x", but return "x1"

    This is source marked my correct with coment
*/
#include "gtkapi.ch"
#include "hbclass.ch"

#define NO_ARRAY 0
#define NUM_ARRAY 1
#define CHAR_ARRAY 2

CLASS GCOMBOBOX_CLIP FROM GCOMBOBOX
    DATA nMode

    METHOD New( )
    METHOD SetItems( aItems )
    METHOD GetText()
    METHOD SelectItem( cItem )
    METHOD GetItem( uItem )  
    METHOD SeekItem( uItem ) 

ENDCLASS

/***************************************************************************************************************************/
METHOD New( bSetGet, aItems, bChange, oModel, oFont, oParent, lExpand,lFill, nPadding, lContainer, x, y,;
            cId, uGlade, uLabelTab, nWidth, nHeight, lEnd, lSecond,lResize, lShrink,;
            left_ta,right_ta,top_ta,bottom_ta, xOptions_ta, yOptions_ta ) CLASS GCOMBOBOX_CLIP

    Super:New( bSetGet, aItems, bChange, oModel, oFont, oParent, lExpand,lFill, nPadding, lContainer, x, y,;
               cId, uGlade, uLabelTab, nWidth, nHeight, lEnd, lSecond,lResize, lShrink,;
               left_ta,right_ta,top_ta,bottom_ta, xOptions_ta, yOptions_ta )

RETURN Self

/***************************************************************************************************************************/
METHOD SetItems( aItems ) CLASS GCOMBOBOX_CLIP
    Local X
    Local uActive := 1
    Local uText
    Local nLen

    if Empty( aItems )
       Return nil
    endif

    ::aItems := aItems
    ::nMode := iif( ISARRAY( aItems[1] ), NUM_ARRAY, NO_ARRAY) // Added from Rosen
    nLen := Len( ::aItems )

    if Eval( ::bSetGet ) == nil
        Eval( ::bSetGet, aItems[ 1 ] )
    else
        uText := Eval( ::bSetGet )
    endif
    if ::nMode == NUM_ARRAY
       ::nMode := iif( ISNUMBER( uText ), ::nMode, CHAR_ARRAY )
    endif

    if !Empty( aItems ) // Note.. If you NOT ASIGN array.. CRASH!!
       for x := 1 to nLen
           gtk_combo_box_append_text ( ::pWidget, cValtoChar( ::GetItem( x, 1 ) ) ) // Corect from Rosen
       next
    endif

    if uText != NIL
       uActive := ::SeekItem( uText ) // Corect from Rosen
       if uActive = 0
          uActive := 1
       endif
    endif

    ::SetActive( uActive )

RETURN NIL

/***************************************************************************************************************************/
METHOD GetText() CLASS GCOMBOBOX_CLIP
    Local nPos, aIter
    Local uResult := ""

    if ::oRenderer = NIL // Si no se basa en un modelo de datos
        nPos := gtk_combo_box_get_active( ::pWidget )
        if nPos >= 0
           uResult := ::GetItem( nPos + 1 ) // Corect from Rosen
        endif
    else
        aIter := Array( 4 )
        if ( gtk_combo_box_get_active_iter( ::pWidget, aIter ) )
           HB_GTK_TREE_MODEL_GET_STRING( ::oModel:pWidget, aIter, 0, @uResult )
        endif
    endif

RETURN uResult

/***************************************************************************************************************************/
METHOD SelectItem( cItem ) CLASS GCOMBOBOX_CLIP
    Local uActive := 0

    uActive := ::SeekItem( cItem ) 
    if uActive > 0 // Se encontro
       ::SetActive( uActive )
    endif

RETURN NIL

/***************************************************************************************************************************/
METHOD GetItem( uItem, nItem ) CLASS GCOMBOBOX_CLIP
    uItem := iif( ISNUMBER( uItem ), uItem, ::SeekItem( uItem ) )
    nItem := iif( nItem == NIL, 2, nItem)
    
    // Switch exist in Harbour ? Please, if not exits in harbour, change
    // used DO CASE...
    switch ::nMode
        case NO_ARRAY
             Return iif(uItem > Len(::aItems), 0, ::aItems[uItem])
             break

        case NUM_ARRAY
             Return iif(uItem > Len(::aItems), 0, iif(nItem == 1, ::aItems[uItem, nItem], uItem))
            break

        case CHAR_ARRAY
             Return iif(uItem > Len(::aItems), 0, ::aItems[uItem, nItem])
             break
    end

Return 0

/***************************************************************************************************************************/
METHOD SeekItem( uItem ) CLASS GCOMBOBOX_CLIP
    Local uVar
    
    switch ::nMode

    case NO_ARRAY
            Return iif(ISNUMBER(uItem), iif(uItem > Len(::aItems), 0, uItem), AScan(::aItems, uItem))
            break

    case NUM_ARRAY
    case CHAR_ARRAY
            Return iif(ISNUMBER(uItem), iif(uItem > Len(::aItems), 0, uItem), AScan(::aItems, {|uVar| uVar[2] == uItem}))
            break
    end
Return 0

/***************************************************************************************************************************/
/*
 Please , function ISNUMER() , ISARRAY() , i not found...?
 */
/***************************************************************************************************************************/

STATIC FUNCTION ISNUMBER( uValue )
RETURN iif( Valtype( uValue ) == "N", .T., .F. ) 

STATIC FUNCTION ISARRAY( uValue )
RETURN iif( Valtype( uValue ) == "A", .T., .F. ) 
