/* Ejemplo nativo del uso de ActiveX con T-Gtk
   Existe actualmente la limitacion de colocarlo en una ventana,
   en estudio la manera de empotrarlo en contenedores.

   Source information:  
   http://www.mail-archive.com/pygtk@daa.com.au/msg11107.html
   
   Please, view you PUT ACTIVEX INTO the widget DRAWINGAREA!

   ONLY FOR WINDOWS AND XHARBOUR!

   (c)2006 Rafa Carmona 
 */
#include "gclass.ch"
#pragma BEGINDUMP
   #include <hbapi.h>
   #include <hbvm.h>
   #include <windows.h>
   #include <hbapiitm.h>
   #include <commctrl.h>
#pragma ENDDUMP

Function Main()
  Local oActiveX, oWnd2, oDraw , oBox, oBtn
   
  DEFINE WINDOW oWnd2 TITLE "title"
      oWnd2:Show()
      
      DEFINE BOX oBox VERTICAL OF oWnd2
      DEFINE DRAWINGAREA oDraw SIZE 200,200 EXPAND FILL OF oBox ;
             EXPOSE EVENT Expose_event( oDraw, oActiveX )
     

      DEFINE BUTTON oBtn TEXT "Google";
             ACTION oActiveX:Navigate( "http://www.google.com" )  OF Obox
      
      /* Permite coger el foco desde un control win32 */
      oBtn:Connect( "button-press-event" )
      oBtn:bButtonPressEvent := { || oWnd2:SetFocus() }

      DEFINE BUTTON oBtn TEXT "home";
             ACTION oActiveX:GoHome()  OF Obox
      
      oBtn:Connect( "button-press-event" )
      oBtn:bButtonPressEvent := { || oWnd2:SetFocus() }
      
      oActiveX := TActiveX_FreeWin():New( oDraw, "Shell.Explorer.2" ) 
      oActiveX:Navigate( "http://www.google.com" ) 
  
  ACTIVATE WINDOW oWnd2

RETURN NIL 

// Informamos del cambio de la ventana
STATIC FUNCTION expose_event( window, oActiveX )
  Local hWnd := GET_HWND( window:pWidget ) 
  
  HB_INLINE( oActiveX:pWidget, hWnd )
 {
   RECT rc;
   GetClientRect( (HWND)hb_parnl( 2 ), &rc );
   MoveWindow( (HWND)hb_parnl( 1 ), 0, 0, rc.right, rc.bottom, 1 );
 }

RETURN .F.

STATIC FUNCTION Foco( window, oActiveX  ) 
  Local hWnd := GET_HWND( window:pWidget ) 
  
  HB_INLINE( oActiveX:pWidget, hWnd )
 {
   RECT rc;
   HWND mio;
   POINT pt;

   GetWindowRect( (HWND)hb_parnl( 2 ), &rc );
   pt.x = rc.left;
   pt.y = rc.top;
   mio = WindowFromPoint( pt );
   SetFocus(mio);
 }

RETURN .F.

