import 'package:dio/dio.dart';
import '../../../core/network/api_client.dart';
import '../../../core/network/api_endpoints.dart';

class ProfileRepository {
  final ApiClient _client;

  ProfileRepository(this._client);

  Future<void> completeAsHomeowner(Map<String, dynamic> data) async {
    try {
      await _client.post(
        ApiEndpoints.completeHomeowner,
        data: data,
      );
    } on DioException catch (e) {
      final msg = e.response?.data?['message']?.toString() ?? e.message ?? 'Error al completar perfil';
      throw Exception(msg);
    }
  }
}
