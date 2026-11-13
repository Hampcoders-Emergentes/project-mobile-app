import 'package:equatable/equatable.dart';

abstract class IotDashboardEvent extends Equatable {
  const IotDashboardEvent();

  @override
  List<Object> get props => [];
}

/// Carga inicial o reintento: muestra loading y errores.
class FetchIotDashboard extends IotDashboardEvent {
  const FetchIotDashboard();
}

/// Refresco silencioso (polling / pull-to-refresh): conserva los datos
/// actuales si la petición falla.
class RefreshIotDashboard extends IotDashboardEvent {
  const RefreshIotDashboard();
}

class AcknowledgeAlert extends IotDashboardEvent {
  final String entryId;

  const AcknowledgeAlert({required this.entryId});

  @override
  List<Object> get props => [entryId];
}
