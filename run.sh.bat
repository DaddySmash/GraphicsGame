#!/bin/sh
@ echo off
echo ^>/dev/null \>nul \& goto bat

rem= # .sh mode #
echo @ command is only used in .bat mode.
cd ..
godot GraphicsGame/engine.cfg
exit

rem= # .bat mode #
:bat
echo #! command is only used in .sh mode.
cd ..
godot.exe GraphicsGame/engine.cfg
exit /b