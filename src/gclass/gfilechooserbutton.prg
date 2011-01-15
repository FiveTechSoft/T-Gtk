/* $Id: gfilechooserbutton.prg,v 1.1 2006-09-07 17:02:44 xthefull Exp $*/
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

CLASS GFILECHOOSERBUTTON FROM GBOXVH

      DATA bAction

      METHOD New( )
      METHOD SetFolder( cFolder ) INLINE gtk_file_chooser_set_current_folder( ::pWidget, cFolder )
      METHOD GetFolder( )         INLINE gtk_file_chooser_get_current_folder( ::pWidget )
      METHOD SetFileName( cFile ) INLINE gtk_file_chooser_set_filename( ::pWidget, cFile )
      METHOD GetFileName( )       INLINE gtk_file_chooser_get_filename( ::pWidget )
      METHOD SetFilter( aFilter )
      METHOD Onfile_Set()
      

ENDCLASS

METHOD New( cText, nMode , cFileName, oParent, lExpand,;
            lFill, nPadding , lContainer, x, y, cId, uGlade, nCursor,;
            uLabelTab, nWidth, nHeight, oBar, cMsgBar, lEnd, lSecond, lResize, lShrink,;
            left_ta,right_ta,top_ta,bottom_ta, xOptions_ta, yOptions_ta, cFilter, bAction ) CLASS GFILECHOOSERBUTTON

       DEFAULT nMode := 0,;
               cText := ""  // GTK_FILE_CHOOSER_ACTION_SELECT_FOLDER

       IF cId == NIL
          ::pWidget := gtk_file_chooser_button_new( cText, nMode  )
       ELSE
          /* Actualmente, este widget no es soportado por glade....*/
          ::pWidget := glade_xml_get_widget( uGlade, cId )
          ::CheckGlade( cId )
       ENDIF
       
       ::Register()

       ::AddChild( oParent, lExpand, lFill, nPadding, lContainer, x, y,;
                   uLabelTab, lEnd, lSecond, lResize, lShrink,;
                   left_ta,right_ta,top_ta,bottom_ta, xOptions_ta, yOptions_ta  )

       if nWidth != NIL
          ::Size( nWidth, nHeight )
       endif

       if oBar != NIL .AND. cMsgBar != NIL
         ::SetMsg( cMsgBar, oBar )
       endif

       if cFileName != NIL
          ::SetFileName( cFileName )/* Si fuese nMode =folder, se posiciona en el folder */
       endif

       if ! Empty( cFilter )
          ::SetFilter( cFilter ) 
       endif 
        
       if bAction != NIL 
          ::bAction = bAction
          ::Connect( "file-set" )
          ? "ok"
       endif
       
       ::Show()

RETURN Self


METHOD OnFile_Set( oSender ) CLASS GFILECHOOSERBUTTON

   Eval( ::bAction, oSender:GetFileName() )

RETURN NIL

METHOD SetFilter( cFilter ) CLASS GFILECHOOSERBUTTON

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
