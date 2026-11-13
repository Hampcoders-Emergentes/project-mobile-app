import 'package:dio/dio.dart';
import 'package:mobile_app_electrolink/core/network/api_client.dart';
import 'package:mobile_app_electrolink/features/profile/data/models/complete_company_profile_request.dart';
import 'package:mobile_app_electrolink/features/profile/data/models/company_profile_response.dart';

class ProfileRemoteDataSource {
  final Dio _dio;

  ProfileRemoteDataSource() : _dio = ApiClient.instance.dio;

  Future<CompanyProfileResponse> getMyProfile() async {
    final response = await _dio.get('/api/v1/profiles/me');
    return CompanyProfileResponse.fromJson(
      response.data as Map<String, dynamic>,
    );
  }

  Future<CompanyProfileResponse> completeCompanyProfile(
    CompleteCompanyProfileRequest request,
  ) async {
    final response = await _dio.post(
      '/api/v1/profiles/me/complete/company',
      data: request.toJson(),
    );
    return CompanyProfileResponse.fromJson(
      response.data as Map<String, dynamic>,
    );
  }
}
