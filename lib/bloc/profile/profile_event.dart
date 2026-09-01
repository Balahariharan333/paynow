import 'package:equatable/equatable.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

class LoadProfileEvent extends ProfileEvent {
  const LoadProfileEvent();
}

class ToggleNotificationsEvent extends ProfileEvent {
  final bool enabled;

  const ToggleNotificationsEvent(this.enabled);

  @override
  List<Object?> get props => [enabled];
}

class ToggleBiometricsEvent extends ProfileEvent {
  final bool enabled;

  const ToggleBiometricsEvent(this.enabled);

  @override
  List<Object?> get props => [enabled];
}

class ToggleDarkModeEvent extends ProfileEvent {
  final bool enabled;

  const ToggleDarkModeEvent(this.enabled);

  @override
  List<Object?> get props => [enabled];
}

class UpdateMpinEvent extends ProfileEvent {
  final String newMpin;

  const UpdateMpinEvent(this.newMpin);

  @override
  List<Object?> get props => [newMpin];
}

class UpdateProfilePhoneEvent extends ProfileEvent {
  final String phoneNumber;

  const UpdateProfilePhoneEvent(this.phoneNumber);

  @override
  List<Object?> get props => [phoneNumber];
}
