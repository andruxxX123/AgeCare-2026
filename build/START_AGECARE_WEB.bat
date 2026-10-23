@echo off
setlocal
cd /d "%~dp0AgeCare-Web-Demo"
where py >nul 2>nul
if %errorlevel%==0 (
  start "AgeCare" http://localhost:3000
  py -3 -m http.server 3000
  goto :eof
)
where python >nul 2>nul
if %errorlevel%==0 (
  start "AgeCare" http://localhost:3000
  python -m http.server 3000
  goto :eof
)
echo No se encontro Python. Instala Python 3 y vuelve a ejecutar este archivo.
pause
