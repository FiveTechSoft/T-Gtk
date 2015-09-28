/* $Id: gwidget.prg,v 1.7 2010-12-24 01:06:17 dgarciagil Exp $*/
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

STATIC aControls := {}

CLASS GWIDGET FROM GOBJECT
       DATA cText
       DATA oFont

       // Cursors que queramos que tengan los widgets
       DATA pCursorEnter
       DATA nTypeCursor
       DATA cMsgBar, oBar

       DATA bConfigure_Event
       DATA bExpose_Event
       DATA bSizeAllocate, bFocus, bButtonPressEvent
       DATA bKeyPressEvent
       METHOD Register() VIRTUAL
       METHOD Show()     INLINE gtk_widget_show( ::pWidget )
       METHOD Hide()     INLINE gtk_widget_hide( ::pWidget )
       METHOD SetBorder( nBorder )  INLINE gtk_container_set_border_width( ::pWidget, nBorder )
       METHOD Quit()     INLINE gtk_main_quit( ),Self

       METHOD SetFocus()    INLINE gtk_widget_grab_focus( ::pWidget )
       METHOD SetCanFocus( lBool ) INLINE gtk_widget_set_can_focus( ::pWidget, lBool )

       METHOD Enable()     INLINE gtk_widget_set_sensitive( ::pWidget, .T.)
       METHOD Disable()    INLINE gtk_widget_set_sensitive( ::pWidget, .F.)
       METHOD End()        INLINE gtk_widget_destroy( ::pWidget )
       METHOD SetEvents( uEvents ) INLINE gtk_widget_set_events( ::pWidget, uEvents )
       METHOD AddEvents( uEvents ) INLINE gtk_widget_add_events( ::pWidget, uEvents )

       METHOD SetFont( oFont ) INLINE ::oFont := oFont, gtk_widget_modify_font( ::pWidget, oFont:pFont )
       METHOD Size( nWidth, nHeight )   INLINE gtk_widget_set_usize( ::pWidget, nWidth, nHeight )
       METHOD Style( cColor, iComponent, iState ) INLINE  __GSTYLE( cColor, ::pWidget, iComponent , iState )

       // Insercion de contanedores padre/hijo
       METHOD AddContainer( oParent )   INLINE gtk_container_add( oParent:pWidget, ::pWidget )
       METHOD box_pack_start( oBox, lExpand, lFill, nPadding )
       METHOD Box_Pack_end( oBox, lExpand, lFill, nPadding)
       METHOD AddChild( oParent, lExpand, lFill, nPadding, lContainer, x, y , lEnd)
       METHOD Refresh( ) INLINE gtk_widget_queue_draw( ::pWidget )

       METHOD RemoveContainer( oChild ) VIRTUAL

       METHOD CursorEnter()
       METHOD CursorLeave()
       METHOD ActivateCursor( nCursor )

       METHOD MsgLeave()
       METHOD MsgEnter()
       METHOD SetMsg( cMsgBar, oBar )

       /* Signals */
       METHOD OnAccelClosuresChanged( oSender )     VIRTUAL
       METHOD OnButtonPressEvent( oSender, pGdkEventButton )  SETGET
       METHOD OnButtonReleaseEvent( oSender, pGdkEventButton ) INLINE .F.
       METHOD OnCanActivateAccel( oSender, nSignal_Id )        INLINE .F.
       METHOD OnChildNotify( oSender, pGParamSpec )  VIRTUAL
       METHOD OnClientEvent( oSender, pGdkEventClient ) INLINE .F.
       METHOD OnConfigure_Event( oSender, pGdkEventConfigure )
       METHOD OnDestroyEvent( oSender, pGdkEvent )      INLINE .F.
       METHOD OnDirectionChanged( oSender, nGtkTextDirection )  VIRTUAL
       METHOD OnEnterNotifyEvent( oSender,  pGdkEventCrossing )
       METHOD OnEvent( oSender, pGdkEvent ) INLINE .F.
       METHOD OnEventAfter( oSender, pGdkEvent ) VIRTUAL
       METHOD OnExpose_Event( oSender, pGdkEventExpose )
       METHOD OnFocus( oSender, nGtkDirectionType ) SETGET
       METHOD OnFocus_In_Event( oSender , pGdkEventFocus )
       METHOD OnFocus_Out_Event( oSender, pGdkEventFocus )
       METHOD OnGrabBrokenEvent( oSender, pGdkEvent ) INLINE .F.
       METHOD OnGrabFocus( oSender ) INLINE .F.
       METHOD OnGrabNotify( oSender, lArg1 ) VIRTUAL
       METHOD OnHide( oSender ) VIRTUAL
       METHOD OnHierarchyChanged( oSender, pWidget2 ) VIRTUAL
       METHOD OnKeyPressEvent( oSender,   pGdkEventKey  ) SETGET
       METHOD OnKeyReleaseEvent( oSender, pGdkEventKey  ) INLINE .F.
       METHOD OnLeaveNotifyEvent( oSender,  pGdkEventCrossing )
       METHOD OnMap( oSender ) VIRTUAL
       METHOD OnMapEvent( oSender, pGdkEvent )     INLINE .F.
       METHOD OnMnemonicActivate( oSender, lArg1 ) INLINE .F.
       METHOD OnMotionNotifyEvent( oSender, pGdkEventMotion ) INLINE .F.
       METHOD OnNoExposeEvent( oSender, pGdkEventNoExpose )   INLINE .F.
       METHOD OnParentSet( oSender, pGtkObject ) VIRTUAL
       METHOD OnPopupMenu( oSender ) INLINE .F.
       METHOD OnRealize( oSender )   VIRTUAL
       METHOD OnPropertyNotifyEvent( oSender, pGdkEventProperty ) INLINE .F.
       METHOD OnProximityInEvent( oSender, pGdkEventProximity  )  INLINE .F.
       METHOD OnProximityOutEvent( oSender, pGdkEventProximity )  INLINE .F.
       METHOD OnScreenChanged( oSender, pGdkScreen ) VIRTUAL
       METHOD OnScrollEvent( oSender, pGdkEventScroll )  INLINE .F.
       METHOD OnSelectionClearEvent( oSender, pGdkEventSelection )       INLINE .F.
       METHOD OnSelectionGet( oSender, pGtkSelectionData, nInfo, nTime ) INLINE .F.
       METHOD OnSelectionNotifyEvent( oSender, pGdkEventSelection )      INLINE .F.
       METHOD OnSelectionReceived( oSender, pGtkSelectionData, nTime )   INLINE .F.
       METHOD OnSelectionRequestEvent( oSender, pGdkEventSelection )     INLINE .F.
       METHOD OnShow( oSender ) VIRTUAL
       METHOD OnShowHelp( oSender, nGtkWidgetHelpType ) INLINE .F.
       METHOD OnSizeAllocate( oSender, GtkAllocation )
       METHOD OnSizeRequest( oSender, pGtkRequisition ) VIRTUAL
       METHOD OnStateChanged( oSender, nGtkStateType )  VIRTUAL
       METHOD OnStyleSet( oSender, pGtkStyle_previous_style  ) VIRTUAL
       METHOD OnUnMap( oSender ) VIRTUAL
       METHOD OnUnMapEvent( oSender, pGdkEvent ) INLINE .F.
       METHOD OnUnRealize( oSender ) VIRTUAL
       METHOD OnVisibilityNotifyEvent( oSender, pGdkEventVisibility ) INLINE .F.
       METHOD OnWindowStateEvent( oSender, pGdkEventWindowState ) INLINE .F.
	   //METHOD OnDelete_From_Cursor( oSender, nDeleteType, nMode ) VIRTUAL

ENDCLASS


******************************************************************************
* Introduce widget child en su contenedor correspondiente
******************************************************************************
METHOD AddChild( oParent, lExpand, lFill, nPadding, lContainer, x, y,;
                 uLabelTab, lEnd, lSecond, lResize, lShrink,;
                 left_ta,right_ta,top_ta,bottom_ta, xOptions_ta, yOptions_ta ) CLASS GWIDGET
       Local uTempLabel

       DEFAULT lExpand := .F., lFill := .F., nPadding := 0 ,;
                x := 1, y := 1, uLabelTab := "TAB",;
                lEnd := .F.,;
                lResize := .F.,;
                lShrink := .F.,;
                lSecond := .F.

       IF oParent != NIL
          IF oParent:ClassName() = "GPANED"  // Si es un panel, lo metemos
             oParent:AddPaned( Self, lSecond, lResize, lShrink )
             return nil
          ENDIF

          IF oParent:ClassName() = "GTABLE"  // Si es tabla,
             if xOptions_ta = NIL
                oParent:AddTable( Self, left_ta,right_ta,top_ta,bottom_ta )
             else
                oParent:AddTable_ex( Self, left_ta,right_ta,top_ta,bottom_ta, xOptions_ta, yOptions_ta, 0 , 0 )
             endif
             return nil
          ENDIF
       ENDIF

       IF oParent != NIL
          IF oParent:ClassName() = "GFIXED"
             oParent:Put( Self, x, y )
          ELSE
            IF oParent:ClassName() = "GNOTEBOOK" // Introducimos dentro del Notebook
               IF Valtype( uLabelTab ) == "C"    // Si pasamos cadena texto , creamos el objeto
                  DEFINE LABEL uTempLabel TEXT uLabelTab
               ELSE
                  uTempLabel := uLabelTab
               ENDIF
               oParent:Append( Self, uTempLabel )
            ELSE
               IF lContainer
                  ::AddContainer( oParent )
               ELSE
                  if lEnd
                     ::Box_Pack_End( oParent, lExpand, lFill, nPadding )
                  else
                     ::Box_Pack_Start( oParent, lExpand, lFill, nPadding )
                  endif
               ENDIF
            ENDIF
          ENDIF
       ENDIF

RETURN NIL

******************************************************************************
******************************************************************************
METHOD Box_Pack_Start( oBox, lExpand, lFill, nPadding)  CLASS GWIDGET
       DEFAULT lExpand := .F., lFill := .F., nPadding := 0

       gtk_box_pack_start( oBox:pWidget, ::pWidget, lExpand, lFill, nPadding )

RETURN nil

******************************************************************************
******************************************************************************
METHOD Box_Pack_End( oBox, lExpand, lFill, nPadding)  CLASS GWIDGET
       DEFAULT lExpand := .F., lFill := .F., nPadding := 0

       gtk_box_pack_end( oBox:pWidget, ::pWidget, lExpand, lFill, nPadding )

RETURN nil


******************************************************************************
******************************************************************************
METHOD ActivateCursor( nCursor ) CLASS GWIDGET
       ::nTypeCursor := nCursor
       ::Connect("leave")
       ::Connect("enter")
RETURN NIL

******************************************************************************
******************************************************************************
METHOD CursorEnter( ) CLASS GWIDGET
       Local uCursor := NIL

       if ::nTypeCursor != NIL .AND. ::pCursorEnter == NIL
          ::pCursorEnter := gdk_cursor_new( ::nTypeCursor )
          gdk_window_set_cursor( ::pWidget , ::pCursorEnter )
       elseif ::nTypeCursor != NIL .AND. ::pCursorEnter != NIL
          gdk_window_set_cursor( ::pWidget , ::pCursorEnter )
       endif

RETURN NIL

******************************************************************************
******************************************************************************
METHOD CursorLeave( ) CLASS GWIDGET

     if ::nTypeCursor != NIL .AND. ::pCursorEnter != NIL
        gdk_window_set_cursor( ::pWidget , NIL )
     endif

RETURN NIL

******************************************************************************
******************************************************************************
METHOD SetMsg( cMsgBar, oBar ) CLASS GWIDGET

    //::Connect("leave")
    //::Connect("enter")
    ::Connect( "focus-out-event")
    ::Connect( "focus-in-event")
    ::cMsgBar := cMsgBar
    ::oBar    := oBar

RETURN NIL

******************************************************************************
******************************************************************************
METHOD MsgEnter()  CLASS GWIDGET
    if ::oBar != NIL
       ::oBar:Push( ::cMsgBar )
    endif
RETURN NIL

******************************************************************************
******************************************************************************
METHOD MsgLeave()  CLASS GWIDGET
    if ::oBar != NIL
       ::oBar:Pop()
    endif
RETURN NIL

// Las se�ales "enter" y "leave", son deprecated.
// En su lugar , indican que deberian usarse "enter-notify-event" y "leave-notify-event"
******************************************************************************
METHOD OnLeaveNotifyEvent( oSender, pGdkEventCrossing ) CLASS GWIDGET

    oSender:CursorLeave()
    if oSender:bLeave != NIL
       Eval( oSender:bLeave, oSender )
    endif

RETURN NIL

******************************************************************************
METHOD OnEnterNotifyEvent( oSender, pGdkEventCrossing ) CLASS GWIDGET

    oSender:CursorEnter()
    if oSender:bEnter != NIL
       Eval( oSender:bEnter, oSender )
    endif

RETURN NIL

******************************************************************************
* a la Fivewin seria +- ::LostFocus()
******************************************************************************
METHOD OnFocus_out_event( oSender, pGdkEventFocus ) CLASS GWIDGET

    oSender:MsgLeave()  // Limpiamos mensaje en Status Bar

    IF oSender:bValid != nil
       IF ! Eval( oSender:bValid, oSender )
          oSender:SetFocus()
          RETURN .T.
       ENDIF
    ENDIF

    gtk_widget_queue_draw( oSender:pWidget ) // Redibujo el widget

    if oSender:bLostFocus != nil
       Eval( oSender:bLostFocus, oSender )
    endif

RETURN .F.

******************************************************************************
METHOD OnFocus_in_event( oSender, pGdkEventFocus ) CLASS GWIDGET

     oSender:MsgEnter()  // Colocamos mensaje en Status Bar

     IF oSender:bWhen != nil
        IF !Eval( oSender:bWhen, oSender )
           gtk_widget_child_focus( gtk_widget_get_toplevel( oSender:pWidget) ,GTK_DIR_TAB_FORWARD)
        ENDIF
     ENDIF

RETURN .F.

******************************************************************************
METHOD OnConfigure_Event( oSender, pGdkEventConfigure )  CLASS GWIDGET

  IF oSender:bConfigure_Event != nil
     RETURN Eval( oSender:bConfigure_Event, oSender, pGdkEventConfigure )
  ENDIF

RETURN .F.

******************************************************************************
METHOD OnExpose_Event( oSender, pGdkEventExpose ) CLASS GWIDGET

   IF oSender:bExpose_Event != NIL
      return Eval( oSender:bExpose_Event , oSender, pGdkEventExpose )
   ENDIF

RETURN .F.

******************************************************************************
METHOD OnSizeAllocate( oSender, pGtkAllocation ) CLASS GWIDGET

   IF oSender:bSizeAllocate != NIL
      return Eval( oSender:bSizeAllocate , oSender, pGtkAllocation )
   ENDIF

RETURN .F.

******************************************************************************
METHOD OnFocus( uParam, nGtkDirectionType ) CLASS GWIDGET

   if hb_IsBlock( uParam )
      ::bFocus = uParam
      ::Connect( "focus" )
   elseif hb_IsObject( uParam )
      if hb_IsBlock( uParam:bFocus )
         Eval( uParam:bFocus, uParam, nGtkDirectionType )
      endif
   endif

RETURN .F.

******************************************************************************
METHOD OnButtonPressEvent( uParam, pGdkEventButton )  CLASS GWIDGET

   if hb_IsBlock( uParam )
      ::bButtonPressEvent = uParam
      ::Connect( "button-press-event" )
   elseif hb_IsObject( uParam )
      if hb_IsBlock( uParam:bButtonPressEvent )
         Eval( uParam:bButtonPressEvent, uParam, pGdkEventButton )
      endif
   endif

RETURN .F.

******************************************************************************

METHOD OnKeyPressEvent( uParam, pGdkEventKey )  CLASS GWIDGET

   if hb_IsBlock( uParam )
      ::bKeyPressEvent = uParam
      ::Connect( "key-press-event" )
   elseif hb_IsObject( uParam )
      if hb_IsBlock( uParam:bKeyPressEvent )
         Eval( uParam:bKeyPressEvent, uParam, pGdkEventKey )
      endif
   endif

RETURN .F.
