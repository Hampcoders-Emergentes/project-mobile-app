import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../auth/token_service.dart';
import 'api_constants.dart';
import 'auth_interceptor.dart';

class ApiClient {
  static ApiClient? _instance;

  /// Cliente compartido apuntando al backend de identidad/perfiles.
  static ApiClient get instance =>
      _instance ??= ApiClient(baseUrl: ApiConstants.baseUrl);

  final FlutterSecureStorage storage = const FlutterSecureStorage();

  late final Dio _dio;

  Dio get dio => _dio;

  ApiClient({required String baseUrl, String? token}) {
    _dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));

    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        final t = token ?? TokenService.instance.token;
        if (t != null) {
          options.headers['Authorization'] = 'Bearer $t';
        }
        handler.next(options);
      },
      onError: (error, handler) {
        handler.next(error);
      },
    ));

    _dio.interceptors.add(AuthInterceptor(storage));
  }

  Future<Response> get(String path, {Map<String, dynamic>? queryParameters}) =>
      _dio.get(path, queryParameters: queryParameters);

  Future<Response> post(String path, {dynamic data}) =>
      _dio.post(path, data: data);

  Future<Response> put(String path, {dynamic data}) =>
      _dio.put(path, data: data);

  Future<Response> delete(String path) =>
      _dio.delete(path);
}
