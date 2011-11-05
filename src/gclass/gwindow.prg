/* $Id: gwindow.prg,v 1.5 2010-12-24 01:06:17 dgarciagil Exp $*/
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

static oWndMain

function SetWndMain( oWnd ); oWndMain := oWnd; return nil
function GetWndMain(); return oWndMain

CLASS GWINDOW FROM GCONTAINER

      CLASSDATA aWindows INIT {}

      DATA ldestroy_gtk_Main INIT .F.
      DATA bInit
      DATA oAccelGroup
      DATA oMenuPopup
      DATA lUseEsc INIT .F.
      DATA lInitiate INIT .F.

      METHOD NEW( cTitle, nType, nWidth, nHeight, cId, cGlade, cIconName, cIconFile )
      METHOD SetTitle( cText )  INLINE gtk_window_set_title ( ::pWidget, cText )
      METHOD cTitle( cText )    INLINE gtk_window_set_title ( ::pWidget, cText )
      METHOD SetIconName( cText ) INLINE gtk_window_set_icon_name ( ::pWidget, cText )
      METHOD SetIconFile( cText ) INLINE gtk_window_set_icon ( ::pWidget, cText )
      METHOD GetTitle( cText )  INLINE gtk_window_get_title ( ::pWidget )
      METHOD Activate( bEnd )
      METHOD SetResizable( lResizable ) INLINE gtk_window_set_resizable( ::pWidget, lResizable )
      METHOD Modal( lModal ) INLINE gtk_window_set_modal( ::pWidget, lModal )
      METHOD Maximize()      INLINE gtk_window_maximize( ::pWidget )
      METHOD Center()
      METHOD End()
      METHOD Register()
      METHOD SetDecorated( lDecorated ) INLINE gtk_window_set_decorated( ::pWidget , lDecorated )
      METHOD SetSkipTaskBar( lHide )    INLINE gtk_window_set_skip_taskbar_hint( ::pWidget , lHide )
      METHOD SetTypeHint( nType )       INLINE gtk_window_set_type_hint( ::pWidget , nType )
      METHOD GetOpacity()               INLINE gtk_window_get_opacity( ::pWidget )
      METHOD SetOpacity( nOpacity )     INLINE gtk_window_set_opacity( ::pWidget, nOpacity )
      METHOD GetTransparency()          INLINE 1-::GetOpacity()
      METHOD SetTransparency( nTransparency )      INLINE ::SetOpacity( 1-nTransparency )
      METHOD SetFocus()                 INLINE gtk_window_present( ::pWidget )
      METHOD SetMenuPopup( oMenu )

      //Signals of gWindow
      METHOD OnActivateDefault( oSender ) VIRTUAL
      METHOD OnActivateFocus( oSender )   VIRTUAL
      METHOD OnFrameEvent( oSender, pGdkEvent ) INLINE .F.
      METHOD OnKeysChanged( oSender ) VIRTUAL
      METHOD OnMoveFocus( oSender , nGtkDirectionType ) VIRTUAL
      METHOD OnSetFocus( oSender, pGtkWidget ) VIRTUAL

      // Signals Hierarchy re-write
      METHOD OnKeyPressEvent( oSender, pGdkEventKey  )
      METHOD OnEvent( oSender, pGdkEvent )

ENDCLASS

METHOD NEW( cTitle, nType, nWidth, nHeight, cId, uGlade, nType_Hint, ;
            cIconName, cIconFile, oParent ) CLASS GWINDOW
       DEFAULT nType   := GTK_WINDOW_TOPLEVEL
       //DEFAULT oParent := GetWndMain()

       if cId == NIL
          ::pWidget := gtk_window_new( nType )
       else
          ::pWidget := glade_xml_get_widget( uGlade, cId )
          ::CheckGlade( cId )
       endif

       if cTitle != NIL
          ::cTitle( cTitle )
       endif

       if nWidth != NIL
          ::Size( nWidth, nHeight )
       endif

       if nType_Hint != NIL
          ::SetTypeHint( nType_Hint )
       endif

       if cIconName = NIL
          if cIconFile = NIL
             //::SetIconName( GTK_STOCK_PREFERENCES )
             if GetWndMain() == NIL
                SET_DEFAULT_TGTK_ICON()
             elseif GET_DEFAULT_TGTK_ICON() == NIL
                ::SetIconName( GTK_STOCK_PREFERENCES )
             endif
          else
             ::SetIconFile( cIconFile )
          endif
       else
          ::SetIconName( cIconName )
       endif

       if oParent != NIL //.and. oParent:pWidget != GetWndMain():pWidget
           gtk_window_set_transient_for( ::pWidget, oParent:pWidget )
       endif

       ::Connect( "delete-event" )
       ::Connect( "destroy" )

       if GetWndMain() == NIL
          SetWndMain( Self )
       endif

RETURN Self


METHOD Activate( bEnd, lCenter, lMaximize, lModal, lInitiate ) CLASS GWINDOW

       DEFAULT ::bEnd := bEnd,;
               lInitiate := .F.

       if ::bInit != NIL
          Eval( ::bInit , Self )
       endif

       if lCenter
          ::Center()
       endif

       if lMaximize
          ::Maximize()
       endif

       ::Register()
       ::Show()
       
       if lModal
          ::Modal( .T. )
       endif

       ::lInitiate := lInitiate

       ::Connect( "key-press-event" )

       // Solamente se entra una vez en el bucle de GTK.
       IF ::lInitiate .or. GetWndMain() == Self
          ::lInitiate := .T.
          ::ldestroy_gtk_Main := .T.
          //connect_destroy_widget( ::pWidget ) // Conectarmos seal de destroy automaticamente
          Gtk_Main()
       ENDIF


RETURN NIL

METHOD End() CLASS GWINDOW
    
    if ! ::OnDelete_Event( Self )
       gtk_widget_destroy( ::pWidget )
    endif

return nil

METHOD Register() CLASS GWINDOW
    Super:Register()
    AADD( ::aWindows, Self )
    // Debugger
    //g_print("Ventana:" + cValtoChar( ::pWidget ) + ":Array:"+ cValtoChar( Len( ::aWindows ) ) )
RETURN NIL

METHOD Center( nPosition ) CLASS GWINDOW
   DEFAULT nPosition := GTK_WIN_POS_CENTER
   Gtk_Window_Set_Position( ::pWidget, nPosition )
RETURN NIL

METHOD SetMenuPopup( oMenu ) CLASS GWINDOW

  ::oMenuPopup := oMenu
  ::Connect( "event" )
  ::SetEvents( GDK_BUTTON_PRESS_MASK  )

RETURN NIL

METHOD OnEvent( oSender, pGdkEvent ) CLASS gWindow
   Local nEvent_Type, nEvent_Button_Button, nEvent_Button_Time

   if ::oMenuPopup != NIL // Si habiamos definido un MenuPopup
      nEvent_Type := HB_GET_GDKEVENT_TYPE( pGdkevent )
      if ( nEvent_Type == GDK_BUTTON_PRESS )        // Event_Type
          nEvent_Button_Button := HB_GET_GDKEVENT_BUTTON_BUTTON( pGdkevent )
          if ( nEvent_Button_Button == 3)                    // Event->Button.Button
             nEvent_Button_Time := HB_GET_GDKEVENT_BUTTON_TIME( pGdkevent )
             gtk_menu_popup( ::oMenuPopup:pWidget, NIL, NIL, NIL, NIL,;
                             nEvent_Button_Button, nEvent_Button_Time ) // event->button.time
          RETURN .T.
       endif
    endif
   endif

RETURN .F.

METHOD OnKeyPressEvent( oSender, pGdkEventKey ) CLASS gWindow
   local  nKey

   nKey := HB_GET_GDKEVENTKEY_KEYVAL( pGdkEventKey )// aGdkEventKey[ 6 ]

   do case
      case nKey == GDK_Escape
           if ::lUseEsc
              oSender:End()
              return .T.
           endif
   end case

RETURN Super:OnKeyPressEvent( oSender, pGdkEventKey )

