@rem make sure we are in current directory when "Run as administrator"
@setlocal enableextensions
@cd /d "%~dp0"
@echo off

@REM 
@REM Please make sure the following environment variables are set before calling this script:
@REM RECASTNAVIGATION_UE4_VERSION - Release version string.
@REM RECASTNAVIGATION_UE4_PREFIX  - Absolute install path prefix string.
@REM 

@if "%RECASTNAVIGATION_UE4_VERSION%"=="" (
    echo RECASTNAVIGATION_UE4_VERSION is not set, exit.
    exit /b 1
) else (
    echo RECASTNAVIGATION_UE4_VERSION: %RECASTNAVIGATION_UE4_VERSION%
)

@if "%RECASTNAVIGATION_UE4_PREFIX%"=="" (
    echo RECASTNAVIGATION_UE4_PREFIX is not set, exit.
    exit /b 1
) else (
    echo RECASTNAVIGATION_UE4_PREFIX: %RECASTNAVIGATION_UE4_PREFIX%
)

@if not exist %RECASTNAVIGATION_UE4_VERSION% (
    echo Can not find version %RECASTNAVIGATION_UE4_VERSION%, exit.
    exit /b 2
)

set SOLUTION_NAME=recastnavigation-ue4.sln

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

pushd %RECASTNAVIGATION_UE4_VERSION%

if not exist _intermediate (
    md _intermediate
)
pushd _intermediate

cmake -G "Visual Studio 15 2017 Win64" -DCMAKE_INSTALL_PREFIX=%RECASTNAVIGATION_UE4_PREFIX%  ..\

devenv %SOLUTION_NAME% /build "Debug" /project "INSTALL"
devenv %SOLUTION_NAME% /build "RelWithDebInfo" /project "INSTALL"

@goto end

@REM -----------------------------------------------------------------------
:error_no_VS2017
@echo ERROR: Cannot find Common Tools folder for Visual Studio 2017
@goto end

@REM -----------------------------------------------------------------------
:end

popd @rem pushd _intermediate
popd @rem pushd %RECASTNAVIGATION_UE4_VERSION%

