import 'package:flutter_bloc/flutter_bloc.dart';
import 'preferences_event.dart';
import 'preferences_state.dart';

class PreferencesBloc extends Bloc<PreferencesEvent, PreferencesState> {
  PreferencesBloc() : super(const PreferencesState(pushNotificationsEnabled: false, faceIdEnabled: false)) {
    on<PushNotificationsToggled>((event, emit) {
      emit(PreferencesState(
        pushNotificationsEnabled: event.value,
        faceIdEnabled: state.faceIdEnabled,
      ));
    });
    on<FaceIdToggled>((event, emit) {
      emit(PreferencesState(
        pushNotificationsEnabled: state.pushNotificationsEnabled,
        faceIdEnabled: event.value,
      ));
    });
    on<PinCodeTapped>((event, emit) {
      // Navigation or logic for PIN code can be handled here
    });
  }
} 