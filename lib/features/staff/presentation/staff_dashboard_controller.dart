import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/staff_api.dart';
import '../data/staff_repository.dart';
import '../domain/staff_models.dart';

class StaffDashboardState {
  final List<StaffStore> stores;
  final StaffStore? selected;
  final StaffSummary? dashboard;
  final StaffAlerts? alerts;
  final bool loading, loadedStores;
  final String? error;
  const StaffDashboardState({
    this.stores = const [],
    this.selected,
    this.dashboard,
    this.alerts,
    this.loading = false,
    this.loadedStores = false,
    this.error,
  });
}

class StaffDashboardController extends Cubit<StaffDashboardState> {
  final StaffRepository repository;
  int _generation = 0;
  StaffDashboardController(this.repository)
    : super(const StaffDashboardState());
  Future<void> load() async {
    final generation = ++_generation;
    emit(const StaffDashboardState(loading: true));
    try {
      final stores = await repository.stores();
      if (isClosed || generation != _generation) return;
      emit(StaffDashboardState(stores: stores, loadedStores: true));
      if (stores.isNotEmpty) await select(stores.first);
    } catch (error) {
      if (!isClosed && generation == _generation) {
        emit(StaffDashboardState(error: staffError(error)));
      }
    }
  }

  Future<void> select(StaffStore store) async {
    final generation = ++_generation;
    final stores = state.stores;
    emit(
      StaffDashboardState(
        stores: stores,
        selected: store,
        loading: true,
        loadedStores: true,
      ),
    );
    try {
      final results = await Future.wait<Object>([
        repository.summary(store.id),
        repository.alerts(store.id),
      ]);
      if (!isClosed && generation == _generation) {
        emit(
          StaffDashboardState(
            stores: stores,
            selected: store,
            loadedStores: true,
            dashboard: results[0] as StaffSummary,
            alerts: results[1] as StaffAlerts,
          ),
        );
      }
    } catch (error) {
      if (!isClosed && generation == _generation) {
        emit(
          StaffDashboardState(
            stores: stores,
            selected: store,
            loadedStores: true,
            error: staffError(error),
          ),
        );
      }
    }
  }

  Future<void> refresh() =>
      state.selected == null ? load() : select(state.selected!);
}
