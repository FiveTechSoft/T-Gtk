/*
 * $Id: viewport.prg,v 1.1 2006-09-21 10:05:13 xthefull Exp $
 * Viewport.
 * (C) 2004-05. Rafa Carmona -TheFull-
*/
#include "gclass.ch"

Function Main()
   Local oWnd, oViewPort

   DEFINE WINDOW oWnd TITLE "T-GTK ViewPort"  SIZE 100,100
      DEFINE SCROLLEDWINDOW oScroll OF oWnd CONTAINER
              DEFINE VIEWPORT oViewPort OF oScroll CONTAINER
                 DEFINE IMAGE FILE "../../images/raptor.jpg" OF oViewPort CONTAINER
  
   ACTIVATE WINDOW oWnd CENTER 

Return NIL

