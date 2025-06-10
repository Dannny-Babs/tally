abstract class PreferencesEvent {
  const PreferencesEvent();
}

class PushNotificationsToggled extends PreferencesEvent {
  final bool enabled;
  const PushNotificationsToggled(this.enabled);
}

class FaceIdToggled extends PreferencesEvent {
  final bool enabled;
  const FaceIdToggled(this.enabled);
}

class PinCodeSaved extends PreferencesEvent {
  final String pinCode;
  const PinCodeSaved(this.pinCode);
}

class PinCodeValidated extends PreferencesEvent {
  final String pinCode;
  const PinCodeValidated(this.pinCode);
} 