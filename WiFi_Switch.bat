echo off
break off
title WiFi Switch
cls
goto checkadmin

:checkadmin
echo.
echo Checking admin privelages...
net session >nul 2>&1
if %errorlevel%==0 (
color 0a
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
pause
exit
)

:start
echo Configure WiFi adapter.
echo.
wmic nic get name, index
echo.
set /p number=Select Number: 
echo. 
echo %number% was selected
echo.
echo.
echo Internet Status:
echo.
echo netsh interface show interface | findstr /C:"Wi-Fi" /C:"Name" /C:"-"
echo.
netsh interface show interface | findstr /C:"Wi-Fi" /C:"Name" /C:"-"
echo.
echo.
pause
cls
echo.
echo.
echo 	=-=-=-=-=-=WiFi switch=-=-=-=-=-=
echo.
echo.
echo 1. Turn On
echo.
echo 2. Turn Off
echo.
echo 3. Exit
echo.
echo.
set /p mchoice=Select: 
if %mchoice%==1 goto on
if %mchoice%==2 goto off
if %mchoice%==3 exit
if %mchoice%==exit exit

:on
echo.
echo.
echo wmic path win32_networkadapter where index=%number% call enable
echo.
wmic path win32_networkadapter where index=%number% call enable
if %errorlevel%==0 (
echo Success.
timeout 2 > nul
exit
) ELSE (
echo Failed.
timeout 2 > nul
exit
)

:off
echo.
echo.
echo wmic path win32_networkadapter where index=%number% call disable
echo.
wmic path win32_networkadapter where index=%number% call disable
if %errorlevel%==0 (
echo Success.
timeout 2 > nul
exit
) ELSE (
echo Failed.
timeout 2 > nul
exit
)