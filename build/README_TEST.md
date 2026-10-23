# AgeCare — build de prueba

## Prueba rápida del frontend

1. Ejecuta `START_AGECARE_WEB.bat`.
2. Se abrirá `http://localhost:3000`.
3. Usa cualquiera de las cuentas de ejemplo indicadas en `AgeCare-Web-Demo/README.md`.
4. Prueba navegación, perfiles, salud local, calendario, comunicación y accesibilidad.

Esta demo no usa datos reales ni requiere instalar Flutter. Los datos se guardan en el
navegador local y se reinician si se limpian sus datos.

## Prueba del backend integrado

La carpeta `Backend/Backend-AgeCareW` contiene el backend con login, pacientes y signos
vitales. Para levantarlo necesitas Python 3.12+ y PostgreSQL 16 (Docker recomendado):

1. Ejecuta `START_AGECARE_BACKEND.bat` una vez para crear el entorno e instalar dependencias.
2. En la carpeta del backend ejecuta `docker compose up -d`.
3. Ejecuta `python -m alembic upgrade head`.
4. Ejecuta `uvicorn app.main:app --reload --port 8000`.
5. Abre `http://localhost:8000/docs` para probar los endpoints.

La build web rápida es independiente del backend y sirve para revisar la experiencia del AgeCare.
