import 'package:mobile_app_electrolink/core/network/api_client.dart';
import 'package:mobile_app_electrolink/core/network/api_endpoints.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/subscription_repository_impl.dart';
import '../../domain/repositories/subscription_repository.dart';
import 'subscription_event.dart';
import 'subscription_state.dart';

class SubscriptionBloc extends Bloc<SubscriptionEvent, SubscriptionState> {
  final SubscriptionRepository _repository;

  SubscriptionBloc({SubscriptionRepository? repository, ApiClient? client})
      : _repository = repository ??
            SubscriptionRepositoryImpl(
                client ?? ApiClient(baseUrl: ApiEndpoints.baseUrl)),
        super(const SubscriptionInitial()) {
    on<FetchSubscription>(_onFetch);
    on<ChangePlanRequested>(_onChangePlan);
    on<CancelSubscriptionRequested>(_onCancel);
    on<OpenPortalRequested>(_onOpenPortal);
  }

  Future<void> _onFetch(
      FetchSubscription event, Emitter<SubscriptionState> emit) async {
    emit(const SubscriptionLoading());
    try {
      final data = await _repository.fetchSubscription();
      emit(SubscriptionLoaded(data));
    } catch (e) {
      emit(SubscriptionError(e.toString()));
    }
  }

  Future<void> _onChangePlan(
      ChangePlanRequested event, Emitter<SubscriptionState> emit) async {
    final current = state;
    if (current is SubscriptionLoaded) {
      emit(current.copyWith(isActionLoading: true));
    }
    try {
      final url = await _repository.initiateCheckout(
        event.planType,
        event.billingCycle,
        'electrolink://checkout/success',
        'electrolink://checkout/cancel',
      );
      if (current is SubscriptionLoaded) {
        emit(current.copyWith(isActionLoading: false, actionUrl: url));
      }
    } catch (e) {
      if (current is SubscriptionLoaded) {
        emit(current.copyWith(isActionLoading: false));
      }
    }
  }

  Future<void> _onCancel(
      CancelSubscriptionRequested event, Emitter<SubscriptionState> emit) async {
    try {
      final success = await _repository.cancelSubscription(event.reason, feedback: event.feedback);
      if (success) {
        final data = await _repository.fetchSubscription();
        emit(SubscriptionLoaded(data));
      } else {
        emit(const SubscriptionError('Error al cancelar suscripción'));
      }
    } catch (e) {
      emit(SubscriptionError(e.toString()));
    }
  }

  Future<void> _onOpenPortal(
      OpenPortalRequested event, Emitter<SubscriptionState> emit) async {
    final current = state;
    if (current is SubscriptionLoaded) {
      emit(current.copyWith(isActionLoading: true));
    }
    try {
      final url = await _repository.openCustomerPortal(event.returnUrl);
      if (current is SubscriptionLoaded) {
        emit(current.copyWith(isActionLoading: false, actionUrl: url));
      }
    } catch (e) {
      if (current is SubscriptionLoaded) {
        emit(current.copyWith(isActionLoading: false));
      }
    }
  }
}
