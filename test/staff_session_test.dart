import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:dio/dio.dart';
import 'package:mobile_app_electrolink/features/staff/data/staff_api.dart';
import 'package:mobile_app_electrolink/features/staff/presentation/staff_session.dart';
import 'support/http_stub.dart';
import 'support/memory_storage.dart';

class FailingClearStorage extends MemoryStorage {
  FailingClearStorage(super.token);
  @override
  Future<void> clear() async => throw StateError('storage unavailable');
}

void main() {
  test(
    'storage cleanup failure keeps memory signed out and exposes retry',
    () async {
      final session = StaffSession(
        StaffApi(),
        FailingClearStorage(testToken()),
      );
      await session.restore();
      await session.signOut();
      expect(session.state.status, SessionStatus.signedOut);
      expect(session.state.storageNeedsClear, isTrue);
      expect(session.api.token, isNull);
      await session.close();
    },
  );

  test(
    'duplicate submit sends one login request and logout rejects late response',
    () async {
      final response = Completer<ResponseBody>();
      final started = Completer<void>();
      var requests = 0;
      final api = StaffApi();
      api.dio.httpClientAdapter = HttpStub((request) {
        requests++;
        started.complete();
        return response.future;
      });
      final storage = MemoryStorage();
      final session = StaffSession(api, storage);
      final login = session.signIn('staff@example.test', 'example');
      await started.future;
      await session.signIn('staff@example.test', 'example');
      expect(requests, 1);
      await session.signOut();
      response.complete(jsonResponse({'token': testToken()}));
      await login;
      expect(session.state.status, SessionStatus.signedOut);
      expect(api.token, isNull);
      expect(storage.token, isNull);
      await session.close();
    },
  );
  test(
    'login errors do not expose server details or create a session',
    () async {
      final api = StaffApi();
      api.dio.httpClientAdapter = HttpStub(
        (_) async => jsonResponse({'detail': 'internal-secret-detail'}, 401),
      );
      final session = StaffSession(api, MemoryStorage());
      await session.signIn('staff@example.test', 'wrong');
      expect(session.state.status, SessionStatus.signedOut);
      expect(session.state.error, 'Correo o contraseña incorrectos.');
      expect(api.token, isNull);
      await session.close();
    },
  );

  test('expired saved token is cleared and never authenticates', () async {
    final storage = MemoryStorage(testToken(expires: 1));
    final session = StaffSession(StaffApi(), storage);
    await session.restore();
    expect(session.state.status, SessionStatus.signedOut);
    expect(storage.token, isNull);
    await session.close();
  });
  test(
    'canonical login preserves user string and clears session on protected 401',
    () async {
      final api = StaffApi();
      final storage = MemoryStorage();
      api.dio.httpClientAdapter = HttpStub((request) async {
        if (request.path == '/api/v1/auth/sign-in') {
          expect(request.data, {
            'email': 'staff@example.test',
            'password': 'example',
          });
          expect(request.headers['Authorization'], isNull);
          return jsonResponse({
            'userId': 'us-test',
            'email': 'staff@example.test',
            'token': testToken(),
          });
        }
        expect(request.headers['Authorization'], startsWith('Bearer '));
        return jsonResponse({'detail': 'private internals'}, 401);
      });
      final session = StaffSession(api, storage);
      await session.signIn('staff@example.test', 'example');
      expect(session.state.userId, 'us-test');
      expect(session.state.status, SessionStatus.signedIn);
      await expectLater(
        api.dio.get('/api/v1/stores'),
        throwsA(isA<DioException>()),
      );
      await Future<void>.delayed(Duration.zero);
      expect(session.state.status, SessionStatus.signedOut);
      expect(storage.token, isNull);
      expect(api.token, isNull);
      await session.close();
    },
  );
  test(
    'valid saved session restores identity then logout removes token',
    () async {
      final storage = MemoryStorage(testToken());
      final session = StaffSession(StaffApi(), storage);
      await session.restore();
      expect(session.state.userId, 'us-test');
      await session.signOut();
      expect(session.state.status, SessionStatus.signedOut);
      expect(storage.token, isNull);
      await session.close();
    },
  );
}
