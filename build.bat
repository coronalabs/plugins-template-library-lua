@echo off

:: Strip trailing \
set PATH_BAT=%~dp0
if %PATH_BAT:~-1%==\ set PATH_BAT=%PATH_BAT:~0,-1%

:: ---------------------------------------------------------------------------
:: Validate args
:: ---------------------------------------------------------------------------

if "%1"=="" goto OnShowCommandLineHelp

:: ---------------------------------------------------------------------------
:: Setup
:: ---------------------------------------------------------------------------

set BUILD_NUMBER=%1
set BUILD_DIR=%2
set LIBRARY_NAME="PLUGIN_NAME"


:: Defaults
if "%BUILD_DIR%" == "" (
	set BUILD_DIR=%PATH_BAT%\build
)

:: OUTPUT_DIR
set OUTPUT_DIR=%BUILD_DIR%

:: Clean build
if exist "%OUTPUT_DIR%" (
	del "%OUTPUT_DIR%"
)

:: Plugins
set PLUGIN_TYPE=plugin
set OUTPUT_PLUGINS_DIR=%OUTPUT_DIR%\plugins
set OUTPUT_DIR_LUA=%OUTPUT_PLUGINS_DIR%\%BUILD_NUMBER%\lua
set OUTPUT_DIR_LUA_PLUGIN=%OUTPUT_DIR_LUA%/%PLUGIN_TYPE%

:: Create directories
mkdir "%OUTPUT_DIR%"
mkdir "%OUTPUT_DIR_LUA%"

:: ---------------------------------------------------------------------------
:: Build
:: ---------------------------------------------------------------------------

echo ------------------------------------------------------------------------
echo [lua]
xcopy "%PATH_BAT%"\lua\%PLUGIN_TYPE% "%OUTPUT_DIR_LUA_PLUGIN%" /I /S


echo ------------------------------------------------------------------------
echo [metadata.json]
copy %PATH_BAT%\metadata.json "%OUTPUT_DIR%"


echo ------------------------------------------------------------------------
echo Plugin build succeeded.
echo Build files located at: '%BUILD_DIR%'


goto :eof

:: ---------------------------------------------------------------------------
:: Subroutines
:: ---------------------------------------------------------------------------

:OnShowCommandLineHelp
echo Usage: $0 daily_build_number [dst_dir]
echo.
echo   daily_build_number: The daily build number, e.g. 2015.2560
echo   dst_dir: If not provided, will be '%PATH_BAT%/build'
exit /b 1
