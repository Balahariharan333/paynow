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
