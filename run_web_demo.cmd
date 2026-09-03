@echo off
setlocal

set "DART_EXE=C:\dev\flutter\bin\cache\dart-sdk\bin\dart.exe"
set "SERVER_SCRIPT=%~dp0tool\web_demo_server.dart"
set "WEB_BUILD=%~dp0build\web"

if not exist "%DART_EXE%" (
  echo Dart not found: %DART_EXE%
  echo Please check the Flutter installation path.
  pause
  exit /b 1
)

if not exist "%WEB_BUILD%\index.html" (
  echo Web build not found: %WEB_BUILD%
  echo Please rebuild the Flutter Web app first.
  pause
  exit /b 1
)

"%DART_EXE%" "%SERVER_SCRIPT%" "%WEB_BUILD%"
set "DEMO_EXIT_CODE=%ERRORLEVEL%"

endlocal & exit /b %DEMO_EXIT_CODE%
