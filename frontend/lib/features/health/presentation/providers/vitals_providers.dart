import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/core_providers.dart';
import '../../data/vitals_repository.dart';
import '../../domain/vital_model.dart';

final vitalsRepositoryProvider = Provider<VitalsRepository>((ref) {
  return VitalsRepository(apiClient: ref.watch(apiClientProvider));
});

final patientVitalsProvider =
    FutureProvider.autoDispose.family<List<VitalModel>, String>((ref, patientId) {
  return ref.watch(vitalsRepositoryProvider).list(patientId);
});
