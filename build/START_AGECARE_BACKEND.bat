@echo off
setlocal
cd /d "%~dp0Backend\Backend-AgeCareW"
if not exist ".venv\Scripts\python.exe" (
  where py >nul 2>nul
  if %errorlevel%==0 (py -3 -m venv .venv) else (python -m venv .venv)
  call .venv\Scripts\activate.bat
  python -m pip install --upgrade pip
  pip install -r requirements.txt
) else (
  call .venv\Scripts\activate.bat
)
echo.
echo Backend listo para iniciar cuando PostgreSQL este disponible.
echo Ejecuta primero: docker compose up -d
echo Luego: python -m alembic upgrade head
echo Finalmente: uvicorn app.main:app --reload --port 8000
pause
