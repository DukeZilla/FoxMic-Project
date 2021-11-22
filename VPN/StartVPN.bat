echo off
break off
title Starting VPN.bat ...
cls

PUSHD "%CD%"
CD /D "%~dp0"
setlocal
set x=on
echo Starting...
call VPN.bat
endlocal
echo.
echo Console shutting down...
echo.
timeout 3 > nul