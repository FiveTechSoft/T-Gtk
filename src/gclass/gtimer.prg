/* $Id: gtimer.prg,v 1.1 2006-09-07 17:02:45 xthefull Exp $*/
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
    Control de Timers a traves de gLib
    (c)2003 Rafael Carmona <thefull@wanadoo.es>
*/

//----------------------------------------------------------------------------//
#include "hbclass.ch"
#include "gclass.ch"

static aTimers := {}
static nId     := 1

CLASS gTimer

   DATA   bAction
   DATA   lActive
   DATA   nId, nInterval
   DATA   Cargo

	 METHOD New( nInterval, bAction )
   METHOD Activate()
   METHOD Enable()  INLINE ::lActive := .T.
   METHOD Disable() INLINE ::lActive := .F.
   METHOD End()

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( nInterval, bAction ) CLASS gTimer

   DEFAULT nInterval := 1000, bAction := { || nil }

   ::nInterval = nInterval
   ::bAction   = bAction
 	 ::nId := ++nId
   ::lActive   = .F.
	 AAdd( aTimers, Self )

return Self

//----------------------------------------------------------------------------//

METHOD Activate() CLASS gTimer

	 ::nId := TGTK_hb_SetTimer( ::nInterval, cValToChar( ::nId ) )
   ::lActive = .t.

Return nil

//----------------------------------------------------------------------------//

METHOD End() CLASS gTimer
	 Local nAt, lResult

   lResult := TGTK_hb_deltimer( ::nId )
   if ( nAt := AScan( aTimers, { | o | o == Self } )  ) != 0
      ADel( aTimers, nAt )
      ASize( aTimers, Len( aTimers ) - 1 )
   endif

return nil

//----------------------------------------------------------------------------//

function TimerEvent( nId )

   local nTimer
	 nId := Val( nId )
	 nTimer := AScan( aTimers, { | oTimer | oTimer:nID == nId } )
	 if nTimer != 0 .and. aTimers[ nTimer ]:lActive
      Eval( aTimers[ nTimer ]:bAction )
   endif

Return .T.
