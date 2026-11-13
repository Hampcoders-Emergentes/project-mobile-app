import 'package:mobile_app_electrolink/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:mobile_app_electrolink/features/profile/data/models/company_profile_response.dart';
import 'package:mobile_app_electrolink/features/profile/data/models/complete_company_profile_request.dart';
import 'package:mobile_app_electrolink/features/profile/domain/repositories/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource _dataSource;

  ProfileRepositoryImpl() : _dataSource = ProfileRemoteDataSource();

  @override
  Future<CompanyProfileResponse> getMyProfile() async {
    return await _dataSource.getMyProfile();
  }

  @override
  Future<CompanyProfileResponse> completeCompanyProfile(
    CompleteCompanyProfileRequest request,
  ) async {
    return await _dataSource.completeCompanyProfile(request);
  }
}
