from uuid import UUID

from fastapi import APIRouter, Depends, Query, status
from sqlalchemy.ext.asyncio import AsyncSession

from app.api.deps import get_current_user
from app.core.database import get_db
from app.features.health.schemas import VitalCreateRequest, VitalListResponse, VitalResponse
from app.features.health.service import create_vital, list_vitals
from app.models.user import User

router = APIRouter(prefix="/patients/{patient_id}/vitals", tags=["health"])


def _to_response(record) -> VitalResponse:
    return VitalResponse(
        id=record.id,
        patient_id=record.patient_id,
        recorded_by=record.recorded_by,
        metric=record.metric,
        value=float(record.value),
        unit=record.unit,
        recorded_at=record.recorded_at,
        source=record.source,
        note=record.note,
    )


@router.get("", response_model=VitalListResponse, summary="Consultar signos vitales")
async def get_vitals(
    patient_id: UUID,
    limit: int = Query(default=50, ge=1, le=200),
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user),
) -> VitalListResponse:
    records = await list_vitals(db, patient_id, current_user, limit)
    return VitalListResponse(items=[_to_response(item) for item in records])


@router.post(
    "", response_model=VitalResponse, status_code=status.HTTP_201_CREATED,
    summary="Registrar un signo vital",
)
async def post_vital(
    patient_id: UUID,
    payload: VitalCreateRequest,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user),
) -> VitalResponse:
    record = await create_vital(db, patient_id, payload, current_user)
    return _to_response(record)
