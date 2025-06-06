import 'package:equatable/equatable.dart';

class PreferencesState extends Equatable {
  final bool pushNotificationsEnabled;
  final bool faceIdEnabled;
  final String pinError;
  final bool pinSaved;
  final bool logoutConfirmed;
  const PreferencesState({
    required this.pushNotificationsEnabled,
    required this.faceIdEnabled,
    this.pinError = '',
    this.pinSaved = false,
    this.logoutConfirmed = false,
  });
  @override
  List<Object?> get props => [pushNotificationsEnabled, faceIdEnabled, pinError, pinSaved, logoutConfirmed];
} 