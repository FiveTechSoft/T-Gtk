#include "gclass.ch"

function Maingtk(nopt1)
local oFont1, oFont2, oWin1, oBox, oLabel1, oBar, oBoxWnd, oTable, oBtn1, oBtn2, oBtn3
DEFINE FONT oFont1 Name "Arial 14"
DEFINE FONT oFont2 Name "Arial bold 18"

DEFINE WINDOW oWin1 TITLE "Programm"

	DEFINE BOX oBox VERTICAL OF oWin1

        DEFINE LABEL oLabel1 PROMPT " Main screen"  FONT oFont2 OF oBox

	DEFINE STATUSBAR oBar OF oBox TEXT "Main screen" INSERT_END

	DEFINE BOX oBoxWnd OF oBox VERTICAL SPACING 2
		oBoxWnd: SetBorder( 120 )
	
 	DEFINE TABLE oTable ROWS 7 COLS 3 HOMO OF oBoxWnd

        DEFINE BUTTON oBtn1 OF oTable TABLEATTACH 1,2,0,1 EXPAND FILL ;
		ACTION (nopt1:=1, oWin1:End() ) ;
		BAR oBar MSG "prog fopt1" ;
		TEXT "_Option 1" ;
		FONT oFont1 ;
		MNEMONIC

        DEFINE BUTTON oBtn2 OF oTable TABLEATTACH 1,2,1,2 EXPAND FILL ;
		ACTION (nopt1:=2, oWin1:End() )  ;
		BAR oBar MSG "prog fopt2" ;
		TEXT "_Option 2" ;
		FONT oFont1 ;
		MNEMONIC

        DEFINE BUTTON oBtn3 OF oTable TABLEATTACH 1,2,2,3 EXPAND FILL ;
		ACTION (nopt1:=3, oWin1:End() )  ;
		BAR oBar MSG "prog fopt3" ;
		TEXT "_Quit" ;
		FONT oFont1 ;
		MNEMONIC 

ACTIVATE WINDOW oWin1 CENTER MAXIMIZED
RETURN .t.


function Gtk2(nopt2)
local oFont1, oFont2, oWin1, oBox, oLabel1, oBar, oBoxWnd, oTable, oBtn1, oBtn2, oBtn3
DEFINE FONT oFont1 Name "Arial 14"
DEFINE FONT oFont2 Name "Arial bold 18"

DEFINE WINDOW oWin1 TITLE "Programm"

	DEFINE BOX oBox VERTICAL OF oWin1

        DEFINE LABEL oLabel1 PROMPT " Second screen"  FONT oFont2 OF oBox

	DEFINE STATUSBAR oBar OF oBox TEXT "Second screen" INSERT_END

	DEFINE BOX oBoxWnd OF oBox VERTICAL SPACING 2
		oBoxWnd: SetBorder( 120 )
	
 	DEFINE TABLE oTable ROWS 7 COLS 3 HOMO OF oBoxWnd

        DEFINE BUTTON oBtn1 OF oTable TABLEATTACH 1,2,0,1 EXPAND FILL ;
		ACTION (nopt2:=1, oWin1:End() ) ;
		BAR oBar MSG "prog fopt1" ;
		TEXT "_Option 1" ;
		FONT oFont1 ;
		MNEMONIC

        DEFINE BUTTON oBtn2 OF oTable TABLEATTACH 1,2,1,2 EXPAND FILL ;
		ACTION (nopt2:=2, oWin1:End() )  ;
		BAR oBar MSG "prog fopt2" ;
		TEXT "_Option 2" ;
		FONT oFont1 ;
		MNEMONIC

        DEFINE BUTTON oBtn3 OF oTable TABLEATTACH 1,2,2,3 EXPAND FILL ;
		ACTION (nopt2:=3, oWin1:End() )  ;
		BAR oBar MSG "prog fopt3" ;
		TEXT "_Back" ;
		FONT oFont1 ;
		MNEMONIC 

ACTIVATE WINDOW oWin1 CENTER MAXIMIZED
RETURN nopt2
