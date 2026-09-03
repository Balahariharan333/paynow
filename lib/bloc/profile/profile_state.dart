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
  final String email;
  final String phone;
  final String upiId;
  final String mpin;
  final bool notificationsEnabled;
  final bool biometricsEnabled;
  final bool darkModeEnabled;

  const ProfileLoaded({
    this.name = 'PayNow User',
    this.email = 'user@paynow.com',
    this.phone = '+91 98765 43210',
    this.upiId = 'user@paynow',
    this.mpin = '1234',
    this.notificationsEnabled = true,
    this.biometricsEnabled = false,
    this.darkModeEnabled = false,
  });

  ProfileLoaded copyWith({
    String? name,
    String? email,
    String? phone,
    String? upiId,
    String? mpin,
    bool? notificationsEnabled,
    bool? biometricsEnabled,
    bool? darkModeEnabled,
  }) {
    return ProfileLoaded(
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      upiId: upiId ?? this.upiId,
      mpin: mpin ?? this.mpin,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      biometricsEnabled: biometricsEnabled ?? this.biometricsEnabled,
      darkModeEnabled: darkModeEnabled ?? this.darkModeEnabled,
    );
  }

  @override
  List<Object?> get props => [
        name,
        email,
        phone,
        upiId,
        mpin,
        notificationsEnabled,
        biometricsEnabled,
        darkModeEnabled,
      ];
}
