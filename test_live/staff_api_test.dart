// Run explicitly against the isolated trial API; never part of the offline suite.
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app_electrolink/features/staff/data/staff_api.dart';
import 'package:mobile_app_electrolink/features/staff/data/staff_repository.dart';
import 'package:mobile_app_electrolink/features/staff/presentation/staff_session.dart';
import '../test/support/memory_storage.dart';

void main() {
  test(
    'trial API: login, stores, summary, alerts, safety, protocol, ACK and logout',
    () async {
      final path = Platform.environment['STAFF_TRIAL_CREDENTIALS_FILE'];
      if (path == null) {
        throw StateError(
          'Set STAFF_TRIAL_CREDENTIALS_FILE to a private trial account JSON.',
        );
      }
      final trial =
          jsonDecode(File(path).readAsStringSync()) as Map<String, dynamic>;
      final api = StaffApi(
        dio: Dio(
          BaseOptions(
            baseUrl: trial['apiBaseUrl'] as String,
            connectTimeout: const Duration(seconds: 15),
            receiveTimeout: const Duration(seconds: 30),
          ),
        ),
      );
      final storage = MemoryStorage();
      final session = StaffSession(api, storage);
      addTearDown(session.close);
      await session.signIn(
        trial['email'] as String,
        trial['password'] as String,
      );
      expect(session.state.status, SessionStatus.signedIn);
      expect(session.state.userId, startsWith('us-'));
      final repository = StaffRepository(api);
      final stores = await repository.stores();
      final store = stores.singleWhere((s) => s.id == trial['storeId']);
      final summary = await repository.summary(store.id);
      expect(summary.storeId, store.id);
      final equipment = summary.equipment.singleWhere(
        (e) => e.id == trial['equipmentId'],
      );
      expect(equipment.state, 'UNMONITORED');
      final detail = await repository.detail(store.id, equipment);
      expect(detail.safety.status, 'UNVERIFIED');
      expect(detail.safety.canShowSafeAt(DateTime.now()), isFalse);
      expect(detail.protocol.shutdown, isNotEmpty);
      final response = await api.dio.get<Map<String, dynamic>>(
        '${repository.equipmentPath(store.id, equipment)}/alerts/${Uri.encodeComponent(trial['alertId'] as String)}',
      );
      // Resolve the exact trial alert rather than modifying another user's data.
      final before = await repository.alerts(store.id);
      if (response.data!['status'] == 'OPEN') {
        final alert = before.items.singleWhere((a) => a.id == trial['alertId']);
        final acknowledged = await repository.acknowledge(
          store.id,
          equipment,
          alert,
        );
        expect(acknowledged.status, 'ACKNOWLEDGED');
        expect(acknowledged.id, trial['alertId']);
      } else {
        expect(response.data!['status'], 'ACKNOWLEDGED');
      }
      final after = await repository.alerts(store.id);
      expect(after.items.any((a) => a.id == trial['alertId']), isFalse);
      await session.signOut();
      expect(storage.token, isNull);
      expect(api.token, isNull);
    },
  );
}
