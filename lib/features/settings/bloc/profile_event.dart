import 'package:equatable/equatable.dart';

abstract class ProfileEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class EditProfileRequested extends ProfileEvent {}
class SaveProfileRequested extends ProfileEvent {
  final String displayName;
  final String email;
  SaveProfileRequested(this.displayName, this.email);
  @override
  List<Object?> get props => [displayName, email];
} 