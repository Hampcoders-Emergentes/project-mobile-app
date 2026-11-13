import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app_electrolink/features/staff/domain/staff_models.dart';

void main() {
  test('old or unknown safety never shows a favorable cleaning state', () {
    final now = DateTime.utc(2026, 11, 13);
    expect(
      StaffSafety(
        'SAFE_TO_CLEAN',
        true,
        now.subtract(const Duration(minutes: 2)),
        [],
      ).canShowSafeAt(now),
      isFalse,
    );
    expect(StaffSafety('NEW_STATE', true, now, []).canShowSafeAt(now), isFalse);
    expect(
      StaffSafety('UNVERIFIED', false, now, []).canShowSafeAt(now),
      isFalse,
    );
    expect(
      StaffSafety('SAFE_TO_CLEAN', true, now, []).canShowSafeAt(now),
      isTrue,
    );
  });
}
