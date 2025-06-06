import 'package:equatable/equatable.dart';

class ProfileState extends Equatable {
  final String displayName;
  final String email;
  final String? profileError;
  final bool profileSaved;
  const ProfileState({
    required this.displayName,
    required this.email,
    this.profileError,
    this.profileSaved = false,
  });
  @override
  List<Object?> get props => [displayName, email, profileError, profileSaved];
} 