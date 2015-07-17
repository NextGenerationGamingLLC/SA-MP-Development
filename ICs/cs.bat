@echo OFF

rem Get the target compiler - defaults to just swapping with no parameter
if "%1"=="" (
	if exist "newpawncc.exe" (
		set TO="new"
	) else (
		set TO="old"
	)
) else (
	set TO="%~1"
)

rem Get the current compiler version
if %TO%=="new" (
	set FROM=old
) else (
	set FROM=new
)

rem Check that we are going in a legitimate direction
if exist "%FROM%pawncc.exe" (
	goto :eof
)

call :switch_all %FROM% %TO%

goto :eof

:switch_all
	call :switch_one %1 %2 "pawncc.exe"
	call :switch_one %1 %2 "pawnc.dll"
	call :switch_one %1 %2 "libpawnc.dll"
	call :switch_one %1 %2 "pawnc.pdb"
	call :switch_one %1 %2 "pawncc.pdb"
	goto :eof

:switch_one
	if exist "%~3" (
		ren "%~3" "%~1%~3"
	)
	if exist "%~2%~3" (
		ren "%~2%~3" "%~3"
	)
	goto :eof

