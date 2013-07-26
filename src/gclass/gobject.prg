/* $Id: gobject.prg,v 1.6 2010-12-28 18:52:20 dgarciagil Exp $*/
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

/* Clase principal, que heredan todos los widgets y no widgets de gtk */

#include "gclass.ch"
#include "hbclass.ch"

CLASS GOBJECT
      DATA pWidget  // puntero al Widget
      DATA aSignals
      DATA bAction, bLeave, bEnter, bChange, bWhen
      DATA bValid
      DATA bEnd
      DATA bLostFocus
      DATA bDestroy

      METHOD Object_Empty() INLINE Self
      METHOD Set_Valist( aValues, pWidget ) 
      METHOD Set_Property( cProperty_name, uValue ) INLINE g_object_set_property( ::pWidget, cProperty_name, uValue  )
      METHOD Connect( cEvento, cMethod, pWidget, ConnectionFlags)
      METHOD Connect_After( cEvento, cMethod, pWidget )   INLINE ::Connect( cEvento, cMethod, pWidget, G_CONNECT_AFTER )
//      METHOD Connect_Swapped( cEvento, cMethod, pWidget ) INLINE ::Connect( cEvento, cMethod, pWidget, G_CONNECT_SWAPPED )
      METHOD OnDestroy( oSender )
      METHOD OnDelete_Event( oSender )
      METHOD OnLeave( oSender )
      METHOD OnEnter( oSender )
      METHOD OnActivate( oSender )
      METHOD Emit_Signal( cSignal ) INLINE g_signal_emit_by_name( ::pWidget, cSignal )
      METHOD DisConnect( cSignal )
      METHOD CheckGlade( cId )


ENDCLASS

******************************************************************************
******************************************************************************
METHOD Set_Valist( aValues, pWidget ) CLASS GOBJECT
    DEFAULT pWidget := ::pWidget
    g_object_set_valist( pWidget, aValues )
RETURN NIL

******************************************************************************
METHOD Connect( cSignal, cMethod, pWidget, ConnectionFlags ) CLASS GOBJECT
    Local nId_Signal

    if ::aSignals == NIL
       ::aSignals := {}
    endif

    if pWidget == NIL
       pWidget := ::pWidget
    endif
	//TraceLog( pWidget, cEvento, ValToPrg(Self), cMethod, ConnectionFlags)

    nId_Signal := harb_signal_connect( pWidget, cSignal, Self, cMethod, ConnectionFlags )

    AADD( ::aSignals, { cSignal, nId_Signal } )

RETURN nId_Signal
******************************************************************************
METHOD DisConnect( cSignal ) CLASS GOBJECT
  Local nPos, nId_Signal 

  nPos := ascan( ::aSignals, {|aVal| UPPER( ALLTRIM( cSignal ) ) == UPPER( ALLTRIM( aVal[1] ) ) } ) 

  if nPos != 0 
     nId_Signal := ::aSignals[ nPos, 2 ] 
     hb_g_signal_handler_disconnect( ::pWidget , nId_Signal, cSignal )
     ADel( ::aSignals, nPos )
     ASize( ::aSignals, Len( ::aSignals ) - 1 )
  endif

RETURN NIL

******************************************************************************
METHOD OnActivate( oSender ) CLASS GOBJECT
   
   if oSender:bAction != NIL
      Eval( oSender:bAction, oSender )
   endif

RETURN .F.


******************************************************************************
METHOD OnLeave( oSender ) CLASS GOBJECT

    oSender:CursorLeave()
    if oSender:bLeave != NIL
       Eval( oSender:bLeave, oSender )
    endif

RETURN NIL

******************************************************************************
METHOD OnEnter( oSender ) CLASS GOBJECT

    oSender:CursorEnter()
    if oSender:bEnter != NIL
       Eval( oSender:bEnter, oSender )
    endif

RETURN NIL

******************************************************************************
METHOD OnDestroy( oSender ) CLASS GOBJECT
    Local nWidget
    Local cClassName := oSender:ClassName()

   if oSender:bDestroy != NIL
       Eval( oSender:bDestroy, oSender )
    endif

    if oSender:oFont != NIL
       //? "Font destruida de : "+ oSender:ClassName() + " " // DEBUG
       oSender:oFont:End()  // Destruccion de la font asociado a un widget
    endif

    if oSender:pCursorEnter != NIL // destroy del cursor
       gdk_cursor_unref( oSender:pCursorEnter )
    endif

    if oSender:ISDERIVEDFROM( "GWINDOW" )//cClassName == "GDIALOG" .OR. cClassName == "GWINDOW"
       SysRefresh()       
       hb_gcAll()         // Garbage collector
    endif

    if oSender:ISDERIVEDFROM( "GWINDOW" )  // cClassName == "GWINDOW" .OR. cClassName == "GDIALOG" .OR. cClassName == "GASSISTANT"
       if oSender:oAccelGroup != NIL
          oSender:oAccelGroup:Destroy()
       endif
       if cClassName == "GDIALOG" .OR. cClassName == "GASSISTANT"// Si es un dialogo, lo matamos
          gtk_widget_destroy( oSender:pWidget )
       endif

       if oSender:ldestroy_gtk_Main
          gtk_main_quit()
       endif
    endif

    if cClassName == "GDIALOG" .OR. cClassName == "GWINDOW"
       nWidget := AScan( oSender:aWindows, { | oControl | oControl:pWidget == oSender:pWidget } )
       if nWidget != 0
          ADEL( oSender:aWindows, nWidget )
          ASIZE( oSender:aWindows, ( Len( oSender:aWindows ) - 1) )
          // Debugger
          //g_print( "destroy"+ cvaltochar( oSender:pWidget ) +;
          //         ":"+ cvaltochar( Len(oSender:aWindows) ) + HB_OSNEWLINE() )
       endif
    endif
    
    oSender:pWidget = NIL

RETURN .F.

******************************************************************************

METHOD OnDelete_Event( oSender ) CLASS GOBJECT
    Local lResult := .T.

   if oSender:bEnd != NIL 
      lResult = Eval( oSender:bEnd, oSender )
      if ValType( lResult ) != "L" 
         lResult = .F.
      endif 
   endif

Return ! lResult

******************************************************************************
// Chequea si el puntero es correto, evitando GPF y dando 'pistas'
METHOD CheckGlade( cId ) CLASS GOBJECT
     IF empty( ::pWidget ) 
        MsgStop( "No existe widget: " + cId ,  "PARADA CRITICA!!" )
        gtk_widget_destroy( GetWndMain():pWidget )
     ENDIF
RETURN .F.

******************************************************************************
/* Funciones de manejos de señales movidas a gsignals.prg */
******************************************************************************

//eof
