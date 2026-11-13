import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// Separate transport for the operational flow; legacy screens keep their client.
class StaffApi {
  final Dio dio;
  String? token;
  void Function(String)? onUnauthorized;

  StaffApi({Dio? dio})
    : dio =
          dio ??
          Dio(
            BaseOptions(
              baseUrl: const String.fromEnvironment(
                'API_BASE_URL',
                defaultValue: '',
              ),
              connectTimeout: const Duration(seconds: 15),
              receiveTimeout: const Duration(seconds: 30),
              headers: {
                'Accept': 'application/json',
                'Content-Type': 'application/json',
              },
            ),
          ) {
    if (this.dio.options.baseUrl.isEmpty) {
      this.dio.options.baseUrl = defaultTargetPlatform == TargetPlatform.android
          ? 'http://10.0.2.2:8088'
          : 'http://127.0.0.1:8088';
    }
    this.dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (request, handler) {
          if (request.path != '/api/v1/auth/sign-in' && token != null) {
            final current = token!;
            if (JwtIdentity.parse(current) == null) {
              onUnauthorized?.call(current);
              handler.reject(
                DioException(
                  requestOptions: request,
                  type: DioExceptionType.cancel,
                ),
              );
              return;
            }
            request.headers['Authorization'] = 'Bearer $current';
          }
          handler.next(request);
        },
        onError: (error, handler) {
          final authorization = error.requestOptions.headers['Authorization'];
          if (error.response?.statusCode == 401 &&
              authorization is String &&
              authorization.startsWith('Bearer ')) {
            onUnauthorized?.call(authorization.substring(7));
          }
          handler.next(error);
        },
      ),
    );
  }
}

class JwtIdentity {
  final String userId, email;
  final DateTime expiresAt;
  const JwtIdentity(this.userId, this.email, this.expiresAt);

  // Used for local expiry/identity only. The server validates signature/authority.
  static JwtIdentity? parse(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) return null;
      final json =
          jsonDecode(
                utf8.decode(base64Url.decode(base64Url.normalize(parts[1]))),
              )
              as Map<String, dynamic>;
      final exp = json['exp'];
      if (exp is! num) return null;
      final expires = DateTime.fromMillisecondsSinceEpoch(
        exp.toInt() * 1000,
        isUtc: true,
      );
      if (!expires.isAfter(DateTime.now().toUtc())) return null;
      final id =
          json['sub'] ??
          json['nameid'] ??
          json['userId'] ??
          json['http://schemas.xmlsoap.org/ws/2005/05/identity/claims/nameidentifier'];
      if (id is! String || id.isEmpty) return null;
      final email =
          json['email'] ??
          json['http://schemas.xmlsoap.org/ws/2005/05/identity/claims/emailaddress'];
      return JwtIdentity(id, email is String ? email : '', expires);
    } catch (_) {
      return null;
    }
  }
}

String staffError(Object error, {bool signingIn = false}) {
  if (error is DioException) {
    switch (error.response?.statusCode) {
      case 401:
        return signingIn
            ? 'Correo o contraseña incorrectos.'
            : 'Tu sesión venció. Inicia sesión nuevamente.';
      case 403:
        return 'Esta cuenta no tiene acceso o está inactiva.';
      case 404:
        return 'El recurso ya no está disponible para esta cuenta.';
      case 409:
        return 'El estado cambió. Actualiza e inténtalo nuevamente.';
      case 429:
        return 'Demasiados intentos. Espera un momento y vuelve a intentar.';
    }
    if (error.response == null) {
      return 'No pudimos conectar. Revisa tu conexión e inténtalo nuevamente.';
    }
  }
  return 'No pudimos completar la operación. Inténtalo nuevamente.';
}
