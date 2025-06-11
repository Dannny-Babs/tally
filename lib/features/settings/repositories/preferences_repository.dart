import 'base_repository.dart';

class PreferencesRepository extends BaseRepository {
  bool _pushNotificationsEnabled = true;
  bool _faceIdEnabled = false;
  String _pinCode = '';

  bool get pushNotificationsEnabled => _pushNotificationsEnabled;
  bool get faceIdEnabled => _faceIdEnabled;
  String get pinCode => _pinCode;

  Future<void> togglePushNotifications(bool value) async {
    _pushNotificationsEnabled = value;
  }

  Future<void> toggleFaceId(bool value) async {
    _faceIdEnabled = value;
  }

  Future<void> savePinCode(String pin) async {
    _pinCode = pin;
  }

  Future<bool> validatePinCode(String pin) async {
    return _pinCode == pin;
  }

  @override
  Future<void> initialize() async {
    // TODO: Load preferences from local storage
  }

  @override
  Future<void> dispose() async {
    // TODO: Save preferences to local storage
  }
} 