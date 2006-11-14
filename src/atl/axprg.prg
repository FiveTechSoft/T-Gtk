/* 
Lira Lira Oscar Joel [oSkAr ] 
Clase TAxtiveX_FreeWin
Noviembre 8 del 2006 
email: oscarlira78@hotmail.com 
http://freewin.sytes.net 
@CopyRight 2006 Todos los Derechos Reservados 
Requiere TOleAuto incluida en xHarbour 

 Adaptada para T-Gtk por Rafa Carmona
*/ 
/*-----------------------------------------------------------------------------------------------*/ 
#include "gclass.ch"
#include "hbclass.ch"

CLASS TActiveX_FreeWin 
    DATA oOle , oWnd , pWidget
    
    METHOD New() 
    ERROR Handler OnError() 

ENDCLASS 

/*-----------------------------------------------------------------------------------------------*/ 
METHOD New( uoWnd, cProgId ) 
    Local hWnd

    AtlAxWinInit() 
    if Valtype( uoWnd ) = "O"
       hWnd :=  GET_HWND( uoWnd:pWidget )
    else
       hWnd := GET_HWND( uoWnd ) 
    endif
    ::pWidget := CreateWindowEx( hWnd, cProgId )
    ::oOle := TOleAuto():New( AtlAxGetDisp( ::pWidget ) )

RETURN SELF 

/*-----------------------------------------------------------------------------------------------*/ 
METHOD ONERROR( ... ) 
    LOCAL cMethod := __GetMessage() 
    IF cMethod[1] == "_" 
       cMethod := Right( cMethod, 2 ) 
    ENDIF 
    HB_ExecFromArray( ::oOle, cMethod, HB_aParams() ) 
RETURN NIL 

/*-----------------------------------------------------------------------------------------------*/ 
#pragma BEGINDUMP 
#include <windows.h> 
#include <hbapi.h> 
#include <gtk/gtk.h>
//#include <gdkwin32.h>
#define GDK_WINDOW_HWND(d) (gdk_win32_drawable_get_handle (d))
/* Translate from drawable to Windows handle */
HGDIOBJ       gdk_win32_drawable_get_handle (GdkDrawable *drawable);

HB_FUNC_STATIC( CREATEWINDOWEX ) // hWnd, cProgId -> hActiveXWnd 
{ 
RECT rc; 
HWND hControl; 
GetClientRect( (HWND)hb_parnl( 1 ), &rc ); 
hControl = CreateWindowEx( 0, "AtlAxWin", hb_parc( 2 ), 
WS_VISIBLE|WS_CHILD, 0, 0, rc.right, rc.bottom, (HWND)hb_parnl( 1 ), 0, 0, NULL ); 
hb_retnl( (long) hControl ); 
} 

HB_FUNC( GET_HWND )
{
  GtkWidget * widget = GTK_WIDGET( hb_parnl( 1 ) );
  HWND hWnd = gdk_win32_drawable_get_handle( GDK_DRAWABLE( widget->window ) );
  //HWND hWnd = GDK_WINDOW_HWND( GDK_DRAWABLE( widget->window ) );
  hb_retnl( (glong) hWnd );

 }

#pragma ENDDUMP 
