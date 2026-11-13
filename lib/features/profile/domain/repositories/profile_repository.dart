import 'package:mobile_app_electrolink/features/profile/data/models/company_profile_response.dart';
import 'package:mobile_app_electrolink/features/profile/data/models/complete_company_profile_request.dart';

abstract class ProfileRepository {
  Future<CompanyProfileResponse> getMyProfile();
  Future<CompanyProfileResponse> completeCompanyProfile(
    CompleteCompanyProfileRequest request,
  );
}
