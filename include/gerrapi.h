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

#include "hbapierr.h"


//functions prototypes lang messages 
int LoadMsgsEN();
int LoadMsgsES();

//------------------------------------//


typedef struct _G_ERRMSG
{
  int iCode;                  // error code
  const char * sDescription;  // error description
} G_ERRMSG, * PG_ERRMSG;


typedef struct _G_LANG
{
  const char * sLang;        // lang Id from Harbour 
  void * pFuncLang;          // pointer to function to load messages
  long lTotalMsgs;           // total messages
} G_LANG, * PG_LANG;

void BuildErrMsg( G_ERRMSG *ErrMsg, int iSize );


short g_errRT_BASE(  HB_ERRCODE errGenCode, HB_ERRCODE errSubCode, const char * szOperation, HB_ULONG ulArgCount );
