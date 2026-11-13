import 'package:equatable/equatable.dart';
import '../../domain/models/iot_dashboard_data.dart';

abstract class IotDashboardState extends Equatable {
  const IotDashboardState();

  @override
  List<Object?> get props => [];
}

class IotDashboardInitial extends IotDashboardState {}

class IotDashboardLoading extends IotDashboardState {}

class IotDashboardLoaded extends IotDashboardState {
  final IotDashboardData data;

  const IotDashboardLoaded({required this.data});

  @override
  List<Object> get props => [data];
}

class IotDashboardError extends IotDashboardState {
  final String message;

  const IotDashboardError({required this.message});

  @override
  List<Object> get props => [message];
}
