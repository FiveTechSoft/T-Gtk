/*
 * Copyright 2015 - Riztan Gutierrez 
 *
 */

#include "gclass.ch"

#define IMAGES_IN  "imgs_in" + hb_ps()
#define IMAGES_OUT "imgs_out" + hb_ps()

PROCEDURE Main()

   LOCAL oWnd, oBox, oBtn1, oBtn2
   LOCAL oBtn3, oBtn4, oBtn5, oBtn6, oBtn7

   // Check output directory
   IF ! hb_DirExists( IMAGES_OUT )
      DirMake( IMAGES_OUT )
   ENDIF

   DEFINE WINDOW oWnd TITLE "LibGD with t-gtk" ;
          SIZE 300,300

   DEFINE BOX oBox VERTICAL ;
          BORDER 5 HOMO ;
          OF oWnd

   DEFINE BUTTON oBtn1 TEXT "gdAPI"        ;
          ACTION gdAPI()                   ;
          OF oBox

   DEFINE BUTTON oBtn2 TEXT "Animated GIF" ;
          ACTION gdAnimGif()               ;
          OF oBox

   DEFINE BUTTON oBtn3 TEXT "gdClass"      ;
          ACTION gdClass()                 ;
          OF oBox

   DEFINE BUTTON oBtn4 TEXT "Bar Code"     ;
          ACTION BarCode()                 ;
          OF oBox

   DEFINE BUTTON oBtn5 TEXT "Bar Code 2"   ;
          ACTION BarCode2()                ;
          OF oBox

   DEFINE BUTTON oBtn6 TEXT "Anti Aliased" ;
          ACTION AntiAlia()                ;
          OF oBox

   DEFINE BUTTON oBtn7 TEXT "Counter"      ;
          ACTION Counter()                 ;
          OF oBox


   ACTIVATE WINDOW oWnd


   RETURN
