/* $Id: gaboutdialog.prg,v 1.1 2006-09-22 19:43:53 xthefull Exp $*/
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
    (c)2006 Rafael Carmona <thefull@wanadoo.es>
*/
#include "gtkapi.ch"
#include "hbclass.ch"

CLASS GAboutDialog FROM GDIALOG

      METHOD New( )
      METHOD SetName( cName )       INLINE gtk_about_dialog_set_name( ::pWidget, cName )
      METHOD GetName()              INLINE gtk_about_dialog_get_name( ::pWidget )
      METHOD SetVersion( cVersion ) INLINE gtk_about_dialog_set_version( ::pWidget, cVersion )
      METHOD GetVersion()           INLINE gtk_about_dialog_get_version( ::pWidget )

ENDCLASS

METHOD NEW( cName, cVersion, lCenter, cId, uGlade ) CLASS GAboutDialog

       if cId == NIL
          ::pWidget := gtk_about_dialog_new()
       else
          ::pWidget := glade_xml_get_widget( uGlade, cId )
          ::CheckGlade( cId )
          ::lGlade := .T.
       endif

       if cName    != NIL  ;  ::SetName( cName )        ;   endif
       if cVersion != NIL  ;  ::SetVersion( cVersion )  ;   endif
      
       // Como en los dialogs, esto es ignorado desde glade...quizas sea un bug( gtk 2.8 win )
       if !::lGlade 
          if lCenter
             ::Center()
          endif
       endif

       ::Show()           
       ::Connect( "destroy" )

RETURN Self
