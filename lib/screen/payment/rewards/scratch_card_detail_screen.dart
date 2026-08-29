// ignore_for_file: unused_local_variable
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paynow/bloc/payment/payment_bloc.dart';
import 'package:paynow/bloc/payment/payment_event.dart';
import 'package:paynow/bloc/transaction/transaction_bloc.dart';
import 'package:paynow/bloc/transaction/transaction_event.dart';
import 'package:paynow/bloc/wallet/wallet_bloc.dart';
import 'package:paynow/bloc/wallet/wallet_event.dart';
import 'package:paynow/utils/app_colors.dart';
import 'package:paynow/utils/responsive_helper.dart';
import 'package:paynow/widget/custom_text.dart';
import 'package:paynow/widget/scratch_card_widget.dart';

class ScratchCardDetailScreen extends StatefulWidget {
  final String amount;
  final String type;
  final String subtitle;

  const ScratchCardDetailScreen({
    super.key,
    required this.amount,
    required this.type,
    required this.subtitle,
  });

  @override
  State<ScratchCardDetailScreen> createState() => _ScratchCardDetailScreenState();
}

class _ScratchCardDetailScreenState extends State<ScratchCardDetailScreen> {
  bool _revealed = false;

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
                      child: Icon(Icons.arrow_back, color: Theme.of(context).colorScheme.onSurface,
                        size: 24,
                      ),
                    ),
                  ),
                  SizedBox(width: Responsive.w(8)),
                  CustomText.header('Scratch & Win', fontSize: 20),
                ],
              ),
            ),
            
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: Responsive.w(24.0)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomText.body(
                      'LIMITED TIME REWARD',
                      color: AppColors.primary,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                    SizedBox(height: Responsive.h(12)),
                    CustomText.header(
                      'Unlock Your Bonus',
                      fontSize: 24,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: Responsive.h(8)),
                    CustomText.subtitle(
                      'A hidden treasure from PayNow is under this card.',
                      fontSize: 14,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: Responsive.h(40)),
                    
                    // Scratch Card Widget
                    ScratchCardWidget(
                      rewardAmount: widget.amount,
                      rewardType: widget.type,
                      rewardSubtitle: widget.subtitle,
                      onRevealed: () {
                        setState(() {
                          _revealed = true;
                        });

                        // If it's a cashback card, add to Wallet balance and history
                        if (widget.type.toLowerCase().contains('cashback')) {
                          final double amountVal = double.tryParse(widget.amount.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0.0;
                          context.read<WalletBloc>().add(CreditWalletBalanceEvent(amountVal));
                          context.read<TransactionBloc>().add(AddTransactionEvent(
                                title: 'Scratch Card Cashback',
                                amountVal: amountVal,
                                type: 'Cashback',
                                isPositive: true,
                                isSuccess: true,
                                icon: Icons.stars,
                                iconBackground: AppColors.tintPurple,
                                iconColor: AppColors.primary,
                              ));
                          context.read<PaymentBloc>().add(ClaimScratchCardEvent(
                                amount: widget.amount,
                                type: widget.type,
                                subtitle: widget.subtitle,
                              ));
                        }
                      },
                    ),
                    
                    SizedBox(height: Responsive.h(40)),
                    
                    // Helper Text/Icon at bottom
                    AnimatedCrossFade(
                      firstChild: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.gesture_outlined,
                            color: AppColors.grayFont,
                            size: 20,
                          ),
                          SizedBox(width: Responsive.w(8)),
                          Flexible(
                            child: CustomText.subtitle(
                              'Swipe to scratch and reveal your reward',
                              fontSize: 13,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                      secondChild: Column(
                        children: [
                          CustomText.title(
                            'Reward Claimed Successfully!',
                            color: AppColors.successGreen,
                            fontSize: 14,
                          ),
                          SizedBox(height: Responsive.h(16)),
                          SizedBox(
                            width: Responsive.w(160),
                            height: Responsive.h(45),
                            child: ElevatedButton(
                              onPressed: () => Navigator.pop(context),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 0,
                              ),
                              child: CustomText.title(
                                'Done',
                                color: AppColors.white,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                      crossFadeState: _revealed
                          ? CrossFadeState.showSecond
                          : CrossFadeState.showFirst,
                      duration: const Duration(milliseconds: 300),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
