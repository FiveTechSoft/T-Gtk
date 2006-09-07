/* $Id: gadjustment.prg,v 1.1 2006-09-07 17:07:55 xthefull Exp $*/
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

CLASS GADJUSTMENT FROM GOBJECT

      METHOD New()
      METHOD Set( nValue ) INLINE gtk_adjustment_set_value( ::pWidget, nValue )
      METHOD Get( )        INLINE gtk_adjustment_get_value( ::pWidget )
      METHOD Clamp( nLower, nUpper ) INLINE gtk_adjustment_clamp_page( ::pWidget , nLower, nUpper )

ENDCLASS

METHOD New( nMin, nMax, nValue, nStep, nPage_inc, nPage_Size ) CLASS GADJUSTMENT

       DEFAULT nMin := 0 , nMax := 100, nStep := 1,;
       nPage_Inc := 10, nPage_Size := 10

       ::pWidget := gtk_adjustment_new( nMin, nMax, nValue, nStep, nPage_Inc, nPage_Size )

RETURN Self
