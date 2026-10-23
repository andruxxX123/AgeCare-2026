"""CRUD protegido del perfil del adulto mayor y su círculo de cuidado."""
from uuid import UUID

from fastapi import APIRouter, Depends, status
from sqlalchemy.ext.asyncio import AsyncSession

from app.api.deps import get_current_user
from app.core.database import get_db
from app.features.patients.schemas import (
    PatientCreateRequest,
    PatientCreateResponse,
    PatientDetailResponse,
    PatientListItem,
    PatientListResponse,
    PatientUpdateRequest,
)
from app.features.patients.service import (
    create_patient,
    get_patient_for_member,
    list_patients_for_member,
    update_patient,
)
from app.models.user import User

router = APIRouter(prefix="/patients", tags=["patients"])


def _detail(patient) -> PatientDetailResponse:
    return PatientDetailResponse(
        patient_id=patient.id,
        full_name=patient.full_name,
        birth_date=patient.birth_date,
        sex=patient.sex,
        photo_url=patient.photo_url,
        conditions=patient.conditions,
        notes=patient.notes,
        wearable=None,
    )


@router.get("", response_model=PatientListResponse, summary="Listar mis pacientes")
async def list_patients_endpoint(
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user),
) -> PatientListResponse:
    items = [
        PatientListItem(
            patient_id=patient.id,
            full_name=patient.full_name,
            birth_date=patient.birth_date,
            sex=patient.sex,
            photo_url=patient.photo_url,
            conditions=patient.conditions,
            notes=patient.notes,
            wearable=None,
            role=membership.role.value,
            is_owner=membership.is_owner,
        )
        for patient, membership in await list_patients_for_member(db, current_user)
    ]
    return PatientListResponse(items=items)


@router.post(
    "",
    response_model=PatientCreateResponse,
    status_code=status.HTTP_201_CREATED,
    summary="Crear el perfil del adulto mayor",
)
async def create_patient_endpoint(
    payload: PatientCreateRequest,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user),
) -> PatientCreateResponse:
    """
    Crea el paciente y registra a `current_user` como familiar administrador
    (owner) en `patient_members`. Requiere estar autenticado (cualquier
    usuario registrado puede crear un paciente y así iniciar un círculo de
    cuidado nuevo).
    """
    patient = await create_patient(db, payload, owner=current_user)
    return PatientCreateResponse(
        patient_id=patient.id,
        full_name=patient.full_name,
        created_at=patient.created_at,
    )


@router.get(
    "/{patient_id}",
    response_model=PatientDetailResponse,
    summary="Detalle de paciente",
)
async def get_patient_endpoint(
    patient_id: UUID,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user),
) -> PatientDetailResponse:
    """
    Devuelve el perfil completo del paciente si `current_user` pertenece a
    su círculo de cuidado (ver get_patient_for_member). `wearable` viaja en
    `null`: la vinculación de dispositivos es del módulo de Vitals
    (Sprint 3), no de este hito.
    """
    patient = await get_patient_for_member(db, patient_id, current_user)
    return _detail(patient)


@router.patch(
    "/{patient_id}",
    response_model=PatientDetailResponse,
    summary="Actualizar perfil del adulto mayor",
)
async def update_patient_endpoint(
    patient_id: UUID,
    payload: PatientUpdateRequest,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user),
) -> PatientDetailResponse:
    patient = await update_patient(db, patient_id, payload, current_user)
    return _detail(patient)
