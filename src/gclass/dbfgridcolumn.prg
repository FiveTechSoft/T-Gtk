/* $Id: dbfgridcolumn.prg,v 1.1 2006-09-07 17:07:55 xthefull Exp $*/
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
    (c)2005 Joaquim Ferrer Godoy <quim_ferrer@yahoo.es>
*/
#include "gtkapi.ch"
#include "hbclass.ch"

CLASS DbfGridColumn

   DATA   cHeading  
   DATA   cfgColor, cbgColor 
   DATA   cBmpFile
   DATA   uData 
   DATA   nHeadWidth, nWidth  
   DATA   nColType    AS NUMERIC INIT 0  
   DATA   lDrawSelect AS LOGICAL INIT .T.
   
   METHOD New( cHeading, uData, nWidth, cfgColor, cbgColor, nColType )

ENDCLASS

METHOD New( cHeading, uData, nWidth, cfgColor, cbgColor, nColType, cBmpFile ) CLASS DbfGridColumn

   DEFAULT nWidth   := 20
   DEFAULT cfgColor := "black"
   DEFAULT cbgColor := "white"
   DEFAULT nColType := 0 

   ::nHeadWidth := len( cHeading ) *10
   ::cHeading   := cHeading
   ::uData      := uData
   ::nWidth     := nWidth
   ::cfgColor   := cfgColor
   ::cbgColor   := cbgColor
   ::nColType   := nColType
   
   if cBmpFile != NIL
      ::cBmpFile = cBmpFile
   endif

return Self
