#define GTK
#ifdef GTK
#include "gclass.ch"
#endif


function main()
local nopt1:=1
cls

#ifdef GTK
Maingtk()
#else
do while .t.
@  7,32,15,47 box replicate(chr(178),8)
@  8,33 prompt "Option 1      "
@  9,33 prompt "Option 2      "
@ 10,33 prompt "Quit          "
menu to nopt1

do case
case nopt1==1
  fopt1()
case nopt1==2
  fopt2()
case nopt1==3
  quit
endcase
enddo
#endif
return .t.


function fopt1()
local nopt2:=1

#ifdef GTK
Gtk2()
#else
do while .t.
cls
@  7,32,15,47 box replicate(chr(178),8)
@  8,33 prompt "Option 1.1    "
@  9,33 prompt "Option 1.2    "
@ 10,33 prompt "Back          "
menu to nopt2

do case
 case nopt2==1
  cls
  @ 9,33 say "Hello! First Option"
  inkey(0)
 case nopt2==2
  cls
  @ 9,33 say "Hello! Second Option"
  inkey(0)
 case nopt2==3
  return .t.
endcase
enddo
#endif
return .t.

function fopt2()
local nopt3,vbox
vbox := replicate(chr(177),8)

#ifdef GTK
Gtk3()
#else
do while .t.
cls
@  7,32,15,47 box vbox
@  8,33 prompt "Option 2.1    "
@  9,33 prompt "Option 2.2    "
@ 10,33 prompt "Back          "
menu to nopt3

do case
 case nopt3==1
  cls
  @ 9,33 say "Hello! First Option"
  inkey(0)
 case nopt3==2
  cls
  @ 9,33 say "Hello! Second Option"
  inkey(0)
 case nopt3==3
  return .t.
endcase
enddo
#endif
return .t.