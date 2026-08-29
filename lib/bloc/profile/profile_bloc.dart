import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paynow/bloc/profile/profile_event.dart';
import 'package:paynow/bloc/profile/profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(const ProfileLoaded()) {
    on<LoadProfileEvent>(_onLoadProfile);
    on<ToggleNotificationsEvent>(_onToggleNotifications);
    on<ToggleBiometricsEvent>(_onToggleBiometrics);
    on<ToggleDarkModeEvent>(_onToggleDarkMode);
  }

  void _onLoadProfile(LoadProfileEvent event, Emitter<ProfileState> emit) {
    if (state is! ProfileLoaded) {
      emit(const ProfileLoaded());
    }
  }

  void _onToggleNotifications(
    ToggleNotificationsEvent event,
    Emitter<ProfileState> emit,
  ) {
    if (state is ProfileLoaded) {
      final current = state as ProfileLoaded;
      emit(current.copyWith(notificationsEnabled: event.enabled));
    }
  }

  void _onToggleBiometrics(
    ToggleBiometricsEvent event,
    Emitter<ProfileState> emit,
  ) {
    if (state is ProfileLoaded) {
      final current = state as ProfileLoaded;
      emit(current.copyWith(biometricsEnabled: event.enabled));
    }
  }

  void _onToggleDarkMode(
    ToggleDarkModeEvent event,
    Emitter<ProfileState> emit,
  ) {
    if (state is ProfileLoaded) {
      final current = state as ProfileLoaded;
      emit(current.copyWith(darkModeEnabled: event.enabled));
    }
  }
}
