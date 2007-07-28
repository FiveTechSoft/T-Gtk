#define GTK
#ifdef GTK
#include "gclass.ch"
#endif


function main()
local nopt1:=1
cls

do while .t.
#ifdef GTK
Maingtk(@nopt1)
#else
@  7,32,15,47 box replicate(chr(178),8)
@  8,33 prompt "Option 1   "
@  9,33 prompt "Option 2   "
@ 10,33 prompt "Quit       "
menu to nopt1
#endif

do case
case nopt1==1
  fopt1()
case nopt1==2
  fopt2()
case nopt1==3
  quit
endcase
enddo
return .t.


function fopt1()
local nopt2:=1

do while .t.
#ifdef GTK
Gtk2(@nopt2)
#else
cls
@  7,32,15,47 box replicate(chr(178),8)
@  8,33 prompt "Option 1.1  "
@  9,33 prompt "Option 2.2  "
@ 10,33 prompt "Back          "
menu to nopt2
#endif

do case
 case nopt2==1
  #ifdef GTK
  MsgInfo("Hello! First Option")
  #else
  cls
  @ 9,33 say "Hello! First Option"
  inkey(0)
  #endif
 case nopt2==2
  #ifdef GTK
  MsgInfo("Hello! Second Option")
  #else
  cls
  @ 9,33 say "Hello! Second Option"
  inkey(0)
  #endif
 case nopt2==3
  return .t.
endcase
enddo
return .t.

function fopt2()
local nopt3,vbox
vbox := replicate(chr(177),8)

#ifdef GTK
Gtk2(@nopt3)
#else
cls
@  7,32,15,47 box vbox
@  8,33 prompt "Option 1.1       " 
@  9,33 prompt "Option 2.2       " 
@ 10,33 prompt "Back                "
menu to nopt3
#endif

do case
 case nopt3==1
  #ifdef GTK
  MsgInfo("Hello! First Option")
  #else
  cls
  @ 9,33 say "Hello! First Option"
  #endif
 case nopt3==2
  #ifdef GTK
  MsgInfo("Hello! Second Option")
  #else
  cls
  @ 9,33 say "Hello! Second Option"
  #endif
 case nopt3==3
  return .t.
endcase
return .t.