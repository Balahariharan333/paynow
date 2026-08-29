// ignore_for_file: unused_local_variable
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paynow/bloc/transaction/transaction_bloc.dart';
import 'package:paynow/bloc/transaction/transaction_state.dart';
import 'package:paynow/bloc/wallet/wallet_bloc.dart';
import 'package:paynow/bloc/wallet/wallet_state.dart';
import 'package:paynow/screen/home/history_screen.dart';
import 'package:paynow/screen/home/notifications_screen.dart';
import 'package:paynow/screen/payment/bills/bills_dashboard_screen.dart';
import 'package:paynow/screen/payment/transfer/transfer_home_screen.dart';
import 'package:paynow/screen/payment/wallet/add_money_screen.dart';
import 'package:paynow/screen/payment/wallet/withdraw_screen.dart';
import 'package:paynow/screen/profile/profile_settings_screen.dart';
import 'package:paynow/screen/settings/card_details_screen.dart';
import 'package:paynow/screen/transaction/transaction_details_screen.dart';
import 'package:paynow/utils/app_colors.dart';
import 'package:paynow/utils/responsive_helper.dart';
import 'package:paynow/widget/custom_text.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
            left: Responsive.w(20.0),
            right: Responsive.w(20.0),
            top: MediaQuery.of(context).padding.top + Responsive.h(12.0),
            bottom: Responsive.w(20.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              SizedBox(height: Responsive.h(24)),
              _buildWalletCard(context),
              SizedBox(height: Responsive.h(20)),
              _buildSummaryCards(context),
              SizedBox(height: Responsive.h(24)),
              _buildQuickActions(context),
              SizedBox(height: Responsive.h(24)),
              _buildPromoBanner(context),
              SizedBox(height: Responsive.h(24)),
              _buildRecentTransactions(context),
              SizedBox(height: Responsive.h(80)), // Padding for Bottom Nav Bar
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ProfileSettingsScreen()),
                  );
                },
                borderRadius: BorderRadius.circular(25),
                child: SizedBox(
                  width: Responsive.w(50),
                  height: Responsive.h(50),
                  child: Stack(
                    children: [
                      Container(
                        width: Responsive.w(50),
                        height: Responsive.h(50),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFACC15), // Yellow color from design
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.black, width: Responsive.w(1.5)),
                        ),
                        child: const Center(
                          child: Text(
                            'A',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppColors.black,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          width: Responsive.w(18),
                          height: Responsive.h(18),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.white, width: Responsive.w(1.5)),
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.settings,
                              size: 10,
                              color: AppColors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(width: Responsive.w(12)),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText.body(
                  'Good Morning,',
                  color: AppColors.grayFont,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
                CustomText.header(
                  'Alex',
                  fontSize: 18,
                ),
              ],
            ),
          ],
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const NotificationsScreen()),
            );
          },
          child: Container(
            width: Responsive.w(45),
            height: Responsive.h(45),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(
              Icons.notifications_outlined,
              color: AppColors.black,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildWalletCard(BuildContext context) {
    return BlocBuilder<WalletBloc, WalletState>(
      builder: (context, state) {
        final bool isFrozen = state is WalletLoaded ? state.isCardFrozen : false;
        final double balance = state is WalletLoaded ? state.balance : 12450.85;

        return Stack(
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(Responsive.w(20)),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: LinearGradient(
                  colors: isFrozen
                      ? [const Color(0xFF6B7280), const Color(0xFF374151)] // Greyed out color when frozen
                      : [AppColors.primaryGradientStart, AppColors.primaryGradientEnd],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: (isFrozen ? Colors.grey : AppColors.primaryGradientEnd).withValues(alpha: 0.3),
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
                      CustomText.body(
                        'Main Wallet Balance',
                        color: AppColors.white.withValues(alpha: 0.8),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: Responsive.w(8), vertical: Responsive.h(4)),
                        decoration: BoxDecoration(
                          color: AppColors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: CustomText.body(
                          isFrozen ? 'FROZEN' : 'PREMIUM',
                          color: AppColors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: Responsive.h(8)),
                  CustomText.header(
                    'Rs ${balance.toStringAsFixed(2)}',
                    color: AppColors.white,
                    fontSize: 30,
                  ),
                  SizedBox(height: Responsive.h(32)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText.body(
                            'CARD HOLDER',
                            color: AppColors.white.withValues(alpha: 0.7),
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                          ),
                          SizedBox(height: Responsive.h(4)),
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
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                          ),
                          SizedBox(height: Responsive.h(4)),
                          CustomText.title(
                            '08/28',
                            color: AppColors.white,
                            fontSize: 12,
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
            if (isFrozen)
              Positioned(
                right: 20,
                bottom: 20,
                child: Container(
                  padding: EdgeInsets.all(Responsive.w(8)),
                  decoration: const BoxDecoration(
                    color: Colors.white24,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.lock,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildSummaryCards(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Container(
            height: Responsive.h(160),
            padding: EdgeInsets.all(Responsive.w(16)),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Icon(Icons.account_balance_wallet, color: AppColors.successGreen, size: Responsive.w(16)),
                    SizedBox(width: Responsive.w(8)),
                    CustomText.body(
                      'Total Balance',
                      color: AppColors.grayFont,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ],
                ),
                const Spacer(),
                BlocBuilder<WalletBloc, WalletState>(
                  builder: (context, state) {
                    final double balance = state is WalletLoaded ? state.balance : 12450.85;
                    return CustomText.header(
                      'Rs ${balance.toStringAsFixed(2)}',
                      fontSize: 18,
                    );
                  },
                ),
                SizedBox(height: Responsive.h(4)),
                CustomText.body(
                  '+2.4% this month',
                  color: AppColors.successGreen,
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
                const Spacer(),
              ],
            ),
          ),
        ),
        SizedBox(width: Responsive.w(16)),
        Expanded(
          flex: 1,
          child: Column(
            children: [
              Container(
                height: Responsive.h(72),
                padding: EdgeInsets.all(Responsive.w(16)),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Icon(Icons.card_giftcard, color: AppColors.primaryGradientEnd, size: Responsive.w(16)),
                    SizedBox(width: Responsive.w(8)),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomText.body(
                          'Cashback',
                          color: AppColors.black,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                        SizedBox(height: Responsive.h(2)),
                        CustomText.title(
                          'Rs 142.50',
                          color: AppColors.primaryGradientEnd.withValues(alpha: 0.8),
                          fontSize: 12,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: Responsive.h(16)),
              Container(
                height: Responsive.h(72),
                padding: EdgeInsets.all(Responsive.w(16)),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Icon(Icons.stars, color: AppColors.orangeReward, size: Responsive.w(16)),
                    SizedBox(width: Responsive.w(8)),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomText.body(
                          'Reward Coins',
                          color: AppColors.black,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                        SizedBox(height: Responsive.h(2)),
                        CustomText.title(
                          '2,840',
                          color: AppColors.orangeReward,
                          fontSize: 12,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText.header(
          'Quick Actions',
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        SizedBox(height: Responsive.h(16)),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildActionItem(
              icon: Icons.add,
              label: 'Add',
              backgroundColor: AppColors.primaryGradientStart,
              iconColor: AppColors.white,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AddMoneyScreen()),
                );
              },
            ),
            _buildActionItem(
              icon: Icons.send,
              label: 'Transfer',
              backgroundColor: Theme.of(context).cardColor,
              iconColor: AppColors.primaryGradientStart,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const TransferHomeScreen()),
                );
              },
            ),
            _buildActionItem(
              icon: Icons.account_balance,
              label: 'Withdraw',
              backgroundColor: Theme.of(context).cardColor,
              iconColor: AppColors.primaryGradientStart,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const WithdrawScreen()),
                );
              },
            ),
            _buildActionItem(
              icon: Icons.receipt_long,
              label: 'Bills',
              backgroundColor: Theme.of(context).cardColor,
              iconColor: AppColors.primaryGradientStart,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const BillsDashboardScreen()),
                );
              },
            ),
            _buildActionItem(
              icon: Icons.ac_unit,
              label: 'Freeze',
              backgroundColor: AppColors.tintRed,
              iconColor: AppColors.errorRed,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CardDetailsScreen()),
                );
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionItem({
    required IconData icon,
    required String label,
    required Color backgroundColor,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: Responsive.w(50),
            height: Responsive.h(50),
            decoration: BoxDecoration(
              color: backgroundColor,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(icon, color: iconColor, size: Responsive.w(20)),
          ),
          SizedBox(height: Responsive.h(8)),
          CustomText.body(
            label,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ],
      ),
    );
  }

  Widget _buildPromoBanner(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(Responsive.w(16)),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark ? Theme.of(context).cardColor : AppColors.promoGray,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: AppColors.primary, size: Responsive.w(24)),
          SizedBox(width: Responsive.w(12)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText.title('Special Offer Available!', fontSize: 13),
                SizedBox(height: Responsive.h(2)),
                CustomText.body(
                  'Get up to Rs 500 cashback on mobile recharges today.',
                  color: AppColors.grayFont,
                  fontSize: 11,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentTransactions(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomText.title(
              'Recent Wallet Transactions',
              fontSize: 14,
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HistoryScreen()),
                );
              },
              child: CustomText.title(
                'View All',
                color: AppColors.primaryGradientStart,
                fontSize: 12,
              ),
            ),
          ],
        ),
        SizedBox(height: Responsive.h(16)),
        BlocBuilder<TransactionBloc, TransactionState>(
          builder: (context, state) {
            final transactions = state is TransactionLoaded ? state.allTransactions : <Map<String, dynamic>>[];
            final displayList = transactions.take(3).toList();
            if (displayList.isEmpty) {
              return Padding(
                padding: EdgeInsets.symmetric(vertical: Responsive.h(20.0)),
                child: CustomText.body('No recent transactions', color: AppColors.grayFont),
              );
            }
            return Column(
              children: List.generate(displayList.length, (index) {
                final tx = displayList[index];
                final hasIcon = tx['icon'] != null;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TransactionDetailsScreen(transaction: tx),
                        ),
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.all(Responsive.w(12)),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: Responsive.w(48),
                            height: Responsive.h(48),
                            decoration: BoxDecoration(
                              color: tx['iconBackground'] ?? const Color(0xFFF3F4F6),
                              shape: BoxShape.circle,
                            ),
                            child: hasIcon
                                ? Icon(tx['icon'] as IconData, color: tx['iconColor'] as Color, size: Responsive.w(22))
                                : Center(
                                    child: CustomText.title(
                                      tx['initialText'] ?? 'T',
                                      color: tx['iconColor'] ?? AppColors.grayFont,
                                    ),
                                  ),
                          ),
                          SizedBox(width: Responsive.w(12)),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomText.title(
                                  tx['title'] as String,
                                  fontSize: 14,
                                ),
                                SizedBox(height: Responsive.h(2)),
                                CustomText.subtitle(
                                  tx['type'] as String,
                                  fontSize: 11,
                                ),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              CustomText.amount(
                                (tx['isPositive'] ? '+ ' : '- ') + (tx['amount'] as String),
                                isPositive: tx['isPositive'] as bool,
                                fontSize: 13.5,
                              ),
                              SizedBox(height: Responsive.h(2)),
                              CustomText.subtitle(
                                tx['time'] as String,
                                fontSize: 10,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            );
          },
        ),
      ],
    );
  }
}
