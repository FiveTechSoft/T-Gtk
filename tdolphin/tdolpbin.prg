/*
 * TDOLPHIN PROJECT source code:
 * Manager MySql prepared statement
 *
 * Copyright 2011 Daniel Garcia-Gil<danielgarciagil@gmail.com>
 * www - http://tdolphin.blogspot.com/
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2, or (at your option)
 * any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this software.  If not, write to
 * the Free Software Foundation, Inc., 59 Temple Place, Suite 330,
 * Boston, MA 02111-1307 USA (or visit the web site http://www.gnu.org/).
 *
 * As a special exception, the tdolphin Project gives permission for
 * additional uses of the text contained in its release of tdolphin.
 *
 * The exception is that, if you link the tdolphin libraries with other
 * files to produce an executable, this does not by itself cause the
 * resulting executable to be covered by the GNU General Public License.
 * Your use of that executable is in no way restricted on account of
 * linking the tdolphin library code into it.
 *
 * This exception does not however invalidate any other reasons why
 * the executable file might be covered by the GNU General Public License.
 *
 * This exception applies only to the code released by the tdolphin
 * Project under the name tdolphin.  If you copy code from other
 * tdolphin Project or Free Software Foundation releases into a copy of
 * tdolphin, as the General Public License permits, the exception does
 * not apply to the code that you add in this way.  To avoid misleading
 * anyone as to the status of such modified files, you must delete
 * this exception notice from them.
 *
 * If you write modifications of your own for tdolphin, it is your choice
 * whether to permit this exception to apply to your modifications.
 * If you do not wish that, delete this exception notice.
 *
 */
 
#include "hbclass.ch"
#include "common.ch"
#include "dbstruct.ch"
#include "tdolphin.ch"
#include "dolerr.ch"


CLASS TDolphinBind
  
  DATA hDatas 
  DATA hBind

  METHOD New()
  METHOD AddData( cName, uValue )
  METHOD BuildBind()

  METHOD GetValue( cName )
  
  METHOD SetProperty( cName, nType, uValue )
  METHOD SetValue( cName, cValue )
  
  ERROR HANDLER ONERROR()    
  

ENDCLASS

//------------------------------------------------//


METHOD New() CLASS TDolphinBind

 ::hDatas = hb_HASH()
  
return Self

//------------------------------------------------//


METHOD AddData( cName ) CLASS TDolphinBind
  
  cName := Upper( cName )
  
  if ! hb_HHasKey( ::hDatas, cName )
     hb_HSet( ::hDatas, cName, NIL )
  endif
  
  ::hDatas[ cName ] = ItemNew( 0 )
  
return nil

//------------------------------------------------//

METHOD BuildBind() CLASS TDolphinBind

   local nLen := Len( ::hDatas )
   
   ::hBind = NewBind( nLen )

return nil

//------------------------------------------------//

METHOD GetValue( cName ) CLASS TDolphinBind

   local uValue
   local nPos := hb_HPOS( ::hDatas, Upper( cName ) )
   
   uValue = GetBind( @::hBind, nPos )
   
return uValue

//------------------------------------------------//

METHOD SetProperty( cName, nType, uValue ) CLASS TDolphinBind

   local nPos 
   
   cName = Upper( cName ) 
   nPos := hb_HPOS( ::hDatas, cName )
   
   setbind( @::hBind, nPos, @::hDatas[ cName ], nType, uValue ) 

return nil


//------------------------------------------------//

METHOD SetValue( cName, uValue ) CLASS TDolphinBind

   SetValue( @::hDatas[ cName ], uValue )   

return uValue

//------------------------------------------------//

METHOD ONERROR( uParam1 ) CLASS TDolphinBind
   local cCol    := Upper( __GetMessage() )
   local uRet
   
   if Left( cCol, 1 ) == "_"
      cCol = Right( cCol, Len( cCol ) - 1 )
   endif
   
   if ! hb_HHasKey( ::hDatas, cCol )
      ::AddData( cCol )
   endif
   
   if uParam1 == nil
      uRet = ::GetValue( cCol )
   else
      uRet = ::SetValue( cCol, uParam1 )
   endif
   
RETURN uRet

