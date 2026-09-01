// ignore_for_file: unused_local_variable
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paynow/bloc/wallet/wallet_bloc.dart';
import 'package:paynow/bloc/wallet/wallet_state.dart';
import 'package:paynow/screen/onboarding/link_bank_screen.dart';
import 'package:paynow/screen/payment/rewards/rewards_home_screen.dart';
import 'package:paynow/screen/payment/wallet/add_money_screen.dart';
import 'package:paynow/screen/payment/wallet/withdraw_screen.dart';
import 'package:paynow/utils/app_colors.dart';
import 'package:paynow/utils/responsive_helper.dart';
import 'package:paynow/widget/bank_balance_tile.dart';
import 'package:paynow/widget/custom_text.dart';
import 'package:paynow/widget/wallet_summary_card.dart';

class WalletBalanceScreen extends StatelessWidget {
  const WalletBalanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
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
              // Header title
              Padding(
                padding: EdgeInsets.symmetric(vertical: Responsive.h(8.0)),
                child: CustomText.header('Accounts & Balance', fontSize: 22),
                
              ),
              SizedBox(height: Responsive.h(16)),
              
              // PayNow Wallet Summary Card
              BlocBuilder<WalletBloc, WalletState>(
                builder: (context, state) {
                  final double balance = state is WalletLoaded ? state.balance : 12450.85;
                  return WalletSummaryCard(
                    balance: 'Rs ${balance.toStringAsFixed(2)}',
                    onAddMoney: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const AddMoneyScreen()),
                      );
                    },
                    onWithdraw: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const WithdrawScreen()),
                      );
                    },
                  );
                },
              ),
              SizedBox(height: Responsive.h(24)),
              
              // Linked Banks Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText.header('Linked Bank Accounts', fontSize: 16, color: AppColors.grayFont),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LinkBankScreen(isFromOnboarding: false),
                        ),
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: Responsive.w(8), vertical: Responsive.h(4)),
                      color: Colors.transparent,
                      child: CustomText.body('+ Add Bank', color: AppColors.primary, fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              SizedBox(height: Responsive.h(12)),
              BlocBuilder<WalletBloc, WalletState>(
                builder: (context, state) {
                  final linkedBanks = state is WalletLoaded ? state.linkedBanks : <Map<String, dynamic>>[];
                  if (linkedBanks.isEmpty) {
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: Responsive.h(8.0)),
                      child: CustomText.body('No linked bank accounts', color: AppColors.grayFont),
                    );
                  }
                  return ListView.separated(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: linkedBanks.length,
                    separatorBuilder: (context, index) => SizedBox(height: Responsive.h(12)),
                    itemBuilder: (context, index) {
                      final bank = linkedBanks[index];
                      return BankBalanceTile(
                        bankName: bank['bankName'] as String,
                        accountNumber: bank['accountNumber'] as String,
                        icon: bank['icon'] as IconData,
                        mockBalance: bank['mockBalance'] as String,
                      );
                    },
                  );
                },
              ),
              SizedBox(height: Responsive.h(24)),
              
              // Other Accounts / Instruments
              CustomText.header('Other Instruments', fontSize: 16, color: AppColors.grayFont),
              SizedBox(height: Responsive.h(12)),
              const BankBalanceTile(
                bankName: 'PayNow Gift Card',
                accountNumber: 'Ending in •••• 9238',
                icon: Icons.card_giftcard,
                mockBalance: 'Rs 500.00',
              ),
              SizedBox(height: Responsive.h(12)),
              
              // Reward Coins Tile
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const RewardsHomeScreen()),
                  );
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: Responsive.w(16), vertical: Responsive.h(16)),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: Responsive.w(44),
                        height: Responsive.h(44),
                        decoration: const BoxDecoration(
                          color: Color(0xFFFEF3C7), // Amber background tint
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.stars,
                          color: AppColors.orangeReward,
                          size: 22,
                        ),
                      ),
                      SizedBox(width: Responsive.w(12)),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText.title('Reward Coins', fontSize: 14),
                            SizedBox(height: Responsive.h(2)),
                            CustomText.subtitle('Redeemable on purchases', fontSize: 12),
                          ],
                        ),
                      ),
                      CustomText.title(
                        '2,840 Coins',
                        color: AppColors.orangeReward,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: Responsive.h(24)),
              
              // Wallet Settings list
              CustomText.header('Payment Settings', fontSize: 16, color: AppColors.grayFont),
              SizedBox(height: Responsive.h(12)),
              _buildSettingItem(
                context,
                icon: Icons.sync_outlined,
                title: 'Manage Auto-Topup',
                subtitle: 'Automatically top up wallet when balance is low',
              ),
              SizedBox(height: Responsive.h(12)),
              _buildSettingItem(
                context,
                icon: Icons.help_outline,
                title: 'Help & Support',
                subtitle: 'View FAQs and contact support regarding disputes',
              ),
              SizedBox(height: Responsive.h(80)), // Padding to scroll past Bottom Bar notch
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      padding: EdgeInsets.all(Responsive.w(16)),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: AppColors.grayFont,
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
    );
  }
}
