import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app_electrolink/main.dart';
import 'package:mobile_app_electrolink/features/staff/data/staff_api.dart';
import 'package:mobile_app_electrolink/features/staff/presentation/staff_session.dart';
import 'support/memory_storage.dart';

void main() {
  testWidgets('App renders auth screen smoke test', (tester) async {
    final session = StaffSession(StaffApi(), MemoryStorage());
    addTearDown(session.close);
    await tester.pumpWidget(ElectroLinkApp(session: session));
    await tester.pumpAndSettle();
    expect(find.text('ElectroLink'), findsOneWidget);
    expect(find.text('Iniciar sesión'), findsOneWidget);
  });
}
