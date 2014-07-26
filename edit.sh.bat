#!/bin/sh
@ echo off
echo ^>/dev/null \>nul \& goto bat

rem= # .sh mode #
echo @ command is only used in .bat mode.
cd engine
../../godot -e
exit

rem= # .bat mode #
:bat
echo #! command is only used in .sh mode.
cd engine
"../../godot.exe" -e
exit /b