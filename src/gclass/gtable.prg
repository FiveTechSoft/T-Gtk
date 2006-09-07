/* $Id: gtable.prg,v 1.1 2006-09-07 17:02:45 xthefull Exp $*/
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

CLASS GTABLE FROM GCONTAINER

      METHOD New( nRows, nColumns, lhomogeneous, oParent, cId, uGlade, lSecond, lResize, lShrink)
      METHOD AddTable( oChild, left_ta, right_ta, top_ta, bottom_ta )
      METHOD AddTable_Ex( oChild, left_ta,right_ta,top_ta,bottom_ta, xOptions, yOptions, xPadding, yPadding )

      METHOD SetRow( nRow, nSpacing ) INLINE gtk_table_set_row_spacing( ::pWidget, nRow, nSpacing )
      METHOD SetCol( nCol, nSpacing ) INLINE gtk_table_set_col_spacing( ::pWidget, nCol, nSpacing )
      METHOD SetRows( nSpacing ) INLINE  gtk_table_set_row_spacings( ::pWidget, nSpacing )
      METHOD SetCols( nSpacing ) INLINE  gtk_table_set_col_spacings( ::pWidget, nSpacing )

      METHOD Resize( nRows, nColumns ) INLINE gtk_table_resize( ::pWidget, nRows, nColumns )

      METHOD GetRow( nRow ) INLINE gtk_table_get_row_spacing( ::pWidget, nRow )
      METHOD GetCol( nCol ) INLINE gtk_table_get_col_spacing( ::pWidget, nCol )
      METHOD GetRows( ) INLINE gtk_table_get_default_row_spacing( ::pWidget )
      METHOD GetCols( ) INLINE gtk_table_get_default_col_spacing( ::pWidget )

      METHOD SetHomo( lHomo) INLINE gtk_table_set_homogeneous( ::pWidget, lHomo )
      METHOD GetHomo( )      INLINE gtk_table_get_homogeneous( ::pWidget )

ENDCLASS

METHOD New( nRows, nColumns, lhomogeneous,oParent, cId, uGlade, lSecond, lResize, lShrink,;
            left_ta,right_ta,top_ta,bottom_ta, xOptions_ta, yOptions_ta ) CLASS GTABLE
       DEFAULT nRows := 1,;
               nColumns := 1

       IF cId == NIL
          ::pWidget := gtk_table_new( nRows, nColumns,  lhomogeneous )
       ELSE
          ::pWidget := glade_xml_get_widget( uGlade, cId )
          ::CheckGlade( cId )
       ENDIF

       ::Register()

       IF oParent != NIL
          IF oParent:ClassName() = "GPANED"  // Si es un panel, lo metemos
             oParent:AddPaned( Self, lSecond, lResize, lShrink )
          ELSEIF oParent:ClassName() = "GTABLE"
             if xOptions_ta = NIL
                oParent:AddTable( Self, left_ta,right_ta,top_ta,bottom_ta )
             else
                oParent:AddTable_Ex( Self, left_ta,right_ta,top_ta,bottom_ta, xOptions_ta, yOptions_ta )
             endif
          ELSE
             ::AddContainer( oParent )
          ENDIF
       ENDIF

       ::Show()

RETURN Self

METHOD AddTable( oChild, left_ta,right_ta,top_ta,bottom_ta )  CLASS GTABLE
       DEFAULT left_ta := 0,;
               right_ta := 1,;
               top_ta := 0,;
               bottom_ta := 1

       gtk_table_attach_defaults( ::pWidget, oChild:pWidget ,;
                              left_ta, right_ta, top_ta, bottom_ta )

RETURN NIL

METHOD AddTable_Ex( oChild, left_ta,right_ta,top_ta,bottom_ta, xOptions, yOptions, xPadding, yPadding )  CLASS GTABLE
       DEFAULT left_ta := 0,;
               right_ta := 1,;
               top_ta := 0,;
               bottom_ta := 1,;
               xPadding := 0 , yPadding := 0,;
               xOptions := nOr( GTK_EXPAND, GTK_FILL ),;
               yOptions := nOr( GTK_EXPAND, GTK_FILL )


        gtk_table_attach( ::pWidget, oChild:pWidget ,;
                         left_ta, right_ta, top_ta, bottom_ta ,;
                         xOptions, yOptions, xPadding, yPadding )

RETURN NIL
