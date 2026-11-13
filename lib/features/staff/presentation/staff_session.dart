import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../data/staff_api.dart';

abstract interface class SessionStorage {
  Future<String?> read();
  Future<void> write(String token);
  Future<void> clear();
}

class SecureSessionStorage implements SessionStorage {
  final FlutterSecureStorage storage;
  const SecureSessionStorage([this.storage = const FlutterSecureStorage()]);
  @override
  Future<String?> read() => storage.read(key: 'auth_token');
  @override
  Future<void> write(String token) =>
      storage.write(key: 'auth_token', value: token);
  @override
  Future<void> clear() => storage.delete(key: 'auth_token');
}

enum SessionStatus { restoring, signedOut, signingIn, signedIn }

class StaffSessionState {
  final SessionStatus status;
  final String email, userId;
  final String? error;
  final bool storageNeedsClear;
  const StaffSessionState(
    this.status, {
    this.email = '',
    this.userId = '',
    this.error,
    this.storageNeedsClear = false,
  });
}

class StaffSession extends Cubit<StaffSessionState> {
  final StaffApi api;
  final SessionStorage storage;
  Timer? _expiry;
  int _generation = 0;
  // Serialize persistence so a logout cannot leave a late login token on disk.
  Future<void> _persistence = Future.value();
  StaffSession(this.api, this.storage)
    : super(const StaffSessionState(SessionStatus.restoring)) {
    api.onUnauthorized = (rejected) {
      if (api.token == rejected) {
        unawaited(
          signOut(message: 'Tu sesión venció. Inicia sesión nuevamente.'),
        );
      }
    };
  }

  Future<void> _store(Future<void> Function() action) {
    final next = _persistence.then((_) => action());
    _persistence = next.catchError((Object _) {});
    return next;
  }

  Future<void> restore() async {
    final generation = ++_generation;
    try {
      final token = await storage.read();
      if (isClosed || generation != _generation) return;
      final identity = token == null ? null : JwtIdentity.parse(token);
      if (identity == null) {
        await signOut();
      } else {
        _authenticate(token!, identity);
      }
    } catch (_) {
      if (!isClosed && generation == _generation) {
        api.token = null;
        emit(
          const StaffSessionState(
            SessionStatus.signedOut,
            error:
                'No se pudo leer la sesión guardada. Inicia sesión nuevamente.',
          ),
        );
      }
    }
  }

  Future<void> signIn(String email, String password) async {
    if (state.status == SessionStatus.signingIn || isClosed) return;
    final generation = ++_generation;
    emit(const StaffSessionState(SessionStatus.signingIn));
    try {
      final response = await api.dio.post<Map<String, dynamic>>(
        '/api/v1/auth/sign-in',
        data: {'email': email.trim(), 'password': password},
      );
      if (isClosed || generation != _generation) return;
      final token = response.data?['token'];
      final identity = token is String ? JwtIdentity.parse(token) : null;
      if (identity == null) throw const FormatException('Invalid session');
      await _store(() => storage.write(token as String));
      if (!isClosed && generation == _generation) {
        _authenticate(token as String, identity);
      }
    } catch (error) {
      if (!isClosed && generation == _generation) {
        emit(
          StaffSessionState(
            SessionStatus.signedOut,
            error: staffError(error, signingIn: true),
          ),
        );
      }
    }
  }

  void _authenticate(String token, JwtIdentity identity) {
    api.token = token;
    _expiry?.cancel();
    _expiry = Timer(
      identity.expiresAt.difference(DateTime.now().toUtc()),
      () => unawaited(
        signOut(message: 'Tu sesión venció. Inicia sesión nuevamente.'),
      ),
    );
    emit(
      StaffSessionState(
        SessionStatus.signedIn,
        email: identity.email,
        userId: identity.userId,
      ),
    );
  }

  Future<void> signOut({String? message}) async {
    ++_generation;
    _expiry?.cancel();
    api.token = null;
    if (!isClosed) {
      emit(StaffSessionState(SessionStatus.signedOut, error: message));
    }
    try {
      await _store(storage.clear);
    } catch (_) {
      if (!isClosed && state.status == SessionStatus.signedOut) {
        emit(
          const StaffSessionState(
            SessionStatus.signedOut,
            storageNeedsClear: true,
            error:
                'Sesión cerrada en esta app. No se pudo eliminar el acceso guardado; vuelve a intentar cerrar sesión.',
          ),
        );
      }
    }
  }

  @override
  Future<void> close() {
    _expiry?.cancel();
    api.onUnauthorized = null;
    return super.close();
  }
}
