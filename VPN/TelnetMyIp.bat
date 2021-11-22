echo off
break off
title WAN IP ADDRESS
cls

telnet /?
if %errorlevel%==0 (
cls
goto main
) ELSE (
echo.
echo Telnet not installed.
echo.
echo Installing telnet...
echo.
timeout 1 > nul
pkgmgr /iu:"TelnetClient"
echo.
echo Installed.
taskkill /im telnet.exe -f >nul 2>&1
)

:main
cls

start /min Killtelnet.bat

telnet telnetmyip.com 80