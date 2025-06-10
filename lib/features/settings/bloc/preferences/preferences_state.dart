class PreferencesState {
  final bool pushNotificationsEnabled;
  final bool faceIdEnabled;
  final String pinCode;
  final bool isPinCodeValid;

  const PreferencesState({
    this.pushNotificationsEnabled = false,
    this.faceIdEnabled = false,
    this.pinCode = '',
    this.isPinCodeValid = false,
  });

  PreferencesState copyWith({
    bool? pushNotificationsEnabled,
    bool? faceIdEnabled,
    String? pinCode,
    bool? isPinCodeValid,
  }) {
    return PreferencesState(
      pushNotificationsEnabled: pushNotificationsEnabled ?? this.pushNotificationsEnabled,
      faceIdEnabled: faceIdEnabled ?? this.faceIdEnabled,
      pinCode: pinCode ?? this.pinCode,
      isPinCodeValid: isPinCodeValid ?? this.isPinCodeValid,
    );
  }
} 