/* $Id: gsignals.prg,v 1.0 2013-07-25 22:22:20 riztan Exp $*/
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

******************************************************************************
// Funciones de manejo de señales
FUNCTION gtk_signal_connect( pWidget, cSignal, pBlock )
  Local iReturn := 0
  
  iReturn := HARB_SIGNAL_CONNECT( pWidget, cSignal, NIL, pBlock , 0 )

RETURN iReturn
      
FUNCTION gtk_signal_connect_After( pWidget, cSignal, pBlock )
  Local iReturn := 0
  
  IF ValType( pBlock ) == "B"
     iReturn := HARB_SIGNAL_CONNECT( pWidget, cSignal, NIL, pBlock , G_CONNECT_AFTER )
#ifdef _GTK2_
  ELSE
     MsgSTOP( "Sorry...Codeblock not pass at widget "+ cValToChar( pWidget ), "Caution..." )
#endif
  ENDIF

RETURN iReturn

FUNCTION gtk_signal_connect_Swapped( pWidget, cSignal, pBlock )
  Local iReturn := 0
  
  /*
   IF ValType( pBlock ) == "B"
     iReturn := HARB_SIGNAL_CONNECT( pWidget, cSignal, NIL, pBlock , G_CONNECT_SWAPPED )
  ELSE
     MsgSTOP( "Sorry...Codeblock not pass at widget "+ cValToChar( pWidget ), "Caution..." )
  ENDIF
  */
#ifdef _GTK2_
  MsgSTOP( "Sorry...not implement...under xBase, not necessary..."+CRLF+;
           "Use function g_signal_connect()", "Caution..." )
#endif

RETURN iReturn

FUNCTION g_signal_connect( pWidget, cSignal, pBlock )
RETURN gtk_signal_connect( pWidget, cSignal, pBlock )

FUNCTION g_signal_connect_After( pWidget, cSignal, pBlock )
RETURN gtk_signal_connect_After( pWidget, cSignal, pBlock )

FUNCTION g_signal_connect_Swapped( pWidget, cSignal, pBlock )
RETURN gtk_signal_connect_Swapped( pWidget, cSignal, pBlock )
