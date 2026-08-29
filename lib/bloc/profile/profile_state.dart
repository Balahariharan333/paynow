import 'package:equatable/equatable.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

class ProfileInitial extends ProfileState {
  const ProfileInitial();
}

class ProfileLoaded extends ProfileState {
  final String name;
  final String phone;
  final String upiId;
  final bool notificationsEnabled;
  final bool biometricsEnabled;
  final bool darkModeEnabled;

  const ProfileLoaded({
    this.name = 'Alex',
    this.phone = '+91 98765 43210',
    this.upiId = 'alex@paynow',
    this.notificationsEnabled = true,
    this.biometricsEnabled = false,
    this.darkModeEnabled = false,
  });

  ProfileLoaded copyWith({
    String? name,
    String? phone,
    String? upiId,
    bool? notificationsEnabled,
    bool? biometricsEnabled,
    bool? darkModeEnabled,
  }) {
    return ProfileLoaded(
      name: name ?? this.name,
      phone: phone ?? this.phone,
      upiId: upiId ?? this.upiId,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      biometricsEnabled: biometricsEnabled ?? this.biometricsEnabled,
      darkModeEnabled: darkModeEnabled ?? this.darkModeEnabled,
    );
  }

  @override
  List<Object?> get props => [
        name,
        phone,
        upiId,
        notificationsEnabled,
        biometricsEnabled,
        darkModeEnabled,
      ];
}
