@echo off
del config\control.log
IF EXIST %2 GOTO YES
echo no > %1\config\control.log
GOTO Fin

:YES
echo yes > %1\config\control.log

:Fin
exit
