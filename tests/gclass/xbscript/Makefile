# Make para ejecutar segun el sistema
# -mwindows al enlazar no sale ventana consola.
# pero para depurar, va de muerte que salgan mensajes en la consola

TARGET = testscript

SOURCES = prgscrpt.prg xbscript.prg

#ifndef __XHARBOUR__
  SOURCES = hbrun.prg hbscript.prg 
  
  LIBS +=-lhbextern -lhbdebug -lhbvmmt -lhblang -lhbcpage -lgtcgi -lgtpca -lhbrdd -lrddnsx -lrddcdx -lhbsix -lhbhsx -lhbusrrdd -lhbuddall -lhbrtl -lhbmacro -lhbcplr -lhbpp -lhbcommon

#endif


include ../../../Rules.make


