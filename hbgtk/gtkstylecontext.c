/* $Id: gtkstylecontext.c,v 1.0 2022-07-07 21:32:32 riztan Exp $*/
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
    (c)2022 Riztan Gutierrez <riztan@gmail.com>
*/

#include <gtk/gtk.h>
#include "hbapi.h"
#include "t-gtk.h"
#include "hbapierr.h"
#include "gerrapi.h"

HB_FUNC( GTK_STYLE_CONTEXT_ADD_PROVIDER )
{
   GtkStyleContext  * context  = hb_parptr( 1 );
   GtkStyleProvider * provider = hb_parptr( 2 );
   guint priority = hb_parni( 3 );
   gtk_style_context_add_provider( context, provider, priority );
}

/*
HB_FUNC( GTK_STYLE_CONTEXT_ )
{
   GtkStyleContext * context = hb_parptr( 1 );
   hb_retptr();
}


HB_FUNC( GTK_STYLE_CONTEXT_ )
{
   GtkStyleContext * context = hb_parptr( 1 );
   hb_retptr();
}

HB_FUNC( GTK_STYLE_CONTEXT_ )
{
   GtkStyleContext * context = hb_parptr( 1 );
   hb_retptr();
}
*/
//eof
