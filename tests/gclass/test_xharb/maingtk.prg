#include "gclass.ch"

function Maingtk()
local oWin1,oBox, oLabel1, oBar, oBoxWnd, oTable, oBtn1, oBtn2, oBtn3
MEMVAR aWin,oFont1,oFont2
aWin:={}

DEFINE FONT oFont1 Name "Arial 14"
DEFINE FONT oFont2 Name "Arial bold 18"

DEFINE WINDOW oWin1 TITLE "Programm"
aadd(aWin,oWin1)

	DEFINE BOX oBox VERTICAL OF oWin1

        DEFINE LABEL oLabel1 PROMPT " Main screen"  FONT oFont2 OF oBox

	DEFINE STATUSBAR oBar OF oBox TEXT "Main screen" INSERT_END

	DEFINE BOX oBoxWnd OF oBox VERTICAL SPACING 2
		oBoxWnd: SetBorder( 120 )
	
 	DEFINE TABLE oTable ROWS 7 COLS 3 HOMO OF oBoxWnd

        DEFINE BUTTON oBtn1 OF oTable TABLEATTACH 1,2,0,1 EXPAND FILL ;
		ACTION ( fopt1() ) ;
		BAR oBar MSG "prog fopt1" ;
		TEXT "_Option 1" ;
		FONT oFont1 ;
		MNEMONIC

        DEFINE BUTTON oBtn2 OF oTable TABLEATTACH 1,2,1,2 EXPAND FILL ;
		ACTION ( fopt2() ) ;
		BAR oBar MSG "prog fopt2" ;
		TEXT "_Option 2" ;
		FONT oFont1 ;
		MNEMONIC

        DEFINE BUTTON oBtn3 OF oTable TABLEATTACH 1,2,2,3 EXPAND FILL ;
		ACTION ( oWin1:End() )  ;
		BAR oBar MSG "prog fopt3" ;
		TEXT "_Quit" ;
		FONT oFont1 ;
		MNEMONIC 

ACTIVATE WINDOW oWin1 MAXIMIZED MODAL

RETURN .t.


function Gtk2()
LOCAL oWin2,oBox, oLabel1, oBar, oBoxWnd, oTable, oBtn1, oBtn2, oBtn3
MEMVAR aWin,oFont1,oFont2

fWinHide()

DEFINE WINDOW oWin2 TITLE "Programm"
aadd(aWin,oWin2)

	DEFINE BOX oBox VERTICAL OF oWin2

        DEFINE LABEL oLabel1 PROMPT " Second screen"  FONT oFont2 OF oBox

	DEFINE STATUSBAR oBar OF oBox TEXT "Second screen" INSERT_END

	DEFINE BOX oBoxWnd OF oBox VERTICAL SPACING 2
		oBoxWnd: SetBorder( 120 )
	
 	DEFINE TABLE oTable ROWS 7 COLS 3 HOMO OF oBoxWnd

        DEFINE BUTTON oBtn1 OF oTable TABLEATTACH 1,2,0,1 EXPAND FILL ;
		ACTION   MsgInfo("Hello! First Option") ;
		BAR oBar MSG "prog fopt1" ;
		TEXT "_Option 1.1" ;
		FONT oFont1 ;
		MNEMONIC

        DEFINE BUTTON oBtn2 OF oTable TABLEATTACH 1,2,1,2 EXPAND FILL ;
		ACTION   MsgBox("Do you really want option 2?") ;
		BAR oBar MSG "prog fopt2" ;
		TEXT "_Option 1.2" ;
		FONT oFont1 ;
		MNEMONIC

        DEFINE BUTTON oBtn3 OF oTable TABLEATTACH 1,2,2,3 EXPAND FILL ;
		ACTION fWinClose()  ;
		BAR oBar MSG "prog fopt3" ;
		TEXT "_Back" ;
		FONT oFont1 ;
		MNEMONIC

ACTIVATE WINDOW oWin2 MAXIMIZED MODAL

RETURN .t.

function Gtk3()
local oWin3, oBox, oLabel1, oBar, oBoxWnd, oTable, oBtn1, oBtn2, oBtn3
memvar aWin, oFont1,oFont2

fWinhide()

DEFINE WINDOW oWin3 TITLE "Programm"
aadd(aWin,oWin3)

	DEFINE BOX oBox VERTICAL OF oWin3

        DEFINE LABEL oLabel1 PROMPT " Tercer screen"  FONT oFont2 OF oBox

	DEFINE STATUSBAR oBar OF oBox TEXT "Tercer screen" INSERT_END

	DEFINE BOX oBoxWnd OF oBox VERTICAL SPACING 2
		oBoxWnd: SetBorder( 120 )
	
 	DEFINE TABLE oTable ROWS 7 COLS 3 HOMO OF oBoxWnd

        DEFINE BUTTON oBtn1 OF oTable TABLEATTACH 1,2,0,1 EXPAND FILL ;
		ACTION   MsgInfo("Hello! First Option of 3") ;
		BAR oBar MSG "prog fopt1" ;
		TEXT "_Option 1.1" ;
		FONT oFont1 ;
		MNEMONIC

        DEFINE BUTTON oBtn2 OF oTable TABLEATTACH 1,2,1,2 EXPAND FILL ;
		ACTION   MsgBox("Do you really want option 3?") ;
		BAR oBar MSG "prog fopt2" ;
		TEXT "_Option 1.2" ;
		FONT oFont1 ;
		MNEMONIC

        DEFINE BUTTON oBtn3 OF oTable TABLEATTACH 1,2,2,3 EXPAND FILL ;
		ACTION fWinClose()  ;
		BAR oBar MSG "prog fopt3" ;
		TEXT "_Back" ;
		FONT oFont1 ;
		MNEMONIC 

ACTIVATE WINDOW oWin3 MAXIMIZED MODAL

RETURN .t.


function fWinclose()
local nn1
memvar aWin

nn1:=len(aWin)
aWin[nn1-1]:Show()
aWin[nn1]:End()
Adel(aWin,nn1,.t.)
aWin[nn1-1]:SetSkipTaskbar(.f.)
aWin[nn1-1]:SetFocus()
return .t.


function fWinhide()
local nn1
memvar aWin
nn1:=len(aWin)
aWin[nn1]:SetSkipTaskbar(.t.)
return .t.


function showmsg(ctext)
local nopt

nopt:=MsgBox( ctext, GTK_MSGBOX_OK+GTK_MSGBOX_CANCEL , GTK_MSGBOX_QUESTION )

if nopt ==1
  MsgInfo("Hello! Second Option of 3")
endif

return .t.