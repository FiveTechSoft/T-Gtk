#include <hbapi.h>
#include <windows.h>
/*-----------------------------------------------------------------------------------------------*/
typedef BOOL ( CALLBACK *PATLAXWININIT )( void );
typedef BOOL ( CALLBACK *PATLAXWINTERM )( void );
typedef HRESULT ( CALLBACK *PATLAXGETCONTROL )( HWND, IUnknown** );
/*-----------------------------------------------------------------------------------------------*/
static HMODULE   hLib            = LoadLibrary( "Atl.dll" );
PATLAXWININIT    AtlAxWinInit    = (PATLAXWININIT)    GetProcAddress( hLib, "AtlAxWinInit" );
PATLAXGETCONTROL AtlAxGetControl = (PATLAXGETCONTROL) GetProcAddress( hLib, "AtlAxGetControl" );
PATLAXWINTERM    AtlAxWinTerm    = (PATLAXWINTERM)    GetProcAddress( hLib, "AtlAxWinTerm" );

/*-----------------------------------------------------------------------------------------------*/
extern "C" HB_FUNC( ATLAXWININIT ){ // lInit
   hb_retnl( AtlAxWinInit() );
}

/*-----------------------------------------------------------------------------------------------*/
extern "C" HB_FUNC( ATLAXGETCONTROL ){ // hWnd --> pUnk
   IUnknown  *pUnk;
   AtlAxGetControl( (HWND)hb_parnl( 1 ), &pUnk );
   hb_retnl( (long) pUnk );
}

/*-----------------------------------------------------------------------------------------------*/
extern "C" HB_FUNC( ATLAXGETDISPATCH ){ // pUnk --> hObj
   IDispatch *pDsp;
   ( (IUnknown * ) hb_parnl( 1 ) ) -> QueryInterface( IID_IDispatch, (void **)&pDsp );
   hb_retnl( (long) pDsp );
}

/*-----------------------------------------------------------------------------------------------*/
extern "C" HB_FUNC( ATLAXWINTERM ){ // lTerm
  // AtlAxWinTerm();
}
