import 'package:equatable/equatable.dart';

abstract class SubscriptionEvent extends Equatable {
  const SubscriptionEvent();

  @override
  List<Object> get props => [];
}

class FetchSubscription extends SubscriptionEvent {
  const FetchSubscription();
}

class ChangePlanRequested extends SubscriptionEvent {
  final String planType;
  final String billingCycle;
  const ChangePlanRequested({required this.planType, this.billingCycle = 'monthly'});
  @override
  List<Object> get props => [planType, billingCycle];
}

class CancelSubscriptionRequested extends SubscriptionEvent {
  final String reason;
  final String? feedback;
  const CancelSubscriptionRequested({required this.reason, this.feedback});
  @override
  List<Object> get props => [reason, feedback ?? ''];
}

class OpenPortalRequested extends SubscriptionEvent {
  final String returnUrl;
  const OpenPortalRequested({required this.returnUrl});
  @override
  List<Object> get props => [returnUrl];
}
