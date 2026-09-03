// ignore_for_file: unused_local_variable
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paynow/bloc/auth/auth_bloc.dart';
import 'package:paynow/bloc/auth/auth_event.dart';
import 'package:paynow/bloc/auth/auth_state.dart';
import 'package:paynow/bloc/profile/profile_bloc.dart';
import 'package:paynow/bloc/profile/profile_event.dart';
import 'package:paynow/bloc/profile/profile_state.dart';
import 'package:paynow/constants/route_constants.dart';
import 'package:paynow/utils/app_colors.dart';
import 'package:paynow/utils/responsive_helper.dart';
import 'package:paynow/widget/custom_text.dart';
import 'package:paynow/widget/custom_switch.dart';
import 'package:paynow/bloc/theme/theme_bloc.dart';
import 'package:paynow/bloc/theme/theme_event.dart';

class ProfileSettingsScreen extends StatelessWidget {
  const ProfileSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Custom App Bar
            Padding(
              padding: EdgeInsets.symmetric(horizontal: Responsive.w(16.0), vertical: Responsive.h(12.0)),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: EdgeInsets.all(Responsive.w(8.0)),
                      color: Colors.transparent,
                      child: Icon(Icons.arrow_back, color: Theme.of(context).colorScheme.onSurface,
                        size: 24,
                      ),
                    ),
                  ),
                  SizedBox(width: Responsive.w(8)),
                  CustomText.header('Profile & Settings', fontSize: 20),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                padding: EdgeInsets.symmetric(horizontal: Responsive.w(20.0)),
                child: BlocBuilder<ProfileBloc, ProfileState>(
                  builder: (context, state) {
                    final profile = state is ProfileLoaded ? state : const ProfileLoaded();
                    final authState = context.watch<AuthBloc>().state;
                    final String activeLoginPhone = authState is AuthSuccess ? authState.phoneNumber : '';

                    String displayPhone = profile.phone;
                    if (activeLoginPhone.isNotEmpty) {
                      final digits = activeLoginPhone.replaceAll(RegExp(r'[^0-9]'), '');
                      if (digits.length == 10) {
                        displayPhone = '+91 ${digits.substring(0, 5)} ${digits.substring(5)}';
                      } else if (digits.length > 10 && digits.startsWith('91')) {
                        final sub = digits.substring(2);
                        if (sub.length == 10) {
                          displayPhone = '+91 ${sub.substring(0, 5)} ${sub.substring(5)}';
                        }
                      } else {
                        displayPhone = activeLoginPhone.startsWith('+') ? activeLoginPhone : '+91 $activeLoginPhone';
                      }
                    }

                    final cleanDigits = displayPhone.replaceAll(RegExp(r'[^0-9]'), '');
                    final displayUpiId = cleanDigits.isNotEmpty ? '$cleanDigits@paynow' : profile.upiId;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: Responsive.h(12)),
                        
                        // Profile Header card (Tappable to Edit)
                        GestureDetector(
                          onTap: () => _showEditProfileSheet(context, profile.name, profile.email),
                          child: Container(
                            padding: EdgeInsets.all(Responsive.w(20.0)),
                            decoration: BoxDecoration(
                              color: Theme.of(context).cardColor,
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: Responsive.w(60),
                                  height: Responsive.h(60),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFACC15), // Yellow from designs
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.2), width: Responsive.w(1.5)),
                                  ),
                                  child: Center(
                                    child: Text(
                                      profile.name.isNotEmpty ? profile.name[0] : 'U',
                                      style: const TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.black,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: Responsive.w(16)),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      CustomText.header(profile.name, fontSize: 18),
                                      SizedBox(height: Responsive.h(4)),
                                      CustomText.subtitle(displayPhone, fontSize: 13),
                                      SizedBox(height: Responsive.h(2)),
                                      CustomText.subtitle(displayUpiId, fontSize: 12, color: AppColors.primary),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary.withValues(alpha: 0.1),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.edit_outlined,
                                    color: AppColors.primary,
                                    size: 18,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: Responsive.h(24)),

                        // Section: Payment Settings
                        CustomText.header('Payment Accounts', fontSize: 14, color: AppColors.grayFont),
                        SizedBox(height: Responsive.h(12)),
                        _buildNavigationItem(
                          context,
                          icon: Icons.account_balance,
                          title: 'Bank Accounts',
                          subtitle: 'Add or manage linked bank accounts',
                          onTap: () => Navigator.pushNamed(context, RouteConstants.bankAccounts),
                        ),
                        SizedBox(height: Responsive.h(12)),
                        _buildNavigationItem(
                          context,
                          icon: Icons.credit_card,
                          title: 'Credit & Debit Cards',
                          subtitle: 'Manage card limits and lock state',
                          onTap: () => Navigator.pushNamed(context, RouteConstants.cardDetails),
                        ),
                        SizedBox(height: Responsive.h(24)),

                        // Section: App Preferences
                        CustomText.header('Security & Preferences', fontSize: 14, color: AppColors.grayFont),
                        SizedBox(height: Responsive.h(12)),
                        _buildNavigationItem(
                          context,
                          icon: Icons.pin_outlined,
                          title: 'App & Card MPIN',
                          subtitle: 'Change your 4-digit security MPIN',
                          onTap: () => _showChangeMpinDialog(context, profile.mpin),
                        ),
                        SizedBox(height: Responsive.h(12)),
                        _buildToggleItem(
                          context,
                          icon: Icons.notifications_active_outlined,
                          title: 'Push Notifications',
                          value: profile.notificationsEnabled,
                          onChanged: (val) {
                            context.read<ProfileBloc>().add(ToggleNotificationsEvent(val));
                          },
                        ),
                        SizedBox(height: Responsive.h(12)),
                        _buildToggleItem(
                          context,
                          icon: Icons.fingerprint,
                          title: 'Biometric Authentication',
                          value: profile.biometricsEnabled,
                          onChanged: (val) {
                            context.read<ProfileBloc>().add(ToggleBiometricsEvent(val));
                          },
                        ),
                        SizedBox(height: Responsive.h(12)),
                        _buildToggleItem(
                          context,
                          icon: Icons.dark_mode_outlined,
                          title: 'Dark Mode',
                          value: Theme.of(context).brightness == Brightness.dark,
                          onChanged: (val) {
                            context.read<ThemeBloc>().add(SetThemeModeEvent(val ? ThemeMode.dark : ThemeMode.light));
                            context.read<ProfileBloc>().add(ToggleDarkModeEvent(val));
                            ScaffoldMessenger.of(context).clearSnackBars();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(val ? 'Dark mode activated' : 'Light mode activated'),
                                duration: const Duration(seconds: 1),
                              ),
                            );
                          },
                        ),
                        SizedBox(height: Responsive.h(24)),

                        // Section: Danger Zone / Actions
                        CustomText.header('Account Actions', fontSize: 14, color: AppColors.grayFont),
                        SizedBox(height: Responsive.h(12)),
                        GestureDetector(
                          onTap: () => _showLogoutDialog(context),
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: Responsive.w(16), vertical: Responsive.h(16)),
                            decoration: BoxDecoration(
                              color: Theme.of(context).cardColor,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.logout,
                                  color: AppColors.errorRed,
                                  size: 22,
                                ),
                                SizedBox(width: Responsive.w(16)),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      CustomText.title('Log Out', fontSize: 14, color: AppColors.errorRed),
                                      SizedBox(height: Responsive.h(2)),
                                      CustomText.subtitle('Sign out of your PayNow account', fontSize: 11),
                                    ],
                                  ),
                                ),
                                const Icon(
                                  Icons.chevron_right,
                                  color: AppColors.grayFont,
                                  size: 20,
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: Responsive.h(40)),
                        
                        // App Version Footer
                        Center(
                          child: Column(
                            children: [
                              CustomText.subtitle('PayNow v1.0.0', fontSize: 12),
                              SizedBox(height: Responsive.h(4)),
                              CustomText.subtitle('© 2026 PayNow Technologies', fontSize: 11),
                            ],
                          ),
                        ),
                        SizedBox(height: Responsive.h(40)),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavigationItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(Responsive.w(16)),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: AppColors.primary,
              size: 22,
            ),
            SizedBox(width: Responsive.w(16)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText.title(title, fontSize: 14),
                  SizedBox(height: Responsive.h(2)),
                  CustomText.subtitle(subtitle, fontSize: 11),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right,
              color: AppColors.grayFont,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: Responsive.w(16), vertical: Responsive.h(10)),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: value ? AppColors.primary : AppColors.grayFont,
            size: 22,
          ),
          SizedBox(width: Responsive.w(16)),
          Expanded(
            child: CustomText.title(title, fontSize: 14),
          ),
          CustomSwitch(
            value: value,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  void _showChangeMpinDialog(BuildContext context, String currentMpin) {
    final currentPinController = TextEditingController();
    final newPinController = TextEditingController();
    final confirmPinController = TextEditingController();
    String? errorMessage;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext modalContext) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: EdgeInsets.only(
                left: Responsive.w(24),
                right: Responsive.w(24),
                top: Responsive.h(24),
                bottom: MediaQuery.of(context).viewInsets.bottom + Responsive.h(24),
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: Responsive.w(40),
                      height: Responsive.h(4),
                      decoration: BoxDecoration(
                        color: AppColors.grayFont.withValues(alpha: 0.4),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  SizedBox(height: Responsive.h(16)),
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(Responsive.w(8)),
                        decoration: BoxDecoration(
                          color: AppColors.tintBlue,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.lock_outline, color: AppColors.primary, size: 20),
                      ),
                      SizedBox(width: Responsive.w(12)),
                      CustomText.header('Change App MPIN', fontSize: 18),
                    ],
                  ),
                  SizedBox(height: Responsive.h(8)),
                  CustomText.subtitle('Enter current MPIN and set a new 4-digit security PIN', fontSize: 12),
                  if (errorMessage != null) ...[
                    SizedBox(height: Responsive.h(12)),
                    Container(
                      padding: EdgeInsets.all(Responsive.w(10)),
                      decoration: BoxDecoration(
                        color: AppColors.tintRed,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.error_outline, color: AppColors.errorRed, size: 16),
                          SizedBox(width: Responsive.w(8)),
                          Expanded(
                            child: CustomText.body(errorMessage!, color: AppColors.errorRed, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ],
                  SizedBox(height: Responsive.h(16)),
                  TextField(
                    controller: currentPinController,
                    keyboardType: TextInputType.number,
                    obscureText: true,
                    maxLength: 4,
                    decoration: InputDecoration(
                      labelText: 'Current 4-digit MPIN',
                      hintText: 'Default: 1234',
                      counterText: '',
                      prefixIcon: const Icon(Icons.pin, size: 20),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                  ),
                  SizedBox(height: Responsive.h(12)),
                  TextField(
                    controller: newPinController,
                    keyboardType: TextInputType.number,
                    obscureText: true,
                    maxLength: 4,
                    decoration: InputDecoration(
                      labelText: 'New 4-digit MPIN',
                      hintText: 'e.g. 5678',
                      counterText: '',
                      prefixIcon: const Icon(Icons.key, size: 20),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                  ),
                  SizedBox(height: Responsive.h(12)),
                  TextField(
                    controller: confirmPinController,
                    keyboardType: TextInputType.number,
                    obscureText: true,
                    maxLength: 4,
                    decoration: InputDecoration(
                      labelText: 'Confirm New MPIN',
                      hintText: 'Re-enter new 4-digit PIN',
                      counterText: '',
                      prefixIcon: const Icon(Icons.check_circle_outline, size: 20),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                  ),
                  SizedBox(height: Responsive.h(20)),
                  SizedBox(
                    width: double.infinity,
                    height: Responsive.h(50),
                    child: ElevatedButton(
                      onPressed: () {
                        final curr = currentPinController.text.trim();
                        final next = newPinController.text.trim();
                        final conf = confirmPinController.text.trim();

                        if (curr != currentMpin) {
                          setModalState(() {
                            errorMessage = 'Current MPIN is incorrect.';
                          });
                          return;
                        }
                        if (next.length != 4) {
                          setModalState(() {
                            errorMessage = 'New MPIN must be exactly 4 digits.';
                          });
                          return;
                        }
                        if (next != conf) {
                          setModalState(() {
                            errorMessage = 'New MPIN and Confirm MPIN do not match.';
                          });
                          return;
                        }

                        // Save MPIN
                        context.read<ProfileBloc>().add(UpdateMpinEvent(next));
                        Navigator.pop(modalContext);
                        ScaffoldMessenger.of(context).clearSnackBars();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('App MPIN updated successfully!'),
                            backgroundColor: AppColors.successGreen,
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      child: CustomText.title('Save New MPIN', color: AppColors.white, fontSize: 15),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showEditProfileSheet(BuildContext context, String currentName, String currentEmail) {
    final nameController = TextEditingController(text: currentName);
    final emailController = TextEditingController(text: currentEmail);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          ),
          padding: EdgeInsets.only(
            left: Responsive.w(20),
            right: Responsive.w(20),
            top: Responsive.h(20),
            bottom: MediaQuery.of(sheetContext).viewInsets.bottom + Responsive.h(24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.grayFont.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              SizedBox(height: Responsive.h(16)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText.header('Edit Profile Details', fontSize: 18),
                  IconButton(
                    icon: const Icon(Icons.close, size: 20, color: AppColors.grayFont),
                    onPressed: () => Navigator.pop(sheetContext),
                  ),
                ],
              ),
              CustomText.body(
                'Personalize your display name and email address.',
                fontSize: 12,
                color: AppColors.grayFont,
              ),
              SizedBox(height: Responsive.h(20)),
              CustomText.title('Full Name', fontSize: 13),
              SizedBox(height: Responsive.h(8)),
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  hintText: 'Enter your full name',
                  filled: true,
                  fillColor: Theme.of(context).brightness == Brightness.dark ? Colors.white10 : const Color(0xFFF8FAFC),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  contentPadding: EdgeInsets.symmetric(horizontal: Responsive.w(14), vertical: Responsive.h(12)),
                ),
              ),
              SizedBox(height: Responsive.h(16)),
              CustomText.title('Email Address', fontSize: 13),
              SizedBox(height: Responsive.h(8)),
              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: 'e.g. user@paynow.com',
                  filled: true,
                  fillColor: Theme.of(context).brightness == Brightness.dark ? Colors.white10 : const Color(0xFFF8FAFC),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  contentPadding: EdgeInsets.symmetric(horizontal: Responsive.w(14), vertical: Responsive.h(12)),
                ),
              ),
              SizedBox(height: Responsive.h(24)),
              SizedBox(
                width: double.infinity,
                height: Responsive.h(50),
                child: ElevatedButton(
                  onPressed: () {
                    final newName = nameController.text.trim();
                    final newEmail = emailController.text.trim();

                    if (newName.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please enter your name'),
                          backgroundColor: AppColors.errorRed,
                        ),
                      );
                      return;
                    }

                    context.read<ProfileBloc>().add(UpdateProfileDetailsEvent(
                          name: newName,
                          email: newEmail.isNotEmpty ? newEmail : 'user@paynow.com',
                        ));

                    Navigator.pop(sheetContext);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Profile details updated successfully!'),
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: CustomText.title('Save Changes', color: AppColors.white, fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: Theme.of(dialogContext).cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          title: CustomText.header('Confirm Log Out', fontSize: 18),
          content: CustomText.body('Are you sure you want to log out of the application?', color: AppColors.grayFont),
          actionsPadding: EdgeInsets.symmetric(horizontal: Responsive.w(16), vertical: Responsive.h(12)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: CustomText.title('Cancel', color: AppColors.grayFont, fontSize: 14),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(dialogContext); // Close dialog
                context.read<AuthBloc>().add(const LogoutEvent());
                
                // Clear state and redirect to login screen
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  RouteConstants.login,
                  (route) => false,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.errorRed,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: CustomText.title('Log Out', color: AppColors.white, fontSize: 14),
            ),
          ],
        );
      },
    );
  }
}
