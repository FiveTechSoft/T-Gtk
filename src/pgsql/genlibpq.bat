@echo off
echo Generando libqp.a
dlltool -d libpqdll.def -D libpq.dll -k -l libpq.a -S as.exe
IF %ERRORLEVEL%==0 GOTO END
Echo Ocurrio un Error
:END
