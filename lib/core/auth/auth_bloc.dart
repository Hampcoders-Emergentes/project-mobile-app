import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../network/api_client.dart';
import '../network/api_endpoints.dart';
import 'token_service.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();
  @override
  List<Object?> get props => [];
}

class AppStarted extends AuthEvent {}

class LoginRequested extends AuthEvent {
  final String email;
  final String password;
  const LoginRequested(this.email, this.password);
  @override
  List<Object?> get props => [email, password];
}

class RegisterRequested extends AuthEvent {
  final String email;
  final String password;
  final String passwordConfirmation;
  final String role;
  const RegisterRequested({
    required this.email,
    required this.password,
    required this.passwordConfirmation,
    this.role = 'homeowner',
  });
  @override
  List<Object?> get props => [email, password, passwordConfirmation, role];
}

class LogoutRequested extends AuthEvent {}

abstract class AuthState extends Equatable {
  const AuthState();
  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  final String token;
  final String userId;
  final String email;
  final String profileId;
  final String role;
  final bool isNewUser;
  const AuthAuthenticated({
    required this.token,
    required this.userId,
    required this.email,
    required this.profileId,
    this.role = '',
    this.isNewUser = false,
  });
  @override
  List<Object?> get props => [token, userId, email, profileId, role, isNewUser];
}

class AuthUnauthenticated extends AuthState {}

class AuthError extends AuthState {
  final String message;
  const AuthError(this.message);
  @override
  List<Object?> get props => [message];
}

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final TokenService _tokenService;
  ApiClient? _client;

  AuthBloc(this._tokenService) : super(AuthInitial()) {
    on<AppStarted>(_onAppStarted);
    on<LoginRequested>(_onLoginRequested);
    on<RegisterRequested>(_onRegisterRequested);
    on<LogoutRequested>(_onLogoutRequested);
  }

  ApiClient get _apiClient {
    _client ??= ApiClient(baseUrl: ApiEndpoints.baseUrl);
    return _client!;
  }

  Future<void> _onAppStarted(
    AppStarted event,
    Emitter<AuthState> emit,
  ) async {
    await _tokenService.loadToken();
    if (_tokenService.token != null) {
      final token = _tokenService.token!;
      final userId = _jwtUserId(token);
      final email = _jwtEmail(token);
      final profileId = _jwtProfileId(token);
      final role = _jwtRole(token);
      emit(AuthAuthenticated(
          token: token,
          userId: userId,
          email: email,
          profileId: profileId,
          role: role));
    } else {
      emit(AuthUnauthenticated());
    }
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final response = await _apiClient.post(
        '/Authentication/sign-in',
        data: {
          'email': event.email,
          'password': event.password,
        },
      );
      final data = response.data as Map<String, dynamic>;
      final token = data['token'] as String;
      final userId = data['userId'] as String;
      final email = data['email'] as String;
      final profileId = _jwtProfileId(token);
      final role = data['role'] as String? ?? _jwtRole(token);
      await _tokenService.saveToken(token);
      emit(AuthAuthenticated(
          token: token,
          userId: userId,
          email: email,
          profileId: profileId,
          role: role));
    } on DioException catch (e) {
      final msg = e.response?.data?['message']?.toString() ?? e.message ?? 'Error de conexión';
      emit(AuthError(msg));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onRegisterRequested(
    RegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final response = await _apiClient.post(
        '/Authentication/sign-up',
        data: {
          'email': event.email,
          'password': event.password,
          'passwordConfirmation': event.passwordConfirmation,
          'role': event.role,
        },
      );
      final data = response.data as Map<String, dynamic>;
      final token = data['token'] as String;
      final userId = data['userId'] as String;
      final email = data['email'] as String;
      final profileId = _jwtProfileId(token);
      await _tokenService.saveToken(token);
      emit(AuthAuthenticated(
          token: token,
          userId: userId,
          email: email,
          profileId: profileId,
          role: event.role,
          isNewUser: true));
    } on DioException catch (e) {
      final msg = e.response?.data?['message']?.toString() ?? e.message ?? 'Error de conexión';
      emit(AuthError(msg));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    await _tokenService.clearToken();
    emit(AuthUnauthenticated());
  }

  String _jwtUserId(String token) {
    try {
      final payload = _jwtPayload(token);
      return payload['userId'] as String? ?? '';
    } catch (_) {
      return '';
    }
  }

  String _jwtEmail(String token) {
    try {
      final payload = _jwtPayload(token);
      return payload['email'] as String? ?? '';
    } catch (_) {
      return '';
    }
  }

  String _jwtProfileId(String token) {
    try {
      final payload = _jwtPayload(token);
      return payload['profileId'] as String? ?? '';
    } catch (_) {
      return '';
    }
  }

  String _jwtRole(String token) {
    try {
      final payload = _jwtPayload(token);
      return payload['role'] as String? ?? '';
    } catch (_) {
      return '';
    }
  }

  Map<String, dynamic> _jwtPayload(String token) {
    final parts = token.split('.');
    if (parts.length != 3) return {};
    final normalized = parts[1].replaceAll('-', '+').replaceAll('_', '/');
    final padded = normalized.padRight(
      normalized.length + (4 - normalized.length % 4) % 4,
      '=',
    );
    final decoded = utf8.decode(base64.decode(padded));
    return Map<String, dynamic>.from(jsonDecode(decoded) as Map);
  }
}
