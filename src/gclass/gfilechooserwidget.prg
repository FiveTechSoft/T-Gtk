/* $Id: gfilechooserwidget.prg,v 1.1 2015-10-05 18:13:31 riztan Exp $*/
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
    (c)2003 Rafael Carmona   <thefull@wanadoo.es>
    (c)2015 Riztan Gutierrez <riztan@gmail.com>
*/
#include "gtkapi.ch"
#include "hbclass.ch"


CLASS GFILECHOOSERWIDGET FROM GBOXVH

      METHOD New( )
      METHOD SetAction( nAction ) INLINE gtk_file_chooser_set_action( ::pWidget, nAction)
      METHOD SetFolder( cFolder ) INLINE gtk_file_chooser_set_current_folder( ::pWidget, cFolder )
      METHOD GetFolder( )         INLINE gtk_file_chooser_get_current_folder( ::pWidget )
      METHOD SetFileName( cFile ) INLINE gtk_file_chooser_set_filename( ::pWidget, cFile )
      METHOD GetFileName( )       INLINE gtk_file_chooser_get_filename( ::pWidget )
      METHOD SetFilter( aFilter )

      METHOD SetMultiple( lMultiple )  INLINE gtk_file_chooser_set_select_multiple( ::pWidget, lMultiple )
      METHOD GetMultiple()             INLINE gtk_file_chooser_get_select_multiple( ::pWidget )


ENDCLASS
 
METHOD New( nMode, lhomogeneous, nSpacing, oParent, lExpand, lFill, nPadding, lContainer, x, y,uLabelTab,;
           lSecond, lResize, lShrink, left_ta, right_ta, top_ta, bottom_ta, xOptions_ta, yOptions_ta,;
           cId, uGlade, nBorder  ) CLASS GFILECHOOSERWIDGET

       DEFAULT nMode := GTK_FILE_CHOOSER_ACTION_OPEN,  ;
               nSpacing := 0, ;
               lHomogeneous := .F.

       IF cId == NIL
          ::pWidget := gtk_file_chooser_widget_new( nMode  )
       ELSE
          ::pWidget := glade_xml_get_widget( uGlade, cId )
          ::CheckGlade( cId )
       ENDIF
       
       ::Register()

       ::AddChild( oParent, lExpand, lFill, nPadding, lContainer, x, y,;
                   uLabelTab,, lSecond, lResize, lShrink,;
                   left_ta,right_ta,top_ta,bottom_ta, xOptions_ta, yOptions_ta  )

       IF ValType( nBorder ) = "N"
          gtk_container_set_border_width( ::pWidget, nBorder )
       ENDIF

//       ::Show()

RETURN Self

METHOD SetFilter( cFilter ) CLASS GFILECHOOSERWIDGET

   local aFilter
   local pFilter
   
   aFilter = HB_ATokens( cFilter, "|" )

   if Len( aFilter ) > 0
      pFilter = gtk_file_filter_new()
      for each cFilter in aFilter
         gtk_file_filter_add_pattern( pFilter, AllTrim( cFilter ) )
      next
      gtk_file_chooser_add_filter( ::pWidget, pFilter )
   endif

return nil
