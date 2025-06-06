import 'package:equatable/equatable.dart';

class PreferencesState extends Equatable {
  final bool pushNotificationsEnabled;
  final bool faceIdEnabled;
  const PreferencesState({required this.pushNotificationsEnabled, required this.faceIdEnabled});
  @override
  List<Object?> get props => [pushNotificationsEnabled, faceIdEnabled];
} 