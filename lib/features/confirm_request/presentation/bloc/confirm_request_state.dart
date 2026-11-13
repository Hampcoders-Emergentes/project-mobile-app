import 'package:equatable/equatable.dart';

abstract class ConfirmRequestState extends Equatable {
  const ConfirmRequestState();

  @override
  List<Object> get props => [];
}

class ConfirmRequestInitial extends ConfirmRequestState {
  const ConfirmRequestInitial();
}

class ConfirmRequestLoading extends ConfirmRequestState {
  const ConfirmRequestLoading();
}

class ConfirmRequestSuccess extends ConfirmRequestState {
  const ConfirmRequestSuccess();
}

class ConfirmRequestError extends ConfirmRequestState {
  final String message;
  const ConfirmRequestError({required this.message});

  @override
  List<Object> get props => [message];
}
