import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paynow/bloc/profile/profile_event.dart';
import 'package:paynow/bloc/profile/profile_state.dart';
import 'package:paynow/hive/hive_service.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(_getInitialState()) {
    on<LoadProfileEvent>(_onLoadProfile);
    on<ToggleNotificationsEvent>(_onToggleNotifications);
    on<ToggleBiometricsEvent>(_onToggleBiometrics);
    on<ToggleDarkModeEvent>(_onToggleDarkMode);
    on<UpdateMpinEvent>(_onUpdateMpin);
    on<UpdateProfilePhoneEvent>(_onUpdateProfilePhone);
  }

  static ProfileLoaded _getInitialState() {
    final profile = HiveService.getUserProfile();
    return ProfileLoaded(
      name: profile.name,
      phone: profile.phone,
      upiId: profile.upiId,
      mpin: profile.mpin,
      notificationsEnabled: profile.notificationsEnabled,
      biometricsEnabled: profile.biometricsEnabled,
      darkModeEnabled: profile.darkModeEnabled,
    );
  }

  void _onLoadProfile(LoadProfileEvent event, Emitter<ProfileState> emit) {
    final profile = HiveService.getUserProfile();
    emit(ProfileLoaded(
      name: profile.name,
      phone: profile.phone,
      upiId: profile.upiId,
      mpin: profile.mpin,
      notificationsEnabled: profile.notificationsEnabled,
      biometricsEnabled: profile.biometricsEnabled,
      darkModeEnabled: profile.darkModeEnabled,
    ));
  }

  void _onUpdateProfilePhone(UpdateProfilePhoneEvent event, Emitter<ProfileState> emit) {
    if (state is ProfileLoaded) {
      final current = state as ProfileLoaded;
      final updated = current.copyWith(phone: event.phoneNumber);
      emit(updated);

      final profile = HiveService.getUserProfile();
      HiveService.saveUserProfile(profile.copyWith(phone: event.phoneNumber));
    }
  }

  void _onUpdateMpin(UpdateMpinEvent event, Emitter<ProfileState> emit) {
    if (state is ProfileLoaded) {
      final current = state as ProfileLoaded;
      final updated = current.copyWith(mpin: event.newMpin);
      emit(updated);

      final profile = HiveService.getUserProfile();
      HiveService.saveUserProfile(profile.copyWith(mpin: event.newMpin));
    }
  }

  void _onToggleNotifications(
    ToggleNotificationsEvent event,
    Emitter<ProfileState> emit,
  ) {
    if (state is ProfileLoaded) {
      final current = state as ProfileLoaded;
      final updated = current.copyWith(notificationsEnabled: event.enabled);
      emit(updated);

      final profile = HiveService.getUserProfile();
      HiveService.saveUserProfile(profile.copyWith(notificationsEnabled: event.enabled));
    }
  }

  void _onToggleBiometrics(
    ToggleBiometricsEvent event,
    Emitter<ProfileState> emit,
  ) {
    if (state is ProfileLoaded) {
      final current = state as ProfileLoaded;
      final updated = current.copyWith(biometricsEnabled: event.enabled);
      emit(updated);

      final profile = HiveService.getUserProfile();
      HiveService.saveUserProfile(profile.copyWith(biometricsEnabled: event.enabled));
    }
  }

  void _onToggleDarkMode(
    ToggleDarkModeEvent event,
    Emitter<ProfileState> emit,
  ) {
    if (state is ProfileLoaded) {
      final current = state as ProfileLoaded;
      final updated = current.copyWith(darkModeEnabled: event.enabled);
      emit(updated);

      final profile = HiveService.getUserProfile();
      HiveService.saveUserProfile(profile.copyWith(darkModeEnabled: event.enabled));
      HiveService.saveDarkMode(event.enabled);
    }
  }
}
