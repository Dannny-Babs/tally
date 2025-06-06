import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

// Events
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

// State
class PreferencesState extends Equatable {
  final bool pushNotificationsEnabled;
  final bool faceIdEnabled;
  const PreferencesState({required this.pushNotificationsEnabled, required this.faceIdEnabled});
  @override
  List<Object?> get props => [pushNotificationsEnabled, faceIdEnabled];
}

// Bloc
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