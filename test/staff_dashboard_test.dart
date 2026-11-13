import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app_electrolink/features/staff/data/staff_api.dart';
import 'package:mobile_app_electrolink/features/staff/data/staff_repository.dart';
import 'package:mobile_app_electrolink/features/staff/domain/staff_models.dart';
import 'package:mobile_app_electrolink/features/staff/presentation/staff_dashboard_controller.dart';
import 'support/http_stub.dart';

Map<String, Object> summary(String id) => {
  'storeId': id,
  'generatedAtUtc': DateTime.now().toUtc().toIso8601String(),
  'totalEquipment': 0,
  'monitoredEquipment': 0,
  'offlineEquipment': 0,
  'unmonitoredEquipment': 0,
  'activeCriticalAlerts': 0,
  'activeNonCriticalAlerts': 0,
  'equipment': <Object>[],
};
Map<String, Object> alerts() => {
  'openCritical': 0,
  'openNonCritical': 0,
  'items': <Object>[],
};

void main() {
  test('loads all stores from paginated contract', () async {
    final api = StaffApi();
    api.dio.httpClientAdapter = HttpStub((request) async {
      final page = request.queryParameters['page'] as int;
      return jsonResponse({
        'items': [
          {'id': 'store-$page', 'name': 'Local $page', 'address': 'Lima'},
        ],
        'hasMore': page == 1,
      });
    });
    expect((await StaffRepository(api).stores()).map((s) => s.id), [
      'store-1',
      'store-2',
    ]);
  });
  test('late dashboard response does not overwrite selected store', () async {
    final waiting = Completer<void>();
    final api = StaffApi();
    api.dio.httpClientAdapter = HttpStub((request) async {
      if (request.path.contains('store-old')) await waiting.future;
      return jsonResponse(
        request.path.endsWith('dashboard-summary')
            ? summary(
                request.path.contains('store-old') ? 'store-old' : 'store-new',
              )
            : alerts(),
      );
    });
    final controller = StaffDashboardController(StaffRepository(api));
    final old = controller.select(const StaffStore('store-old', 'Old', ''));
    await controller.select(const StaffStore('store-new', 'New', ''));
    waiting.complete();
    await old;
    expect(controller.state.selected?.id, 'store-new');
    expect(controller.state.dashboard?.storeId, 'store-new');
    await controller.close();
  });
  test('server error remains an error instead of an empty dashboard', () async {
    final api = StaffApi();
    api.dio.httpClientAdapter = HttpStub((_) async => jsonResponse({}, 500));
    final controller = StaffDashboardController(StaffRepository(api));
    await controller.load();
    expect(controller.state.error, isNotNull);
    expect(controller.state.loadedStores, isFalse);
    await controller.close();
  });
}
