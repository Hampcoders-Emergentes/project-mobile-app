import 'package:dio/dio.dart';
import 'package:mobile_app_electrolink/core/network/api_client.dart';
import 'package:mobile_app_electrolink/core/network/api_constants.dart';
import 'package:mobile_app_electrolink/features/auth/data/models/sign_in_request.dart';
import 'package:mobile_app_electrolink/features/auth/data/models/sign_in_response.dart';
import 'package:mobile_app_electrolink/features/auth/data/models/register_request.dart';

class AuthRemoteDataSource {
  final Dio _dio;

  AuthRemoteDataSource() : _dio = ApiClient.instance.dio;

  Future<SignInResponse> signIn(SignInRequest request) async {
    final response = await _dio.post(
      ApiConstants.signIn,
      data: request.toJson(),
    );
    return SignInResponse.fromJson(response.data as Map<String, dynamic>);
  }

  Future<SignInResponse> signUp(RegisterRequest request) async {
    final response = await _dio.post(
      ApiConstants.signUp,
      data: request.toJson(),
    );
    return SignInResponse.fromJson(response.data as Map<String, dynamic>);
  }
}
