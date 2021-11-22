echo off
break off
title KILL TELNET
cls

timeout 10 

taskkill /im telnet.exe -f

echo done.

timeout 1 > nul

exit