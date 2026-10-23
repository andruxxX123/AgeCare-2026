# AgeCare

Repositorio integrado de AgeCare para 2026-II.

## Estructura

- `backend/`: API FastAPI, PostgreSQL y migraciones Alembic.
- `frontend/`: aplicación Flutter y experiencia web.
- `build/`: paquete preparado para ejecutar la experiencia web y configurar el backend.

## Inicio rápido

Para revisar la experiencia web, abre `build/START_AGECARE_WEB.bat`.

Para preparar el backend, abre `build/START_AGECARE_BACKEND.bat`. El servidor requiere
Python y PostgreSQL; la base de datos no se inicia automáticamente en esta entrega.

Consulta `build/README_TEST.md` para el flujo completo de validación.

## Dependencias y validación

- Backend: `backend/.venv` contiene el entorno instalado desde `backend/requirements.txt`.
- Web: `frontend/demo-web` y `build/AgeCare-Web-Demo` no requieren dependencias externas; `npm install` y `npm test` ya fueron ejecutados.
- Base de datos: no se inicia en este paquete. Las migraciones Alembic quedan incluidas para cuando exista PostgreSQL.
- Aplicación Flutter: el código fuente queda en `frontend/`; el SDK de Flutter no forma parte de este entorno de Windows.
