#!/bin/sh
@ echo off
echo ^>/dev/null \>nul \& goto bat

rem= # .sh mode #
echo @ command is only used in .bat mode.
cd app
godot -export "Linux X11" "../alpha"
exit

rem= # .bat mode #
:bat
echo #! command is only used in .sh mode.
cd app
"godot.exe" -export "Windows Desktop" "../alpha.exe"
exit /b