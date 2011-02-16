#include "hbapi.h"

#define STARTCODE 5000

static char * ErrMessage[] = {
  "Invalid iterator param" //5000
}; 
  

  
char * GetGErrorMsg( int iCode )
{
  int iLen = sizeof( ErrMessage ) / sizeof( char * );
  int iPos = iCode - STARTCODE;
  char * cMsg = NULL;
  
  if( iPos >= 0 && iPos < iLen)
     cMsg = ( char * ) ErrMessage[ iPos ];
  
  return cMsg;
  
}
  
     