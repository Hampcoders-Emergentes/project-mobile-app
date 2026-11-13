import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app_electrolink/main.dart';
import 'package:mobile_app_electrolink/features/staff/data/staff_api.dart';
import 'package:mobile_app_electrolink/features/staff/presentation/staff_session.dart';
import 'support/memory_storage.dart';
import 'staff_dashboard_test.dart' show summary;
import 'support/http_stub.dart';

void main() {
  testWidgets(
    'login, real repository dashboard, detail, acknowledgement and logout',
    (tester) async {
      final api = StaffApi();
      final storage = MemoryStorage();
      final session = StaffSession(api, storage);
      addTearDown(session.close);
      var recognized = false;
      var acknowledgeCount = 0;
      var safetyLoads = 0;
      final alert = <String, dynamic>{
        'id': 'alert-1',
        'equipmentId': 'equipment-1',
        'anomalyType': 'CURRENT_LEAKAGE',
        'severity': 'CRITICAL',
        'status': 'OPEN',
        'createdAtUtc': DateTime.now().toUtc().toIso8601String(),
      };
      api.dio.httpClientAdapter = HttpStub((request) async {
        final path = request.path;
        if (path == '/api/v1/auth/sign-in') {
          return jsonResponse({
            'token': testToken(),
            'userId': 'us-test',
            'email': 'staff@example.test',
          });
        }
        expectSync(request.headers['Authorization'], startsWith('Bearer '));
        if (path == '/api/v1/stores') {
          return jsonResponse({
            'items': [
              {'id': 'store-1', 'name': 'Local de prueba', 'address': 'Lima'},
            ],
            'hasMore': false,
          });
        }
        if (path.endsWith('dashboard-summary')) {
          return jsonResponse({
            ...summary('store-1'),
            'totalEquipment': 1,
            'equipment': [
              {
                'equipmentId': 'equipment-1',
                'name': 'Refrigeradora',
                'areaId': 'area-1',
                'areaName': 'Cocina',
                'state': 'NORMAL',
              },
            ],
          });
        }
        if (path.endsWith('alerts/active')) {
          return jsonResponse({
            'openCritical': recognized ? 0 : 1,
            'openNonCritical': 0,
            'items': recognized ? [] : [alert],
          });
        }
        if (path.endsWith('/acknowledgement')) {
          expectSync(
            path,
            '/api/v1/stores/store-1/areas/area-1/equipment/equipment-1/alerts/alert-1/acknowledgement',
          );
          acknowledgeCount++;
          recognized = true;
          return jsonResponse({...alert, 'status': 'ACKNOWLEDGED'});
        }
        if (path.endsWith('safety-status')) {
          safetyLoads++;
          return jsonResponse({
            'status': 'UNVERIFIED',
            'isSafeToClean': false,
            'evaluatedAtUtc': DateTime.now().toUtc().toIso8601String(),
            'reasons': ['No hay lectura reciente.'],
          });
        }
        if (path.endsWith('shutdown-protocol')) {
          return jsonResponse({
            'isDefault': true,
            'shutdownSteps': ['Paso del servidor'],
            'emergencyIsolationSteps': ['Aislamiento del servidor'],
          });
        }
        throw StateError('Unexpected route: $path');
      });
      await tester.pumpWidget(ElectroLinkApp(session: session));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Iniciar sesión'));
      await tester.pumpAndSettle();
      expect(find.text('Ingresa un correo válido.'), findsOneWidget);
      await tester.enterText(
        find.byType(TextFormField).at(0),
        'staff@example.test',
      );
      await tester.enterText(find.byType(TextFormField).at(1), 'example');
      await tester.tap(find.text('Iniciar sesión'));
      await tester.pumpAndSettle();
      expect(find.text('Local de prueba'), findsOneWidget);
      await tester.scrollUntilVisible(find.text('Reconocer alerta'), 250);
      await tester.ensureVisible(find.text('Reconocer alerta'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Reconocer alerta'));
      await tester.pumpAndSettle();
      expect(acknowledgeCount, 0);
      await session.signOut();
      await tester.pumpAndSettle();
      expect(find.byType(AlertDialog), findsNothing);
      expect(find.text('Iniciar sesión'), findsOneWidget);
      unawaited(session.signIn('staff@example.test', 'example'));
      await tester.pumpAndSettle();
      await tester.scrollUntilVisible(find.text('Reconocer alerta'), 250);
      await tester.ensureVisible(find.text('Reconocer alerta'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Reconocer alerta'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Reconocer'));
      await tester.pumpAndSettle();
      expect(acknowledgeCount, 1);
      expect(find.text('No hay alertas activas registradas.'), findsOneWidget);
      await tester.scrollUntilVisible(find.text('Consultar equipo'), 250);
      await tester.ensureVisible(find.text('Consultar equipo'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Consultar equipo'));
      await tester.pumpAndSettle();
      expect(find.text('Seguridad sin verificar'), findsOneWidget);
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
      await tester.pump();
      expect(find.text('Seguridad sin verificar'), findsNothing);
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
      await tester.pump();
      await tester.pumpAndSettle();
      expect(safetyLoads, 2);
      // A protected 401 closes every route, including equipment detail.
      api.onUnauthorized!(api.token!);
      await tester.pumpAndSettle();
      expect(find.text('Iniciar sesión'), findsOneWidget);
      expect(find.text('Detalle del equipo'), findsNothing);
      expect(storage.token, isNull);
    },
  );

  testWidgets('small screen with large text and no stores stays usable', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 700);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    tester.platformDispatcher.textScaleFactorTestValue = 1.8;
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    final api = StaffApi();
    api.dio.httpClientAdapter = HttpStub(
      (_) async => jsonResponse({'items': [], 'hasMore': false}),
    );
    final session = StaffSession(api, MemoryStorage(testToken()));
    addTearDown(session.close);
    await tester.pumpWidget(ElectroLinkApp(session: session));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(find.text('Sin locales disponibles'), 200);
    expect(tester.takeException(), isNull);
    await tester.tap(find.byTooltip('Cerrar sesión'));
    await tester.pumpAndSettle();
    expect(find.text('Tu local, bajo control'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
