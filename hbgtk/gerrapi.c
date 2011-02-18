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
    (c)2011 danielgarciagil@gmail.com
*/


#include "hbapi.h"
#include "hbapilng.h"
#include "gerrapi.h"
#include "hbapierr.h"

#define STARTCODE 5000

static G_LANG * pLangActive;

static G_LANG LangInstalled[] = {
  { "EN", &LoadMsgsEN, 0 },
  { "ES", &LoadMsgsES, 0 }
};

static G_ERRMSG * pErrMessage = NULL;
  
static const char * sIDLang = NULL;

//--------------------------------------------------------------//

static void LoadMsgs()
{
  const char * sID = hb_langID();
  
  if( ! sIDLang || hb_stricmp( sIDLang, sID ) != 0 ){    
    int iLen = sizeof( LangInstalled ) / sizeof( G_LANG );
    int i;
    sIDLang = sID;    

    for( i=0; i < iLen; i++ )
    {
      if( hb_stricmp( LangInstalled[ i ].sLang, sID ) == 0 ){
	int (*fp)();
	pLangActive = &LangInstalled[ i ];
	fp = pLangActive->pFuncLang;
	pLangActive->lTotalMsgs = (*fp)();
      }
    }
  }
}

//--------------------------------------------------------------//  
  
char * GetGErrorMsg( HB_ERRCODE iCode, const char * sAux )
{
  int iPos = ( int ) iCode - STARTCODE;
  char * cMsg = hb_xgrab( 128 );
  
  LoadMsgs();

  if( iPos >= 0 && iPos < pLangActive->lTotalMsgs )
    sprintf( cMsg,  pErrMessage[ iPos ].sDescription, sAux );

  return ( char * )cMsg;
  
}


//--------------------------------------------------------------//

void BuildErrMsg( G_ERRMSG *ErrMsg, int iSize )
{
  
  if( pErrMessage )
    hb_xfree( pErrMessage );
  
  pErrMessage = ( G_ERRMSG * ) hb_xgrab( iSize );
  
  memcpy( pErrMessage, ErrMsg, iSize );

  return;
}
