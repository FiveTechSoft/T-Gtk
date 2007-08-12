/*  $Id: gscrolled.prg,v 1.2 2007-08-12 15:03:54 xthefull Exp $ */
#include "gtkapi.ch"
#include "hbclass.ch"

/*************************************************************
  Protipico de Clase GScrolledWindow
*************************************************************/
CLASS GSCROLLEDWINDOW FROM GBIN

      METHOD New( )
      METHOD SetPolicy( h, v )         INLINE gtk_scrolled_window_set_policy( ::pWidget, h ,v ) 
      METHOD SetShadow( nType )        INLINE gtk_scrolled_window_set_shadow_type( ::pWidget, nType )
      METHOD GetVAdjustment( )         INLINE gtk_scrolled_window_get_vadjustment( ::pWidget )
      METHOD SetVAdjustment( pAdjV )   INLINE gtk_scrolled_window_set_vadjustment( ::pWidget, pAdjV )
      METHOD AddViewPort( oChild )     INLINE gtk_scrolled_window_add_with_viewport (::pWidget, oChild:pWidget )

      //Signals
      METHOD OnMoveFocusOut( oSender, nGtkDirectionType )     VIRTUAL
      METHOD OnScrollChild( oSender, nGtkScrollType , lArg2 ) VIRTUAL

ENDCLASS

METHOD New( oAdjH, oAdjV, oParent, lExpand,lFill, nPadding,;
            lContainer,x,y,cId,uGlade, uLabelTab, nWidth,nHeight, lEnd, lSecond, lResize, lShrink,;
            left_ta, right_ta, top_ta, bottom_ta, xOptions_ta, yOptions_ta, nShadow ) CLASS GSCROLLEDWINDOW
       Local pAdjustV, pAdjustH

       IF cId == NIL
          if !Empty( oAdjH )
             pAdjustH := oAdjH:pWidget
          endif
          if !Empty( oAdjV )
             pAdjustV := oAdjV:pWidget
          endif
          ::pWidget = gtk_scrolled_window_new( pAdjustH, pAdjustV )
       ELSE
          ::pWidget := glade_xml_get_widget( uGlade, cId )
          ::CheckGlade( cId )
       ENDIF

       ::Register()

       ::AddChild( oParent, lExpand, lFill, nPadding, lContainer, x, y, uLabelTab,;
                   lEnd, lSecond, lResize, lShrink, left_ta, right_ta, top_ta, bottom_ta,;
                   xOptions_ta, yOptions_ta )

       if nShadow != NIL
          ::SetShadow( nShadow )
       endif

       if nWidth != NIL
          ::Size( nWidth, nHeight )
       endif

       ::Show()

RETURN Self
