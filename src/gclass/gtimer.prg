/* $Id: gtimer.prg,v 1.2 2010-12-21 17:51:36 xthefull Exp $*/
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
    (c)2010 Marco Bernardi
*/

//----------------------------------------------------------------------------//
#include "hbclass.ch"
#include "gclass.ch"

static aTimers := {}
CLASS gTimer

   DATA   bAction
   DATA   nInterval
   DATA   oTimer
   DATA   i
   DATA   lActive

   METHOD New( nInterval, bAction )
   METHOD Activate()
   METHOD Enable()  INLINE ::lActive := .T.
   METHOD Disable() INLINE ::lActive := .F.
   METHOD End()

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( nInterval, bAction ) CLASS gTimer

   DEFAULT nInterval := 1000, bAction := { || nil }

   ::nInterval := nInterval
   ::bAction   := bAction

return Self

//----------------------------------------------------------------------------//

METHOD Activate() CLASS gTimer
  local i  
  if ( i := ascan(aTimers,{|bAct| bAct == NIL }) )=0 
     aadd(aTimers, Self)
     ::i := len(aTimers)
  else
     aTimers[i] := Self
     ::i        := i
  endif
  ::lActive := .t.
  ::oTimer  := TGTK_hb_SetTimer( ::nInterval, cValToChar( ::i ) )

Return nil

//----------------------------------------------------------------------------//

METHOD End() CLASS gTimer
   TGTK_hb_deltimer( ::oTimer )
   aTimers[::i] := NIL    
return nil

function timerevent( i )
  i:=val(i)
  
  if aTimers[i]:lActive
     eval( aTimers[i]:bAction )
  endif

return .t.


