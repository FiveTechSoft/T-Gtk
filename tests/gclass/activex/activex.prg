/* Ejemplo nativo del uso de ActiveX con T-Gtk

   Source information:  
   http://www.mail-archive.com/pygtk@daa.com.au/msg11107.html
   
   Please, view you PUT ACTIVEX INTO the widget DRAWINGAREA!
   New support EVENTS ACTIVEX!!

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

#define EXP_STATUSTEXTCHANGE             102
#define EXP_PROGRESSCHANGE               108
#define EXP_TITLECHANGE                  113

Function Main()
  Local oActiveX, oWnd2, oDraw , oBox, oBtn, oBar, oBox2, oGet, oBoxV
  Local cVar := "https://sourceforge.net/projects/t-gtk/"
  Local oProgress, nVar := 0, oBox3
   
  DEFINE WINDOW oWnd2 TITLE "title"
      oWnd2:Show()
      oWnd2:SetBorder( 10 )
      
      DEFINE BOX oBox VERTICAL OF oWnd2  SPACING 10
      DEFINE BOX oBox2 OF oBox SPACING 10
      
      DEFINE BUTTON oBtn OF oBox2 ACTION oActiveX:GoHome()
            DEFINE BOX oBoxV OF oBtn CONTAINER 
                DEFINE IMAGE FILE "../../images/Anieyes.gif" OF oBoxV 
                DEFINE LABEL PROMPT "<b>HOME</b>" ;
                       OF oBoxV MARKUP EXPAND FILL ;
                       VALIGN TOP ;
                       HALIGN RIGHT 

      /* Permite coger el foco desde un control win32 */
      oBtn:Connect( "button-press-event" )
      oBtn:bButtonPressEvent := { || oWnd2:SetFocus() }
      
      DEFINE ENTRY oGet VAR cVar OF oBox2 EXPAND FILL ;
             VALID ( oActiveX:Navigate( oGet:GetText() ),.T. )
      /* Permite coger el foco desde un control win32 */
      oGet:Connect( "button-press-event" )
      oGet:bButtonPressEvent := { || oWnd2:SetFocus() }
      
      DEFINE BUTTON oBtn TEXT "Ir..." ACTION oActiveX:Navigate( oGet:GetText() )  OF Obox2
                                                              
      /* Permite coger el foco desde un control win32 */
      oBtn:Connect( "button-press-event" )
      oBtn:bButtonPressEvent := { || oWnd2:SetFocus() }
      
      DEFINE DRAWINGAREA oDraw SIZE 200,200 EXPAND FILL OF oBox ;
             EXPOSE EVENT Expose_event( oDraw, oActiveX )

      DEFINE BOX oBox3 OF oBox SPACING 5
        DEFINE PROGRESSBAR oProgress VAR nVar TOTAL 1 OF oBox3
        DEFINE STATUSBAR oBar TEXT "Ejemplo Events ActiveX" OF oBox3 EXPAND FILL 

      oActiveX := TActiveX_FreeWin():New( oDraw, "Shell.Explorer.2" ) 
      oActiveX:Navigate( cVar ) 
       
      oActiveX:UserMap( EXP_STATUSTEXTCHANGE, { |cText| oBar:SetText( UTF_8( cText ) ) } )
      oActiveX:UserMap( EXP_TITLECHANGE ,     { |cText| oWnd2:SetTitle( UTF_8( cText ) ) } )   
      oActiveX:UserMap( EXP_PROGRESSCHANGE ,  { |nP, nMax| Paint_progress( oProgress, nP, nMax ) } )

      
      // file:///C:/GTK/share/gtk-doc/html/gtk/index.html
  

  ACTIVATE WINDOW oWnd2

RETURN NIL 

STATIC FUNCTION Paint_progress( oProgress, nSet, nMax )
    
    oProgress:SetTotal( nMax )
    
    if nSet < 0  
       nSet := 0
    endif
    
    oProgress:Set( nSet )

return nil

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
