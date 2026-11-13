import 'package:mobile_app_electrolink/core/enums/user_role.dart';
import 'package:mobile_app_electrolink/core/network/api_client.dart';
import 'package:mobile_app_electrolink/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:mobile_app_electrolink/features/auth/data/models/sign_in_request.dart';
import 'package:mobile_app_electrolink/features/auth/data/models/register_request.dart';
import 'package:mobile_app_electrolink/features/auth/domain/models/user_model.dart';
import 'package:mobile_app_electrolink/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final ApiClient _apiClient;

  AuthRepositoryImpl()
      : _remoteDataSource = AuthRemoteDataSource(),
        _apiClient = ApiClient.instance;

  UserRole _mapBackendRoleToUiRole(String? backendRole) {
    if (backendRole == null) return UserRole.homeowner;

    final normalizedRole = backendRole.toUpperCase();

    if (normalizedRole.contains('COMPANY')) {
      return UserRole.company;
    } else if (normalizedRole.contains('TECHNICIAN') ||
        normalizedRole.contains('MAKER')) {
      return UserRole.technician;
    } else {
      return UserRole.homeowner;
    }
  }

  @override
  Future<UserModel> signIn(String email, String password) async {
    final request = SignInRequest(email: email, password: password);
    final response = await _remoteDataSource.signIn(request);
    await _apiClient.storage.write(key: 'auth_token', value: response.token);
    return UserModel(
      userId: response.userId,
      email: response.email,
      token: response.token,
      role: _mapBackendRoleToUiRole(response.role),
    );
  }

  @override
  Future<UserModel> signUp(
    String email,
    String password,
    String confirmPassword,
  ) async {
    final request = RegisterRequest(
      email: email,
      password: password,
      confirmPassword: confirmPassword,
    );
    final response = await _remoteDataSource.signUp(request);
    await _apiClient.storage.write(key: 'auth_token', value: response.token);
    return UserModel(
      userId: response.userId,
      email: response.email,
      token: response.token,
      role: _mapBackendRoleToUiRole(response.role),
    );
  }

  @override
  Future<void> signOut() async {
    await _apiClient.storage.delete(key: 'auth_token');
  }

  @override
  Future<String?> getToken() async {
    return await _apiClient.storage.read(key: 'auth_token');
  }

  @override
  Future<bool> isAuthenticated() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }
}
