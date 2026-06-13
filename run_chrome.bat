@echo off
setlocal
set PUB_CACHE=C:\app\pub-cache
set FLUTTER_ROOT=C:\app\flutter
set PATH=C:\app\flutter\bin;%PATH%
cd /d C:\app\k24_mvp

echo.
echo ========================================
echo   K24Klik - Flutter Web (Chrome)
echo   Project: C:\app\k24_mvp
echo   Flutter: C:\app\flutter
echo ========================================
echo.
echo First launch can take 1-2 minutes to compile.
echo You should see a green K24Klik loading screen, then the app.
echo.
echo Do NOT use "flutter" from PATH - it points to the old broken install.
echo.

C:\app\flutter\bin\flutter.bat run -d chrome --web-port 7357

endlocal
