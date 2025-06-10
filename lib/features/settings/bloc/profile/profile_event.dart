import 'package:equatable/equatable.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

class ProfileLoaded extends ProfileEvent {}

class ProfileUpdated extends ProfileEvent {
  final String name;
  final String email;
  final double annualSalary;
  final double taxRate;
  final String? country;
  final String? currency;
  final bool studentStatus;

  const ProfileUpdated({
    required this.name,
    required this.email,
    required this.annualSalary,
    required this.taxRate,
    this.country,
    this.currency,
    required this.studentStatus,
  });

  @override
  List<Object?> get props => [
        name,
        email,
        annualSalary,
        taxRate,
        country,
        currency,
        studentStatus,
      ];
} 