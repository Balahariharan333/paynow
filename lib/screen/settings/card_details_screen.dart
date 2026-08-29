// ignore_for_file: unused_local_variable
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paynow/bloc/wallet/wallet_bloc.dart';
import 'package:paynow/bloc/wallet/wallet_event.dart';
import 'package:paynow/bloc/wallet/wallet_state.dart';
import 'package:paynow/utils/app_colors.dart';
import 'package:paynow/utils/responsive_helper.dart';
import 'package:paynow/widget/custom_text.dart';
import 'package:paynow/widget/custom_switch.dart';

class CardDetailsScreen extends StatefulWidget {
  const CardDetailsScreen({super.key});

  @override
  State<CardDetailsScreen> createState() => _CardDetailsScreenState();
}

class _CardDetailsScreenState extends State<CardDetailsScreen> {
  bool _showCardDetails = false;

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(Responsive.w(20.0)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildAnimatedCardSection(),
                    SizedBox(height: Responsive.h(28)),
                    _buildFreezeControlSection(),
                    SizedBox(height: Responsive.h(24)),
                    _buildLimitsSection(),
                    SizedBox(height: Responsive.h(24)),
                    _buildSecurityInfoSection(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Responsive.w(16.0), vertical: Responsive.h(12.0)),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: EdgeInsets.all(Responsive.w(8.0)),
              child: Icon(Icons.arrow_back, color: Theme.of(context).colorScheme.onSurface,
                size: 24,
              ),
            ),
          ),
          SizedBox(width: Responsive.w(8)),
          CustomText.header('Card Controls', fontSize: 20),
        ],
      ),
    );
  }

  Widget _buildAnimatedCardSection() {
    return BlocBuilder<WalletBloc, WalletState>(
      builder: (context, state) {
        final bool isFrozen = state is WalletLoaded ? state.isCardFrozen : false;

        return Stack(
          alignment: Alignment.center,
          children: [
            // Base Card Container
            Container(
              width: double.infinity,
              height: Responsive.h(210),
              padding: EdgeInsets.all(Responsive.w(24)),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: LinearGradient(
                  colors: [
                    AppColors.primaryGradientStart,
                    AppColors.primaryGradientEnd,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryGradientEnd.withValues(alpha: 0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText.title(
                        'Platinum Card',
                        color: AppColors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                      const Icon(
                        Icons.contactless,
                        color: AppColors.white,
                        size: 22,
                      ),
                    ],
                  ),
                  const Spacer(),
                  // Card Number
                  CustomText.header(
                    _showCardDetails ? '4912  8834  1028  9982' : '••••  ••••  ••••  9982',
                    color: AppColors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText.body(
                            'CARD HOLDER',
                            color: AppColors.white.withValues(alpha: 0.7),
                            fontSize: 9,
                            fontWeight: FontWeight.w500,
                          ),
                          SizedBox(height: Responsive.h(2)),
                          CustomText.title(
                            'ALEXANDER PAYNE',
                            color: AppColors.white,
                            fontSize: 12,
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText.body(
                            'EXPIRES',
                            color: AppColors.white.withValues(alpha: 0.7),
                            fontSize: 9,
                            fontWeight: FontWeight.w500,
                          ),
                          SizedBox(height: Responsive.h(2)),
                          CustomText.title(
                            '08/28',
                            color: AppColors.white,
                            fontSize: 12,
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText.body(
                            'CVV',
                            color: AppColors.white.withValues(alpha: 0.7),
                            fontSize: 9,
                            fontWeight: FontWeight.w500,
                          ),
                          SizedBox(height: Responsive.h(2)),
                          CustomText.title(
                            _showCardDetails ? '883' : '•••',
                            color: AppColors.white,
                            fontSize: 12,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // Glassmorphism Frost Overlay when Frozen
            if (isFrozen)
              ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                  child: Container(
                    width: double.infinity,
                    height: Responsive.h(210),
                    color: Colors.white.withValues(alpha: 0.15),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: EdgeInsets.all(Responsive.w(12)),
                            decoration: const BoxDecoration(
                              color: AppColors.white,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.lock,
                              color: AppColors.errorRed,
                              size: 28,
                            ),
                          ),
                          SizedBox(height: Responsive.h(8)),
                          CustomText.title(
                            'CARD FROZEN',
                            color: AppColors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildFreezeControlSection() {
    return Container(
      padding: EdgeInsets.all(Responsive.w(20)),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: Responsive.w(44),
                    height: Responsive.h(44),
                    decoration: const BoxDecoration(
                      color: AppColors.tintRed,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.ac_unit,
                      color: AppColors.errorRed,
                      size: 20,
                    ),
                  ),
                  SizedBox(width: Responsive.w(14)),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText.title('Freeze Card', fontSize: 14),
                      SizedBox(height: Responsive.h(2)),
                      CustomText.subtitle('Temporary block withdrawals', fontSize: 11),
                    ],
                  ),
                ],
              ),
              BlocBuilder<WalletBloc, WalletState>(
                builder: (context, state) {
                  final bool isFrozen = state is WalletLoaded ? state.isCardFrozen : false;
                  return CustomSwitch(
                    value: isFrozen,
                    activeThumbColor: AppColors.errorRed,
                    activeTrackColor: AppColors.tintRed,
                    onChanged: (val) {
                      context.read<WalletBloc>().add(ToggleFreezeCardEvent(val));
                      ScaffoldMessenger.of(context).clearSnackBars();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(val ? 'Card Frozen successfully' : 'Card Unfrozen successfully'),
                          duration: const Duration(seconds: 1),
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
          Divider(height: Responsive.h(32)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: Responsive.w(44),
                    height: Responsive.h(44),
                    decoration: const BoxDecoration(
                      color: AppColors.lightBlue,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.visibility_outlined,
                      color: AppColors.primary,
                      size: 20,
                    ),
                  ),
                  SizedBox(width: Responsive.w(14)),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText.title('View Credentials', fontSize: 14),
                      SizedBox(height: Responsive.h(2)),
                      CustomText.subtitle('Show details and CVV', fontSize: 11),
                    ],
                  ),
                ],
              ),
              CustomSwitch(
                value: _showCardDetails,
                activeThumbColor: AppColors.primary,
                activeTrackColor: AppColors.tintBlue,
                onChanged: (val) {
                  setState(() {
                    _showCardDetails = val;
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLimitsSection() {
    return Container(
      padding: EdgeInsets.all(Responsive.w(20)),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.tune, color: AppColors.primary, size: Responsive.w(20)),
              SizedBox(width: Responsive.w(8)),
              CustomText.title('Monthly Spending Limit', fontSize: 15),
            ],
          ),
          SizedBox(height: Responsive.h(16)),
          BlocBuilder<WalletBloc, WalletState>(
            builder: (context, state) {
              final double limit = state is WalletLoaded ? state.dailyLimit : 50000.00;
              return Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText.subtitle('Daily Limit', fontSize: 12),
                      CustomText.title(
                        'Rs ${limit.toStringAsFixed(0)}',
                        fontSize: 14,
                        color: AppColors.primary,
                      ),
                    ],
                  ),
                  Slider(
                    value: limit,
                    min: 5000,
                    max: 100000,
                    divisions: 19,
                    activeColor: AppColors.primary,
                    inactiveColor: AppColors.lightGray,
                    onChanged: (val) {
                      context.read<WalletBloc>().add(UpdateDailyLimitEvent(val));
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText.subtitle('Min Rs 5k', fontSize: 10),
                      CustomText.subtitle('Max Rs 100k', fontSize: 10),
                    ],
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSecurityInfoSection() {
    return Container(
      padding: EdgeInsets.all(Responsive.w(16)),
      decoration: BoxDecoration(
        color: const Color(0xFFF0FDF4), // Success Light Green Background
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFBBF7D0)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.verified_user_outlined,
            color: Color(0xFF16A34A),
            size: 20,
          ),
          SizedBox(width: Responsive.w(12)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText.title(
                  'Bank Grade Protection',
                  color: const Color(0xFF16A34A),
                  fontSize: 13,
                ),
                SizedBox(height: Responsive.h(4)),
                CustomText.body(
                  'Your card details are fully encrypted. Freezing your card locks physical transactions instantly.',
                  color: const Color(0xFF15803D),
                  fontSize: 11,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
