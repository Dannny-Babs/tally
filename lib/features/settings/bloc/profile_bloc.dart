import 'package:flutter_bloc/flutter_bloc.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc()
      : super(const ProfileState(
          displayName: 'Daniel Baker',
          email: 'daniel.baker@gmail.com',
        )) {
    on<EditProfileRequested>((event, emit) {
      // Could load profile data here
    });
    on<SaveProfileRequested>((event, emit) {
      if (event.displayName.isEmpty || event.email.isEmpty) {
        emit(ProfileState(
          displayName: state.displayName,
          email: state.email,
          profileError: 'Fields cannot be empty',
          profileSaved: false,
        ));
      } else {
        emit(ProfileState(
          displayName: event.displayName,
          email: event.email,
          profileError: null,
          profileSaved: true,
        ));
      }
    });
  }
} 