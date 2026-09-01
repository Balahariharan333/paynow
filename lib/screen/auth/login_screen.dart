// ignore_for_file: unused_local_variable
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paynow/bloc/auth/auth_bloc.dart';
import 'package:paynow/bloc/auth/auth_event.dart';
import 'package:paynow/bloc/auth/auth_state.dart';
import 'package:paynow/bloc/profile/profile_bloc.dart';
import 'package:paynow/bloc/profile/profile_event.dart';
import 'package:paynow/screen/onboarding/link_bank_screen.dart';
import 'package:paynow/utils/app_colors.dart';
import 'package:paynow/utils/app_constants.dart';
import 'package:paynow/utils/responsive_helper.dart';
import 'package:paynow/widget/custom_text.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final List<TextEditingController> _otpControllers = List.generate(4, (_) => TextEditingController());
  final List<FocusNode> _otpFocusNodes = List.generate(4, (_) => FocusNode());

  @override
  void dispose() {
    _phoneController.dispose();
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var node in _otpFocusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _sendOtp() {
    final phone = _phoneController.text.trim();
    if (phone.length != 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid 10-digit mobile number'),
          backgroundColor: AppColors.errorRed,
        ),
      );
      return;
    }
    context.read<AuthBloc>().add(SendOtpEvent(phone));
  }

  void _verifyOtp() {
    final String otp = _otpControllers.map((c) => c.text).join();
    context.read<AuthBloc>().add(VerifyOtpEvent(otp));
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthOtpSent) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (_otpFocusNodes.isNotEmpty && _otpFocusNodes[0].canRequestFocus) {
              _otpFocusNodes[0].requestFocus();
            }
          });
        } else if (state is AuthSuccess) {
          // Refresh profile bloc from Hive with the updated login phone number
          context.read<ProfileBloc>().add(const LoadProfileEvent());

          Future.delayed(const Duration(milliseconds: 800), () {
            if (!context.mounted) return;
            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    const LinkBankScreen(isFromOnboarding: true),
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  return FadeTransition(opacity: animation, child: child);
                },
                transitionDuration: const Duration(milliseconds: 400),
              ),
            );
          });
        }
      },
      builder: (context, state) {
        final bool isLoading = state is AuthLoading;
        final bool isOtpStage = state is AuthOtpSent ||
            (state is AuthLoading && state.isVerifyingOtp) ||
            (state is AuthError && state.isOtpStage);
        final bool isSuccess = state is AuthSuccess;
        final String errorMessage = state is AuthError ? state.message : '';

        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                  padding: EdgeInsets.symmetric(horizontal: Responsive.w(24.0)),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(height: Responsive.h(40)),
                        // App Logo or Icon
                        Center(
                          child: Container(
                            width: Responsive.w(72),
                            height: Responsive.h(72),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [AppColors.primaryGradientStart, AppColors.primaryGradientEnd],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(22),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primary.withValues(alpha: 0.25),
                                  blurRadius: 15,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.account_balance_wallet,
                              color: AppColors.white,
                              size: 36,
                            ),
                          ),
                        ),
                        SizedBox(height: Responsive.h(24)),
                        Center(
                          child: CustomText.header(
                            AppConstants.appName,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: Responsive.h(6)),
                        Center(
                          child: CustomText.subtitle(
                            AppConstants.appTagline,
                            fontSize: 14,
                          ),
                        ),
                        SizedBox(height: Responsive.h(48)),

                        // Main Interactive Card
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          child: isSuccess
                              ? _buildSuccessCard()
                              : isOtpStage
                                  ? _buildOtpCard(isLoading, errorMessage)
                                  : _buildPhoneCard(isLoading, errorMessage),
                        ),
                        SizedBox(height: Responsive.h(40)),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildPhoneCard(bool isLoading, String errorMessage) {
    return Container(
      key: const ValueKey('phoneCard'),
      padding: EdgeInsets.all(Responsive.w(24.0)),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.03),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CustomText.header('Welcome back!', fontSize: 20),
          SizedBox(height: Responsive.h(8)),
          CustomText.subtitle('Enter your mobile number to sign in or sign up.'),
          SizedBox(height: Responsive.h(24)),
          
          // Phone Input field
          Container(
            decoration: BoxDecoration(
              color: AppColors.lightGray.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.lightGray),
            ),
            padding: EdgeInsets.symmetric(horizontal: Responsive.w(16)),
            child: Row(
              children: [
                CustomText.title('+91', color: Theme.of(context).colorScheme.onSurface),
                SizedBox(width: Responsive.w(8)),
                Container(
                  width: Responsive.w(1),
                  height: Responsive.h(20),
                  color: AppColors.grayFont.withValues(alpha: 0.3),
                ),
                SizedBox(width: Responsive.w(12)),
                Expanded(
                  child: TextField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    maxLength: 10,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    decoration: InputDecoration(
                      hintText: 'Mobile number',
                      hintStyle: const TextStyle(color: AppColors.grayFont, fontWeight: FontWeight.normal),
                      counterText: '',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: Responsive.h(16)),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (errorMessage.isNotEmpty) ...[
            SizedBox(height: Responsive.h(12)),
            Text(
              errorMessage,
              style: const TextStyle(color: AppColors.errorRed, fontSize: 12),
            ),
          ],
          SizedBox(height: Responsive.h(24)),

          // Action Button
          ElevatedButton(
            onPressed: isLoading ? null : _sendOtp,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.white,
              padding: EdgeInsets.symmetric(vertical: Responsive.h(16)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 2,
            ),
            child: isLoading
                ? SizedBox(
                    width: Responsive.w(20),
                    height: Responsive.h(20),
                    child: const CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.white,
                    ),
                  )
                : const Text(
                    'Get OTP',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildOtpCard(bool isLoading, String errorMessage) {
    return Container(
      key: const ValueKey('otpCard'),
      padding: EdgeInsets.all(Responsive.w(24.0)),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.03),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  context.read<AuthBloc>().add(const BackToPhoneStageEvent());
                },
                child: Icon(Icons.arrow_back, color: Theme.of(context).colorScheme.onSurface, size: Responsive.w(20)),
              ),
              SizedBox(width: Responsive.w(12)),
              CustomText.header('Enter OTP', fontSize: 20),
            ],
          ),
          SizedBox(height: Responsive.h(8)),
          CustomText.subtitle(
            'We sent a 4-digit verification code to +91\u{00A0}${_phoneController.text}.',
          ),
          SizedBox(height: Responsive.h(24)),

          // Code Inputs Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(4, (index) {
              return SizedBox(
                width: Responsive.w(56),
                height: Responsive.h(56),
                child: TextField(
                  controller: _otpControllers[index],
                  focusNode: _otpFocusNodes[index],
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.primary),
                  maxLength: 1,
                  decoration: InputDecoration(
                    counterText: '',
                    fillColor: AppColors.lightGray.withValues(alpha: 0.5),
                    filled: true,
                    contentPadding: EdgeInsets.zero,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: Colors.transparent),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(color: AppColors.primary, width: Responsive.w(2)),
                    ),
                  ),
                  onChanged: (val) {
                    if (val.isNotEmpty) {
                      if (index < 3) {
                        _otpFocusNodes[index + 1].requestFocus();
                      } else {
                        _otpFocusNodes[index].unfocus();
                        _verifyOtp();
                      }
                    } else if (val.isEmpty && index > 0) {
                      _otpFocusNodes[index - 1].requestFocus();
                    }
                  },
                ),
              );
            }),
          ),
          
          if (errorMessage.isNotEmpty) ...[
            SizedBox(height: Responsive.h(16)),
            Text(
              errorMessage,
              style: const TextStyle(color: AppColors.errorRed, fontSize: 12),
            ),
          ],
          
          SizedBox(height: Responsive.h(24)),

          // Verify Button
          ElevatedButton(
            onPressed: isLoading ? null : _verifyOtp,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.white,
              padding: EdgeInsets.symmetric(vertical: Responsive.h(16)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 2,
            ),
            child: isLoading
                ? SizedBox(
                    width: Responsive.w(20),
                    height: Responsive.h(20),
                    child: const CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.white,
                    ),
                  )
                : const Text(
                    'Verify & Proceed',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessCard() {
    return Container(
      key: const ValueKey('successCard'),
      padding: EdgeInsets.symmetric(horizontal: Responsive.w(24.0), vertical: Responsive.h(36.0)),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.03),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: Responsive.w(72),
            height: Responsive.h(72),
            decoration: const BoxDecoration(
              color: AppColors.tintGreen,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_circle_rounded,
              color: AppColors.successGreen,
              size: 48,
            ),
          ),
          SizedBox(height: Responsive.h(20)),
          CustomText.header('Verification Complete!', fontSize: 20),
          SizedBox(height: Responsive.h(8)),
          CustomText.subtitle('Redirecting you to complete setup...', textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
