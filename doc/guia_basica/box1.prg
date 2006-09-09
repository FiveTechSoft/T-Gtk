/* Guia basica de T-Gtk
   (c)2004-06 Rafa Carmona*/

#include "gclass.ch"

Function Main()
   Local oWnd, oBtn, oBox, oBoxWnd

   DEFINE WINDOW oWnd TITLE "Box example"
    oWnd:SetBorder( 10 ) 
 
     DEFINE BOX oBoxWnd OF oWnd VERTICAL 
       DEFINE LABEL TEXT "gtk_hbox_new(FALSE,0);" OF oBoxWnd HALIGN LEFT

       DEFINE BOX oBox OF oBoxWnd
          DEFINE BUTTON TEXT "gtk_box_pack" OF oBox
          DEFINE BUTTON TEXT "(box," OF oBox
          DEFINE BUTTON TEXT "button," OF oBox
          DEFINE BUTTON TEXT "FALSE," OF oBox
          DEFINE BUTTON TEXT "FALSE," OF oBox
          DEFINE BUTTON TEXT "0);" OF oBox

       DEFINE BOX oBox OF oBoxWnd
          DEFINE BUTTON TEXT "gtk_box_pack" OF oBox EXPAND
          DEFINE BUTTON TEXT "(box," OF oBox EXPAND
          DEFINE BUTTON TEXT "button," OF oBox EXPAND
          DEFINE BUTTON TEXT "TRUE," OF oBox EXPAND
          DEFINE BUTTON TEXT "FALSE," OF oBox EXPAND
          DEFINE BUTTON TEXT "0);" OF oBox EXPAND

       DEFINE BOX oBox OF oBoxWnd
          DEFINE BUTTON TEXT "gtk_box_pack" OF oBox EXPAND FILL
          DEFINE BUTTON TEXT "(box," OF oBox EXPAND FILL
          DEFINE BUTTON TEXT "button," OF oBox EXPAND FILL
          DEFINE BUTTON TEXT "TRUE," OF oBox EXPAND FILL
          DEFINE BUTTON TEXT "TRUE," OF oBox EXPAND FILL
          DEFINE BUTTON TEXT "0);" OF oBox EXPAND FILL

       DEFINE SEPARATOR OF oBoxWnd PADDING 5

       DEFINE LABEL TEXT "gtk_hbox_new(TRUE,0);" OF oBoxWnd HALIGN LEFT
       DEFINE BOX oBox OF oBoxWnd HOMO
          DEFINE BUTTON TEXT "gtk_box_pack" OF oBox EXPAND
          DEFINE BUTTON TEXT "(box," OF oBox EXPAND
          DEFINE BUTTON TEXT "button," OF oBox EXPAND
          DEFINE BUTTON TEXT "TRUE," OF oBox EXPAND
          DEFINE BUTTON TEXT "FALSE," OF oBox EXPAND
          DEFINE BUTTON TEXT "0);" OF oBox EXPAND

       DEFINE BOX oBox OF oBoxWnd HOMO 
          DEFINE BUTTON TEXT "gtk_box_pack" OF oBox EXPAND FILL
          DEFINE BUTTON TEXT "(box," OF oBox EXPAND FILL
          DEFINE BUTTON TEXT "button," OF oBox EXPAND FILL
          DEFINE BUTTON TEXT "TRUE," OF oBox EXPAND FILL
          DEFINE BUTTON TEXT "TRUE," OF oBox EXPAND FILL
          DEFINE BUTTON TEXT "0);" OF oBox EXPAND FILL

       DEFINE SEPARATOR OF oBoxWnd PADDING 5

    ACTIVATE WINDOW oWnd

Return NIL
