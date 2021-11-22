echo off
break off
title FoxMic Console
cls
PUSHD "%CD%"
CD /D "%~dp0"
set back=%cd%
goto FoxMicVbsCheck

:FoxMicVbsCheck
type FoxMic.vbs >nul 2>&1
if %errorlevel%==0 (
goto checkadmin
) ELSE (
echo.
echo Creating FoxMic.vbs...
echo.
echo This file is used for UAC Prompting and shortcut access.
echo.
echo FoxMic.vbs is recommended for accessing the foxmic console.
echo.
timeout 5 > nul 
echo Set UAC = CreateObject^("Shell.Application"^) > "%cd%\FoxMic.vbs"
set params = %*:"="
echo UAC.ShellExecute "cmd.exe", "/c %~s0 %params%", "", "runas", 1 >> "%cd%\FoxMic.vbs"
echo.
echo FoxMic.vbs Created.
echo.
echo FoxMic.vbs Moved to FoxMic folder.
echo.
echo Start FoxMic.vbs to continue.
echo.
color 0a
pause
exit
)

:checkadmin
echo.
echo Checking admin privelages...

net session >nul 2>&1
if %errorlevel%==0 (
echo.
echo Success.
goto start
) ELSE (
color 0c
echo.
echo Error: Current Admin privelages inadequate.
echo.
echo Run this batch file as administrator.
echo.
echo Or run FoxMic.vbs
echo.
pause
exit
)

:start
cls
echo Verifying...
PSLIST >nul 2>&1
if %errorlevel%==0 (
echo.
goto main
cls
) ELSE (
goto iq
)

:iq
cls
color 7
echo.
echo.
echo PSLIST program not detected, would you like to install it from microsoft.com?
echo.
echo https://docs.microsoft.com/en-us/sysinternals/downloads/pstools
echo.
echo Files will be placed in System32.
echo.
set /p mchoice=(Y/N): 
if %mchoice%==y goto install
if %mchoice%==n echo FoxMic needs PSTools in order to run... console will close. & timeout 4 > nul & exit
if %mchoice%==y goto install
if %mchoice%==n echo FoxMic needs PSTools in order to run... console will close. & timeout 4 > nul & exit
echo.
color 0c
echo Invalid Selection...
timeout 3 > nul
goto iq

:install
cls
echo.
echo.
echo Installing PSTools...
echo.
echo They will soon be extracted to System32.
echo.
timeout 3 > nul
powershell.exe -executionpolicy bypass -f "PSToolsInstaller.ps1"
echo.
timeout 2 > nul

:main
cls
color 7
echo.
echo 			     		O=-=-=-=-=FoxMic Project=-=-=-=-=O
echo.
echo.
type adapter.cfg >nul 2>&1
if %errorlevel%==1 goto adaptconfig
echo.
for /f "tokens=1" %%a in (adapter.cfg) do set number=%%a
goto afterfox
:adaptconfig
echo Configure WiFi adapter.
echo.
wmic nic get name, index
echo.
echo Or type exit to exit.
echo.
set /p number=Select Number: 
if %number%==exit exit
echo %number% > adapter.cfg
echo.
echo Adapter choice will be remembered. (Find at adapter.cfg)
echo %number%| findstr /r /i ^^[a-z][a-z0-9-]*$ && goto adaptererror || goto afterfox

:afterfox
echo. 
echo %number% was selected
echo.
echo.
echo Starting WiFi adapter...
echo.
echo wmic path win32_networkadapter where index=%number% call enable
echo.
wmic path win32_networkadapter where index=%number% call enable > results.txt
setlocal enabledelayedexpansion
set /p results=<%back%\results.txt > nul
echo %results%
if "%results%" == "No Instance(s) Available." goto adaptererror

goto acfg

:adaptererror
echo.
echo --------------------------------------------------
color 0c
echo.
echo 		ERROR
echo.
echo An error has occured when configuring the adapter.
echo.
echo Try selecting a different option.
echo.
if exist "results.txt" del results.txt /q
if exist "enable()" del enable() /q
if exist "adapter.cfg" del adapter.cfg /q
pause
endlocal
goto main

:acfg
del results.txt /q
del enable() /q
endlocal
echo.
echo Adapter status:
echo.
netsh interface show interface | findstr /C:"Wi-Fi" /C:"Name" /C:"-"
for /f "usebackq skip=3 tokens=1" %%a in (`netsh interface show interface^| findstr /vl "Local Area Connection"`) do echo %%a >> net.txt
set /p var=<%back%\net.txt > nul
del net.txt
if "%var%" == "Disabled " goto adaptererror
echo.
echo Internet connecting...
echo.
timeout 1 > nul

:vpn
echo.
echo.
set x=on
set /p mchoice=Would you like to turn on a VPN? (Y/N): 
if %mchoice%==y echo. & echo %mchoice% was selected & cd VPN & call VPN.bat & echo. & goto continue
if %mchoice%==n echo. & echo %mchoice% was selected & goto continue
if %mchoice%==Y echo. & echo %mchoice% was selected & cd VPN & call VPN.bat & echo. & goto continue
if %mchoice%==N echo. & echo %mchoice% was selected & goto continue
if %mchoice%==main goto main
goto error

:error
echo.
echo Inavlid selection.
echo.
timeout 3 > nul
cls
goto vpn

:continue
cd ..
echo.
PSLIST firefox >nul 2>&1
if %errorlevel%==1 (
timeout 1 > nul
) ELSE (
echo firefox.exe status: running
goto loop
)

echo.
echo start firefox.exe -private-window
echo.
start firefox.exe -private-window
timeout 2 > nul
echo firefox.exe status: running
timeout 2 > nul
:loop
PSLIST firefox >nul 2>&1
if %errorlevel%==1 (
goto end
) ELSE (
timeout 5 > nul
goto loop
)

:end
echo.
echo firefox.exe status: closed
timeout 1 > nul
echo.
echo Checking / Disconnecting VPN...
cd %back%
cd VPN
set x=off
call VPN.bat
echo.
echo Shutting off WiFi Adapter...
echo.
echo wmic path win32_networkadapter where index=%number% call disable
echo.
wmic path win32_networkadapter where index=%number% call disable
echo.
echo Internet status:
echo.
netsh interface show interface | findstr /C:"Wi-Fi" /C:"Name" /C:"-"
echo.
echo Done.
echo.
echo FoxMic exiting...
timeout 3 > nul

::Jesus is Lord!
::Accept him before it's too late, rapture is near...
::Repent.