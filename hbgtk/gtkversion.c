/* $Id: gtkversion.c,v 1.0 2022-06-21 20:55:47 xthefull Exp $*/
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
    (c)2022 Rafael Carmona <thefull@wanadoo.es>
*/

#include <hbapi.h>
#include <gtk/gtk.h>

HB_FUNC( GTK_GET_MAJOR_VERSION )
{
   hb_retni( GTK_MAJOR_VERSION );
}