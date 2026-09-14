@echo off
setlocal EnableDelayedExpansion

:: Enable ANSI color formatting
for /F %%a in ('echo prompt $E ^| cmd') do set "ESC=%%a"

set "CLR_RESET=%ESC%[0m"
set "CLR_HEADER=%ESC%[1;36m"
set "CLR_TITLE=%ESC%[1;33m"
set "CLR_OPT=%ESC%[92m"
set "CLR_MUTED=%ESC%[90m"
set "CLR_ERR=%ESC%[1;31m"

set "ROOT=%~dp0"
set "EXE=%ROOT%App\BedrockServerManager.exe"
set "INSTANCES=%ROOT%Instances"
set "DEFAULT=%INSTANCES%\Default"

if not exist "%EXE%" (
    cls
    echo %CLR_ERR%[ERROR] BedrockServerManager.exe not found.%CLR_RESET%
    echo Expected path: "%EXE%"
    echo.
    pause
    exit /b 1
)

if not exist "%DEFAULT%" mkdir "%DEFAULT%"

:MENU
cls
echo  %CLR_HEADER%========================================================%CLR_RESET%
echo  %CLR_TITLE%              BEDROCK SERVER MANAGER%CLR_RESET%
echo  %CLR_HEADER%========================================================%CLR_RESET%
echo.
echo  %CLR_HEADER%Instances:%CLR_RESET%
echo.

set /a COUNT=0

for /d %%D in ("%INSTANCES%\*") do if /i not "%%~nxD"=="Default" (
    set /a COUNT+=1
    set "INSTANCE[!COUNT!]=%%~fD"
    echo     %CLR_OPT%[!COUNT!]%CLR_RESET%  %%~nxD
)

if %COUNT%==0 echo     %CLR_MUTED%(No instances found)%CLR_RESET%

echo.
echo  %CLR_HEADER%--------------------------------------------------------%CLR_RESET%
echo   %CLR_OPT%[D]%CLR_RESET% Default    %CLR_OPT%[N]%CLR_RESET% New    %CLR_OPT%[R]%CLR_RESET% Refresh    %CLR_OPT%[Q]%CLR_RESET% Quit
echo  %CLR_HEADER%--------------------------------------------------------%CLR_RESET%
echo.

set "CHOICE="
set /p "CHOICE=  Select an instance or option %CLR_MUTED%[Default]%CLR_RESET%: "

if not defined CHOICE set "CHOICE=D"

if /i "%CHOICE%"=="Q" exit /b
if /i "%CHOICE%"=="R" goto MENU

if /i "%CHOICE%"=="D" (
    set "SELECTED=%DEFAULT%"
    goto LAUNCH
)

if /i "%CHOICE%"=="N" (
    echo.
    set "NEW_NAME="
    set /p "NEW_NAME=  New instance name: "
    if defined NEW_NAME (
        set "NEW_DIR=%INSTANCES%\!NEW_NAME!"
        if not exist "!NEW_DIR!" (
            mkdir "!NEW_DIR!"
            set "SELECTED=!NEW_DIR!"
            goto LAUNCH
        ) else (
            echo %CLR_ERR%[ERROR] That instance already exists.%CLR_RESET%
            timeout /t 2 /nobreak >nul
        )
    )
    goto MENU
)

set "VALID="
for /l %%I in (1,1,%COUNT%) do (
    if "%CHOICE%"=="%%I" (
        set "SELECTED=!INSTANCE[%%I]!"
        set "VALID=1"
    )
)

if defined VALID goto LAUNCH

echo %CLR_ERR%[ERROR] Invalid choice. Please try again.%CLR_RESET%
timeout /t 2 /nobreak >nul
goto MENU

:LAUNCH
cls
for %%A in ("%SELECTED%") do set "INSTANCE_NAME=%%~nxA"

echo  %CLR_HEADER%========================================================%CLR_RESET%
echo  %CLR_TITLE%              BEDROCK SERVER MANAGER%CLR_RESET%
echo  %CLR_HEADER%========================================================%CLR_RESET%
echo.
echo   Status   : %CLR_OPT%Launching application...%CLR_RESET%
echo   Instance : %CLR_TITLE%!INSTANCE_NAME!%CLR_RESET%
echo   Path     : %CLR_MUTED%"%SELECTED%"%CLR_RESET%
echo.
echo  %CLR_HEADER%--------------------------------------------------------%CLR_RESET%

set "CONFIG=%SELECTED%\Config\config.ini"

if exist "%CONFIG%" powershell -NoProfile -Command ^
 "$p='%CONFIG%';$c=Get-Content $p -Raw;$c=$c -replace '(?m)^(\s*RootPath=).*$','$1%SELECTED%';$c=$c -replace '(?m)^(\s*(LocalBackupPath|OffsiteBackupPath)=).*$','$1';[IO.File]::WriteAllText($p,$c)"

start "" "%EXE%" -RootPath "%SELECTED%"
timeout /t 1 /nobreak >nul
exit /b