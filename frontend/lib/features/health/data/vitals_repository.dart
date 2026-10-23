import '../../../core/network/api_client.dart';
import '../../../core/network/api_exception.dart';
import '../domain/vital_model.dart';

class VitalsRepository {
  final ApiClient _apiClient;

  VitalsRepository({required ApiClient apiClient}) : _apiClient = apiClient;

  Future<List<VitalModel>> list(String patientId) {
    return guardApiCall(() async {
      final response = await _apiClient.dio.get('/patients/$patientId/vitals');
      final items = (response.data as Map<String, dynamic>)['items'] as List<dynamic>;
      return items
          .map((item) => VitalModel.fromJson(item as Map<String, dynamic>))
          .toList();
    });
  }

  Future<VitalModel> create({
    required String patientId,
    required String metric,
    required double value,
    required String unit,
    String? note,
  }) {
    return guardApiCall(() async {
      final response = await _apiClient.dio.post('/patients/$patientId/vitals', data: {
        'metric': metric,
        'value': value,
        'unit': unit,
        if (note != null && note.trim().isNotEmpty) 'note': note.trim(),
      });
      return VitalModel.fromJson(response.data as Map<String, dynamic>);
    });
  }
}
