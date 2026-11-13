import 'package:mobile_app_electrolink/core/network/api_client.dart';
import 'package:mobile_app_electrolink/core/network/api_endpoints.dart';
import '../../domain/models/subscription_data.dart';
import '../../domain/repositories/subscription_repository.dart';

class SubscriptionRepositoryImpl implements SubscriptionRepository {
  final ApiClient _client;

  SubscriptionRepositoryImpl(this._client);

  @override
  Future<SubscriptionData> fetchSubscription() async {
    final response = await _client.get(ApiEndpoints.mySubscription);
    final data = response.data as Map<String, dynamic>;
    final subscription = SubscriptionData.fromJson(data);

    final payments = await fetchPaymentHistory();
    return subscription.copyWith(payments: payments);
  }

  @override
  Future<List<PaymentEntry>> fetchPaymentHistory({int page = 1, int pageSize = 20}) async {
    try {
      final response = await _client.get(
        ApiEndpoints.myPaymentHistory,
        queryParameters: {'page': page, 'pageSize': pageSize},
      );
      final data = response.data as Map<String, dynamic>;
      final paymentsJson = data['payments'] as List<dynamic>? ?? [];
      return paymentsJson
          .map((e) => PaymentEntry.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  @override
  Future<String?> initiateCheckout(
    String planType,
    String billingCycle,
    String successUrl,
    String cancelUrl,
  ) async {
    try {
      final response = await _client.post(
        ApiEndpoints.checkout,
        data: {
          'planType': planType,
          'billingCycle': billingCycle,
          'successUrl': successUrl,
          'cancelUrl': cancelUrl,
        },
      );
      final data = response.data as Map<String, dynamic>;
      return data['checkoutUrl'] as String?;
    } catch (_) {
      return null;
    }
  }

  @override
  Future<bool> cancelSubscription(String reason, {String? feedback}) async {
    try {
      await _client.post(
        ApiEndpoints.cancelSubscription,
        data: {
          'reason': reason,
          'feedback': ?feedback,
        },
      );
      return true;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<String?> openCustomerPortal(String returnUrl) async {
    try {
      final response = await _client.post(
        ApiEndpoints.customerPortal,
        data: {'returnUrl': returnUrl},
      );
      final data = response.data as Map<String, dynamic>;
      return data['portalUrl'] as String?;
    } catch (_) {
      return null;
    }
  }
}
