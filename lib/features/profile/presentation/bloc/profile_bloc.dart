import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_app_electrolink/features/profile/data/models/complete_company_profile_request.dart';
import 'package:mobile_app_electrolink/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:mobile_app_electrolink/features/profile/domain/repositories/profile_repository.dart';
import 'package:mobile_app_electrolink/features/profile/presentation/bloc/profile_event.dart';
import 'package:mobile_app_electrolink/features/profile/presentation/bloc/profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepository _repository;

  ProfileBloc({ProfileRepository? repository})
      : _repository = repository ?? ProfileRepositoryImpl(),
        super(ProfileInitial()) {
    on<LoadProfile>(_onLoadProfile);
    on<CompleteCompanyProfile>(_onCompleteCompanyProfile);
  }

  Future<void> _onLoadProfile(
    LoadProfile event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());
    try {
      final profile = await _repository.getMyProfile();
      emit(ProfileLoadSuccess(isComplete: profile.status == 'ACTIVE'));
    } on DioException catch (e) {
      emit(ProfileError(message: _extractError(e)));
    } catch (_) {
      emit(ProfileError(message: 'Error de conexión.'));
    }
  }

  Future<void> _onCompleteCompanyProfile(
    CompleteCompanyProfile event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());
    try {
      final request = CompleteCompanyProfileRequest(
        companyName: event.companyName,
        taxId: event.taxId,
        phoneNumber: event.phoneNumber,
        email: event.email,
        billingStreet: event.billingStreet,
        billingNumber: event.billingNumber,
        billingDistrict: event.billingDistrict,
        billingCity: event.billingCity,
        billingCountry: event.billingCountry,
        billingPostalCode: event.billingPostalCode,
      );
      await _repository.completeCompanyProfile(request);
      emit(ProfileSubmitSuccess());
    } on DioException catch (e) {
      emit(ProfileError(message: _extractError(e)));
    } catch (_) {
      emit(ProfileError(message: 'Error de conexión.'));
    }
  }

  String _extractError(DioException e) {
    if (e.response?.data is Map) {
      final data = e.response!.data as Map;
      return (data['message'] as String?) ?? 'Error inesperado.';
    }
    return 'Error de conexión.';
  }
}
