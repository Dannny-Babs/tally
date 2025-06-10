import 'package:flutter_bloc/flutter_bloc.dart';
import 'profile_event.dart';
import 'profile_state.dart';
import '../../repositories/profile_repository.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepository _repository;

  ProfileBloc(this._repository) : super(const ProfileState()) {
    on<ProfileLoaded>(_onProfileLoaded);
    on<ProfileUpdated>(_onProfileUpdated);
    
    // Load initial profile data
    add(ProfileLoaded());
  }

  Future<void> _onProfileLoaded(
    ProfileLoaded event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(status: ProfileStatus.loading));
    try {
      final profile = await _repository.fetchProfile();
      emit(state.copyWith(
        status: ProfileStatus.success,
        name: profile.name,
        email: profile.email,
        annualSalary: profile.annualSalary,
        taxRate: profile.taxRate,
        country: profile.country,
        currency: profile.currency,
        studentStatus: profile.studentStatus,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: ProfileStatus.error,
        errorMessage: 'Failed to load profile',
      ));
    }
  }

  Future<void> _onProfileUpdated(
    ProfileUpdated event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(status: ProfileStatus.loading));
    try {
      await _repository.updateProfile(
        name: event.name,
        email: event.email,
        annualSalary: event.annualSalary,
        taxRate: event.taxRate,
        country: event.country,
        currency: event.currency,
        studentStatus: event.studentStatus,
      );
      emit(state.copyWith(
        status: ProfileStatus.success,
        name: event.name,
        email: event.email,
        annualSalary: event.annualSalary,
        taxRate: event.taxRate,
        country: event.country,
        currency: event.currency,
        studentStatus: event.studentStatus,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: ProfileStatus.error,
        errorMessage: 'Failed to update profile',
      ));
    }
  }
} 