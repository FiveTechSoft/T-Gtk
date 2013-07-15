/* $Id: gdkcolor.c,v 1.1 2006-09-08 12:18:45 xthefull Exp $*/
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
    (c)2003 Joaquim Ferrer <quim_ferrer@yahoo.es>
*/

#include <gtk/gtk.h>
#include "hbapi.h"
#include "hbapiitm.h"


PHB_ITEM Color2Array( GdkColor *color );
BOOL Array2Color(PHB_ITEM aColor, GdkColor *color );

HB_FUNC( GDK_COLOR_PARSE ) //  string name_color -> logical
{
  GdkColor color;
  gchar * name = (gchar *) hb_parc( 1 );
  hb_retl( (gboolean) gdk_color_parse( name, &color ) );
}

/*
 * Convierte una estructura item en un array de Harbour
 struct GdkColor {
  guint32 pixel;
  guint16 red;
  guint16 green;
  guint16 blue;
  };
 */

PHB_ITEM Color2Array( GdkColor *color )
{
   PHB_ITEM aColor = hb_itemArrayNew(4);
   PHB_ITEM element = hb_itemNew( NULL );

   hb_arraySet( aColor, 1, hb_itemPutNI( element, color->pixel ) );
   hb_arraySet( aColor, 2, hb_itemPutNI( element, color->red ) );
   hb_arraySet( aColor, 3, hb_itemPutNI( element, color->green ) );
   hb_arraySet( aColor, 4, hb_itemPutNI( element, color->blue ) );
   hb_itemRelease(element);
   return aColor;
}

/*
 * Convierte un array en un GdkColor
 * Comprueba si el dato pasado es correcto y su numero de elementos
 */
BOOL Array2Color(PHB_ITEM aColor, GdkColor *color )
{
   if (HB_IS_ARRAY( aColor ) && hb_arrayLen( aColor ) == 4)
   {
       color->pixel = (guint32) hb_arrayGetNI( aColor, 1 );
       color->red   = (guint16) hb_arrayGetNI( aColor, 2 );
       color->green = (guint16) hb_arrayGetNI( aColor, 3 );
       color->blue  = (guint16) hb_arrayGetNI( aColor, 4 );
      return TRUE ;
   }
   return FALSE;
}


//eof
