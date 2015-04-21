@echo off

REM Strip trailing \
set PATH_BAT=%~dp0
if %PATH_BAT:~-1%==\ set PATH_BAT=%PATH_BAT:~0,-1%

REM ---------------------------------------------------------------------------
REM Setup
REM ---------------------------------------------------------------------------

set BUILD_DIR=%PATH_BAT%\builds
set LUAC="%PATH_BAT%\bin\luac.exe"

set LIBRARY_NAME=PLUGIN_NAME

set ZIP_PATH=%PATH_BAT%\plugin-%LIBRARY_NAME%.zip

REM Clean build
if exist "%BUILD_DIR%" (
	rmdir /s /q "%BUILD_DIR%"
)
if exist "%ZIP_PATH%" (
	del /q "%BUILD_DIR%"
)

REM Create directories
mkdir "%BUILD_DIR%"

REM ---------------------------------------------------------------------------
REM Copy files over.
REM ---------------------------------------------------------------------------

echo [copy]
xcopy /I /S "%PATH_BAT%"\plugins "%BUILD_DIR%\plugins"
copy "%PATH_BAT%\metadata.json" "%BUILD_DIR%\metadata.json"

REM ---------------------------------------------------------------------------
REM Compile lua files.
REM ---------------------------------------------------------------------------

echo.
echo [compile]
%LUAC% -v
For /R "%BUILD_DIR%" %%F in (*.lua) Do (
	echo Compiling %%F
	%LUAC% -s -o "%%F" -- "%%F"
)

REM ---------------------------------------------------------------------------
REM Zip up files.
REM ---------------------------------------------------------------------------

echo.
echo [zip]
pushd %BUILD_DIR%
zip -v -r -p "%ZIP_PATH%" *
popd

REM ---------------------------------------------------------------------------
REM Finish.
REM ---------------------------------------------------------------------------

echo.
echo [complete]
echo Plugin build succeeded.
echo Zip file located at: %ZIP_PATH%
