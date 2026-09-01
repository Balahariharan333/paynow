// ignore_for_file: unused_local_variable
import 'package:flutter/material.dart';
import 'package:paynow/utils/responsive_helper.dart';
import 'package:paynow/utils/app_colors.dart';
import 'package:paynow/widget/custom_text.dart';
import 'package:paynow/screen/payment/rewards/scratch_card_detail_screen.dart';

class ActiveScratchCardsScreen extends StatelessWidget {
  const ActiveScratchCardsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    // 6 Mock cards
    final List<Map<String, String>> cards = [
      {'amount': 'Rs 100', 'type': 'Cashback', 'sub': 'Added to your PayNow Wallet'},
      {'amount': 'Rs 50', 'type': 'Merchant Coupon', 'sub': 'Redeemable at Brew & Co.'},
      {'amount': 'Rs 500', 'type': 'Jackpot Reward', 'sub': 'Mega bonus won!'},
      {'amount': 'Rs 20', 'type': 'Cashback', 'sub': 'Added to your PayNow Wallet'},
      {'amount': 'Rs 250', 'type': 'Travel Voucher', 'sub': 'Redeemable on flights'},
      {'amount': 'Rs 15', 'type': 'Cashback', 'sub': 'Added to your PayNow Wallet'},
    ];

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                      child: Icon(Icons.arrow_back, color: Theme.of(context).colorScheme.onSurface,
                        size: 24,
                      ),
                    ),
                  ),
                  SizedBox(width: Responsive.w(8)),
                  CustomText.header('Active Scratch Cards', fontSize: 20),
                ],
              ),
            ),
            
            // Grid List
            Expanded(
              child: GridView.builder(
                physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                padding: EdgeInsets.all(Responsive.w(20.0)),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: MediaQuery.of(context).size.width >= 500 ? 3 : 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.85,
                ),
                itemCount: cards.length,
                itemBuilder: (context, index) {
                  final card = cards[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ScratchCardDetailScreen(
                            amount: card['amount']!,
                            type: card['type']!,
                            subtitle: card['sub']!,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.black.withValues(alpha: 0.02),
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: Responsive.w(60),
                            height: Responsive.h(60),
                            decoration: BoxDecoration(
                              color: AppColors.tintPurple,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.stars,
                              color: AppColors.primary,
                              size: 28,
                            ),
                          ),
                          SizedBox(height: Responsive.h(16)),
                          CustomText.title('Mystery Reward', fontSize: 13),
                          SizedBox(height: Responsive.h(4)),
                          CustomText.subtitle('Tap to scratch', fontSize: 11),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}


