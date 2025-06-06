import 'package:equatable/equatable.dart';

abstract class PreferencesEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class PushNotificationsToggled extends PreferencesEvent {
  final bool value;
  PushNotificationsToggled(this.value);
  @override
  List<Object?> get props => [value];
}

class FaceIdToggled extends PreferencesEvent {
  final bool value;
  FaceIdToggled(this.value);
  @override
  List<Object?> get props => [value];
}

class PinCodeTapped extends PreferencesEvent {}
class SavePinRequested extends PreferencesEvent {
  final String pin;
  final String confirmPin;
  SavePinRequested(this.pin, this.confirmPin);
  @override
  List<Object?> get props => [pin, confirmPin];
}
class PinModalClosed extends PreferencesEvent {}
class LogoutRequested extends PreferencesEvent {} 