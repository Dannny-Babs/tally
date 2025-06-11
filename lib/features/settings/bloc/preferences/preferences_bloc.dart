import 'package:flutter_bloc/flutter_bloc.dart';
import 'preferences_event.dart';
import 'preferences_state.dart';
import '../../repositories/preferences_repository.dart';

class PreferencesBloc extends Bloc<PreferencesEvent, PreferencesState> {
  final PreferencesRepository _repository;

  PreferencesBloc(this._repository) : super(const PreferencesState()) {
    on<PushNotificationsToggled>(_onPushNotificationsToggled);
    on<FaceIdToggled>(_onFaceIdToggled);
    on<PinCodeSaved>(_onPinCodeSaved);
    on<PinCodeValidated>(_onPinCodeValidated);
  }

  Future<void> _onPushNotificationsToggled(
    PushNotificationsToggled event,
    Emitter<PreferencesState> emit,
  ) async {
    await _repository.togglePushNotifications(event.enabled);
    emit(state.copyWith(pushNotificationsEnabled: event.enabled));
  }

  Future<void> _onFaceIdToggled(
    FaceIdToggled event,
    Emitter<PreferencesState> emit,
  ) async {
    await _repository.toggleFaceId(event.enabled);
    emit(state.copyWith(faceIdEnabled: event.enabled));
  }

  Future<void> _onPinCodeSaved(
    PinCodeSaved event,
    Emitter<PreferencesState> emit,
  ) async {
    await _repository.savePinCode(event.pinCode);
    emit(state.copyWith(pinCode: event.pinCode));
  }

  Future<void> _onPinCodeValidated(
    PinCodeValidated event,
    Emitter<PreferencesState> emit,
  ) async {
    final isValid = await _repository.validatePinCode(event.pinCode);
    emit(state.copyWith(isPinCodeValid: isValid));
  }
} 