/*
 * Terminal for T-Gtk
 * (C) 2006. Rafa Carmona -TheFull-
*/
#include "hbclass.ch"

CLASS GTERMINAL FROM GWIDGET
    METHOD New()
    METHOD Console() INLINE HB_VTE_CONSOLE_USER( ::pWidget )
    METHOD Transparent( lMode ) INLINE vte_terminal_set_background_transparent( ::pWidget, lMode )
    METHOD Command( cCommand ) INLINE HB_VTE_COMMAND( ::pWidget, cCommand )
    METHOD SetSize( Cols, Rows )
    METHOD SetFont( oFont ) INLINE vte_terminal_set_font( ::pWidget, oFont:pFont )
    
ENDCLASS

METHOD New( cCommand, oFont, oParent, lExpand, lFill, nPadding, lContainer, x, y,;
              uLabelTab, lEnd, lSecond, lResize, lShrink,;
              left_ta,right_ta,top_ta,bottom_ta, xOptions_ta, yOptions_ta ) CLASS GTERMINAL
   
  ::pWidget := vte_terminal_new()
  
  ::AddChild( oParent, lExpand, lFill, nPadding, lContainer, x, y,;
              uLabelTab, lEnd, lSecond, lResize, lShrink,;
              left_ta,right_ta,top_ta,bottom_ta, xOptions_ta, yOptions_ta  )

  ::Show()
  
  if cCommand != NIL 
     ::Command( cCommand )
  endif
  
  if oFont != NIL
    ::SetFont( oFont )
  endif
    
RETURN Self

METHOD SetSize( cols, rows ) CLASS GTERMINAL
   vte_terminal_set_size( ::pWidget, cols, rows )
RETURN NIL
        
