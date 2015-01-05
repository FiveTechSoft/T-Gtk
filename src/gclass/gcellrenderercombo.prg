/* $Id: gcellrenderercombo.prg,v 1.1 2014-12-21 03:41:45 riztan Exp $*/
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
#include "gtkapi.ch"
#include "hbclass.ch"

CLASS gCellRendererCombo FROM gCellRendererText
      DATA bEdited
      DATA oModel
      METHOD New( oComboModel, nTextCol )
      METHOD SetModel(oModel)   INLINE g_object_set( ::pWidget, "model", oModel:pWidget)
      METHOD IsEntry(lEntry)    INLINE g_object_set( ::pWidget, "has-entry", lEntry)
      METHOD TextColumn(nColumn) INLINE g_object_set( ::pWidget, "text_column", nColumn - COL_INIT )
ENDCLASS

METHOD New( oComboModel, nTextCol ) CLASS gCellRendererCombo
    ::pWidget := gtk_cell_renderer_combo_new() 
    ::cType   := "text"
    if hb_IsObject( oComboModel )
       if nTextCol = NIL ; ::TextColumn( 1 ) ; endif
       ::oModel := oComboModel
       ::SetModel( ::oModel )
       ::SetEditable( .t. )
       ::Connect( "edited" )
       ::IsEntry(.t.)
    endif
RETURN Self



