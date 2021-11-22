echo off
break off
title Disconnecting VPN...
cls

PUSHD "%CD%"
CD /D "%~dp0"
setlocal
set x=off
call VPN.bat
endlocal
echo Done.
timeout 2 > nul