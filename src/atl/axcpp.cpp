#include <windows.h> 
#include <hbapi.h> 

typedef HRESULT (WINAPI *LPAtlAxWinInit) (); 
typedef HRESULT (WINAPI *LPAtlAxGetControl)( HWND hwnd, IUnknown** unk ); 
HMODULE hAtl = LoadLibrary( "Atl.Dll" ); 
LPAtlAxWinInit AtlAxWinInit = (LPAtlAxWinInit) GetProcAddress( hAtl, "AtlAxWinInit" ); 
LPAtlAxGetControl AtlAxGetControl = (LPAtlAxGetControl)GetProcAddress( hAtl, "AtlAxGetControl" ); 

extern "C" HB_FUNC( ATLAXWININIT ){ 
hb_retnl( AtlAxWinInit() ); 
} 

extern "C" HB_FUNC( ATLAXGETDISP ){ //hWnd -> pDisp 
IUnknown *pUnk; 
IDispatch *pDisp; 
AtlAxGetControl( (HWND)hb_parnl( 1 ), &pUnk ); 
pUnk->QueryInterface(IID_IDispatch, (void **)&pDisp); 
hb_retnl( (LONG)pDisp ); 
} 
