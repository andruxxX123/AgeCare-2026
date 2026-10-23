"""add vital records for health AgeCare

Revision ID: 20261021_vitals
Revises: ee94d4920ece
"""
from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa
from sqlalchemy.dialects import postgresql

revision: str = "20261021_vitals"
down_revision: Union[str, None] = "ee94d4920ece"
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    op.create_table(
        "vital_records",
        sa.Column("id", postgresql.UUID(as_uuid=True), nullable=False),
        sa.Column("patient_id", postgresql.UUID(as_uuid=True), nullable=False),
        sa.Column("recorded_by", postgresql.UUID(as_uuid=True), nullable=False),
        sa.Column("metric", sa.String(length=32), nullable=False),
        sa.Column("value", sa.Numeric(precision=10, scale=2), nullable=False),
        sa.Column("unit", sa.String(length=16), nullable=False),
        sa.Column("recorded_at", sa.DateTime(timezone=True), nullable=False),
        sa.Column("source", sa.String(length=32), server_default="manual", nullable=False),
        sa.Column("note", sa.Text(), nullable=True),
        sa.Column("created_at", sa.DateTime(timezone=True), server_default=sa.text("now()"), nullable=False),
        sa.Column("updated_at", sa.DateTime(timezone=True), server_default=sa.text("now()"), nullable=False),
        sa.ForeignKeyConstraint(["patient_id"], ["patients.id"], ondelete="CASCADE"),
        sa.ForeignKeyConstraint(["recorded_by"], ["users.id"], ondelete="RESTRICT"),
        sa.PrimaryKeyConstraint("id"),
    )
    op.create_index("ix_vital_records_patient_id", "vital_records", ["patient_id"])
    op.create_index("ix_vital_records_recorded_by", "vital_records", ["recorded_by"])


def downgrade() -> None:
    op.drop_index("ix_vital_records_recorded_by", table_name="vital_records")
    op.drop_index("ix_vital_records_patient_id", table_name="vital_records")
    op.drop_table("vital_records")
