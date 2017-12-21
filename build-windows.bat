@rem make sure we are in current directory when "Run as administrator"
@setlocal enableextensions
@cd /d "%~dp0"
@echo off

set VERSION=4.16
set INSTALL_PATH=..\_build

if not "%~1"=="" (
    set VERSION="%~1"
)

if not "%~2"=="" (
    set INSTALL_PATH="%~2"
)

set NAME=recastnavigation-ue4

@REM -----------------------------------------------------------------------
@REM Set Environment Variables for the Visual Studio Command Line
set VS2017DEVCMD=C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\Common7\Tools\VsDevCmd.bat
if exist "%VS2017DEVCMD%" (
    @REM VS2017
    @REM Tell VsDevCmd.bat to set the current directory, in case [USERPROFILE]\source exists. See:
    @REM C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\Common7\Tools\vsdevcmd\core\vsdevcmd_end.bat
    set VSCMD_START_DIR=%CD%
    call "%VS2017DEVCMD%"
) else (
    goto error_no_VS2017
)

pushd %VERSION%

if not exist _intermediate (
    md _intermediate
)
pushd _intermediate

cmake -G "Visual Studio 15 2017 Win64" -DCMAKE_INSTALL_PREFIX=%INSTALL_PATH%  ..\
devenv %NAME%.sln /build "RelWithDebInfo" /project "INSTALL"

@goto end

@REM -----------------------------------------------------------------------
:error_no_VS2017
@echo ERROR: Cannot find Common Tools folder for Visual Studio 2017
@goto end

@REM -----------------------------------------------------------------------
:end

popd @rem pushd _intermediate
popd @rem pushd %VERSION%

