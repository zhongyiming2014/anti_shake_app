@echo off
setlocal

set "FLUTTER_EXE=C:\dev\flutter\bin\flutter.bat"
if not exist "%FLUTTER_EXE%" (
  echo Flutter not found: %FLUTTER_EXE%
  echo Please check the Flutter installation path.
  pause
  exit /b 1
)

for %%I in ("%~dp0.") do set "APP_DIR=%%~fI"
subst P: "%APP_DIR%" >nul 2>&1
if errorlevel 1 (
  echo Unable to create temporary drive P:.
  echo Please make sure drive P: is not already in use.
  pause
  exit /b 1
)

cd /d P:\
call "%FLUTTER_EXE%" run -d chrome

subst P: /d >nul 2>&1
endlocal
pause
