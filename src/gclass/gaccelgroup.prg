/* $Id: gaccelgroup.prg,v 1.4 2010-02-08 12:37:38 xthefull Exp $*/
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
#include "gclass.ch"
#include "hbclass.ch"

CLASS GACCELGROUP FROM GOBJECT
      
      METHOD New( oWnd ) 
      METHOD Add( oWidget, cSignal , cKey )
      METHOD SetWindow( oWnd ) 
      METHOD Lock( )   INLINE gtk_accel_group_lock( ::pWidget )
      METHOD Unlock( ) INLINE gtk_accel_group_unlock( ::pWidget )
      METHOD Destroy() INLINE g_object_unref( ::pWidget )

ENDCLASS

METHOD New( oWnd ) CLASS GACCELGROUP
   ::pWidget := gtk_accel_group_new ()
   ::SetWindow( oWnd )
      
RETURN Self    

METHOD SetWindow( oWnd ) CLASS GACCELGROUP

    // Si la ventana ya tiene un Accel_Group , no vamos a permitir ponerle otro.
    if oWnd != NIL .AND. oWnd:oAccelGroup = NIL
       gtk_window_add_accel_group( oWnd:pWidget, ::pWidget ) 
       oWnd:oAccelGroup := Self
    endif

RETURN NIL

METHOD Add( oWidget, cSignal , uKey, nMode, nFlags ) CLASS GACCELGROUP
   Local nKey 
  
   DEFAULT nMode := 0, nFlags := 0

   if VALTYPE( uKey ) = "C"
      nKey := gdk_keyval_from_name( uKey ) 
   else
      nKey := uKey
   endif
   

  if ( nKey != GDK_VoidSymbol )
     gtk_widget_add_accelerator( oWidget:pWidget,;      
                                 cSignal,;
                                 ::pWidget,;
                                 nKey,;
                                 nMode, nFlags )

  else
     Msg_Alert( "The key name is not a valid key. ","Alert" )
  endif

RETURN NIL
