import 'package:equatable/equatable.dart';

enum ProfileStatus { initial, loading, success, error }

class ProfileState extends Equatable {
  final String name;
  final String email;
  final double? annualSalary;
  final double? taxRate;
  final String? country;
  final String? currency;
  final bool? studentStatus;
  final ProfileStatus status;
  final String? errorMessage;

  const ProfileState({
    this.name = '',
    this.email = '',
    this.annualSalary,
    this.taxRate,
    this.country,
    this.currency,
    this.studentStatus,
    this.status = ProfileStatus.initial,
    this.errorMessage,
  });

  ProfileState copyWith({
    String? name,
    String? email,
    double? annualSalary,
    double? taxRate,
    String? country,
    String? currency,
    bool? studentStatus,
    ProfileStatus? status,
    String? errorMessage,
  }) {
    return ProfileState(
      name: name ?? this.name,
      email: email ?? this.email,
      annualSalary: annualSalary ?? this.annualSalary,
      taxRate: taxRate ?? this.taxRate,
      country: country ?? this.country,
      currency: currency ?? this.currency,
      studentStatus: studentStatus ?? this.studentStatus,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        name,
        email,
        annualSalary,
        taxRate,
        country,
        currency,
        studentStatus,
        status,
        errorMessage,
      ];
} 