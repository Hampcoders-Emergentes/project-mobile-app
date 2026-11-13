import 'package:flutter_bloc/flutter_bloc.dart';
import 'confirm_request_event.dart';
import 'confirm_request_state.dart';

class ConfirmRequestBloc extends Bloc<ConfirmRequestEvent, ConfirmRequestState> {
  ConfirmRequestBloc() : super(const ConfirmRequestInitial()) {
    on<ConfirmRequest>(_onConfirm);
  }

  Future<void> _onConfirm(ConfirmRequest event, Emitter<ConfirmRequestState> emit) async {
    emit(ConfirmRequestLoading());
    await Future.delayed(const Duration(seconds: 2));
    emit(const ConfirmRequestSuccess());
  }
}
