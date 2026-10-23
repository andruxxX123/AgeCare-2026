"""Registros de signos vitales del círculo de cuidado."""
import uuid
from datetime import datetime, timezone

from sqlalchemy import DateTime, ForeignKey, Numeric, String, Text
from sqlalchemy.dialects.postgresql import UUID
from sqlalchemy.orm import Mapped, mapped_column

from app.core.database import Base
from app.models.mixins import TimestampMixin


class VitalRecord(TimestampMixin, Base):
    __tablename__ = "vital_records"

    id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    patient_id: Mapped[uuid.UUID] = mapped_column(
        UUID(as_uuid=True), ForeignKey("patients.id", ondelete="CASCADE"), nullable=False, index=True
    )
    recorded_by: Mapped[uuid.UUID] = mapped_column(
        UUID(as_uuid=True), ForeignKey("users.id", ondelete="RESTRICT"), nullable=False, index=True
    )
    metric: Mapped[str] = mapped_column(String(32), nullable=False)
    value: Mapped[float] = mapped_column(Numeric(10, 2), nullable=False)
    unit: Mapped[str] = mapped_column(String(16), nullable=False)
    recorded_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True), nullable=False, default=lambda: datetime.now(timezone.utc)
    )
    source: Mapped[str] = mapped_column(String(32), nullable=False, default="manual", server_default="manual")
    note: Mapped[str | None] = mapped_column(Text, nullable=True)
