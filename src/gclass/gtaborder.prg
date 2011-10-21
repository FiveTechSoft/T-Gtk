/*
    Clase que nos permite definir un orden de saltos entre widgets
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
    (c)2011 Rafael Carmona <rafa.thefull@gmail.com>
*/
#include "gtkapi.ch"
#include "hbclass.ch"

CLASS GTabOrder
     METHOD Create( aWidgets, oParent )
END CLASS

METHOD Create( aWidgets, oParent ) CLASS gTabOrder
      Local g, aItems
      Local nLen := len( aWidgets )

      if !empty( nLen )
         aItems := Array ( nLen )  // Crear array de punteros de widgets
         for g := 1 to nLen
             aItems[ g ] := aWidgets[ g ]:pWidget
         next
         GTK_CONTAINER_SET_FOCUS_CHAIN ( oParent:pWidget , aItems )
      endif

RETURN Self

