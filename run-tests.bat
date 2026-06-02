@echo off
REM Run all test projects found under the "test" directory.
REM Targets net10.0 (the SDK pinned in global.json).

setlocal enabledelayedexpansion

set "ROOT=%~dp0"
set "TESTDIR=%ROOT%test"

REM Prefer a user-local .NET 10 SDK if present (system PATH may point at an older SDK).
set "DOTNET_DIR=%USERPROFILE%\.dotnet"
if exist "%DOTNET_DIR%\dotnet.exe" (
    set "PATH=%DOTNET_DIR%;%PATH%"
    set "DOTNET_ROOT=%DOTNET_DIR%"
)
set "DOTNET_CLI_TELEMETRY_OPTOUT=1"

if not exist "%TESTDIR%" (
    echo Test directory not found: "%TESTDIR%"
    exit /b 1
)

set "EXITCODE=0"

for /d %%P in ("%TESTDIR%\*.Tests") do (
    echo.
    echo === Running tests in %%~nxP ===
    REM -p:NuGetAudit=false avoids restore failing on transitive-package advisories (TreatWarningsAsErrors).
    dotnet test "%%P" -f net10.0 -p:NuGetAudit=false
    if errorlevel 1 set "EXITCODE=1"
)

echo.
if "%EXITCODE%"=="0" (
    echo All test projects passed.
) else (
    echo One or more test projects failed.
)

endlocal & exit /b %EXITCODE%
