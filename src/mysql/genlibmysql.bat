@echo off
echo Generando libmysql.a
dlltool -d libmysql.def -D libmysql.dll -k -l libmysql.a -S as.exe
IF %ERRORLEVEL%==0 GOTO END
Echo Ocurrio un Error
:END
