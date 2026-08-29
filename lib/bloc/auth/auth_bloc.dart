import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paynow/bloc/auth/auth_event.dart';
import 'package:paynow/bloc/auth/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  String _currentPhoneNumber = '';

  AuthBloc() : super(const AuthInitial()) {
    on<SendOtpEvent>(_onSendOtp);
    on<VerifyOtpEvent>(_onVerifyOtp);
    on<BackToPhoneStageEvent>(_onBackToPhoneStage);
    on<ResetAuthEvent>(_onResetAuth);
    on<LogoutEvent>(_onLogout);
  }

  Future<void> _onSendOtp(SendOtpEvent event, Emitter<AuthState> emit) async {
    final phone = event.phoneNumber.trim();
    if (phone.length < 10) {
      emit(const AuthError(message: 'Please enter a valid 10-digit mobile number', isOtpStage: false));
      return;
    }

    _currentPhoneNumber = phone;
    emit(const AuthLoading(isVerifyingOtp: false));

    // Simulate network delay for OTP sending
    await Future.delayed(const Duration(milliseconds: 1200));
    emit(AuthOtpSent(phoneNumber: _currentPhoneNumber));
  }

  Future<void> _onVerifyOtp(VerifyOtpEvent event, Emitter<AuthState> emit) async {
    final otp = event.otp.trim();
    if (otp.length < 4) {
      emit(const AuthError(message: 'Please enter the 4-digit code', isOtpStage: true));
      return;
    }

    emit(const AuthLoading(isVerifyingOtp: true));

    // Simulate OTP verification
    await Future.delayed(const Duration(milliseconds: 1500));
    emit(AuthSuccess(phoneNumber: _currentPhoneNumber));
  }

  void _onBackToPhoneStage(BackToPhoneStageEvent event, Emitter<AuthState> emit) {
    emit(const AuthInitial());
  }

  void _onResetAuth(ResetAuthEvent event, Emitter<AuthState> emit) {
    _currentPhoneNumber = '';
    emit(const AuthInitial());
  }

  void _onLogout(LogoutEvent event, Emitter<AuthState> emit) {
    _currentPhoneNumber = '';
    emit(const AuthInitial());
  }
}
