@echo off

set FNAME=%~p1%~n1
set FLAGS=-a -;+ -(+

call :compile ""
call :compile "-O0"
call :compile "-O1"
REM call :compile "-O2"
call :compile "-d0"
call :compile "-d0 -O0"
call :compile "-d0 -O1"
REM call :compile "-d0 -O2"
call :compile "-d1"
call :compile "-d1 -O0"
call :compile "-d1 -O1"
REM call :compile "-d1 -O2"
call :compile "-d2"
call :compile "-d2 -O0"
call :compile "-d2 -O1"
REM call :compile "-d2 -O2"
call :compile "-d3"
call :compile "-d3 -O0"
call :compile "-d3 -O1"
REM call :compile "-d3 -O2"

goto :EOF

:compile
set VFLAGS=%~1
echo pawncc "%FNAME%.pwn" %FLAGS% %VFLAGS% -o"%FNAME% %VFLAGS%"
pawncc "%FNAME%.pwn" %FLAGS% %VFLAGS% -o"%FNAME% %VFLAGS%"
goto :EOF

