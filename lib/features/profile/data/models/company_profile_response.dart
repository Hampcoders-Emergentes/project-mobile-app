import 'package:equatable/equatable.dart';

class CompanyProfileResponse extends Equatable {
  final String profileId;
  final String userId;
  final String status;
  final String businessRole;
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String street;
  final String district;
  final String city;
  final String country;
  final String postalCode;

  const CompanyProfileResponse({
    required this.profileId,
    required this.userId,
    required this.status,
    required this.businessRole,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.street,
    required this.district,
    required this.city,
    required this.country,
    required this.postalCode,
  });

  factory CompanyProfileResponse.fromJson(Map<String, dynamic> json) {
    return CompanyProfileResponse(
      profileId: json['profileId'] as String? ?? '',
      userId: json['userId'] as String? ?? '',
      status: json['status'] as String? ?? '',
      businessRole: json['businessRole'] as String? ?? '',
      firstName: json['firstName'] as String? ?? '',
      lastName: json['lastName'] as String? ?? '',
      phoneNumber: json['phoneNumber'] as String? ?? '',
      street: json['street'] as String? ?? '',
      district: json['district'] as String? ?? '',
      city: json['city'] as String? ?? '',
      country: json['country'] as String? ?? '',
      postalCode: json['postalCode'] as String? ?? '',
    );
  }

  @override
  List<Object> get props => [profileId, userId, status];
}
