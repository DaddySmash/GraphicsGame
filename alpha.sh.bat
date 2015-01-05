#!/bin/sh
@ echo off
echo ^>/dev/null \>nul \& goto bat

rem= # .sh mode #
echo @ command is only used in .bat mode.
cd app
if [ ! -x godot ]; then
  echo&echo Please download, rename, and chmod the Godot Engine to: ./app/godot
else
  rem= # ./alpha
  ../alpha
fi
cd ..
exit

rem= # .bat mode #
:bat
echo #! command is only used in .sh mode.
cd app
if not exist "godot.exe" (
  echo.&echo Please download and rename the Godot Engine to: ./app/godot.exe
) else (
  ../alpha.exe
)
cd ..
echo.&echo Press any key to close...&pause >nul
exit /b