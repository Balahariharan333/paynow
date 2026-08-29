import 'package:equatable/equatable.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoading extends AuthState {
  final bool isVerifyingOtp;

  const AuthLoading({this.isVerifyingOtp = false});

  @override
  List<Object?> get props => [isVerifyingOtp];
}

class AuthOtpSent extends AuthState {
  final String phoneNumber;

  const AuthOtpSent({required this.phoneNumber});

  @override
  List<Object?> get props => [phoneNumber];
}

class AuthSuccess extends AuthState {
  final String phoneNumber;

  const AuthSuccess({required this.phoneNumber});

  @override
  List<Object?> get props => [phoneNumber];
}

class AuthError extends AuthState {
  final String message;
  final bool isOtpStage;

  const AuthError({required this.message, this.isOtpStage = false});

  @override
  List<Object?> get props => [message, isOtpStage];
}
