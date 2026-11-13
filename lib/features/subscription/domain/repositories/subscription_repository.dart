import '../models/subscription_data.dart';

abstract class SubscriptionRepository {
  Future<SubscriptionData> fetchSubscription();
  Future<List<PaymentEntry>> fetchPaymentHistory({int page = 1, int pageSize = 20});
  Future<String?> initiateCheckout(String planType, String billingCycle, String successUrl, String cancelUrl);
  Future<bool> cancelSubscription(String reason, {String? feedback});
  Future<String?> openCustomerPortal(String returnUrl);
}