/* $Id: gmisc.prg,v 1.1 2006-09-07 17:02:44 xthefull Exp $*/
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
/* Clase para alineacion de gLabels, gArrow, gImage, ( gPixmap ) */
#include "gtkapi.ch"
#include "hbclass.ch"

CLASS GMISC FROM GWIDGET
      
      METHOD SetAlignment( xAlign, yAlign  )
      METHOD GetAlignment( xAlign, yAlign  )
      METHOD SetPadding( xPad, yPad )  
      METHOD GetPadding( xPad, yPad )  

ENDCLASS

METHOD SetAlignment( xAlign, yAlign  ) CLASS GMISC
    DEFAULT xAlign := 0.5,;
            yAlign := 0.5

    gtk_misc_set_alignment( ::pWidget, xAlign, yAlign )

RETURN NIL

METHOD SetPadding( xPad, yPad )  CLASS GMISC
    DEFAULT xPad := 0,;
            yPad := 0

    gtk_misc_set_padding( ::pWidget, xPad, yPad ) 

RETURN NIL

METHOD GetAlignment( xAlign, yAlign  )

    gtk_misc_get_alignment( ::pWidget, @xAlign, @yAlign )

RETURN  NIL

METHOD GetPadding( xPad, yPad )  CLASS GMISC

    gtk_misc_get_padding( ::pWidget, @xPad, @yPad ) 

RETURN  NIL
