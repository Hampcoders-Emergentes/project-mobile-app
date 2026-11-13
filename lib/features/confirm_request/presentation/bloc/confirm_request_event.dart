import 'package:equatable/equatable.dart';

abstract class ConfirmRequestEvent extends Equatable {
  const ConfirmRequestEvent();

  @override
  List<Object> get props => [];
}

class ConfirmRequest extends ConfirmRequestEvent {
  const ConfirmRequest();
}
