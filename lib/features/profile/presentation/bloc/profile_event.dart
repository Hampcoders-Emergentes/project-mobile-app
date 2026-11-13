import 'package:equatable/equatable.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

class LoadProfile extends ProfileEvent {}

class CompleteCompanyProfile extends ProfileEvent {
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

  const CompleteCompanyProfile({
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
  });

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
