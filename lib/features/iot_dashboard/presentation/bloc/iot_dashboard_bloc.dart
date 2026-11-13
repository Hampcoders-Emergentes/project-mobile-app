import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/repositories/iot_dashboard_repository.dart';
import 'iot_dashboard_event.dart';
import 'iot_dashboard_state.dart';

/// Intervalo de polling: la telemetría llega por REST, no por streaming.
const Duration kIotPollingInterval = Duration(seconds: 60);

class IotDashboardBloc extends Bloc<IotDashboardEvent, IotDashboardState> {
  final IotDashboardRepository _repository;
  Timer? _pollTimer;

  IotDashboardBloc({required IotDashboardRepository repository})
      : _repository = repository,
        super(IotDashboardInitial()) {
    on<FetchIotDashboard>(_onFetch);
    on<RefreshIotDashboard>(_onRefresh);
    on<AcknowledgeAlert>(_onAcknowledgeAlert);

    _pollTimer = Timer.periodic(kIotPollingInterval, (_) {
      if (state is IotDashboardLoaded) add(const RefreshIotDashboard());
    });
  }

  Future<void> _onFetch(
    FetchIotDashboard event,
    Emitter<IotDashboardState> emit,
  ) async {
    emit(IotDashboardLoading());
    try {
      final data = await _repository.getDashboard();
      emit(IotDashboardLoaded(data: data));
    } catch (e) {
      emit(const IotDashboardError(
        message: 'No se pudo cargar el panel. Verifica tu conexión.',
      ));
    }
  }

  Future<void> _onRefresh(
    RefreshIotDashboard event,
    Emitter<IotDashboardState> emit,
  ) async {
    final previous = state;
    try {
      final data = await _repository.getDashboard();
      emit(IotDashboardLoaded(data: data));
    } catch (_) {
      // Refresco silencioso: se conserva lo último conocido.
      if (previous is! IotDashboardLoaded) {
        emit(const IotDashboardError(
          message: 'No se pudo cargar el panel. Verifica tu conexión.',
        ));
      }
    }
  }

  Future<void> _onAcknowledgeAlert(
    AcknowledgeAlert event,
    Emitter<IotDashboardState> emit,
  ) async {
    final current = state;
    if (current is! IotDashboardLoaded) return;
    try {
      await _repository.acknowledgeAlert(
        current.data.owner.ownerId,
        event.entryId,
      );
      final data = await _repository.getDashboard();
      emit(IotDashboardLoaded(data: data));
    } catch (_) {
      // La alerta sigue visible; el usuario puede reintentar.
    }
  }

  @override
  Future<void> close() {
    _pollTimer?.cancel();
    return super.close();
  }
}
