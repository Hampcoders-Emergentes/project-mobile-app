/// Formato de números y tiempos del dashboard IoT (sin dependencia de intl).
class IotFormat {
  IotFormat._();

  /// 1240.5 -> "1,240.5"
  static String number(double value, {int decimals = 1}) {
    final fixed = value.toStringAsFixed(decimals);
    final parts = fixed.split('.');
    final digits = parts[0].replaceFirst('-', '');
    final buffer = StringBuffer();
    for (var i = 0; i < digits.length; i++) {
      if (i > 0 && (digits.length - i) % 3 == 0) buffer.write(',');
      buffer.write(digits[i]);
    }
    final sign = value < 0 ? '-' : '';
    final decimalPart =
        parts.length > 1 && int.parse(parts[1]) != 0 ? '.${parts[1]}' : '';
    return '$sign$buffer$decimalPart';
  }

  static String currency(double amount, String currencyCode) {
    final symbol = switch (currencyCode.toUpperCase()) {
      'PEN' => 'S/ ',
      'USD' => '\$',
      'EUR' => '€',
      _ => currencyCode.isEmpty ? '' : '$currencyCode ',
    };
    return '$symbol${amount.toStringAsFixed(2)}';
  }

  static String percent(double value) {
    final sign = value >= 0 ? '+' : '';
    return '$sign${value.toStringAsFixed(1)}%';
  }

  /// "hace 45 s", "hace 12 min", "hace 3 h", "ayer", "hace 4 días"
  static String relative(DateTime timestamp, {DateTime? now}) {
    final reference = (now ?? DateTime.now()).toUtc();
    final diff = reference.difference(timestamp.toUtc());
    if (diff.inSeconds < 60) return 'hace ${diff.inSeconds} s';
    if (diff.inMinutes < 60) return 'hace ${diff.inMinutes} min';
    if (diff.inHours < 24) return 'hace ${diff.inHours} h';
    if (diff.inDays == 1) return 'ayer';
    return 'hace ${diff.inDays} días';
  }

  /// "10:45" en hora local del dispositivo.
  static String clock(DateTime timestamp) {
    final local = timestamp.toLocal();
    final h = local.hour.toString().padLeft(2, '0');
    final m = local.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }
}
