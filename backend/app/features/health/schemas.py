from datetime import datetime
from uuid import UUID

from pydantic import BaseModel, Field


class VitalCreateRequest(BaseModel):
    metric: str = Field(min_length=2, max_length=32, pattern=r"^[a-z_]+$")
    value: float = Field(ge=0, le=1000)
    unit: str = Field(min_length=1, max_length=16)
    recorded_at: datetime | None = None
    source: str = Field(default="manual", min_length=2, max_length=32)
    note: str | None = Field(default=None, max_length=500)


class VitalResponse(BaseModel):
    id: UUID
    patient_id: UUID
    recorded_by: UUID
    metric: str
    value: float
    unit: str
    recorded_at: datetime
    source: str
    note: str | None


class VitalListResponse(BaseModel):
    items: list[VitalResponse]
