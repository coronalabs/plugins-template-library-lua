@echo off

:: ---------------------------------------------------------------------------
:: Validate args
:: ---------------------------------------------------------------------------

if "%1"=="" goto OnShowCommandLineHelp
if "%2"=="" goto OnShowCommandLineHelp

:: ---------------------------------------------------------------------------
:: Create Project
:: ---------------------------------------------------------------------------

:: Strip trailing \
set src=%~dp0
if %src:~-1%==\ set src=%src:~0,-1%

:: [Strip off double quotes with ~]
set dst=%~1

set name=%2

if exist "%dst%" (
	goto OnDstExistsError
) else (
	mkdir "%dst%"
	if NOT exist "%dst%" (
		goto OnDstExistsError
	)
)

echo New project will be created in (%dst%) for plugin (%name%)...
echo Using template files (%src%)

:: [Copy into new project folder]
echo xcopy "%src%" "%dst%" /I /S
xcopy "%src%" "%dst%" /I /S /EXCLUDE:.bat_ignore

:: [Rename directories]
:: [TODO: Dynamically find files to rename, instead of this static list]
move "%dst%\lua\kernel\composite\PLUGIN_NAME" "%dst%\lua\kernel\composite\%name%"
move "%dst%\lua\kernel\filter\PLUGIN_NAME" "%dst%\lua\kernel\filter\%name%"
move "%dst%\lua\kernel\generator\PLUGIN_NAME" "%dst%\lua\kernel\generator\%name%"

call :FindReplace PLUGIN_NAME %name% "%dst%"

:: [Find/Replace string]
:: for /r "%dst%" %%A in (*) do (
:: 	echo Creating "%%A"
:: 	call :FindReplace PLUGIN_NAME %name% "%%A"
:: )

echo Done!
goto :eof

:: ---------------------------------------------------------------------------
:: Subroutines
:: ---------------------------------------------------------------------------

:OnShowCommandLineHelp
echo Usage: %0 newProjectDir pluginName
exit /b 1

:OnDstExistsError
echo ERROR: %dst% already exists
exit /b 1

:: FindReplace <findstr> <replstr> <srcDir>
:FindReplace
set searchStr=%1
set replaceStr=%2
set srcDir=%~3

set tmpfile=%srcfile%-tmp

:: echo Using: %srcDir% %tmpfile%
:: echo "%searchStr%" "%replaceStr%"

:: Create helper for FindReplace
set vbsfile=%dst%\_.vbs
call :MakeReplace "%vbsfile%"

for /f "tokens=*" %%a in ('dir "%srcDir%" /s /b /a-d /on') do (
  for /f "usebackq" %%b in (`Findstr /mic:"%~1" "%%a"`) do (
    echo(&Echo Replacing "%~1" with "%~2" in file %%~nxa
    <%%a cscript //nologo %vbsfile% "%~1" "%~2" > "%tmpfile%"
    if exist "%tmpfile%" move /Y "%tmpfile%" "%%~dpnxa">nul
  )
)

:: Cleanup
del "%vbsfile%"

goto :eof


:MakeReplace
set var=%~1
>"%var%" echo with Wscript
>>"%var%" echo set args=.arguments
>>"%var%" echo .StdOut.Write _
>>"%var%" echo Replace(.StdIn.ReadAll,args(0),args(1),1,-1,1)
>>"%var%" echo end with
goto :eof
