/* $Id: grange.prg,v 1.1 2006-09-07 17:02:45 xthefull Exp $*/
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

CLASS GRange FROM GWidget

      METHOD SetRange( nMin, nMax ) INLINE gtk_range_set_range( ::pWidget, nMin, nMax )
      METHOD Set( nValue )          INLINE gtk_range_set_value( ::pWidget, nValue )
      METHOD GetAdjust()            INLINE gtk_range_get_adjustment( ::pWidget )
      METHOD SetUpdate( nType )     INLINE gtk_range_set_update_policy( ::pWidget, nType )
      METHOD SetAdjust( oAdjust )   INLINE gtk_range_set_adjustment( ::pWidget, oAdjust:pWidget )
      METHOD GetInverted()          INLINE gtk_range_get_inverted( ::pWidget )
      METHOD SetInverted(lSetting)  INLINE gtk_range_set_inverted( ::pWidget, lSetting )
      METHOD GetUpdate()            INLINE gtk_range_get_update_policy( ::pWidget )
      METHOD Get()                  INLINE gtk_range_get_value( ::pWidget )
      METHOD SetIncrements( nStep, nPage ) INLINE gtk_range_set_increments( ::pWidget, nStep, nPage )

      //Signals
      METHOD OnValue_Changed( oSender ) VIRTUAL
      METHOD OnMove_Slider( oSender )   VIRTUAL
      METHOD OnAdjustBounds( oSender, nDouble_Arg1 ) VIRTUAL
      METHOD OnChangeValue( oSender,  nGtkScrollType, value ) INLINE .F.

ENDCLASS

