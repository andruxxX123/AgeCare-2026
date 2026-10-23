class VitalModel {
  final String id;
  final String patientId;
  final String metric;
  final double value;
  final String unit;
  final DateTime recordedAt;
  final String source;
  final String? note;

  const VitalModel({
    required this.id,
    required this.patientId,
    required this.metric,
    required this.value,
    required this.unit,
    required this.recordedAt,
    required this.source,
    this.note,
  });

  factory VitalModel.fromJson(Map<String, dynamic> json) => VitalModel(
        id: json['id'] as String,
        patientId: json['patient_id'] as String,
        metric: json['metric'] as String,
        value: (json['value'] as num).toDouble(),
        unit: json['unit'] as String,
        recordedAt: DateTime.parse(json['recorded_at'] as String),
        source: json['source'] as String? ?? 'manual',
        note: json['note'] as String?,
      );
}
