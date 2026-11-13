import 'package:equatable/equatable.dart';

class CompleteCompanyProfileRequest extends Equatable {
  final String companyName;
  final String taxId;
  final String phoneNumber;
  final String email;
  final String billingStreet;
  final String billingNumber;
  final String billingDistrict;
  final String billingCity;
  final String billingCountry;
  final String billingPostalCode;
  final String industry;
  final int companySize;
  final String website;

  const CompleteCompanyProfileRequest({
    required this.companyName,
    required this.taxId,
    required this.phoneNumber,
    required this.email,
    required this.billingStreet,
    required this.billingNumber,
    required this.billingDistrict,
    required this.billingCity,
    required this.billingCountry,
    required this.billingPostalCode,
    this.industry = '',
    this.companySize = 2,
    this.website = '',
  });

  Map<String, dynamic> toJson() => {
        'companyName': companyName,
        'taxId': taxId,
        'phoneNumber': phoneNumber,
        'email': email,
        'billingStreet': billingStreet,
        'billingNumber': billingNumber,
        'billingDistrict': billingDistrict,
        'billingCity': billingCity,
        'billingCountry': billingCountry,
        'billingPostalCode': billingPostalCode,
        'industry': industry,
        'companySize': companySize,
        'website': website,
      };

  @override
  List<Object> get props => [
        companyName,
        taxId,
        phoneNumber,
        email,
        billingStreet,
        billingNumber,
        billingDistrict,
        billingCity,
        billingCountry,
        billingPostalCode,
      ];
}
