import 'package:equatable/equatable.dart';
import '../../domain/models/subscription_data.dart';

abstract class SubscriptionState extends Equatable {
  const SubscriptionState();

  @override
  List<Object> get props => [];
}

class SubscriptionInitial extends SubscriptionState {
  const SubscriptionInitial();
}

class SubscriptionLoading extends SubscriptionState {
  const SubscriptionLoading();
}

class SubscriptionLoaded extends SubscriptionState {
  final SubscriptionData data;
  final bool isActionLoading;
  final String? actionUrl;

  const SubscriptionLoaded(
    this.data, {
    this.isActionLoading = false,
    this.actionUrl,
  });

  SubscriptionLoaded copyWith({SubscriptionData? data, bool? isActionLoading, String? actionUrl}) {
    return SubscriptionLoaded(
      data ?? this.data,
      isActionLoading: isActionLoading ?? this.isActionLoading,
      actionUrl: actionUrl ?? this.actionUrl,
    );
  }

  @override
  List<Object> get props => [data, isActionLoading, actionUrl ?? ''];  
}

class SubscriptionCancelled extends SubscriptionState {
  const SubscriptionCancelled();
}

class SubscriptionError extends SubscriptionState {
  final String message;

  const SubscriptionError(this.message);

  @override
  List<Object> get props => [message];
}
