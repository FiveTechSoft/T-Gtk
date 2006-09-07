/* $Id: gdlgfont.prg,v 1.1 2006-09-07 17:02:43 xthefull Exp $*/
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
#INCLUDE "gclass.ch"
#include "hbclass.ch"

CLASS GDLGFONT FROM GDIALOG
      DATA oBtn_Ok      // Los botones se trataran como objetos
      DATA oBtn_Cancel
      DATA cFont

      METHOD New( cTitle )
      METHOD SetFont( cFont ) INLINE gtk_font_selection_dialog_set_font_name( ::pWidget, cFont )
      METHOD SetPreview( cText ) INLINE gtk_font_selection_dialog_set_preview_text( ::pWidget, cText )
      METHOD GetFont() INLINE ::cFont:= gtk_font_selection_dialog_get_font_name( ::pWidget )

      METHOD OnClickedBtnOk( oSender )
      METHOD OnClickedBtnCancel( oSender )
      METHOD OnDestroy( oSender )

END CLASS

METHOD New( cTitle, cFontDefault, cPreview, lNoModal, cId, uGlade ) CLASS GDLGFONT

       DEFAULT cTitle := "Seleccione archivo",;
               lNoModal := .F.

       ::cFont := ""

       ::pWidget := gtk_font_selection_dialog_new ( cTitle )

       IF !Empty( cFontDefault )
          ::SetFont( cFontDefault )
       ENDIF

       IF !Empty( cPreview )
          ::SetPreview( cPreview )
       ENDIF

       ::Connect( "destroy" )

       ::oBtn_Ok     := gButton():Object_Empty()
       ::oBtn_Cancel := gButton():Object_Empty()
       ::oBtn_Ok:pWidget     := __get_pointer_btn_ok_font( ::pWidget )
       ::oBtn_Cancel:pWidget := __get_pointer_btn_cancel_font( ::pWidget )

       ::Connect( "clicked" , "OnClickedBtnOk", ::oBtn_Ok:pWidget )
       ::Connect( "clicked" , "OnClickedBtnCancel", ::oBtn_Cancel:pWidget )
       ::Connect( "destroy" , , ::oBtn_Ok:pWidget )
       ::Connect( "destroy" , , ::oBtn_Cancel:pWidget )

       ::Show()

       if !lNoModal
          ::Modal( TRUE )
       endif

       // Entramos en un nuevo bucle de mensajes, para poder devolver el nombre
       // en un momento dado.
       Gtk_Main()

RETURN Self

METHOD OnClickedBtnOk( oSender ) CLASS GDLGFONT
       oSender:cFont:= gtk_font_selection_dialog_get_font_name( oSender:pWidget )
       oSender:End()
RETURN .F.

METHOD OnClickedBtnCancel( oSender ) CLASS GDLGFONT
       oSender:cFont := ""
       oSender:End()
RETURN .F.

METHOD OnDestroy( oSender ) CLASS GDLGFONT
       gtk_main_quit()
RETURN .F.

Function ChooseFont( cTitle, cFontDefault, cPreview )
         Local oFont := gDlgFont():New( cTitle, cFontDefault, cPreview )
RETURN oFont:cFont
