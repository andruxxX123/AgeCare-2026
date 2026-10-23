from datetime import datetime, timezone
from uuid import UUID

from sqlalchemy import desc, select
from sqlalchemy.ext.asyncio import AsyncSession

from app.core.exceptions import forbidden
from app.features.health.schemas import VitalCreateRequest
from app.features.patients.service import get_patient_for_member
from app.models.user import User
from app.models.vital import VitalRecord


async def create_vital(
    db: AsyncSession, patient_id: UUID, data: VitalCreateRequest, user: User
) -> VitalRecord:
    patient = await get_patient_for_member(db, patient_id, user)
    membership = next((item for item in patient.members if item.user_id == user.id), None)
    if membership is None or membership.role.value == "elder":
        raise forbidden("Este perfil no puede registrar signos vitales.")

    record = VitalRecord(
        patient_id=patient_id,
        recorded_by=user.id,
        metric=data.metric,
        value=data.value,
        unit=data.unit,
        recorded_at=data.recorded_at or datetime.now(timezone.utc),
        source=data.source,
        note=data.note,
    )
    db.add(record)
    await db.commit()
    await db.refresh(record)
    return record


async def list_vitals(
    db: AsyncSession, patient_id: UUID, user: User, limit: int = 50
) -> list[VitalRecord]:
    await get_patient_for_member(db, patient_id, user)
    result = await db.scalars(
        select(VitalRecord)
        .where(VitalRecord.patient_id == patient_id)
        .order_by(desc(VitalRecord.recorded_at))
        .limit(limit)
    )
    return list(result)
