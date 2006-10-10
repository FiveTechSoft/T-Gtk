/* $Id: tpict.prg,v 1.1 2006-10-10 10:50:13 rosenwla Exp $*/
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
    (c)2003 Rafael Carmona <thefull@wanadoo.es>
*/
#include "hbclass.ch"
#include "gclass.ch"
#include "getexit.ch"

#include "cStruct.ch"
#include "gtkTypes.ch"

#define PICT_NAME			1 // [@] + One char 
#define PICT_TYPE			2 // Type of char A,C,N,D
#define PICT_ALT_TYPE		3 // Type of char A,C,N,D,
#define PICT_DESCRIPT		4 // Full description of functions
#define PICT_STATE			5 // V-Very-high move in top, H-high next position after standart, N-normal last position
#define PICT_BLOCK			6 // A block, Params is [char] from keyboard, [post] in xbuffer, [xbuffer], return mode or is no params -> excute array
#define PICT_CARGO			7 // User define params
#define PICT_MODE			8 // 0-Noremove, 1-Standart, 2-UserDef
#define PICT_COUNT			8

#define PICT_MODE_NOIMPL	0 // Not change the char
#define PICT_MODE_BREAK		1 // Break for next
#define PICT_MODE_STOP		2 // Skip this char
#define PICT_MODE_CHAGE		3 // Change char
#define PICT_MODE_BR_CH		PICT_MODE_BREAK + PICT_MODE_CHAGE

CLASS TPict
	  DATA Pict
	  DATA PictStd 		INIT {;
						{"@A", {|o| o:ParceA()}},;
						{"@B", {|o| o:ParceB()}},;
						{"@C", {|o| o:ParceC()}},;
						{"@D", {|o| o:ParceD()}},;
						{"@E", {|o| o:ParceE()}},;
						{"@K", {|o| o:ParceK()}},;
						{"@R", {|o| o:ParceR()}},;
						{"@S", {|o| o:ParceS()}},;
						{"@X", {|o| o:ParceX()}},;
						{"@Z", {|o| o:ParceZ()}},;
						{"@(", {|o| o:ParceLeft()}},;
						{"@)", {|o| o:ParceRight()}},;
						{"@!", {|o| o:ParceUpper()}},;
						{"A", {|o| o:TemplA()}},;
						{"N", {|o| o:TemplN()}},;
						{"X", {|o| o:TemplX()}},;
						{"9", {|o| o:TemplDig()}},;
						{"#", {|o| o:TemplDigSgSp()}},;
						{"L", {|o| o:TemplL()}},;
						{"Y", {|o| o:TemplYN()}},;
						{"!", {|o| o:TemplUpper()}},;
						{"$", {|o| o:TemplDollar()}},;
						{"*", {|o| o:TemplAsterisk()}},;
						{".", {|o| o:TemplDec()}},;
						{",", {|o| o:TemplComma()}};
						}
	  DATA PictExFunct	INIT {}
	  DATA TemplEx		INIT {}

	  METHOD ParcePict()
	  METHOD ParceValue( xValue, cPict ) INLINE Transform( xValue, cPict )

	  METHOD AddPictFunction( aFunct )
	  METHOD DelPictFunction( cName )
	  METHOD ReplPictFunction( aFunct )
	  
	  METHOD ParceA() VIRTUAL // A, C, Allows only alphabetic characters.
	  METHOD ParceB() VIRTUAL  // B, N, Displays numbers left-justified.
      METHOD ParceC() VIRTUAL  // C, N, Displays CR after positive numbers.
      METHOD ParceD() VIRTUAL  // D, D,N  Displays dates in SET DATE format.
      METHOD ParceE() VIRTUAL  // E, D,N  Displays dates with day and month inverted independent of the current DATE SETting, numerics with comma and period reverse (European style).
      METHOD ParceK() VIRTUAL  // K, ALL  Deletes default text if first key is not a cursor key.
      METHOD ParceR() VIRTUAL  // R, C    Nontemplate characters are inserted in the display but not saved in the variable.
      METHOD ParceS() VIRTUAL  // S<n>, C    Allows horizontal scrolling within a GET.  <n> is an integer that specifies the width of the region.
      METHOD ParceX() VIRTUAL  // X, N    Displays DB after negative numbers.
      METHOD ParceZ() VIRTUAL  // Z, N    Displays zero as blanks.
      METHOD ParceLeft() VIRTUAL // (, N    Displays negative numbers in parentheses with leading spaces.
      METHOD ParceRight() VIRTUAL // ), N    Displays negative numbers in parentheses without leading spaces.
      METHOD ParceUpper() VIRTUAL // !, C    Converts alphabetic character to uppercase.

      METHOD TemplA() VIRTUAL // A, Allows only alphabetic characters
      METHOD TemplN() VIRTUAL // N, Allows only alphabetic and numeric characters
      METHOD TemplX() VIRTUAL // X, Allows any character
      METHOD TemplDig() VIRTUAL // 9, Allows digits for any data type including sign for numerics
      METHOD TemplDigSgSp() VIRTUAL // #, Allows digits, signs and spaces for any data type
      METHOD TemplL() VIRTUAL // L, Allows only T, F, Y or N
      METHOD TemplYN() VIRTUAL // Y, Allows only Y or N
      METHOD TemplUpper() VIRTUAL // !, Converts an alphabetic character to uppercase
      METHOD TemplDollar() VIRTUAL // $, Displays a dollar sign in place of a leading space in a numeric
      METHOD TemplAsterisk() VIRTUAL // *, Displays an asterisk in place of a leading space in a numeric
      METHOD TemplDec() VIRTUAL //., Displays a decimal point
      METHOD TemplComma() VIRTUAL //, Displays a comma
ENDCLASS

METHOD ParcePict( cPict ) CLASS GENTRY
	Local aPict AS ARRAY, aFunct AS ARRAY, cVar
	
	::Pict := cPict
	aPict  := HB_RegexSplit(" ", ::Pict)
	aFunct := HB_RegexSplit(",", aPict[1])
	aEval(aFunct, {|xVar| ::AddPictFunction("@" + StrTran("@", cVar, ""))})
Return

METHOD AddPictFunction( aFunct ) CLASS 
	Local aReturn AS ARRAY, aComp AS ARRAY, aTmp AS ARRAY , nScan := 0, nPos := 0, cTmp
	
	if left(aFunct[PICT_NAME], 1) == "@" // This a function check before add
		cTmp := StrTran("@", aFunct[PICT_NAME], "")
		if ( nScan := aScan(::PictExFunct, {|aComp| Upper(cTmp) == aComp[PICT_NAME]}) ) != 0
			Return ::PictExFunct[nScan]
			
		elseif ( nScan := aScan(::PictStd, {|aComp| Upper(cTmp) == cComp[1]}) ) != 0
			if ISARRAY( aTmp := Eval( ::PictStd[nScan, 2], Self )) // Self This for next time 
				swith aTmp[PICT_STATE]
					case "V"
						nScan := 1
						aSize(::PictExFunct, Len(::PictExFunct) + 1)
						aIns(::PictExFunct, 1)
						::PictExFunct[nScan] := aClone(aTmp)
						exit
						
					case "H"
						nScan := Len(::PictExFunct)
						aEval(::PictExFunct, {|aComp, nPos| iif(aComp[PICT_MODE] == 0 .or. aComp[PICT_MODE] == 1, (nScan := nPos), NIL))						
						aSize(::PictExFunct, Len(::PictExFunct) + 1)
						aIns(::PictExFunct, ++nScan)
						::PictExFunct[nScan] := aClone(aTmp)
						exit
						
					case "N"
						AaDd(::PictExFunct, aClone(aTmp))
						exit
				end
				Return aTail( ::PictExFunct )
			else
				Return NIL
			endif
			
		else			
			Return NIL
		endif
		
	else // This a template
		cTmp := aFunct[PICT_NAME]
		if ( nScan := aScan(::TemplEx, {|aComp| Upper(cTmp) == aComp[PICT_NAME]}) ) != 0
		elseif ( nScan := aScan(::PictStd, {|aComp| Upper(cTmp) == aComp[1]}) ) != 0
			if ISARRAY( aTmp := Eval( ::PictStd[nScan, 2], Self )) // Self This for next time 
				AaDd(::TemplEx, aClone(aTmp))
			else
				Return NIL
			endif
		else
			Return NIL
		endif
		
	endif
	
Return aReturn
