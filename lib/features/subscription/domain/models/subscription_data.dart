import 'package:equatable/equatable.dart';

class SubscriptionData extends Equatable {
  final String planName;
  final double price;
  final String status;
  final bool cancelAtPeriodEnd;
  final String? billingCycle;
  final String? periodEnd;
  final int? monthlyRequestsUsed;
  final int? monthlyRequestsLimit;
  final String? gracePeriodEndsAt;
  final List<String> features;
  final List<PaymentEntry> payments;

  const SubscriptionData({
    required this.planName,
    this.price = 0,
    required this.status,
    this.cancelAtPeriodEnd = false,
    this.billingCycle,
    this.periodEnd,
    this.monthlyRequestsUsed,
    this.monthlyRequestsLimit,
    this.gracePeriodEndsAt,
    required this.features,
    required this.payments,
  });

  factory SubscriptionData.fromJson(Map<String, dynamic> json) {
    final features = _featuresForPlan(json['planType'] as String? ?? 'Free');
    return SubscriptionData(
      planName: json['planType'] as String? ?? 'Free',
      status: json['status'] as String? ?? 'Inactive',
      cancelAtPeriodEnd: json['cancelAtPeriodEnd'] as bool? ?? false,
      billingCycle: json['billingCycle'] as String?,
      periodEnd: json['periodEnd'] as String?,
      monthlyRequestsUsed: json['monthlyRequestsUsed'] as int?,
      monthlyRequestsLimit: json['monthlyRequestsLimit'] as int?,
      gracePeriodEndsAt: json['gracePeriodEndsAt'] as String?,
      features: features,
      payments: const [],
    );
  }

  static List<String> _featuresForPlan(String planType) {
    switch (planType) {
      case 'PremiumIndividual':
        return [
          'Monitoreo en tiempo real de consumo',
          'Alertas de anomalías eléctricas',
          'Historial de consumo detallado',
          'Soporte prioritario',
        ];
      case 'Enterprise':
        return [
          'Todo lo de Premium',
          'Gestión multi-propiedad',
          'API de integración',
          'Soporte dedicado 24/7',
          'Reportes personalizados',
        ];
      default:
        return [
          'Monitoreo básico de consumo',
          'Alertas por email',
          'Dashboard de consumo',
        ];
    }
  }

  SubscriptionData copyWith({List<PaymentEntry>? payments}) {
    return SubscriptionData(
      planName: planName,
      price: price,
      status: status,
      cancelAtPeriodEnd: cancelAtPeriodEnd,
      billingCycle: billingCycle,
      periodEnd: periodEnd,
      monthlyRequestsUsed: monthlyRequestsUsed,
      monthlyRequestsLimit: monthlyRequestsLimit,
      gracePeriodEndsAt: gracePeriodEndsAt,
      features: features,
      payments: payments ?? this.payments,
    );
  }

  @override
  List<Object?> get props => [
        planName,
        price,
        status,
        cancelAtPeriodEnd,
        billingCycle ?? '',
        periodEnd ?? '',
        monthlyRequestsUsed ?? 0,
        monthlyRequestsLimit ?? 0,
        gracePeriodEndsAt ?? '',
        features,
        payments,
      ];
}

class PaymentEntry extends Equatable {
  final String date;
  final double amount;
  final String status;

  const PaymentEntry({
    required this.date,
    required this.amount,
    required this.status,
  });

  factory PaymentEntry.fromJson(Map<String, dynamic> json) {
    return PaymentEntry(
      date: json['processedAt'] as String? ?? '',
      amount: (json['amountDecimal'] as num?)?.toDouble() ?? 0,
      status: json['status'] as String? ?? 'Unknown',
    );
  }

  @override
  List<Object> get props => [date, amount, status];
}
