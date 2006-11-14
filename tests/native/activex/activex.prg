/* Ejemplo nativo del uso de ActiveX con T-Gtk
   
   Existe actualmente la limitacion de colocarlo en una ventana,
   en estudio la manera de empotrarlo en contenedores.

   The moment, ONLY PUT ActiveX in WINDOW, not in the widget.

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
  Local oActiveX, window
   
   window := gtk_window_new( GTK_WINDOW_TOPLEVEL )
   Gtk_Signal_Connect( window, "destroy", {|| gtk_main_quit() } )  
   gtk_window_set_title( window, "Using ActiveX from T-Gtk!" )
   gtk_window_set_position( window, GTK_WIN_POS_CENTER )
   gtk_window_set_default_size( window, 400, 400 )
   
   // Es necesario, de lo contrario, todavia no tenemos disponible el HWnd de la ventana
   gtk_widget_show( window ) 
   Gtk_Signal_Connect( window, "expose-event", {|| expose_event( window, oActiveX ) } )  
   
   oActiveX := TActiveX_FreeWin():New( window, "Shell.Explorer.2" ) 
   oActiveX:Navigate(  "http://freewin.sytes.net" ) 
  
   gtk_Main()

RETURN NIL 

// Informamos del cambio de la ventana
STATIC FUNCTION expose_event( window, oActiveX )
  LOCAL aRect
  Local nLeft, nTop, nWidth, nHeight, lRepaint
  Local hWnd := GET_HWND( window ) 
  
  HB_INLINE( oActiveX:pWidget, hWnd )
 {
   RECT rc;
   GetClientRect( (HWND)hb_parnl( 2 ), &rc );
   MoveWindow( (HWND)hb_parnl( 1 ), 0, 0, rc.right, rc.bottom, 1 );
 }

RETURN .F.
