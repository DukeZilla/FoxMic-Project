echo off
break off
title VPN Console
PUSHD "%CD%"
CD /D "&~dp0"
set back=%cd%
cls
echo.
echo Running VPN.bat
echo.
echo DISCLAIMER: You must run StartVPN.bat in order for this batch file to run
echo.
timeout 3 > nul
cls

if %x%==off (
goto disconnect
) ELSE (
goto checkadmin
)

:checkadmin
echo.
echo Checking admin privelages...

net session >nul 2>&1
if %errorlevel%==0 (
echo.
echo Success.
goto vpn
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

:vpn
cls
cd %back%
echo.
echo.
echo 			=-=-=VPN=-=-=
echo.
echo.
echo What would you like to do?
echo.
echo.
echo 1. Load Configuration
echo.
echo 2. Configure VPN
echo.
echo 3. Check Configurations
echo.
echo 4. Disconnect
echo.
echo 5. Exit
echo.
echo.
set /p mchoice=Select: 
if %mchoice%==1 goto load
if %mchoice%==2 goto configure
if %mchoice%==3 goto check
if %mchoice%==4 goto disconnect
if %mchoice%==5 cls & exit /b
goto selecterror

:selecterror
echo.
echo.
echo Error: Invalid selection.
echo.
timeout 5 > nul
goto vpn

:check
echo.
echo.
echo -------------------------
echo Configuration file check:
echo.
echo.
type loadvpn.cfg >nul 2>&1
if %errorlevel%==0 (
for /f "tokens=1-9 delims= " %%g in ( loadvpn.cfg ) do ( echo %%h %%i %%j %%k )
echo.
echo.
pause
goto vpn
) ELSE (
echo.
echo ERROR:
echo.
echo No configuration file detected.
echo.
pause
goto vpn
)

:load
echo.
echo.
echo -------------------------
echo Loading configuration...
echo.
type loadvpn.cfg > nul
if %errorlevel%==0 (
timeout 1 > nul
) ELSE (
echo.
echo Error: No configuration file was found.
echo.
pause
goto vpn
)
for /f "delims=" %%a in ('type loadvpn.cfg^|findstr /bic:"set "') do %%a
echo Loaded.
goto okay


:configure
echo.
echo.
echo -------------------------
echo %mchoice% was selected
echo.
echo Configuration:
echo.
echo.
set /p website=Website or Server: 
echo %website%
echo.
set /p connection=Connection Name: 
echo %connection%
echo.
set /p user=Username: 
echo %user%
echo.
set /p pass=Password: 
echo %pass%
echo.
echo.
:validation
set /p mchoice=Configuration okay? (Y/N): 
if %mchoice%==y goto save
if %mchoice%==n goto vpn
if %mchoice%==Y goto save
if %mchoice%==N goto vpn
goto configerror

:save
echo.
set /p mchoice=Would you like to save these configuration settings? (Y/N): 
if %mchoice%==y goto saveconfig
if %mchoice%==n goto okay
if %mchoice%==Y goto saveconfig
if %mchoice%==N goto okay
goto saveerror

:saveerror
echo.
echo.
echo Error: Invalid selection.
echo.
timeout 5 > nul
cls
goto save

:configerror
echo.
echo.
echo Error: Invalid selection.
echo.
timeout 5 > nul
cls
goto validation

:saveconfig
echo.
echo.
echo --------------------------------------------------
echo Saving configuration settings into "loadvpn.cfg"...
echo.
echo You may load these configuration settings next time.
echo.
timeout 3 > nul

( echo set website=%website%
  echo set connection=%connection%
  echo set user=%user%
  echo set pass=%pass% ) > loadvpn.txt

del loadvpn.cfg /q >nul 2>&1
ren loadvpn.txt loadvpn.cfg
if %errorlevel%==0 (
echo.
echo Configuration settings saved.
echo.
timeout 4 > nul
) ELSE (
echo.
echo An error has occured when saving the settings...
echo.
echo Proceeding with the batch job...
echo.
timeout 4 > nul
)

:okay
echo.
echo.
echo Writing phonebook...
echo.
echo Implementing configurations...
echo.
cd \
echo C:\%SYSTEMROOT%\System32\ras
cd %systemroot%\system32\ras
echo.
echo VPN Information:
echo.

( echo [%connection%]
  echo MEDIA=rastapi
  echo Port=VPN2-0
  echo Device=WAN Miniport (IKEv2^)
  echo DEVICE=vpn
  echo PhoneNumber=%website%) > temp.txt

type temp.txt
type temp.txt >> rasphone.pbk
del temp.txt /q
echo.
echo Connecting to VPN...
echo.
echo rasdial "%connection%" %user% %pass%
rasdial "%connection%" %user% %pass%
if %errorlevel% NEQ 0 (
echo.
pause
goto vpn 
) ELSE (
echo.
set x=on > nul
goto success
)

:success
echo.
echo VPN Status: Connected
echo.
timeout 2 > nul
start firefox.exe -private-window
goto ip

:ip
echo.
cd %back%
set ipstring="IPv4 Address"
echo Displaying host IP address...
echo.
for /f "usebackq tokens=2 delims=:" %%f in (`ipconfig ^| findstr /c:%ipstring%`) do echo Host IP: %%f
echo.
timeout 2 > nul
echo Displaying new IP address...
echo.
timeout 2 > nul
call TelnetMyIP.bat
timeout 10
exit /b

:loop
if %x%==off (
goto disconnect 
) ELSE (
timeout 5 > nul
goto loop
)

:disconnect
echo.
echo Disconnecting VPN...
echo.
echo rasdial /DISCONNECT
echo.
rasdial /DISCONNECT
echo.
cd \
cd %SYSTEMROOT%\system32\ras
del rasphone.pbk /q
echo.
timeout 3 > nul
exit /b
