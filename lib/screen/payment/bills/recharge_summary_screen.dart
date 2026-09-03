// ignore_for_file: unused_local_variable
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paynow/bloc/payment/payment_bloc.dart';
import 'package:paynow/bloc/payment/payment_event.dart';
import 'package:paynow/bloc/transaction/transaction_bloc.dart';
import 'package:paynow/bloc/transaction/transaction_event.dart';
import 'package:paynow/bloc/wallet/wallet_bloc.dart';
import 'package:paynow/bloc/wallet/wallet_event.dart';
import 'package:paynow/constants/route_constants.dart';
import 'package:paynow/utils/app_colors.dart';
import 'package:paynow/utils/responsive_helper.dart';
import 'package:paynow/widget/custom_text.dart';

class RechargeSummaryScreen extends StatelessWidget {
  final String recipient;
  final String operatorName;
  final String planDetails;
  final double price;

  const RechargeSummaryScreen({
    super.key,
    required this.recipient,
    required this.operatorName,
    required this.planDetails,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    const double fee = 2.00;
    const double discount = 0.00;
    final double total = price + fee - discount;

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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText.header('Recharge Summary', fontSize: 18),
                      SizedBox(height: Responsive.h(2)),
                      CustomText.body(
                        'Review your selection before payment',
                        color: AppColors.grayFont,
                        fontSize: 11,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                padding: EdgeInsets.symmetric(horizontal: Responsive.w(20.0)),
                child: Column(
                  children: [
                    SizedBox(height: Responsive.h(16)),
                    
                    // Recipient detail block
                    Container(
                      padding: EdgeInsets.all(Responsive.w(16)),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(Responsive.w(10)),
                            decoration: const BoxDecoration(
                              color: AppColors.tintBlue,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.phone_android,
                              color: AppColors.primary,
                              size: 22,
                            ),
                          ),
                          SizedBox(width: Responsive.w(12)),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomText.body(
                                  recipient.contains('AC') ? 'ACCOUNT NUMBER' : 'MOBILE NUMBER',
                                  color: AppColors.grayFont,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                                SizedBox(height: Responsive.h(4)),
                                CustomText.title(recipient, fontSize: 15),
                                SizedBox(height: Responsive.h(2)),
                                CustomText.subtitle(operatorName, fontSize: 12),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: Responsive.h(16)),
                    
                    // Selected Plan Card
                    Container(
                      padding: EdgeInsets.all(Responsive.w(16)),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CustomText.title('Selected Plan', fontSize: 14),
                              GestureDetector(
                                onTap: () => Navigator.pop(context),
                                child: CustomText.title(
                                  'Change Plan',
                                  color: AppColors.primary,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: Responsive.h(16)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildSummarySpecTile(label: 'DATA LIMIT', value: '1.5 GB / Day'),
                              _buildSummarySpecTile(label: 'VALIDITY', value: '28 Days'),
                            ],
                          ),
                          SizedBox(height: Responsive.h(12)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildSummarySpecTile(label: 'VOICE CALLS', value: 'Unlimited'),
                              _buildSummarySpecTile(label: 'SMS LIMIT', value: '100 / Day'),
                            ],
                          ),
                          SizedBox(height: Responsive.h(12)),
                          Divider(color: Colors.grey.withValues(alpha: 0.1), height: Responsive.h(1)),
                          SizedBox(height: Responsive.h(12)),
                          CustomText.body(
                            'Includes Free Disney+ Hotstar Subscription for 3 months.',
                            color: AppColors.grayFont,
                            fontSize: 11,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: Responsive.h(16)),
                    
                    // Invoice Calculator Card
                    Container(
                      padding: EdgeInsets.all(Responsive.w(16)),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText.title('Price Details', fontSize: 14),
                          SizedBox(height: Responsive.h(16)),
                          _buildInvoicePriceRow('Plan Price', 'Rs ${price.toStringAsFixed(2)}'),
                          SizedBox(height: Responsive.h(12)),
                          _buildInvoicePriceRow('Processing Fee', 'Rs ${fee.toStringAsFixed(2)}'),
                          SizedBox(height: Responsive.h(12)),
                          _buildInvoicePriceRow('Promo Discount', '-Rs ${discount.toStringAsFixed(2)}', isDiscount: true),
                          SizedBox(height: Responsive.h(16)),
                          Divider(color: Colors.grey.withValues(alpha: 0.1), height: Responsive.h(1)),
                          SizedBox(height: Responsive.h(16)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CustomText.header('Total Payable', fontSize: 15),
                              CustomText.header('Rs ${total.toStringAsFixed(2)}', fontSize: 18, color: AppColors.primary),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: Responsive.h(40)),
                  ],
                ),
              ),
            ),
            
            // Bottom Action Continue button
            Padding(
              padding: EdgeInsets.all(Responsive.w(20.0)),
              child: SizedBox(
                width: double.infinity,
                height: Responsive.h(54),
                child: ElevatedButton(
                   onPressed: () {
                    // Record transaction & deduct wallet balance via BLoC
                    context.read<WalletBloc>().add(DeductWalletBalanceEvent(total));
                    context.read<TransactionBloc>().add(AddTransactionEvent(
                          title: '$operatorName Bill Payment',
                          amountVal: total,
                          type: 'Bill Payment',
                          isPositive: false,
                          isSuccess: true,
                          icon: Icons.receipt_long,
                          iconBackground: AppColors.tintBlue,
                          iconColor: AppColors.primary,
                        ));
                    context.read<PaymentBloc>().add(ProcessBillPaymentEvent(
                          recipient: recipient,
                          operatorName: operatorName,
                          planDetails: planDetails,
                          price: total,
                        ));

                    Navigator.pushNamed(
                      context,
                      RouteConstants.rechargeSuccess,
                      arguments: {
                        'amount': 'Rs ${total.toStringAsFixed(2)}',
                        'recipientNumber': recipient,
                      },
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: CustomText.title(
                    'Continue to Pay',
                    color: AppColors.white,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummarySpecTile({required String label, required String value}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText.body(
          label,
          color: AppColors.grayFont,
          fontSize: 9,
          fontWeight: FontWeight.bold,
        ),
        SizedBox(height: Responsive.h(2)),
        CustomText.title(
          value,
          fontSize: 13,
        ),
      ],
    );
  }

  Widget _buildInvoicePriceRow(String label, String value, {bool isDiscount = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomText.body(label, fontSize: 12, color: AppColors.grayFont),
        CustomText.body(
          value,
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: isDiscount ? AppColors.successGreen : AppColors.black,
        ),
      ],
    );
  }
}
