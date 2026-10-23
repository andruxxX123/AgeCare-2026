"""Rutas de autenticación del frontend y renovación de sesión."""
from fastapi import APIRouter, Depends, status
from sqlalchemy.ext.asyncio import AsyncSession

from app.core.database import get_db
from app.core.rate_limit import simple_rate_limit
from app.features.auth.schemas import (
    LoginRequest,
    LoginResponse,
    RefreshRequest,
    RefreshResponse,
    RegisterRequest,
    RegisterResponse,
)
from app.features.auth.service import authenticate_user, refresh_session, register_user

router = APIRouter(prefix="/auth", tags=["auth"])


@router.post(
    "/register",
    response_model=RegisterResponse,
    status_code=status.HTTP_201_CREATED,
    summary="Registrar cuenta de familiar",
    # Dependencia de rate limiting ilustrativa: máx. 5 intentos de registro
    # por IP cada 60 segundos (ver docstring de simple_rate_limit sobre por
    # qué esto es solo un punto de partida, no una solución de producción).
    dependencies=[Depends(simple_rate_limit(max_requests=5, window_seconds=60))],
)
async def register(
    payload: RegisterRequest,
    db: AsyncSession = Depends(get_db),
) -> RegisterResponse:
    """
    Crea la cuenta del usuario. En este AgeCare el familiar es quien se registra
    directamente (sin invitación); cuidadora, médico y adulto mayor se
    incorporarán vía invitación en un hito posterior.
    """
    user, access_token, refresh_token = await register_user(db, payload)
    return RegisterResponse(
        user_id=user.id,
        email=user.email,
        role=None,  # ver docstring de RegisterResponse
        access_token=access_token,
        refresh_token=refresh_token,
    )


@router.post("/login", response_model=LoginResponse, summary="Iniciar sesión")
async def login(payload: LoginRequest, db: AsyncSession = Depends(get_db)) -> LoginResponse:
    user, access_token, refresh_token = await authenticate_user(db, payload)
    return LoginResponse(
        user_id=user.id,
        email=user.email,
        role=None,
        access_token=access_token,
        refresh_token=refresh_token,
    )


@router.post("/refresh", response_model=RefreshResponse, summary="Renovar sesión")
async def refresh(payload: RefreshRequest, db: AsyncSession = Depends(get_db)) -> RefreshResponse:
    _, access_token, refresh_token = await refresh_session(db, payload)
    return RefreshResponse(access_token=access_token, refresh_token=refresh_token)
