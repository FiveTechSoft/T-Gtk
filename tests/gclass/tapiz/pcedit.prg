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
    (c)2007 Federico de Maussion <fj_demaussion@yahoo.com.ar>
*/
#include "hbclass.ch"
#include "gclass.ch"
#include "pc-soft.ch"

// --------------------------------------------------------------------------------------- //

CLASS gPcEdit
   DATA oWnd, lEnable
   DATA oBox, oBox1, oBox2, oBox3, oBox4
   DATA oTable, oScroll
   DATA lAcepta
   DATA aReg
   DATA nLenGet
   DATA aGet, oBtn
   DATA bAction, bInit
   DATA lImage, lBoton, lFix


   METHOD New( oParent, cTitle, oIcon, nWidth, nHeight )
   METHOD aCantGet(  )
   METHOD Active( )
   METHOD End( )
   METHOD Enable()  INLINE (aEval( ::aGet, { |o,y| o:Enable() } ),aEval( ::oBtn, { |o,y| o:Enable() } ), ::lEnable := .t.)
   METHOD Disable() INLINE (aEval( ::aGet, { |o,y| o:Disable() } ),aEval( ::oBtn, { |o,y| o:Disable() } ) , ::lEnable := .f.)
   METHOD Refresh() INLINE aEval( ::aGet, { |o,y| o:Refresh() } )
   METHOD nLen(n) INLINE ::nLenGet := n
   METHOD UpdateBuffer( )

END CLASS

// --------------------------------------------------------------------------------------- //

METHOD New( oParent, cTitle, oIcon, nWidth, nHeight, oDepende ) CLASS gPcEdit
   Local oImage

   ::aReg  := {}
   ::oBtn  := {,}
   ::lFix := .t.
   ::lAcepta := .f.
   ::lEnable := .t.
   ::lImage := .t.
   ::lBoton := .t.

   DEFAULT  nWidth := 0 , nHeight := 0

   if oParent == Nil
     if nWidth == 0 .Or. nHeight == 0
        DEFINE WINDOW ::oWnd TITLE cTitle
        ::lFix := .t.
     else
        DEFINE WINDOW ::oWnd SIZE nWidth, nHeight TITLE cTitle
        ::lFix := .f.
     end

     if oDepende != Nil
       gtk_window_set_transient_for( ::oWnd:pWidget, oDepende:pWidget )  
     end

     gtk_window_set_icon(::oWnd:pWidget, oIcon)

      DEFINE BOX ::oBox OF ::oWnd SPACING 8
   else
     ::oBox := oParent
   end


RETURN Self

// --------------------------------------------------------------------------------------- //

METHOD Active( bAction, bInit ) CLASS gPcEdit
   Local x, i, oBox
   Local x2 := 1, oImage
   ::aGet := Array(::aCantGet())
   ::bAction := bAction
   ::bInit   := bInit

   if ::lImage
     //if ::oWnd == Nil
     //  DEFINE SEPARATOR OF ::oBox VERTICAL PADDING 15 //EXPAND FILL
     //end
     ::oBox:SetBorder( 5 )
     DEFINE IMAGE oImage FILE "pixmaps/logo3.png" OF ::oBox
     DEFINE SEPARATOR OF ::oBox VERTICAL PADDING 15 //EXPAND FILL
   end

   DEFINE BOX ::oBox1 OF ::oBox VERTICAL EXPAND FILL //SPACING 8
   ::oBox1:SetBorder( 5 )

     // Vamos a usar una tabla
   if !::lFix
     DEFINE BOX ::oBox2 OF ::oBox1 EXPAND FILL

     DEFINE SCROLLEDWINDOW ::oScroll OF ::oBox2 EXPAND FILL ;
            SHADOW GTK_SHADOW_ETCHED_IN

     ::oScroll:SetPolicy( GTK_POLICY_AUTOMATIC, GTK_POLICY_ALWAYS )
     gtk_box_pack_start( ::oBox2:pWidget, ::oScroll:pWidget, TRUE, TRUE, 0 )

     DEFINE BOX ::oBox4 OF ::oScroll EXPAND FILL
     DEFINE TABLE ::oTable ROWS Len(::aReg) COLS 2 OF ::oBox4
     //gtk_table_set_row_spacings( ::oTable:pWidget, 10 )
     gtk_table_set_col_spacings( ::oBox4:pWidget, 5 )
     gtk_scrolled_window_add_with_viewport( ::oScroll:pWidget, ::oBox4:pWidget )
   else
       DEFINE TABLE ::oTable ROWS Len(::aReg) COLS 2 OF ::oBox1
   endif
     for x=1 to Len(::aReg)

      If ::aReg[x,1] != "Say" .And. ::aReg[x,1] != "ContainerGet" .And. ::aReg[x,2,1] != Nil
         DEFINE LABEL PROMPT utf(::aReg[x,2,1]) OF ::oTable TABLEATTACH 0,1,x-1,x //HALIGN GTK_LEFT
      end
      if ::aReg[x,1] == "Say"
        DEFINE LABEL ::aGet[x2] PROMPT utf(::aReg[x,2,2]) OF ::oTable TABLEATTACH 0,2,x-1,x //HALIGN GTK_LEFT
      elseif ::aReg[x,1] == "Get"
        ::aGet[x2] := PC_Get():New(::aReg[x,2,2],::aReg[x,2,3],,::aReg[x,2,4],,,::oTable,;
        .t.,.t.,,.F.,,,,,, .F.,.F.,.F.,.F.,.F.,1,2,x-1,x,,)
      elseif ::aReg[x,1] == "Entry"
        ::aGet[x2] := GEntry():New(::aReg[x,2,2],::aReg[x,2,3],::aReg[x,2,4],::aReg[x,2,5],,::oTable,;
        .T.,.T.,,.F.,,,,,,.F.,.F.,.F.,.F.,.F.,1,2,x-1,x,,)
      elseif ::aReg[x,1] == "Combo"
        ::aGet[x2] := GComboBox():New(::aReg[x,2,2],::aReg[x,2,3],::aReg[x,2,4],,,::oTable,;
        .T.,.T.,,.F.,,,,,,,,.F.,.F.,.F.,.F.,1,2,x-1,x,,)
      elseif ::aReg[x,1] == "Button"
         ::aGet[x2] := GButton():New(::aReg[x,2,2],::aReg[x,2,3],::aReg[x,2,4] ,,.F.,,::oTable,.T.;
          ,.T.,,.F.,,,,,,,,,,,.F.,.F.,.F.,.F.,1,2,x-1,x,,,,)
      elseif ::aReg[x,1] == "ContainerGet"
        If ::aReg[x,2,1,2] != Nil
          DEFINE LABEL PROMPT ::aReg[x,2,1,2] OF ::oTable TABLEATTACH 0,1,x-1,x //HALIGN LEFT
        end
        DEFINE BOX oBox OF ::oTable TABLEATTACH 1,2,x-1,x
        for i=1 to Len(::aReg[x,2])
          If i > 1
            If ::aReg[x,2,i,2] != Nil
              DEFINE LABEL PROMPT utf(::aReg[x,2,i,2]) OF oBox
            end
          end
          if ::aReg[x,2,i,1] == "Say"
              DEFINE LABEL PROMPT utf(::aReg[x,2,i,2]) OF oBox
          elseif ::aReg[x,2,i,1] == "Get"
            ::aGet[x2] := PC_Get():New(::aReg[x,2,i,3],::aReg[x,2,i,4],,::aReg[x,2,i,5],,,oBox,;
            .t.,.t.,,.F.,,,,,, .F.,.F.,.F.,.F.,.F.,1,2,x-1,x,,)
          elseif ::aReg[x,2,i,1] == "Entry"
            ::aGet[x2] := GEntry():New(::aReg[x,2,i,3],::aReg[x,2,i,4],::aReg[x,2,i,5],::aReg[x,2,i,6],,oBox,;
            .T.,.T.,,.F.,,,,,,.F.,.F.,.F.,.F.,.F.,1,2,x-1,x,,)
          elseif ::aReg[x,2,i,1] == "Combo"
            ::aGet[x2] := GComboBox():New(::aReg[x,2,i,3],::aReg[x,2,i,4],::aReg[x,2,i,5],,,oBox,;
            .T.,.T.,,.F.,,,,,,,,.F.,.F.,.F.,.F.,1,2,x-1,x,,)
          elseif ::aReg[x,2,i,1] == "Button"
            ::aGet[x2] := GButton():New(::aReg[x,2,i,3],::aReg[x,2,i,4] ,::aReg[x,2,i,5] ,,.F.,,oBox,.F.,;
                 .F.,,.F.,,,,,,,,,,,.F.,.F.,.F.,.F.,,,,,,,,)
          end
          if !::lEnable
            ::aGet[x2]:Disable()
          end
          x2++
        next
        x2--
      end
      if ::nLenGet != Nil .And. ::aReg[x,1] != "ContainerGet"
        gtk_entry_set_width_chars( ::aGet[1]:pWidget, ::nLenGet )
      End
      if !::lEnable
        ::aGet[x2]:Disable()
      end
     x2++
     next

   if ::bInit != Nil
     Eval(::bInit, Self)
   End
   if ::lBoton
     DEFINE BOX ::oBox3 OF ::oBox1 HOMO SPACING 8
     ::oBox3:SetBorder( 5 )
     if ::oWnd != Nil
       DEFINE BUTTON ::oBtn[2] PROMPT "Aceptar" ACTION ( ::lAcepta := .t., ::End( ) ) ;
          OF ::oBox3 EXPAND FILL
       DEFINE BUTTON ::oBtn[1] PROMPT "Salir"  ACTION ::End( ) OF ::oBox3 EXPAND FILL

       ::oWnd:SetResizable( .f. )
       ACTIVATE WINDOW ::oWnd CENTER
     else
        DEFINE BUTTON ::oBtn[2] PROMPT "Aceptar" ;
          ACTION ( ::lAcepta := .t., ::End( ) ) ;
          OF ::oBox3 EXPAND FILL
        DEFINE BUTTON ::oBtn[1] PROMPT "Salir"  ;
          ACTION ( ::End( ) ) ;
          OF ::oBox3 EXPAND FILL
        ::Disable()
     end
   end
RETURN Self

// ------------------------------------------------------------------------ //

METHOD aCantGet(  ) CLASS gPcEdit
   Local x, i, oBox
   Local x2 := 0

     // Vamos a usar una tabla ;-)
     for x=1 to Len(::aReg)

      if ::aReg[x,1] == "Get"
      elseif ::aReg[x,1] == "Combo"
      elseif ::aReg[x,1] == "Button"
      elseif ::aReg[x,1] == "ContainerGet"
        for i=1 to Len(::aReg[x,2])
          if ::aReg[x,2,i,1] == "Get"
          elseif ::aReg[x,2,i,1] == "Combo"
          elseif ::aReg[x,2,i,1] == "Button"
          endif
            x2++
        next
        x2--
      end
      x2++
     next

RETURN x2

// ------------------------------------------------------------------------ //

METHOD End( ) CLASS gPcEdit

   if ::bAction != Nil
     eval(::bAction)
   end
   if ::oWnd != Nil
     ::oWnd:End()
   end

RETURN nil

// ------------------------------------------------------------------------ //

METHOD UpdateBuffer( ) CLASS gPcEdit
   Local x, ctext

   for x=1 to Len(::aGet)
     if ::aGet[x]:Classname() == "GGET"
       ::aGet[x]:UpdateBuffer( )
     elseif ::aGet[x]:Classname() == "PC_GET"
       ::aGet[x]:Refresh( )
     elseif ::aGet[x]:Classname() == "GCOMBOBOX"
       ctext := eval(::aGet[x]:bSetGet)
       if !Empty(ctext)
         ::aGet[x]:SelectItem( ctext )
       else
         ::aGet[x]:SetActive( 1 )
       end
     else
       //::aGet[x]:SelectItem( eval(::aGet[x]:bSetGet) )
     end
   next

RETURN nil

// ------------------------------------------------------------------------ //

