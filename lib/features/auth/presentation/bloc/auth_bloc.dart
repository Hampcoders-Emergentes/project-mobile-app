import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_app_electrolink/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:mobile_app_electrolink/features/auth/domain/repositories/auth_repository.dart';
import 'package:mobile_app_electrolink/features/auth/presentation/bloc/auth_event.dart';
import 'package:mobile_app_electrolink/features/auth/presentation/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;

  AuthBloc({AuthRepository? authRepository})
      : _authRepository = authRepository ?? AuthRepositoryImpl(),
        super(AuthInitial()) {
    on<LoginSubmitted>(_onLoginSubmitted);
    on<RegisterSubmitted>(_onRegisterSubmitted);
    on<AuthLogoutRequested>(_onLogoutRequested);
    on<CheckAuthStatus>(_onCheckAuthStatus);
  }

  Future<void> _onLoginSubmitted(
    LoginSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final user = await _authRepository.signIn(
        event.email,
        event.password,
      );
      emit(AuthSuccess(user: user));
    } on DioException catch (e) {
      final message = _extractErrorMessage(e);
      emit(AuthError(message: message));
    } catch (e) {
      emit(AuthError(message: 'Error de conexión. Intente nuevamente.'));
    }
  }

  Future<void> _onRegisterSubmitted(
    RegisterSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final user = await _authRepository.signUp(
        event.email,
        event.password,
        event.confirmPassword,
      );
      emit(AuthSuccess(user: user));
    } on DioException catch (e) {
      final message = _extractErrorMessage(e);
      emit(AuthError(message: message));
    } catch (e) {
      emit(AuthError(message: 'Error de conexión. Intente nuevamente.'));
    }
  }

  Future<void> _onLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    await _authRepository.signOut();
    emit(AuthInitial());
  }

  Future<void> _onCheckAuthStatus(
    CheckAuthStatus event,
    Emitter<AuthState> emit,
  ) async {
    final isAuth = await _authRepository.isAuthenticated();
    if (!isAuth) {
      emit(AuthInitial());
    }
  }

  String _extractErrorMessage(DioException e) {
    if (e.response?.data is Map) {
      final data = e.response!.data as Map;
      return (data['message'] as String?) ?? 'Error inesperado.';
    }
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Tiempo de espera agotado. Verifique su conexión.';
      case DioExceptionType.connectionError:
        return 'No se puede conectar al servidor.';
      default:
        return 'Error inesperado. Intente nuevamente.';
    }
  }
}
